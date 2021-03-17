Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2356C4332E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B48864F33
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhCQJNC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhCQJMq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:46 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED9CC061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:45 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x13so1002029wrs.9
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DxBUihBpj0mKnAYokfmFfqQi/8TivCP0fpcxrk6Lfks=;
        b=Ui0dB7OenZAPPVMZCZSdQfKlwNSOx/NTZDSmaT5mZ/Hi85rGycIoxmFWvu2mpFFiVA
         K4DCbssfzwGsyvT2ze1tS6bBYH2TLiOCmGRc4fnfVGbjPO/HmwhKsu5vJL8uEM9Yjtd0
         K473EDvnWnkAI+eo78zuWPCgHnAxp7MTQxGCGoaD1V4qqXp9oP3aVHrXoxtrDXKVuiIL
         B/iiUZP4mzvwZsa14HAg1RsEpWjPqrMq2nzJxMxrAfQWQelSFH/Hvd2KaCxDtkRqgbGO
         /1wic4JNZb3CerZGVGHmvMYXkj48TSzBvL4ZFaWrTBAzkwFlgrgYhlRHGyzyU4B2RKyq
         Kfag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DxBUihBpj0mKnAYokfmFfqQi/8TivCP0fpcxrk6Lfks=;
        b=lmXHDG3UoAAptXpgJ+05unOGiwPCTY9cur5PYkEPEW5ZzdNzBASw6b67NYLeTyjQyY
         1ZeRYTr4IOcd9uKdYt8/bq5q+zuqGsn0sU06njtGfhU0puFBl9LCO/fJUEcWrfajspzG
         usmOQBWX4U7l18djnvYrTqBvdNq8gfuVUJoajL/O460gnvvkojKBloD5UmFZczatdJSg
         NuKTK+auRwUB3JE7GO1BIbxfLQHvJQ60dQ8x0rKw/sPRm7kpp/TlpYmdttpQLTyM42P8
         DtA54VJ9NW+3U4j/SuQGlPWVmq/5Kp554yxavgTbziB0RDDZjyeb0gHTqnUw9ZisIsEJ
         bGhw==
X-Gm-Message-State: AOAM5308MKTjVGjUpaglqdpUwHfDQiDAcBlRcrktfT7+cxB+pQMNneww
        vhqhiVmJZ7qLjXPaCZoIJQxGlQ==
X-Google-Smtp-Source: ABdhPJzWBMyeCgy6VuZe17B3YyJmg08mmTreF4iTERHCAUiMalj14h3AFnitL+jzvrCBiIcc9/VjGQ==
X-Received: by 2002:adf:c641:: with SMTP id u1mr3334554wrg.332.1615972364586;
        Wed, 17 Mar 2021 02:12:44 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:44 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 05/36] scsi: pmcraid: Fix a whole host of kernel-doc issues
