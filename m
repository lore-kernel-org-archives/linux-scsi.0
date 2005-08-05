From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aacraid: correct use of cmd->timeout field
Date: Fri, 05 Aug 2005 16:31:35 -0500
Message-ID: <1123277495.5003.77.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:60369 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263134AbVHEVbo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2005 17:31:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Mark Haverkamp <markh@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

The cmd->timeout field has been obsolete for a while now.  While looking
to remove it, I came across this use in the aacraid driver.  It looks
like you want to initialise the firmware with the current timeout of the
command (in seconds), so the value I think you should be using is cmd-
>timeout_per_command.

James

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1894,7 +1893,7 @@ static int aac_send_srb_fib(struct scsi_
 	srbcmd->id   = cpu_to_le32(scsicmd->device->id);
 	srbcmd->lun      = cpu_to_le32(scsicmd->device->lun);
 	srbcmd->flags    = cpu_to_le32(flag);
-	timeout = (scsicmd->timeout-jiffies)/HZ;
+	timeout = scsicmd->timeout_per_command/HZ;
 	if(timeout == 0){
 		timeout = 1;
 	}


