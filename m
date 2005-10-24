From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 4/5] aacraid: remove compiler warning
Date: Mon, 24 Oct 2005 10:52:11 -0700
Message-ID: <1130176331.4628.24.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:39902 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751201AbVJXRwN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 13:52:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

This patch resolves a compiler warning on 64 bit architectures.

Applies to the scsi-rc-fixes-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

Index: scsi-rc-aac-1/drivers/scsi/aacraid/commctrl.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/commctrl.c	2005-10-19 13:04:06.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/commctrl.c	2005-10-19 13:04:13.000000000 -0700
@@ -574,7 +574,7 @@
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			sg_user[i] = (void __user *)usg->sg[i].addr;
+			sg_user[i] = (void __user *)(long)usg->sg[i].addr;
 			sg_list[i] = p; // save so we can clean up later
 			sg_indx = i;
 
@@ -624,7 +624,7 @@
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			sg_user[i] = (void __user *)upsg->sg[i].addr;
+			sg_user[i] = (void __user *)(long)upsg->sg[i].addr;
 			sg_list[i] = p; // save so we can clean up later
 			sg_indx = i;
 

-- 
Mark Haverkamp <markh@osdl.org>

