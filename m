Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16E4C0015E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 11:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbjHALlS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 07:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbjHALlO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 07:41:14 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6DEE7D
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 04:41:13 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3719ZkQ0020199
        for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2023 04:41:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=kAQXvBi28dRNQN8T5t6t8jbxZboWzPppoX1Gc6U1pgc=;
 b=C1tEtcFIfNz1+47Mx6gw/R44tTMq0k/KgiLJHLWCJhrs73lpRbnWAW4hi9FFz49HJqyj
 vHySRzWAoPFIM0h4S6sSvoJUobsqbTaUnztKxvPyNBdSMb2U53ovp3+3C5YFOMRYIm64
 z3rLAZwT4V+Fitr+jGhZS4iPbQlKF2E5ZwYPrAimY900DaBvHmBaZuadPIhiHZZFmLT8
 nvUn/RS0Mvwo7aCVp0CW203ZUjoXGSkVal9keBGG+k7vgtq4ota5UWXKhVG7F2FLx9rQ
 WDy8EmTUGV75THhO3iXdyQ0liwdVd4JmSzH54lw3MBBzU9X2uNsqeOf8DOWq6VWSUD1N Gg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3s529k8e3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 04:41:12 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 1 Aug
 2023 04:41:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 1 Aug 2023 04:41:10 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id A3FD03F7044;
        Tue,  1 Aug 2023 04:41:08 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 04/10] qla2xxx: Add logs for SFP temperature monitoring
Date:   Tue, 1 Aug 2023 17:10:51 +0530
Message-ID: <20230801114057.27039-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230801114057.27039-1-njavali@marvell.com>
References: <20230801114057.27039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: tSrRqUcL054_a_0lbsGtOXRxXW4n7WQ8
X-Proofpoint-ORIG-GUID: tSrRqUcL054_a_0lbsGtOXRxXW4n7WQ8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_06,2023-08-01_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

Add logs for SFP Temperature Alert async event to
check if laser is enabled/disabled.

Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 867025c89909..e98788191897 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -56,6 +56,22 @@ const char *const port_state_str[] = {
 	[FCS_ONLINE]		= "ONLINE"
 };
 
+#define SFP_DISABLE_LASER_INITIATED    0x15  /* Sub code of 8070 AEN */
+#define SFP_ENABLE_LASER_INITIATED     0x16  /* Sub code of 8070 AEN */
+
+static inline void display_Laser_info(scsi_qla_host_t *vha,
+				      u16 mb1, u16 mb2, u16 mb3) {
+
+	if (mb1 == SFP_DISABLE_LASER_INITIATED)
+		ql_log(ql_log_warn, vha, 0xf0a2,
+		       "SFP temperature (%d C) reached/exceeded the threshold (%d C). Laser is disabled.\n",
+		       mb3, mb2);
+	if (mb1 == SFP_ENABLE_LASER_INITIATED)
+		ql_log(ql_log_warn, vha, 0xf0a3,
+		       "SFP temperature (%d C) reached normal operating level. Laser is enabled.\n",
+		       mb3);
+}
+
 static void
 qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 {
@@ -1927,6 +1943,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		break;
 
 	case MBA_TEMPERATURE_ALERT:
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
+			display_Laser_info(vha, mb[1], mb[2], mb[3]);
 		ql_dbg(ql_dbg_async, vha, 0x505e,
 		    "TEMPERATURE ALERT: %04x %04x %04x\n", mb[1], mb[2], mb[3]);
 		break;
-- 
2.23.1

