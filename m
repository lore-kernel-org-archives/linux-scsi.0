Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48508C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1354A2072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VpAhhBUG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgGMIAW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729244AbgGMIAV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:21 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5492CC061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:21 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o8so12341262wmh.4
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EB1Ee82K4f4wX+Lz3kbrIOyla+XpjuhxPTOuxM4xsjo=;
        b=VpAhhBUGsGTosEsQ0dXvwysf4egG19rBIQYkaz1ArmHODF3O+nfwIPWMcDk5Sgfa1z
         lQV9XY7VNmH8eUpmY60Y7oAUm81Ezp7PDr5iuftYMlxdL+P34EWLCZ6QRoaeZgeb6mpv
         nblocbP/rq2yqbAL1S2daEC3bn53cTW+bTgXKHOCjkAGGJWCLPLehSyQmwYExFMqFKW3
         zvBHP138KQi/GruKsQ83zVBuQVRqJ1Yc6wPf6i8rcTzAr5jbvfV5FTFpYVHtBZN0dWNl
         tR/mySJxx95RVn4H3Vl9Q3w/L71igX4etUg4ybGPIgOiCCAdsuPIzWHgvxJ3pldIrdTL
         kMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EB1Ee82K4f4wX+Lz3kbrIOyla+XpjuhxPTOuxM4xsjo=;
        b=XEzgC2YCNNmFce6e3Z3cniHgBDjgz9otKp6MyjGSwNTiP3I8wzxzZZy219+W5Bojib
         YbXsMZwAlpdqZmnIGmUnQuhRX2mQMfp+6fyxcTW0Pyjep12wH6dmNqd1ZRaVqu+hflUD
         vSKlHVsbfLM+z2DFQQUFu7GDMybxQZuUy1N6dnZ71EzQJltyICgnWIV+HeiExxQM1GZM
         l8rWMa3BJ5b7uteH+5Z6Kas2oSe14z0QdjW/JeCVe3TG5Cy+eYSyCyFfmQIoZARdRgTA
         4KLLtBzaeqFxEpHinRnTm5MNf9EouX8ylgKq2cQm/qxrhsDcQY/ABOkEBbVNZQ51rSU5
         IFwQ==
X-Gm-Message-State: AOAM533d7HwCTIZSgr44KVKnWBjtSQp3HrPzLj1tZuJIrwvpDBcLO+c1
        HWLgEtw1lefud/ENl8bBax9H1w==
X-Google-Smtp-Source: ABdhPJxwtx3c6Zus1PQb5YHDu1hDMkgOQjr7NuEbryPggSNrHNE0T50lanXyA5CSgE7UEc5jtN3XDw==
X-Received: by 2002:a7b:c4d8:: with SMTP id g24mr16749924wmk.127.1594627219765;
        Mon, 13 Jul 2020 01:00:19 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:18 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Brian King <brking@us.ibm.com>
