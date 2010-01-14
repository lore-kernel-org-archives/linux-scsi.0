From: George Kadianakis <desnacked@gmail.com>
Subject: [PATCH 1/1] SCSI: lpfc, restore MSI-X/MSI support
Date: Thu, 14 Jan 2010 02:20:00 +0200
Message-ID: <87r5pta66n.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:37450 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab0ANAUX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2010 19:20:23 -0500
Received: by ewy1 with SMTP id 1so277442ewy.28
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jan 2010 16:20:21 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.smart@emulex.com

From: George Kadianakis <desnacked {bomb} gmail {point} com>

A Gentoo bug report [1] showed that as of 2.6.31 lpfc only uses INTx interrupts.
This patch restores lpfc's ability to support MSI-X/MSI interrupts that the 
"Addition of SLI4 Interface - Base Support" patch [2] broke.
It reestablishes MSI-X as the default interrupt method and in case MSI-X is not 
supported lpfc_sli{4,}_enable_intr fallbacks to MSI and then to INTx.

[1]: http://bugs.gentoo.org/show_bug.cgi?id=296319
[2]: commit da0436e915a5c17ee79e72c1bf978a4ebb1cbf4d

Signed-off-by:  George Kadianakis <desnacked {cat} gmail {dog} com>
---
 drivers/scsi/lpfc/lpfc_attr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e1a30a1..936ecaf 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2890,12 +2890,12 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
 /*
 # lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
 # 				 support this feature
-#       0  = MSI disabled (default)
+#       0  = MSI disabled
 #       1  = MSI enabled
-#       2  = MSI-X enabled
+#       2  = MSI-X enabled (default)
 # Value range is [0,2]. Default value is 0.
 */
-LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) or "
+LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
 					      "MSI-X (2), if possible");
 
 /*
