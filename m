From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 1/4] cxlflash: Refactor context reset to share reset logic
Date: Wed, 11 Jan 2017 19:19:08 -0600
Message-ID: <1484183948-22786-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1484183898-22714-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754852AbdALBUF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 20:20:05 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v0C1K3cv103503
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 20:20:05 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27wsfdeu1g-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 20:20:04 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 11 Jan 2017 18:19:26 -0700
In-Reply-To: <1484183898-22714-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

As staging for supporting hardware with different context reset
registers but a similar reset procedure, refactor the existing context
reset routine to move the reset logic to a common routine. This will
allow hardware with a different reset register to leverage existing
code.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b17ebf6..a990efb 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -188,10 +188,11 @@ static void cmd_complete(struct afu_cmd *cmd)
 }
 
 /**
- * context_reset_ioarrin() - reset command owner context via IOARRIN register
+ * context_reset() - reset command owner context via specified register
  * @cmd:	AFU command that timed out.
+ * @reset_reg:	MMIO register to perform reset.
  */
-static void context_reset_ioarrin(struct afu_cmd *cmd)
+static void context_reset(struct afu_cmd *cmd, __be64 __iomem *reset_reg)
 {
 	int nretry = 0;
 	u64 rrin = 0x1;
@@ -201,9 +202,9 @@ static void context_reset_ioarrin(struct afu_cmd *cmd)
 
 	pr_debug("%s: cmd=%p\n", __func__, cmd);
 
-	writeq_be(rrin, &afu->host_map->ioarrin);
+	writeq_be(rrin, reset_reg);
 	do {
-		rrin = readq_be(&afu->host_map->ioarrin);
+		rrin = readq_be(reset_reg);
 		if (rrin != 0x1)
 			break;
 		/* Double delay each time */
@@ -215,6 +216,17 @@ static void context_reset_ioarrin(struct afu_cmd *cmd)
 }
 
 /**
+ * context_reset_ioarrin() - reset command owner context via IOARRIN register
+ * @cmd:	AFU command that timed out.
+ */
+static void context_reset_ioarrin(struct afu_cmd *cmd)
+{
+	struct afu *afu = cmd->parent;
+
+	context_reset(cmd, &afu->host_map->ioarrin);
+}
+
+/**
  * send_cmd_ioarrin() - sends an AFU command via IOARRIN register
  * @afu:	AFU associated with the host.
  * @cmd:	AFU command to send.
-- 
2.1.0