Date:   Wed, 17 Mar 2021 09:11:59 +0000
Message-Id: <20210317091230.2912389-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pmcraid.c:455: warning: Function parameter or member 'intrs' not described in 'pmcraid_enable_interrupts'
 drivers/scsi/pmcraid.c:455: warning: Excess function parameter 'intr' description in 'pmcraid_enable_interrupts'
 drivers/scsi/pmcraid.c:543: warning: Function parameter or member '' not described in 'pmcraid_ioa_reset'
 drivers/scsi/pmcraid.c:543: warning: expecting prototype for pmcraid_bist_done(). Prototype was for pmcraid_ioa_reset() instead
 drivers/scsi/pmcraid.c:603: warning: Function parameter or member 't' not described in 'pmcraid_reset_alert_done'
 drivers/scsi/pmcraid.c:603: warning: Excess function parameter 'cmd' description in 'pmcraid_reset_alert_done'
 drivers/scsi/pmcraid.c:638: warning: Function parameter or member '' not described in 'pmcraid_notify_ioastate'
 drivers/scsi/pmcraid.c:638: warning: Function parameter or member 'u32' not described in 'pmcraid_notify_ioastate'
 drivers/scsi/pmcraid.c:638: warning: expecting prototype for pmcraid_reset_alert(). Prototype was for pmcraid_notify_ioastate() instead
 drivers/scsi/pmcraid.c:687: warning: Function parameter or member 't' not described in 'pmcraid_timeout_handler'
 drivers/scsi/pmcraid.c:687: warning: Excess function parameter 'cmd' description in 'pmcraid_timeout_handler'
 drivers/scsi/pmcraid.c:858: warning: expecting prototype for pmcraid_fire_command(). Prototype was for _pmcraid_fire_command() instead
 drivers/scsi/pmcraid.c:972: warning: Function parameter or member '' not described in 'pmcraid_querycfg'
 drivers/scsi/pmcraid.c:972: warning: expecting prototype for pmcraid_get_fwversion_done(). Prototype was for pmcraid_querycfg() instead
 drivers/scsi/pmcraid.c:1398: warning: Function parameter or member 'aen_msg' not described in 'pmcraid_notify_aen'
 drivers/scsi/pmcraid.c:1398: warning: Function parameter or member 'data_size' not described in 'pmcraid_notify_aen'
 drivers/scsi/pmcraid.c:1398: warning: Excess function parameter 'type' description in 'pmcraid_notify_aen'
 drivers/scsi/pmcraid.c:1781: warning: Function parameter or member '' not described in 'pmcraid_initiate_reset'
 drivers/scsi/pmcraid.c:1781: warning: expecting prototype for pmcraid_process_ldn(). Prototype was for pmcraid_initiate_reset() instead
 drivers/scsi/pmcraid.c:1887: warning: Function parameter or member '' not described in 'pmcraid_reinit_buffers'
 drivers/scsi/pmcraid.c:1887: warning: expecting prototype for pmcraid_reset_enable_ioa(). Prototype was for pmcraid_reinit_buffers() instead
 drivers/scsi/pmcraid.c:2704: warning: Function parameter or member 'timeout' not described in 'pmcraid_reset_device'
 drivers/scsi/pmcraid.c:3025: warning: expecting prototype for pmcraid_eh_xxxx_reset_handler(). Prototype was for pmcraid_eh_device_reset_handler() instead
 drivers/scsi/pmcraid.c:3327: warning: expecting prototype for pmcraid_queuecommand(). Prototype was for pmcraid_queuecommand_lck() instead
 drivers/scsi/pmcraid.c:3437: warning: Function parameter or member 'inode' not described in 'pmcraid_chr_open'
 drivers/scsi/pmcraid.c:3437: warning: Function parameter or member 'filep' not described in 'pmcraid_chr_open'
 drivers/scsi/pmcraid.c:3437: warning: expecting prototype for pmcraid_open(). Prototype was for pmcraid_chr_open() instead
 drivers/scsi/pmcraid.c:3457: warning: Function parameter or member 'fd' not described in 'pmcraid_chr_fasync'
 drivers/scsi/pmcraid.c:3457: warning: Function parameter or member 'filep' not described in 'pmcraid_chr_fasync'
 drivers/scsi/pmcraid.c:3457: warning: Function parameter or member 'mode' not described in 'pmcraid_chr_fasync'
 drivers/scsi/pmcraid.c:3457: warning: expecting prototype for pmcraid_fasync(). Prototype was for pmcraid_chr_fasync() instead
 drivers/scsi/pmcraid.c:3574: warning: Function parameter or member 'ioctl_cmd' not described in 'pmcraid_ioctl_passthrough'
 drivers/scsi/pmcraid.c:3574: warning: Function parameter or member 'buflen' not described in 'pmcraid_ioctl_passthrough'
 drivers/scsi/pmcraid.c:3574: warning: Excess function parameter 'cmd' description in 'pmcraid_ioctl_passthrough'
 drivers/scsi/pmcraid.c:3905: warning: Function parameter or member 'filep' not described in 'pmcraid_chr_ioctl'
 drivers/scsi/pmcraid.c:3905: warning: Function parameter or member 'cmd' not described in 'pmcraid_chr_ioctl'
 drivers/scsi/pmcraid.c:3905: warning: Function parameter or member 'arg' not described in 'pmcraid_chr_ioctl'
 drivers/scsi/pmcraid.c:3905: warning: expecting prototype for pmcraid_ioctl(). Prototype was for pmcraid_chr_ioctl() instead
 drivers/scsi/pmcraid.c:3969: warning: cannot understand function prototype: 'const struct file_operations pmcraid_fops = '
 drivers/scsi/pmcraid.c:3993: warning: Function parameter or member 'attr' not described in 'pmcraid_show_log_level'
 drivers/scsi/pmcraid.c:4015: warning: Function parameter or member 'attr' not described in 'pmcraid_store_log_level'
 drivers/scsi/pmcraid.c:4055: warning: Function parameter or member 'attr' not described in 'pmcraid_show_drv_version'
 drivers/scsi/pmcraid.c:4081: warning: Function parameter or member 'attr' not described in 'pmcraid_show_adapter_id'
 drivers/scsi/pmcraid.c:4081: warning: expecting prototype for pmcraid_show_io_adapter_id(). Prototype was for pmcraid_show_adapter_id() instead
 drivers/scsi/pmcraid.c:4600: warning: Function parameter or member 'pinstance' not described in 'pmcraid_allocate_cmd_blocks'
 drivers/scsi/pmcraid.c:5153: warning: Function parameter or member 'minor' not described in 'pmcraid_release_minor'

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pmcraid.c | 68 ++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 834556ea21d20..c98e39eb04b24 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -443,15 +443,14 @@ static void pmcraid_disable_interrupts(
  * pmcraid_enable_interrupts - Enables specified interrupts
  *
  * @pinstance: pointer to per adapter instance structure
- * @intr: interrupts to enable
+ * @intrs: interrupts to enable
  *
  * Return Value
  *	 None
  */
 static void pmcraid_enable_interrupts(
 	struct pmcraid_instance *pinstance,
-	u32 intrs
-)
+	u32 intrs)
 {
 	u32 gmask = ioread32(pinstance->int_regs.global_interrupt_mask_reg);
 	u32 nmask = gmask & (~GLOBAL_INTERRUPT_MASK);
@@ -533,15 +532,13 @@ static void pmcraid_reset_type(struct pmcraid_instance *pinstance)
 		pinstance->ioa_unit_check = 1;
 }
 
