From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-usb-devel] Fw: [Bug 3466] New: Bug while connecting
	USB-HDD (fwd)
Date: 28 Sep 2004 12:40:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096389644.1717.45.camel@mulgrave>
References: <Pine.LNX.4.44L0.0409261704460.32350-100000@netrider.rowland.org>
	<1096236347.10924.97.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:32187 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267974AbUI1Qko (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 12:40:44 -0400
In-Reply-To: <1096236347.10924.97.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Sun, 2004-09-26 at 18:05, James Bottomley wrote:
> There's not enough information to say why it happened.  However, all the
> SCSI code checks out (it's dated ... open coded reference counting
> instead of kref, but it looks sound).  The scenario described could be
> seen if there's a problem in the host reference counting.
> 
> In that case, there should have been a slab error earlier on in the logs
> at the point the error occurred saying something like "slab error in
> kmem_cache_destory(): can't free all objects"
> 
> It's possible this could be caused by a refcounting race on the
> commands.

OK, I have a definite theory about this, but it hinges on finding the
above message in the logs.

I think we tried to destroy the command slab while some commands were
still active.  The refcounting only applies to in-flight commands, but
commands can also be allocated and queued in the block layer.

If I'm right, the attached will close this refcounting hole.

James

===== drivers/scsi/scsi.c 1.146 vs edited =====
--- 1.146/drivers/scsi/scsi.c	2004-08-09 12:55:05 -05:00
+++ edited/drivers/scsi/scsi.c	2004-09-28 11:23:31 -05:00
@@ -244,7 +244,13 @@
  */
 struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int gfp_mask)
 {
-	struct scsi_cmnd *cmd = __scsi_get_command(dev->host, gfp_mask);
+	struct scsi_cmnd *cmd;
+
+	/* Bail if we can't get a reference to the device */
+	if (!get_device(&dev->sdev_gendev))
+		return NULL;
+
+	cmd = __scsi_get_command(dev->host, gfp_mask);
 
 	if (likely(cmd != NULL)) {
 		unsigned long flags;
@@ -258,7 +264,8 @@
 		spin_lock_irqsave(&dev->list_lock, flags);
 		list_add_tail(&cmd->list, &dev->cmd_list);
 		spin_unlock_irqrestore(&dev->list_lock, flags);
-	}
+	} else
+		put_device(&dev->sdev_gendev);
 
 	return cmd;
 }				
@@ -276,7 +283,8 @@
  */
 void scsi_put_command(struct scsi_cmnd *cmd)
 {
-	struct Scsi_Host *shost = cmd->device->host;
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
 	
 	/* serious error if the command hasn't come from a device list */
@@ -294,6 +302,8 @@
 
 	if (likely(cmd != NULL))
 		kmem_cache_free(shost->cmd_pool->slab, cmd);
+
+	put_device(&sdev->sdev_gendev);
 }
 
 /*

