Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F501C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 09:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbiCJJ1k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240808AbiCJJ12 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 04:27:28 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E51E139CEA
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:28 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22A1dlxK024974
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=m+CERT2IYAxeZOm1MryySwz7rDgLFNfsPmZRfcMd26E=;
 b=KOTqXQ0BlLYaEOVGX0GJisocJ58fg8duNlGDQQdKtrRLcE7e5yVGmZb94NGjGY39kXEc
 FIP4P93JV8kSE79OjLrZWdN7qlVI62KuIryqGZy2/tKG1SktWziQZKm2p+qwZBNm9Sx+
 eOLEM4jxguhhxT9tFlDzv8nBDjVJa4Om1cMzu80BfRoGUhHOVkCAHxcGlBpGxRl8DFVR
 PCGda5FyGhKKPjS6TzhDDM1SV2ZOwHC1a7ddL9SvbdoPfczEv28SMGKkcEeUQRfQHFV6
 z4GuULCuVsQerpO1VhskZ0jLcgu52ccuxQOLKCy9xInWexbZq+VAaD5SoiYA7Wt8xL1E XA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38pmd7x-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:27 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Mar
 2022 01:26:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 10 Mar 2022 01:26:23 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8F7333F7065;
        Thu, 10 Mar 2022 01:26:23 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22A9QNoQ023021;
        Thu, 10 Mar 2022 01:26:23 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22A9QNW1023020;
        Thu, 10 Mar 2022 01:26:23 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 09/13] qla2xxx: reduce false trigger to login
Date:   Thu, 10 Mar 2022 01:26:00 -0800
Message-ID: <20220310092604.22950-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com>
References: <20220310092604.22950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 9SyyaYPlTxoOuKE5cZXPzhk77Vy8Sv23
X-Proofpoint-ORIG-GUID: 9SyyaYPlTxoOuKE5cZXPzhk77Vy8Sv23
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

While a session is in the middle of a relogin,
a late RSCN can be delivered from switch. RSCN trigger fabric
scan where the scan logic can trigger another session login
while a login is in progress.
This patch reduce the extra trigger to prevent multiple login
to the same session.

Cc: stable@vger.kernel.org
Fixes: bee8b84686c4 ("scsi: qla2xxx: Reduce redundant ADISC command for RSCNs")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3f05e87ac2d6..a8c27cccf4d6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1644,7 +1644,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	    fcport->login_gen, fcport->loop_id, fcport->scan_state,
 	    fcport->fc4_type);
 
-	if (fcport->scan_state != QLA_FCPORT_FOUND)
+	if (fcport->scan_state != QLA_FCPORT_FOUND ||
+	    fcport->disc_state == DSC_DELETE_PEND)
 		return 0;
 
 	if ((fcport->loop_id != FC_NO_LOOP_ID) &&
@@ -1665,7 +1666,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	if (vha->host->active_mode == MODE_TARGET && !N2N_TOPO(vha->hw))
 		return 0;
 
-	if (fcport->flags & FCF_ASYNC_SENT) {
+	if (fcport->flags & (FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE)) {
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		return 0;
 	}
-- 
2.19.0.rc0

