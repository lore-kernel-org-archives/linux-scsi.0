Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4349C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 11:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbiFHL7U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbiFHL7O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 07:59:14 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D6227B38
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 04:59:13 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2581X4Ni020925
        for <linux-scsi@vger.kernel.org>; Wed, 8 Jun 2022 04:59:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=5o9NWsuFuAkg7cvFNkDA9G6sPwPdUUFxG631GAQGSyY=;
 b=cMFdRZLG5EALk3oq8MjQZ9FF7NCoNBmy3SYk6f2FqWFeQyAzBnHKOzKzkWJOH8mLUzap
 zJLPyHk/KD9H25jeMCLphi9O0+/HRlumB1fKWtYWfg+28w5fAmzlGxO1c3scD6xcMHCZ
 MRyjp/ARXs2vf60svLxeJmtqJuurHLq8wtsIOCy+nvvLvdE//pPdyJOLRGkGMNdP6tdo
 90SItetGfGSh6yLSShCeV5084sir8wQ3H7FMusyy6SL3lTHOkJOIfq5Wx9GG2g/teqk9
 eBNJcUxSQLNEOT1/IciplSsaqbCBD+3E45DSHMRIF9uXDcMUEq7R+yXnbON3go6hC41L rQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gjb7pbsag-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 04:59:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Jun
 2022 04:58:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Jun 2022 04:58:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 772073F708E;
        Wed,  8 Jun 2022 04:58:56 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/10] qla2xxx: edif: Fix no logout on delete for n2n
Date:   Wed, 8 Jun 2022 04:58:46 -0700
Message-ID: <20220608115849.16693-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com>
References: <20220608115849.16693-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: vLQzH0lKtxR67bz7Z1GRRx_MO5UWDVRI
X-Proofpoint-ORIG-GUID: vLQzH0lKtxR67bz7Z1GRRx_MO5UWDVRI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_03,2022-06-07_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Driver failed to send implicit logout on
session delete. For edif, this failed to flush any
lingering SA index in FW. This patch set a flag
to turn on implicit logout early in the session recovery
to make sure it would go out in case of error.

Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 46c879923da1..42ce4e1fe744 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2882,6 +2882,9 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 	    sp->name, res, sp->handle, fcport->d_id.b24, fcport->port_name);
 
 	fcport->flags &= ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
+	/* For edif, set logout on delete to ensure any residual key from FW is flushed.*/
+	fcport->logout_on_delete = 1;
+	fcport->chip_reset = vha->hw->base_qpair->chip_reset;
 
 	if (sp->flags & SRB_WAKEUP_ON_COMP)
 		complete(&lio->u.els_plogi.comp);
-- 
2.19.0.rc0

