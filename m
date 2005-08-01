From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: Fix sgmap error (resend)
Date: Mon, 01 Aug 2005 07:36:59 -0700
Message-ID: <1122907019.24183.6.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:57010 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262169AbVHAOhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2005 10:37:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>


The wrong sgmap structure is being assigned in aac_send_raw_srb.

Patch against scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

Index: scsi-misc-2.6/drivers/scsi/aacraid/commctrl.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aacraid/commctrl.c	2005-06-24 10:51:16.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/aacraid/commctrl.c	2005-07-07 13:17:21.000000000 -0700
@@ -517,7 +517,7 @@
 	}
 	if (dev->dac_support == 1) {
 		struct user_sgmap64* upsg = (struct user_sgmap64*)&user_srbcmd->sg;
-		struct sgmap64* psg = (struct sgmap64*)&user_srbcmd->sg;
+		struct sgmap64* psg = (struct sgmap64*)&srbcmd->sg;
 		struct user_sgmap* usg;
 		byte_count = 0;
 


-- 
Mark Haverkamp <markh@osdl.org>

