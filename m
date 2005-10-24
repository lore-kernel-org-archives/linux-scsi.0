From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/5] aacraid: fix struct element cpu order
Date: Mon, 24 Oct 2005 10:52:02 -0700
Message-ID: <1130176323.4628.23.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:36830 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751198AbVJXRwF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 13:52:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

The compat field needed to be in cpu order.

Applies to the scsi-rc-fixes-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

Index: scsi-rc-aac-1/drivers/scsi/aacraid/aacraid.h
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/aacraid.h	2005-10-19 13:03:36.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/aacraid.h	2005-10-19 13:04:06.000000000 -0700
@@ -1560,7 +1560,7 @@
 
 struct revision
 {
-	__le32 compat;
+	u32 compat;
 	__le32 version;
 	__le32 build;
 };
Index: scsi-rc-aac-1/drivers/scsi/aacraid/commctrl.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/commctrl.c	2005-10-19 13:03:35.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/commctrl.c	2005-10-19 13:04:06.000000000 -0700
@@ -408,7 +408,7 @@
 	char *driver_version = aac_driver_version;
 	u32 version;
 
-	response.compat = cpu_to_le32(1);
+	response.compat = 1;
 	version = (simple_strtol(driver_version, 
 				&driver_version, 10) << 24) | 0x00000400;
 	version += simple_strtol(driver_version + 1, &driver_version, 10) << 16;

-- 
Mark Haverkamp <markh@osdl.org>