Subject: [PATCH v2 11/24] scsi: ipr: Fix a mountain of kerneldoc misdemeanours
Date:   Mon, 13 Jul 2020 08:59:48 +0100
Message-Id: <20200713080001.128044-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Mainly misspellings and/or missing function parameter descriptions.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/ipr.c:10100:15: warning: variable ‘int_reg’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/ipr.c:679: warning: Function parameter or member 'fast_done' not described in 'ipr_init_ipr_cmnd'
 drivers/scsi/ipr.c:697: warning: Function parameter or member 'hrrq' not described in '__ipr_get_free_ipr_cmnd'
 drivers/scsi/ipr.c:697: warning: Excess function parameter 'ioa_cfg' description in '__ipr_get_free_ipr_cmnd'
 drivers/scsi/ipr.c:1297: warning: Function parameter or member 'buffer' not described in '__ipr_format_res_path'
 drivers/scsi/ipr.c:1297: warning: Excess function parameter 'buf' description in '__ipr_format_res_path'
 drivers/scsi/ipr.c:1321: warning: Function parameter or member 'buffer' not described in 'ipr_format_res_path'
 drivers/scsi/ipr.c:1321: warning: Excess function parameter 'buf' description in 'ipr_format_res_path'
 drivers/scsi/ipr.c:1400: warning: Excess function parameter 'cfgtew' description in 'ipr_clear_res_target'
 drivers/scsi/ipr.c:2679: warning: Function parameter or member 't' not described in 'ipr_timeout'
 drivers/scsi/ipr.c:2679: warning: Excess function parameter 'ipr_cmd' description in 'ipr_timeout'
 drivers/scsi/ipr.c:2712: warning: Function parameter or member 't' not described in 'ipr_oper_timeout'
 drivers/scsi/ipr.c:2712: warning: Excess function parameter 'ipr_cmd' description in 'ipr_oper_timeout'
 drivers/scsi/ipr.c:3494: warning: Function parameter or member 'attr' not described in 'ipr_show_fw_version'
 drivers/scsi/ipr.c:3528: warning: Function parameter or member 'attr' not described in 'ipr_show_log_level'
 drivers/scsi/ipr.c:3551: warning: Function parameter or member 'attr' not described in 'ipr_store_log_level'
 drivers/scsi/ipr.c:3551: warning: Function parameter or member 'count' not described in 'ipr_store_log_level'
 drivers/scsi/ipr.c:3586: warning: Function parameter or member 'attr' not described in 'ipr_store_diagnostics'
 drivers/scsi/ipr.c:3642: warning: Function parameter or member 'dev' not described in 'ipr_show_adapter_state'
 drivers/scsi/ipr.c:3642: warning: Function parameter or member 'attr' not described in 'ipr_show_adapter_state'
 drivers/scsi/ipr.c:3642: warning: Excess function parameter 'class_dev' description in 'ipr_show_adapter_state'
 drivers/scsi/ipr.c:3671: warning: Function parameter or member 'attr' not described in 'ipr_store_adapter_state'
 drivers/scsi/ipr.c:3722: warning: Function parameter or member 'attr' not described in 'ipr_store_reset_adapter'
 drivers/scsi/ipr.c:3783: warning: Function parameter or member 'attr' not described in 'ipr_store_iopoll_weight'
 drivers/scsi/ipr.c:3783: warning: Function parameter or member 'count' not described in 'ipr_store_iopoll_weight'
 drivers/scsi/ipr.c:3883: warning: Function parameter or member 'sglist' not described in 'ipr_free_ucode_buffer'
 drivers/scsi/ipr.c:3883: warning: Excess function parameter 'p_dnld' description in 'ipr_free_ucode_buffer'
 drivers/scsi/ipr.c:4074: warning: Function parameter or member 'dev' not described in 'ipr_store_update_fw'
 drivers/scsi/ipr.c:4074: warning: Function parameter or member 'attr' not described in 'ipr_store_update_fw'
 drivers/scsi/ipr.c:4074: warning: Excess function parameter 'class_dev' description in 'ipr_store_update_fw'
 drivers/scsi/ipr.c:4149: warning: Function parameter or member 'attr' not described in 'ipr_show_fw_type'
 drivers/scsi/ipr.c:4489: warning: Excess function parameter 'reason' description in 'ipr_change_queue_depth'
 drivers/scsi/ipr.c:4660: warning: Function parameter or member 'attr' not described in 'ipr_show_raw_mode'
 drivers/scsi/ipr.c:4688: warning: Function parameter or member 'attr' not described in 'ipr_store_raw_mode'
 drivers/scsi/ipr.c:4688: warning: Function parameter or member 'count' not described in 'ipr_store_raw_mode'
 drivers/scsi/ipr.c:5069: warning: Function parameter or member 'ipr_cmd' not described in 'ipr_cmnd_is_free'
 drivers/scsi/ipr.c:5108: warning: Function parameter or member 'ioa_cfg' not described in 'ipr_wait_for_ops'
 drivers/scsi/ipr.c:5108: warning: Excess function parameter 'ipr_cmd' description in 'ipr_wait_for_ops'
 drivers/scsi/ipr.c:5272: warning: Function parameter or member 'deadline' not described in 'ipr_sata_reset'
 drivers/scsi/ipr.c:5453: warning: Function parameter or member 't' not described in 'ipr_abort_timeout'
 drivers/scsi/ipr.c:5453: warning: Excess function parameter 'ipr_cmd' description in 'ipr_abort_timeout'
 drivers/scsi/ipr.c:5578: warning: Function parameter or member 'shost' not described in 'ipr_scan_finished'
 drivers/scsi/ipr.c:5578: warning: Function parameter or member 'elapsed_time' not described in 'ipr_scan_finished'
 drivers/scsi/ipr.c:5578: warning: Excess function parameter 'scsi_cmd' description in 'ipr_scan_finished'
 drivers/scsi/ipr.c:5704: warning: Function parameter or member 'number' not described in 'ipr_isr_eh'
 drivers/scsi/ipr.c:6278: warning: Function parameter or member 'ipr_cmd' not described in 'ipr_gen_sense'
 drivers/scsi/ipr.c:6278: warning: Excess function parameter 'ioasa' description in 'ipr_gen_sense'
 drivers/scsi/ipr.c:6278: warning: Excess function parameter 'sense_buf' description in 'ipr_gen_sense'
 drivers/scsi/ipr.c:6711: warning: Function parameter or member 'host' not described in 'ipr_ioa_info'
 drivers/scsi/ipr.c:6711: warning: Excess function parameter 'scsi_host' description in 'ipr_ioa_info'
 drivers/scsi/ipr.c:7606: warning: Function parameter or member 'res_handle' not described in 'ipr_build_mode_sense'
 drivers/scsi/ipr.c:7606: warning: Excess function parameter 'res' description in 'ipr_build_mode_sense'
 drivers/scsi/ipr.c:7947: warning: Function parameter or member 'ipr_cmd' not described in 'ipr_ioafp_set_caching_parameters'
 drivers/scsi/ipr.c:7986: warning: Function parameter or member 'flags' not described in 'ipr_ioafp_inquiry'
 drivers/scsi/ipr.c:7986: warning: Function parameter or member 'page' not described in 'ipr_ioafp_inquiry'
 drivers/scsi/ipr.c:7986: warning: Function parameter or member 'dma_addr' not described in 'ipr_ioafp_inquiry'
 drivers/scsi/ipr.c:7986: warning: Function parameter or member 'xfer_len' not described in 'ipr_ioafp_inquiry'
 drivers/scsi/ipr.c:8280: warning: Function parameter or member 't' not described in 'ipr_reset_timer_done'
 drivers/scsi/ipr.c:8280: warning: Excess function parameter 'ipr_cmd' description in 'ipr_reset_timer_done'
 drivers/scsi/ipr.c:9486: warning: bad line:
 drivers/scsi/ipr.c:9609: warning: Function parameter or member 'ioa_cfg' not described in 'ipr_free_all_resources'
 drivers/scsi/ipr.c:9609: warning: Excess function parameter 'ipr_cmd' description in 'ipr_free_all_resources'
 drivers/scsi/ipr.c:10071: warning: Function parameter or member 'irq' not described in 'ipr_test_intr'
 drivers/scsi/ipr.c:10071: warning: Function parameter or member 'devp' not described in 'ipr_test_intr'
 drivers/scsi/ipr.c:10071: warning: Excess function parameter 'pdev' description in 'ipr_test_intr'
 drivers/scsi/ipr.c:10098: warning: Function parameter or member 'ioa_cfg' not described in 'ipr_test_msi'
 drivers/scsi/ipr.c:10538: warning: Function parameter or member 'pdev' not described in 'ipr_probe'
 drivers/scsi/ipr.c:10538: warning: Function parameter or member 'dev_id' not described in 'ipr_probe'
 drivers/scsi/ipr.c:10794: warning: Function parameter or member 'ipr_cmd' not described in 'ipr_halt_done'
 drivers/scsi/ipr.c:10805: warning: Function parameter or member 'nb' not described in 'ipr_halt'
 drivers/scsi/ipr.c:10805: warning: Function parameter or member 'event' not described in 'ipr_halt'
 drivers/scsi/ipr.c:10805: warning: Function parameter or member 'buf' not described in 'ipr_halt'

