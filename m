From: Jeff Garzik <jgarzik@pobox.com>
Subject: PATCH: scsi_debug bug
Date: Sun, 29 Jun 2003 15:04:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030629190427.GA2552@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-64-213-145-173.atlantasolutions.com ([64.213.145.173]:9129
	"EHLO havoc.gtf.org") by vger.kernel.org with ESMTP id S261769AbTF2SuI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 14:50:08 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is for 2.5, but should go back to 2.4 I suppose.

MODE_SENSE_10 alloc_len LSB is in cdb byte 8, not byte 6, AFAIK...

	Jeff




===== drivers/scsi/scsi_debug.c 1.39 vs edited =====
--- 1.39/drivers/scsi/scsi_debug.c	Mon Jun  2 20:42:21 2003
+++ edited/drivers/scsi/scsi_debug.c	Sun Jun 29 15:06:03 2003
@@ -687,7 +687,7 @@
 	pcontrol = (cmd[2] & 0xc0) >> 6;
 	pcode = cmd[2] & 0x3f;
 	msense_6 = (MODE_SENSE == cmd[0]);
-	alloc_len = msense_6 ? cmd[4] : ((cmd[7] << 8) | cmd[6]);
+	alloc_len = msense_6 ? cmd[4] : ((cmd[7] << 8) | cmd[8]);
 	/* printk(KERN_INFO "msense: dbd=%d pcontrol=%d pcode=%d "
 		"msense_6=%d alloc_len=%d\n", dbd, pcontrol, pcode, "
 		"msense_6, alloc_len); */
