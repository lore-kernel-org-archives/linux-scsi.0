From: James Smart <James.Smart@Emulex.Com>
Subject: [RFC] fc transport: extensions for fast fail and dev loss
Date: Tue, 20 Jun 2006 14:45:23 -0400
Message-ID: <1150829123.16981.1.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:56226 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750796AbWFTSpZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 14:45:25 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k5KIjOUc018739
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jun 2006 11:45:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Folks,

The following addresses some long standing todo items I've had in the
FC transport. They primarily arise when considering multipathing, or
trying to marry driver internal state to transport state. It is intended
that this same type of functionality would be usable in other transports
as well.

Here's what is contained:

- dev_loss_tmo LLDD callback :
  Currently, there is no notification to the LLDD of when the transport
  gives up on the device returning and starts to return DID_NO_CONNECT
  in the queuecommand helper function. This callback notifies the LLDD
  that the transport has now given up on the rport, thereby acknowledging
  the prior fc_remote_port_delete() call. The callback also expects the
  LLDD to initiate the termination of any outstanding i/o on the rport.

- fast_io_fail_tmo and LLD callback:
  There are some cases where it may take a long while to truly determine
  device loss, but the system is in a multipathing configuration that if
  the i/o was failed quickly (faster than dev_loss_tmo), it could be
  redirected to a different path and completed sooner (assuming the 
  multipath thing knew that the sdev was blocked).
  
  iSCSI is one of the transports that may vary dev_loss_tmo values
  per session, and you would like fast io failure.

- fast_loss_time recommendation:
  In discussing how a admin should set dev_loss_tmo in a multipathing
  environment, it became apparent that we expected the admin to know
  a lot. They had to know the transport type, what the minimum setting
  can be that still survives normal link bouncing, and they may even
  have to know about device specifics.  For iSCSI, the proper loss time
  may vary widely from session to session.

  This attribute is an exported "recommendation" by the LLDD and transport
  on what the lowest setting for dev_loss_tmo should be for a multipathing
  environment. Thus, the admin only needs to cat this attribute to obtain
  the value to echo into dev_loss_tmo.
 
I have one criticism of these changes. The callbacks are calling into
the LLDD with an rport post the driver's rport_delete call. What it means
is that we are essentially extending the lifetime of an rport until the
dev_loss_tmo call occurs.

-- james s



diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2006-06-14 11:37:54.000000000 -0400
+++ b/include/scsi/scsi_transport_fc.h	2006-06-16 10:29:22.000000000 -0400
@@ -187,6 +187,8 @@ struct fc_rport {	/* aka fc_starget_attr
 
 	/* Dynamic Attributes */
 	u32 dev_loss_tmo;	/* Remote Port loss timeout in seconds. */
+	u32 fast_loss_time;	/* Fastest setting for dev_loss_tmo to
+				 * detect a path failure. */
 
 	/* Private (Transport-managed) Attributes */
 	u64 node_name;
@@ -195,6 +197,7 @@ struct fc_rport {	/* aka fc_starget_attr
 	u32 roles;
 	enum fc_port_state port_state;	/* Will only be ONLINE or UNKNOWN */
 	u32 scsi_target_id;
+	u32 fast_io_fail_tmo;
 
 	/* exported data */
 	void *dd_data;			/* Used for driver-specific storage */
@@ -399,6 +402,7 @@ struct fc_host_attrs {
 struct fc_function_template {
 	void    (*get_rport_dev_loss_tmo)(struct fc_rport *);
 	void	(*set_rport_dev_loss_tmo)(struct fc_rport *, u32);
+	void    (*get_rport_fast_loss_time)(struct fc_rport *);
 
 	void	(*get_starget_node_name)(struct scsi_target *);
 	void	(*get_starget_port_name)(struct scsi_target *);
@@ -416,6 +420,9 @@ struct fc_function_template {
 
 	int	(*issue_fc_host_lip)(struct Scsi_Host *);
 
+	void    (*dev_loss_tmo_callbk)(struct fc_rport *);
+	void	(*terminate_rport_io)(struct fc_rport *);
+
 	/* allocation lengths for host-specific data */
 	u32	 			dd_fcrport_size;
 
diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2006-06-15 15:10:47.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2006-06-16 10:41:05.000000000 -0400
@@ -216,6 +216,7 @@ fc_bitfield_name_search(remote_port_role
 
 
 static void fc_timeout_deleted_rport(void *data);
+static void fc_timeout_fail_rport_io(void *data);
 static void fc_scsi_scan_rport(void *data);
 
 /*
@@ -223,7 +224,7 @@ static void fc_scsi_scan_rport(void *dat
  * Increase these values if you add attributes
  */
 #define FC_STARGET_NUM_ATTRS 	3
-#define FC_RPORT_NUM_ATTRS	9
+#define FC_RPORT_NUM_ATTRS	11
 #define FC_HOST_NUM_ATTRS	17
 
 struct fc_internal {
@@ -377,6 +378,19 @@ MODULE_PARM_DESC(dev_loss_tmo,
 		 " exceeded, the scsi target is removed. Value should be"
 		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
 
+/*
+ * fast_loss_time: the minimum number of seconds at which the FC transport
+ *   can detect a real device loss. The user can set dev_loss_tmo to this
+ *   value in multipath configurations that want fast path-loss detection.
+ */
+static unsigned int fc_fast_loss_time = 5;	/* seconds */
+
+module_param_named(fast_loss_time, fc_fast_loss_time, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(fast_loss_time,
+		 "Minimum number of seconds at which the FC transport can"
+		 " detect the loss of a remote port. To be meaningful, the"
+		 " value should be less than the dev_loss_tmo parameter.");
+
 
 static __init int fc_transport_init(void)
 {
@@ -510,6 +524,13 @@ static FC_CLASS_DEVICE_ATTR(rport, title
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
 
@@ -555,6 +576,28 @@ store_fc_rport_dev_loss_tmo(struct class
 static FC_CLASS_DEVICE_ATTR(rport, dev_loss_tmo, S_IRUGO | S_IWUSR,
 		show_fc_rport_dev_loss_tmo, store_fc_rport_dev_loss_tmo);
 
+/*
+ * fast_loss_time attribute
+ */
+static ssize_t
+show_fc_rport_fast_loss_time(struct class_device *cdev, char *buf)
+{
+	struct fc_rport *rport = transport_class_to_rport(cdev);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	if ((i->f->get_rport_fast_loss_time) &&
+	    !((rport->port_state == FC_PORTSTATE_BLOCKED) ||
+	      (rport->port_state == FC_PORTSTATE_DELETED) ||
+	      (rport->port_state == FC_PORTSTATE_NOTPRESENT)))
+		i->f->get_rport_fast_loss_time(rport);
+	/* never return a value greater than dev_loss_tmo */
+	return snprintf(buf, 20, "%d\n", 
+		((rport->fast_loss_time < rport->dev_loss_tmo) ?
+			rport->fast_loss_time :  rport->dev_loss_tmo));
+}
+static FC_CLASS_DEVICE_ATTR(rport, fast_loss_time, S_IRUGO,
+		show_fc_rport_fast_loss_time, NULL);
+
 
 /* Private Remote Port Attributes */
 
@@ -597,6 +640,40 @@ static FC_CLASS_DEVICE_ATTR(rport, roles
 fc_private_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
 fc_private_rport_rd_attr(scsi_target_id, "%d\n", 20);
 
+/*
+ * fast_io_fail_tmo attribute
+ */
+static ssize_t
+show_fc_rport_##field (struct class_device *cdev, char *buf)
+{
+	struct fc_rport *rport = transport_class_to_rport(cdev);
+	if (rport->fast_io_fail_tmo == -1)
+		return snprintf(buf, 5, "off\n");
+	return snprintf(buf, 20, "%d\n", rport->fast_io_fail_tmo);
+}
+static ssize_t
+store_fc_rport_fast_io_fail_tmo(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	int val;
+	struct fc_rport *rport = transport_class_to_rport(cdev);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
+	    (rport->port_state == FC_PORTSTATE_DELETED) ||
+	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
+		return -EBUSY;
+	if (strncmp(buf, "off", 3) == 0)
+		rport->fast_io_fail_tmo = -1;
+	else {
+		val = simple_strtoul(buf, NULL, 0);
+		if ((val < 0) || (val >= rport->dev_loss_tmo))
+			return -EINVAL;
+		rport->fast_io_fail_tmo = val;
+	}
+	return count;
+}
+static FC_CLASS_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
+	show_fc_rport_fast_io_fail_tmo, store_fc_rport_fast_io_fail_tmo);
 
 
 /*
@@ -1251,12 +1328,15 @@ fc_attach_transport(struct fc_function_t
 	SETUP_RPORT_ATTRIBUTE_RD(maxframe_size);
 	SETUP_RPORT_ATTRIBUTE_RD(supported_classes);
 	SETUP_RPORT_ATTRIBUTE_RW(dev_loss_tmo);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(fast_loss_time);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(node_name);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_id);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
+	if (ft->terminate_rport_io)
+		SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
 
 	BUG_ON(count > FC_RPORT_NUM_ATTRS);
 
@@ -1461,10 +1541,17 @@ fc_rport_final_delete(void *data)
 	struct fc_rport *rport = (struct fc_rport *)data;
 	struct device *dev = &rport->dev;
 	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
 
-	/* Delete SCSI target and sdevs */
-	if (rport->scsi_target_id != -1)
-		fc_starget_delete(data);
+	/*
+	 * Involve the LLDD if possible. All io on the rport is to
+	 * be terminated, either as part of the dev_loss_tmo callback
+	 * processing, or via the terminate_rport_io function.
+	 */
+	if (i->f->dev_loss_tmo_callbk)
+		i->f->dev_loss_tmo_callbk(rport);
+	else if (i->f->terminate_rport_io)
+		i->f->terminate_rport_io(rport);
 
 	/*
 	 * if a scan is pending, flush the SCSI Host work_q so that 
@@ -1473,6 +1560,10 @@ fc_rport_final_delete(void *data)
 	if (rport->flags & FC_RPORT_SCAN_PENDING)
 		scsi_flush_work(shost);
 
+	/* Delete SCSI target and sdevs */
+	if (rport->scsi_target_id != -1)
+		fc_starget_delete(data);
+
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
@@ -1515,6 +1606,7 @@ fc_rport_create(struct Scsi_Host *shost,
 	rport->maxframe_size = -1;
 	rport->supported_classes = FC_COS_UNSPECIFIED;
 	rport->dev_loss_tmo = fc_dev_loss_tmo;
+	rport->fast_loss_time = fc_fast_loss_time;
 	memcpy(&rport->node_name, &ids->node_name, sizeof(rport->node_name));
 	memcpy(&rport->port_name, &ids->port_name, sizeof(rport->port_name));
 	rport->port_id = ids->port_id;
@@ -1523,8 +1615,10 @@ fc_rport_create(struct Scsi_Host *shost,
 	if (fci->f->dd_fcrport_size)
 		rport->dd_data = &rport[1];
 	rport->channel = channel;
+	rport->fast_io_fail_tmo = -1;
 
 	INIT_WORK(&rport->dev_loss_work, fc_timeout_deleted_rport, rport);
+	INIT_WORK(&rport->fail_io_work, fc_timeout_fail_rport_io, rport);
 	INIT_WORK(&rport->scan_work, fc_scsi_scan_rport, rport);
 	INIT_WORK(&rport->stgt_delete_work, fc_starget_delete, rport);
 	INIT_WORK(&rport->rport_delete_work, fc_rport_final_delete, rport);
@@ -1837,6 +1931,7 @@ void
 fc_remote_port_delete(struct fc_rport  *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
 	int timeout = rport->dev_loss_tmo;
 	unsigned long flags;
 
@@ -1869,6 +1964,12 @@ fc_remote_port_delete(struct fc_rport  *
 
 	/* cap the length the devices can be blocked until they are deleted */
 	fc_queue_devloss_work(shost, &rport->dev_loss_work, timeout * HZ);
+
+	/* see if we need to kill io faster than waiting for device loss */
+	if ((rport->fast_io_fail_tmo != -1) &&
+	    (rport->fast_io_fail_tmo < timeout) && (i->f->terminate_rport_io))
+		fc_queue_devloss_work(shost, &rport->fail_io_work,
+					rport->fast_io_fail_tmo * HZ);
 }
 EXPORT_SYMBOL(fc_remote_port_delete);
 
@@ -2047,6 +2148,28 @@ fc_timeout_deleted_rport(void  *data)
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


