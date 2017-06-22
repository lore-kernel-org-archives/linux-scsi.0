From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 16/17] cxlflash: Remove zeroing of private command data
Date: Wed, 21 Jun 2017 21:16:44 -0500
Message-ID: <1498097804-9265-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751998AbdFVCQx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 22:16:53 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5M2EX0Y075394
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:16:53 -0400
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b7r1ncy21-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:16:52 -0400
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 22:16:52 -0400
In-Reply-To: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The SCSI core now zeroes the per-command private data area prior to
calling into the LLD. Replace the clearing operation that takes place
when the private command data reference is obtained with a routine that
performs common initializations. The zeroing that takes place in the
device reset path remains intact as the private command data associated
with the specified SCSI command is not guaranteed to be cleared.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h | 11 +++++++++--
 drivers/scsi/cxlflash/main.c   |  2 +-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index e95e5a5..6d95e8e 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -178,15 +178,22 @@ static inline struct afu_cmd *sc_to_afuc(struct scsi_cmnd *sc)
 	return PTR_ALIGN(scsi_cmd_priv(sc), __alignof__(struct afu_cmd));
 }
 
-static inline struct afu_cmd *sc_to_afucz(struct scsi_cmnd *sc)
+static inline struct afu_cmd *sc_to_afuci(struct scsi_cmnd *sc)
 {
 	struct afu_cmd *afuc = sc_to_afuc(sc);
 
-	memset(afuc, 0, sizeof(*afuc));
 	INIT_LIST_HEAD(&afuc->queue);
 	return afuc;
 }
 
+static inline struct afu_cmd *sc_to_afucz(struct scsi_cmnd *sc)
+{
+	struct afu_cmd *afuc = sc_to_afuc(sc);
+
+	memset(afuc, 0, sizeof(*afuc));
+	return sc_to_afuci(sc);
+}
+
 struct hwq {
 	/* Stuff requiring alignment go first. */
 	struct sisl_ioarcb sq[NUM_SQ_ENTRY];		/* 16K SQ */
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 0cce442..4338982 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -543,7 +543,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	struct cxlflash_cfg *cfg = shost_priv(host);
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
-	struct afu_cmd *cmd = sc_to_afucz(scp);
+	struct afu_cmd *cmd = sc_to_afuci(scp);
 	struct scatterlist *sg = scsi_sglist(scp);
 	int hwq_index = cmd_to_target_hwq(host, scp, afu);
 	struct hwq *hwq = get_hwq(afu, hwq_index);
-- 
2.1.0
