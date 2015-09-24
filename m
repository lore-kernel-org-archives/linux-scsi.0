From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v3 17/32] cxlflash: Remove dual port online dependency
Date: Thu, 24 Sep 2015 14:39:42 -0500
Message-ID: <1443123582-17269-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:52814 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbbIXTk0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2015 15:40:26 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 24 Sep 2015 15:40:26 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id D76D66E803F
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 15:32:06 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8OJeNcs55836722
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 19:40:23 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8OJeKVE003887
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 15:40:23 -0400
In-Reply-To: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

At present, both ports must be online for the device to
configure properly. Remove this dependency and the unnecessary
internal LUN override logic as well. Additionally, as a refactoring
measure, change the return code variable name to match that used
throughout the driver.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index ed9fd8c..d45388f 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1030,7 +1030,7 @@ static int wait_port_offline(u64 *fc_regs, u32 delay_us, u32 nretry)
  */
 static int afu_set_wwpn(struct afu *afu, int port, u64 *fc_regs, u64 wwpn)
 {
-	int ret = 0;
+	int rc = 0;
 
 	set_port_offline(fc_regs);
 
@@ -1038,33 +1038,26 @@ static int afu_set_wwpn(struct afu *afu, int port, u64 *fc_regs, u64 wwpn)
 			       FC_PORT_STATUS_RETRY_CNT)) {
 		pr_debug("%s: wait on port %d to go offline timed out\n",
 			 __func__, port);
-		ret = -1; /* but continue on to leave the port back online */
+		rc = -1; /* but continue on to leave the port back online */
 	}
 
-	if (ret == 0)
+	if (rc == 0)
 		writeq_be(wwpn, &fc_regs[FC_PNAME / 8]);
 
+	/* Always return success after programming WWPN */
+	rc = 0;
+
 	set_port_online(fc_regs);
 
 	if (!wait_port_online(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
 			      FC_PORT_STATUS_RETRY_CNT)) {
 		pr_debug("%s: wait on port %d to go online timed out\n",
 			 __func__, port);
-		ret = -1;
-
-		/*
-		 * Override for internal lun!!!
-		 */
-		if (afu->internal_lun) {
-			pr_debug("%s: Overriding port %d online timeout!!!\n",
-				 __func__, port);
-			ret = 0;
-		}
 	}
 
-	pr_debug("%s: returning rc=%d\n", __func__, ret);
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
 
-	return ret;
+	return rc;
 }
 
 /**
-- 
2.1.0

