Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87514C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 03:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F4CE6103D
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 03:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhIYDyL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 23:54:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51280 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233807AbhIYDyK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Sep 2021 23:54:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18OFaWr0011076;
        Fri, 24 Sep 2021 20:52:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=QNQ2ZVjJZvEhKaYscnXDq2vQUNwVRMcaUykGOJr4xBk=;
 b=LckmN5+M0TZAa/1RG30cIK/q+BvoZISiGY/NxFFT95gvQ5A65hv6ha+sI67o/Urq5Alk
 2hboq5vVC5ikkYryVQ76oiyHVrLIR03uKFyjHbuGFSYJ8v1RhjFT614J7zqLcYf/W+So
 kuOr4A97UdQhmjsgDBUmmlYp07hKWGlAJq72sxP7UbuVoZP/6TdoHaA+OA4U7jmMDEZ6
 8N5bbdBp7Xqg09CEkQuGXUVlzFUVcNLRQQT68sYwD5wub1hTp0XTnuEWyvcQNUSC87TD
 Y5YOs6EQDtiEaUHgpmu1qvWoaHVUOl7bEjQc76s7jA49uqkNSm1X5WfJMI8hu+Te7jdW fA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3b9hf51tpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Sep 2021 20:52:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 20:52:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 24 Sep 2021 20:52:32 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6790C3F708A;
        Fri, 24 Sep 2021 20:52:32 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 18P3qJgr029859;
        Fri, 24 Sep 2021 20:52:22 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 18P3ps1h029850;
        Fri, 24 Sep 2021 20:51:54 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <emilne@redhat.com>
Subject: [PATCH] qla2xxx: Fix excessive messages during device logout
Date:   Fri, 24 Sep 2021 20:51:54 -0700
Message-ID: <20210925035154.29815-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: x0Mt_rfxSPyr6BHSOanI9gyxeSGk4EJb
X-Proofpoint-ORIG-GUID: x0Mt_rfxSPyr6BHSOanI9gyxeSGk4EJb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-24_05,2021-09-24_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Disable default logging of some IO path messages which can be
turned back on by setting ql2xextended_error_logging.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ece60267b971..b26f2699adb2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2634,7 +2634,7 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	}
 
 	if (unlikely(logit))
-		ql_log(ql_log_warn, fcport->vha, 0x5060,
+		ql_log(ql_dbg_io, fcport->vha, 0x5060,
 		   "NVME-%s ERR Handling - hdl=%x status(%x) tr_len:%x resid=%x  ox_id=%x\n",
 		   sp->name, sp->handle, comp_status,
 		   fd->transferred_length, le32_to_cpu(sts->residual_len),
@@ -3491,7 +3491,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 out:
 	if (logit)
-		ql_log(ql_log_warn, fcport->vha, 0x3022,
+		ql_log(ql_dbg_io, fcport->vha, 0x3022,
 		       "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%p cp=%p.\n",
 		       comp_status, scsi_status, res, vha->host_no,
 		       cp->device->id, cp->device->lun, fcport->d_id.b.domain,
-- 
2.19.0.rc0

