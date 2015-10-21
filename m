From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 34/37] cxlflash: Fix to escalate to LINK_RESET on login timeout
Date: Wed, 21 Oct 2015 15:16:07 -0500
Message-ID: <1445458567-62129-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:44749 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbbJUURb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:17:31 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 14:17:30 -0600
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 7F4CD38C8062
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:17:27 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKHR6N61538550
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:17:27 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKHPgQ002632
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:17:27 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

From: Manoj Kumar <manoj@linux.vnet.ibm.com>

A 'login timed out' asynchronous error interrupt is generated if no
response is seen to a FLOGI within 2 seconds.  If the time out error
is not escalated to a LINK_RESET the port will not be available for
use. This fix provides the required escalation.

Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index c152703..afaf533 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1100,7 +1100,7 @@ static const struct asyc_intr_info ainfo[] = {
 	{SISL_ASTATUS_FC0_OTHER, "other error", 0, CLR_FC_ERROR | LINK_RESET},
 	{SISL_ASTATUS_FC0_LOGO, "target initiated LOGO", 0, 0},
 	{SISL_ASTATUS_FC0_CRC_T, "CRC threshold exceeded", 0, LINK_RESET},
-	{SISL_ASTATUS_FC0_LOGI_R, "login timed out, retrying", 0, 0},
+	{SISL_ASTATUS_FC0_LOGI_R, "login timed out, retrying", 0, LINK_RESET},
 	{SISL_ASTATUS_FC0_LOGI_F, "login failed", 0, CLR_FC_ERROR},
 	{SISL_ASTATUS_FC0_LOGI_S, "login succeeded", 0, SCAN_HOST},
 	{SISL_ASTATUS_FC0_LINK_DN, "link down", 0, 0},
-- 
2.1.0

