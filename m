From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 1/6] cxlflash: Fix to escalate LINK_RESET also on port 1
Date: Thu, 10 Dec 2015 16:53:26 -0600
Message-ID: <1449788006-23055-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:48791 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbbLJWy3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2015 17:54:29 -0500
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Thu, 10 Dec 2015 15:54:28 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 6693C19D8040
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 15:42:09 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBAMs4gY27066594
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 15:54:04 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBAMs1fH007862
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 15:54:02 -0700
In-Reply-To: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>

From: Manoj Kumar <manoj@linux.vnet.ibm.com>

The original fix to escalate a 'login timed out' error
to a LINK_RESET was only made for one of the two ports
on the card. This fix resolves the same issue for
the second port (port 1).

Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
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