+static void pmcraid_ioa_reset(struct pmcraid_cmd *);
 /**
  * pmcraid_bist_done - completion function for PCI BIST
- * @cmd: pointer to reset command
+ * @t: pointer to reset command
  * Return Value
  *	none
  */
-
-static void pmcraid_ioa_reset(struct pmcraid_cmd *);
-
 static void pmcraid_bist_done(struct timer_list *t)
 {
 	struct pmcraid_cmd *cmd = from_timer(cmd, t, timer);
@@ -595,7 +592,7 @@ static void pmcraid_start_bist(struct pmcraid_cmd *cmd)
 
 /**
  * pmcraid_reset_alert_done - completion routine for reset_alert
- * @cmd: pointer to command block used in reset sequence
+ * @t: pointer to command block used in reset sequence
  * Return value
  *  None
  */
@@ -626,16 +623,16 @@ static void pmcraid_reset_alert_done(struct timer_list *t)
 	}
 }
 
+static void pmcraid_notify_ioastate(struct pmcraid_instance *, u32);
 /**
  * pmcraid_reset_alert - alerts IOA for a possible reset
- * @cmd : command block to be used for reset sequence.
+ * @cmd: command block to be used for reset sequence.
  *
  * Return Value
  *	returns 0 if pci config-space is accessible and RESET_DOORBELL is
  *	successfully written to IOA. Returns non-zero in case pci_config_space
  *	is not accessible
  */
