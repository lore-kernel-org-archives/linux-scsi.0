Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16689C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D6A207DD
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xIll18Oh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbgGIRrA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbgGIRqT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:19 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8364C08E763
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:18 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id w3so2746129wmi.4
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sg8dC1PqQ5ZLNgANJj8CFd/WU9c7Mby6GC87AahLWX8=;
        b=xIll18OhkjzHZuQidzTISpBaXG+WZBh3JRnVO8i3NXIo1g2Xi89ZygPD+hP7PF1bn7
         HeDvrLsMrhKlkgzAqRL/DkNmNOgNIOhanWfYeAotvr6CLwt4x3y9L3XimSLCMb/fsyg8
         4qUG7w/mjqrZemL1qXicM16ERq8FnXQpDFWwDbXUoNxvhPnrvJI2yaNfkoxc5CAzaxPd
         k0rapa6+Eons96Zn2Il+G5a+RNbzRI8FtcDoOGmWFinSkpKv0QT8kizzLMciebLU/P2k
         /pwI5WBDKQ7MumCTtEiCQO+UjZhXLngt7/rnR8NlrDr/c0ths5+lorQUp7Oq1xcmZFxi
         CEBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sg8dC1PqQ5ZLNgANJj8CFd/WU9c7Mby6GC87AahLWX8=;
        b=D0ExbaDKI+dcKPj4S8mOE/dG2m1ngYchMPVaYGXH/a3MK5pVCNRfbg90gfcdRX0NUV
         heRoQ076obFkIEQ5p43dAAAi8OET7qsuNpSrvWaEHLP2i7HZVStELeJ4aoNqIioSdgTo
         2i4dSnbWUAgPFylrMvz0Rnz7ujrmp8ydzZBv0RDVZe0Ay+qH29gJUNpWsPjyepVwzBks
         Kt/Wl8YmRgK+YBmLEmbC/muCCijfBDUDcROLQ/SadEfABTfIgGdHL0tIEBZ5BIXjLYrw
         OloKSpf1+IklSp2TP87P+HzhVSs9Bo8Nt6+5IeAB4ry9iRA1CbZS0ll4E4hn+qYXr2Az
         fa6w==
X-Gm-Message-State: AOAM531aSv7HTPki4J08ffbm5EjTeDgbG5hEJTusRVRMlcWMwi4+YT/1
        rg23CRjR6mHH00Zq7ciIjnyNkOh6zgo=
X-Google-Smtp-Source: ABdhPJxqpfIETwdxlShAfpzyZdFT5S0NVTPmxg39Qwu69TdfOVZsmN17tAW0CugawW8gk+dbI/kZ3w==
X-Received: by 2002:a1c:7402:: with SMTP id p2mr1101961wmc.117.1594316777278;
        Thu, 09 Jul 2020 10:46:17 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:16 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Christoph Hellwig <hch@lst.de>, Seokmann.Ju@lsil.com,
        sju@lsil.com, megaraidlinux.pdl@broadcom.com
