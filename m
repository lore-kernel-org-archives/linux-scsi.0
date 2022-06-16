Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05304C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 05:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358626AbiFPFfT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358575AbiFPFfP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 01:35:15 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64795A094
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FN9tAe014579
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=t9K0bQIsh0c5jQVaXBFGyZQ5hkIlvJDDEFPQEIyDcXk=;
 b=O2VNRIEBc2kkmaxirx+TtYi+kbDbWcBSe4BCAJ7Z5Hzbao8UmMQyWiYrzZg29vRPjydn
 DlcwY0uMX/uKTK/rt63inWo0L4uK1nk2DxrvMpCP0vi77nwlkwLlBWx+cUUEsGA+XvO9
 kIslkQh9uIRUvOiCfoD/wjTA94dbh91Sw6ekSK9dyt2whPBMnBXUrX39fxBcA4bm1oev
 /D1imjZr5PzxKZEcsvEpnzaVEjYFdONnBWm9+Ql7hfcV2RwDsoqdj0Mh+2nBl1XyD91H
 /huoK9hXmhyH2TW7rJRuy9fayaebpB6FXGmwKUcBjiU/VUYwx7ZDwx+zhuRmn79HwIso Ww== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gqruu977w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jun
 2022 22:35:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 15 Jun 2022 22:35:12 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EE37F3F70B1;
        Wed, 15 Jun 2022 22:35:11 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 04/11] qla2xxx: Turn off multi-queue for 8G adapter
Date:   Wed, 15 Jun 2022 22:35:01 -0700
Message-ID: <20220616053508.27186-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220616053508.27186-1-njavali@marvell.com>
References: <20220616053508.27186-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: klCSuV8z7guKpEN8pXoGoQ7LjpLbfTfU
X-Proofpoint-GUID: klCSuV8z7guKpEN8pXoGoQ7LjpLbfTfU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_02,2022-06-15_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For 8G adapter, multi-queue was enabled accidentally.
This patch make sure multi-queue is not enabled accidentally.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  4 ++--
 drivers/scsi/qla2xxx/qla_isr.c | 16 ++++++----------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 74d4234e5a31..89cb6c24258d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4273,8 +4273,8 @@ struct qla_hw_data {
 #define IS_OEM_001(ha)          ((ha)->device_type & DT_OEM_001)
 #define HAS_EXTENDED_IDS(ha)    ((ha)->device_type & DT_EXTENDED_IDS)
 #define IS_CT6_SUPPORTED(ha)	((ha)->device_type & DT_CT6_SUPPORTED)
-#define IS_MQUE_CAPABLE(ha)	((ha)->mqenable || IS_QLA83XX(ha) || \
-				IS_QLA27XX(ha) || IS_QLA28XX(ha))
+#define IS_MQUE_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
+				 IS_QLA28XX(ha))
 #define IS_BIDI_CAPABLE(ha) \
     (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
 /* Bit 21 of fw_attributes decides the MCTP capabilities */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9af9b35edc27..24f9a3b116d8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4430,16 +4430,12 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	}
 
 	/* Enable MSI-X vector for response queue update for queue 0 */
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-		if (ha->msixbase && ha->mqiobase &&
-		    (ha->max_rsp_queues > 1 || ha->max_req_queues > 1 ||
-		     ql2xmqsupport))
-			ha->mqenable = 1;
-	} else
-		if (ha->mqiobase &&
-		    (ha->max_rsp_queues > 1 || ha->max_req_queues > 1 ||
-		     ql2xmqsupport))
-			ha->mqenable = 1;
+	if (IS_MQUE_CAPABLE(ha) &&
+	    (ha->msixbase && ha->mqiobase && ha->max_qpairs))
+		ha->mqenable = 1;
+	else
+		ha->mqenable = 0;
+
 	ql_dbg(ql_dbg_multiq, vha, 0xc005,
 	    "mqiobase=%p, max_rsp_queues=%d, max_req_queues=%d.\n",
 	    ha->mqiobase, ha->max_rsp_queues, ha->max_req_queues);
-- 
2.19.0.rc0

