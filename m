From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 06/15] IB/srp: Maintain a single connection per I_T nexus
Date: Fri, 28 Jun 2013 14:51:26 +0200
Message-ID: <51CD86CE.8080804@acm.org>
References: <51CD856A.3010102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD856A.3010102-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

An SRP target is required to maintain a single connection between
initiator and target. This means that if the 'add_target' attribute
is used to create a second connection to a target that the first
connection will be logged out and that the SCSI error handler will
kick in. The SCSI error handler will cause the SRP initiator to
reconnect, which will cause I/O over the second connection to fail.
Avoid such ping-pong behavior by disabling relogins. Note: if
reconnecting manually is necessary, that is possible by deleting
and recreating an rport via sysfs.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Signed-off-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   44 +++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 01212c9..4eba1f7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -542,11 +542,11 @@ static void srp_remove_work(struct work_struct *work)
 
 	WARN_ON_ONCE(target->state != SRP_TARGET_REMOVED);
 
+	srp_remove_target(target);
+
 	spin_lock(&target->srp_host->target_lock);
 	list_del(&target->list);
 	spin_unlock(&target->srp_host->target_lock);
-
-	srp_remove_target(target);
 }
 
 static void srp_rport_delete(struct srp_rport *rport)
@@ -2010,6 +2010,36 @@ static struct class srp_class = {
 	.dev_release = srp_release_dev
 };
 
+/**
+ * srp_conn_unique() - check whether the connection to a target is unique
+ */
+static bool srp_conn_unique(struct srp_host *host,
+			    struct srp_target_port *target)
+{
+	struct srp_target_port *t;
+	bool ret = false;
+
+	if (target->state == SRP_TARGET_REMOVED)
+		goto out;
+
+	ret = true;
+
+	spin_lock(&host->target_lock);
+	list_for_each_entry(t, &host->target_list, list) {
+		if (t != target &&
+		    target->id_ext == t->id_ext &&
+		    target->ioc_guid == t->ioc_guid &&
+		    target->initiator_ext == t->initiator_ext) {
+			ret = false;
+			break;
+		}
+	}
+	spin_unlock(&host->target_lock);
+
+out:
+	return ret;
+}
+
 /*
  * Target ports are added by writing
  *
@@ -2266,6 +2296,16 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err;
 
+	if (!srp_conn_unique(target->srp_host, target)) {
+		shost_printk(KERN_INFO, target->scsi_host,
+			     PFX "Already connected to target port with id_ext=%016llx;ioc_guid=%016llx;initiator_ext=%016llx\n",
+			     be64_to_cpu(target->id_ext),
+			     be64_to_cpu(target->ioc_guid),
+			     be64_to_cpu(target->initiator_ext));
+		ret = -EEXIST;
+		goto err;
+	}
+
 	if (!host->srp_dev->fmr_pool && !target->allow_ext_sg &&
 				target->cmd_sg_cnt < target->sg_tablesize) {
 		pr_warn("No FMR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
