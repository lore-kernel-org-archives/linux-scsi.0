Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E27C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 489A9206DB
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="A/kEtwgZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgBLVrG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:47:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53520 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgBLVrF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:47:05 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLejnh001672;
        Wed, 12 Feb 2020 13:45:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=mBY5DR49p2rOar71Bs8NeZ4c81Lrk723+1DKKwPD/t8=;
 b=A/kEtwgZ7q/uHmlEXXWqGEAEElhVm9ZMqHC0KDs9FnNOpYCftCgWh9HCDfOZ9yqTKaB4
 25zvpZt9GzJDVaFkYzqRI4j2MtLXtzM+Kr3pPld3zrSr3ItX15aLgiKnMCUSGswm/0rn
 Pk0nzEgLwcmmZraOFFg4s/iHr5ObLYAal8O9HSfGrh0156M3izt+lP0u3+uqaZTCbDNU
 q1kZOZD0LVUqbnqSgzUt6KkpUa5rrwHeJaVWeZinA6pjkD8NEDa96w+vTLdk9EmwAFis
 TCvivNlWDhv7FKIJ+GqqUaSsfz1RqIfYKmGviD8nGWPDIjh/zZEk1dV7mIEzsWs7m1/O 3g== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt4xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:04 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:02 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:02 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 26B2D3F7053;
        Wed, 12 Feb 2020 13:45:02 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLj2ve025608;
        Wed, 12 Feb 2020 13:45:02 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLj1E9025599;
        Wed, 12 Feb 2020 13:45:01 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 08/25] qla2xxx: Add ql2xrdpenable module parameter for RDP
Date:   Wed, 12 Feb 2020 13:44:19 -0800
Message-ID: <20200212214436.25532-9-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

This patch provides separate module parameter
ql2xrdpenable to turn on/off RDP capability in
the driver. However, if ql2xsmartsan parameter
is enabled, it will also turn on ql2xfdmienable
parameter since its required for RDP to work.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
 drivers/scsi/qla2xxx/qla_init.c | 12 +++++++++---
 drivers/scsi/qla2xxx/qla_os.c   | 10 +++++++++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 7679f8fa1ddc..cdd8d7947fa8 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -144,6 +144,7 @@ extern int qlport_down_retry;
 extern int ql2xplogiabsentdevice;
 extern int ql2xloginretrycount;
 extern int ql2xfdmienable;
+extern int ql2xrdpenable;
 extern int ql2xsmartsan;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2b36a1bdcc5f..8fee3f5154c7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2270,6 +2270,12 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	ql_dbg(ql_dbg_init, vha, 0x0078,
 	    "Verifying loaded RISC code...\n");
 
+	/* If smartsan enabled then require fdmi and rdp enabled */
+	if (ql2xsmartsan) {
+		ql2xfdmienable = 1;
+		ql2xrdpenable = 1;
+	}
+
 	if (qla2x00_isp_firmware(vha) != QLA_SUCCESS) {
 		rval = ha->isp_ops->chip_diag(vha);
 		if (rval)
@@ -3710,7 +3716,7 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 		}
 
 		/* Enable PUREX PASSTHRU */
-		if (ql2xsmartsan)
+		if (ql2xrdpenable)
 			qla25xx_set_els_cmds_supported(vha);
 	} else
 		goto failed;
@@ -3945,7 +3951,7 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 	}
 
 enable_purex:
-	if (ql2xsmartsan)
+	if (ql2xrdpenable)
 		ha->fw_options[1] |= ADD_FO1_ENABLE_PUREX_IOCB;
 
 	qla2x00_set_fw_options(vha, ha->fw_options);
@@ -8682,7 +8688,7 @@ qla83xx_update_fw_options(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 
-	if (ql2xsmartsan)
+	if (ql2xrdpenable)
 		ha->fw_options[1] |= ADD_FO1_ENABLE_PUREX_IOCB;
 
 	qla2x00_set_fw_options(vha, ha->fw_options);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 96f5577d3679..4be99f13be42 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -113,7 +113,8 @@ module_param(ql2xfdmienable, int, S_IRUGO|S_IWUSR);
 module_param_named(fdmi, ql2xfdmienable, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xfdmienable,
 		"Enables FDMI registrations. "
-		"0 - no FDMI. Default is 1 - perform FDMI.");
+		"0 - no FDMI registrations. "
+		"1 - provide FDMI registrations (default).");
 
 #define MAX_Q_DEPTH	64
 static int ql2xmaxqdepth = MAX_Q_DEPTH;
@@ -313,6 +314,13 @@ MODULE_PARM_DESC(ql2xsmartsan,
                " Default is 0 - No SmartSAN registration,"
                " 1 - Register SmartSAN Management Attributes.");
 
+int ql2xrdpenable;
+module_param(ql2xrdpenable, int, 0444);
+module_param_named(rdpenable, ql2xrdpenable, int, 0444);
+MODULE_PARM_DESC(ql2xrdpenable,
+		"Enables RDP responses. "
+		"0 - no RDP responses (default). "
+		"1 - provide RDP responses.");
 
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
-- 
2.12.0

