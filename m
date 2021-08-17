Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A80BC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 814D360FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbhHQFOd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:14:33 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8368 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237669AbhHQFOZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 01:14:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2m1BN006952
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=g4wYAqQDPEd++gx4zsyWf896hrYxZHnDxYhiGL0uj7s=;
 b=kGxkjyvK2aNrTK5xT2PmXtTCPTootXAB20a7Gcy0LIpfRGOEGS7QwGeWb3I9Y7acYKBP
 VaOPxfRgZh4mLkLrocSkQov+lt7n4JYf4Pc8Xzpbv7kn6tScmJ4xNCN6UKcW3LEQv1wz
 YpiC3Q6wgE61Vh1lZ+ORXMV32A6MzJ35yBjMtH+wy8WgdRlZ6/1o8Dh0h5JINOACrRBB
 mgPctqRcd6yovUwatPZZyHc02Xl93Nfo/guDnoZDL0pIjl2bxfmv7lT0dbSPQKBVxRBk
 HCm1ozduC7sUaXkL4b6JKLA2I3z0DaJ5oEUvkOnZV7StMROLtmgbkgxTvf/nme1L6kTj 6A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0rdcu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:53 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 22:13:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 22:13:51 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BC27A3F70B2;
        Mon, 16 Aug 2021 22:13:51 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17H5Dp6f002552;
        Mon, 16 Aug 2021 22:13:51 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17H5DpeU002551;
        Mon, 16 Aug 2021 22:13:51 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 10/12] qla2xxx: fix NVME session down detection
Date:   Mon, 16 Aug 2021 22:13:13 -0700
Message-ID: <20210817051315.2477-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210817051315.2477-1-njavali@marvell.com>
References: <20210817051315.2477-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: GXdcrOjPcdwoqi2RfKhe00XkRCXdJoK_
X-Proofpoint-ORIG-GUID: GXdcrOjPcdwoqi2RfKhe00XkRCXdJoK_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

When Target port transition its personality from one to another
(NVME <--> FCP), there could be some overlap of the two where
one layer is going down while the other layer is coming up. This
overlap can cause temporary IO error. This patch detects those
error/transition and recover from it. This patch triggers session
tear down and allow relogin to re-drive the connection under the
following conditions:

- NVME command error
- On prlo + N2N (rida format 2)

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 12 +++++++-----
 drivers/scsi/qla2xxx/qla_isr.c  |  9 +++++++++
 drivers/scsi/qla2xxx/qla_mbx.c  | 10 ++++++++++
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 4a0a5b4e688d..d09776b77af2 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2733,12 +2733,14 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	 * final cleanup of firmware resources (PCBs and XCBs).
 	 */
 	if (fcport->loop_id != FC_NO_LOOP_ID) {
-		if (IS_FWI2_CAPABLE(fcport->vha->hw))
-			fcport->vha->hw->isp_ops->fabric_logout(fcport->vha,
-			    fcport->loop_id, fcport->d_id.b.domain,
-			    fcport->d_id.b.area, fcport->d_id.b.al_pa);
-		else
+		if (IS_FWI2_CAPABLE(fcport->vha->hw)) {
+			if (fcport->loop_id != FC_NO_LOOP_ID)
+				fcport->logout_on_delete = 1;
+
+			qlt_schedule_sess_for_deletion(fcport);
+		} else {
 			qla2x00_port_logout(fcport->vha, fcport);
+		}
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c2fc75a9ca61..ece60267b971 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2652,6 +2652,15 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	case CS_PORT_UNAVAILABLE:
 	case CS_PORT_LOGGED_OUT:
 		fcport->nvme_flag |= NVME_FLAG_RESETTING;
+		if (atomic_read(&fcport->state) == FCS_ONLINE) {
+			ql_dbg(ql_dbg_disc, fcport->vha, 0x3021,
+			       "Port to be marked lost on fcport=%06x, current "
+			       "port state= %s comp_status %x.\n",
+			       fcport->d_id.b24, port_state_str[FCS_ONLINE],
+			       comp_status);
+
+			qlt_schedule_sess_for_deletion(fcport);
+		}
 		fallthrough;
 	case CS_ABORTED:
 	case CS_PORT_BUSY:
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 438af0d55135..7811c4952035 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4190,6 +4190,16 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				rptid_entry->u.f2.remote_nport_id[1];
 			fcport->d_id.b.al_pa =
 				rptid_entry->u.f2.remote_nport_id[0];
+
+			/*
+			 * For the case where remote port sending PRLO, FW
+			 * sends up RIDA Format 2 as an indication of session
+			 * loss. In other word, FW state change from PRLI
+			 * complete back to PLOGI complete. Delete the
+			 * session and let relogin drive the reconnect.
+			 */
+			if (atomic_read(&fcport->state) == FCS_ONLINE)
+				qlt_schedule_sess_for_deletion(fcport);
 		}
 	}
 }
-- 
2.23.1

