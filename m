Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904BBC71153
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 15:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbjHXPQB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 11:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242077AbjHXPP3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 11:15:29 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F29E199D
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:15:28 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37O6mFh3001832
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:15:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=On3eMDGqkZ8GDcC4XNV3SSb9jUdjLkT3JIBLZL8b0w8=;
 b=J+W1y27eaqqpkl2137HYh5qXc5mjv9L9NFx4ed5EW7eBPnyByt7C84Hevko9cxk1oFdC
 Q2Ns4tnnDDGgDscELcqdwqlJbqpcPJuIICUbx9/zl5gie1+C7ggV+Di8YARL9SPb3uGO
 lawMJECgUqcpkuCJWSVNN4cXRhzyMAegSjtmQdXbGHUE2s+FqQGEDcagKIQLbIMfbp6L
 XbFp9I/xb76T0tlwjkYcIIdjEK3xCQ2Z+ONp/lgal+V6HSsxUthuiCLGBrYj/R6DHCM4
 SDkAQnV06MJT/9ayI0sk6731ZPaW+kzWCysu+Zo9naXzLzV6r2o2VzFOlhPOOQrlR4a2 5g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3sn20d045n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:15:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 24 Aug
 2023 08:15:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 24 Aug 2023 08:15:24 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id EA6C93F70A2;
        Thu, 24 Aug 2023 08:15:22 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH] qla2xxx: fix nvme_fc_rcv_ls_req undefined error
Date:   Thu, 24 Aug 2023 20:45:21 +0530
Message-ID: <20230824151521.35261-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: cGHNMCIzYu66inBKQtA1k8GofzJD7ve3
X-Proofpoint-ORIG-GUID: cGHNMCIzYu66inBKQtA1k8GofzJD7ve3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_12,2023-08-24_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The kernel robot reported below build error,

>> ERROR: modpost: "nvme_fc_rcv_ls_req" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!

Use CONFIG_NVME_FC enabled check to fix the build error.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308021445.txlNq7UC-lkp@intel.com/
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 1a31e877e6cb..62a67662cbf3 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1182,10 +1182,12 @@ qla2xxx_process_purls_pkt(struct scsi_qla_host *vha, struct purex_item *item)
 	struct qla_nvme_unsol_ctx *uctx = item->purls_context;
 	fc_port_t *fcport = uctx->fcport;
 	struct qla_nvme_lsrjt_pt_arg a;
-	int ret;
+	int ret = 1;
 
+#if (IS_ENABLED(CONFIG_NVME_FC))
 	ret = nvme_fc_rcv_ls_req(fcport->nvme_remote_port, &uctx->lsrsp,
 				 &item->iocb, item->size);
+#endif
 	if (ret) {
 		ql_dbg(ql_dbg_unsol, vha, 0x2125, "NVMe tranport ls_req failed\n");
 		memset((void *)&a, 0, sizeof(a));
-- 
2.23.1

