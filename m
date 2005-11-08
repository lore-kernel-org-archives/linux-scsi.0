From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid: Fix read capacity 16 return data
Date: Tue, 08 Nov 2005 14:26:33 -0800
Message-ID: <1131488793.4050.14.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:46217 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965227AbVKHW0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 17:26:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

The return data from a read capacity 16 needs to have RTO_EN and PROT_EN
zeroed out.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

Applies to the scsi-misc-2.6 git tree.

Index: scsi-misc-aac/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2005-10-31 15:06:16.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2005-11-04 10:12:34.000000000 -0800
@@ -1579,18 +1579,10 @@
 			break;
 	{
 		u64 capacity;
-		char cp[12];
-		unsigned int offset = 0;
+		char cp[13];
 
 		dprintk((KERN_DEBUG "READ CAPACITY_16 command.\n"));
 		capacity = fsa_dev_ptr[cid].size - 1;
-		if (scsicmd->cmnd[13] > 12) {
-			offset = scsicmd->cmnd[13] - 12;
-			if (offset > sizeof(cp))
-				break;
-			memset(cp, 0, offset);
-			aac_internal_transfer(scsicmd, cp, 0, offset);
-		}
 		cp[0] = (capacity >> 56) & 0xff;
 		cp[1] = (capacity >> 48) & 0xff;
 		cp[2] = (capacity >> 40) & 0xff;
@@ -1603,7 +1595,18 @@
 		cp[9] = 0;
 		cp[10] = 2;
 		cp[11] = 0;
-		aac_internal_transfer(scsicmd, cp, offset, sizeof(cp));
+		cp[12] = 0;
+		aac_internal_transfer(scsicmd, cp, 0,
+		  min((unsigned int)scsicmd->cmnd[13], sizeof(cp)));
+		if (sizeof(cp) < scsicmd->cmnd[13]) {
+			unsigned int len, offset = sizeof(cp);
+
+			memset(cp, 0, offset);
+			do {
+				len = min(scsicmd->cmnd[13]-offset, sizeof(cp));
+				aac_internal_transfer(scsicmd, cp, offset, len);
+			} while ((offset += len) < scsicmd->cmnd[13]);
+		}
 
 		/* Do not cache partition table for arrays */
 		scsicmd->device->removable = 1;

-- 
Mark Haverkamp <markh@osdl.org>

