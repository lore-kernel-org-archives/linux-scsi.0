From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 5/5] aacraid: Check scsi_bios_ptabe return code
Date: Wed, 30 Nov 2005 10:36:42 -0800
Message-ID: <1133375802.2288.25.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:60814 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751504AbVK3Sgq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 13:36:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

scsi_bios_ptable return value is not being checked in aac_biosparm.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.


Index: scsi-misc-aac/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2005-11-28 15:15:16.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2005-11-28 15:15:20.000000000 -0800
@@ -325,6 +325,8 @@
 	 *	translations ( 64/32, 128/32, 255/63 ).
 	 */
 	buf = scsi_bios_ptable(bdev);
+	if(buf == NULL)
+		return 0;
 	if(*(__le16 *)(buf + 0x40) == cpu_to_le16(0xaa55)) {
 		struct partition *first = (struct partition * )buf;
 		struct partition *entry = first;

-- 
Mark Haverkamp <markh@osdl.org>

