Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997F1C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76CAE610A2
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240222AbhHEKZj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 06:25:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36840 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239963AbhHEKZg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 06:25:36 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175AETU5017423
        for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2021 03:25:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=TkgqGYoBt2lyCxf+7oEEMNwAt/7G0Nkmq3xN/LHg/z4=;
 b=B3SrwGxSrIp81w+c88ZA5fsdh3kwHqo9+LTg0ZipwXmXGw7TH8r3vZef31WP0uENXMMI
 JtHKQ3vdPphKp/VQ6Uoyylho7FF6CcHgmLolWBeChBcnlqAreksYL9K3TpzF+43CjAFr
 VgpljYJa0BABJCQQaNL+/J2d4Q6wduoHH0brKd0SfzYaSomidfUn5rvgzXJAwgFUg+Ui
 roJPciOpVuh6Xx7Lci0vyxJJsWI60QjsW+ZyRDLtzjLaQlLLe5pI9C0b3U1U2hZuorJb
 P+nOrKzF9AFUK3Fjo6yciuEyrYG9L+B+cIZn/mX2NviGNSaxJ1Pgx6XNCDx8gn1pmQME AA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3a8ata0j9s-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 03:25:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 5 Aug
 2021 03:25:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 5 Aug 2021 03:25:19 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BAFB63F705D;
        Thu,  5 Aug 2021 03:25:19 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 175APJTt020307;
        Thu, 5 Aug 2021 03:25:19 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 175APJu3020306;
        Thu, 5 Aug 2021 03:25:19 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 12/14] qla2xxx: Changes to support kdump kernel for NVMe BFS
Date:   Thu, 5 Aug 2021 03:20:03 -0700
Message-ID: <20210805102005.20183-13-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210805102005.20183-1-njavali@marvell.com>
References: <20210805102005.20183-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: eXtjnNhB75ahuPcUMTjIp2-SRYfKARzI
X-Proofpoint-GUID: eXtjnNhB75ahuPcUMTjIp2-SRYfKARzI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_03:2021-08-05,2021-08-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

The MSI-X and MSI calls fails in kdump kernel, because of this
qla2xxx_create_qpair fails leading to .create_queue callback failure.
The fix is to return existing qpair instead of allocating new one and
allocate single hw queue.

[   19.975838] qla2xxx [0000:d8:00.1]-00c7:11: MSI-X: Failed to enable support,
giving   up -- 16/-28.
[   19.984885] qla2xxx [0000:d8:00.1]-0037:11: Falling back-to MSI mode --
ret=-28.
[   19.992278] qla2xxx [0000:d8:00.1]-0039:11: Falling back-to INTa mode --
ret=-28.
..
..
..
[   21.141518] qla2xxx [0000:d8:00.0]-2104:2: qla_nvme_alloc_queue: handle
00000000e7ee499d, idx =1, qsize 32
[   21.151166] qla2xxx [0000:d8:00.0]-0181:2: FW/Driver is not multi-queue capable.
[   21.158558] qla2xxx [0000:d8:00.0]-2122:2: Failed to allocate qpair
[   21.164824] nvme nvme0: NVME-FC{0}: reset: Reconnect attempt failed (-22)
[   21.171612] nvme nvme0: NVME-FC{0}: Reconnect attempt in 2 seconds

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  1 -
 drivers/scsi/qla2xxx/qla_isr.c  |  2 ++
 drivers/scsi/qla2xxx/qla_nvme.c | 40 +++++++++++++++------------------
 3 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 60702d066ed9..55175e8a0749 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4022,7 +4022,6 @@ struct qla_hw_data {
 				/* Enabled in Driver */
 		uint32_t	scm_enabled:1;
 		uint32_t	edif_enabled:1;
-		uint32_t	max_req_queue_warned:1;
 		uint32_t	plogi_template_valid:1;
 		uint32_t	port_isolated:1;
 	} flags;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b0b5af21781a..ba4a5bf5600a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4508,6 +4508,8 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 		ql_dbg(ql_dbg_init, vha, 0x0125,
 		    "INTa mode: Enabled.\n");
 		ha->flags.mr_intr_valid = 1;
+		/* Set max_qpair to 0, as MSI-X and MSI in not enabled */
+		ha->max_qpairs = 0;
 	}
 
 clear_risc_ints:
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 6f3c0a506509..94e350ef3028 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -108,19 +108,24 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 		return -EINVAL;
 	}
 
-	if (ha->queue_pair_map[qidx]) {
-		*handle = ha->queue_pair_map[qidx];
-		ql_log(ql_log_info, vha, 0x2121,
-		    "Returning existing qpair of %px for idx=%x\n",
-		    *handle, qidx);
-		return 0;
-	}
+	/* Use base qpair if max_qpairs is 0 */
+	if (!ha->max_qpairs) {
+		qpair = ha->base_qpair;
+	} else {
+		if (ha->queue_pair_map[qidx]) {
+			*handle = ha->queue_pair_map[qidx];
+			ql_log(ql_log_info, vha, 0x2121,
+			       "Returning existing qpair of %px for idx=%x\n",
+			       *handle, qidx);
+			return 0;
+		}
 
-	qpair = qla2xxx_create_qpair(vha, 5, vha->vp_idx, true);
-	if (qpair == NULL) {
-		ql_log(ql_log_warn, vha, 0x2122,
-		    "Failed to allocate qpair\n");
-		return -EINVAL;
+		qpair = qla2xxx_create_qpair(vha, 5, vha->vp_idx, true);
+		if (!qpair) {
+			ql_log(ql_log_warn, vha, 0x2122,
+			       "Failed to allocate qpair\n");
+			return -EINVAL;
+		}
 	}
 	*handle = qpair;
 
@@ -731,18 +736,9 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 
 	WARN_ON(vha->nvme_local_port);
 
-	if (ha->max_req_queues < 3) {
-		if (!ha->flags.max_req_queue_warned)
-			ql_log(ql_log_info, vha, 0x2120,
-			       "%s: Disabling FC-NVME due to lack of free queue pairs (%d).\n",
-			       __func__, ha->max_req_queues);
-		ha->flags.max_req_queue_warned = 1;
-		return ret;
-	}
-
 	qla_nvme_fc_transport.max_hw_queues =
 	    min((uint8_t)(qla_nvme_fc_transport.max_hw_queues),
-		(uint8_t)(ha->max_req_queues - 2));
+		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
 
 	pinfo.node_name = wwn_to_u64(vha->node_name);
 	pinfo.port_name = wwn_to_u64(vha->port_name);
-- 
2.19.0.rc0

