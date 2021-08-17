Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F328C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EEFE60F5E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhHQFOY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:14:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43588 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233861AbhHQFOX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 01:14:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17GMLCqV012247
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=2aehGJq2LIK9qSme0lTF+q/mDH5AD4/eoOvt+K4UDek=;
 b=iP0zldps/aopg9prKrc5zIYGKIasS/Z/HbpH2rZNPNNifF5CwR8pkTmjUCPU/cn/6NcO
 wB4fDLvpo/uFKxtwnVuT9lTWwEb6KI8OSKvJDFkpXCPCDmNHTI4ZceKDDiv+aWgUWRkU
 OOAA13rMM0QtrnN62XRLSN9MuMS6/oi5//jtxmNv4hZmrNjFGb5pk9WFe7ZStV1ufqeJ
 fh6ge0OeXHT3OLcTCkwAl7PPIYfY5W3owW/TeK1M1nXS1gqFdcMmTSr7Qb6/2Z7hzv/L
 U1Q07taFbV3SeZeBCdzDqoNOX/Rmuwe8hbpCQaI+rTZurXsSRZNPc41+5WY+PIfPPtlR mQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ag0qxh1ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 22:13:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 22:13:48 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 01BD03F70AB;
        Mon, 16 Aug 2021 22:13:47 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17H5DgU0002516;
        Mon, 16 Aug 2021 22:13:42 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17H5Db0U002515;
        Mon, 16 Aug 2021 22:13:37 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 01/12] qla2xxx: edif: Fix stale session
Date:   Mon, 16 Aug 2021 22:13:04 -0700
Message-ID: <20210817051315.2477-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210817051315.2477-1-njavali@marvell.com>
References: <20210817051315.2477-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PiFza-vHWXO-dz8y4n2cU5rz4x3FzAYY
X-Proofpoint-GUID: PiFza-vHWXO-dz8y4n2cU5rz4x3FzAYY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

FW indicates session has been torn down via UPDATE SA IOCB
or ELS Passthrough IOCB, driver need to also tear down the
session.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 8 ++++++++
 drivers/scsi/qla2xxx/qla_edif.h | 2 ++
 drivers/scsi/qla2xxx/qla_isr.c  | 1 +
 3 files changed, 11 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 2db954a7aaf1..7d16955383dd 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2674,6 +2674,14 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
 		    __func__, pkt->sa_index, nport_handle);
 		qla_edif_sadb_delete_sa_index(sp->fcport, nport_handle,
 		    le16_to_cpu(pkt->sa_index));
+		switch (le16_to_cpu(pkt->u.comp_sts)) {
+		case CS_PORT_EDIF_UNAVAIL:
+		case CS_PORT_EDIF_LOGOUT:
+			qlt_schedule_sess_for_deletion(sp->fcport);
+			break;
+		default:
+			break;
+		}
 	}
 
 	sp->done(sp, 0);
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 1cff02e5bd43..88495df9a3c2 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -63,6 +63,8 @@ struct sa_update_28xx {
 	union {
 		__le16 nport_handle;  /* in: N_PORT handle. */
 		__le16 comp_sts;              /* out: completion status */
+#define CS_PORT_EDIF_UNAVAIL	0x28
+#define CS_PORT_EDIF_LOGOUT	0x29
 #define CS_PORT_EDIF_SUPP_NOT_RDY 0x64
 #define CS_PORT_EDIF_INV_REQ      0x66
 	} u;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index cb02dade85f8..c2fc75a9ca61 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2235,6 +2235,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 			} else if (comp_status == CS_PORT_LOGGED_OUT) {
 				els->u.els_plogi.len = 0;
 				res = DID_IMM_RETRY << 16;
+				qlt_schedule_sess_for_deletion(sp->fcport);
 			} else {
 				els->u.els_plogi.len = 0;
 				res = DID_ERROR << 16;
-- 
2.23.1

