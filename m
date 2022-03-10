Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83866C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 09:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbiCJJ11 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240757AbiCJJ10 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 04:27:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4AB139CDA
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:25 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22A1dlxF024974
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=BoL/n33aG5zRFRU9CoUdcUwroLvxCnuY0VrxP58aJko=;
 b=W3O8+va/TOxaPDh11FmfU6bKbGjIFgFXHIuVMMm2VR44wi1A46Lxzh98z4fAzjTqTWTp
 aPtD5QVVFlDw08+jFjy3bWg9+tu7CTtObAI2P/+xip1ziTbMbuPyNRNkVn7qpr2y0P5V
 7gky2BHo91tjBX4rgHjKxk2mu0epiHw1ATiyL3PhE6+GEMiG5JJ8fhc3quVxMDJGyTgD
 bSm3uNafuxoimZGqqQP+XOo1DEHd1pM0b1zKDLdSdxOT8bsqXZQuQARqHLpFlwSklV5y
 aBF8n/RSj6VYLYXW0UH8tagoohbZfBvzP8Bm+Iz10d7RxWSMHzh2FEY5FCLO6LPf5Spf zQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38pmd7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:24 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Mar
 2022 01:26:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Mar 2022 01:26:22 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C5B693F7041;
        Thu, 10 Mar 2022 01:26:22 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22A9QMl7022989;
        Thu, 10 Mar 2022 01:26:22 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22A9QMlx022988;
        Thu, 10 Mar 2022 01:26:22 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 01/13] qla2xxx: Fix incorrect reporting of task management failure
Date:   Thu, 10 Mar 2022 01:25:52 -0800
Message-ID: <20220310092604.22950-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com>
References: <20220310092604.22950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: D2kV3luQfUGMUjY_9QLJmPuEKyzZYMbL
X-Proofpoint-ORIG-GUID: D2kV3luQfUGMUjY_9QLJmPuEKyzZYMbL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

User experienced no task management error while target device
is responding with error. The RSP_CODE field in the status
iocb is in little endian. Driver assumes it's big endian,
where it picked up erroneous data.

Convert the data back to big endian as is on the wire,
where current code will pick up correct status.

Cc: stable@vger.kernel.org
Fixes: faef62d13463 ("[SCSI] qla2xxx: Fix Task Management command asynchronous handling")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index aaf6504570fd..198b782d7790 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2498,6 +2498,7 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 		iocb->u.tmf.data = QLA_FUNCTION_FAILED;
 	} else if ((le16_to_cpu(sts->scsi_status) &
 	    SS_RESPONSE_INFO_LEN_VALID)) {
+		host_to_fcp_swap(sts->data, sizeof(sts->data));
 		if (le32_to_cpu(sts->rsp_data_len) < 4) {
 			ql_log(ql_log_warn, fcport->vha, 0x503b,
 			    "Async-%s error - hdl=%x not enough response(%d).\n",
-- 
2.19.0.rc0

