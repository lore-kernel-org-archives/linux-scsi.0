Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CD1EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 07:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbjGNHBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 03:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbjGNHBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 03:01:16 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B8D2707
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:15 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DLV6ch030902
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=SBu2ieNxx34XL8mQNQGykixy/DuEBtxFwz7d3r2+91A=;
 b=cUa0dISu8JAUT3dsRJCEEXy+cCzsSqNGh7Sz+5KBK4onArPm7uP2Xa/fjZhODs4j8qGW
 tGXxKi75ce/JTOaiehrs0SJkzF1CjRMx7NmqwAeKz/oC1fcvEXdP0VVWhyIk0GcJ3d2u
 M4JpKh9LxeA3/7ceDzRGUpkPq6qQwy70AKdSkFeBEjHLXvegRp4PSLHuyCSw0FDFDnTA
 vojtDIlUHDXE9QygEtJnUUhTifVwfO13f7QVsAXf4Ak2/+rn40zUs92TfWhuBaDx4Au6
 c7VDDzfn6wFw0YN5bSz19ORWZQ1btgRnjpiG6baidINjp/IEk5vi5xw8udEEBgfaAODL 2A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3rtptx9rxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 14 Jul
 2023 00:01:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 14 Jul 2023 00:01:12 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id D53733F706B;
        Fri, 14 Jul 2023 00:01:10 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 02/10] qla2xxx: Adjust iocb resource on qpair create
Date:   Fri, 14 Jul 2023 12:30:56 +0530
Message-ID: <20230714070104.40052-3-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230714070104.40052-1-njavali@marvell.com>
References: <20230714070104.40052-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: tHoaTk80Eyfoclijw8yGWjq0X9xhihUb
X-Proofpoint-ORIG-GUID: tHoaTk80Eyfoclijw8yGWjq0X9xhihUb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_04,2023-07-13_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

During NVME queue creation, a new qpair is created, FW resource limit
need to be re-adjusted to take into account of the new qpair. Otherwise,
NVME command can not go through.
This issue was discovered while testing/forcing FW execution to fail at
load time.

Add call to readjust iocb and exchange limit.

In addition, get fw state command require FW to be running. Otherwise,
error is generated.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
v2:
- Remove extra line in qla_gbl.h

 drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
 drivers/scsi/qla2xxx/qla_init.c | 52 +++++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_mbx.c  |  3 ++
 drivers/scsi/qla2xxx/qla_nvme.c |  1 +
 4 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ba7831f24734..33fba9d62969 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -143,6 +143,7 @@ void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess);
 void qla_edif_clear_appdata(struct scsi_qla_host *vha,
 			    struct fc_port *fcport);
 const char *sc_to_str(uint16_t cmd);
+void qla_adjust_iocb_limit(scsi_qla_host_t *vha);
 
 /*
  * Global Data in qla_os.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f8f64ed4de07..60dd0e415351 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4153,41 +4153,55 @@ qla24xx_detect_sfp(scsi_qla_host_t *vha)
 	return ha->flags.lr_detected;
 }
 
-void qla_init_iocb_limit(scsi_qla_host_t *vha)
+static void __qla_adjust_iocb_limit(struct qla_qpair *qpair)
 {
-	u16 i, num_qps;
-	u32 limit;
-	struct qla_hw_data *ha = vha->hw;
+	u8 num_qps;
+	u16 limit;
+	struct qla_hw_data *ha = qpair->vha->hw;
 
 	num_qps = ha->num_qpairs + 1;
 	limit = (ha->orig_fw_iocb_count * QLA_IOCB_PCT_LIMIT) / 100;
 
-	ha->base_qpair->fwres.iocbs_total = ha->orig_fw_iocb_count;
-	ha->base_qpair->fwres.iocbs_limit = limit;
-	ha->base_qpair->fwres.iocbs_qp_limit = limit / num_qps;
-	ha->base_qpair->fwres.iocbs_used = 0;
+	qpair->fwres.iocbs_total = ha->orig_fw_iocb_count;
+	qpair->fwres.iocbs_limit = limit;
+	qpair->fwres.iocbs_qp_limit = limit / num_qps;
+
+	qpair->fwres.exch_total = ha->orig_fw_xcb_count;
+	qpair->fwres.exch_limit = (ha->orig_fw_xcb_count *
+				   QLA_IOCB_PCT_LIMIT) / 100;
+}
+
+void qla_init_iocb_limit(scsi_qla_host_t *vha)
+{
+	u8 i;
+	struct qla_hw_data *ha = vha->hw;
 
-	ha->base_qpair->fwres.exch_total = ha->orig_fw_xcb_count;
-	ha->base_qpair->fwres.exch_limit = (ha->orig_fw_xcb_count *
-					    QLA_IOCB_PCT_LIMIT) / 100;
+	 __qla_adjust_iocb_limit(ha->base_qpair);
+	ha->base_qpair->fwres.iocbs_used = 0;
 	ha->base_qpair->fwres.exch_used  = 0;
 
 	for (i = 0; i < ha->max_qpairs; i++) {
 		if (ha->queue_pair_map[i])  {
-			ha->queue_pair_map[i]->fwres.iocbs_total =
-				ha->orig_fw_iocb_count;
-			ha->queue_pair_map[i]->fwres.iocbs_limit = limit;
-			ha->queue_pair_map[i]->fwres.iocbs_qp_limit =
-				limit / num_qps;
+			__qla_adjust_iocb_limit(ha->queue_pair_map[i]);
 			ha->queue_pair_map[i]->fwres.iocbs_used = 0;
-			ha->queue_pair_map[i]->fwres.exch_total = ha->orig_fw_xcb_count;
-			ha->queue_pair_map[i]->fwres.exch_limit =
-				(ha->orig_fw_xcb_count * QLA_IOCB_PCT_LIMIT) / 100;
 			ha->queue_pair_map[i]->fwres.exch_used = 0;
 		}
 	}
 }
 
+void qla_adjust_iocb_limit(scsi_qla_host_t *vha)
+{
+	u8 i;
+	struct qla_hw_data *ha = vha->hw;
+
+	__qla_adjust_iocb_limit(ha->base_qpair);
+
+	for (i = 0; i < ha->max_qpairs; i++) {
+		if (ha->queue_pair_map[i])
+			__qla_adjust_iocb_limit(ha->queue_pair_map[i]);
+	}
+}
+
 /**
  * qla2x00_setup_chip() - Load and start RISC firmware.
  * @vha: HA context
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 254fd4c64262..b05f93037875 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2213,6 +2213,9 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1054,
 	    "Entered %s.\n", __func__);
 
+	if (!ha->flags.fw_started)
+		return QLA_FUNCTION_FAILED;
+
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
 	if (IS_FWI2_CAPABLE(vha->hw))
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 86e85f2f4782..6769c40287b9 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -132,6 +132,7 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 			       "Failed to allocate qpair\n");
 			return -EINVAL;
 		}
+		qla_adjust_iocb_limit(vha);
 	}
 	*handle = qpair;
 
-- 
2.23.1

