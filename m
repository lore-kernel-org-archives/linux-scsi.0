From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 1/6] cxlflash: Fix to escalate LINK_RESET also on port 1
Date: Mon, 14 Dec 2015 14:55:09 -0600
Message-ID: <1450126509-47557-2-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1450126293-47440-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1450126509-47557-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:35904 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbbLNU4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 15:56:09 -0500
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Mon, 14 Dec 2015 15:56:08 -0500
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 9277CC9003C
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 15:44:15 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBEKu61a28180562
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 20:56:06 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBEKu5n0010082
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 15:56:06 -0500
In-Reply-To: <1450126509-47557-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>

From: Manoj Kumar <manoj@linux.vnet.ibm.com>

The original fix to escalate a 'login timed out' error
to a LINK_RESET was only made for one of the two ports
on the card. This fix resolves the same issue for
the second port (port 1).

Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 1e5bf0c..09fe252 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1108,7 +1108,7 @@ static const struct asyc_intr_info ainfo[] = {
 	{SISL_ASTATUS_FC1_OTHER, "other error", 1, CLR_FC_ERROR | LINK_RESET},
 	{SISL_ASTATUS_FC1_LOGO, "target initiated LOGO", 1, 0},
 	{SISL_ASTATUS_FC1_CRC_T, "CRC threshold exceeded", 1, LINK_RESET},
-	{SISL_ASTATUS_FC1_LOGI_R, "login timed out, retrying", 1, 0},
+	{SISL_ASTATUS_FC1_LOGI_R, "login timed out, retrying", 1, LINK_RESET},
 	{SISL_ASTATUS_FC1_LOGI_F, "login failed", 1, CLR_FC_ERROR},
 	{SISL_ASTATUS_FC1_LOGI_S, "login succeeded", 1, SCAN_HOST},
 	{SISL_ASTATUS_FC1_LINK_DN, "link down", 1, 0},
-- 
2.1.0

