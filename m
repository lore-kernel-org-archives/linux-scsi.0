From: James.Smart@Emulex.Com
Subject: [PATCH - repost] update fc_transport for removal of block/unblock functions
Date: Tue, 18 Oct 2005 12:03:35 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276997@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55533 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750870AbVJRQEO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2005 12:04:14 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9IG3avf021266
	for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2005 09:03:37 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

[Reposting with updates to the qla2xxx portions] 

Folks,

We recently went back to implement a board reset. When we perform the
reset, we wanted to tear down the internal data structures and rebuild
them. Unfortunately, when it came to the rport structure, things were
odd. If we deleted them, the scsi targets and sdevs would be
torn down. Not a good thing for a temporary reset. We could block the
rports, but we either maintain the internal structures to keep the
rport reference (perhaps even replicating what's in the transport),
or we have to fatten the fc transport with new search routines to find
the rport (and deal with a case of a dangling rport that the driver
forgets).

It dawned on me that we had actually reached this state incorrectly.
When the fc transport first started, we did the block/unblock first, then
added the rport interface. The purpose of block/unblock is to hide the
temporary disappearance of the rport (e.g. being deleted, then readded).
Why are we making the driver do the block/unblock ? We should be making
the transport have only an rport add/delete, and the let the transport
handle the block/unblock.

So... This patch removes the existing fc_remote_port_block/unblock
functions. It moves the block/unblock functionality into the
fc_remote_port_add/delete functions.  Updates for the lpfc driver are
included. Qlogic driver updates are also enclosed, thanks to the
contributions of Andrew Vasquez. [Note: the qla2xxx changes are 
relative to the scsi-misc-2.6 tree as of this morning - which does
not include the recent patches sent by Andrew]. The zfcp driver does
not use the block/unblock functions.

One last comment: The resulting behavior feels very clean. The LLDD is
concerned only with add/delete, which corresponds to the physical
disappearance.  However, the fact that the scsi target and sdevs are
not immediately torn down after the LLDD calls delete causes an
interesting scenario... the midlayer can call the xxx_slave_alloc and
xxx_queuecommand functions with a sdev that is at the location the
rport used to be. The driver must validate the device exists when it
first enters these functions. In thinking about it, this has always
been the case for the LLDD and these routines. The existing drivers
already check for existence. However, this highlights that simple
validation via data structure dereferencing needs to be watched.
To deal with this, a new transport function, fc_remote_port_chkready()
was created that LLDDs should call when they first enter these two
routines. It validates the rport state, and returns a scsi result
which could be returned. In addition to solving the above, it also
creates consistent behavior from the LLDD's when the block and deletes
are occuring.

-- James S



diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2005-10-02 20:53:20.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2005-10-17 12:24:01.000000000 -0400
@@ -212,7 +212,7 @@ fc_bitfield_name_search(remote_port_role
 #define FC_MGMTSRVR_PORTID		0x00000a
 
 
-static void fc_timeout_blocked_rport(void *data);
+static void fc_timeout_deleted_rport(void *data);
 static void fc_scsi_scan_rport(void *data);
 static void fc_rport_terminate(struct fc_rport  *rport);
 
@@ -386,7 +386,9 @@ show_fc_rport_##field (struct class_devi
 	struct fc_rport *rport = transport_class_to_rport(cdev);	\
 	struct Scsi_Host *shost = rport_to_shost(rport);		\
 	struct fc_internal *i = to_fc_internal(shost->transportt);	\
-	if (i->f->get_rport_##field)					\
+	if ((i->f->get_rport_##field) &&				\
+	    !((rport->port_state == FC_PORTSTATE_BLOCKED) ||		\
+	      (rport->port_state == FC_PORTSTATE_NOTPRESENT)))		\
 		i->f->get_rport_##field(rport);				\
 	return snprintf(buf, sz, format_string, cast rport->field); 	\
 }
@@ -400,6 +402,9 @@ store_fc_rport_##field(struct class_devi
 	struct fc_rport *rport = transport_class_to_rport(cdev);	\
 	struct Scsi_Host *shost = rport_to_shost(rport);		\
 	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||		\
+	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))		\
+		return -EBUSY;						\
 	val = simple_strtoul(buf, NULL, 0);				\
 	i->f->set_rport_##field(rport, val);				\
 	return count;							\
@@ -502,7 +507,29 @@ static FC_CLASS_DEVICE_ATTR(rport, suppo
 
 /* Dynamic Remote Port Attributes */
 
-fc_rport_rw_attr(dev_loss_tmo, "%d\n", 20);
+/*
+ * dev_loss_tmo attribute
+ */
+fc_rport_show_function(dev_loss_tmo, "%d\n", 20, )
+static ssize_t
+store_fc_rport_dev_loss_tmo(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	int val;
+	struct fc_rport *rport = transport_class_to_rport(cdev);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
+	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
+		return -EBUSY;
+	val = simple_strtoul(buf, NULL, 0);
+	if ((val < 0) || (val > SCSI_DEVICE_BLOCK_MAX_TIMEOUT))
+		return -EINVAL;
+	i->f->set_rport_dev_loss_tmo(rport, val);
+	return count;
+}
+static FC_CLASS_DEVICE_ATTR(rport, dev_loss_tmo, S_IRUGO | S_IWUSR,
+		show_fc_rport_dev_loss_tmo, store_fc_rport_dev_loss_tmo);
 
 
 /* Private Remote Port Attributes */
@@ -1185,6 +1212,25 @@ fc_remove_host(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(fc_remove_host);
 
+/*
+ * fc_rport_tgt_remove - Removes the scsi target on the remote port
+ * @rport:	The remote port to be operated on
+ */
+static void
+fc_rport_tgt_remove(struct fc_rport *rport)
+{
+	struct Scsi_Host *shost = rport_to_shost(rport);
+
+	scsi_target_unblock(&rport->dev);
+
+	/* Stop anything on the workq */
+	if (!cancel_delayed_work(&rport->dev_loss_work))
+		flush_scheduled_work();
+	scsi_flush_work(shost);
+
+	scsi_remove_target(&rport->dev);
+}
+
 /**
  * fc_rport_create - allocates and creates a remote FC port.
  * @shost:	scsi host the remote port is connected to.
@@ -1231,7 +1277,7 @@ fc_rport_create(struct Scsi_Host *shost,
 		rport->dd_data = &rport[1];
 	rport->channel = channel;
 
-	INIT_WORK(&rport->dev_loss_work, fc_timeout_blocked_rport, rport);
+	INIT_WORK(&rport->dev_loss_work, fc_timeout_deleted_rport, rport);
 	INIT_WORK(&rport->scan_work, fc_scsi_scan_rport, rport);
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -1323,17 +1369,93 @@ struct fc_rport *
 fc_remote_port_add(struct Scsi_Host *shost, int channel,
 	struct fc_rport_identifiers  *ids)
 {
+	struct fc_internal *fci = to_fc_internal(shost->transportt);
 	struct fc_rport *rport;
 	unsigned long flags;
 	int match = 0;
 
+	/*
+	 * Search the list of "active" rports, for an rport that has been
+	 * deleted, but we've held off the real delete while the target
+	 * is in a "blocked" state.
+	 */
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
+
+		if ((rport->port_state == FC_PORTSTATE_BLOCKED) &&
+			(rport->channel == channel)) {
+
+			switch (fc_host_tgtid_bind_type(shost)) {
+			case FC_TGTID_BIND_BY_WWPN:
+			case FC_TGTID_BIND_NONE:
+				if (rport->port_name == ids->port_name)
+					match = 1;
+				break;
+			case FC_TGTID_BIND_BY_WWNN:
+				if (rport->node_name == ids->node_name)
+					match = 1;
+				break;
+			case FC_TGTID_BIND_BY_ID:
+				if (rport->port_id == ids->port_id)
+					match = 1;
+				break;
+			}
+
+			if (match) {
+				struct work_struct *work = 
+							&rport->dev_loss_work;
+
+				memcpy(&rport->node_name, &ids->node_name,
+					sizeof(rport->node_name));
+				memcpy(&rport->port_name, &ids->port_name,
+					sizeof(rport->port_name));
+				rport->port_id = ids->port_id;
+
+				rport->port_state = FC_PORTSTATE_ONLINE;
+				rport->roles = ids->roles;
+
+				spin_unlock_irqrestore(shost->host_lock, flags);
+
+				if (fci->f->dd_fcrport_size)
+					memset(rport->dd_data, 0,
+						fci->f->dd_fcrport_size);
+
+				/*
+				 * If we were blocked, we were a target.
+				 * If no longer a target, we leave the timer
+				 * running in case the port changes roles
+				 * prior to the timer expiring. If the timer
+				 * fires, the target will be torn down.
+				 */
+				if (!(ids->roles & FC_RPORT_ROLE_FCP_TARGET))
+					return rport;
+
+				/* restart the target */
+
+				/*
+				 * Stop the target timer first. Take no action
+				 * on the del_timer failure as the state
+				 * machine state change will validate the
+				 * transaction.
+				 */
+				if (!cancel_delayed_work(work))
+					flush_scheduled_work();
+
+				/* initiate a scan of the target */
+				scsi_queue_work(shost, &rport->scan_work);
+
+				return rport;
+			}
+		}
+	}
+
+	/* Search the bindings array */
 	if (likely((ids->roles & FC_RPORT_ROLE_FCP_TARGET) &&
 		(fc_host_tgtid_bind_type(shost) != FC_TGTID_BIND_NONE))) {
 
 		/* search for a matching consistent binding */
 
-		spin_lock_irqsave(shost->host_lock, flags);
-
 		list_for_each_entry(rport, &fc_host_rport_bindings(shost),
 					peers) {
 			if (rport->channel != channel)
@@ -1363,8 +1485,6 @@ fc_remote_port_add(struct Scsi_Host *sho
 			}
 		}
 
-		spin_unlock_irqrestore(shost->host_lock, flags);
-
 		if (match) {
 			memcpy(&rport->node_name, &ids->node_name,
 				sizeof(rport->node_name));
@@ -1374,6 +1494,12 @@ fc_remote_port_add(struct Scsi_Host *sho
 			rport->roles = ids->roles;
 			rport->port_state = FC_PORTSTATE_ONLINE;
 
+			spin_unlock_irqrestore(shost->host_lock, flags);
+
+			if (fci->f->dd_fcrport_size)
+				memset(rport->dd_data, 0,
+						fci->f->dd_fcrport_size);
+
 			if (rport->roles & FC_RPORT_ROLE_FCP_TARGET)
 				/* initiate a scan of the target */
 				scsi_queue_work(shost, &rport->scan_work);
@@ -1382,6 +1508,8 @@ fc_remote_port_add(struct Scsi_Host *sho
 		}
 	}
 
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	/* No consistent binding found - create new remote port entry */
 	rport = fc_rport_create(shost, channel, ids);
 
@@ -1390,25 +1518,6 @@ fc_remote_port_add(struct Scsi_Host *sho
 EXPORT_SYMBOL(fc_remote_port_add);
 
 /*
- * fc_rport_tgt_remove - Removes the scsi target on the remote port
- * @rport:	The remote port to be operated on
- */
-static void
-fc_rport_tgt_remove(struct fc_rport *rport)
-{
-	struct Scsi_Host *shost = rport_to_shost(rport);
-
-	scsi_target_unblock(&rport->dev);
-
-	/* Stop anything on the workq */
-	if (!cancel_delayed_work(&rport->dev_loss_work))
-		flush_scheduled_work();
-	scsi_flush_work(shost);
-
-	scsi_remove_target(&rport->dev);
-}
-
-/*
  * fc_rport_terminate - this routine tears down and deallocates a remote port.
  * @rport:	The remote port to be terminated
  *
@@ -1441,24 +1550,44 @@ fc_rport_terminate(struct fc_rport  *rpo
  * The LLDD calls this routine to notify the transport that a remote
  * port is no longer part of the topology. Note: Although a port
  * may no longer be part of the topology, it may persist in the remote
- * ports displayed by the fc_host. This is done so that target id
- * mappings (managed via the remote port structures), are always visible
- * as long as the mapping is valid, regardless of port state,
+ * ports displayed by the fc_host. We do this under 2 conditions:
+ * - If the port was a scsi target, we delay its deletion by "blocking" it.
+ *   This allows the port to temporarily disappear, then reappear without
+ *   disrupting the SCSI device tree attached to it. During the "blocked"
+ *   period the port will still exist.
+ * - If the port was a scsi target and disappears for longer than we
+ *   expect, we'll delete the port and the tear down the SCSI device tree
+ *   attached to it. However, we want to semi-persist the target id assigned
+ *   to that port if it eventually does exist. The port structure will
+ *   remain (although with minimal information) so that the target id
+ *   bindings remails.
  *
  * If the remote port is not an FCP Target, it will be fully torn down
  * and deallocated, including the fc_remote_port class device.
  *
- * If the remote port is an FCP Target, the port structure will be
- * marked as Not Present, but will remain as long as there is a valid
- * SCSI target id mapping associated with the port structure. Validity
- * is determined by the binding type. If binding by wwpn, then the port
- * structure is always valid and will not be deallocated until the host
- * is removed.  If binding by wwnn, then the port structure is valid
- * until another port with the same node name is found in the topology.
- * If binding by port id (fc address), then the port structure is valid
- * valid until another port with the same address is identified.
+ * If the remote port is an FCP Target, the port will be placed in a
+ * temporary blocked state. From the LLDD's perspective, the rport no
+ * longer exists. From the SCSI midlayer's perspective, the SCSI target
+ * exists, but all sdevs on it are blocked from further I/O. The following
+ * is then expected:
+ *   If the remote port does not return (signaled by a LLDD call to
+ *   fc_remote_port_add()) within the dev_loss_tmo timeout, then the
+ *   scsi target is removed - killing all outstanding i/o and removing the
+ *   scsi devices attached ot it. The port structure will be marked Not
+ *   Present and be partially cleared, leaving only enough information to
+ *   recognize the remote port relative to the scsi target id binding if
+ *   it later appears.  The port will remain as long as there is a valid
+ *   binding (e.g. until the user changes the binding type or unloads the
+ *   scsi host with the binding).
+ *
+ *   If the remote port returns within the dev_loss_tmo value (and matches
+ *   according to the target id binding type), the port structure will be
+ *   reused. If it is no longer a SCSI target, the target will be torn
+ *   down. If it continues to be a SCSI target, then the target will be
+ *   unblocked (allowing i/o to be resumed), and a scan will be activated
+ *   to ensure that all luns are detected.
  *
- * Called from interrupt or normal process context.
+ * Called from normal process context only - cannot be called from interrupt.
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
@@ -1466,53 +1595,20 @@ fc_rport_terminate(struct fc_rport  *rpo
 void
 fc_remote_port_delete(struct fc_rport  *rport)
 {
-	struct Scsi_Host *shost = rport_to_shost(rport);
-	unsigned long flags;
+	int timeout = rport->dev_loss_tmo;
 
-	/* If no scsi target id mapping or consistent binding type, delete it */
-	if ((rport->scsi_target_id == -1) ||
-	    (fc_host_tgtid_bind_type(shost) == FC_TGTID_BIND_NONE)) {
+	/* If no scsi target id mapping, delete it */
+	if (rport->scsi_target_id == -1) {
 		fc_rport_terminate(rport);
 		return;
 	}
 
-	fc_rport_tgt_remove(rport);
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	list_move_tail(&rport->peers, &fc_host_rport_bindings(shost));
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	/*
-	 * Note: We do not remove or clear the hostdata area. This allows
-	 *   host-specific target data to persist along with the
-	 *   scsi_target_id. It's up to the host to manage it's hostdata area.
-	 */
+	scsi_target_block(&rport->dev);
 
-	/*
-	 * Reinitialize port attributes that may change if the port comes back.
-	 */
-	rport->maxframe_size = -1;
-	rport->supported_classes = FC_COS_UNSPECIFIED;
-	rport->roles = FC_RPORT_ROLE_UNKNOWN;
-	rport->port_state = FC_PORTSTATE_NOTPRESENT;
+	/* cap the length the devices can be blocked until they are deleted */
+	schedule_delayed_work(&rport->dev_loss_work, timeout * HZ);
 
-	/* remove the identifiers that aren't used in the consisting binding */
-	switch (fc_host_tgtid_bind_type(shost)) {
-	case FC_TGTID_BIND_BY_WWPN:
-		rport->node_name = -1;
-		rport->port_id = -1;
-		break;
-	case FC_TGTID_BIND_BY_WWNN:
-		rport->port_name = -1;
-		rport->port_id = -1;
-		break;
-	case FC_TGTID_BIND_BY_ID:
-		rport->node_name = -1;
-		rport->port_name = -1;
-		break;
-	case FC_TGTID_BIND_NONE:	/* to keep compiler happy */
-		break;
-	}
+	rport->port_state = FC_PORTSTATE_BLOCKED;
 }
 EXPORT_SYMBOL(fc_remote_port_delete);
 
@@ -1545,127 +1641,140 @@ fc_remote_port_rolechg(struct fc_rport  
 	unsigned long flags;
 	int create = 0;
 
-	rport->roles = roles;
-
 	spin_lock_irqsave(shost->host_lock, flags);
-	if ((rport->scsi_target_id == -1) &&
-	    (rport->roles & FC_RPORT_ROLE_FCP_TARGET)) {
-		rport->scsi_target_id = fc_host->next_target_id++;
-		create = 1;
+	if (roles & FC_RPORT_ROLE_FCP_TARGET) {
+		if (rport->scsi_target_id == -1) {
+			rport->scsi_target_id = fc_host->next_target_id++;
+			create = 1;
+		} else if (!(rport->roles & FC_RPORT_ROLE_FCP_TARGET))
+			create = 1;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (create)
+	rport->roles = roles;
+
+	if (create) {
+		/*
+		 * There may have been a delete timer running on the
+		 * port. Ensure that it is cancelled as we now know
+		 * the port is an FCP Target.
+		 * Note: we know the rport is exists and in an online
+		 *  state as the LLDD would not have had an rport
+		 *  reference to pass us.
+		 *
+		 * Take no action on the del_timer failure as the state
+		 * machine state change will validate the
+		 * transaction.
+		 */
+		if (!cancel_delayed_work(&rport->dev_loss_work))
+			flush_scheduled_work();
+
 		/* initiate a scan of the target */
 		scsi_queue_work(shost, &rport->scan_work);
+	}
 }
 EXPORT_SYMBOL(fc_remote_port_rolechg);
 
 /**
- * fc_timeout_blocked_rport - Timeout handler for blocked remote port
- *                       that fails to return in the alloted time.
- * @data:	scsi target that failed to reappear in the alloted time.
+ * fc_timeout_deleted_rport - Timeout handler for a deleted remote port that
+ *                       was a SCSI target (thus was blocked), and failed
+ *                       to return in the alloted time.
+ * 
+ * @data:	rport target that failed to reappear in the alloted time.
  **/
 static void
-fc_timeout_blocked_rport(void  *data)
+fc_timeout_deleted_rport(void  *data)
 {
 	struct fc_rport *rport = (struct fc_rport *)data;
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	unsigned long flags;
 
-	rport->port_state = FC_PORTSTATE_OFFLINE;
-
-	dev_printk(KERN_ERR, &rport->dev,
-		"blocked FC remote port time out: removing target\n");
+	spin_lock_irqsave(shost->host_lock, flags);
 
 	/*
-	 * As this only occurs if the remote port (scsi target)
-	 * went away and didn't come back - we'll remove
-	 * all attached scsi devices.
+	 * If the port is ONLINE, then it came back, but was no longer an
+	 * FCP target. Thus we need to tear down the scsi_target on it.
 	 */
-	scsi_target_unblock(&rport->dev);
-	scsi_remove_target(&rport->dev);
-}
+	if (rport->port_state == FC_PORTSTATE_ONLINE) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
 
-/**
- * fc_remote_port_block - temporarily block any scsi traffic to a remote port.
- * @rport:	remote port to be blocked.
- *
- * scsi lldd's with a FC transport call this routine to temporarily stop
- * all scsi traffic to a remote port. If the port is not a SCSI target,
- * no action is taken. If the port is a SCSI target, all attached devices
- * are placed into a SDEV_BLOCK state and a timer is started. The timer is
- * represents the maximum amount of time the port may be blocked. If the
- * timer expires, the port is considered non-existent and the attached
- * scsi devices will be removed.
- *
- * Called from interrupt or normal process context.
- *
- * Returns zero if successful or error if not
- *
- * Notes:
- *      This routine assumes no locks are held on entry.
- *
- *	The timeout and timer types are extracted from the fc transport 
- *	attributes from the caller's rport pointer.
- **/
-int
-fc_remote_port_block(struct fc_rport *rport)
-{
-	int timeout = rport->dev_loss_tmo;
-	struct work_struct *work = &rport->dev_loss_work;
+		dev_printk(KERN_ERR, &rport->dev,
+			"blocked FC remote port time out: removing target\n");
 
-	if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
-		return -EINVAL;
+		fc_rport_tgt_remove(rport);
 
-	scsi_target_block(&rport->dev);
+		return;
+	}
 
-	/* cap the length the devices can be blocked */
-	schedule_delayed_work(work, timeout * HZ);
+	if (rport->port_state != FC_PORTSTATE_BLOCKED) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		dev_printk(KERN_ERR, &rport->dev,
+			"blocked FC remote port time out: leaving target alone\n");
+		return;
+	}
 
-	rport->port_state = FC_PORTSTATE_BLOCKED;
-	return 0;
-}
-EXPORT_SYMBOL(fc_remote_port_block);
+	if (fc_host_tgtid_bind_type(shost) == FC_TGTID_BIND_NONE) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		dev_printk(KERN_ERR, &rport->dev,
+			"blocked FC remote port time out: removing target\n");
+		fc_rport_terminate(rport);
+		return;
+	}
 
-/**
- * fc_remote_port_unblock - restart any blocked scsi traffic to a remote port.
- * @rport:	remote port to be unblocked.
- *
- * scsi lld's with a FC transport call this routine to restart IO to all
- * devices associated with the caller's scsi target following a fc_target_block
- * request.  Called from interrupt or normal process context.
- *
- * Notes:
- *	This routine assumes no locks are held on entry.
- **/
- void
-fc_remote_port_unblock(struct fc_rport *rport)
-{
-	struct work_struct *work = &rport->dev_loss_work;
-	struct Scsi_Host *shost = rport_to_shost(rport);
+	dev_printk(KERN_ERR, &rport->dev,
+		"blocked FC remote port time out: removing target and "
+		"saving binding\n");
+
+	list_move_tail(&rport->peers, &fc_host_rport_bindings(shost));
 
 	/*
-	 * Stop the target timer first. Take no action on the del_timer
-	 * failure as the state machine state change will validate the
-	 * transaction.
+	 * Note: We do not remove or clear the hostdata area. This allows
+	 *   host-specific target data to persist along with the
+	 *   scsi_target_id. It's up to the host to manage it's hostdata area.
 	 */
-	if (!cancel_delayed_work(work))
-		flush_scheduled_work();
 
-	if (rport->port_state == FC_PORTSTATE_OFFLINE)
-		/*
-		 * initiate a scan of the target as the target has
-		 * been torn down.
-		 */
-		scsi_queue_work(shost, &rport->scan_work);
-	else
-		scsi_target_unblock(&rport->dev);
+	/*
+	 * Reinitialize port attributes that may change if the port comes back.
+	 */
+	rport->maxframe_size = -1;
+	rport->supported_classes = FC_COS_UNSPECIFIED;
+	rport->roles = FC_RPORT_ROLE_UNKNOWN;
+	rport->port_state = FC_PORTSTATE_NOTPRESENT;
 
-	rport->port_state = FC_PORTSTATE_ONLINE;
+	/* remove the identifiers that aren't used in the consisting binding */
+	switch (fc_host_tgtid_bind_type(shost)) {
+	case FC_TGTID_BIND_BY_WWPN:
+		rport->node_name = -1;
+		rport->port_id = -1;
+		break;
+	case FC_TGTID_BIND_BY_WWNN:
+		rport->port_name = -1;
+		rport->port_id = -1;
+		break;
+	case FC_TGTID_BIND_BY_ID:
+		rport->node_name = -1;
+		rport->port_name = -1;
+		break;
+	case FC_TGTID_BIND_NONE:	/* to keep compiler happy */
+		break;
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	/*
+	 * As this only occurs if the remote port (scsi target)
+	 * went away and didn't come back - we'll remove
+	 * all attached scsi devices.
+	 */
+	fc_rport_tgt_remove(rport);
 }
-EXPORT_SYMBOL(fc_remote_port_unblock);
 
 /**
  * fc_scsi_scan_rport - called to perform a scsi scan on a remote port.
+ *
+ * Will unblock the target (in case it went away and has now come back),
+ * then invoke a scan.
+ *
  * @data:	remote port to be scanned.
  **/
 static void
@@ -1673,6 +1782,7 @@ fc_scsi_scan_rport(void *data)
 {
 	struct fc_rport *rport = (struct fc_rport *)data;
 
+	scsi_target_unblock(&rport->dev);
 	scsi_scan_target(&rport->dev, rport->channel, rport->scsi_target_id,
 			SCAN_WILD_CARD, 1);
 }
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2005-10-08 08:52:51.000000000 -0400
+++ b/include/scsi/scsi_transport_fc.h	2005-10-17 10:03:47.000000000 -0400
@@ -28,6 +28,7 @@
 #define SCSI_TRANSPORT_FC_H
 
 #include <linux/config.h>
+#include <scsi/scsi.h>
 
 struct scsi_transport_template;
 
@@ -427,6 +428,34 @@ struct fc_function_template {
 };
 
 
+/**
+ * fc_remote_port_chkready - called to validate the remote port state
+ *   prior to initiating io to the port.
+ *
+ * Returns a scsi result code that can be returned by the LLDD.
+ *
+ * @rport:	remote port to be checked
+ **/
+static inline int
+fc_remote_port_chkready(struct fc_rport *rport)
+{
+	int result;
+
+	switch (rport->port_state) {
+	case FC_PORTSTATE_ONLINE:
+		result = 0;
+		break;
+	case FC_PORTSTATE_BLOCKED:
+		result = DID_BUS_BUSY << 16;
+		break;
+	default:
+		result = DID_NO_CONNECT << 16;
+		break;
+	}
+	return result;
+}
+
+
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
@@ -435,8 +464,6 @@ struct fc_rport *fc_remote_port_add(stru
 			int channel, struct fc_rport_identifiers  *ids);
 void fc_remote_port_delete(struct fc_rport  *rport);
 void fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles);
-int fc_remote_port_block(struct fc_rport *rport);
-void fc_remote_port_unblock(struct fc_rport *rport);
 int scsi_is_fc_rport(const struct device *);
 
 #endif /* SCSI_TRANSPORT_FC_H */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2005-10-08 11:21:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2005-10-17 10:21:02.000000000 -0400
@@ -1031,6 +1031,7 @@ lpfc_register_remote_port(struct lpfc_hb
 	if (ndlp->nlp_type & NLP_FCP_INITIATOR)
 		rport_ids.roles |= FC_RPORT_ROLE_FCP_INITIATOR;
 
+	scsi_block_requests(phba->host);
 	ndlp->rport = rport = fc_remote_port_add(phba->host, 0, &rport_ids);
 	if (!rport) {
 		dev_printk(KERN_WARNING, &phba->pcidev->dev,
@@ -1047,6 +1048,23 @@ lpfc_register_remote_port(struct lpfc_hb
 	}
 	rdata = rport->dd_data;
 	rdata->pnode = ndlp;
+	scsi_unblock_requests(phba->host);
+
+	return;
+}
+
+static void
+lpfc_unregister_remote_port(struct lpfc_hba * phba,
+			    struct lpfc_nodelist * ndlp)
+{
+	struct fc_rport *rport = ndlp->rport;
+	struct lpfc_rport_data *rdata = rport->dd_data;
+
+	ndlp->rport = NULL;
+	rdata->pnode = NULL;
+	scsi_block_requests(phba->host);
+	fc_remote_port_delete(rport);
+	scsi_unblock_requests(phba->host);
 
 	return;
 }
@@ -1263,7 +1281,7 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		 * may have removed the remote port.
 		 */
 		if ((rport_del != none) && nlp->rport)
-			fc_remote_port_block(nlp->rport);
+			lpfc_unregister_remote_port(phba, nlp);
 
 		if (rport_add != none) {
 			/*
@@ -1273,8 +1291,6 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 			 */
 			if (!nlp->rport)
 				lpfc_register_remote_port(phba, nlp);
-			else
-				fc_remote_port_unblock(nlp->rport);
 
 			/*
 			 * if we added to Mapped list, but the remote port
@@ -1493,7 +1509,6 @@ lpfc_freenode(struct lpfc_hba * phba, st
 	LPFC_MBOXQ_t       *mb;
 	LPFC_MBOXQ_t       *nextmb;
 	struct lpfc_dmabuf *mp;
-	struct fc_rport *rport;
 
 	/* Cleanup node for NPort <nlp_DID> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
@@ -1510,10 +1525,7 @@ lpfc_freenode(struct lpfc_hba * phba, st
 	 * and flush cache's w/o generating flush errors.
 	 */
 	if ((ndlp->rport) && !(phba->fc_flag & FC_UNLOADING)) {
-		rport = ndlp->rport;
-		ndlp->rport = NULL;
-		fc_remote_port_unblock(rport);
-		fc_remote_port_delete(rport);
+		lpfc_unregister_remote_port(phba, ndlp);
 		ndlp->nlp_sid = NLP_NO_SID;
 	}
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2005-10-02 20:53:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2005-10-16 09:26:24.000000000 -0400
@@ -537,12 +537,6 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 
 		lpfc_offline(phba);
 
-		/*
-		 * Restart all traffic to this host.  Since the fc_transport
-		 * block functions (future) were not called in lpfc_offline,
-		 * don't call them here.
-		 */
-		scsi_unblock_requests(phba->host);
 	}
 }
 
@@ -1226,12 +1220,6 @@ lpfc_online(struct lpfc_hba * phba)
 	phba->fc_flag &= ~FC_OFFLINE_MODE;
 	spin_unlock_irq(phba->host->host_lock);
 
-	/*
-	 * Restart all traffic to this host.  Since the fc_transport block
-	 * functions (future) were not called in lpfc_offline, don't call them
-	 * here.
-	 */
-	scsi_unblock_requests(phba->host);
 	return 0;
 }
 
@@ -1249,13 +1237,6 @@ lpfc_offline(struct lpfc_hba * phba)
 	if (phba->fc_flag & FC_OFFLINE_MODE)
 		return 0;
 
-	/*
-	 * Don't call the fc_transport block api (future).  The device is
-	 * going offline and causing a timer to fire in the midlayer is
-	 * unproductive.  Just block all new requests until the driver
-	 * comes back online.
-	 */
-	scsi_block_requests(phba->host);
 	psli = &phba->sli;
 	pring = &psli->ring[psli->fcp_ring];
 
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2005-10-02 20:53:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2005-10-17 10:22:25.000000000 -0400
@@ -403,14 +403,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			break;
 		}
 
-		if (pnode) {
-			if (pnode->nlp_state != NLP_STE_MAPPED_NODE)
-				cmd->result = ScsiResult(DID_BUS_BUSY,
-					SAM_STAT_BUSY);
-		}
-		else {
-			cmd->result = ScsiResult(DID_NO_CONNECT, 0);
-		}
+		if ((pnode == NULL )
+		    || (pnode->nlp_state != NLP_STE_MAPPED_NODE))
+			cmd->result = ScsiResult(DID_BUS_BUSY, SAM_STAT_BUSY);
 	} else {
 		cmd->result = ScsiResult(DID_OK, 0);
 	}
@@ -539,7 +534,7 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 	struct lpfc_rport_data *rdata = scsi_dev->hostdata;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 
-	if ((ndlp == 0) || (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
+	if ((ndlp == NULL) || (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
 		return 0;
 	}
 
@@ -727,39 +722,23 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 	struct lpfc_scsi_buf *lpfc_cmd = NULL;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	struct list_head *scsi_buf_list = &phba->lpfc_scsi_buf_list;
-	int err = 0;
+	int err;
 
-	/*
-	 * The target pointer is guaranteed not to be NULL because the driver
-	 * only clears the device->hostdata field in lpfc_slave_destroy.  This
-	 * approach guarantees no further IO calls on this target.
-	 */
-	if (!ndlp) {
-		cmnd->result = ScsiResult(DID_NO_CONNECT, 0);
+	err = fc_remote_port_chkready(rport);
+	if (err) {
+		cmnd->result = err;
 		goto out_fail_command;
 	}
 
 	/*
-	 * A Fibre Channel target is present and functioning only when the node
-	 * state is MAPPED.  Any other state is a failure.
+	 * Catch race where our node has transitioned, but the
+	 * transport is still transitioning.
 	 */
-	if (ndlp->nlp_state != NLP_STE_MAPPED_NODE) {
-		if ((ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) ||
-		    (ndlp->nlp_state == NLP_STE_UNUSED_NODE)) {
-			cmnd->result = ScsiResult(DID_NO_CONNECT, 0);
-			goto out_fail_command;
-		}
-		else if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
-			cmnd->result = ScsiResult(DID_BUS_BUSY, 0);
-			goto out_fail_command;
-		}
-		/*
-		 * The device is most likely recovered and the driver
-		 * needs a bit more time to finish.  Ask the midlayer
-		 * to retry.
-		 */
-		goto out_host_busy;
+	if (!ndlp) {
+		cmnd->result = ScsiResult(DID_BUS_BUSY, 0);
+		goto out_fail_command;
 	}
 
 	list_remove_head(scsi_buf_list, lpfc_cmd, struct lpfc_scsi_buf, list);
@@ -1163,44 +1142,16 @@ static int
 lpfc_slave_alloc(struct scsi_device *sdev)
 {
 	struct lpfc_hba *phba = (struct lpfc_hba *)sdev->host->hostdata[0];
-	struct lpfc_nodelist *ndlp = NULL;
-	int match = 0;
 	struct lpfc_scsi_buf *scsi_buf = NULL;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	uint32_t total = 0, i;
 	uint32_t num_to_alloc = 0;
 	unsigned long flags;
-	struct list_head *listp;
-	struct list_head *node_list[6];
-
-	/*
-	 * Store the target pointer in the scsi_device hostdata pointer provided
-	 * the driver has already discovered the target id.
-	 */
-
-	/* Search the nlp lists other than unmap_list for this target ID */
-	node_list[0] = &phba->fc_npr_list;
-	node_list[1] = &phba->fc_nlpmap_list;
-	node_list[2] = &phba->fc_prli_list;
-	node_list[3] = &phba->fc_reglogin_list;
-	node_list[4] = &phba->fc_adisc_list;
-	node_list[5] = &phba->fc_plogi_list;
-
-	for (i = 0; i < 6 && !match; i++) {
-		listp = node_list[i];
-		if (list_empty(listp))
-			continue;
-		list_for_each_entry(ndlp, listp, nlp_listp) {
-			if ((sdev->id == ndlp->nlp_sid) && ndlp->rport) {
-				match = 1;
-				break;
-			}
-		}
-	}
 
-	if (!match)
+	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	sdev->hostdata = ndlp->rport->dd_data;
+	sdev->hostdata = rport->dd_data;
 
 	/*
 	 * Populate the cmds_per_lun count scsi_bufs into this host's globally
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b455c31..e0025da 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -34,6 +34,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/interrupt.h>
+#include <linux/workqueue.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
@@ -1673,6 +1674,8 @@ typedef struct fc_port {
 
 	struct fc_rport *rport;
 	u32 supported_classes;
+	struct work_struct rport_add_work;
+	struct work_struct rport_del_work;
 } fc_port_t;
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 23d095d..127e1a5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1677,6 +1677,24 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	return (rval);
 }
 
+static void
+qla2x00_rport_add(void *data)
+{
+	fc_port_t *fcport = data;
+
+	qla2x00_reg_remote_port(fcport->ha, fcport);
+}
+
+static void
+qla2x00_rport_del(void *data)
+{
+	fc_port_t *fcport = data;
+
+	if (fcport->rport)
+		fc_remote_port_delete(fcport->rport);
+	fcport->rport = NULL;
+}
+
 /**
  * qla2x00_alloc_fcport() - Allocate a generic fcport.
  * @ha: HA context
@@ -1702,6 +1720,8 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 	atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	fcport->flags = FCF_RLC_SUPPORT;
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
+	INIT_WORK(&fcport->rport_add_work, qla2x00_rport_add, fcport);
+	INIT_WORK(&fcport->rport_del_work, qla2x00_rport_del, fcport);
 
 	return (fcport);
 }
@@ -2065,8 +2085,8 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 	struct fc_rport *rport;
 
 	if (fcport->rport) {
-		fc_remote_port_unblock(fcport->rport);
-		return;
+		fc_remote_port_delete(fcport->rport);
+		fcport->rport = NULL;
 	}
 
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
@@ -2080,7 +2100,7 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 		    "Unable to allocate fc remote port!\n");
 		return;
 	}
-	rport->dd_data = fcport;
+	*((fc_port_t **)rport->dd_data) = fcport;
 	rport->supported_classes = fcport->supported_classes;
 
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8982978..111fe95 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -373,11 +373,13 @@ qla2x00_queuecommand(struct scsi_cmnd *c
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
 	srb_t *sp;
 	int rval;
 
-	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
+	rval = fc_remote_port_chkready(rport);
+	if (rval) {
+		cmd->result = rval;
 		goto qc_fail_command;
 	}
 
@@ -436,11 +438,13 @@ qla24xx_queuecommand(struct scsi_cmnd *c
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
 	srb_t *sp;
 	int rval;
 
-	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
+	rval = fc_remote_port_chkready(rport);
+	if (rval) {
+		cmd->result = rval;
 		goto qc24_fail_command;
 	}
 
@@ -1087,10 +1091,10 @@ qla2xxx_slave_alloc(struct scsi_device *
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 
-	if (!rport)
+	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	sdev->hostdata = rport->dd_data;
+	sdev->hostdata = *(fc_port_t **)rport->dd_data;
 
 	return 0;
 }
@@ -1681,7 +1685,8 @@ void qla2x00_mark_device_lost(scsi_qla_h
     int do_login)
 {
 	if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
-		fc_remote_port_block(fcport->rport);
+		schedule_work(&fcport->rport_del_work);
+
 	/*
 	 * We may need to retry the login, so don't change the state of the
 	 * port but do the retries.
@@ -1742,7 +1747,7 @@ qla2x00_mark_all_devices_lost(scsi_qla_h
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
 		if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
-			fc_remote_port_block(fcport->rport);
+			schedule_work(&fcport->rport_del_work);
 		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
index 1eba988..2f04a5f 100644
--- a/drivers/scsi/qla2xxx/qla_rscn.c
+++ b/drivers/scsi/qla2xxx/qla_rscn.c
@@ -330,8 +330,7 @@ qla2x00_update_login_fcport(scsi_qla_hos
 	fcport->flags &= ~FCF_FAILOVER_NEEDED;
 	fcport->iodesc_idx_sent = IODESC_INVALID_INDEX;
 	atomic_set(&fcport->state, FCS_ONLINE);
-	if (fcport->rport)
-		fc_remote_port_unblock(fcport->rport);
+	schedule_work(&fcport->rport_add_work);
 }
 
 
 
