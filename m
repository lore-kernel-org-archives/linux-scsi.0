Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 606EEC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 09:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240818AbiCJJ1f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240801AbiCJJ11 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 04:27:27 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3372E139CDA
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:27 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22A1dlxI024974
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=x9woAqLZdjcRwl3ui6ZnNuEQKBGBcfcpFzzMpv+ReKk=;
 b=dlC+8YPJfKu8kduKhAKBmU9+/ChjZBPZglY1Y2RVjOjAVbvm4jFc8i7xI9O3820CR/J9
 cjsWd7p6ncXiaMrc/hLSN1I2WanEPwlVDdSDpfaH0SsTm9aW6Zdcuhs6zWJXDgzM6ctX
 6ebXMrbgXP7hhDZ1hY7yFpNdGm2SLIaS20v6VsIDbxBkXTaZmdg6ernbs68jrcWOQmWR
 AUjLb4WU1Yrv2MTQwwbA0Q4TIAIG1DJxlDTZ7Jyt5tMb/nmtw31QLBs0o2JrRIOEl48U
 TqzIDdX5M8hMm2W10r65Q5yLzDoI888GJlRxhXqbkKAcIK4jraTVEye202w5+3F4lKba Ug== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38pmd7x-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:26 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Mar
 2022 01:26:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 10 Mar 2022 01:26:23 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 487E33F705E;
        Thu, 10 Mar 2022 01:26:23 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22A9QNYM023009;
        Thu, 10 Mar 2022 01:26:23 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22A9QNZY023008;
        Thu, 10 Mar 2022 01:26:23 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 06/13] qla2xxx: fix n2n inconsistent plogi
Date:   Thu, 10 Mar 2022 01:25:57 -0800
Message-ID: <20220310092604.22950-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com>
References: <20220310092604.22950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: MCMNpRuppeAUAwNKRX7aZfpfM18wx0x2
X-Proofpoint-ORIG-GUID: MCMNpRuppeAUAwNKRX7aZfpfM18wx0x2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For N2N topology, ELS Passthrough is used to send PLOGI.
On failure of ELS pass through PLOGI, driver flipped over
to using LLIOCB PLOGI for N2N. This is not consistent.
This patch would delete the session to restart the
connection, where ELS pass through PLOGI would be used consistently.

Cc: stable@vger.kernel.org
Fixes: c76ae845ea83 ("scsi: qla2xxx: Add error handling for PLOGI ELS passthrough")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 5e3ee1f7b43c..e0fe9ddb4bd2 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2958,6 +2958,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 					set_bit(ISP_ABORT_NEEDED,
 					    &vha->dpc_flags);
 					qla2xxx_wake_dpc(vha);
+					break;
 				}
 				fallthrough;
 			default:
@@ -2967,9 +2968,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 				    fw_status[0], fw_status[1], fw_status[2]);
 
 				fcport->flags &= ~FCF_ASYNC_SENT;
-				qla2x00_set_fcport_disc_state(fcport,
-				    DSC_LOGIN_FAILED);
-				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+				qlt_schedule_sess_for_deletion(fcport);
 				break;
 			}
 			break;
@@ -2981,8 +2980,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			    fw_status[0], fw_status[1], fw_status[2]);
 
 			sp->fcport->flags &= ~FCF_ASYNC_SENT;
-			qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_FAILED);
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+			qlt_schedule_sess_for_deletion(fcport);
 			break;
 		}
 
-- 
2.19.0.rc0

