Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579F8C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F3E821D7D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfLSAu6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 19:50:58 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35969 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfLSAu6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 19:50:58 -0500
Received: by mail-pf1-f193.google.com with SMTP id x184so2182138pfb.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 16:50:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x7dHL3GVHBYHbaeYNJ5xlwpcirU4aNm9cjvA2IYIi4I=;
        b=iDvXgRxm4E5bev7RJhBmV9zUZIh4som8JnkOMxcvZVeAlpKU1jIk0acIqLOmHm80jd
         YJbt/K6wG1Rw9KOjzzm8xtrEJYrHBHDLfHtRtAcRvcvECJm9GhUAS0b6zXIiTRjufBFz
         1X+RMJ7rIRfsNrmr/8R7oI2hBcyTPh5tIcjSyTbOR5Kw4SuCBGBIY7foAQ0Fh6YThtiI
         8dSMLXsjYtAUDUYM4lz6pW1W9BGxhwIaYHZXD0X3ACuGBT1BsXuqAQxoG+9Z9YhSZG9L
         p2/8T02vD/PEPgUEt1VIuTJ2+6RjpPCcOGPda1qHzmhgQVQo/0RSqxLFEwByQ6UWSBnJ
         gIRg==
X-Gm-Message-State: APjAAAX0QHMvw+Zx30IObBlMDOE99adMi29QnD5Byg6BDSpVa67D6qj2
        lNdg2D+h1CQbGTBbIN1D7l4=
X-Google-Smtp-Source: APXvYqyrb0kzKODqrtD3gZoTM9yaMKE/eU8SWLnkA3bA3ri1058Dwy3rZMJGHkeYTy/Yk1O7u3LvvQ==
X-Received: by 2002:a63:1807:: with SMTP id y7mr5866587pgl.94.1576716657318;
        Wed, 18 Dec 2019 16:50:57 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id b8sm5047645pfr.64.2019.12.18.16.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 16:50:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] qla2xxx: Use get_unaligned_*() instead of open-coding these functions
Date:   Wed, 18 Dec 2019 16:50:50 -0800
Message-Id: <20191219005050.40193-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch improves readability and does not change any functionality.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c    |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c    | 12 ++++++------
 drivers/scsi/qla2xxx/qla_nx.c     |  6 +++---
 drivers/scsi/qla2xxx/qla_target.c | 12 ++++++------
 drivers/scsi/qla2xxx/qla_target.h |  3 +--
 5 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index cbaf178fc979..941c40e13acc 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -796,7 +796,7 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 
 	if (atomic_read(&vha->loop_state) == LOOP_READY &&
 	    (ha->current_topology == ISP_CFG_F ||
-	    (le32_to_cpu(*(uint32_t *)req_data) == ELS_OPCODE_BYTE &&
+	    (get_unaligned_le32(req_data) == ELS_OPCODE_BYTE &&
 	     req_data_len == MAX_ELS_FRAME_PAYLOAD)) &&
 	    elreq.options == EXTERNAL_LOOPBACK) {
 		type = "FC_BSG_HST_VENDOR_ECHO_DIAG";
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ddd73b7c14d5..efb3ac31138d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2152,12 +2152,12 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 	 * swab32 of the "data" field in the beginning of qla2x00_status_entry()
 	 * would make guard field appear at offset 2
 	 */
-	a_guard   = le16_to_cpu(*(uint16_t *)(ap + 2));
-	a_app_tag = le16_to_cpu(*(uint16_t *)(ap + 0));
-	a_ref_tag = le32_to_cpu(*(uint32_t *)(ap + 4));
-	e_guard   = le16_to_cpu(*(uint16_t *)(ep + 2));
-	e_app_tag = le16_to_cpu(*(uint16_t *)(ep + 0));
-	e_ref_tag = le32_to_cpu(*(uint32_t *)(ep + 4));
+	a_guard   = get_unaligned_le16(ap + 2);
+	a_app_tag = get_unaligned_le16(ap + 0);
+	a_ref_tag = get_unaligned_le32(ap + 4);
+	e_guard   = get_unaligned_le16(ep + 2);
+	e_app_tag = get_unaligned_le16(ep + 0);
+	e_ref_tag = get_unaligned_le32(ep + 4);
 
 	ql_dbg(ql_dbg_io, vha, 0x3023,
 	    "iocb(s) %p Returned STATUS.\n", sts24);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index c855d013ba8a..49b1a43802c1 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1882,7 +1882,7 @@ qla82xx_set_product_offset(struct qla_hw_data *ha)
 static int
 qla82xx_validate_firmware_blob(scsi_qla_host_t *vha, uint8_t fw_type)
 {
-	__le32 val;
+	uint32_t val;
 	uint32_t min_size;
 	struct qla_hw_data *ha = vha->hw;
 	const struct firmware *fw = ha->hablob->fw;
@@ -1895,8 +1895,8 @@ qla82xx_validate_firmware_blob(scsi_qla_host_t *vha, uint8_t fw_type)
 
 		min_size = QLA82XX_URI_FW_MIN_SIZE;
 	} else {
-		val = cpu_to_le32(*(u32 *)&fw->data[QLA82XX_FW_MAGIC_OFFSET]);
-		if ((__force u32)val != QLA82XX_BDINFO_MAGIC)
+		val = get_unaligned_le32(&fw->data[QLA82XX_FW_MAGIC_OFFSET]);
+		if (val != QLA82XX_BDINFO_MAGIC)
 			return -EINVAL;
 
 		min_size = QLA82XX_FW_MIN_SIZE;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 68c14143e50e..7d6132ce67b5 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3446,13 +3446,13 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 
 	cmd->trc_flags |= TRC_DIF_ERR;
 
-	cmd->a_guard   = be16_to_cpu(*(uint16_t *)(ap + 0));
-	cmd->a_app_tag = be16_to_cpu(*(uint16_t *)(ap + 2));
-	cmd->a_ref_tag = be32_to_cpu(*(uint32_t *)(ap + 4));
+	cmd->a_guard   = get_unaligned_be16(ap + 0);
+	cmd->a_app_tag = get_unaligned_be16(ap + 2);
+	cmd->a_ref_tag = get_unaligned_be32(ap + 4);
 
-	cmd->e_guard   = be16_to_cpu(*(uint16_t *)(ep + 0));
-	cmd->e_app_tag = be16_to_cpu(*(uint16_t *)(ep + 2));
-	cmd->e_ref_tag = be32_to_cpu(*(uint32_t *)(ep + 4));
+	cmd->e_guard   = get_unaligned_be16(ep + 0);
+	cmd->e_app_tag = get_unaligned_be16(ep + 2);
+	cmd->e_ref_tag = get_unaligned_be32(ep + 4);
 
 	ql_dbg(ql_dbg_tgt_dif, vha, 0xf075,
 	    "%s: aborted %d state %d\n", __func__, cmd->aborted, cmd->state);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index d006f0a97b8c..6539499e9e95 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -379,8 +379,7 @@ static inline int get_datalen_for_atio(struct atio_from_isp *atio)
 {
 	int len = atio->u.isp24.fcp_cmnd.add_cdb_len;
 
-	return (be32_to_cpu(get_unaligned((uint32_t *)
-	    &atio->u.isp24.fcp_cmnd.add_cdb[len * 4])));
+	return get_unaligned_be32(&atio->u.isp24.fcp_cmnd.add_cdb[len * 4]);
 }
 
 #define CTIO_TYPE7 0x12 /* Continue target I/O entry (for 24xx) */