Subject: [PATCH 16/24] scsi: megaraid: Fix a whole bunch of function header formatting issues
Date:   Thu,  9 Jul 2020 18:45:48 +0100
Message-Id: <20200709174556.7651-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Plus a couple of API catch-ups.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/megaraid.c:133: warning: Function parameter or member 'adapter' not described in 'mega_setup_mailbox'
 drivers/scsi/megaraid.c:356: warning: Function parameter or member 'adapter' not described in 'mega_runpendq'
 drivers/scsi/megaraid.c:424: warning: Function parameter or member 'adapter' not described in 'mega_allocate_scb'
 drivers/scsi/megaraid.c:424: warning: Function parameter or member 'cmd' not described in 'mega_allocate_scb'
 drivers/scsi/megaraid.c:456: warning: Function parameter or member 'adapter' not described in 'mega_get_ldrv_num'
 drivers/scsi/megaraid.c:456: warning: Function parameter or member 'cmd' not described in 'mega_get_ldrv_num'
 drivers/scsi/megaraid.c:456: warning: Function parameter or member 'channel' not described in 'mega_get_ldrv_num'
 drivers/scsi/megaraid.c:519: warning: Function parameter or member 'adapter' not described in 'mega_build_cmd'
 drivers/scsi/megaraid.c:519: warning: Function parameter or member 'cmd' not described in 'mega_build_cmd'
 drivers/scsi/megaraid.c:519: warning: Function parameter or member 'busy' not described in 'mega_build_cmd'
 drivers/scsi/megaraid.c:951: warning: Function parameter or member 'adapter' not described in 'mega_prepare_passthru'
 drivers/scsi/megaraid.c:951: warning: Function parameter or member 'scb' not described in 'mega_prepare_passthru'
 drivers/scsi/megaraid.c:951: warning: Function parameter or member 'cmd' not described in 'mega_prepare_passthru'
 drivers/scsi/megaraid.c:951: warning: Function parameter or member 'channel' not described in 'mega_prepare_passthru'
 drivers/scsi/megaraid.c:951: warning: Function parameter or member 'target' not described in 'mega_prepare_passthru'
 drivers/scsi/megaraid.c:1016: warning: Function parameter or member 'adapter' not described in 'mega_prepare_extpassthru'
 drivers/scsi/megaraid.c:1016: warning: Function parameter or member 'scb' not described in 'mega_prepare_extpassthru'
 drivers/scsi/megaraid.c:1016: warning: Function parameter or member 'cmd' not described in 'mega_prepare_extpassthru'
 drivers/scsi/megaraid.c:1016: warning: Function parameter or member 'channel' not described in 'mega_prepare_extpassthru'
 drivers/scsi/megaraid.c:1016: warning: Function parameter or member 'target' not described in 'mega_prepare_extpassthru'
 drivers/scsi/megaraid.c:1097: warning: Function parameter or member 'adapter' not described in 'issue_scb'
 drivers/scsi/megaraid.c:1097: warning: Function parameter or member 'scb' not described in 'issue_scb'
 drivers/scsi/megaraid.c:1176: warning: Function parameter or member 'adapter' not described in 'issue_scb_block'
 drivers/scsi/megaraid.c:1176: warning: Function parameter or member 'raw_mbox' not described in 'issue_scb_block'
 drivers/scsi/megaraid.c:1259: warning: Function parameter or member 'irq' not described in 'megaraid_isr_iomapped'
 drivers/scsi/megaraid.c:1259: warning: Function parameter or member 'devp' not described in 'megaraid_isr_iomapped'
 drivers/scsi/megaraid.c:1335: warning: Function parameter or member 'irq' not described in 'megaraid_isr_memmapped'
 drivers/scsi/megaraid.c:1335: warning: Function parameter or member 'devp' not described in 'megaraid_isr_memmapped'
 drivers/scsi/megaraid.c:1413: warning: Function parameter or member 'adapter' not described in 'mega_cmd_done'
 drivers/scsi/megaraid.c:1413: warning: Function parameter or member 'completed' not described in 'mega_cmd_done'
 drivers/scsi/megaraid.c:1413: warning: Function parameter or member 'nstatus' not described in 'mega_cmd_done'
 drivers/scsi/megaraid.c:1413: warning: Function parameter or member 'status' not described in 'mega_cmd_done'
 drivers/scsi/megaraid.c:1933: warning: Function parameter or member 'adapter' not described in 'megaraid_abort_and_reset'
 drivers/scsi/megaraid.c:1933: warning: Function parameter or member 'cmd' not described in 'megaraid_abort_and_reset'
 drivers/scsi/megaraid.c:1933: warning: Function parameter or member 'aor' not described in 'megaraid_abort_and_reset'
 drivers/scsi/megaraid.c:2031: warning: Function parameter or member 'dma_handle' not described in 'mega_allocate_inquiry'
 drivers/scsi/megaraid.c:2031: warning: Function parameter or member 'pdev' not described in 'mega_allocate_inquiry'
 drivers/scsi/megaraid.c:2055: warning: Function parameter or member 'm' not described in 'proc_show_config'
 drivers/scsi/megaraid.c:2055: warning: Function parameter or member 'v' not described in 'proc_show_config'
 drivers/scsi/megaraid.c:2119: warning: Function parameter or member 'm' not described in 'proc_show_stat'
 drivers/scsi/megaraid.c:2119: warning: Function parameter or member 'v' not described in 'proc_show_stat'
 drivers/scsi/megaraid.c:2154: warning: Function parameter or member 'm' not described in 'proc_show_mbox'
 drivers/scsi/megaraid.c:2154: warning: Function parameter or member 'v' not described in 'proc_show_mbox'
 drivers/scsi/megaraid.c:2181: warning: Function parameter or member 'm' not described in 'proc_show_rebuild_rate'
 drivers/scsi/megaraid.c:2181: warning: Function parameter or member 'v' not described in 'proc_show_rebuild_rate'
 drivers/scsi/megaraid.c:2224: warning: Function parameter or member 'm' not described in 'proc_show_battery'
 drivers/scsi/megaraid.c:2224: warning: Function parameter or member 'v' not described in 'proc_show_battery'
 drivers/scsi/megaraid.c:2328: warning: Function parameter or member 'm' not described in 'proc_show_pdrv'
 drivers/scsi/megaraid.c:2328: warning: Function parameter or member 'adapter' not described in 'proc_show_pdrv'
 drivers/scsi/megaraid.c:2328: warning: Function parameter or member 'channel' not described in 'proc_show_pdrv'
 drivers/scsi/megaraid.c:2443: warning: Function parameter or member 'm' not described in 'proc_show_pdrv_ch0'
 drivers/scsi/megaraid.c:2443: warning: Function parameter or member 'v' not described in 'proc_show_pdrv_ch0'
 drivers/scsi/megaraid.c:2457: warning: Function parameter or member 'm' not described in 'proc_show_pdrv_ch1'
 drivers/scsi/megaraid.c:2457: warning: Function parameter or member 'v' not described in 'proc_show_pdrv_ch1'
 drivers/scsi/megaraid.c:2471: warning: Function parameter or member 'm' not described in 'proc_show_pdrv_ch2'
 drivers/scsi/megaraid.c:2471: warning: Function parameter or member 'v' not described in 'proc_show_pdrv_ch2'
 drivers/scsi/megaraid.c:2485: warning: Function parameter or member 'm' not described in 'proc_show_pdrv_ch3'
 drivers/scsi/megaraid.c:2485: warning: Function parameter or member 'v' not described in 'proc_show_pdrv_ch3'
 drivers/scsi/megaraid.c:2502: warning: Function parameter or member 'm' not described in 'proc_show_rdrv'
 drivers/scsi/megaraid.c:2502: warning: Function parameter or member 'adapter' not described in 'proc_show_rdrv'
 drivers/scsi/megaraid.c:2502: warning: Function parameter or member 'start' not described in 'proc_show_rdrv'
 drivers/scsi/megaraid.c:2502: warning: Function parameter or member 'end' not described in 'proc_show_rdrv'
 drivers/scsi/megaraid.c:2684: warning: Function parameter or member 'm' not described in 'proc_show_rdrv_10'
 drivers/scsi/megaraid.c:2684: warning: Function parameter or member 'v' not described in 'proc_show_rdrv_10'
 drivers/scsi/megaraid.c:2698: warning: Function parameter or member 'm' not described in 'proc_show_rdrv_20'
 drivers/scsi/megaraid.c:2698: warning: Function parameter or member 'v' not described in 'proc_show_rdrv_20'
 drivers/scsi/megaraid.c:2712: warning: Function parameter or member 'm' not described in 'proc_show_rdrv_30'
 drivers/scsi/megaraid.c:2712: warning: Function parameter or member 'v' not described in 'proc_show_rdrv_30'
 drivers/scsi/megaraid.c:2726: warning: Function parameter or member 'm' not described in 'proc_show_rdrv_40'
 drivers/scsi/megaraid.c:2726: warning: Function parameter or member 'v' not described in 'proc_show_rdrv_40'
 drivers/scsi/megaraid.c:2739: warning: Function parameter or member 'index' not described in 'mega_create_proc_entry'
 drivers/scsi/megaraid.c:2739: warning: Function parameter or member 'parent' not described in 'mega_create_proc_entry'
 drivers/scsi/megaraid.c:2796: warning: Function parameter or member 'sdev' not described in 'megaraid_biosparam'
 drivers/scsi/megaraid.c:2796: warning: Function parameter or member 'bdev' not described in 'megaraid_biosparam'
 drivers/scsi/megaraid.c:2796: warning: Function parameter or member 'capacity' not described in 'megaraid_biosparam'
 drivers/scsi/megaraid.c:2796: warning: Function parameter or member 'geom' not described in 'megaraid_biosparam'
 drivers/scsi/megaraid.c:2865: warning: Function parameter or member 'adapter' not described in 'mega_init_scb'
 drivers/scsi/megaraid.c:2945: warning: Function parameter or member 'inode' not described in 'megadev_open'
 drivers/scsi/megaraid.c:2945: warning: Function parameter or member 'filep' not described in 'megadev_open'
 drivers/scsi/megaraid.c:2969: warning: Function parameter or member 'filep' not described in 'megadev_ioctl'
 drivers/scsi/megaraid.c:2969: warning: Function parameter or member 'cmd' not described in 'megadev_ioctl'
 drivers/scsi/megaraid.c:2969: warning: Function parameter or member 'arg' not described in 'megadev_ioctl'
 drivers/scsi/megaraid.c:3383: warning: Function parameter or member 'arg' not described in 'mega_m_to_n'
 drivers/scsi/megaraid.c:3383: warning: Function parameter or member 'uioc' not described in 'mega_m_to_n'
 drivers/scsi/megaraid.c:3574: warning: Function parameter or member 'adapter' not described in 'mega_is_bios_enabled'
 drivers/scsi/megaraid.c:3607: warning: Function parameter or member 'adapter' not described in 'mega_enum_raid_scsi'
 drivers/scsi/megaraid.c:3661: warning: Function parameter or member 'adapter' not described in 'mega_get_boot_drv'
 drivers/scsi/megaraid.c:3728: warning: Function parameter or member 'adapter' not described in 'mega_support_random_del'
 drivers/scsi/megaraid.c:3757: warning: Function parameter or member 'adapter' not described in 'mega_support_ext_cdb'
 drivers/scsi/megaraid.c:3787: warning: Function parameter or member 'adapter' not described in 'mega_del_logdrv'
 drivers/scsi/megaraid.c:3787: warning: Function parameter or member 'logdrv' not described in 'mega_del_logdrv'
 drivers/scsi/megaraid.c:3872: warning: Function parameter or member 'adapter' not described in 'mega_get_max_sgl'
 drivers/scsi/megaraid.c:3917: warning: Function parameter or member 'adapter' not described in 'mega_support_cluster'
 drivers/scsi/megaraid.c:3962: warning: Function parameter or member 'adapter' not described in 'mega_adapinq'
 drivers/scsi/megaraid.c:3962: warning: Function parameter or member 'dma_handle' not described in 'mega_adapinq'
 drivers/scsi/megaraid.c:4071: warning: Function parameter or member 'adapter' not described in 'mega_internal_command'
 drivers/scsi/megaraid.c:4071: warning: Function parameter or member 'mc' not described in 'mega_internal_command'
 drivers/scsi/megaraid.c:4071: warning: Function parameter or member 'pthru' not described in 'mega_internal_command'

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Seokmann.Ju@lsil.com
Cc: sju@lsil.com
Cc: megaraidlinux.pdl@broadcom.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/megaraid.c | 218 ++++++++++++++++++++--------------------
 1 file changed, 109 insertions(+), 109 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index f27ffd088c8ae..2d57836d1607f 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -124,7 +124,7 @@ static int trace_level;
 
 /**
  * mega_setup_mailbox()
- * @adapter - pointer to our soft state
+ * @adapter: pointer to our soft state
  *
  * Allocates a 8 byte aligned memory for the handshake mailbox.
  */
