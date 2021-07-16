Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CF6C07E95
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 11:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB0C9613FA
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 11:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhGPLcD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 07:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhGPLcB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2021 07:32:01 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCE3C06175F;
        Fri, 16 Jul 2021 04:29:07 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cu14so6307549pjb.0;
        Fri, 16 Jul 2021 04:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MC5tChpyKDO9MxxhXN9qZeQy1Mbjt8+9z3nY5NfMrUQ=;
        b=ai/jTwHWpQ5ES8PMU98tuswbaKLWebk9PuXn2q1k6WFGj1G6QK8waj1cFO2kWCzYfw
         JPZBeWXpzkPCDH/6D2aqmjoJMZIk1O6Ez+QNZRxuJckz/ylEE5QycBPYLVZuzErqZCM6
         APqGlcjdHpfiFxTq1m0wVyCkchEdcqr85E3IrKHvhb7eo3EQmjCI9t3nJNQH6cDHEIQ8
         Y8uV6AVSRQwmq+D3hXDsQOBG5jsLsA74ye2D1LZiji62oqefOO6ONec9hwCmPp4rNzzc
         xOP67hSzylBNqujqRUb+v74RnoLI1l9SeV7ixAGeEsYDAFo9FrBKehoYPQR+2P1Oii0w
         TL2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MC5tChpyKDO9MxxhXN9qZeQy1Mbjt8+9z3nY5NfMrUQ=;
        b=tRWTHMOi5IuuvRKu7TOVi/f7gxSXi0lv3jB/dTRK/KFeToy7AUPB6Je1CS/CkoHtzj
         Ck1K/WWvqheRu9bnyjT9GisPc4NzMFefmtKVNyEgPC7MdD4LJf8VTD4jpoDc6/8T23/W
         O0Z91prRW3/P5AZDetcK+Gdrc1bK0m4irwfhwXhDmq5OO03ClM5GAujwhBCJ3Su9ZJL5
         WeeTy0qmRSfDn3UyTRY8inymjyd3NNKTK517Vd1w5rggYcclSc+9IAfAWTtII5LpWNA8
         zOEEVi2M8ZSmRaCVGEA4nlRWLx54jAiVs6oWaL/gZ6aX6SCES2FmfUN5NfHeS2QSrfhS
         /w2Q==
X-Gm-Message-State: AOAM531pw3qxALr/hCZAsOz5lrH8Dt8oJ1DBYWAoAaB0gxI31hwj1t2I
        FihtO2MZVmo31X1nxiYFjrE=
X-Google-Smtp-Source: ABdhPJwxJFnGjK1YW5gQxdhUo/44vTB568gogq0iVx4wSRn8sVexjTyhX6yvzwP3YtrcPC1etetpEA==
X-Received: by 2002:a17:90a:1641:: with SMTP id x1mr9698536pje.160.1626434946395;
        Fri, 16 Jul 2021 04:29:06 -0700 (PDT)
Received: from localhost.localdomain ([49.37.48.177])
        by smtp.gmail.com with ESMTPSA id a15sm9861353pff.128.2021.07.16.04.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 04:29:05 -0700 (PDT)
From:   Dwaipayan Ray <dwaipayanray1@gmail.com>
To:     njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lukas.bulwahn@gmail.com, Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: [PATCH] scsi: qla4xxx: convert uses of __constant_cpu_to_<foo> to cpu_to_<foo>
Date:   Fri, 16 Jul 2021 16:58:52 +0530
Message-Id: <20210716112852.24598-1-dwaipayanray1@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The macros cpu_to_le16 and cpu_to_le32 has special cases for constants.
So their __constant_<foo> versions are not required.

In little endian systems, both cpu_to_le16 and __constant_cpu_to_le16
expand to the same expression. Same is the case with cpu_to_le32.

In big endian systems, cpu_to_le16 expands to __swab16 which has a
__builtin_constant_p check. Similarly, cpu_to_le32 expands to __swab32.

