Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433D4C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1968D20738
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X0VdXngJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgGGOBH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgGGOBG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 10:01:06 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA01C061755
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 07:01:05 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o2so46636754wmh.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 07:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uauyj1xy+L+/htMK5ksIUAg7Hy+icFikuL1ZKHn5ieg=;
        b=X0VdXngJ93DIwxDMbMyZ1nk58HNjto/r57/NTazOTe/czfJ1X+ndWnxUIrt4mC2sko
         Bg9tEsmuJACn5nkgagX5dsQd3zqJXichqtOKyNGywBUekWWAmlgzyBKqkolKgNwDOR/4
         EMAMoUGrqwHdUqmAcREP7TdENCahylOtUGAV/7Zj+45uHQMC3vKqkckD94TsYkpIfX70
         lBxcBlWyb8f2tYZmO/Hp2ryf4gYWAxf9W8psNISB38HDNPx+kj0nzDIQvvkdDKDEtF0F
         6lTtOU5ZXOtrVBqq81FwpPjV3NROGzzkGdYNfhiMMdblcBxvJnrcLNZ9V8cOa0ET93on
         Onlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uauyj1xy+L+/htMK5ksIUAg7Hy+icFikuL1ZKHn5ieg=;
        b=VFXUSxC5PSHc4VvZRpeCOuEP5GKLDrZrsFqguMHnS+j8n1G3d3RC6B6a37eYA+OTVw
         CmufSrKQdIjjdoR2j62tRdxxPYAyVcdDlnjqc/2oK0KDSSaP3KeHW/tcMw25BYkK+urP
         p/QsuzaTLD+IMIIal+tfosIz6HEpH/ht8qYz7OQJhCDI032rdaasae7X8gwIADpYg08J
         1KEv+DkwsfWdx3f4rD8Ee9toacHOQjqjig52Cw0QxH30V5sQfkIZnzb/QBAdYLR8zw5N
         GoBsbh5kUO6uFrbnE+TZUAqh8OHEc3enfkQ0+n+yAs4BYyA4TcJd0eUNwXyFt4O7xFPw
         XCXw==
X-Gm-Message-State: AOAM531SAMwVi3f7/6cmQq/crrN9vAb7tW8cbSFwjZWW+c2fS8P/2rfY
        IE6fEnQ8BgDbqpRaIjnqUaLqvA==
X-Google-Smtp-Source: ABdhPJy/4OMcjd0sn2ElOe4Gl9FVRLZ4ak2S2TRlrf1xoSVam74NomkbmdNNjeyBZ7pGslVPB+K4Rw==
X-Received: by 2002:a1c:5418:: with SMTP id i24mr4169805wmb.47.1594130464199;
        Tue, 07 Jul 2020 07:01:04 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id z25sm1102823wmk.28.2020.07.07.07.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:01:03 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        megaraidlinux.pdl@broadcom.com
