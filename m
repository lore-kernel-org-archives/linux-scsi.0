Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6F1C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 06:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C014A20706
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 06:45:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="f+bdDieD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgHYGp6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 02:45:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24096 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729076AbgHYGp5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Aug 2020 02:45:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07P6Uh3m031764
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 23:45:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=FoO5pJ8MoblbrNIXEe7414IX8h9wAv8EYQQiKofxqU4=;
 b=f+bdDieDbNkX5doEg8V1XNkBcwNCwd5PinrRS+6u4mPJljUHdU4vthWyTmMchgBv0VI9
 j58ut1tnm6uhPq8b/uy1GxCrfe+qA6PZ2vhi4iF1d2rarshmDifh65c2UBHaRNrl04wI
 QGq/FtsBeN26Na+nLiAWZfux9J5UobPODhRVJWKc5lZch6iZ2J8GiB5hgXh8pvEYa5rI
 RHjNl5KlUzQPBJEthzB9iwS9+RN/23A3+8aggA6d492VZtS1wMXbzAPDSDI7H5OT6fie
 VNTSY2znZUjjWUru1PcTtD9WDpPVe/uCaFJqXJ1+ga5eZAuvkPw3ch50rxhcSE72qHHz Ow== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3330qpjue0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 23:45:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Aug
 2020 23:45:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 Aug 2020 23:45:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F039B3F703F;
        Mon, 24 Aug 2020 23:45:54 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07P6jsFX016430;
        Mon, 24 Aug 2020 23:45:54 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07P6jsCO016429;
        Mon, 24 Aug 2020 23:45:54 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 4/8] qedf: FDMI Enhancement.
