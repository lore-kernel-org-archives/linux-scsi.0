Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B1DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9420064F37
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCQJMz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhCQJMm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:42 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8681C061763
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:41 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v4so990637wrp.13
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=789UHYUvVMzCBbNg3UASk3n+nFZmY80q4S9W+NeV8Bg=;
        b=WFW0sq+ziqOsjD8Iegw5o3qclzUow5ppaB10QpJpjUdB1ZS/1pwY3QhWX4IKKISPH0
         VADtvkNA40g7exp5m9DEu0cx6qSrq/lVF4Naq+wafPw0wAUrm/nH44pAm19tV5lwe2K1
         9BtL9UMOSf8KQyukj8TeTg4wPddjnjaN6+CjYF806OnRKJ0fuaVOcrAIFXsXWv8FCxae
         fWC17C/eg2eimNcSG7JV4Bybk3/emq7L4Dli3Yai4zhrjbFkiwQwAhukjLjixHxn5AU6
         Z/h0tzwLyb3Xs0hFnvsOosHdTJ8LSZFltvClu4n6TPgvx+ByJMpfDFVykWq8/7vLSomr
         /nEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=789UHYUvVMzCBbNg3UASk3n+nFZmY80q4S9W+NeV8Bg=;
        b=uFX6Q1Y/b/Ev1Dr9IyXFVtff5l3WE99C6R1ui75hVyRejMiq1whZfZ5rnddCdP7JA5
         q2+/tEmQcuFB2uVvz821DBE/KaMrnCBjp7LcnO05Dz8IH860+FgrEC1xzuPyv9ZTI2um
         Cgpb0E12B86zNOoHsv2XIQkck7H06OXulxEJU+wMZTgn1rYSwPtRT7A0M4w+GiZCe0N3
         bKsyE1Q0S1a+K7F2zKsaLvAA6dNWfvPK0UDqYfU6XKE79YrHAvzoTsYy12Dc8ZNhskl6
         CIlLrza8GHrzKqi7KKn2YDX6bYmrm7YX7d807sk3ZvpzpSVeWbV/VWbxXq55MEz8X5o3
         Vwag==
X-Gm-Message-State: AOAM533tMdo9via6ax/UfxF6lVX9A8NJb2+O74uD7r8qLojZmqGi6Rug
        DR3CbJ9E/yZnKt2zby04eh4IEQ==
X-Google-Smtp-Source: ABdhPJwc0anQ2uWCMoYF1ZmFduPTo3+KlLFKm/knVP5icK/xLxR8ksWkzZhsaVCDyON6q1qxwDx7xg==
X-Received: by 2002:a5d:6412:: with SMTP id z18mr3343778wru.214.1615972360513;
        Wed, 17 Mar 2021 02:12:40 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:40 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux GmbH <hare@suse.com>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 01/36] scsi: myrb: Demote non-conformant kernel-doc headers and fix others
