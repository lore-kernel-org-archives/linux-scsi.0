Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9003BC4BA2F
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65A3224672
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="mbVRWuD/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgBZWkj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:40:39 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19140 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727761AbgBZWki (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:40:38 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMVSRK003748;
        Wed, 26 Feb 2020 14:40:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=DWntlNsJsTMy8GIQjyKelOEKRPtrXmhW9gGEwGlNT9U=;
 b=mbVRWuD/QZRxO14yZWUr9qZ5IAgK3WYjV4x26bMVAf2df+460ApUXg7v4WCy9fPrnO5Q
 X2G+TFbLaRkaFM7wUYJvplx3fQ+kBsUAl8epSAke1UE5SUespaz3FyLxjsOkEpisPbJW
 VYkvv19KlUZrPf38JFjdbOWteSXG5RYxxnBk5Qc1rTyg9hmm5KqfIfziLLfOu3PPUe1n
 JUBmFCIZ3G4Ch9M/JJ+uIV8CKzYb/plT3EIx64/SUxYvwdereRYznghORoIsk6aUfbrc
 OoJFWdCTj7qFu9IeSLjMRoRQZ64Xn72qGpOVwwNN/OmpD1FkiALD4qi57EN7EgXMibRs bQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ydcm15b7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:40:37 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:36 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:40:36 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 318B23F703F;
        Wed, 26 Feb 2020 14:40:36 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMeaN1024569;
        Wed, 26 Feb 2020 14:40:36 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMeaAX024568;
        Wed, 26 Feb 2020 14:40:36 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 04/18] qla2xxx: Fix FCP-SCSI FC4 flag passing error
Date:   Wed, 26 Feb 2020 14:40:08 -0800
Message-ID: <20200226224022.24518-5-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200226224022.24518-1-hmadhani@marvell.com>
References: <20200226224022.24518-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

This patch fixes issue where incorrect flag was used for
sending switch commands.

Fixes: a4239945b8ad ("scsi: qla2xxx: Add switch command to simplify fabric discovery")
Fixes: e8c72ba51a15 ("[SCSI] qla2xxx: Use GFF_ID to check FCP-SCSI FC4 type before logging into Nx_Ports")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c     | 4 ++--
 drivers/scsi/qla2xxx/qla_init.c   | 4 ++--
 drivers/scsi/qla2xxx/qla_target.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 5af49a7ddb22..42c3ad27f1cb 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -2733,7 +2733,7 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
 	for (i = 0; i < ha->max_fibre_devices; i++) {
 		/* Set default FC4 Type as UNKNOWN so the default is to
 		 * Process this port */
-		list[i].fc4_type = FC4_TYPE_UNKNOWN;
+		list[i].fc4_type = 0;
 
 		/* Do not attempt GFF_ID if we are not FWI_2 capable */
 		if (!IS_FWI2_CAPABLE(ha))
@@ -3083,7 +3083,7 @@ void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 			    "%s %d %8phC post new sess\n",
 			    __func__, __LINE__, ea->port_name);
 			qla24xx_post_newsess_work(vha, &ea->id,
-			    ea->port_name, NULL, NULL, FC4_TYPE_UNKNOWN);
+			    ea->port_name, NULL, NULL, 0);
 		}
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 50a173086118..f1793d768c07 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1043,7 +1043,7 @@ static void qla24xx_async_gnl_sp_done(srb_t *sp, int res)
 			    __func__, __LINE__, (u8 *)&wwn, id.b24);
 			wwnn = wwn_to_u64(e->node_name);
 			qla24xx_post_newsess_work(vha, &id, (u8 *)&wwn,
-			    (u8 *)&wwnn, NULL, FC4_TYPE_UNKNOWN);
+			    (u8 *)&wwnn, NULL, 0);
 		}
 	}
 
@@ -5829,7 +5829,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 		/* Bypass ports whose FCP-4 type is not FCP_SCSI */
 		if (ql2xgffidenable &&
 		    (!(new_fcport->fc4_type & FS_FC4TYPE_FCP) &&
-		    new_fcport->fc4_type != FC4_TYPE_UNKNOWN))
+		    new_fcport->fc4_type != 0))
 			continue;
 
 		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 243f87df3d2b..2e2bf919afed 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4739,11 +4739,11 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 			qla24xx_post_newsess_work(vha, &port_id,
 			    iocb->u.isp24.port_name,
 			    iocb->u.isp24.u.plogi.node_name,
-			    pla, FC4_TYPE_UNKNOWN);
+			    pla, 0);
 		else
 			qla24xx_post_newsess_work(vha, &port_id,
 			    iocb->u.isp24.port_name, NULL,
-			    pla, FC4_TYPE_UNKNOWN);
+			    pla, 0);
 
 		goto out;
 	}
-- 
2.12.0

