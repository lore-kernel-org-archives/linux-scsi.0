Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C86C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 19:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4366560F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 19:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbhJLTVE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 15:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbhJLTVD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 15:21:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222F3C061570
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 12:19:02 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso2635644pjb.4
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 12:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=loi9qa3yWIa9HrTdIfuN4GNDklMHPyUlomTVozxKKNk=;
        b=fyOo+pV+fTQyXwFNd4eR2hrY4bWqwsaArJIxNYDROQgTQqAbhWWjOi5QWL0e0Mj6kp
         dKb1504J7G6fZMFbRROyPpC51F2gRdicVFlnbqMYFb6RKw66BaNPOgqpH6q77lp9O+tG
         XoiZqhEbN4ww5wvo6eWKnlwzmTHT6GdpRPM8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=loi9qa3yWIa9HrTdIfuN4GNDklMHPyUlomTVozxKKNk=;
        b=8GUUaqTHcbZvw8h5e6uCocLly7WshmZTdP19Ixe6xKVZxydMQ/H4/XojPhbsOE/11i
         gwKXL4T5cq72XoFG6SDv5MGHyyI1d1oSYnCmbOQJLuQZpb+pf6NqIfjRNEm46E+DzC1A
         gasqxOj3nHvlVeWkwibEVbcGRkOMgNjyYGalTg+OgSt05OzSO3jRyup56iRwvnzV0RaU
         zUu2O7zab0yl1lyoaRjK6EcsQRuTGNJqJgYLFM1NnEL98iBxoFX4WQPg9TqOUdVmvJrB
         SrUaBMrNhy/SuCXlJfZg4w04ihvl/tZQs++VmSXBKmawZJYGq1QtJfUEf75Fv68dAwhV
         U1iQ==
X-Gm-Message-State: AOAM531zori+v2UoxCd/nsOezHMPQvX5uOGfCEAMBVIKTMruseKVOH5t
        P6vhVqyKwiV4NJY7H10ZSJuO0QRH3KxdG0SDTxcIF7ocltbR8Mft8IZfBw5+4atAw1TRXODGqD6
        zY/LeoN/YLnX/GLSmS188LajVHpnavVDT3XIxTAWCbzTw3Be3FwgZ3aJeI1VZU9cFv7pQK8mCWG
        8E+cGk7cBq
X-Google-Smtp-Source: ABdhPJwyoZFjrMOFvX4NHE3i1ud5vKGmIAkMc73ovb9rY3xUHPOOmR9vf3c2lqQB5faoOqi6tjokog==
X-Received: by 2002:a17:903:246:b0:13f:2ff9:8b93 with SMTP id j6-20020a170903024600b0013f2ff98b93mr16159178plh.54.1634066341208;
        Tue, 12 Oct 2021 12:19:01 -0700 (PDT)
Received: from dev-jgu.dev.purestorage.com ([192.30.188.252])
        by smtp.googlemail.com with ESMTPSA id 139sm11838872pfz.35.2021.10.12.12.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 12:19:00 -0700 (PDT)
From:   Joy Gu <jgu@purestorage.com>
To:     linux-scsi@vger.kernel.org
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        bvanassche@acm.org, Joy Gu <jgu@purestorage.com>
Subject: [PATCH 2/2] scsi: qla2xxx: Initialize uninitialized variables
Date:   Tue, 12 Oct 2021 12:18:34 -0700
Message-Id: <20211012191834.90306-3-jgu@purestorage.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211012191834.90306-1-jgu@purestorage.com>
References: <20211012191834.90306-1-jgu@purestorage.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Zero-initialize variables left uninitialized by qla2x00_mailbox_command(),
qla8044_reg_indirect(), qla83xx_rd_reg(), and
__qla83xx_get_idc_control(). Initialize mc in qla2x00_dump_mctp_data()
so that mcp->mb[10] |= BIT_7 doesn't have an unexpected result.

