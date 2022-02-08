Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0FBC4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 11:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344866AbiBHLZR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 06:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355462AbiBHJkx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 04:40:53 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4551AC03FEC0
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 01:40:52 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2189ecKL003539;
        Tue, 8 Feb 2022 01:40:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=rRw4ovcVbEyyymtV+rmFFqHruaxAeUEJv2aC/cEsV0s=;
 b=igXuRZxRTNTk6P6x3y+8YWGQUBKU1+67S1ihp1vmNbjX3ZZbZjMPi7t/La7Rk5HVaXfm
 wAFk0s8/1y60sq0O7vZK+23LnaFnSL+yQYdslrv/UnSBNFM+/w2EFLzAZqSV29KDNsjD
 Bj8vkVlswVyiF9tgquy1RWdcO0vd9sfkTOYfRq+NuPoc8nE2umThoB127hkPAJJiLZVv
 pEbW6gfWSzJx3znmVikBuIAgBPqBDbTaf+Ui0aCqW2fiuVRVsAQlGQSmmGHrM5va70Bu
 tRu8f9D1cZAc6j6sUgvxELzTGc0I+QseGpymVylDWhX811NQ6bB3TC8fR0esDKXnhnVo yw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e3nuy013h-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:40:49 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 01:40:28 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 8 Feb 2022 01:40:28 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BF59F3F708F;
        Tue,  8 Feb 2022 01:40:28 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 2189eCDR004572;
        Tue, 8 Feb 2022 01:40:18 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 2189dkOF004505;
        Tue, 8 Feb 2022 01:39:46 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <emilne@redhat.com>
Subject: [PATCH] qla2xxx: Add qla2x00_async_done routine for async routines.
Date:   Tue, 8 Feb 2022 01:39:46 -0800
Message-ID: <20220208093946.4471-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: aNWDzRTt6rgA5JkVxLjeyZfvw-JoB4jT
X-Proofpoint-ORIG-GUID: aNWDzRTt6rgA5JkVxLjeyZfvw-JoB4jT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_02,2022-02-07_02,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

This done routine will delete the timer and check for it's return
value and accordingly decrease the reference count.

Fixes: 31e6cdbe0eae ("scsi: qla2xxx: Implement ref count for SRB")
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7dd82214d59f..5e3ee1f7b43c 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2560,6 +2560,20 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
 	}
 }
 
+static void
+qla2x00_async_done(struct srb *sp, int res)
+{
+	if (del_timer(&sp->u.iocb_cmd.timer)) {
+		/*
+		 * Successfully cancelled the timeout handler
+		 * ref: TMR
+		 */
+		if (kref_put(&sp->cmd_kref, qla2x00_sp_release))
+			return;
+	}
+	sp->async_done(sp, res);
+}
+
 void
 qla2x00_sp_release(struct kref *kref)
 {
@@ -2573,7 +2587,8 @@ qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
 		     void (*done)(struct srb *sp, int res))
 {
 	timer_setup(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout, 0);
-	sp->done = done;
+	sp->done = qla2x00_async_done;
+	sp->async_done = done;
 	sp->free = qla2x00_sp_free;
 	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
-- 
2.23.1