Subject: [PATCH 04/10] scsi: megaraid: megaraid_sas_fusion: Fix-up a whole myriad of kerneldoc misdemeanours
Date:   Tue,  7 Jul 2020 15:00:49 +0100
Message-Id: <20200707140055.2956235-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707140055.2956235-1-lee.jones@linaro.org>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/megaraid/megaraid_sas_fusion.c:106: warning: Function parameter or member 'instance' not described in 'megasas_adp_reset_wait_for_ready'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:106: warning: Function parameter or member 'do_adp_reset' not described in 'megasas_adp_reset_wait_for_ready'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:106: warning: Function parameter or member 'ocr_context' not described in 'megasas_adp_reset_wait_for_ready'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:159: warning: Function parameter or member 'instance' not described in 'megasas_check_same_4gb_region'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:159: warning: Function parameter or member 'start_addr' not described in 'megasas_check_same_4gb_region'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:159: warning: Function parameter or member 'size' not described in 'megasas_check_same_4gb_region'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:181: warning: Function parameter or member 'instance' not described in 'megasas_enable_intr_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:181: warning: Excess function parameter 'regs' description in 'megasas_enable_intr_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:203: warning: Function parameter or member 'instance' not described in 'megasas_disable_intr_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:203: warning: Excess function parameter 'regs' description in 'megasas_disable_intr_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:246: warning: Function parameter or member 'blk_tag' not described in 'megasas_get_cmd_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:323: warning: Function parameter or member 'fw_boot_context' not described in 'megasas_fusion_update_can_queue'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:1025: warning: Function parameter or member 'seconds' not described in 'wait_and_poll'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:1912: warning: Function parameter or member 'work' not described in 'megasas_fault_detect_work'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2001: warning: Function parameter or member 'fusion' not described in 'map_cmd_status'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2001: warning: Function parameter or member 'scmd' not described in 'map_cmd_status'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2001: warning: Function parameter or member 'data_length' not described in 'map_cmd_status'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2001: warning: Function parameter or member 'sense' not described in 'map_cmd_status'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2001: warning: Excess function parameter 'cmd' description in 'map_cmd_status'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2245: warning: Function parameter or member 'sge_count' not described in 'megasas_make_sgl_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2356: warning: Function parameter or member 'io_request' not described in 'megasas_set_pd_lba'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2356: warning: Function parameter or member 'io_info' not described in 'megasas_set_pd_lba'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2356: warning: Function parameter or member 'scp' not described in 'megasas_set_pd_lba'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2356: warning: Function parameter or member 'local_map_ptr' not described in 'megasas_set_pd_lba'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2356: warning: Function parameter or member 'ref_tag' not described in 'megasas_set_pd_lba'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2356: warning: Excess function parameter 'cdb' description in 'megasas_set_pd_lba'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2356: warning: Excess function parameter 'start_blk' description in 'megasas_set_pd_lba'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2617: warning: Function parameter or member 'fusion' not described in 'megasas_set_raidflag_cpu_affinity'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2617: warning: Function parameter or member 'scsi_buff_len' not described in 'megasas_set_raidflag_cpu_affinity'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2950: warning: Function parameter or member 'scmd' not described in 'megasas_build_ld_nonrw_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:2950: warning: Excess function parameter 'scp' description in 'megasas_build_ld_nonrw_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3041: warning: Function parameter or member 'scmd' not described in 'megasas_build_syspd_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3041: warning: Excess function parameter 'scp' description in 'megasas_build_syspd_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3414: warning: Function parameter or member 'cmd' not described in 'megasas_complete_r1_command'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3414: warning: Excess function parameter 'cmd_fusion' description in 'megasas_complete_r1_command'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3467: warning: Function parameter or member 'MSIxIndex' not described in 'complete_cmd_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3467: warning: Function parameter or member 'irq_context' not described in 'complete_cmd_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3639: warning: Function parameter or member 'instance' not described in 'megasas_enable_irq_poll'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3656: warning: Function parameter or member 'instance_addr' not described in 'megasas_sync_irqs'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3656: warning: Excess function parameter 'instance' description in 'megasas_sync_irqs'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3715: warning: Function parameter or member 'instance_addr' not described in 'megasas_complete_cmd_dpc_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3715: warning: Excess function parameter 'instance' description in 'megasas_complete_cmd_dpc_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3734: warning: Function parameter or member 'irq' not described in 'megasas_isr_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3734: warning: Function parameter or member 'devp' not described in 'megasas_isr_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3772: warning: Function parameter or member 'mfi_cmd' not described in 'build_mpt_mfi_pass_thru'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3887: warning: Function parameter or member 'instance' not described in 'megasas_read_fw_status_reg_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3887: warning: Excess function parameter 'regs' description in 'megasas_read_fw_status_reg_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3937: warning: Function parameter or member 'instance' not described in 'megasas_adp_reset_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:4014: warning: Function parameter or member 'instance' not described in 'megasas_check_reset_fusion'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:4346: warning: Function parameter or member 'instance' not described in 'megasas_tm_response_code'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:4346: warning: Excess function parameter 'ioc' description in 'megasas_tm_response_code'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:4408: warning: Function parameter or member 'mr_device_priv_data' not described in 'megasas_issue_tm'
 drivers/scsi/megaraid/megaraid_sas_fusion.c:4408: warning: Excess function parameter 'm_type' description in 'megasas_issue_tm'

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: megaraidlinux.pdl@broadcom.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 73 ++++++++++++---------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 319f241da4b66..a0cf55776361c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -90,9 +90,9 @@ extern u32 megasas_readl(struct megasas_instance *instance,
 /**
  * megasas_adp_reset_wait_for_ready -	initiate chip reset and wait for
  *					controller to come to ready state
- * @instance -				adapter's soft state
- * @do_adp_reset -			If true, do a chip reset
- * @ocr_context -			If called from OCR context this will
+ * @instance:				adapter's soft state
+ * @do_adp_reset:			If true, do a chip reset
+ * @ocr_context:			If called from OCR context this will
  *					be set to 1, else 0
  *
  * This function initates a chip reset followed by a wait for controller to
@@ -146,10 +146,10 @@ megasas_adp_reset_wait_for_ready(struct megasas_instance *instance,
 /**
  * megasas_check_same_4gb_region -	check if allocation
  *					crosses same 4GB boundary or not
- * @instance -				adapter's soft instance
- * start_addr -			start address of DMA allocation
- * size -				size of allocation in bytes
- * return -				true : allocation does not cross same
+ * @instance:				adapter's soft instance
+ * @start_addr:			start address of DMA allocation
+ * @size:				size of allocation in bytes
+ * @return:				true : allocation does not cross same
  *					4GB boundary
  *					false: allocation crosses same
  *					4GB boundary
@@ -174,7 +174,7 @@ static inline bool megasas_check_same_4gb_region
 
 /**
  * megasas_enable_intr_fusion -	Enables interrupts
- * @regs:			MFI register set
+ * @instance:		Adapter soft state
  */
 static void
 megasas_enable_intr_fusion(struct megasas_instance *instance)
@@ -196,7 +196,7 @@ megasas_enable_intr_fusion(struct megasas_instance *instance)
 
 /**
  * megasas_disable_intr_fusion - Disables interrupt
- * @regs:			 MFI register set
+ * @instance:		Adapter soft state
  */
 static void
 megasas_disable_intr_fusion(struct megasas_instance *instance)
@@ -238,6 +238,7 @@ megasas_clear_intr_fusion(struct megasas_instance *instance)
 /**
  * megasas_get_cmd_fusion -	Get a command from the free pool
  * @instance:		Adapter soft state
+ * @blk_tag:		Index into the command list
  *
  * Returns a blk_tag indexed mpt frame
  */
@@ -310,7 +311,7 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
 /**
  * megasas_fusion_update_can_queue -	Do all Adapter Queue depth related calculations here
  * @instance:							Adapter soft state
- * fw_boot_context:						Whether this function called during probe or after OCR
+ * @fw_boot_context:						Whether this function called during probe or after OCR
  *
  * This function is only for fusion controllers.
  * Update host can queue, if firmware downgrade max supported firmware commands.
@@ -1016,6 +1017,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
  * wait_and_poll -	Issues a polling command
  * @instance:			Adapter soft state
  * @cmd:			Command packet to be issued
+ * @seconds:			Total seconds to wait
  *
  * For polling, MFI requires the cmd_status to be set to 0xFF before posting.
  */
@@ -1906,6 +1908,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 /**
  * megasas_fault_detect_work	-	Worker function of
  *					FW fault handling workqueue.
+ * @work:	Pointer to work information
  */
 static void
 megasas_fault_detect_work(struct work_struct *work)
@@ -1989,9 +1992,12 @@ megasas_fusion_stop_watchdog(struct megasas_instance *instance)
 
 /**
  * map_cmd_status -	Maps FW cmd status to OS cmd status
- * @cmd :		Pointer to cmd
+ * @fusion :		Pointer to driver data
+ * @scmd :		Pointer to SCSI cmd
  * @status :		status of cmd returned by FW
  * @ext_status :	ext status of cmd returned by FW
+ * @data_length :	size of reqeusted data
+ * @sense :		sense data
  */
 
 static void
@@ -2234,8 +2240,7 @@ megasas_make_prp_nvme(struct megasas_instance *instance, struct scsi_cmnd *scmd,
  * @scp:		SCSI command from the mid-layer
  * @sgl_ptr:		SGL to be filled in
  * @cmd:		cmd we are working on
- * @sge_count		sge count
- *
+ * @sge_count:		sge count
  */
 static void
 megasas_make_sgl_fusion(struct megasas_instance *instance,
@@ -2341,11 +2346,9 @@ int megasas_make_sgl(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	return sge_count;
 }
 
-/**
+/*
  * megasas_set_pd_lba -	Sets PD LBA
- * @cdb:		CDB
  * @cdb_len:		cdb length
- * @start_blk:		Start block of IO
  *
  * Used to set the PD LBA in CDB for FP IOs
  */
@@ -2603,11 +2606,12 @@ static void megasas_stream_detect(struct megasas_instance *instance,
  * affinity (cpu of the controller) and raid_flags in the raid context
  * based on IO type.
  *
+ * @fusion :		Pointer to driver data
  * @praid_context:	IO RAID context
  * @raid:		LD raid map
  * @fp_possible:	Is fast path possible?
  * @is_read:		Is read IO?
- *
+ * @scsi_buff_len:	SCSI buffer length
  */
 static void
 megasas_set_raidflag_cpu_affinity(struct fusion_context *fusion,
@@ -2940,7 +2944,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 /**
  * megasas_build_ld_nonrw_fusion - prepares non rw ios for virtual disk
  * @instance:		Adapter soft state
- * @scp:		SCSI command
+ * @scmd:		SCSI command
  * @cmd:		Command to be prepared
  *
  * Prepares the io_request frame for non-rw io cmds for vd.
@@ -3028,7 +3032,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 /**
  * megasas_build_syspd_fusion - prepares rw/non-rw ios for syspd
  * @instance:		Adapter soft state
- * @scp:		SCSI command
+ * @scmd:		SCSI command
  * @cmd:		Command to be prepared
  * @fp_possible:	parameter to detect fast path or firmware path io.
  *
@@ -3405,7 +3409,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
  * megasas_complete_r1_command -
  * completes R1 FP write commands which has valid peer smid
  * @instance:			Adapter soft state
- * @cmd_fusion:			MPT command frame
+ * @cmd:			MPT command frame
  *
  */
 static inline void
@@ -3456,7 +3460,7 @@ megasas_complete_r1_command(struct megasas_instance *instance,
 	}
 }
 
-/**
+/*
  * complete_cmd_fusion -	Completes command
  * @instance:			Adapter soft state
  * Completes all commands that is in reply descriptor queue
@@ -3634,6 +3638,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 
 /**
  * megasas_enable_irq_poll() - enable irqpoll
+ * @instance:			Adapter soft state
  */
 static void megasas_enable_irq_poll(struct megasas_instance *instance)
 {
@@ -3650,7 +3655,7 @@ static void megasas_enable_irq_poll(struct megasas_instance *instance)
 
 /**
  * megasas_sync_irqs -	Synchronizes all IRQs owned by adapter
- * @instance:			Adapter soft state
+ * @instance_addr:		Adapter soft state
  */
 static void megasas_sync_irqs(unsigned long instance_addr)
 {
@@ -3706,7 +3711,7 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 
 /**
  * megasas_complete_cmd_dpc_fusion -	Completes command
- * @instance:			Adapter soft state
+ * @instance_addr:		Adapter soft state
  *
  * Tasklet to complete cmds
  */
@@ -3729,6 +3734,8 @@ megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 
 /**
  * megasas_isr_fusion - isr entry point
+ * @irq:	Interrupt number
+ * @devp:	Interrupt contect
  */
 static irqreturn_t megasas_isr_fusion(int irq, void *devp)
 {
@@ -3763,7 +3770,7 @@ static irqreturn_t megasas_isr_fusion(int irq, void *devp)
 /**
  * build_mpt_mfi_pass_thru - builds a cmd fo MFI Pass thru
  * @instance:			Adapter soft state
- * mfi_cmd:			megasas_cmd pointer
+ * @mfi_cmd:			megasas_cmd pointer
  *
  */
 static void
@@ -3880,7 +3887,7 @@ megasas_release_fusion(struct megasas_instance *instance)
 
 /**
  * megasas_read_fw_status_reg_fusion - returns the current FW status value
- * @regs:			MFI register set
+ * @instance:			Adapter soft state
  */
 static u32
 megasas_read_fw_status_reg_fusion(struct megasas_instance *instance)
@@ -3929,7 +3936,8 @@ megasas_free_host_crash_buffer(struct megasas_instance *instance)
 
 /**
  * megasas_adp_reset_fusion -	For controller reset
- * @regs:				MFI register set
+ * @instance:			Adapter soft state
+ * @regs:			MFI register set
  */
 static int
 megasas_adp_reset_fusion(struct megasas_instance *instance,
@@ -4006,7 +4014,8 @@ megasas_adp_reset_fusion(struct megasas_instance *instance,
 
 /**
  * megasas_check_reset_fusion -	For controller reset check
- * @regs:				MFI register set
+ * @instance:			Adapter soft state
+ * @regs:			MFI register set
  */
 static int
 megasas_check_reset_fusion(struct megasas_instance *instance,
@@ -4168,7 +4177,7 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
 	}
 }
 
-/*
+/**
  * megasas_refire_mgmt_cmd :	Re-fire management commands
  * @instance:				Controller's soft instance
 */
@@ -4267,7 +4276,7 @@ static void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
 	}
 }
 
-/*
+/**
  * megasas_return_polled_cmds: Return polled mode commands back to the pool
  *			       before initiating an OCR.
  * @instance:                  Controller's soft instance
@@ -4298,7 +4307,7 @@ megasas_return_polled_cmds(struct megasas_instance *instance)
 	}
 }
 
-/*
+/**
  * megasas_track_scsiio : Track SCSI IOs outstanding to a SCSI device
  * @instance: per adapter struct
  * @channel: the channel assigned by the OS
@@ -4335,7 +4344,7 @@ static int megasas_track_scsiio(struct megasas_instance *instance,
 
 /**
  * megasas_tm_response_code - translation of device response code
- * @ioc: per adapter object
+ * @instance:                  Controller's soft instance
  * @mpi_reply: MPI reply returned by firmware
  *
  * Return nothing.
@@ -4393,7 +4402,7 @@ megasas_tm_response_code(struct megasas_instance *instance,
  * @id: the id assigned by the OS
  * @type: MPI2_SCSITASKMGMT_TASKTYPE__XXX (defined in megaraid_sas_fusion.c)
  * @smid_task: smid assigned to the task
- * @m_type: TM_MUTEX_ON or TM_MUTEX_OFF
+ * @mr_device_priv_data: Private device data
  * Context: user
  *
  * MegaRaid use MPT interface for Task Magement request.
-- 
2.25.1

