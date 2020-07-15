Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F0EC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 04:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91E482067D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 04:34:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="l9WMoeZh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgGOEe0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 00:34:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:15082 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725770AbgGOEeZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Jul 2020 00:34:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06F4Ut4O020258
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 21:34:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=nRgQdunPDbdvPqwkqsiD60WDvKyaQ7/601ehiSwGmPQ=;
 b=l9WMoeZhpWYKdFIRGhZ53DCogU9r3SgOVI3yEcQu5gRTGdsVekCB3Efbr0mr05OguOoT
 xcQ096dOrZc07xJUutDOCInIMKzcH0fWxpTGco5xWCVS8gJ+sIEI3LN6RqFw/Q4P6snB
 JMpW9AQZOo68EYGJATxfkjJhueKaKL41A2Z8Zmot8P8bIzXI2dYvQeicdqW6DmWn8Ra6
 3yUE1usbQkzwZ1bzGuU4cdrkLf4xDLTuxgs0MNRSlWETL2IOnUAUxMUfV1a5DUuGGJd2
 LcBDySld9OPV8Z/YuZ1HXjjiXIcouxcVT6rrcUxw7+A2q+C51W7JVA743s+zC70rQPvV Yg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asnfwnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 21:34:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 14 Jul
 2020 21:34:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 14 Jul
 2020 21:34:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 14 Jul 2020 21:34:23 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3DA753F703F;
        Tue, 14 Jul 2020 21:34:23 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 06F4YNhF021713;
        Tue, 14 Jul 2020 21:34:23 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 06F4YMPG021702;
        Tue, 14 Jul 2020 21:34:22 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2] qla2xxx: Address a set of sparse warnings.
Date:   Tue, 14 Jul 2020 21:33:58 -0700
Message-ID: <20200715043358.21668-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_02:2020-07-14,2020-07-15 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

v1->v2:
- Rebase on 5.9/scsi-queue

Fix sparse warnings,
drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: restricted __le16 degrades
to integer
drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: cast to restricted __le16

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_fw.h  | 2 +-
 drivers/scsi/qla2xxx/qla_isr.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 49403fb1c3f7..bba1b77fba7e 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -610,7 +610,7 @@ struct sts_entry_24xx {
 	__le32	residual_len;		/* FW calc residual transfer length. */
 
 	union {
-		uint16_t reserved_1;
+		__le16 reserved_1;
 		__le16	nvme_rsp_pyld_len;
 	};
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7be32de2ae06..27bcd346af7c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -790,7 +790,7 @@ qla27xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
 	}
 }
 
-struct purex_item *
+static struct purex_item *
 qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
 {
 	struct purex_item *item = NULL;
@@ -878,7 +878,7 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 	struct purex_item *item;
 	void *fpin_pkt = NULL;
 
-	total_bytes = le16_to_cpu(purex->frame_size & 0x0FFF)
+	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF)
 	    - PURX_ELS_HEADER_SIZE;
 	pending_bytes = total_bytes;
 	entry_count = entry_count_remaining = purex->entry_count;
-- 
2.19.0.rc0

