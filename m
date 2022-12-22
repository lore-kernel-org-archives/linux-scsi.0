Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAC2C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 04:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbiLVEkY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 23:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiLVEjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 23:39:46 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19541A3AE
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:45 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BM4OKMo020309
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=syCxd692celOp/euXxqcnd34/oaIkTBsRfF9vJBtHbA=;
 b=lPh0km7mrjldnxWHSBhVIBi5J3TVNZVHXx1ZmDfx+AfARa7d7MGq1+4JhCE9Ib9txjAZ
 MIHUaNDZC7Ouq2Ism6d2O8FOsJyA4Y4M+rZPJ/XAGTHntPt5r8LdlMHUDlKnNhYUkZcn
 N03qaRN73SGOASr1GdJU/nQtPY6QBOrdqkslL+HgptR0flEQDFAWV2ISgFUaeMLPa5W0
 U52256KC8QDQDtaytnpoN6YePoN992C0nUV8p7Zs/byny7txOlX2ne/jWX0MFy4qbqLf
 /EujMf2TbNLUhOQiQRr4RJ16HQNKKzMN3VROQKYGlSylTdIVnlKfZwjtX0VomqhyKh0W 7g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3mhe5rsdhc-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 21 Dec
 2022 20:39:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 21 Dec 2022 20:39:41 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 88E753F7066;
        Wed, 21 Dec 2022 20:39:41 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 08/10] qla2xxx: edif - fix clang warning
Date:   Wed, 21 Dec 2022 20:39:31 -0800
Message-ID: <20221222043933.2825-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221222043933.2825-1-njavali@marvell.com>
References: <20221222043933.2825-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: qHqZCa0i7ABJ3A5TM7L50H6fExyOyhp9
X-Proofpoint-ORIG-GUID: qHqZCa0i7ABJ3A5TM7L50H6fExyOyhp9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_01,2022-12-21_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

clang warning:
  drivers/scsi/qla2xxx/qla_edif_bsg.h:93:12: warning: field remote_pid
  within 'struct app_pinfo_req' is less aligned than 'port_id_t' and is
  usually due to 'struct app_pinfo_req' being packed, which can lead to
  unaligned accesses [-Wunaligned-access]
  port_id_t remote_pid;
	        ^
  2 warnings generated.

Remove u32 field in remote_pid to silent warning.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 7ebb336e45ef (scsi: qla2xxx: edif: Add start + stop bsgs)
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c     |  4 +++-
 drivers/scsi/qla2xxx/qla_edif_bsg.h | 15 ++++++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 4ed94745fee5..4189fd2c1e52 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -967,7 +967,9 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			if (!(fcport->flags & FCF_FCSP_DEVICE))
 				continue;
 
-			tdid = app_req.remote_pid;
+			tdid.b.domain = app_req.remote_pid.domain;
+			tdid.b.area = app_req.remote_pid.area;
+			tdid.b.al_pa = app_req.remote_pid.al_pa;
 
 			ql_dbg(ql_dbg_edif, vha, 0x2058,
 			    "APP request entry - portid=%06x.\n", tdid.b24);
diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
index 0931f4e4e127..514c265ba86e 100644
--- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -89,7 +89,20 @@ struct app_plogi_reply {
 struct app_pinfo_req {
 	struct app_id app_info;
 	uint8_t	 num_ports;
-	port_id_t remote_pid;
+	struct {
+#ifdef __BIG_ENDIAN
+		uint8_t domain;
+		uint8_t area;
+		uint8_t al_pa;
+#elif defined(__LITTLE_ENDIAN)
+		uint8_t al_pa;
+		uint8_t area;
+		uint8_t domain;
+#else
+#error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined!"
+#endif
+		uint8_t rsvd_1;
+	} remote_pid;
 	uint8_t		version;
 	uint8_t		pad[VND_CMD_PAD_SIZE];
 	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
-- 
2.19.0.rc0

