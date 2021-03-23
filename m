Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C608FC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7513D619AB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCWEpB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:45:01 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18556 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229547AbhCWEpA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 00:45:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12N4faxw003467
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:45:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=CzVs3LChVPnLXTMEBApGcc9gr8qXsSuO6Swa8NtePfU=;
 b=a3jne6CbMbbCznSUKxfXdcpBieLWZVtvDsAlb9ZfP8kBt9il5LYiJQlR5h3EjzqHjX9U
 84Ggzso5YqtbpY1qbofoqHQdYUimmu2L0Gwij2abktSg+H2rYujBuC92F+zN3vVIAkjq
 2yLKu8PrwWtlUHHi5R/UEKYB2Jqq4k5M6NbttvNjXn2fw+CCrp3R2USm+6cUdIy0OmJ8
 YYlYxRN/PW0qKqgyjraF6HO03Cvx1DloWpz7/VH7mCDgIkeWPavUj87hv/Sjah46P/Ym
 RwEXyMC1OxuEbauqOpMpC4oZr4Y///9t3cG9QPmhQpJgXYoZmxWo0TydSqwg7RFcg6NW Ag== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrfsng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:45:00 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 21:44:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 21:44:58 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AC8513F703F;
        Mon, 22 Mar 2021 21:44:58 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12N4iwJU026733;
        Mon, 22 Mar 2021 21:44:58 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12N4iwxe026723;
        Mon, 22 Mar 2021 21:44:58 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 04/11] qla2xxx: consolidate zio threshold setting for both fcp & nvme
Date:   Mon, 22 Mar 2021 21:42:50 -0700
Message-ID: <20210323044257.26664-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210323044257.26664-1-njavali@marvell.com>
References: <20210323044257.26664-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_01:2021-03-22,2021-03-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

consolidate zio threshold setting for both fcp & nvme to prevent
one protocol from clobbering the setting of the other protocol.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  1 -
 drivers/scsi/qla2xxx/qla_os.c  | 34 ++++++++++++++--------------------
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 49b42b430df4..3d09f31895e7 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4727,7 +4727,6 @@ typedef struct scsi_qla_host {
 #define FX00_CRITEMP_RECOVERY	25
 #define FX00_HOST_INFO_RESEND	26
 #define QPAIR_ONLINE_CHECK_NEEDED	27
-#define SET_NVME_ZIO_THRESHOLD_NEEDED	28
 #define DETECT_SFP_CHANGE	29
 #define N2N_LOGIN_NEEDED	30
 #define IOCB_WORK_ACTIVE	31
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 074392560f3d..6563d69706ba 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6969,28 +6969,23 @@ qla2x00_do_dpc(void *data)
 			mutex_unlock(&ha->mq_lock);
 		}
 
-		if (test_and_clear_bit(SET_NVME_ZIO_THRESHOLD_NEEDED,
-		    &base_vha->dpc_flags)) {
+		if (test_and_clear_bit(SET_ZIO_THRESHOLD_NEEDED,
+				       &base_vha->dpc_flags)) {
+			u16 threshold = ha->nvme_last_rptd_aen + ha->last_zio_threshold;
+
+			if (threshold > ha->orig_fw_xcb_count)
+				threshold = ha->orig_fw_xcb_count;
+
 			ql_log(ql_log_info, base_vha, 0xffffff,
-				"nvme: SET ZIO Activity exchange threshold to %d.\n",
-						ha->nvme_last_rptd_aen);
-			if (qla27xx_set_zio_threshold(base_vha,
-			    ha->nvme_last_rptd_aen)) {
+			       "SET ZIO Activity exchange threshold to %d.\n",
+			       threshold);
+			if (qla27xx_set_zio_threshold(base_vha, threshold)) {
 				ql_log(ql_log_info, base_vha, 0xffffff,
-				    "nvme: Unable to SET ZIO Activity exchange threshold to %d.\n",
-				    ha->nvme_last_rptd_aen);
+				       "Unable to SET ZIO Activity exchange threshold to %d.\n",
+				       threshold);
 			}
 		}
 
-		if (test_and_clear_bit(SET_ZIO_THRESHOLD_NEEDED,
-		    &base_vha->dpc_flags)) {
-			ql_log(ql_log_info, base_vha, 0xffffff,
-			    "SET ZIO Activity exchange threshold to %d.\n",
-			    ha->last_zio_threshold);
-			qla27xx_set_zio_threshold(base_vha,
-			    ha->last_zio_threshold);
-		}
-
 		if (!IS_QLAFX00(ha))
 			qla2x00_do_dpc_all_vps(base_vha);
 
@@ -7218,14 +7213,13 @@ qla2x00_timer(struct timer_list *t)
 	index = atomic_read(&ha->nvme_active_aen_cnt);
 	if (!vha->vp_idx &&
 	    (index != ha->nvme_last_rptd_aen) &&
-	    (index >= DEFAULT_ZIO_THRESHOLD) &&
 	    ha->zio_mode == QLA_ZIO_MODE_6 &&
 	    !ha->flags.host_shutting_down) {
+		ha->nvme_last_rptd_aen = atomic_read(&ha->nvme_active_aen_cnt);
 		ql_log(ql_log_info, vha, 0x3002,
 		    "nvme: Sched: Set ZIO exchange threshold to %d.\n",
 		    ha->nvme_last_rptd_aen);
-		ha->nvme_last_rptd_aen = atomic_read(&ha->nvme_active_aen_cnt);
-		set_bit(SET_NVME_ZIO_THRESHOLD_NEEDED, &vha->dpc_flags);
+		set_bit(SET_ZIO_THRESHOLD_NEEDED, &vha->dpc_flags);
 		start_dpc++;
 	}
 
-- 
2.19.0.rc0

