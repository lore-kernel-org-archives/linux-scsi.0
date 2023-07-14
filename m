Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF21C001B0
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 07:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbjGNHBf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 03:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbjGNHB3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 03:01:29 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53452713
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:22 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DLUPqQ029957
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=cY3z0pSTNb3IVKcBvsb2+gPdrUQv6qIBg6U1O1J/W8o=;
 b=hoje6nmuhNpve/ZXug3KHH5Mtj15YXDXlMLo7utqZfRZJPgZkZIEYsk2k0qhFjvvAsEY
 jvlqe0hUT9muWKaflBX3rfkKdrobtoIt9PdA2V5PAY8FO6ISLY5NbCas9/oUI5mV/Q1V
 XJweNervrtToXON5SupFESt0wc48ZPUY2EraC7V17GvekcSOf2RotCM8MV4hR8XF3NPH
 ajMLuy6/DjTPbS4WyZDAgPftAcFI5Da4CVOrRWQaeel7o/EPwh/Y2AwBFTPmsoJk25T2
 iu7xeMqbqCLMYXIEJRb/TgdYFz4AIL9EYv7jElEh36TWUVLWLdv5Pxb4vJ3o7I8A6gYz zA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3rtptx9rxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:22 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 14 Jul
 2023 00:01:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 14 Jul 2023 00:01:20 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 751083F7087;
        Fri, 14 Jul 2023 00:01:17 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 05/10] qla2xxx: Fix erroneous link up failure
Date:   Fri, 14 Jul 2023 12:30:59 +0530
Message-ID: <20230714070104.40052-6-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230714070104.40052-1-njavali@marvell.com>
References: <20230714070104.40052-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: bTqOiZMirOTceemhm_LulJU3emGF9I8l
X-Proofpoint-ORIG-GUID: bTqOiZMirOTceemhm_LulJU3emGF9I8l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_04,2023-07-13_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Link up failure occurred where driver fail to see certain
events from FW indicating link up (AEN 8011) and fabric login completion
(AEN 8014). Without these 2 events driver would not proceed forward
to scan the fabric. The cause of this is due to delay in the receive
of interrupt for Mailbox 60 that cause qla to set the fw_started flag late.
The late setting of this flag cause other interrupts to be dropped.
These dropped interrupts happen to be the link up (AEN 8011) and
fabric login completion (AEN 8014).

Set fw_started flag early to prevent interrupts being dropped.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 3 ++-
 drivers/scsi/qla2xxx/qla_isr.c  | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3b32e65d6260..725806ca9572 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4815,15 +4815,16 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	if (ha->flags.edif_enabled)
 		mid_init_cb->init_cb.frame_payload_size = cpu_to_le16(ELS_MAX_PAYLOAD);
 
+	QLA_FW_STARTED(ha);
 	rval = qla2x00_init_firmware(vha, ha->init_cb_size);
 next_check:
 	if (rval) {
+		QLA_FW_STOPPED(ha);
 		ql_log(ql_log_fatal, vha, 0x00d2,
 		    "Init Firmware **** FAILED ****.\n");
 	} else {
 		ql_dbg(ql_dbg_init, vha, 0x00d3,
 		    "Init Firmware -- success.\n");
-		QLA_FW_STARTED(ha);
 		vha->u_ql2xexchoffld = vha->u_ql2xiniexchg = 0;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a07c010b0843..eb8480a0d7b0 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1121,8 +1121,12 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 	unsigned long	flags;
 	fc_port_t	*fcport = NULL;
 
-	if (!vha->hw->flags.fw_started)
+	if (!vha->hw->flags.fw_started) {
+		ql_log(ql_log_warn, vha, 0x50ff,
+		    "Dropping AEN - %04x %04x %04x %04x.\n",
+		    mb[0], mb[1], mb[2], mb[3]);
 		return;
+	}
 
 	/* Setup to process RIO completion. */
 	handle_cnt = 0;
-- 
2.23.1

