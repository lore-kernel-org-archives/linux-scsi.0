From: Michael Reed <mdr@sgi.com>
Subject: [PATCH] make fc transport removal of target configurable
Date: Mon, 12 Jun 2006 18:16:42 -0500
Message-ID: <448DF5DA.3070800@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000703050709090102040005"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:27583 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932225AbWFLXQq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 19:16:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James.Smart@Emulex.Com, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Michael Reed <mdr@sgi.com>, Gary Hagensen <gwh@sgi.com>

This is a multi-part message in MIME format.
--------------000703050709090102040005
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

If the fc transport removes the scsi infrastructure for a
disconnected target and that target subsequently returns,
those subsystems layered upon scsi which don't understand
the implications of this disconnection / reconnection may
be unable to access the reconnected scsi target.  This patch
makes the target removal configurable.

Signed-off-by: Michael Reed <mdr@sgi.com>



--------------000703050709090102040005
Content-Type: text/x-patch;
 name="fc_transport_optional_remove.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fc_transport_optional_remove.patch"

--- rc6u/drivers/scsi/scsi_transport_fc.c	2006-06-07 12:21:31.000000000 -0500
+++ rc6/drivers/scsi/scsi_transport_fc.c	2006-06-12 17:23:34.135974222 -0500
@@ -374,9 +374,29 @@
 MODULE_PARM_DESC(dev_loss_tmo,
 		 "Maximum number of seconds that the FC transport should"
 		 " insulate the loss of a remote port. Once this value is"
-		 " exceeded, the scsi target is removed. Value should be"
+		 " exceeded, the scsi target may be removed. Reference the
+		 " remove_on_dev_loss module parameter.  Value should be"
 		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
 
+/*
+ * remove_on_dev_loss: controls whether the transport will
+ *   remove a scsi target after the device loss timer expires.
+ *   Removal on disconnect is modeled after the USB subsystem
+ *   and expects subsystems layered on SCSI to be aware of
+ *   potential device loss and handle it appropriately. However,
+ *   many subsystems do not support device removal, leaving situations
+ *   where structure references may remain, causing new device
+ *   name assignments, etc., if the target returns.
+ */
+static unsigned int fc_remove_on_dev_loss = 0;
+module_param_named(remove_on_dev_loss, fc_remove_on_dev_loss,
+		   int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(remove_on_dev_loss,
+    		"Boolean.  When the device loss timer fires, this variable"
+		" controls whether the scsi infrastructure for the target"
+		" device is removed.  Values: zero means do not remove,"
+		" non-zero means remove.  Default is zero.");
+
 
 static __init int fc_transport_init(void)
 {
@@ -1446,7 +1466,8 @@
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	scsi_remove_target(&rport->dev);
+	if (fc_remove_on_dev_loss)
+		scsi_remove_target(&rport->dev);
 }
 
 
@@ -1992,9 +2013,13 @@
 		return;
 	}
 
-	dev_printk(KERN_ERR, &rport->dev,
-		"blocked FC remote port time out: removing target and "
-		"saving binding\n");
+	if (fc_remove_on_dev_loss)
+		dev_printk(KERN_ERR, &rport->dev,
+			"blocked FC remote port time out: removing target and "
+			"saving binding\n");
+	else
+		dev_printk(KERN_ERR, &rport->dev,
+			"blocked FC remote port time out: saving binding\n");
 
 	list_move_tail(&rport->peers, &fc_host->rport_bindings);
 

--------------000703050709090102040005--
