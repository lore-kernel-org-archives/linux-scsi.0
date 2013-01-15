From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Tue, 15 Jan 2013 16:02:18 +0100
Message-ID: <1358262138-13378-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402Ab3AOPCW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jan 2013 10:02:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>

Multipath might detect a path down even though the LLDD
hasn't registered a link down event.
This patch makes the 'port_state' FC attribute writeable
to enforce a link down scenario in these cases, allowing
for a fast failover to the remaining ports.

Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Smart <james.smart@emulex.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 5e1c6dd..4d28ee5 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -42,6 +42,8 @@
 #include "scsi_priv.h"
 #include "scsi_transport_fc_internal.h"
 
+static void fc_flush_devloss(struct Scsi_Host *shost);
+static void fc_flush_work(struct Scsi_Host *shost);
 static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
 static void fc_vport_sched_delete(struct work_struct *work);
 static int fc_vport_setup(struct Scsi_Host *shost, int channel,
@@ -949,7 +951,76 @@ show_fc_rport_roles (struct device *dev, struct device_attribute *attr,
 static FC_DEVICE_ATTR(rport, roles, S_IRUGO,
 		show_fc_rport_roles, NULL);
 
-fc_private_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
+static ssize_t
+store_fc_rport_port_state(struct device *dev,
+			  struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	unsigned long flags;
+	struct fc_rport *rport = transport_class_to_rport(dev);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (!strncmp(buf, "Blocked", 7)) {
+		if (rport->port_state != FC_PORTSTATE_ONLINE) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			return -EBUSY;
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		fc_remote_port_delete(rport);
+	} else if (!strncmp(buf, "Online", 6)) {
+		if (rport->port_state != FC_PORTSTATE_BLOCKED) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			return -EBUSY;
+		}
+		/* Reset back to online for rescan */
+		rport->port_state = FC_PORTSTATE_ONLINE;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
+		if (!cancel_delayed_work(&rport->fail_io_work))
+			fc_flush_devloss(shost);
+		if (!cancel_delayed_work(&rport->dev_loss_work))
+			fc_flush_devloss(shost);
+
+		spin_lock_irqsave(shost->host_lock, flags);
+		rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
+				  FC_RPORT_DEVLOSS_PENDING |
+				  FC_RPORT_DEVLOSS_CALLBK_DONE);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
+		/* ensure any stgt delete functions are done */
+		fc_flush_work(shost);
+
+		if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
+			scsi_target_unblock(&rport->dev, SDEV_RUNNING);
+			/* initiate a scan of the target */
+			spin_lock_irqsave(shost->host_lock, flags);
+			rport->flags |= FC_RPORT_SCAN_PENDING;
+			scsi_queue_work(shost, &rport->scan_work);
+			spin_unlock_irqrestore(shost->host_lock, flags);
+		}
+	} else
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t
+show_fc_rport_port_state (struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+	const char *name;
+
+	name = get_fc_port_state_name(rport->port_state);
+	if (!name)
+		return -EINVAL;
+	return snprintf(buf, FC_PORTSTATE_MAX_NAMELEN, "%s\n", name);
+}
+
+static FC_DEVICE_ATTR(rport, port_state, S_IRUGO | S_IWUSR,
+		show_fc_rport_port_state, store_fc_rport_port_state);
+
 fc_private_rport_rd_attr(scsi_target_id, "%d\n", 20);
 
 /*
@@ -2289,7 +2360,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_id);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
-	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(port_state);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
 