So these macros can be safely used with constants, and hence all those
uses are converted. This was discovered as a part of a checkpatch
evaluation, looking at all reports of WARNING:CONSTANT_CONVERSION
error type.

Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |  4 ++--
 drivers/scsi/qla4xxx/ql4_iocb.c |  2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c  | 30 +++++++++++++++---------------
 drivers/scsi/qla4xxx/ql4_nx.c   | 10 +++++-----
 drivers/scsi/qla4xxx/ql4_os.c   | 10 +++++-----
 5 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index f786ac2f5548..301bc09c8365 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -119,8 +119,8 @@ int qla4xxx_init_rings(struct scsi_qla_host *ha)
 		 * the interrupt_handler to think there are responses to be
 		 * processed when there aren't.
 		 */
-		ha->shadow_regs->req_q_out = __constant_cpu_to_le32(0);
-		ha->shadow_regs->rsp_q_in = __constant_cpu_to_le32(0);
+		ha->shadow_regs->req_q_out = cpu_to_le32(0);
+		ha->shadow_regs->rsp_q_in = cpu_to_le32(0);
 		wmb();
 
 		writel(0, &ha->reg->req_q_in);
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index cbd1e6ffcd67..c57cec6fff6d 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -160,7 +160,7 @@ static void qla4xxx_build_scsi_iocbs(struct srb *srb,
 
 	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
 		/* No data being transferred */
-		cmd_entry->ttlByteCnt = __constant_cpu_to_le32(0);
+		cmd_entry->ttlByteCnt = cpu_to_le32(0);
 		return;
 	}
 
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 187d78aa4f67..cd71074f3abe 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -645,8 +645,8 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 	/* Fill in the request and response queue information. */
 	init_fw_cb->rqq_consumer_idx = cpu_to_le16(ha->request_out);
 	init_fw_cb->compq_producer_idx = cpu_to_le16(ha->response_in);
-	init_fw_cb->rqq_len = __constant_cpu_to_le16(REQUEST_QUEUE_DEPTH);
-	init_fw_cb->compq_len = __constant_cpu_to_le16(RESPONSE_QUEUE_DEPTH);
+	init_fw_cb->rqq_len = cpu_to_le16(REQUEST_QUEUE_DEPTH);
+	init_fw_cb->compq_len = cpu_to_le16(RESPONSE_QUEUE_DEPTH);
 	init_fw_cb->rqq_addr_lo = cpu_to_le32(LSDW(ha->request_dma));
 	init_fw_cb->rqq_addr_hi = cpu_to_le32(MSDW(ha->request_dma));
 	init_fw_cb->compq_addr_lo = cpu_to_le32(LSDW(ha->response_dma));
@@ -656,20 +656,20 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 
 	/* Set up required options. */
 	init_fw_cb->fw_options |=
-		__constant_cpu_to_le16(FWOPT_SESSION_MODE |
-				       FWOPT_INITIATOR_MODE);
+		cpu_to_le16(FWOPT_SESSION_MODE |
+			    FWOPT_INITIATOR_MODE);
 
 	if (is_qla80XX(ha))
 		init_fw_cb->fw_options |=
-		    __constant_cpu_to_le16(FWOPT_ENABLE_CRBDB);
+		    cpu_to_le16(FWOPT_ENABLE_CRBDB);
 
-	init_fw_cb->fw_options &= __constant_cpu_to_le16(~FWOPT_TARGET_MODE);
+	init_fw_cb->fw_options &= cpu_to_le16(~FWOPT_TARGET_MODE);
 
 	init_fw_cb->add_fw_options = 0;
 	init_fw_cb->add_fw_options |=
-			__constant_cpu_to_le16(ADFWOPT_SERIALIZE_TASK_MGMT);
+			cpu_to_le16(ADFWOPT_SERIALIZE_TASK_MGMT);
 	init_fw_cb->add_fw_options |=