Date:   Wed, 17 Mar 2021 09:11:55 +0000
Message-Id: <20210317091230.2912389-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/myrb.c:91: warning: Function parameter or member 'pdev' not described in 'myrb_create_mempools'
 drivers/scsi/myrb.c:91: warning: Function parameter or member 'cb' not described in 'myrb_create_mempools'
 drivers/scsi/myrb.c:141: warning: Function parameter or member 'cb' not described in 'myrb_destroy_mempools'
 drivers/scsi/myrb.c:153: warning: Function parameter or member 'cmd_blk' not described in 'myrb_reset_cmd'
 drivers/scsi/myrb.c:164: warning: Function parameter or member 'cb' not described in 'myrb_qcmd'
 drivers/scsi/myrb.c:164: warning: Function parameter or member 'cmd_blk' not described in 'myrb_qcmd'
 drivers/scsi/myrb.c:187: warning: Function parameter or member 'cb' not described in 'myrb_exec_cmd'
 drivers/scsi/myrb.c:187: warning: Function parameter or member 'cmd_blk' not described in 'myrb_exec_cmd'
 drivers/scsi/myrb.c:208: warning: Function parameter or member 'cb' not described in 'myrb_exec_type3'
 drivers/scsi/myrb.c:208: warning: Function parameter or member 'op' not described in 'myrb_exec_type3'
 drivers/scsi/myrb.c:208: warning: Function parameter or member 'addr' not described in 'myrb_exec_type3'
 drivers/scsi/myrb.c:231: warning: Function parameter or member 'cb' not described in 'myrb_exec_type3D'
 drivers/scsi/myrb.c:231: warning: Function parameter or member 'op' not described in 'myrb_exec_type3D'
 drivers/scsi/myrb.c:231: warning: Function parameter or member 'sdev' not described in 'myrb_exec_type3D'
 drivers/scsi/myrb.c:231: warning: Function parameter or member 'pdev_info' not described in 'myrb_exec_type3D'
 drivers/scsi/myrb.c:341: warning: Function parameter or member 'cb' not described in 'myrb_get_errtable'
 drivers/scsi/myrb.c:388: warning: Function parameter or member 'cb' not described in 'myrb_get_ldev_info'
 drivers/scsi/myrb.c:440: warning: Function parameter or member 'cb' not described in 'myrb_get_rbld_progress'
 drivers/scsi/myrb.c:440: warning: Function parameter or member 'rbld' not described in 'myrb_get_rbld_progress'
 drivers/scsi/myrb.c:472: warning: Function parameter or member 'cb' not described in 'myrb_update_rbld_progress'
 drivers/scsi/myrb.c:533: warning: Function parameter or member 'cb' not described in 'myrb_get_cc_progress'
 drivers/scsi/myrb.c:580: warning: Function parameter or member 'cb' not described in 'myrb_bgi_control'
 drivers/scsi/myrb.c:671: warning: Function parameter or member 'cb' not described in 'myrb_hba_enquiry'
 drivers/scsi/myrb.c:782: warning: Function parameter or member 'cb' not described in 'myrb_set_pdev_state'
 drivers/scsi/myrb.c:782: warning: Function parameter or member 'sdev' not described in 'myrb_set_pdev_state'
 drivers/scsi/myrb.c:782: warning: Function parameter or member 'state' not described in 'myrb_set_pdev_state'
 drivers/scsi/myrb.c:808: warning: Function parameter or member 'cb' not described in 'myrb_enable_mmio'
 drivers/scsi/myrb.c:808: warning: Function parameter or member 'mmio_init_fn' not described in 'myrb_enable_mmio'
 drivers/scsi/myrb.c:913: warning: Function parameter or member 'cb' not described in 'myrb_get_hba_config'
 drivers/scsi/myrb.c:1200: warning: Function parameter or member 'cb' not described in 'myrb_unmap'
 drivers/scsi/myrb.c:1236: warning: Function parameter or member 'cb' not described in 'myrb_cleanup'
 drivers/scsi/myrb.c:2249: warning: Function parameter or member 'dev' not described in 'myrb_is_raid'
 drivers/scsi/myrb.c:2260: warning: Function parameter or member 'dev' not described in 'myrb_get_resync'
 drivers/scsi/myrb.c:2287: warning: Function parameter or member 'dev' not described in 'myrb_get_state'
 drivers/scsi/myrb.c:2493: warning: Function parameter or member 'cb' not described in 'myrb_err_status'
 drivers/scsi/myrb.c:2493: warning: Function parameter or member 'error' not described in 'myrb_err_status'
 drivers/scsi/myrb.c:2493: warning: Function parameter or member 'parm0' not described in 'myrb_err_status'
 drivers/scsi/myrb.c:2493: warning: Function parameter or member 'parm1' not described in 'myrb_err_status'

Cc: Hannes Reinecke <hare@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Linux GmbH <hare@suse.com>
Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/myrb.c | 47 ++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 3d8e91c07dc77..d469a48897774 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -82,7 +82,7 @@ static const char *myrb_raidlevel_name(enum myrb_raidlevel level)
 	return NULL;
 }
 
-/**
+/*
  * myrb_create_mempools - allocates auxiliary data structures
  *
  * Return: true on success, false otherwise.
@@ -134,7 +134,7 @@ static bool myrb_create_mempools(struct pci_dev *pdev, struct myrb_hba *cb)
 	return true;
 }
 
-/**
+/*
  * myrb_destroy_mempools - tears down the memory pools for the controller
  */
 static void myrb_destroy_mempools(struct myrb_hba *cb)
@@ -146,7 +146,7 @@ static void myrb_destroy_mempools(struct myrb_hba *cb)
 	dma_pool_destroy(cb->dcdb_pool);
 }
 
-/**
+/*
  * myrb_reset_cmd - reset command block
  */
 static inline void myrb_reset_cmd(struct myrb_cmdblk *cmd_blk)
@@ -157,7 +157,7 @@ static inline void myrb_reset_cmd(struct myrb_cmdblk *cmd_blk)
 	cmd_blk->status = 0;
 }
 
-/**
+/*
  * myrb_qcmd - queues command block for execution
  */
 static void myrb_qcmd(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk)
@@ -177,7 +177,7 @@ static void myrb_qcmd(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk)
 	cb->next_cmd_mbox = next_mbox;
 }
 