-static void pmcraid_notify_ioastate(struct pmcraid_instance *, u32);
 static void pmcraid_reset_alert(struct pmcraid_cmd *cmd)
 {
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
@@ -676,7 +673,7 @@ static void pmcraid_reset_alert(struct pmcraid_cmd *cmd)
 /**
  * pmcraid_timeout_handler -  Timeout handler for internally generated ops
  *
- * @cmd : pointer to command structure, that got timedout
+ * @t: pointer to command structure, that got timedout
  *
  * This function blocks host requests and initiates an adapter reset.
  *
@@ -844,7 +841,7 @@ static void pmcraid_erp_done(struct pmcraid_cmd *cmd)
 }
 
 /**
- * pmcraid_fire_command - sends an IOA command to adapter
+ * _pmcraid_fire_command - sends an IOA command to adapter
  *
  * This function adds the given block into pending command list
  * and returns without waiting
@@ -961,6 +958,7 @@ static void pmcraid_ioa_shutdown(struct pmcraid_cmd *cmd)
 			 pmcraid_timeout_handler);
 }
 
+static void pmcraid_querycfg(struct pmcraid_cmd *);
 /**
  * pmcraid_get_fwversion_done - completion function for get_fwversion
  *
@@ -969,8 +967,6 @@ static void pmcraid_ioa_shutdown(struct pmcraid_cmd *cmd)
  * Return Value
  *	none
  */
-static void pmcraid_querycfg(struct pmcraid_cmd *);
-
 static void pmcraid_get_fwversion_done(struct pmcraid_cmd *cmd)
 {
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
@@ -1382,10 +1378,9 @@ static void pmcraid_netlink_release(void)
 	genl_unregister_family(&pmcraid_event_family);
 }
 
-/**
+/*
  * pmcraid_notify_aen - sends event msg to user space application
  * @pinstance: pointer to adapter instance structure
- * @type: HCAM type
  *
  * Return value:
  *	0 if success, error value in case of any failure.
@@ -1393,8 +1388,7 @@ static void pmcraid_netlink_release(void)
 static int pmcraid_notify_aen(
 	struct pmcraid_instance *pinstance,
 	struct pmcraid_aen_msg  *aen_msg,
-	u32    data_size
-)
+	u32    data_size)
 {
 	struct sk_buff *skb;
 	void *msg_header;
@@ -1771,6 +1765,8 @@ static void pmcraid_process_ccn(struct pmcraid_cmd *cmd)
 	}
 }
 
+static void pmcraid_initiate_reset(struct pmcraid_instance *);
+static void pmcraid_set_timestamp(struct pmcraid_cmd *cmd);
 /**
  * pmcraid_process_ldn - op done function for an LDN
  * @cmd: pointer to command block
@@ -1778,9 +1774,6 @@ static void pmcraid_process_ccn(struct pmcraid_cmd *cmd)
  * Return value
  *   none
  */
-static void pmcraid_initiate_reset(struct pmcraid_instance *);
-static void pmcraid_set_timestamp(struct pmcraid_cmd *cmd);
-
 static void pmcraid_process_ldn(struct pmcraid_cmd *cmd)
 {
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
@@ -1878,14 +1871,14 @@ static void pmcraid_unregister_hcams(struct pmcraid_cmd *cmd)
 	pmcraid_cancel_ldn(cmd);
 }
 
+static void pmcraid_reinit_buffers(struct pmcraid_instance *);
+
 /**
  * pmcraid_reset_enable_ioa - re-enable IOA after a hard reset
  * @pinstance: pointer to adapter instance structure
  * Return Value
  *  1 if TRANSITION_TO_OPERATIONAL is active, otherwise 0
  */
-static void pmcraid_reinit_buffers(struct pmcraid_instance *);
-
 static int pmcraid_reset_enable_ioa(struct pmcraid_instance *pinstance)
 {
 	u32 intrs;
@@ -2687,6 +2680,7 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
  * pmcraid_reset_device - device reset handler functions
  *
  * @scsi_cmd: scsi command struct
+ * @timeout: command timeout
  * @modifier: reset modifier indicating the reset sequence to be performed
  *
  * This function issues a device reset to the affected device.
@@ -2699,8 +2693,7 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
 static int pmcraid_reset_device(
 	struct scsi_cmnd *scsi_cmd,
 	unsigned long timeout,
-	u8 modifier
-)
+	u8 modifier)
 {
 	struct pmcraid_cmd *cmd;
 	struct pmcraid_instance *pinstance;
@@ -3008,7 +3001,7 @@ static int pmcraid_eh_abort_handler(struct scsi_cmnd *scsi_cmd)
 }
 
 /**
- * pmcraid_eh_xxxx_reset_handler - bus/target/device reset handler callbacks
+ * pmcraid_eh_device_reset_handler - bus/target/device reset handler callbacks
  *
  * @scmd: pointer to scsi_cmd that was sent to the resource to be reset.
  *
@@ -3307,7 +3300,7 @@ static int pmcraid_copy_sglist(
 }
 
 /**
- * pmcraid_queuecommand - Queue a mid-layer request
+ * pmcraid_queuecommand_lck - Queue a mid-layer request
  * @scsi_cmd: scsi command struct
  * @done: done function
  *
@@ -3430,7 +3423,7 @@ static int pmcraid_queuecommand_lck(
 
 static DEF_SCSI_QCMD(pmcraid_queuecommand)
 
-/**
+/*
  * pmcraid_open -char node "open" entry, allowed only users with admin access
  */
 static int pmcraid_chr_open(struct inode *inode, struct file *filep)
@@ -3447,7 +3440,7 @@ static int pmcraid_chr_open(struct inode *inode, struct file *filep)
 	return 0;
 }
 
