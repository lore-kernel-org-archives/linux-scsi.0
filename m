Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BF2C83F01
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 11:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjHaLVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Aug 2023 07:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjHaLVz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2023 07:21:55 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449BECF3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2023 04:21:52 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V5UHoq011758
        for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2023 04:21:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=mPfbzX+EeydR6jepSb5Tf9N4kxk3qRAHCYghM3+jIEg=;
 b=FRg6xEb1r+K8vVgkIHyrVdDY/TlShNvp/lFl0B3GdGUe9OB72oLeLYC8WR0iZdzfcCmz
 QmYAcB8zBFopuHU58AJQ/0fmrT+nztCiuMPZxPFxqqVxzF7QQlQhH64w6FYOjTz1vJGD
 ydtH2zuSvu+9k6GyePJ+VzvXrUxoJ6/JsJFJ0JhOQNY6zKFa/Jmx/NsOfRC7uquGJSAU
 RDhWepoFZJdQJNqUd88R5QhR/T0fTjirSbFIvZppKpQec24zui1r+xH+VmIQH8JOa+vU
 Pu6UPYrQ0Hy1xTjZKcBD4JTXpyF2hOQFJ2AJlkIf6Gj/sS01dY5RrX/vv5NOqq11Y8iS Gw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3st1y64xqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2023 04:21:51 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 31 Aug
 2023 04:21:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 31 Aug 2023 04:21:49 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 599913F703F;
        Thu, 31 Aug 2023 04:21:47 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH] qla2xxx: correct endianness for rqstlen and rsplen
Date:   Thu, 31 Aug 2023 16:51:45 +0530
Message-ID: <20230831112146.32595-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: -Udbllsspi8ovckF_Zu2oJk9DPk7WkKQ
X-Proofpoint-GUID: -Udbllsspi8ovckF_Zu2oJk9DPk7WkKQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_08,2023-08-31_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

rqstlen and rsplen were changed to __le32 to fix
sparse warnings.

drivers/scsi/qla2xxx/qla_nvme.c:402:30: warning: incorrect type in assignment (different base types)
drivers/scsi/qla2xxx/qla_nvme.c:402:30:    expected restricted __le32 [usertype] cmd_len
drivers/scsi/qla2xxx/qla_nvme.c:402:30:    got unsigned short [usertype] rsplen
drivers/scsi/qla2xxx/qla_nvme.c:507:30: warning: incorrect type in assignment (different base types)
drivers/scsi/qla2xxx/qla_nvme.c:507:30:    expected restricted __le32 [usertype] cmd_len
drivers/scsi/qla2xxx/qla_nvme.c:507:30:    got unsigned int [usertype] rqstlen
drivers/scsi/qla2xxx/qla_nvme.c:508:30: warning: incorrect type in assignment (different base types)
drivers/scsi/qla2xxx/qla_nvme.c:508:30:    expected restricted __le32 [usertype] rsp_len
drivers/scsi/qla2xxx/qla_nvme.c:508:30:    got unsigned int [usertype] rsplen

Correct the endianness in qla2x driver thus avoiding changes in nvme-fc-driver.h.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 10 +++++-----
 include/linux/nvme-fc-driver.h  |  6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index b6eebfcf34b3..72ba3bd828a6 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -399,14 +399,14 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
 	nvme->u.nvme.dl = 0;
 	nvme->u.nvme.timeout_sec = 0;
 	nvme->u.nvme.cmd_dma = fd_resp->rspdma;
-	nvme->u.nvme.cmd_len = fd_resp->rsplen;
+	nvme->u.nvme.cmd_len = cpu_to_le32(fd_resp->rsplen);
 	nvme->u.nvme.rsp_len = 0;
 	nvme->u.nvme.rsp_dma = 0;
 	nvme->u.nvme.exchange_address = uctx->exchange_address;
 	nvme->u.nvme.nport_handle = uctx->nport_handle;
 	nvme->u.nvme.ox_id = uctx->ox_id;
 	dma_sync_single_for_device(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
-				   le32_to_cpu(fd_resp->rsplen), DMA_TO_DEVICE);
+				   fd_resp->rsplen, DMA_TO_DEVICE);
 
 	ql_dbg(ql_dbg_unsol, vha, 0x2122,
 	       "Unsol lsreq portid=%06x %8phC exchange_address 0x%x ox_id 0x%x hdl 0x%x\n",
@@ -504,13 +504,13 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	nvme->u.nvme.desc = fd;
 	nvme->u.nvme.dir = 0;
 	nvme->u.nvme.dl = 0;
-	nvme->u.nvme.cmd_len = fd->rqstlen;
-	nvme->u.nvme.rsp_len = fd->rsplen;
+	nvme->u.nvme.cmd_len = cpu_to_le32(fd->rqstlen);
+	nvme->u.nvme.rsp_len = cpu_to_le32(fd->rsplen);
 	nvme->u.nvme.rsp_dma = fd->rspdma;
 	nvme->u.nvme.timeout_sec = fd->timeout;
 	nvme->u.nvme.cmd_dma = fd->rqstdma;
 	dma_sync_single_for_device(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
-	    le32_to_cpu(fd->rqstlen), DMA_TO_DEVICE);
+	    fd->rqstlen, DMA_TO_DEVICE);
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
index f6ef8cf5d774..4109f1bd6128 100644
--- a/include/linux/nvme-fc-driver.h
+++ b/include/linux/nvme-fc-driver.h
@@ -53,10 +53,10 @@
 struct nvmefc_ls_req {
 	void			*rqstaddr;
 	dma_addr_t		rqstdma;
-	__le32			rqstlen;
+	u32			rqstlen;
 	void			*rspaddr;
 	dma_addr_t		rspdma;
-	__le32			rsplen;
+	u32			rsplen;
 	u32			timeout;
 
 	void			*private;
@@ -120,7 +120,7 @@ struct nvmefc_ls_req {
 struct nvmefc_ls_rsp {
 	void		*rspbuf;
 	dma_addr_t	rspdma;
-	__le32		rsplen;
+	u16		rsplen;
 
 	void (*done)(struct nvmefc_ls_rsp *rsp);
 	void		*nvme_fc_private;	/* LLDD is not to access !! */
-- 
2.23.1

