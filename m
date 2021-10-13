Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1308C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 12:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB453610F8
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 12:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhJMMrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 08:47:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17758 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234056AbhJMMrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 08:47:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DAVHvd016935
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 05:45:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=TV/hHRS8GB8cJrTE7TF5DgmOZGRf/M058x4yS5ItQW8=;
 b=U06svJ6phRypz6r8UrhMbtVI+i57Vn+RUm+obUkQ+tVFmDj0Qw+LAimxYGVvdngTvHuK
 5x3mhAL/4oTLXzzmJx3/SCzMCLbLRsp30qy3pdv1HSZeSR1hLv8lFR8gS3RBWsvlo++b
 gKEi1Li3PPsJXulyYVRhUfckgSHRvxxlP9J0CTZoV/SJa46aaJnri1CWfmbZX1qfJKb3
 Shf+6EjwAgpO5cRNvDxbclNebW7NJQyz59JbxsaHcpEbyOh4k6qxo/AVIqic93ciDpBR
 ZVNk5upjq0eCh7G9Z2jrcCVFINfNiqDojNKsdCS+Tjdj/GXTOfuhU8joAwSAAWbn/Psi ZA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bnwrxghgw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 05:45:12 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 05:45:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 05:45:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 973363F7051;
        Wed, 13 Oct 2021 05:45:11 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19DCjBrG017234;
        Wed, 13 Oct 2021 05:45:11 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19DCjBBw017233;
        Wed, 13 Oct 2021 05:45:11 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 10/13] qla2xxx: edif: increase ELS payload
Date:   Wed, 13 Oct 2021 05:44:19 -0700
Message-ID: <20211013124422.17151-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211013124422.17151-1-njavali@marvell.com>
References: <20211013124422.17151-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: kP3nAsz0gcLENN23uCYfE2JFr2nsm2f7
X-Proofpoint-GUID: kP3nAsz0gcLENN23uCYfE2JFr2nsm2f7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_05,2021-10-13_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Currently, FW limits ELS payload to FC frame size/2112.
This patch adjust memory buffer size to be able to handle
max ELS payload.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c     | 2 +-
 drivers/scsi/qla2xxx/qla_edif.h     | 3 ++-
 drivers/scsi/qla2xxx/qla_edif_bsg.h | 2 +-
 drivers/scsi/qla2xxx/qla_init.c     | 4 ++++
 drivers/scsi/qla2xxx/qla_os.c       | 2 +-
 5 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index bb3a1afb86a8..1ea130c61d70 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2375,7 +2375,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 		return;
 	}
 
-	if (totlen > MAX_PAYLOAD) {
+	if (totlen > ELS_MAX_PAYLOAD) {
 		ql_dbg(ql_dbg_edif, vha, 0x0910d,
 		    "%s WARNING: verbose ELS frame received (totlen=%x)\n",
 		    __func__, totlen);
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 920b1eace40f..2517005fb08c 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -93,7 +93,6 @@ struct sa_update_28xx {
 };
 
 #define        NUM_ENTRIES     256
-#define        MAX_PAYLOAD     1024
 #define        PUR_GET         1
 
 struct dinfo {
@@ -127,6 +126,8 @@ struct enode {
 	} u;
 };
 
+#define RX_ELS_SIZE (roundup(sizeof(struct enode) + ELS_MAX_PAYLOAD, SMP_CACHE_BYTES))
+
 #define EDIF_SESSION_DOWN(_s) \
 	(qla_ini_mode_enabled(_s->vha) && (_s->disc_state == DSC_DELETE_PEND || \
 	 _s->disc_state == DSC_DELETED || \
diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
index 58b718d35d19..53026d82ebff 100644
--- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -8,7 +8,7 @@
 #define __QLA_EDIF_BSG_H
 
 /* BSG Vendor specific commands */
-#define	ELS_MAX_PAYLOAD		1024
+#define	ELS_MAX_PAYLOAD		2112
 #ifndef	WWN_SIZE
 #define WWN_SIZE		8
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 999e0423891c..2bc5593645ec 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4486,6 +4486,10 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		    (ha->flags.fawwpn_enabled) ? "enabled" : "disabled");
 	}
 
+	/* ELS pass through payload is limit by frame size. */
+	if (ha->flags.edif_enabled)
+		mid_init_cb->init_cb.frame_payload_size = cpu_to_le16(ELS_MAX_PAYLOAD);
+
 	rval = qla2x00_init_firmware(vha, ha->init_cb_size);
 next_check:
 	if (rval) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index df0e46ef3e96..814d082491af 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4352,7 +4352,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 
 	/* allocate the purex dma pool */
 	ha->purex_dma_pool = dma_pool_create(name, &ha->pdev->dev,
-	    MAX_PAYLOAD, 8, 0);
+	    ELS_MAX_PAYLOAD, 8, 0);
 
 	if (!ha->purex_dma_pool) {
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x011b,
-- 
2.19.0.rc0

