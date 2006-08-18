From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] FC transport: Add dev_loss_tmo callbacks, and new
	fast_io_fail_tmo w/ callback
Date: Fri, 18 Aug 2006 17:33:29 -0400
Message-ID: <1155936809.12933.10.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:20420 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750799AbWHRVd0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 17:33:26 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7ILXOZ4023697
	for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2006 14:33:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch adds the following functionality to the FC transport:

- dev_loss_tmo LLDD callback :
  Called to essentially confirm the deletion of an rport. Thus, it is
  called whenever the dev_loss_tmo fires, or when the rport is deleted
  due to other circumstances (module unload, etc).  It is expected that
  the callback will initiate the termination of any outstanding i/o on
  the rport.

- fast_io_fail_tmo and LLD callback:
  There are some cases where it may take a long while to truly determine
  device loss, but the system is in a multipathing configuration that if
  the i/o was failed quickly (faster than dev_loss_tmo), it could be
  redirected to a different path and completed sooner.

Many thanks to Mike Reed who cleaned up the initial RFC in support
of this post.

The original RFC is at:
http://marc.theaimsgroup.com/?l=linux-scsi&m=115505981027246&w=2

Note: This patch assumes 3 prior fc transport patches have been installed:
   http://marc.theaimsgroup.com/?l=linux-scsi&m=115555807316329&w=2
   http://marc.theaimsgroup.com/?l=linux-scsi&m=115581614930261&w=2
   http://marc.theaimsgroup.com/?l=linux-scsi&m=115593664816371&w=2

   Sorry - next time I'll do something like making these individual
   patches of the same posting when I know they'll be posted closely
   together.

-- james s


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2006-08-18 10:35:16.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2006-08-18 17:04:54.000000000 -0400
@@ -242,6 +242,7 @@ fc_bitfield_name_search(remote_port_role
 
 
 static void fc_timeout_deleted_rport(void *data);
+static void fc_timeout_fail_rport_io(void *data);
 static void fc_scsi_scan_rport(void *data);
 
 /*
@@ -249,7 +250,7 @@ static void fc_scsi_scan_rport(void *dat
  * Increase these values if you add attributes
  */
 #define FC_STARGET_NUM_ATTRS 	3
-#define FC_RPORT_NUM_ATTRS	9
+#define FC_RPORT_NUM_ATTRS	10
 #define FC_HOST_NUM_ATTRS	17
 
 struct fc_internal {
@@ -622,11 +623,14 @@ store_fc_rport_##field(struct class_devi
 	struct fc_rport *rport = transport_class_to_rport(cdev);	\
 	struct Scsi_Host *shost = rport_to_shost(rport);		\
 	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	char *cp;							\
 	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||		\
 	    (rport->port_state == FC_PORTSTATE_DELETED) ||		\
 	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))		\
 		return -EBUSY;						\
-	val = simple_strtoul(buf, NULL, 0);				\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
 	i->f->set_rport_##field(rport, val);				\
 	return count;							\
 }