@@ -178,9 +178,9 @@ mega_setup_mailbox(adapter_t *adapter)
 }
 
 
-/*
+/**
  * mega_query_adapter()
- * @adapter - pointer to our soft state
+ * @adapter: pointer to our soft state
  *
  * Issue the adapter inquiry commands to the controller and find out
  * information and parameter about the devices attached
@@ -347,7 +347,7 @@ mega_query_adapter(adapter_t *adapter)
 
 /**
  * mega_runpendq()
- * @adapter - pointer to our soft state
+ * @adapter: pointer to our soft state
  *
  * Runs through the list of pending requests.
  */
@@ -358,10 +358,10 @@ mega_runpendq(adapter_t *adapter)
 		__mega_runpendq(adapter);
 }
 
-/*
+/**
  * megaraid_queue()
- * @scmd - Issue this scsi command
- * @done - the callback hook into the scsi mid-layer
+ * @scmd: Issue this scsi command
+ * @done: the callback hook into the scsi mid-layer
  *
  * The command queuing entry point for the mid-layer.
  */
@@ -413,8 +413,8 @@ static DEF_SCSI_QCMD(megaraid_queue)
 
 /**
  * mega_allocate_scb()
- * @adapter - pointer to our soft state
- * @cmd - scsi command from the mid-layer
+ * @adapter: pointer to our soft state
+ * @cmd: scsi command from the mid-layer
  *
  * Allocate a SCB structure. This is the central structure for controller
  * commands.
@@ -444,9 +444,9 @@ mega_allocate_scb(adapter_t *adapter, struct scsi_cmnd *cmd)
 
 /**
  * mega_get_ldrv_num()
- * @adapter - pointer to our soft state
- * @cmd - scsi mid layer command
- * @channel - channel on the controller
+ * @adapter: pointer to our soft state
+ * @cmd: scsi mid layer command
+ * @channel: channel on the controller
  *
  * Calculate the logical drive number based on the information in scsi command
  * and the channel number.
@@ -503,9 +503,9 @@ mega_get_ldrv_num(adapter_t *adapter, struct scsi_cmnd *cmd, int channel)
 
 /**
  * mega_build_cmd()
- * @adapter - pointer to our soft state
- * @cmd - Prepare using this scsi command
- * @busy - busy flag if no resources
+ * @adapter: pointer to our soft state
+ * @cmd: Prepare using this scsi command
+ * @busy: busy flag if no resources
  *
  * Prepares a command and scatter gather list for the controller. This routine
  * also finds out if the commands is intended for a logical drive or a
@@ -937,11 +937,11 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 
 /**
  * mega_prepare_passthru()
- * @adapter - pointer to our soft state
- * @scb - our scsi control block
- * @cmd - scsi command from the mid-layer
- * @channel - actual channel on the controller
- * @target - actual id on the controller.
+ * @adapter: pointer to our soft state
+ * @scb: our scsi control block
+ * @cmd: scsi command from the mid-layer
+ * @channel: actual channel on the controller
+ * @target: actual id on the controller.
  *
  * prepare a command for the scsi physical devices.
  */
