From: scameron@beardog.cca.cpqcorp.net
Subject: [patch 8/8] cciss: decode unit attention in SCSI error handling code
Date: Mon, 8 Jun 2009 16:10:57 -0500
Message-ID: <20090608211057.GN23523@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:27838 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZFHVKd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 17:10:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, akpm@linux-foundation.org
Cc: scameron@beardog.cca.cpqcorp.net, mikem@beardog.cca.cpqcorp.net



Make SCSI reset error handler decode unit attention ASC
and after a target reset wait for a unit attention that indicates
a reset occurred rather than just for any old unit attention.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

---

---


diff -puN drivers/block/cciss_scsi.c~decode_unit_attn drivers/block/cciss_scsi.c
--- linux-next/drivers/block/cciss_scsi.c~decode_unit_attn	2009-06-08 12:59:13.000000000 -0500
+++ linux-next-scameron/drivers/block/cciss_scsi.c	2009-06-08 14:35:43.000000000 -0500
@@ -1604,16 +1604,25 @@ static int wait_for_device_to_become_rea
 
 		(void) process_sendcmd_error(h, c);
 
-		if (rc == 0 && c->err_info->CommandStatus == CMD_SUCCESS)
-			break;
+		if (rc != 0)
+			goto retry_tur;
 
-		if (rc == 0 &&
-			c->err_info->CommandStatus == CMD_TARGET_STATUS &&
-			c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION &&
-			(c->err_info->SenseInfo[2] == NO_SENSE ||
-			c->err_info->SenseInfo[2] == UNIT_ATTENTION))
+		if (c->err_info->CommandStatus == CMD_SUCCESS)
 			break;
 
+		if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
+			c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION) {
+			if (c->err_info->SenseInfo[2] == NO_SENSE)
+				break;
+			if (c->err_info->SenseInfo[2] == UNIT_ATTENTION) {
+				unsigned char asc;
+				asc = c->err_info->SenseInfo[12];
+				check_for_unit_attention(h, c);
+				if (asc == POWER_OR_RESET)
+					break;
+			}
+		}
+retry_tur:
 		printk(KERN_WARNING "cciss%d: Waiting %d secs "
 			"for device to become ready.\n",
 			h->ctlr, waittime / HZ);
_
