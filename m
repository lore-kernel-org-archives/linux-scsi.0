Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5121DC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3869D60F5C
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237834AbhHQFO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:14:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53054 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234143AbhHQFOZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 01:14:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2m1BL006952
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=4Ig5RIKqw4w/cxu6MP+wzbzDsMebEf5nM4xIyx+m424=;
 b=gW53EDuLA391P18L1xxmXRQXwbIOOgEDE5Aklt8vSUzOSW0iCSLsLaxG3vIQ+bC/k6O5
 +eKkQNBr1WOiwEvgeLG7JsqhGH9O7643ghyuNEH7BTHuBkG12qtweUuqkHSGQe9kGTsO
 ipHvn93bFO8DqaXf9fUl+vzqAGpK4tdbqGmCdKsNp1mVPY2qLt5kkXfOjJhXOAdBJ0zf
 3wXkvGEiLtKCPnGZXlP6ctBP/gDJRsVJ9viF1onKF3dvbZudS0jSr10pLGcb5A63jCEN
 kTbjCfy2wH33gZMW/VVV8TCeFROnWDdkfDCn8Vmmq4Xa1yhNWvKHFxuhWt+TrtYSRw7s fA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0rdcu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 22:13:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 22:13:51 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 19C1F3F70AB;
        Mon, 16 Aug 2021 22:13:51 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17H5Do5A002528;
        Mon, 16 Aug 2021 22:13:50 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17H5DoDe002527;
        Mon, 16 Aug 2021 22:13:50 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 04/12] qla2xxx: Fix hang during NVME session tear down
Date:   Mon, 16 Aug 2021 22:13:07 -0700
Message-ID: <20210817051315.2477-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210817051315.2477-1-njavali@marvell.com>
References: <20210817051315.2477-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: f8gsaV2tajtXLwF7q_fIeRZPGIp1UWG9
X-Proofpoint-ORIG-GUID: f8gsaV2tajtXLwF7q_fIeRZPGIp1UWG9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

The following hung task call trace was seen:

    [ 1230.183294] INFO: task qla2xxx_wq:523 blocked for more than 120 seconds.
    [ 1230.197749] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [ 1230.205585] qla2xxx_wq      D    0   523      2 0x80004000
    [ 1230.205636] Workqueue: qla2xxx_wq qlt_free_session_done [qla2xxx]
    [ 1230.205639] Call Trace:
    [ 1230.208100]  __schedule+0x2c4/0x700
    [ 1230.211607]  schedule+0x38/0xa0
    [ 1230.214769]  schedule_timeout+0x246/0x2f0
    [ 1230.222651]  wait_for_completion+0x97/0x100
    [ 1230.226921]  qlt_free_session_done+0x6a0/0x6f0 [qla2xxx]
    [ 1230.232254]  process_one_work+0x1a7/0x360

..when device side port resets were done.

Abort threads were getting out without processing due to the "deleted"
flag check. The delete thread, meanwhile, could not proceed with a
logout (that would have cleared out pending requests) as the logout iocb
work was not progressing. It appears like the hung qlt_free_session_done()
thread is causing the ha->wq works on hold. The qlt_free_session_done()
was hung waiting for nvme_fc_unregister_remoteport() + localport_delete cb
to be complete, which would only happen when all IOs are released.

Fix this by allowing abort to progress until device delete is completely
done. This should make the qlt_free_session_done proceed without hang
and thus clear up the deadlock.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 05cad06ff165..d294b590581e 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -233,7 +233,7 @@ static void qla_nvme_abort_work(struct work_struct *work)
 	       "%s called for sp=%p, hndl=%x on fcport=%p deleted=%d\n",
 	       __func__, sp, sp->handle, fcport, fcport->deleted);
 
-	if (!ha->flags.fw_started || fcport->deleted)
+	if (!ha->flags.fw_started || fcport->deleted == QLA_SESS_DELETED)
 		goto out;
 
 	if (ha->flags.host_shutting_down) {
-- 
2.23.1

