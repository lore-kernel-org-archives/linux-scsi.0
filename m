From: Jeff Garzik <jgarzik@pobox.com>
Subject: PATCH: scsi_debug bug
Date: Sun, 06 Jul 2003 11:38:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F08427C.4050706@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030506040105040807020407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:13029 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262227AbTGFPYQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jul 2003 11:24:16 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030506040105040807020407
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

No response the first time.  Resending.

Can someone look at this patch and approve it, please?

It looks like an obvious bug and fix to me:  MODE_SENSE_10 allocation 
length LSB is in cdb byte 8, not byte 6.

This bug is present in both 2.4 and 2.5.

	Jeff




--------------030506040105040807020407
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

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


--------------030506040105040807020407--

