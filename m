From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 5/6] cxlflash: Refactor WWPN setup
Date: Fri,  2 Sep 2016 15:40:20 -0500
Message-ID: <1472848820-65180-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42961 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752847AbcIBUkh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2016 16:40:37 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82KXHHw093864
        for <linux-scsi@vger.kernel.org>; Fri, 2 Sep 2016 16:40:36 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2575yrxu9t-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 02 Sep 2016 16:40:35 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Fri, 2 Sep 2016 14:40:34 -0600
In-Reply-To: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Commit 964497b3bf3f ("cxlflash: Remove dual port online dependency")
logically removed the ability for the WWPN setup routine afu_set_wwpn()
to return a non-success value. This routine can safely be made a void
to simplify the code as there is no longer a need to report a failure.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 40 +++++++++-------------------------------
 1 file changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 42970a4..b301655 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1093,42 +1093,25 @@ static int wait_port_offline(__be64 __iomem *fc_regs, u32 delay_us, u32 nretry)
  * online. This toggling action can cause this routine to delay up to a few
  * seconds. When configured to use the internal LUN feature of the AFU, a
  * failure to come online is overridden.
- *
- * Return:
- *	0 when the WWPN is successfully written and the port comes back online
- *	-1 when the port fails to go offline or come back up online
  */
-static int afu_set_wwpn(struct afu *afu, int port, __be64 __iomem *fc_regs,
-			u64 wwpn)
+static void afu_set_wwpn(struct afu *afu, int port, __be64 __iomem *fc_regs,
+			 u64 wwpn)
 {
-	int rc = 0;
-
 	set_port_offline(fc_regs);
-
 	if (!wait_port_offline(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
 			       FC_PORT_STATUS_RETRY_CNT)) {
 		pr_debug("%s: wait on port %d to go offline timed out\n",
 			 __func__, port);
-		rc = -1; /* but continue on to leave the port back online */
 	}
 
-	if (rc == 0)
-		writeq_be(wwpn, &fc_regs[FC_PNAME / 8]);
-
-	/* Always return success after programming WWPN */
-	rc = 0;
+	writeq_be(wwpn, &fc_regs[FC_PNAME / 8]);
 
 	set_port_online(fc_regs);
-
 	if (!wait_port_online(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
 			      FC_PORT_STATUS_RETRY_CNT)) {
-		pr_err("%s: wait on port %d to go online timed out\n",
-		       __func__, port);
+		pr_debug("%s: wait on port %d to go online timed out\n",
+			 __func__, port);
 	}
-
-	pr_debug("%s: returning rc=%d\n", __func__, rc);
-
-	return rc;
 }
 
 /**
@@ -1629,15 +1612,10 @@ static int init_global(struct cxlflash_cfg *cfg)
 			  [FC_CRC_THRESH / 8]);
 
 		/* Set WWPNs. If already programmed, wwpn[i] is 0 */
-		if (wwpn[i] != 0 &&
-		    afu_set_wwpn(afu, i,
-				 &afu->afu_map->global.fc_regs[i][0],
-				 wwpn[i])) {
-			dev_err(dev, "%s: failed to set WWPN on port %d\n",
-			       __func__, i);
-			rc = -EIO;
-			goto out;
-		}
+		if (wwpn[i] != 0)
+			afu_set_wwpn(afu, i,
+				     &afu->afu_map->global.fc_regs[i][0],
+				     wwpn[i]);
 		/* Programming WWPN back to back causes additional
 		 * offline/online transitions and a PLOGI
 		 */
-- 
2.1.0

