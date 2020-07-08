Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFD8C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 16:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8728D206DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 16:25:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="Z+PutqzQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgGHQZm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 12:25:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7994 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730093AbgGHQZl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 12:25:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068GKf1x028312
        for <linux-scsi@vger.kernel.org>; Wed, 8 Jul 2020 09:25:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=RYOOMZhRlMARV9er+AJ03NppH7TLAJrjNt3O9xdWykw=;
 b=Z+PutqzQF6/3vv1T3xZTpAHuwTlKQ9Z8mVkIueve8MTl5lhmj46zCSvuvm+qbPfJdH4I
 dvH4mUiDWSxEqKEgsTWU3vWO1He07HZ922unEhhJYzI8iqKMQC8BVLrRhuBIT4k0zPsZ
 iw+4tso9OfZsn2xMKrUGvv9fi/pcmb1dZ9kZT6fKmZo3HI4BCurJDOAa7+yzGFlgsJGv
 k5mHxmJ/SrQmUG3n4qYjR9/cooI766GrBuJeAcdROXvP3LVv6JTUE101lfZYL0EHtaG8
 5VX4DXyHtwHtzX8u/H4MnLYmKorbJHlrdeDhtmFLWT35eAaGGEzqDVe5UaxsdsOMfb+4 SQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 322q4q1hmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 09:25:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 8 Jul
 2020 09:25:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 8 Jul
 2020 09:25:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Jul 2020 09:25:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 39D263F703F;
        Wed,  8 Jul 2020 09:25:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 068GPexb029840;
        Wed, 8 Jul 2020 09:25:40 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 068GPde2029839;
        Wed, 8 Jul 2020 09:25:39 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH] qla2xxx: Address a set of sparse warnings.
Date:   Wed, 8 Jul 2020 09:25:15 -0700
Message-ID: <20200708162515.29805-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_15:2020-07-08,2020-07-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

Fix sparse warnings,
drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: restricted __le16 degrades
to integer
drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: cast to restricted __le16

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 36 +++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_fw.h  | 28 +++++++++++++-------------
 drivers/scsi/qla2xxx/qla_isr.c |  4 ++--
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f6b8502a35ab..297291624ffb 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1997,13 +1997,13 @@ typedef struct {
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
 	uint32_t handle;		/* System handle. */
-	uint16_t scsi_status;		/* SCSI status. */
-	uint16_t comp_status;		/* Completion status. */
-	uint16_t state_flags;		/* State flags. */
-	uint16_t status_flags;		/* Status flags. */
-	uint16_t rsp_info_len;		/* Response Info Length. */
-	uint16_t req_sense_length;	/* Request sense data length. */
-	uint32_t residual_length;	/* Residual transfer length. */
+	__le16 scsi_status;		/* SCSI status. */
+	__le16 comp_status;		/* Completion status. */
+	__le16 state_flags;		/* State flags. */
+	__le16 status_flags;		/* Status flags. */
+	__le16 rsp_info_len;		/* Response Info Length. */
+	__le16 req_sense_length;	/* Request sense data length. */
+	__le32 residual_length;		/* Residual transfer length. */
 	uint8_t rsp_info[8];		/* FCP response information. */
 	uint8_t req_sense_data[32];	/* Request sense data. */
 } sts_entry_t;
@@ -2193,20 +2193,20 @@ struct mbx_entry {
 	uint32_t handle;
 	target_id_t loop_id;
 
-	uint16_t status;
-	uint16_t state_flags;
-	uint16_t status_flags;
+	__le16 status;
+	__le16 state_flags;
+	__le16 status_flags;
 
 	uint32_t sys_define2[2];
 
-	uint16_t mb0;
-	uint16_t mb1;
-	uint16_t mb2;
-	uint16_t mb3;
-	uint16_t mb6;
-	uint16_t mb7;
-	uint16_t mb9;
-	uint16_t mb10;
+	__le16 mb0;
+	__le16 mb1;
+	__le16 mb2;
+	__le16 mb3;
+	__le16 mb6;
+	__le16 mb7;
+	__le16 mb9;
+	__le16 mb10;
 	uint32_t reserved_2[2];
 	uint8_t node_name[WWN_SIZE];
 	uint8_t port_name[WWN_SIZE];
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index a0d83c67dc23..bc37539a77b5 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -604,32 +604,32 @@ struct sts_entry_24xx {
 
 	uint32_t handle;		/* System handle. */
 
-	uint16_t comp_status;		/* Completion status. */
-	uint16_t ox_id;			/* OX_ID used by the firmware. */
+	__le16 comp_status;		/* Completion status. */
+	__le16 ox_id;			/* OX_ID used by the firmware. */
 
-	uint32_t residual_len;		/* FW calc residual transfer length. */
+	__le32 residual_len;		/* FW calc residual transfer length. */
 
 	union {
-		uint16_t reserved_1;
-		uint16_t nvme_rsp_pyld_len;
+		__le16 reserved_1;
+		__le16 nvme_rsp_pyld_len;
 	};
 
-	uint16_t state_flags;		/* State flags. */
+	__le16 state_flags;		/* State flags. */
 #define SF_TRANSFERRED_DATA	BIT_11
 #define SF_NVME_ERSP            BIT_6
 #define SF_FCP_RSP_DMA		BIT_0
 
-	uint16_t retry_delay;
-	uint16_t scsi_status;		/* SCSI status. */
+	__le16 retry_delay;
+	__le16 scsi_status;		/* SCSI status. */
 #define SS_CONFIRMATION_REQ		BIT_12
 
-	uint32_t rsp_residual_count;	/* FCP RSP residual count. */
+	__le32 rsp_residual_count;	/* FCP RSP residual count. */
 
-	uint32_t sense_len;		/* FCP SENSE length. */
+	__le32 sense_len;		/* FCP SENSE length. */
 
 	union {
 		struct {
-			uint32_t rsp_data_len;	/* FCP response data length  */
+			__le32 rsp_data_len;	/* FCP response data length  */
 			uint8_t data[28];	/* FCP rsp/sense information */
 		};
 		struct nvme_fc_ersp_iu nvme_ersp;
@@ -742,10 +742,10 @@ struct purex_entry_24xx {
 	uint16_t status_flags;
 	uint16_t nport_handle;
 
-	uint16_t frame_size;
-	uint16_t trunc_frame_size;
+	__le16 frame_size;
+	__le16 trunc_frame_size;
 
-	uint32_t rx_xchg_addr;
+	__le32 rx_xchg_addr;
 
 	uint8_t d_id[3];
 	uint8_t r_ctl;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 039099ddc472..1c923ee75441 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -791,7 +791,7 @@ qla27xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
 	}
 }
 
-struct purex_item *
+static struct purex_item *
 qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
 {
 	struct purex_item *item = NULL;
@@ -879,7 +879,7 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 	struct purex_item *item;
 	void *fpin_pkt = NULL;
 
-	total_bytes = le16_to_cpu(purex->frame_size & 0x0FFF)
+	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF)
 	    - PURX_ELS_HEADER_SIZE;
 	pending_bytes = total_bytes;
 	entry_count = entry_count_remaining = purex->entry_count;
-- 
2.19.0.rc0

