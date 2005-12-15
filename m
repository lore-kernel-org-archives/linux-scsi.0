From: James.Smart@Emulex.Com
Subject: [PATCH] fix for fc transport recursion problem.
Date: Thu, 15 Dec 2005 09:56:22 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7BA5@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60296 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750749AbVLOO42 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 09:56:28 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jBFEuOs3017642
	for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2005 06:56:25 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com

In the scenario that a link was broken, the devloss timer for each rport
was expire at roughly the same time, causing lots of "delete" workqueue items
being queued. Depth is dependent upon the number of rports that were on the link.

The rport target remove calls were calling flush_scheduled_work(), which would
interrupt the stream, and start the next workqueue item, which did the same thing,
and so on until recursion depth was large.

This fix stops the recursion in the initial delete path, and pushes it off to
a host-level work item that reaps the dead rports.

James - this fix should be added to the final list of 2.6.15-rc5 patches you just posted.

-- james s



diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2005-10-17 12:24:01.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2005-12-15 09:45:42.000000000 -0500
@@ -106,6 +106,7 @@ static struct {
 	{ FC_PORTSTATE_LINKDOWN,	"Linkdown" },
 	{ FC_PORTSTATE_ERROR,		"Error" },
 	{ FC_PORTSTATE_LOOPBACK,	"Loopback" },
+	{ FC_PORTSTATE_DELETED,		"Deleted" },
 };
 fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
 #define FC_PORTSTATE_MAX_NAMELEN	20
@@ -212,6 +213,7 @@ fc_bitfield_name_search(remote_port_role
 #define FC_MGMTSRVR_PORTID		0x00000a
 
 
+static void fc_shost_remove_rports(void  *data);
 static void fc_timeout_deleted_rport(void *data);
 static void fc_scsi_scan_rport(void *data);
 static void fc_rport_terminate(struct fc_rport  *rport);
@@ -319,6 +321,8 @@ static int fc_host_setup(struct transpor
 	fc_host_next_rport_number(shost) = 0;
 	fc_host_next_target_id(shost) = 0;
 
+	fc_host_flags(shost) = 0;
+	INIT_WORK(&fc_host_rport_del_work(shost), fc_shost_remove_rports, shost);
 	return 0;
 }
 
@@ -388,6 +392,7 @@ show_fc_rport_##field (struct class_devi
 	struct fc_internal *i = to_fc_internal(shost->transportt);	\
 	if ((i->f->get_rport_##field) &&				\
 	    !((rport->port_state == FC_PORTSTATE_BLOCKED) ||		\
+	      (rport->port_state == FC_PORTSTATE_DELETED) ||		\
 	      (rport->port_state == FC_PORTSTATE_NOTPRESENT)))		\
 		i->f->get_rport_##field(rport);				\
 	return snprintf(buf, sz, format_string, cast rport->field); 	\
@@ -403,6 +408,7 @@ store_fc_rport_##field(struct class_devi
 	struct Scsi_Host *shost = rport_to_shost(rport);		\
 	struct fc_internal *i = to_fc_internal(shost->transportt);	\
 	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||		\
+	    (rport->port_state == FC_PORTSTATE_DELETED) ||		\
 	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))		\
 		return -EBUSY;						\
 	val = simple_strtoul(buf, NULL, 0);				\
@@ -520,6 +526,7 @@ store_fc_rport_dev_loss_tmo(struct class
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
+	    (rport->port_state == FC_PORTSTATE_DELETED) ||
 	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
 		return -EBUSY;
 	val = simple_strtoul(buf, NULL, 0);
@@ -1739,7 +1746,7 @@ fc_timeout_deleted_rport(void  *data)
 	rport->maxframe_size = -1;
 	rport->supported_classes = FC_COS_UNSPECIFIED;
 	rport->roles = FC_RPORT_ROLE_UNKNOWN;
-	rport->port_state = FC_PORTSTATE_NOTPRESENT;
+	rport->port_state = FC_PORTSTATE_DELETED;
 
 	/* remove the identifiers that aren't used in the consisting binding */
 	switch (fc_host_tgtid_bind_type(shost)) {
@@ -1759,14 +1766,23 @@ fc_timeout_deleted_rport(void  *data)
 		break;
 	}
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
 	/*
 	 * As this only occurs if the remote port (scsi target)
 	 * went away and didn't come back - we'll remove
 	 * all attached scsi devices.
+	 *
+	 * We'll schedule the shost work item to perform the actual removal
+	 * to avoid recursion in the different flush calls if we perform
+	 * the removal in each target - and there are lots of targets
+	 * whose timeouts fire at the same time.
 	 */
-	fc_rport_tgt_remove(rport);
+
+	if ( !(fc_host_flags(shost) & FC_SHOST_RPORT_DEL_SCHEDULED)) {
+		fc_host_flags(shost) |= FC_SHOST_RPORT_DEL_SCHEDULED;
+		scsi_queue_work(shost, &fc_host_rport_del_work(shost));
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /**
@@ -1788,6 +1804,41 @@ fc_scsi_scan_rport(void *data)
 }
 
 
+/**
+ * fc_shost_remove_rports - called to remove all rports that are marked
+ *                       as in a deleted (not connected) state.
+ * 
+ * @data:	shost whose rports are to be looked at
+ **/
+static void
+fc_shost_remove_rports(void  *data)
+{
+	struct Scsi_Host *shost = (struct Scsi_Host *)data;
+	struct fc_rport *rport, *next_rport;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	while (fc_host_flags(shost) & FC_SHOST_RPORT_DEL_SCHEDULED) {
+
+		fc_host_flags(shost) &= ~FC_SHOST_RPORT_DEL_SCHEDULED;
+
+restart_search:
+		list_for_each_entry_safe(rport, next_rport,
+				&fc_host_rport_bindings(shost), peers) {
+			if (rport->port_state == FC_PORTSTATE_DELETED) {
+				rport->port_state = FC_PORTSTATE_NOTPRESENT;
+				spin_unlock_irqrestore(shost->host_lock, flags);
+				fc_rport_tgt_remove(rport);
+				spin_lock_irqsave(shost->host_lock, flags);
+				goto restart_search;
+			}
+		}
+
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
+
 MODULE_AUTHOR("Martin Hicks");
 MODULE_DESCRIPTION("FC Transport Attributes");
 MODULE_LICENSE("GPL");
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2005-10-17 10:03:47.000000000 -0400
+++ b/include/scsi/scsi_transport_fc.h	2005-12-07 09:43:30.000000000 -0500
@@ -78,6 +78,7 @@ enum fc_port_state {
 	FC_PORTSTATE_LINKDOWN,
 	FC_PORTSTATE_ERROR,
 	FC_PORTSTATE_LOOPBACK,
+	FC_PORTSTATE_DELETED,
 };
 
 
@@ -324,8 +325,14 @@ struct fc_host_attrs {
 	struct list_head rport_bindings;
 	u32 next_rport_number;
 	u32 next_target_id;
+	u8 flags;
+ 	struct work_struct rport_del_work;
 };
 
+/* values for struct fc_host_attrs "flags" field: */
+#define FC_SHOST_RPORT_DEL_SCHEDULED	0x01
+
+
 #define fc_host_node_name(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->node_name)
 #define fc_host_port_name(x)	\
@@ -364,6 +371,10 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->next_rport_number)
 #define fc_host_next_target_id(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->next_target_id)
+#define fc_host_flags(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->flags)
+#define fc_host_rport_del_work(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->rport_del_work)
 
 
 /* The functions by which the transport class and the driver communicate */