Cc: Brian King <brking@us.ibm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ipr.c | 73 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 7d86f4ca266c8..f85020904099e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -670,6 +670,7 @@ static void ipr_reinit_ipr_cmnd(struct ipr_cmnd *ipr_cmd)
 /**
  * ipr_init_ipr_cmnd - Initialize an IPR Cmnd block
  * @ipr_cmd:	ipr command struct
+ * @fast_done:	fast done function call-back
  *
  * Return value:
  * 	none
@@ -687,7 +688,7 @@ static void ipr_init_ipr_cmnd(struct ipr_cmnd *ipr_cmd,
 
 /**
  * __ipr_get_free_ipr_cmnd - Get a free IPR Cmnd block
- * @ioa_cfg:	ioa config struct
+ * @hrrq:	hrr queue
  *
  * Return value:
  * 	pointer to ipr command struct
@@ -1287,7 +1288,7 @@ static int ipr_is_same_device(struct ipr_resource_entry *res,
 /**
  * __ipr_format_res_path - Format the resource path for printing.
  * @res_path:	resource path
- * @buf:	buffer
+ * @buffer:	buffer
  * @len:	length of buffer provided
  *
  * Return value:
@@ -1310,7 +1311,7 @@ static char *__ipr_format_res_path(u8 *res_path, char *buffer, int len)
  * ipr_format_res_path - Format the resource path for printing.
  * @ioa_cfg:	ioa config struct
  * @res_path:	resource path
- * @buf:	buffer
+ * @buffer:	buffer
  * @len:	length of buffer provided
  *
  * Return value:
@@ -1391,7 +1392,6 @@ static void ipr_update_res_entry(struct ipr_resource_entry *res,
  * ipr_clear_res_target - Clear the bit in the bit map representing the target
  * 			  for the resource.
  * @res:	resource entry struct
- * @cfgtew:	config table entry wrapper struct
  *
  * Return value:
  *      none
@@ -2667,7 +2667,7 @@ static void ipr_process_error(struct ipr_cmnd *ipr_cmd)
 
 /**
  * ipr_timeout -  An internally generated op has timed out.
- * @ipr_cmd:	ipr command struct
+ * @t: Timer context used to fetch ipr command struct
  *
  * This function blocks host requests and initiates an
  * adapter reset.
@@ -2700,7 +2700,7 @@ static void ipr_timeout(struct timer_list *t)
 
 /**
  * ipr_oper_timeout -  Adapter timed out transitioning to operational
- * @ipr_cmd:	ipr command struct
+ * @t: Timer context used to fetch ipr command struct
  *
  * This function blocks host requests and initiates an
  * adapter reset.
@@ -3484,6 +3484,7 @@ static struct bin_attribute ipr_trace_attr = {
 /**
  * ipr_show_fw_version - Show the firmware version
  * @dev:	class device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
  *
  * Return value:
@@ -3518,6 +3519,7 @@ static struct device_attribute ipr_fw_version_attr = {
 /**
  * ipr_show_log_level - Show the adapter's error logging level
  * @dev:	class device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
  *
  * Return value:
@@ -3540,7 +3542,9 @@ static ssize_t ipr_show_log_level(struct device *dev,
 /**
  * ipr_store_log_level - Change the adapter's error logging level
  * @dev:	class device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
+ * @count:	buffer size
  *
  * Return value:
  * 	number of bytes printed to buffer
@@ -3571,6 +3575,7 @@ static struct device_attribute ipr_log_level_attr = {
 /**
  * ipr_store_diagnostics - IOA Diagnostics interface
  * @dev:	device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
  * @count:	buffer size
  *
@@ -3631,7 +3636,8 @@ static struct device_attribute ipr_diagnostics_attr = {
 
 /**
  * ipr_show_adapter_state - Show the adapter's state
- * @class_dev:	device struct
+ * @dev:	device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
  *
  * Return value:
@@ -3657,6 +3663,7 @@ static ssize_t ipr_show_adapter_state(struct device *dev,
 /**
  * ipr_store_adapter_state - Change adapter state
  * @dev:	device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
  * @count:	buffer size
  *
@@ -3708,6 +3715,7 @@ static struct device_attribute ipr_ioa_state_attr = {
 /**
  * ipr_store_reset_adapter - Reset the adapter
  * @dev:	device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
  * @count:	buffer size
  *
@@ -3749,6 +3757,7 @@ static int ipr_iopoll(struct irq_poll *iop, int budget);
  /**
  * ipr_show_iopoll_weight - Show ipr polling mode
  * @dev:	class device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
  *
  * Return value:
@@ -3772,7 +3781,9 @@ static ssize_t ipr_show_iopoll_weight(struct device *dev,
 /**
  * ipr_store_iopoll_weight - Change the adapter's polling mode
  * @dev:	class device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
+ * @count:	buffer size
  *
  * Return value:
  *	number of bytes printed to buffer
@@ -3871,7 +3882,7 @@ static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
 
 /**
  * ipr_free_ucode_buffer - Frees a microcode download buffer
- * @p_dnld:		scatter/gather list pointer
+ * @sglist:		scatter/gather list pointer
  *
  * Free a DMA'able ucode download buffer previously allocated with
  * ipr_alloc_ucode_buffer
@@ -4059,7 +4070,8 @@ static int ipr_update_ioa_ucode(struct ipr_ioa_cfg *ioa_cfg,
 
 /**
  * ipr_store_update_fw - Update the firmware on the adapter
- * @class_dev:	device struct
+ * @dev:	device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
  * @count:	buffer size
  *
@@ -4139,6 +4151,7 @@ static struct device_attribute ipr_update_fw_attr = {
 /**
  * ipr_show_fw_type - Show the adapter's firmware type.
  * @dev:	class device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
  *
  * Return value:
@@ -4480,7 +4493,6 @@ static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg) { return 0; };
  * ipr_change_queue_depth - Change the device's queue depth
  * @sdev:	scsi device struct
  * @qdepth:	depth to set
- * @reason:	calling context
  *
  * Return value:
  * 	actual depth set
@@ -4650,6 +4662,7 @@ static struct device_attribute ipr_resource_type_attr = {
 /**
  * ipr_show_raw_mode - Show the adapter's raw mode
  * @dev:	class device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
  *
  * Return value:
@@ -4677,7 +4690,9 @@ static ssize_t ipr_show_raw_mode(struct device *dev,
 /**
  * ipr_store_raw_mode - Change the adapter's raw mode
  * @dev:	class device struct
+ * @attr:	device attribute (unused)
  * @buf:	buffer
+ * @count:		buffer size
  *
  * Return value:
  * 	number of bytes printed to buffer
@@ -5060,7 +5075,7 @@ static int ipr_match_lun(struct ipr_cmnd *ipr_cmd, void *device)
 
 /**
  * ipr_cmnd_is_free - Check if a command is free or not
- * @ipr_cmd	ipr command struct
+ * @ipr_cmd:	ipr command struct
  *
  * Returns:
  *	true / false
@@ -5096,7 +5111,7 @@ static int ipr_match_res(struct ipr_cmnd *ipr_cmd, void *resource)
 
 /**
  * ipr_wait_for_ops - Wait for matching commands to complete
- * @ipr_cmd:	ipr command struct
+ * @ioa_cfg:	ioa config struct
  * @device:		device to match (sdev)
  * @match:		match function to use
  *
@@ -5261,6 +5276,7 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
  * ipr_sata_reset - Reset the SATA port
  * @link:	SATA link to reset
  * @classes:	class of the attached device
+ * @deadline:	unused
  *
  * This function issues a SATA phy reset to the affected ATA link.
  *
@@ -5440,7 +5456,7 @@ static void ipr_bus_reset_done(struct ipr_cmnd *ipr_cmd)
 
 /**
  * ipr_abort_timeout - An abort task has timed out
- * @ipr_cmd:	ipr command struct
+ * @t: Timer context used to fetch ipr command struct
  *
  * This function handles when an abort task times out. If this
  * happens we issue a bus reset since we have resources tied
@@ -5569,7 +5585,8 @@ static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
 
 /**
  * ipr_eh_abort - Abort a single op
- * @scsi_cmd:	scsi command struct
+ * @shost:           scsi host struct
+ * @elapsed_time:    elapsed time
  *
  * Return value:
  *	0 if scan in progress / 1 if scan is complete
@@ -5696,6 +5713,7 @@ static irqreturn_t ipr_handle_other_interrupt(struct ipr_ioa_cfg *ioa_cfg,
  * ipr_isr_eh - Interrupt service routine error handler
  * @ioa_cfg:	ioa config struct
  * @msg:	message to log
+ * @number:	various meanings depending on the caller/message
  *
  * Return value:
  * 	none
@@ -6268,8 +6286,7 @@ static void ipr_dump_ioasa(struct ipr_ioa_cfg *ioa_cfg,
 
 /**
  * ipr_gen_sense - Generate SCSI sense data from an IOASA
- * @ioasa:		IOASA
- * @sense_buf:	sense data buffer
+ * @ipr_cmd:	ipr command struct
  *
  * Return value:
  * 	none
@@ -6702,7 +6719,7 @@ static int ipr_ioctl(struct scsi_device *sdev, unsigned int cmd,
 
 /**
  * ipr_info - Get information about the card/driver
- * @scsi_host:	scsi host struct
+ * @host:	scsi host struct
  *
  * Return value:
  * 	pointer to buffer with description string
@@ -7592,7 +7609,7 @@ static int ipr_ioafp_mode_select_page28(struct ipr_cmnd *ipr_cmd)
 /**
  * ipr_build_mode_sense - Builds a mode sense command
  * @ipr_cmd:	ipr command struct
- * @res:		resource entry struct
+ * @res_handle:		resource entry struct
  * @parm:		Byte 2 of mode sense command
  * @dma_addr:	DMA address of mode sense buffer
  * @xfer_len:	Size of DMA buffer
@@ -7939,6 +7956,7 @@ static void ipr_build_ioa_service_action(struct ipr_cmnd *ipr_cmd,
 /**
  * ipr_ioafp_set_caching_parameters - Issue Set Cache parameters service
  * action
+ * @ipr_cmd:	ipr command struct
  *
  * Return value:
  *	none
@@ -7975,6 +7993,10 @@ static int ipr_ioafp_set_caching_parameters(struct ipr_cmnd *ipr_cmd)
 /**
  * ipr_ioafp_inquiry - Send an Inquiry to the adapter.
  * @ipr_cmd:	ipr command struct
+ * @flags:	flags to send
+ * @page:	page to inquire
+ * @dma_addr:	DMA address
+ * @xfer_len:	transfer data length
  *
  * This utility function sends an inquiry to the adapter.
  *
@@ -8265,7 +8287,7 @@ static int ipr_ioafp_identify_hrrq(struct ipr_cmnd *ipr_cmd)
 
 /**
  * ipr_reset_timer_done - Adapter reset timer function
- * @ipr_cmd:	ipr command struct
+ * @t: Timer context used to fetch ipr command struct
  *
  * Description: This function is used in adapter reset processing
  * for timing events. If the reset_cmd pointer in the IOA
@@ -9483,7 +9505,6 @@ static pci_ers_result_t ipr_pci_error_detected(struct pci_dev *pdev,
  * Description: This is the second phase of adapter initialization
  * This function takes care of initilizing the adapter to the point
  * where it can accept new commands.
-
  * Return value:
  * 	0 on success / -EIO on failure
  **/
