Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50123C77B61
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Apr 2023 08:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243220AbjD0IEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Apr 2023 04:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243222AbjD0IEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2023 04:04:08 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32C62D74
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:06 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R7CHrE006786
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=OzQ5pz75Xvys3YHsBXksbbJMT7fUh1Rc3WWR+nYLcjQ=;
 b=bxRTBuzTu2KuAFDc8hZnq+o4BCntBE3qDdGQZoEmBvbvvdeChEB92/rDCmlq9cInQrz8
 qnZzsOVfSab/oWpVbAym7DIVTwVgl4bTBV3PldwrMG+NTeC13OD8lv+vdWwdWvXhfCKV
 NwTq/vNL3q1hKOifvk9dCNLqDm8QtHCXLJs/AeyCS4APhidgGX1ihW4ZkXUPpRXjmN3l
 QZfYaQRigProbbtXpT0VjhNol3U/lC3bMdvPGBkpaYbRQ2EKWvNcdMu1CO9d3BlWwNRO
 +WsHIqZkpEeqitjAfoT9C6ky3EtQFDtf8wOYqnKyx32ouYzZn8tn+cUL9Tejx2R0Mxib aw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q7apa2khg-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 27 Apr
 2023 01:04:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 27 Apr 2023 01:04:03 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 32A343F705B;
        Thu, 27 Apr 2023 01:04:03 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 6/7] qla2xxx: Wait for io return on terminate rport
Date:   Thu, 27 Apr 2023 01:03:50 -0700
Message-ID: <20230427080351.9889-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20230427080351.9889-1-njavali@marvell.com>
References: <20230427080351.9889-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: T--5Z2UZHJpPjmiwoxs_39ES-wvVV0qT
X-Proofpoint-GUID: T--5Z2UZHJpPjmiwoxs_39ES-wvVV0qT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_05,2023-04-26_03,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

System crash due to use after free.
Current code allows terminate_rport_io to exit before making
sure all IOs has returned. For FCP-2 device, IO's can hang
on in HW because driver has not tear down the session in FW at
first sign of cable pull. When dev_loss_tmo timer pops,
terminate_rport_io is called and upper layer is about to
free various resources. Terminate_rport_io trigger qla to do
the final cleanup, but the cleanup might not be fast enough where it
leave qla still holding on to the same resource.

Wait for IO's to return to upper layer before resources are freed.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 70cfc94c3d43..b00222459607 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2750,6 +2750,7 @@ static void
 qla2x00_terminate_rport_io(struct fc_rport *rport)
 {
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
+	scsi_qla_host_t *vha;
 
 	if (!fcport)
 		return;
@@ -2759,9 +2760,12 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 
 	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
 		return;
+	vha = fcport->vha;
 
 	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
 		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
+		qla2x00_eh_wait_for_pending_commands(fcport->vha, fcport->d_id.b24,
+			0, WAIT_TARGET);
 		return;
 	}
 	/*
@@ -2786,6 +2790,15 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 			qla2x00_port_logout(fcport->vha, fcport);
 		}
 	}
+
+	/* check for any straggling io left behind */
+	if (qla2x00_eh_wait_for_pending_commands(fcport->vha, fcport->d_id.b24, 0, WAIT_TARGET)) {
+		ql_log(ql_log_warn, vha, 0x300b,
+		       "IO not return.  Resetting. \n");
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
+		qla2x00_wait_for_chip_reset(vha);
+	}
 }
 
 static int
-- 
2.23.1

