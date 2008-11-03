From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: 2.6.27 and good_bytes -= scsi_get_resid(cmd)
Date: Mon, 3 Nov 2008 22:50:18 +0100
Message-ID: <20081103215014.GA20035@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3786 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYKCWDz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2008 17:03:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, mikevs@xs4all.net

I upgraded to 2.6.27 on a machine with the dpt_i2o scsi driver and
I'm seeing some weird number from iostat -x 2. Basically it thinks
that the size of every request is 32640 sectors (0xff0000 bytes),
and that throws off the stats considerably.

By using git-bisect I found out that the cause is this commit:

commit 427e59f09fdba387547106de7bab980b7fff77be
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Mar 8 18:24:17 2008 -0600

    [SCSI] make use of the residue value
    
    USB sometimes doesn't return an error but instead returns a residue
    value indicating part (or all) of the command wasn't completed.  So if
    the driver _done() error processing indicates the command was fully
    processed, subtract off the residue so that this USB error gets
    propagated.
    
    Cc: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 110e776..36c92f9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -855,9 +855,18 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 
 	good_bytes = scsi_bufflen(cmd);
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+		int old_good_bytes = good_bytes;
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
 			good_bytes = drv->done(cmd);
+		/*
+		 * USB may not give sense identifying bad sector and
+		 * simply return a residue instead, so subtract off the
+		 * residue if drv->done() error processing indicates no
+		 * change to the completion length.
+		 */
+		if (good_bytes == old_good_bytes)
+			good_bytes -= scsi_get_resid(cmd);
 	}
 	scsi_io_completion(cmd, good_bytes);
 }


Now the dpt_i2o driver calls scsi_set_resid unconditionally after
a command completes and comments it as '// calculate resid for sg' .

Reverting the above commit fixes my problem. Applying the following
patch to dpt_i2o.c fixes it as well. If the patch below is
actually considered the right way to fix this (I'm not really sure
what I'm doing here) then I think there might be more drivers that
need a similar fix.

[PATCH] dpt_i2o.c: calculate resid for sg only

dpt_i2o.c calls scsi_set_resid() unconditionally. But
it should only do that for sg requests. This became apparent
after commit 427e59f09fdba387547106de7bab980b7fff77be .

Signed-off-by: Miquel vam Smoorenburg <mikevs@xs4all.net>

--- linux-2.6.27.4/drivers/scsi/dpt_i2o.c.ORIG	2008-10-26 00:05:07.000000000 +0200
+++ linux-2.6.27.4/drivers/scsi/dpt_i2o.c	2008-11-03 22:17:21.000000000 +0100
@@ -2445,7 +2445,8 @@
 	hba_status = detailed_status >> 8;
 
 	// calculate resid for sg 
-	scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(reply+5));
+	if (cmd->request->cmd_type == REQ_TYPE_BLOCK_PC)
+		scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(reply+5));
 
 	pHba = (adpt_hba*) cmd->device->host->hostdata[0];
 


Mike.