-			__constant_cpu_to_le16(ADFWOPT_AUTOCONN_DISABLE);
+			cpu_to_le16(ADFWOPT_AUTOCONN_DISABLE);
 
 	if (qla4xxx_set_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma)
 		!= QLA_SUCCESS) {
@@ -1613,7 +1613,7 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha, char *username, char *password,
 
 	strlcpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
 	strlcpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
-	chap_table->cookie = __constant_cpu_to_le16(CHAP_VALID_COOKIE);
+	chap_table->cookie = cpu_to_le16(CHAP_VALID_COOKIE);
 
 exit_get_chap:
 	dma_pool_free(ha->chap_dma_pool, chap_table, chap_dma);
@@ -1655,7 +1655,7 @@ int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username, char *password,
 	chap_table->secret_len = strlen(password);
 	strncpy(chap_table->secret, password, MAX_CHAP_SECRET_LEN - 1);
 	strncpy(chap_table->name, username, MAX_CHAP_NAME_LEN - 1);
-	chap_table->cookie = __constant_cpu_to_le16(CHAP_VALID_COOKIE);
+	chap_table->cookie = cpu_to_le16(CHAP_VALID_COOKIE);
 
 	if (is_qla40XX(ha)) {
 		chap_size = MAX_CHAP_ENTRIES_40XX * sizeof(*chap_table);
@@ -1721,7 +1721,7 @@ int qla4xxx_get_uni_chap_at_index(struct scsi_qla_host *ha, char *username,
 
 	mutex_lock(&ha->chap_sem);
 	chap_table = (struct ql4_chap_table *)ha->chap_list + chap_index;
-	if (chap_table->cookie != __constant_cpu_to_le16(CHAP_VALID_COOKIE)) {
+	if (chap_table->cookie != cpu_to_le16(CHAP_VALID_COOKIE)) {
 		rval = QLA_ERROR;
 		goto exit_unlock_uni_chap;
 	}
@@ -1784,7 +1784,7 @@ int qla4xxx_get_chap_index(struct scsi_qla_host *ha, char *username,
 	for (i = 0; i < max_chap_entries; i++) {
 		chap_table = (struct ql4_chap_table *)ha->chap_list + i;
 		if (chap_table->cookie !=
-		    __constant_cpu_to_le16(CHAP_VALID_COOKIE)) {
+		    cpu_to_le16(CHAP_VALID_COOKIE)) {
 			if (i > MAX_RESRV_CHAP_IDX && free_index == -1)
 				free_index = i;
 			continue;
@@ -2105,18 +2105,18 @@ int qla4xxx_set_param_ddbentry(struct scsi_qla_host *ha,
 
 	if (conn->max_recv_dlength)
 		fw_ddb_entry->iscsi_max_rcv_data_seg_len =
-		  __constant_cpu_to_le16((conn->max_recv_dlength / BYTE_UNITS));
+		  cpu_to_le16((conn->max_recv_dlength / BYTE_UNITS));
 
 	if (sess->max_r2t)
 		fw_ddb_entry->iscsi_max_outsnd_r2t = cpu_to_le16(sess->max_r2t);
 
 	if (sess->first_burst)
 		fw_ddb_entry->iscsi_first_burst_len =
-		       __constant_cpu_to_le16((sess->first_burst / BYTE_UNITS));
+		       cpu_to_le16((sess->first_burst / BYTE_UNITS));
 
 	if (sess->max_burst)
 		fw_ddb_entry->iscsi_max_burst_len =
-			__constant_cpu_to_le16((sess->max_burst / BYTE_UNITS));
+			cpu_to_le16((sess->max_burst / BYTE_UNITS));
 
 	if (sess->time2wait)
 		fw_ddb_entry->iscsi_def_time2wait =
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 66a487795c53..47adff9f0506 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3658,7 +3658,7 @@ qla4_82xx_read_flash_data(struct scsi_qla_host *ha, uint32_t *dwptr,
 			    "Do ROM fast read failed\n");
 			goto done_read;
 		}
-		dwptr[i] = __constant_cpu_to_le32(val);
+		dwptr[i] = cpu_to_le32(val);
 	}
 
 done_read:
@@ -3721,9 +3721,9 @@ qla4_8xxx_get_flt_info(struct scsi_qla_host *ha, uint32_t flt_addr)
 			goto no_flash_data;
 	}
 
-	if (*wptr == __constant_cpu_to_le16(0xffff))
+	if (*wptr == cpu_to_le16(0xffff))
 		goto no_flash_data;
-	if (flt->version != __constant_cpu_to_le16(1)) {
+	if (flt->version != cpu_to_le16(1)) {
 		DEBUG2(ql4_printk(KERN_INFO, ha, "Unsupported FLT detected: "
 			"version=0x%x length=0x%x checksum=0x%x.\n",
 			le16_to_cpu(flt->version), le16_to_cpu(flt->length),
@@ -3826,7 +3826,7 @@ qla4_82xx_get_fdt_info(struct scsi_qla_host *ha)
 	qla4_82xx_read_optrom_data(ha, (uint8_t *)ha->request_ring,
 	    hw->flt_region_fdt << 2, OPTROM_BURST_SIZE);
 
-	if (*wptr == __constant_cpu_to_le16(0xffff))
+	if (*wptr == cpu_to_le16(0xffff))
 		goto no_flash_data;
 
 	if (fdt->sig[0] != 'Q' || fdt->sig[1] != 'L' || fdt->sig[2] != 'I' ||
@@ -3883,7 +3883,7 @@ qla4_82xx_get_idc_param(struct scsi_qla_host *ha)
 	qla4_82xx_read_optrom_data(ha, (uint8_t *)ha->request_ring,
 			QLA82XX_IDC_PARAM_ADDR , 8);
 
-	if (*wptr == __constant_cpu_to_le32(0xffffffff)) {
+	if (*wptr == cpu_to_le32(0xffffffff)) {
 		ha->nx_dev_init_timeout = ROM_DEV_INIT_TIMEOUT;
 		ha->nx_reset_timeout = ROM_DRV_RESET_ACK_TIMEOUT;
 	} else {
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6ee7ea4c27e0..3f7737386193 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -702,7 +702,7 @@ static int qla4xxx_get_chap_by_index(struct scsi_qla_host *ha,
 
 	*chap_entry = (struct ql4_chap_table *)ha->chap_list + chap_index;
 	if ((*chap_entry)->cookie !=
-	     __constant_cpu_to_le16(CHAP_VALID_COOKIE)) {
+	     cpu_to_le16(CHAP_VALID_COOKIE)) {
 		*chap_entry = NULL;
 	} else {
 		rval = QLA_SUCCESS;
@@ -745,7 +745,7 @@ static int qla4xxx_find_free_chap_index(struct scsi_qla_host *ha,
 		chap_table = (struct ql4_chap_table *)ha->chap_list + i;
 
 		if ((chap_table->cookie !=
-		    __constant_cpu_to_le16(CHAP_VALID_COOKIE)) &&
+		    cpu_to_le16(CHAP_VALID_COOKIE)) &&
 		   (i > MAX_RESRV_CHAP_IDX)) {
 				free_index = i;
 				break;
@@ -794,7 +794,7 @@ static int qla4xxx_get_chap_list(struct Scsi_Host *shost, uint16_t chap_tbl_idx,
 	for (i = chap_tbl_idx; i < max_chap_entries; i++) {
 		chap_table = (struct ql4_chap_table *)ha->chap_list + i;
 		if (chap_table->cookie !=
-		    __constant_cpu_to_le16(CHAP_VALID_COOKIE))
+		    cpu_to_le16(CHAP_VALID_COOKIE))
 			continue;
 
 		chap_rec->chap_tbl_idx = i;
@@ -923,7 +923,7 @@ static int qla4xxx_delete_chap(struct Scsi_Host *shost, uint16_t chap_tbl_idx)
 		goto exit_delete_chap;
 	}
 
-	chap_table->cookie = __constant_cpu_to_le16(0xFFFF);
+	chap_table->cookie = cpu_to_le16(0xFFFF);
 
 	offset = FLASH_CHAP_OFFSET |
 			(chap_tbl_idx * sizeof(struct ql4_chap_table));
@@ -6043,7 +6043,7 @@ static int qla4xxx_get_bidi_chap(struct scsi_qla_host *ha, char *username,
 	for (i = 0; i < max_chap_entries; i++) {
 		chap_table = (struct ql4_chap_table *)ha->chap_list + i;
 		if (chap_table->cookie !=
-		    __constant_cpu_to_le16(CHAP_VALID_COOKIE)) {
+		    cpu_to_le16(CHAP_VALID_COOKIE)) {
 			continue;
 		}
 
-- 
2.28.0

