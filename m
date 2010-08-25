From: Jean Sacren <sakiwit@gmail.com>
Subject: [PATCH 1/1] scsi: Fix warning: zero-length gnu_printf format string
Date: Wed, 25 Aug 2010 17:58:09 -0600
Message-ID: <20100825235809.GA7160@mail.gmail.com>
References: <20100825235529.GA7152@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56885 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0HYX6H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Aug 2010 19:58:07 -0400
Received: by pwi7 with SMTP id 7so498558pwi.19
        for <linux-scsi@vger.kernel.org>; Wed, 25 Aug 2010 16:58:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20100825235529.GA7152@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

warning: zero-length gnu_printf format string

Fix the above warning by inserting a space into the literal string.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/scsi/constants.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index cd05e04..d0c8234 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1404,13 +1404,13 @@ void scsi_print_sense(char *name, struct scsi_cmnd *cmd)
 {
 	struct scsi_sense_hdr sshdr;
 
-	scmd_printk(KERN_INFO, cmd, "");
+	scmd_printk(KERN_INFO, cmd, " ");
 	scsi_decode_sense_buffer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				 &sshdr);
 	scsi_show_sense_hdr(&sshdr);
 	scsi_decode_sense_extras(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				 &sshdr);
-	scmd_printk(KERN_INFO, cmd, "");
+	scmd_printk(KERN_INFO, cmd, " ");
 	scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
 }
 EXPORT_SYMBOL(scsi_print_sense);
@@ -1453,7 +1453,7 @@ EXPORT_SYMBOL(scsi_show_result);
 
 void scsi_print_result(struct scsi_cmnd *cmd)
 {
-	scmd_printk(KERN_INFO, cmd, "");
+	scmd_printk(KERN_INFO, cmd, " ");
 	scsi_show_result(cmd->result);
 }
 EXPORT_SYMBOL(scsi_print_result);
-- 
1.7.1


-- 
Jean Sacren
Bring LAMP To People