@@ -9597,7 +9618,7 @@ static void ipr_free_irqs(struct ipr_ioa_cfg *ioa_cfg)
 
 /**
  * ipr_free_all_resources - Free all allocated resources for an adapter.
- * @ipr_cmd:	ipr command struct
+ * @ioa_cfg:	ioa config struct
  *
  * This function frees all allocated resources for the
  * specified adapter.
@@ -10059,7 +10080,8 @@ static int ipr_request_other_msi_irqs(struct ipr_ioa_cfg *ioa_cfg,
 
 /**
  * ipr_test_intr - Handle the interrupt generated in ipr_test_msi().
- * @pdev:		PCI device struct
+ * @devp:		PCI device struct
+ * @irq:		IRQ number
  *
  * Description: Simply set the msi_received flag to 1 indicating that
  * Message Signaled Interrupts are supported.
@@ -10085,6 +10107,7 @@ static irqreturn_t ipr_test_intr(int irq, void *devp)
 
 /**
  * ipr_test_msi - Test for Message Signaled Interrupt (MSI) support.
+ * @ioa_cfg:		ioa config struct
  * @pdev:		PCI device struct
  *
  * Description: This routine sets up and initiates a test interrupt to determine
@@ -10530,6 +10553,8 @@ static void ipr_remove(struct pci_dev *pdev)
 
 /**
  * ipr_probe - Adapter hot plug add entry point
+ * @pdev:	pci device struct
+ * @dev_id:	pci device ID
  *
  * Return value:
  * 	0 on success / non-zero on failure
@@ -10786,6 +10811,7 @@ static struct pci_driver ipr_driver = {
 
 /**
  * ipr_halt_done - Shutdown prepare completion
+ * @ipr_cmd:   ipr command struct
  *
  * Return value:
  * 	none
@@ -10797,6 +10823,9 @@ static void ipr_halt_done(struct ipr_cmnd *ipr_cmd)
 
 /**
  * ipr_halt - Issue shutdown prepare to all adapters
+ * @nb: Notifier block
+ * @event: Notifier event
+ * @buf: Notifier data (unused)
  *
  * Return value:
  * 	NOTIFY_OK on success / NOTIFY_DONE on failure
-- 
2.25.1

