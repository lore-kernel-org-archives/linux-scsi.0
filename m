From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 06/10] scsi_transport_srp: Add periodic reconnect support
Date: Thu, 10 Oct 2013 14:15:49 +0200
Message-ID: <52569A75.30200@acm.org>
References: <52569806.9080201@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52569806.9080201-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Add support for periodically reconnecting to an SRP target until
the dev_loss timer expires. After the tenth reconnection attempt,
gradually slow down subsequent reconnect attempts.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/scsi/scsi_transport_srp.c | 106 +++++++++++++++++++++++++++++++++++---
 include/scsi/scsi_transport_srp.h |  11 +++-
 2 files changed, 108 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 675e203..04a97b6 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -41,7 +41,7 @@ struct srp_host_attrs {
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
 #define SRP_HOST_ATTRS 0
-#define SRP_RPORT_ATTRS 6
+#define SRP_RPORT_ATTRS 8
 
 struct srp_internal {
 	struct scsi_transport_template t;
@@ -69,11 +69,13 @@ static inline struct Scsi_Host *rport_to_shost(struct srp_rport *r)
  * are finished in a reasonable time. Hence do not allow the fast I/O fail
  * timeout to exceed SCSI_DEVICE_BLOCK_MAX_TIMEOUT. Furthermore, these
  * parameters must be such that multipath can detect failed paths timely.
- * Hence do not allow both parameters to be disabled simultaneously.
+ * Hence do not allow all three parameters to be disabled simultaneously.
  */
-int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
+int srp_tmo_valid(int reconnect_delay, int fast_io_fail_tmo, int dev_loss_tmo)
 {
-	if (fast_io_fail_tmo < 0 && dev_loss_tmo < 0)
+	if (reconnect_delay < 0 && fast_io_fail_tmo < 0 && dev_loss_tmo < 0)
+		return -EINVAL;
+	if (reconnect_delay == 0)
 		return -EINVAL;
 	if (fast_io_fail_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
 		return -EINVAL;
@@ -202,6 +204,56 @@ static int srp_parse_tmo(int *tmo, const char *buf)
 	return res;
 }
 
+static ssize_t show_reconnect_delay(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+
+	return srp_show_tmo(buf, rport->reconnect_delay);
+}
+
+static ssize_t store_reconnect_delay(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, const size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	int res, delay;
+
+	res = srp_parse_tmo(&delay, buf);
+	if (res)
+		goto out;
+	res = srp_tmo_valid(delay, rport->fast_io_fail_tmo,
+			    rport->dev_loss_tmo);
+	if (res)
+		goto out;
+
+	if (rport->reconnect_delay <= 0 && delay > 0 &&
+	    rport->state != SRP_RPORT_RUNNING) {
+		queue_delayed_work(system_long_wq, &rport->reconnect_work,
+				   delay * HZ);
+	} else if (delay <= 0) {
+		cancel_delayed_work(&rport->reconnect_work);
+	}
+	rport->reconnect_delay = delay;
+	res = count;
+
+out:
+	return res;
+}
+
+static DEVICE_ATTR(reconnect_delay, S_IRUGO | S_IWUSR, show_reconnect_delay,
+		   store_reconnect_delay);
+
+static ssize_t show_failed_reconnects(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+
+	return sprintf(buf, "%d\n", rport->failed_reconnects);
+}
+
+static DEVICE_ATTR(failed_reconnects, S_IRUGO, show_failed_reconnects, NULL);
+
 static ssize_t show_srp_rport_fast_io_fail_tmo(struct device *dev,
 					       struct device_attribute *attr,
 					       char *buf)
@@ -222,7 +274,8 @@ static ssize_t store_srp_rport_fast_io_fail_tmo(struct device *dev,
 	res = srp_parse_tmo(&fast_io_fail_tmo, buf);
 	if (res)
 		goto out;
-	res = srp_tmo_valid(fast_io_fail_tmo, rport->dev_loss_tmo);
+	res = srp_tmo_valid(rport->reconnect_delay, fast_io_fail_tmo,
+			    rport->dev_loss_tmo);
 	if (res)
 		goto out;
 	rport->fast_io_fail_tmo = fast_io_fail_tmo;
@@ -256,7 +309,8 @@ static ssize_t store_srp_rport_dev_loss_tmo(struct device *dev,
 	res = srp_parse_tmo(&dev_loss_tmo, buf);
 	if (res)
 		goto out;
-	res = srp_tmo_valid(rport->fast_io_fail_tmo, dev_loss_tmo);
+	res = srp_tmo_valid(rport->reconnect_delay, rport->fast_io_fail_tmo,
+			    dev_loss_tmo);
 	if (res)
 		goto out;
 	rport->dev_loss_tmo = dev_loss_tmo;
@@ -312,6 +366,29 @@ invalid:
 	return -EINVAL;
 }
 
+/**
+ * srp_reconnect_work() - reconnect and schedule a new attempt if necessary
+ */
+static void srp_reconnect_work(struct work_struct *work)
+{
+	struct srp_rport *rport = container_of(to_delayed_work(work),
+					struct srp_rport, reconnect_work);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	int delay, res;
+
+	res = srp_reconnect_rport(rport);
+	if (res != 0) {
+		shost_printk(KERN_ERR, shost,
+			     "reconnect attempt %d failed (%d)\n",
+			     ++rport->failed_reconnects, res);
+		delay = rport->reconnect_delay *
+			min(100, max(1, rport->failed_reconnects - 10));
+		if (delay > 0)
+			queue_delayed_work(system_long_wq,
+					   &rport->reconnect_work, delay * HZ);
+	}
+}
+
 static void __rport_fail_io_fast(struct srp_rport *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
@@ -370,16 +447,21 @@ static void rport_dev_loss_timedout(struct work_struct *work)
 static void __srp_start_tl_fail_timers(struct srp_rport *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
-	int fast_io_fail_tmo, dev_loss_tmo;
+	int delay, fast_io_fail_tmo, dev_loss_tmo;
 
 	lockdep_assert_held(&rport->mutex);
 
 	if (!rport->deleted) {
+		delay = rport->reconnect_delay;
 		fast_io_fail_tmo = rport->fast_io_fail_tmo;
 		dev_loss_tmo = rport->dev_loss_tmo;
 		pr_debug("%s current state: %d\n",
 			 dev_name(&shost->shost_gendev), rport->state);
 
+		if (delay > 0)
+			queue_delayed_work(system_long_wq,
+					   &rport->reconnect_work,
+					   1UL * delay * HZ);
 		if (fast_io_fail_tmo >= 0 &&
 		    srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0) {
 			pr_debug("%s new state: %d\n",
@@ -480,6 +562,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 		cancel_delayed_work(&rport->fast_io_fail_work);
 		cancel_delayed_work(&rport->dev_loss_work);
 
+		rport->failed_reconnects = 0;
 		srp_rport_set_state(rport, SRP_RPORT_RUNNING);
 		scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
 		/*
@@ -538,6 +621,7 @@ static void srp_rport_release(struct device *dev)
 {
 	struct srp_rport *rport = dev_to_rport(dev);
 
+	cancel_delayed_work_sync(&rport->reconnect_work);
 	cancel_delayed_work_sync(&rport->fast_io_fail_work);
 	cancel_delayed_work_sync(&rport->dev_loss_work);
 
@@ -634,6 +718,10 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 	memcpy(rport->port_id, ids->port_id, sizeof(rport->port_id));
 	rport->roles = ids->roles;
 
+	if (i->f->reconnect)
+		rport->reconnect_delay = i->f->reconnect_delay ?
+			*i->f->reconnect_delay : 10;
+	INIT_DELAYED_WORK(&rport->reconnect_work, srp_reconnect_work);
 	rport->fast_io_fail_tmo = i->f->fast_io_fail_tmo ?
 		*i->f->fast_io_fail_tmo : 15;
 	rport->dev_loss_tmo = i->f->dev_loss_tmo ? *i->f->dev_loss_tmo : 60;
@@ -772,6 +860,10 @@ srp_attach_transport(struct srp_function_template *ft)
 		i->rport_attrs[count++] = &dev_attr_fast_io_fail_tmo;
 		i->rport_attrs[count++] = &dev_attr_dev_loss_tmo;
 	}
+	if (ft->reconnect) {
+		i->rport_attrs[count++] = &dev_attr_reconnect_delay;
+		i->rport_attrs[count++] = &dev_attr_failed_reconnects;
+	}
 	if (ft->rport_delete)
 		i->rport_attrs[count++] = &dev_attr_delete;
 	i->rport_attrs[count++] = NULL;
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index ee70016..4ebf691 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -31,7 +31,8 @@ enum srp_rport_state {
 /**
  * struct srp_rport
  * @lld_data: LLD private data.
- * @mutex:    Protects against concurrent rport fast_io_fail / dev_loss_tmo.
+ * @mutex:    Protects against concurrent rport reconnect / fast_io_fail /
+ *   dev_loss_tmo activity.
  */
 struct srp_rport {
 	/* for initiator and target drivers */
@@ -48,6 +49,9 @@ struct srp_rport {
 	struct mutex		mutex;
 	enum srp_rport_state	state;
 	bool			deleted;
+	int			reconnect_delay;
+	int			failed_reconnects;
+	struct delayed_work	reconnect_work;
 	int			fast_io_fail_tmo;
 	int			dev_loss_tmo;
 	struct delayed_work	fast_io_fail_work;
@@ -60,6 +64,7 @@ struct srp_rport {
  *     dev_loss_tmo sysfs attribute for an rport.
  * @reset_timer_if_blocked: Whether or srp_timed_out() should reset the command
  *     timer if the device on which it has been queued is blocked.
+ * @reconnect_delay: If not NULL, points to the default reconnect_delay value.
  * @fast_io_fail_tmo: If not NULL, points to the default fast_io_fail_tmo value.
  * @dev_loss_tmo: If not NULL, points to the default dev_loss_tmo value.
  * @reconnect: Callback function for reconnecting to the target. See also
@@ -71,6 +76,7 @@ struct srp_function_template {
 	/* for initiator drivers */
 	bool has_rport_state;
 	bool reset_timer_if_blocked;
+	int *reconnect_delay;
 	int *fast_io_fail_tmo;
 	int *dev_loss_tmo;
 	int (*reconnect)(struct srp_rport *rport);
@@ -90,7 +96,8 @@ extern void srp_rport_put(struct srp_rport *rport);
 extern struct srp_rport *srp_rport_add(struct Scsi_Host *,
 				       struct srp_rport_identifiers *);
 extern void srp_rport_del(struct srp_rport *);
-extern int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo);
+extern int srp_tmo_valid(int reconnect_delay, int fast_io_fail_tmo,
+			 int dev_loss_tmo);
 extern int srp_reconnect_rport(struct srp_rport *rport);
 extern void srp_start_tl_fail_timers(struct srp_rport *rport);
 extern void srp_remove_host(struct Scsi_Host *);
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