@@ -1000,11 +1000,11 @@ mega_prepare_passthru(adapter_t *adapter, scb_t *scb, struct scsi_cmnd *cmd,
 
 /**
  * mega_prepare_extpassthru()
- * @adapter - pointer to our soft state
- * @scb - our scsi control block
- * @cmd - scsi command from the mid-layer
- * @channel - actual channel on the controller
- * @target - actual id on the controller.
+ * @adapter: pointer to our soft state
+ * @scb: our scsi control block
+ * @cmd: scsi command from the mid-layer
+ * @channel: actual channel on the controller
+ * @target: actual id on the controller.
  *
  * prepare a command for the scsi physical devices. This rountine prepares
  * commands for devices which can take extended CDBs (>10 bytes)
@@ -1085,8 +1085,8 @@ __mega_runpendq(adapter_t *adapter)
 
 /**
  * issue_scb()
- * @adapter - pointer to our soft state
- * @scb - scsi control block
+ * @adapter: pointer to our soft state
+ * @scb: scsi control block
  *
  * Post a command to the card if the mailbox is available, otherwise return
  * busy. We also take the scb from the pending list if the mailbox is
@@ -1166,8 +1166,8 @@ mega_busywait_mbox (adapter_t *adapter)
 
 /**
  * issue_scb_block()
- * @adapter - pointer to our soft state
- * @raw_mbox - the mailbox
+ * @adapter: pointer to our soft state
+ * @raw_mbox: the mailbox
  *
  * Issue a scb in synchronous and non-interrupt mode
  */
@@ -1247,8 +1247,8 @@ issue_scb_block(adapter_t *adapter, u_char *raw_mbox)
 
 /**
  * megaraid_isr_iomapped()
- * @irq - irq
- * @devp - pointer to our soft state
+ * @irq: irq
+ * @devp: pointer to our soft state
  *
  * Interrupt service routine for io-mapped controllers.
  * Find out if our device is interrupting. If yes, acknowledge the interrupt
@@ -1323,8 +1323,8 @@ megaraid_isr_iomapped(int irq, void *devp)
 
 /**
  * megaraid_isr_memmapped()
- * @irq - irq
- * @devp - pointer to our soft state
+ * @irq: irq
+ * @devp: pointer to our soft state
  *
  * Interrupt service routine for memory-mapped controllers.
  * Find out if our device is interrupting. If yes, acknowledge the interrupt
@@ -1401,10 +1401,10 @@ megaraid_isr_memmapped(int irq, void *devp)
 }
 /**
  * mega_cmd_done()
- * @adapter - pointer to our soft state
- * @completed - array of ids of completed commands
- * @nstatus - number of completed commands
- * @status - status of the last command completed
+ * @adapter: pointer to our soft state
+ * @completed: array of ids of completed commands
+ * @nstatus: number of completed commands
+ * @status: status of the last command completed
  *
  * Complete the commands and call the scsi mid-layer callback hooks.
  */
@@ -1921,9 +1921,9 @@ megaraid_reset(struct scsi_cmnd *cmd)
 
 /**
  * megaraid_abort_and_reset()
- * @adapter - megaraid soft state
- * @cmd - scsi command to be aborted or reset
- * @aor - abort or reset flag
+ * @adapter: megaraid soft state
+ * @cmd: scsi command to be aborted or reset
+ * @aor: abort or reset flag
  *
  * Try to locate the scsi command in the pending queue. If found and is not
  * issued to the controller, abort/reset it. Otherwise return failure
@@ -2021,8 +2021,8 @@ free_local_pdev(struct pci_dev *pdev)
 
 /**
  * mega_allocate_inquiry()
- * @dma_handle - handle returned for dma address
- * @pdev - handle to pci device
+ * @dma_handle: handle returned for dma address
+ * @pdev: handle to pci device
  *
  * allocates memory for inquiry structure
  */
@@ -2045,8 +2045,8 @@ mega_free_inquiry(void *inquiry, dma_addr_t dma_handle, struct pci_dev *pdev)
 
 /**
  * proc_show_config()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display configuration information about the controller.
  */
@@ -2109,8 +2109,8 @@ proc_show_config(struct seq_file *m, void *v)
 
 /**
  * proc_show_stat()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display statistical information about the I/O activity.
  */
@@ -2143,8 +2143,8 @@ proc_show_stat(struct seq_file *m, void *v)
 
 /**
  * proc_show_mbox()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display mailbox information for the last command issued. This information
  * is good for debugging.
@@ -2171,8 +2171,8 @@ proc_show_mbox(struct seq_file *m, void *v)
 
 /**
  * proc_show_rebuild_rate()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display current rebuild rate
  */
@@ -2214,8 +2214,8 @@ proc_show_rebuild_rate(struct seq_file *m, void *v)
 
 /**
  * proc_show_battery()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display information about the battery module on the controller.
  */
@@ -2317,9 +2317,9 @@ mega_print_inquiry(struct seq_file *m, char *scsi_inq)
 
 /**
  * proc_show_pdrv()
- * @m - Synthetic file construction data
- * @page - buffer to write the data in
- * @adapter - pointer to our soft state
+ * @m: Synthetic file construction data
+ * @adapter: pointer to our soft state
+ * @channel: channel on the controller
  *
  * Display information about the physical drives.
  */
@@ -2433,8 +2433,8 @@ proc_show_pdrv(struct seq_file *m, adapter_t *adapter, int channel)
 
 /**
  * proc_show_pdrv_ch0()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display information about the physical drives on physical channel 0.
  */
@@ -2447,8 +2447,8 @@ proc_show_pdrv_ch0(struct seq_file *m, void *v)
 
 /**
  * proc_show_pdrv_ch1()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display information about the physical drives on physical channel 1.
  */
@@ -2461,8 +2461,8 @@ proc_show_pdrv_ch1(struct seq_file *m, void *v)
 
 /**
  * proc_show_pdrv_ch2()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display information about the physical drives on physical channel 2.
  */
@@ -2475,8 +2475,8 @@ proc_show_pdrv_ch2(struct seq_file *m, void *v)
 
 /**
  * proc_show_pdrv_ch3()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display information about the physical drives on physical channel 3.
  */
@@ -2489,10 +2489,10 @@ proc_show_pdrv_ch3(struct seq_file *m, void *v)
 
 /**
  * proc_show_rdrv()
- * @m - Synthetic file construction data
- * @adapter - pointer to our soft state
- * @start - starting logical drive to display
- * @end - ending logical drive to display
+ * @m: Synthetic file construction data
+ * @adapter: pointer to our soft state
+ * @start: starting logical drive to display
+ * @end: ending logical drive to display
  *
  * We do not print the inquiry information since its already available through
  * /proc/scsi/scsi interface
@@ -2674,8 +2674,8 @@ proc_show_rdrv(struct seq_file *m, adapter_t *adapter, int start, int end )
 
 /**
  * proc_show_rdrv_10()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display real time information about the logical drives 0 through 9.
  */
@@ -2688,8 +2688,8 @@ proc_show_rdrv_10(struct seq_file *m, void *v)
 
 /**
  * proc_show_rdrv_20()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display real time information about the logical drives 0 through 9.
  */
@@ -2702,8 +2702,8 @@ proc_show_rdrv_20(struct seq_file *m, void *v)
 
 /**
  * proc_show_rdrv_30()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display real time information about the logical drives 0 through 9.
  */
@@ -2716,8 +2716,8 @@ proc_show_rdrv_30(struct seq_file *m, void *v)
 
 /**
  * proc_show_rdrv_40()
- * @m - Synthetic file construction data
- * @v - File iterator
+ * @m: Synthetic file construction data
+ * @v: File iterator
  *
  * Display real time information about the logical drives 0 through 9.
  */
@@ -2729,8 +2729,8 @@ proc_show_rdrv_40(struct seq_file *m, void *v)
 
 /**
  * mega_create_proc_entry()
- * @index - index in soft state array
- * @parent - parent node for this /proc entry
+ * @index: index in soft state array
+ * @parent: parent node for this /proc entry
  *
  * Creates /proc entries for our controllers.
  */
@@ -2785,7 +2785,7 @@ static inline void mega_create_proc_entry(int index, struct proc_dir_entry *pare
 #endif
 
 
-/**
+/*
  * megaraid_biosparam()
  *
  * Return the disk geometry for a particular disk
@@ -2854,7 +2854,7 @@ megaraid_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 
 /**
  * mega_init_scb()
- * @adapter - pointer to our soft state
+ * @adapter: pointer to our soft state
  *
  * Allocate memory for the various pointers in the scb structures:
  * scatter-gather list pointer, passthru and extended passthru structure
@@ -2934,8 +2934,8 @@ mega_init_scb(adapter_t *adapter)
 
 /**
  * megadev_open()
- * @inode - unused
- * @filep - unused
+ * @inode: unused
+ * @filep: unused
  *
  * Routines for the character/ioctl interface to the driver. Find out if this
  * is a valid open. 
@@ -2954,10 +2954,9 @@ megadev_open (struct inode *inode, struct file *filep)
 
 /**
  * megadev_ioctl()
- * @inode - Our device inode
- * @filep - unused
- * @cmd - ioctl command
- * @arg - user buffer
+ * @filep: unused
+ * @cmd: ioctl command
+ * @arg: user buffer
  *
  * ioctl entry point for our private ioctl interface. We move the data in from
  * the user space, prepare the command (if necessary, convert the old MIMD
@@ -3370,8 +3369,8 @@ megadev_unlocked_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 
 /**
  * mega_m_to_n()
- * @arg - user address
- * @uioc - new ioctl structure
+ * @arg: user address
+ * @uioc: new ioctl structure
  *
  * A thin layer to convert older mimd interface ioctl structure to NIT ioctl
  * structure
@@ -3496,10 +3495,10 @@ mega_m_to_n(void __user *arg, nitioctl_t *uioc)
 	return 0;
 }
 
-/*
+/**
  * mega_n_to_m()
- * @arg - user address
- * @mc - mailbox command
+ * @arg: user address
+ * @mc: mailbox command
  *
  * Updates the status information to the application, depending on application
  * conforms to older mimd ioctl interface or newer NIT ioctl interface
@@ -3565,7 +3564,7 @@ mega_n_to_m(void __user *arg, megacmd_t *mc)
 
 /**
  * mega_is_bios_enabled()
- * @adapter - pointer to our soft state
+ * @adapter: pointer to our soft state
  *
  * issue command to find out if the BIOS is enabled for this controller
  */
@@ -3596,7 +3595,7 @@ mega_is_bios_enabled(adapter_t *adapter)
 
 /**
  * mega_enum_raid_scsi()
- * @adapter - pointer to our soft state
+ * @adapter: pointer to our soft state
  *
  * Find out what channels are RAID/SCSI. This information is used to
  * differentiate the virtual channels and physical channels and to support
@@ -3651,7 +3650,7 @@ mega_enum_raid_scsi(adapter_t *adapter)
 
 /**
  * mega_get_boot_drv()
- * @adapter - pointer to our soft state
+ * @adapter: pointer to our soft state
  *
  * Find out which device is the boot device. Note, any logical drive or any
  * phyical device (e.g., a CDROM) can be designated as a boot device.
@@ -3718,7 +3717,7 @@ mega_get_boot_drv(adapter_t *adapter)
 
 /**
  * mega_support_random_del()
- * @adapter - pointer to our soft state
+ * @adapter: pointer to our soft state
  *
  * Find out if this controller supports random deletion and addition of
  * logical drives
@@ -3748,7 +3747,7 @@ mega_support_random_del(adapter_t *adapter)
 
 /**
  * mega_support_ext_cdb()
- * @adapter - pointer to our soft state
+ * @adapter: pointer to our soft state
  *
  * Find out if this firmware support cdblen > 10
  */
@@ -3776,8 +3775,8 @@ mega_support_ext_cdb(adapter_t *adapter)
 
 /**
  * mega_del_logdrv()
- * @adapter - pointer to our soft state
- * @logdrv - logical drive to be deleted
+ * @adapter: pointer to our soft state
+ * @logdrv: logical drive to be deleted
  *
  * Delete the specified logical drive. It is the responsibility of the user
  * app to let the OS know about this operation.
@@ -3862,7 +3861,7 @@ mega_do_del_logdrv(adapter_t *adapter, int logdrv)
 
 /**
  * mega_get_max_sgl()
- * @adapter - pointer to our soft state
+ * @adapter: pointer to our soft state
  *
  * Find out the maximum number of scatter-gather elements supported by this
  * version of the firmware
@@ -3908,7 +3907,7 @@ mega_get_max_sgl(adapter_t *adapter)
 
 /**
  * mega_support_cluster()
- * @adapter - pointer to our soft state
+ * @adapter: pointer to our soft state
  *
  * Find out if this firmware support cluster calls.
  */
@@ -3950,8 +3949,8 @@ mega_support_cluster(adapter_t *adapter)
 #ifdef CONFIG_PROC_FS
 /**
  * mega_adapinq()
- * @adapter - pointer to our soft state
- * @dma_handle - DMA address of the buffer
+ * @adapter: pointer to our soft state
+ * @dma_handle: DMA address of the buffer
  *
  * Issue internal commands while interrupts are available.
  * We only issue direct mailbox commands from within the driver. ioctl()
@@ -3983,11 +3982,12 @@ mega_adapinq(adapter_t *adapter, dma_addr_t dma_handle)
 }
 
 
-/** mega_internal_dev_inquiry()
- * @adapter - pointer to our soft state
- * @ch - channel for this device
- * @tgt - ID of this device
- * @buf_dma_handle - DMA address of the buffer
+/**
+ * mega_internal_dev_inquiry()
+ * @adapter: pointer to our soft state
+ * @ch: channel for this device
+ * @tgt: ID of this device
+ * @buf_dma_handle: DMA address of the buffer
  *
  * Issue the scsi inquiry for the specified device.
  */
@@ -4056,9 +4056,9 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, u8 tgt,
 
 /**
  * mega_internal_command()
- * @adapter - pointer to our soft state
- * @mc - the mailbox command
- * @pthru - Passthru structure for DCDB commands
+ * @adapter: pointer to our soft state
+ * @mc: the mailbox command
+ * @pthru: Passthru structure for DCDB commands
  *
  * Issue the internal commands in interrupt mode.
  * The last argument is the address of the passthru structure if the command
-- 
2.25.1