Date:   Mon, 24 Aug 2020 23:43:50 -0700
Message-ID: <20200825064354.16361-5-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200825064354.16361-1-jhasan@marvell.com>
References: <20200825064354.16361-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_12:2020-08-24,2020-08-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-Added attributes for RHBA and RPA registration.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf.h      |  5 +++
 drivers/scsi/qedf/qedf_main.c | 78 +++++++++++++++++++++++++++++--------------
 2 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index e163be8..15d6cbe 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -544,6 +544,11 @@ extern void qedf_process_seq_cleanup_compl(struct qedf_ctx *qedf,
 
 #define FCOE_WORD_TO_BYTE  4
 #define QEDF_MAX_TASK_NUM	0xFFFF
+#define QL45xxx			0x165C
+#define QL41xxx			0x8080
+#define MAX_CT_PAYLOAD		2048
+#define DISCOVERED_PORTS	4
+#define NUMBER_OF_PORTS		1
 
 struct fip_vlan {
 	struct ethhdr eth;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index ccf6a99..bf1b755 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1623,11 +1623,13 @@ static void qedf_fcoe_ctlr_setup(struct qedf_ctx *qedf)
 static void qedf_setup_fdmi(struct qedf_ctx *qedf)
 {
 	struct fc_lport *lport = qedf->lport;
-	struct fc_host_attrs *fc_host = shost_to_fc_host(lport->host);
-	u64 dsn;
+	u8 buf[8];
+	int pos;
+	uint32_t i;
 
 	/*
-	 * fdmi_enabled needs to be set for libfc to execute FDMI registration.
+	 * fdmi_enabled needs to be set for libfc
+	 * to execute FDMI registration
 	 */
 	lport->fdmi_enabled = 1;
 
@@ -1637,32 +1639,53 @@ static void qedf_setup_fdmi(struct qedf_ctx *qedf)
 	 */
 
 	/* Get the PCI-e Device Serial Number Capability */
-	dsn = pci_get_dsn(qedf->pdev);
-	if (dsn)
-		snprintf(fc_host->serial_number,
-		    sizeof(fc_host->serial_number), "%016llX", dsn);
-	else
-		snprintf(fc_host->serial_number,
-		    sizeof(fc_host->serial_number), "Unknown");
+	pos = pci_find_ext_capability(qedf->pdev, PCI_EXT_CAP_ID_DSN);
+	if (pos) {
+		pos += 4;
+		for (i = 0; i < 8; i++)
+			pci_read_config_byte(qedf->pdev, pos + i, &buf[i]);
+
+		snprintf(fc_host_serial_number(lport->host),
+		    FC_SERIAL_NUMBER_SIZE,
+		    "%02X%02X%02X%02X%02X%02X%02X%02X",
+		    buf[7], buf[6], buf[5], buf[4],
+		    buf[3], buf[2], buf[1], buf[0]);
+	} else
+		snprintf(fc_host_serial_number(lport->host),
+		    FC_SERIAL_NUMBER_SIZE, "Unknown");
+
+	snprintf(fc_host_manufacturer(lport->host),
+	    FC_SERIAL_NUMBER_SIZE, "%s", "Marvell Semiconductor Inc.");
+
+	if (qedf->pdev->device == QL45xxx) {
+		snprintf(fc_host_model(lport->host),
+			FC_SYMBOLIC_NAME_SIZE, "%s", "QL45xxx");
 
-	snprintf(fc_host->manufacturer,
-	    sizeof(fc_host->manufacturer), "%s", "Cavium Inc.");
+		snprintf(fc_host_model_description(lport->host),
+			FC_SYMBOLIC_NAME_SIZE, "%s",
+			"Marvell FastLinQ QL45xxx FCoE Adapter");
+	}
+
+	if (qedf->pdev->device == QL41xxx) {
+		snprintf(fc_host_model(lport->host),
+			FC_SYMBOLIC_NAME_SIZE, "%s", "QL41xxx");
 
-	snprintf(fc_host->model, sizeof(fc_host->model), "%s", "QL41000");
+		snprintf(fc_host_model_description(lport->host),
+			FC_SYMBOLIC_NAME_SIZE, "%s",
+			"Marvell FastLinQ QL41xxx FCoE Adapter");
+	}
 
-	snprintf(fc_host->model_description, sizeof(fc_host->model_description),
-	    "%s", "QLogic FastLinQ QL41000 Series 10/25/40/50GGbE Controller"
-	    "(FCoE)");
+	snprintf(fc_host_hardware_version(lport->host),
+	    FC_VERSION_STRING_SIZE, "Rev %d", qedf->pdev->revision);
 
-	snprintf(fc_host->hardware_version, sizeof(fc_host->hardware_version),
-	    "Rev %d", qedf->pdev->revision);
+	snprintf(fc_host_driver_version(lport->host),
+	    FC_VERSION_STRING_SIZE, "%s", QEDF_VERSION);
 
-	snprintf(fc_host->driver_version, sizeof(fc_host->driver_version),
-	    "%s", QEDF_VERSION);
+	snprintf(fc_host_firmware_version(lport->host),
+	    FC_VERSION_STRING_SIZE, "%d.%d.%d.%d",
+	    FW_MAJOR_VERSION, FW_MINOR_VERSION, FW_REVISION_VERSION,
+	    FW_ENGINEERING_VERSION);
 
-	snprintf(fc_host->firmware_version, sizeof(fc_host->firmware_version),
-	    "%d.%d.%d.%d", FW_MAJOR_VERSION, FW_MINOR_VERSION,
-	    FW_REVISION_VERSION, FW_ENGINEERING_VERSION);
 }
 
 static int qedf_lport_setup(struct qedf_ctx *qedf)
@@ -1709,8 +1732,13 @@ static int qedf_lport_setup(struct qedf_ctx *qedf)
 	fc_host_dev_loss_tmo(lport->host) = qedf_dev_loss_tmo;
 
 	/* Set symbolic node name */
-	snprintf(fc_host_symbolic_name(lport->host), 256,
-	    "QLogic %s v%s", QEDF_MODULE_NAME, QEDF_VERSION);
+	if (qedf->pdev->device == QL45xxx)
+		snprintf(fc_host_symbolic_name(lport->host), 256,
+			"Marvell FastLinQ 45xxx FCoE v%s", QEDF_VERSION);
+
+	if (qedf->pdev->device == QL41xxx)
+		snprintf(fc_host_symbolic_name(lport->host), 256,
+			"Marvell FastLinQ 41xxx FCoE v%s", QEDF_VERSION);
 
 	qedf_setup_fdmi(qedf);
 
-- 
1.8.3.1

