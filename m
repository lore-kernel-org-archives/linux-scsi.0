Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E19C4CEC7
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56C1A2081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:10:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KUSX3tLf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfILSKI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 14:10:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5500 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726909AbfILSKH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 14:10:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CI9PEK019904;
        Thu, 12 Sep 2019 11:10:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=dQ4VYrHlMQ1hzkracfYZhnHmYJ3buBqWvvQpitpAnvc=;
 b=KUSX3tLfbDbbFn8Ti7sTHoFhMEqU10X5iBDGUltVRjx6i4bRx5zN6LBQkpGbpYNj/1LY
 Sy4C+oNmvL+VFOfz7DTU5FXGVmFAcDJ7kWmOjP0x3XDMsMIpeCFTFMIZUkr2vQ5LLbUN
 9v5FRAdVVV9uPc+dH16857xGgFZDlZsZAPdeGDgSM2Q7/iqbRuoy6csphbJt00xcblrM
 RUZpnbU0PSvzgGfG75hCg/NAM4OVHgthOajNuuU2TPxONPkTC7yTupviHUZ1zfsYfUkE
 SRxtDGPROakHQ51YsAlE/6Vg4xrfM/h/meladnl6dLRQZakIphgf15xeVmnoxIsK5xRh vg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uytdfg5rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 11:10:05 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 11:10:03 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 11:10:03 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AECB03F7044;
        Thu, 12 Sep 2019 11:10:03 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CIA3Ag006588;
        Thu, 12 Sep 2019 11:10:03 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CIA30n006522;
        Thu, 12 Sep 2019 11:10:03 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 13/14] qla2xxx: Improve logging for scan thread
Date:   Thu, 12 Sep 2019 11:09:17 -0700
Message-ID: <20190912180918.6436-14-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912180918.6436-1-hmadhani@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_09:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

move messages to verbose logging for scan thread

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 5b5ac09f38db..7a00272ca380 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3571,7 +3571,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 	u8 recheck = 0;
 	u16 dup = 0, dup_cnt = 0;
 
-	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
 	    "%s enter\n", __func__);
 
 	if (sp->gen1 != vha->hw->base_qpair->chip_reset) {
@@ -3588,8 +3588,9 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		} else {
-			ql_dbg(ql_dbg_disc, vha, 0xffff,
-			    "Fabric scan failed on all retries.\n");
+			ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
+			    "%s: Fabric scan failed for %d retries.\n",
+			    __func__, vha->scan.scan_retry);
 		}
 		goto out;
 	}
@@ -4055,7 +4056,7 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 
 void qla24xx_async_gpnft_done(scsi_qla_host_t *vha, srb_t *sp)
 {
-	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
 	    "%s enter\n", __func__);
 	qla24xx_async_gnnft(vha, sp, sp->gen2);
 }
@@ -4069,7 +4070,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 	u32 rspsz;
 	unsigned long flags;
 
-	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
 	    "%s enter\n", __func__);
 
 	if (!vha->flags.online)
@@ -4078,14 +4079,15 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 	spin_lock_irqsave(&vha->work_lock, flags);
 	if (vha->scan.scan_flags & SF_SCANNING) {
 		spin_unlock_irqrestore(&vha->work_lock, flags);
-		ql_dbg(ql_dbg_disc, vha, 0xffff, "scan active\n");
+		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
+		    "%s: scan active\n", __func__);
 		return rval;
 	}
 	vha->scan.scan_flags |= SF_SCANNING;
 	spin_unlock_irqrestore(&vha->work_lock, flags);
 
 	if (fc4_type == FC4_TYPE_FCP_SCSI) {
-		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
 		    "%s: Performing FCP Scan\n", __func__);
 
 		if (sp)
@@ -4140,7 +4142,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 		}
 		sp->u.iocb_cmd.u.ctarg.rsp_size = rspsz;
 
-		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
 		    "%s scan list size %d\n", __func__, vha->scan.size);
 
 		memset(vha->scan.l, 0, vha->scan.size);
@@ -4205,8 +4207,8 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 	spin_lock_irqsave(&vha->work_lock, flags);
 	vha->scan.scan_flags &= ~SF_SCANNING;
 	if (vha->scan.scan_flags == 0) {
-		ql_dbg(ql_dbg_disc, vha, 0xffff,
-		    "%s: schedule\n", __func__);
+		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
+		    "%s: Scan scheduled.\n", __func__);
 		vha->scan.scan_flags |= SF_QUEUED;
 		schedule_delayed_work(&vha->scan.scan_work, 5);
 	}
-- 
2.12.0

