From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH] cxlflash: Remove unused variable from queuecommand
Date: Wed, 26 Aug 2015 18:36:12 -0500
Message-ID: <1440632172-10180-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:60421 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbbHZXgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2015 19:36:31 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 26 Aug 2015 17:36:30 -0600
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id F088638C8039
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2015 19:36:27 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7QNaRTm56033348
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2015 23:36:27 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7QNaQ1H020307
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2015 19:36:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, mikey@neuling.org, kbuild-all@01.org
Cc: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The queuecommand routine has a local dev pointer used for the
dev_* prints. The two prints that currently exist are tucked
under a debug define and thus can be left out. Use the actual
location instead of a local to avoid this warning.

This patch is intended to be applied after the "CXL Flash Error
Recovery and Superpipe" series.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
---
 drivers/scsi/cxlflash/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 458ed83..3ccb546 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -354,7 +354,6 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
 	struct afu *afu = cfg->afu;
 	struct pci_dev *pdev = cfg->dev;
-	struct device *dev = &cfg->dev->dev;
 	struct afu_cmd *cmd;
 	u32 port_sel = scp->device->channel + 1;
 	int nseg, i, ncount;
@@ -384,11 +383,13 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 
 	switch (cfg->state) {
 	case STATE_LIMBO:
-		dev_dbg_ratelimited(dev, "%s: device in limbo!\n", __func__);
+		dev_dbg_ratelimited(&cfg->dev->dev, "%s: device in limbo!\n",
+				    __func__);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	case STATE_FAILTERM:
-		dev_dbg_ratelimited(dev, "%s: device has failed!\n", __func__);
+		dev_dbg_ratelimited(&cfg->dev->dev, "%s: device has failed!\n",
+				    __func__);
 		scp->result = (DID_NO_CONNECT << 16);
 		scp->scsi_done(scp);
 		rc = 0;
-- 
2.1.0

