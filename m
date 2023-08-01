Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE8AC001E0
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 11:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbjHALl1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 07:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbjHALlU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 07:41:20 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D32E43
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 04:41:17 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 371ALieX015236
        for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2023 04:41:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=EQheTtWVV4RseIFMEW+Kf3yIsDzs1vhdNqr0Q0mjeTc=;
 b=jdqnwjY1KxFYQOMaRQ8qtPZvl78AnkkL7FMTDoBgM5d2TqVpC9KpZVk/0x6tmi8H2727
 +3LHicvPoGbMpNL4InetMWWh6BPOl6giqEtEWIa3ElUmIfxh6mw0N9ZcNBMUnlYd1E4v
 sq6zZRK4d/y+A8nzljvWTtIQ8pPBHNtqkZ3c+W2V0lrujKKZCKIhSvRSNAvw2G53DK3o
 GP6BoM12Pz5UqEQpVXbd9arijoMVyqI4dLkkbInL4rMCtYMXxFfdlNNYLt2JlNuJLHHg
 0lzuoS5FRpG3fHg2KklLESWMdiG3pFIvlsM1dhOK82UO2hMLUUTIkWgVtnAZ6wVZD0MS 4A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3s707dg82u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 04:41:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 1 Aug
 2023 04:41:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 1 Aug 2023 04:41:15 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id DEB903F704B;
        Tue,  1 Aug 2023 04:41:13 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 06/10] qla2xxx: Remove unsupported ql2xenabledif option.
Date:   Tue, 1 Aug 2023 17:10:53 +0530
Message-ID: <20230801114057.27039-7-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230801114057.27039-1-njavali@marvell.com>
References: <20230801114057.27039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Yk3TahpmDxEItptOAMUxPr0M1rABrgx6
X-Proofpoint-ORIG-GUID: Yk3TahpmDxEItptOAMUxPr0M1rABrgx6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_06,2023-08-01_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Manish Rangankar <mrangankar@marvell.com>

User accidently pass module param ql2xenabledif=1, which is unsupported
in driver, but driver still progress and lead to guard tag error during
device discovery.

Remove unsupported ql2xenabledif=1 option and validate the user input.

Cc: stable@vger.kernel.org
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 --
 drivers/scsi/qla2xxx/qla_dbg.c  | 2 +-
 drivers/scsi/qla2xxx/qla_os.c   | 9 +++++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index b00222459607..44449c70a375 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3093,8 +3093,6 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 			vha->flags.difdix_supported = 1;
 			ql_dbg(ql_dbg_user, vha, 0x7082,
 			    "Registered for DIF/DIX type 1 and 3 protection.\n");
-			if (ql2xenabledif == 1)
-				prot = SHOST_DIX_TYPE0_PROTECTION;
 			scsi_host_set_prot(vha->host,
 			    prot | SHOST_DIF_TYPE1_PROTECTION
 			    | SHOST_DIF_TYPE2_PROTECTION
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 4d104425146b..691ef827a5ab 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -17,7 +17,7 @@
  * | Queue Command and IO tracing |       0x3074       | 0x300b         |
  * |                              |                    | 0x3027-0x3028  |
  * |                              |                    | 0x303d-0x3041  |
- * |                              |                    | 0x302d,0x3033  |
+ * |                              |                    | 0x302e,0x3033  |
  * |                              |                    | 0x3036,0x3038  |
  * |                              |                    | 0x303a		|
  * | DPC Thread                   |       0x4023       | 0x4002,0x4013  |
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7da13607e239..b9f9d1bb2634 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3288,6 +3288,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->max_id = ha->max_fibre_devices;
 	host->cmd_per_lun = 3;
 	host->unique_id = host->host_no;
+
+	if (ql2xenabledif && ql2xenabledif != 2) {
+		ql_log(ql_log_warn, base_vha, 0x302d,
+		       "Invalid value for ql2xenabledif, resetting it to default (2)\n");
+		ql2xenabledif = 2;
+	}
+
 	if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif)
 		host->max_cmd_len = 32;
 	else
@@ -3524,8 +3531,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			base_vha->flags.difdix_supported = 1;
 			ql_dbg(ql_dbg_init, base_vha, 0x00f1,
 			    "Registering for DIF/DIX type 1 and 3 protection.\n");
-			if (ql2xenabledif == 1)
-				prot = SHOST_DIX_TYPE0_PROTECTION;
 			if (ql2xprotmask)
 				scsi_host_set_prot(host, ql2xprotmask);
 			else
-- 
2.23.1

