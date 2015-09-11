From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 07/29] cxlflash: Add ULL specifier to context encode mask
Date: Fri, 11 Sep 2015 16:10:19 -0500
Message-ID: <1442005819-46574-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:55898 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbbIKVKi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:10:38 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 17:10:37 -0400
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 8626A6E8045
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:02:18 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLAYIH47644718
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 21:10:34 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLAXlW021967
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:10:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The context encode mask covers more than 32-bits, making it
a long integer. This should be noted by appending a specifier,
'ULL' in this case.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 72d53cf..7947091 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -87,7 +87,7 @@ enum ctx_ctrl {
 	CTX_CTRL_FILE		= (1 << 5)
 };
 
-#define ENCODE_CTXID(_ctx, _id)	(((((u64)_ctx) & 0xFFFFFFFF0) << 28) | _id)
+#define ENCODE_CTXID(_ctx, _id)	(((((u64)_ctx) & 0xFFFFFFFF0ULL) << 28) | _id)
 #define DECODE_CTXID(_val)	(_val & 0xFFFFFFFF)
 
 struct ctx_info {
-- 
2.1.0