-/**
+/*
  * pmcraid_fasync - Async notifier registration from applications
  *
  * This function adds the calling process to a driver global queue. When an
@@ -3559,7 +3552,8 @@ static void pmcraid_release_passthrough_ioadls(
  * pmcraid_ioctl_passthrough - handling passthrough IOCTL commands
  *
  * @pinstance: pointer to adapter instance structure
- * @cmd: ioctl code
+ * @ioctl_cmd: ioctl code
+ * @buflen: unused
  * @arg: pointer to pmcraid_passthrough_buffer user buffer
  *
  * Return value
@@ -3894,7 +3888,7 @@ static int pmcraid_check_ioctl_buffer(
 	return 0;
 }
 
-/**
+/*
  *  pmcraid_ioctl - char node ioctl entry point
  */
 static long pmcraid_chr_ioctl(
@@ -3963,7 +3957,7 @@ static long pmcraid_chr_ioctl(
 	return retval;
 }
 
-/**
+/*
  * File operations structure for management interface
  */
 static const struct file_operations pmcraid_fops = {
@@ -3981,6 +3975,7 @@ static const struct file_operations pmcraid_fops = {
 /**
  * pmcraid_show_log_level - Display adapter's error logging level
  * @dev: class device struct
+ * @attr: unused
  * @buf: buffer
  *
  * Return value:
@@ -4000,6 +3995,7 @@ static ssize_t pmcraid_show_log_level(
 /**
  * pmcraid_store_log_level - Change the adapter's error logging level
  * @dev: class device struct
+ * @attr: unused
  * @buf: buffer
  * @count: not used
  *
@@ -4042,6 +4038,7 @@ static struct device_attribute pmcraid_log_level_attr = {
 /**
  * pmcraid_show_drv_version - Display driver version
  * @dev: class device struct
+ * @attr: unused
  * @buf: buffer
  *
  * Return value:
@@ -4068,6 +4065,7 @@ static struct device_attribute pmcraid_driver_version_attr = {
 /**
  * pmcraid_show_io_adapter_id - Display driver assigned adapter id
  * @dev: class device struct
+ * @attr: unused
  * @buf: buffer
  *
  * Return value:
@@ -4589,7 +4587,7 @@ pmcraid_release_control_blocks(
 
 /**
  * pmcraid_allocate_cmd_blocks - allocate memory for cmd block structures
- * @pinstance - pointer to per adapter instance structure
+ * @pinstance: pointer to per adapter instance structure
  *
  * Allocates memory for command blocks using kernel slab allocator.
  *
@@ -5134,7 +5132,7 @@ static void pmcraid_shutdown(struct pci_dev *pdev)
 }
 
 
-/**
+/*
  * pmcraid_get_minor - returns unused minor number from minor number bitmap
  */
 static unsigned short pmcraid_get_minor(void)
@@ -5146,7 +5144,7 @@ static unsigned short pmcraid_get_minor(void)
 	return minor;
 }
 
-/**
+/*
  * pmcraid_release_minor - releases given minor back to minor number bitmap
  */
 static void pmcraid_release_minor(unsigned short minor)
-- 
2.27.0

