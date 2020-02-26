Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F876C4BA24
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E530524670
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="axKY6H7i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgBZWkh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:40:37 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3510 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgBZWkh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:40:37 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMeZXL006185;
        Wed, 26 Feb 2020 14:40:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=CD8Pek2+ywsJeIk0X2MSC21qTfPnz8eqQebnVWqoa08=;
 b=axKY6H7ioXpjgRUHM8vs5O4JbusVevXNLztSqjpDxYHDig9l0cbMwJl8YGLpLyONqCK3
 wJM0Dk9OAJxOUUygzxDU7UA2+Vmriy7BzmdVWAEj5fuaI1Hd+oCHQXot7Dq6osjQ38ej
 fvyF0DlBeHCtCTFtvM2YavDupofwO3GM8s7ddcqeIlwodDFOWJbayLssk0qKkNDpsTcj
 LdM2hpMeuIwXHdVVV5X11foK7+ZBlmcXV0HmSIbvvuug6bca+tytXiZU4XrKWB2aMuk0
 4LIqYKF0dNvGHCWnhL8Gjq/lCf5vJWbS0RzuE6h9ry2KaAnvSSsWOL6w3LxLVjYxixAj /g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydchtd6jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:40:35 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:33 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:40:32 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 04E0E3F703F;
        Wed, 26 Feb 2020 14:40:32 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMeWQu024565;
        Wed, 26 Feb 2020 14:40:32 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMeWfe024564;
        Wed, 26 Feb 2020 14:40:32 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 03/18] qla2xxx: Use FC generic update firmware options routine for ISP27xx
Date:   Wed, 26 Feb 2020 14:40:07 -0800
Message-ID: <20200226224022.24518-4-hmadhani@marvell.com>
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

From: Giridhar Malavali <gmalavali@marvell.com>

This patch uses generic firmware update options for FCoE based
adapters as well to reduce code duplication.

Signed-off-by: Giridhar Malavali <gmalavali@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |  2 --
 drivers/scsi/qla2xxx/qla_init.c | 66 -----------------------------------------
 drivers/scsi/qla2xxx/qla_os.c   |  4 +--
 3 files changed, 2 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index bb3dfef9afb8..73b663defee1 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -31,8 +31,6 @@ extern int qla24xx_nvram_config(struct scsi_qla_host *);
 extern int qla81xx_nvram_config(struct scsi_qla_host *);
 extern void qla2x00_update_fw_options(struct scsi_qla_host *);
 extern void qla24xx_update_fw_options(scsi_qla_host_t *);
-extern void qla81xx_update_fw_options(scsi_qla_host_t *);
-extern void qla83xx_update_fw_options(scsi_qla_host_t *);
 
 extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
 extern int qla24xx_load_risc(scsi_qla_host_t *, uint32_t *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 111a97a69489..50a173086118 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8680,72 +8680,6 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 	return status;
 }
 
-void
-qla83xx_update_fw_options(scsi_qla_host_t *vha)
-{
-	struct qla_hw_data *ha = vha->hw;
-
-	if (ql2xrdpenable)
-		ha->fw_options[1] |= ADD_FO1_ENABLE_PUREX_IOCB;
-
-	qla2x00_set_fw_options(vha, ha->fw_options);
-}
-
-void
-qla81xx_update_fw_options(scsi_qla_host_t *vha)
-{
-	struct qla_hw_data *ha = vha->hw;
-
-	/*  Hold status IOCBs until ABTS response received. */
-	if (ql2xfwholdabts)
-		ha->fw_options[3] |= BIT_12;
-
-	/* Set Retry FLOGI in case of P2P connection */
-	if (ha->operating_mode == P2P) {
-		ha->fw_options[2] |= BIT_3;
-		ql_dbg(ql_dbg_disc, vha, 0x2103,
-		    "(%s): Setting FLOGI retry BIT in fw_options[2]: 0x%x\n",
-			__func__, ha->fw_options[2]);
-	}
-
-	/* Move PUREX, ABTS RX & RIDA to ATIOQ */
-	if (ql2xmvasynctoatio) {
-		if (qla_tgt_mode_enabled(vha) ||
-		    qla_dual_mode_enabled(vha))
-			ha->fw_options[2] |= BIT_11;
-		else
-			ha->fw_options[2] &= ~BIT_11;
-	}
-
-	if (qla_tgt_mode_enabled(vha) ||
-	    qla_dual_mode_enabled(vha)) {
-		/* FW auto send SCSI status during */
-		ha->fw_options[1] |= BIT_8;
-		ha->fw_options[10] |= (u16)SAM_STAT_BUSY << 8;
-
-		/* FW perform Exchange validation */
-		ha->fw_options[2] |= BIT_4;
-	} else {
-		ha->fw_options[1]  &= ~BIT_8;
-		ha->fw_options[10] &= 0x00ff;
-
-		ha->fw_options[2] &= ~BIT_4;
-	}
-
-	if (ql2xetsenable) {
-		/* Enable ETS Burst. */
-		memset(ha->fw_options, 0, sizeof(ha->fw_options));
-		ha->fw_options[2] |= BIT_9;
-	}
-
-	ql_dbg(ql_dbg_init, vha, 0x00e9,
-	    "%s, add FW options 1-3 = 0x%04x 0x%04x 0x%04x mode %x\n",
-	    __func__, ha->fw_options[1], ha->fw_options[2],
-	    ha->fw_options[3], vha->host->active_mode);
-
-	qla2x00_set_fw_options(vha, ha->fw_options);
-}
-
 /*
  * qla24xx_get_fcp_prio
  *	Gets the fcp cmd priority value for the logged in port.
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 628bb4e87f17..f3244c8f2179 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2307,7 +2307,7 @@ static struct isp_operations qla81xx_isp_ops = {
 	.config_rings		= qla24xx_config_rings,
 	.reset_adapter		= qla24xx_reset_adapter,
 	.nvram_config		= qla81xx_nvram_config,
-	.update_fw_options	= qla83xx_update_fw_options,
+	.update_fw_options	= qla24xx_update_fw_options,
 	.load_risc		= qla81xx_load_risc,
 	.pci_info_str		= qla24xx_pci_info_str,
 	.fw_version_str		= qla24xx_fw_version_str,
@@ -2424,7 +2424,7 @@ static struct isp_operations qla83xx_isp_ops = {
 	.config_rings		= qla24xx_config_rings,
 	.reset_adapter		= qla24xx_reset_adapter,
 	.nvram_config		= qla81xx_nvram_config,
-	.update_fw_options	= qla83xx_update_fw_options,
+	.update_fw_options	= qla24xx_update_fw_options,
 	.load_risc		= qla81xx_load_risc,
 	.pci_info_str		= qla24xx_pci_info_str,
 	.fw_version_str		= qla24xx_fw_version_str,
-- 
2.12.0

