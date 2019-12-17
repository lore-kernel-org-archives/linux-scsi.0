Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A98C2D0BF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA98921582
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:06:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DQ7Jj53+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfLQWGt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:06:49 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40126 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725940AbfLQWGt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:06:49 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM59sx027778;
        Tue, 17 Dec 2019 14:06:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=LWCfbpX8dXDg6AkhjE1OCLZpUznUqjoxvyvRdZaSgjc=;
 b=DQ7Jj53+tGPUhwylFpPzs3nCj02LgOu6d7IjDCfIostMTiTENhvb0H8I6EUc4mD4WNwB
 O2rRqKKF1d0ttCtCW9znSwQJOaDNL+BDZuHMhyXahcZ+iREo0MF7C/NitMBpB2FNN5Rd
 /+lL0SDvCHKx5/FQxmlEZgoESb3nYIayGIFOQ0J/l4Ph24ktyT7dcEsCR/G6LceOnjA+
 x7mnFYJVKzs6yGA/5mhRGioQ2RvLRfjbankbT0a5yj8LmNE3bkT5x5fGF2b8AAkLwlCu
 YDsLs8eKhaoVe+EtjEegL/rvtDsGLFHZmh6giKU53ae5PobKZq7vAZ/Ao+njMOkPVx7A BA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wxneav08c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:06:48 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:37 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:37 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DA93F3F7040;
        Tue, 17 Dec 2019 14:06:37 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6bND028155;
        Tue, 17 Dec 2019 14:06:37 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6bYn028154;
        Tue, 17 Dec 2019 14:06:37 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 07/14] qla2xxx: Use common routine to free fcport struct
Date:   Tue, 17 Dec 2019 14:06:10 -0800
Message-ID: <20191217220617.28084-8-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191217220617.28084-1-hmadhani@marvell.com>
References: <20191217220617.28084-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

This patch does not change any any functionality.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  | 9 +++++----
 drivers/scsi/qla2xxx/qla_gbl.h  | 1 +
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 drivers/scsi/qla2xxx/qla_mr.c   | 6 +++---
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index cbaf178fc979..2b3702b20c94 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -54,7 +54,8 @@ void qla2x00_bsg_sp_free(srb_t *sp)
 	if (sp->type == SRB_CT_CMD ||
 	    sp->type == SRB_FXIOCB_BCMD ||
 	    sp->type == SRB_ELS_CMD_HST)
-		kfree(sp->fcport);
+		qla2x00_free_fcport(sp->fcport);
+
 	qla2x00_rel_sp(sp);
 }
 
@@ -405,7 +406,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 
 done_free_fcport:
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS)
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 done:
 	return rval;
 }
@@ -545,7 +546,7 @@ qla2x00_process_ct(struct bsg_job *bsg_job)
 	return rval;
 
 done_free_fcport:
-	kfree(fcport);
+	qla2x00_free_fcport(fcport);
 done_unmap_sg:
 	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
@@ -2049,7 +2050,7 @@ qlafx00_mgmt_cmd(struct bsg_job *bsg_job)
 	return rval;
 
 done_free_fcport:
-	kfree(fcport);
+	qla2x00_free_fcport(fcport);
 
 done_unmap_rsp_sg:
 	if (piocb_rqst->flags & SRB_FXDISC_RESP_DMA_VALID)
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index dec295f077d2..2a64729a2bc5 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -198,6 +198,7 @@ extern void qla2x00_free_host(struct scsi_qla_host *);
 extern void qla2x00_relogin(struct scsi_qla_host *);
 extern void qla2x00_do_work(struct scsi_qla_host *);
 extern void qla2x00_free_fcports(struct scsi_qla_host *);
+extern void qla2x00_free_fcport(fc_port_t *);
 
 extern void qla83xx_schedule_work(scsi_qla_host_t *, int);
 extern void qla83xx_service_idc_aen(struct work_struct *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index dd59bd30badd..67f7c21edb4c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5246,7 +5246,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	}
 
 cleanup_allocation:
-	kfree(new_fcport);
+	qla2x00_free_fcport(new_fcport);
 
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_disc, vha, 0x2098,
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index cb830d79cfbe..bad043c40622 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1212,7 +1212,7 @@ qlafx00_find_all_targets(scsi_qla_host_t *vha,
 				    fcport->old_tgt_id);
 				qla2x00_mark_device_lost(vha, fcport, 0);
 				set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-				kfree(new_fcport);
+				qla2x00_free_fcport(new_fcport);
 				return rval;
 			}
 			break;
@@ -1230,7 +1230,7 @@ qlafx00_find_all_targets(scsi_qla_host_t *vha,
 			return QLA_MEMORY_ALLOC_FAILED;
 	}
 
-	kfree(new_fcport);
+	qla2x00_free_fcport(new_fcport);
 	return rval;
 }
 
@@ -1298,7 +1298,7 @@ qlafx00_configure_all_targets(scsi_qla_host_t *vha)
 	/* Free all new device structures not processed. */
 	list_for_each_entry_safe(fcport, rmptemp, &new_fcports, list) {
 		list_del(&fcport->list);
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 	}
 
 	return rval;
-- 
2.12.0

