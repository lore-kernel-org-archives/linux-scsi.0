Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7E9C2D0CD
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6CC20716
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:09:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="g7BOPU+w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfLQWJN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:09:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42046 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbfLQWJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:09:13 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM5aBs029957;
        Tue, 17 Dec 2019 14:07:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=yKBC8vvNbI2CgVFj9zTDZ0exBqUjvq6WmtCpFPy5wo8=;
 b=g7BOPU+wZ9+m/BTnb/3TANNB5V2GMwJQb50i7K4CQNZRq1y2Rwr5JzWVd+RZEsH9neW6
 93p8g+3OV+OKZQB5k4Ekc63BZRaqiRBb0AUu0b/j5YA0gFAlM7TRJxh/44XP4y+tnLCK
 5pjjOKpvN6X9GMKKcIy+qL/mxopgXOmR8g8LJKFYHuqy9G8tgNgCYgKmUtgg2DODRW2I
 tsLTfUmjkdq9bs/83IgSNGFrkI8vkVOPlyf6666REOeKw6B9I1jnWL3uy6UXgJ2NYYCg
 ZrLf28QrB9p6nI81pOb5Wbn/5QwDNS4WxsnRQhLXWOoR2v7PNEx/3t/6KuAXurECI6K5 nA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wxn0wm22h-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:07:11 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:44 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:44 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B10C73F703F;
        Tue, 17 Dec 2019 14:06:44 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6iZw028163;
        Tue, 17 Dec 2019 14:06:44 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6i4n028162;
        Tue, 17 Dec 2019 14:06:44 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 09/14] qla2xxx: Correct fcport flags handling
Date:   Tue, 17 Dec 2019 14:06:12 -0800
Message-ID: <20191217220617.28084-10-hmadhani@marvell.com>
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

From: Shyam Sundar <ssundar@marvell.com>

This patch fixes some instances of FCF_ASYNC_{SENT|ACTIVE} flag
setting and clearning were missing.

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 4 ----
 drivers/scsi/qla2xxx/qla_init.c | 3 ++-
 drivers/scsi/qla2xxx/qla_iocb.c | 3 ++-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index f11fb00bfc43..aaa4a5bbf2ff 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -2963,7 +2963,6 @@ int qla24xx_post_gpsc_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 		return QLA_FUNCTION_FAILED;
 
 	e->u.fcport.fcport = fcport;
-	fcport->flags |= FCF_ASYNC_ACTIVE;
 	return qla2x00_post_work(vha, e);
 }
 
@@ -3097,9 +3096,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
-	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
-	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return rval;
 }
 
@@ -4464,7 +4461,6 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
-	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 37aad8da7934..77e54e7a31d6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1119,8 +1119,8 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
-	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
+	fcport->flags &= ~(FCF_ASYNC_ACTIVE | FCF_ASYNC_SENT);
 	return rval;
 }
 
@@ -1354,6 +1354,7 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	sp->free(sp);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
+	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	qla24xx_post_gpdb_work(vha, fcport, opt);
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 3ee080a2564c..47bf60a9490a 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2924,6 +2924,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (!sp) {
 		ql_log(ql_log_info, vha, 0x70e6,
 		 "SRB allocation failed\n");
+		fcport->flags &= ~FCF_ASYNC_ACTIVE;
 		return -ENOMEM;
 	}
 
@@ -3001,7 +3002,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	}
 
 out:
-	fcport->flags &= ~(FCF_ASYNC_SENT);
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
 	sp->free(sp);
 done:
-- 
2.12.0