-/**
+/*
  * myrb_exec_cmd - executes command block and waits for completion.
  *
  * Return: command status
@@ -198,7 +198,7 @@ static unsigned short myrb_exec_cmd(struct myrb_hba *cb,
 	return cmd_blk->status;
 }
 
-/**
+/*
  * myrb_exec_type3 - executes a type 3 command and waits for completion.
  *
  * Return: command status
@@ -220,7 +220,7 @@ static unsigned short myrb_exec_type3(struct myrb_hba *cb,
 	return status;
 }
 
-/**
+/*
  * myrb_exec_type3D - executes a type 3D command and waits for completion.
  *
  * Return: command status
@@ -332,7 +332,7 @@ static void myrb_get_event(struct myrb_hba *cb, unsigned int event)
 			  ev_buf, ev_addr);
 }
 
-/**
+/*
  * myrb_get_errtable - retrieves the error table from the controller
  *
  * Executes a type 3 command and logs the error table from the controller.
@@ -377,7 +377,7 @@ static void myrb_get_errtable(struct myrb_hba *cb)
 	}
 }
 
-/**
+/*
  * myrb_get_ldev_info - retrieves the logical device table from the controller
  *
  * Executes a type 3 command and updates the logical device table.
@@ -427,7 +427,7 @@ static unsigned short myrb_get_ldev_info(struct myrb_hba *cb)
 	return status;
 }
 
-/**
+/*
  * myrb_get_rbld_progress - get rebuild progress information
  *
  * Executes a type 3 command and returns the rebuild progress
@@ -462,11 +462,10 @@ static unsigned short myrb_get_rbld_progress(struct myrb_hba *cb,
 	return status;
 }
 
-/**
+/*
  * myrb_update_rbld_progress - updates the rebuild status
  *
  * Updates the rebuild status for the attached logical devices.
- *
  */
 static void myrb_update_rbld_progress(struct myrb_hba *cb)
 {
@@ -523,7 +522,7 @@ static void myrb_update_rbld_progress(struct myrb_hba *cb)
 	cb->last_rbld_status = status;
 }
 
-/**
+/*
  * myrb_get_cc_progress - retrieve the rebuild status
  *
  * Execute a type 3 Command and fetch the rebuild / consistency check
@@ -571,7 +570,7 @@ static void myrb_get_cc_progress(struct myrb_hba *cb)
 			  rbld_buf, rbld_addr);
 }
 
-/**
+/*
  * myrb_bgi_control - updates background initialisation status
  *
  * Executes a type 3B command and updates the background initialisation status
@@ -660,7 +659,7 @@ static void myrb_bgi_control(struct myrb_hba *cb)
 			  bgi, bgi_addr);
 }
 
-/**
+/*
  * myrb_hba_enquiry - updates the controller status
  *
  * Executes a DAC_V1_Enquiry command and updates the controller status.
@@ -772,7 +771,7 @@ static unsigned short myrb_hba_enquiry(struct myrb_hba *cb)
 	return MYRB_STATUS_SUCCESS;
 }
 
-/**
+/*
  * myrb_set_pdev_state - sets the device state for a physical device
  *
  * Return: command status
@@ -796,7 +795,7 @@ static unsigned short myrb_set_pdev_state(struct myrb_hba *cb,
 	return status;
 }
 
-/**
+/*
  * myrb_enable_mmio - enables the Memory Mailbox Interface
  *
  * PD and P controller types have no memory mailbox, but still need the
@@ -901,7 +900,7 @@ static bool myrb_enable_mmio(struct myrb_hba *cb, mbox_mmio_init_t mmio_init_fn)
 	return true;
 }
 
-/**
+/*
  * myrb_get_hba_config - reads the configuration information
  *
  * Reads the configuration information from the controller and
@@ -1193,7 +1192,7 @@ static int myrb_get_hba_config(struct myrb_hba *cb)
 	return ret;
 }
 
-/**
+/*
  * myrb_unmap - unmaps controller structures
  */
 static void myrb_unmap(struct myrb_hba *cb)
@@ -1229,7 +1228,7 @@ static void myrb_unmap(struct myrb_hba *cb)
 	}
 }
 
-/**
+/*
  * myrb_cleanup - cleanup controller structures
  */
 static void myrb_cleanup(struct myrb_hba *cb)
@@ -2243,7 +2242,7 @@ static struct scsi_host_template myrb_template = {
 
 /**
  * myrb_is_raid - return boolean indicating device is raid volume
- * @dev the device struct object
+ * @dev: the device struct object
  */
 static int myrb_is_raid(struct device *dev)
 {
@@ -2254,7 +2253,7 @@ static int myrb_is_raid(struct device *dev)
 
 /**
  * myrb_get_resync - get raid volume resync percent complete
- * @dev the device struct object
+ * @dev: the device struct object
  */
 static void myrb_get_resync(struct device *dev)
 {
@@ -2281,7 +2280,7 @@ static void myrb_get_resync(struct device *dev)
 
 /**
  * myrb_get_state - get raid volume status
- * @dev the device struct object
+ * @dev: the device struct object
  */
 static void myrb_get_state(struct device *dev)
 {
@@ -2480,7 +2479,7 @@ static void myrb_monitor(struct work_struct *work)
 	queue_delayed_work(cb->work_q, &cb->monitor_work, interval);
 }
 
-/**
+/*
  * myrb_err_status - reports controller BIOS messages
  *
  * Controller BIOS messages are passed through the Error Status Register
-- 
2.27.0

