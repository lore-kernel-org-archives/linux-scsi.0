Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFB9C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 09:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240815AbiCJJ1d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240799AbiCJJ11 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 04:27:27 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE02139CD6
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:26 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22A1dmHR025048
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=2D+nbuM+Q0o7DSqlk6Us31WrW/O8Ed1mNYKcwDkG7uQ=;
 b=V2d2sKHgiRW4fUs0qqNxX7GwmtLXQV9Wzaozvlcro+EJzV1wPfZrBX+rPF2DWTau+Aaw
 ZR3n/mzbRLct12F6h5OtKJotapQP52LhKKiOeDkBjWeDJCYomoAxqXY76cH8iEkr9QUP
 DmGBd5BxHpZTjd27p8k1WbNO8teECsVrSTdLwFuBPBE8SRNhUMz7yioXskRtaU0Zrz/c
 6TG+f/7qmzT+TOSQGj4HU9j5YjjUQu9GKnxMkdBicWg0NHRWLggEtSmH6tQYcbY/9tgV
 sx+8pQUtxu39PRck/xION107R7sRwLyYsJ4WB68SMEq91yC6J9WYCPnh88v2ynykAmC+ Jg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38pmd7w-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:26 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Mar
 2022 01:26:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 10 Mar 2022 01:26:23 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A602A3F7066;
        Thu, 10 Mar 2022 01:26:23 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22A9QNmK023025;
        Thu, 10 Mar 2022 01:26:23 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22A9QN6m023024;
        Thu, 10 Mar 2022 01:26:23 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 10/13] qla2xxx: Fix stuck session of prli reject
Date:   Thu, 10 Mar 2022 01:26:01 -0800
Message-ID: <20220310092604.22950-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com>
References: <20220310092604.22950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: gNHDygKJrSwQ_S5QKu0s-hhRLcePxbCx
X-Proofpoint-ORIG-GUID: gNHDygKJrSwQ_S5QKu0s-hhRLcePxbCx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Remove stale recovery code that prevents normal path recovery.

Cc: stable@vger.kernel.org
Fixes: 1cbc0efcd9be ("scsi: qla2xxx: Fix retry for PRLI RJT with reason of BUSY")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a8c27cccf4d6..7f81525c4fb3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2105,13 +2105,6 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		qla24xx_post_gpdb_work(vha, ea->fcport, 0);
 		break;
 	default:
-		if ((ea->iop[0] == LSC_SCODE_ELS_REJECT) &&
-		    (ea->iop[1] == 0x50000)) {   /* reson 5=busy expl:0x0 */
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-			ea->fcport->fw_login_state = DSC_LS_PLOGI_COMP;
-			break;
-		}
-
 		sp = ea->sp;
 		ql_dbg(ql_dbg_disc, vha, 0x2118,
 		       "%s %d %8phC priority %s, fc4type %x prev try %s\n",
-- 
2.19.0.rc0