Signed-off-by: Joy Gu <jgu@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 6 +++---
 drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
 drivers/scsi/qla2xxx/qla_nx2.c  | 2 +-
 drivers/scsi/qla2xxx/qla_os.c   | 8 ++++----
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d09776b77af2..6f504b313089 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -698,7 +698,7 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	int type;
-	uint32_t idc_control;
+	uint32_t idc_control = 0;
 	uint8_t *tmp_data = NULL;
 
 	if (off != 0)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5fc7697f0af4..8f8ba47ac2c0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6631,8 +6631,8 @@ void
 qla83xx_reset_ownership(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	uint32_t drv_presence, drv_presence_mask;
-	uint32_t dev_part_info1, dev_part_info2, class_type;
+	uint32_t drv_presence = 0, drv_presence_mask;
+	uint32_t dev_part_info1 = 0, dev_part_info2 = 0, class_type;
 	uint32_t class_type_mask = 0x3;
 	uint16_t fcoe_other_function = 0xffff, i;
 
@@ -6776,7 +6776,7 @@ static int
 qla83xx_initiating_reset(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	uint32_t  idc_control, dev_state;
+	uint32_t  idc_control = 0, dev_state = 0;
 
 	__qla83xx_get_idc_control(vha, &idc_control);
 	if ((idc_control & QLA83XX_IDC_RESET_DISABLED)) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7811c4952035..b8037763c174 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1681,7 +1681,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
     uint8_t *area, uint8_t *domain, uint16_t *top, uint16_t *sw_cap)
 {
 	int rval;
-	mbx_cmd_t mc;
+	mbx_cmd_t mc = { 0, };
 	mbx_cmd_t *mcp = &mc;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1046,
@@ -2257,7 +2257,7 @@ qla2x00_get_port_name(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t *name,
     uint8_t opt)
 {
 	int rval;
-	mbx_cmd_t mc;
+	mbx_cmd_t mc = { 0, };
 	mbx_cmd_t *mcp = &mc;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1057,
@@ -6366,7 +6366,7 @@ qla2x00_dump_mctp_data(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t addr,
 	uint32_t size)
 {
 	int rval;
-	mbx_cmd_t mc;
+	mbx_cmd_t mc = { 0, };
 	mbx_cmd_t *mcp = &mc;
 
 	if (!IS_MCTP_CAPABLE(vha->hw))
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 5ceecc9642fc..18beeb062ee3 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -2466,7 +2466,7 @@ qla8044_minidump_process_l2tag(struct scsi_qla_host *vha,
 	uint32_t addr, r_addr, c_addr, t_r_addr;
 	uint32_t i, k, loop_count, t_value, r_cnt, r_value;
 	unsigned long p_wait, w_time, p_mask;
-	uint32_t c_value_w, c_value_r;
+	uint32_t c_value_w, c_value_r = 0;
 	struct qla8044_minidump_entry_cache *cache_hdr;
 	int rval = QLA_FUNCTION_FAILED;
 	uint32_t *data_ptr = *d_ptr;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d2e40aaba734..4fe00da03a20 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5656,7 +5656,7 @@ qla83xx_check_nic_core_fw_alive(scsi_qla_host_t *base_vha)
 {
 	int rval = QLA_SUCCESS;
 	unsigned long heart_beat_wait = jiffies + (1 * HZ);
-	uint32_t heart_beat_counter1, heart_beat_counter2;
+	uint32_t heart_beat_counter1 = 0, heart_beat_counter2 = 0;
 
 	do {
 		if (time_after(jiffies, heart_beat_wait)) {
@@ -5726,7 +5726,7 @@ qla83xx_service_idc_aen(struct work_struct *work)
 	struct qla_hw_data *ha =
 		container_of(work, struct qla_hw_data, idc_aen);
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
-	uint32_t dev_state, idc_control;
+	uint32_t dev_state = 0, idc_control = 0;
 
 	qla83xx_idc_lock(base_vha, 0);
 	qla83xx_rd_reg(base_vha, QLA83XX_IDC_DEV_STATE, &dev_state);
@@ -6507,7 +6507,7 @@ static void
 qla83xx_need_reset_handler(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	uint32_t drv_ack, drv_presence;
+	uint32_t drv_ack = 0, drv_presence = 0;
 	unsigned long ack_timeout;
 
 	/* Wait for IDC ACK from all functions (DRV-ACK == DRV-PRESENCE) */
@@ -6546,7 +6546,7 @@ static int
 qla83xx_device_bootstrap(scsi_qla_host_t *vha)
 {
 	int rval = QLA_SUCCESS;
-	uint32_t idc_control;
+	uint32_t idc_control = 0;
 
 	qla83xx_wr_reg(vha, QLA83XX_IDC_DEV_STATE, QLA8XXX_DEV_INITIALIZING);
 	ql_log(ql_log_info, vha, 0xb069, "HW State: INITIALIZING.\n");
-- 
2.17.1