@@ -708,6 +712,13 @@ static FC_CLASS_DEVICE_ATTR(rport, title
 	if (i->f->show_rport_##field)					\
 		count++
 
+#define SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(field)				\
+{									\
+	i->private_rport_attrs[count] = class_device_attr_rport_##field; \
+	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
+	count++;							\
+}
+
 
 /* The FC Transport Remote Port Attributes: */
 
@@ -740,12 +751,14 @@ store_fc_rport_dev_loss_tmo(struct class
 	struct fc_rport *rport = transport_class_to_rport(cdev);
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
+	char *cp;
 	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
 	    (rport->port_state == FC_PORTSTATE_DELETED) ||
 	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
 		return -EBUSY;
-	val = simple_strtoul(buf, NULL, 0);
-	if ((val < 0) || (val > SCSI_DEVICE_BLOCK_MAX_TIMEOUT))
+	val = simple_strtoul(buf, &cp, 0);
+	if ((*cp && (*cp != '\n')) ||
+	    (val < 0) || (val > SCSI_DEVICE_BLOCK_MAX_TIMEOUT))
 		return -EINVAL;
 	i->f->set_rport_dev_loss_tmo(rport, val);
 	return count;
@@ -795,6 +808,44 @@ static FC_CLASS_DEVICE_ATTR(rport, roles
 fc_private_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
 fc_private_rport_rd_attr(scsi_target_id, "%d\n", 20);
 
+/*
+ * fast_io_fail_tmo attribute
+ */
+static ssize_t
+show_fc_rport_fast_io_fail_tmo (struct class_device *cdev, char *buf)
+{
+	struct fc_rport *rport = transport_class_to_rport(cdev);
+
+	if (rport->fast_io_fail_tmo == -1)
+		return snprintf(buf, 5, "off\n");
+	return snprintf(buf, 20, "%d\n", rport->fast_io_fail_tmo);
+}
+
+static ssize_t
+store_fc_rport_fast_io_fail_tmo(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	int val;
+	char *cp;
+	struct fc_rport *rport = transport_class_to_rport(cdev);
+
+	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
+	    (rport->port_state == FC_PORTSTATE_DELETED) ||
+	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
+		return -EBUSY;
+	if (strncmp(buf, "off", 3) == 0)
+		rport->fast_io_fail_tmo = -1;
+	else {
+		val = simple_strtoul(buf, &cp, 0);
+		if ((*cp && (*cp != '\n')) ||
+		    (val < 0) || (val >= rport->dev_loss_tmo))
+			return -EINVAL;
+		rport->fast_io_fail_tmo = val;
+	}
+	return count;
+}
+static FC_CLASS_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
+	show_fc_rport_fast_io_fail_tmo, store_fc_rport_fast_io_fail_tmo);
 
 
 /*
@@ -880,8 +931,11 @@ store_fc_host_##field(struct class_devic
 	int val;							\
 	struct Scsi_Host *shost = transport_class_to_shost(cdev);	\
 	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	char *cp;							\
 									\
-	val = simple_strtoul(buf, NULL, 0);				\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
 	i->f->set_host_##field(shost, val);				\
 	return count;							\
 }
@@ -1481,6 +1535,8 @@ fc_attach_transport(struct fc_function_t
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
+	if (ft->terminate_rport_io)
+		SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
 
 	BUG_ON(count > FC_RPORT_NUM_ATTRS);
 
@@ -1552,7 +1608,7 @@ fc_flush_work(struct Scsi_Host *shost)
  * @delay:	jiffies to delay the work queuing
  *
  * Return value:
- * 	0 on success / != 0 for error
+ * 	1 on success / 0 already queued / < 0 for error
  **/
 static int
 fc_queue_devloss_work(struct Scsi_Host *shost, struct work_struct *work,
@@ -1567,6 +1623,9 @@ fc_queue_devloss_work(struct Scsi_Host *
 		return -EINVAL;
 	}
 
+	if (delay == 0)
+		return queue_work(fc_host_devloss_work_q(shost), work);
+
 	return queue_delayed_work(fc_host_devloss_work_q(shost), work, delay);
 }
 
@@ -1659,10 +1718,23 @@ fc_starget_delete(void *data)
 	struct fc_rport *rport = (struct fc_rport *)data;
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	unsigned long flags;
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+
+	/*
+	 * Involve the LLDD if possible. All io on the rport is to
+	 * be terminated, either as part of the dev_loss_tmo callback
+	 * processing, or via the terminate_rport_io function.
+	 */
+	if (i->f->dev_loss_tmo_callbk)
+		i->f->dev_loss_tmo_callbk(rport);
+	else if (i->f->terminate_rport_io)
+		i->f->terminate_rport_io(rport);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (rport->flags & FC_RPORT_DEVLOSS_PENDING) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
+		if (!cancel_delayed_work(&rport->fail_io_work))
+			fc_flush_devloss(shost);
 		if (!cancel_delayed_work(&rport->dev_loss_work))
 			fc_flush_devloss(shost);
 		spin_lock_irqsave(shost->host_lock, flags);
@@ -1685,10 +1757,7 @@ fc_rport_final_delete(void *data)
 	struct fc_rport *rport = (struct fc_rport *)data;
 	struct device *dev = &rport->dev;
 	struct Scsi_Host *shost = rport_to_shost(rport);
-
-	/* Delete SCSI target and sdevs */
-	if (rport->scsi_target_id != -1)
-		fc_starget_delete(data);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
 
 	/*
 	 * if a scan is pending, flush the SCSI Host work_q so that 
@@ -1697,6 +1766,14 @@ fc_rport_final_delete(void *data)
 	if (rport->flags & FC_RPORT_SCAN_PENDING)
 		scsi_flush_work(shost);
 
+	/* Delete SCSI target and sdevs */
+	if (rport->scsi_target_id != -1)
+		fc_starget_delete(data);
+	else if (i->f->dev_loss_tmo_callbk)
+		i->f->dev_loss_tmo_callbk(rport);
+	else if (i->f->terminate_rport_io)
+		i->f->terminate_rport_io(rport);
+
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
@@ -1748,8 +1825,10 @@ fc_rport_create(struct Scsi_Host *shost,
 	if (fci->f->dd_fcrport_size)
 		rport->dd_data = &rport[1];
 	rport->channel = channel;
+	rport->fast_io_fail_tmo = -1;
 
 	INIT_WORK(&rport->dev_loss_work, fc_timeout_deleted_rport, rport);
+	INIT_WORK(&rport->fail_io_work, fc_timeout_fail_rport_io, rport);
 	INIT_WORK(&rport->scan_work, fc_scsi_scan_rport, rport);
 	INIT_WORK(&rport->stgt_delete_work, fc_starget_delete, rport);
 	INIT_WORK(&rport->rport_delete_work, fc_rport_final_delete, rport);
@@ -1913,11 +1992,13 @@ fc_remote_port_add(struct Scsi_Host *sho
 				/* restart the target */
 
 				/*
-				 * Stop the target timer first. Take no action
+				 * Stop the target timers first. Take no action
 				 * on the del_timer failure as the state
 				 * machine state change will validate the
 				 * transaction.
 				 */
+				if (!cancel_delayed_work(&rport->fail_io_work))
+					fc_flush_devloss(shost);
 				if (!cancel_delayed_work(work))
 					fc_flush_devloss(shost);
 
@@ -2061,6 +2142,7 @@ void
 fc_remote_port_delete(struct fc_rport  *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
 	int timeout = rport->dev_loss_tmo;
 	unsigned long flags;
 
@@ -2091,6 +2173,12 @@ fc_remote_port_delete(struct fc_rport  *
 
 	scsi_target_block(&rport->dev);
 
+	/* see if we need to kill io faster than waiting for device loss */
+	if ((rport->fast_io_fail_tmo != -1) &&
+	    (rport->fast_io_fail_tmo < timeout) && (i->f->terminate_rport_io))
+		fc_queue_devloss_work(shost, &rport->fail_io_work,
+					rport->fast_io_fail_tmo * HZ);
+
 	/* cap the length the devices can be blocked until they are deleted */
 	fc_queue_devloss_work(shost, &rport->dev_loss_work, timeout * HZ);
 }
@@ -2150,6 +2238,8 @@ fc_remote_port_rolechg(struct fc_rport  
 		 * machine state change will validate the
 		 * transaction.
 		 */
+		if (!cancel_delayed_work(&rport->fail_io_work))
+			fc_flush_devloss(shost);
 		if (!cancel_delayed_work(&rport->dev_loss_work))
 			fc_flush_devloss(shost);
 
@@ -2271,6 +2361,28 @@ fc_timeout_deleted_rport(void  *data)
 }
 
 /**
+ * fc_timeout_fail_rport_io - Timeout handler for a fast io failing on a
+ *                       disconnected SCSI target.
+ * 
+ * @data:	rport to terminate io on.
+ *
+ * Notes: Only requests the failure of the io, not that all are flushed
+ *    prior to returning.
+ **/
+static void
+fc_timeout_fail_rport_io(void  *data)
+{
+	struct fc_rport *rport = (struct fc_rport *)data;
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+
+	if (rport->port_state != FC_PORTSTATE_BLOCKED)
+		return;
+
+	i->f->terminate_rport_io(rport);
+}
+
+/**
  * fc_scsi_scan_rport - called to perform a scsi scan on a remote port.
  *
  * @data:	remote port to be scanned.
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2006-08-18 10:35:17.000000000 -0400
+++ b/include/scsi/scsi_transport_fc.h	2006-08-18 15:40:51.000000000 -0400
@@ -195,6 +195,7 @@ struct fc_rport {	/* aka fc_starget_attr
 	u32 roles;
 	enum fc_port_state port_state;	/* Will only be ONLINE or UNKNOWN */
 	u32 scsi_target_id;
+	u32 fast_io_fail_tmo;
 
 	/* exported data */
 	void *dd_data;			/* Used for driver-specific storage */
@@ -207,6 +208,7 @@ struct fc_rport {	/* aka fc_starget_attr
 	struct device dev;
  	struct work_struct dev_loss_work;
  	struct work_struct scan_work;
+ 	struct work_struct fail_io_work;
  	struct work_struct stgt_delete_work;
 	struct work_struct rport_delete_work;
 } __attribute__((aligned(sizeof(unsigned long))));
@@ -445,6 +447,9 @@ struct fc_function_template {
 
 	int	(*issue_fc_host_lip)(struct Scsi_Host *);
 
+	void    (*dev_loss_tmo_callbk)(struct fc_rport *);
+	void	(*terminate_rport_io)(struct fc_rport *);
+
 	/* allocation lengths for host-specific data */
 	u32	 			dd_fcrport_size;
 


