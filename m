Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B561C2BA83
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B8D964D5D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhCQJNu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhCQJNO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:14 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DBFC06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:03 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so4988363wma.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uTNqNlz+Ecexn349OCj8UvAD3yFKfX6K/X1rJlsgwE4=;
        b=NjwKS70JSdJTqCLRsydCZ8MnzYAyMKrf5yd3/VvJhFZmnFTzlcjDhxkgNNsxXqj20k
         tX134FeDTDfhZURYy427MNHsZWbrKuNHekfjZLjm6LBShO9C8x5oMSVOTYO8Mao1rmk7
         jHSrhQZkQZCDYhLHLNRIjS/62yd7Fl6zVzXfscxSw/HMx5aNuIp6yE7RgXy9e+dpl8Sa
         FdU5xqYBfqOxsigfQ3vOB2Y9vi+WT7Dnay3M4F6laBnsEoilKwbRGd4esn6na5nrjOZp
         R1v7AGWvcPdurC56X98C/jU2PlrFF+dMAhVkSorh2TTiL3W82Lfpu7CkVayXS4JbZYN8
         NwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uTNqNlz+Ecexn349OCj8UvAD3yFKfX6K/X1rJlsgwE4=;
        b=EOF2GgwoS3r8+uN6nwlWrb555qMlUsaFFoPMgafSEkZKTbFoBjeEuFzJdd9fSRviPa
         aH5wU3b4Hy+IzR/no49UWMIVAaTiOTr4jSq1vFAUPLe1RsfjEQha//gCI9AamE7Paaqx
         km67FRC508vq+fM2bfEHDXmqVsG74tAjo9tLHoalHB02eWMYv3+h877Qg1jCH2EfJSPi
         d5KqqpgWfvoypzIf56dHymXvDmrUJhP4QZYGRFsMPxBIRk2ISuKZOjxZgxd6hAZLVmht
         7YxKQhxntDVeA9PBYG5NQqLPWwPwZr5vN6NQvWHxRnl7/mP9rs4vYJMJImVOGmBMwnog
         ubOA==
X-Gm-Message-State: AOAM533T8VtfyZgS8mXl6e5kjLaQRdeEUf59v2H0dWTAWtLvhGtGHdDO
        aDt3eWEsR0bptgOYbp/xO5G3e4NGFqFdYg==
X-Google-Smtp-Source: ABdhPJz49XR6h5U/phDAhEcEQiD2oH9OnjIFP1p8VxQVe7IHelKhUnyLOo6nrlongYhhtpNJ8Rll4g==
X-Received: by 2002:a1c:e383:: with SMTP id a125mr2705173wmh.125.1615972382028;
        Wed, 17 Mar 2021 02:13:02 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:01 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 21/36] scsi: isci: host: Fix bunch of kernel-doc related issues
Date:   Wed, 17 Mar 2021 09:12:15 +0000
Message-Id: <20210317091230.2912389-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/host.c:93: warning: Cannot understand  *
 drivers/scsi/isci/host.c:108: warning: Function parameter or member 'x' not described in 'NORMALIZE_PUT_POINTER'
 drivers/scsi/isci/host.c:121: warning: Function parameter or member 'x' not described in 'NORMALIZE_EVENT_POINTER'
 drivers/scsi/isci/host.c:130: warning: Function parameter or member 'x' not described in 'NORMALIZE_GET_POINTER'
 drivers/scsi/isci/host.c:139: warning: Function parameter or member 'x' not described in 'NORMALIZE_GET_POINTER_CYCLE_BIT'
 drivers/scsi/isci/host.c:146: warning: Function parameter or member 'x' not described in 'COMPLETION_QUEUE_CYCLE_BIT'
 drivers/scsi/isci/host.c:646: warning: Function parameter or member 'ihost' not described in 'isci_host_start_complete'
 drivers/scsi/isci/host.c:646: warning: Excess function parameter 'isci_host' description in 'isci_host_start_complete'
 drivers/scsi/isci/host.c:680: warning: Function parameter or member 'ihost' not described in 'sci_controller_get_suggested_start_timeout'
 drivers/scsi/isci/host.c:680: warning: Excess function parameter 'controller' description in 'sci_controller_get_suggested_start_timeout'
 drivers/scsi/isci/host.c:903: warning: Function parameter or member 'ihost' not described in 'sci_controller_start_next_phy'
 drivers/scsi/isci/host.c:903: warning: Excess function parameter 'scic' description in 'sci_controller_start_next_phy'
 drivers/scsi/isci/host.c:1159: warning: Function parameter or member 'ihost' not described in 'sci_controller_stop'
 drivers/scsi/isci/host.c:1159: warning: Excess function parameter 'controller' description in 'sci_controller_stop'
 drivers/scsi/isci/host.c:1184: warning: Function parameter or member 'ihost' not described in 'sci_controller_reset'
 drivers/scsi/isci/host.c:1184: warning: Excess function parameter 'controller' description in 'sci_controller_reset'
 drivers/scsi/isci/host.c:1352: warning: Function parameter or member 'ihost' not described in 'sci_controller_set_interrupt_coalescence'
 drivers/scsi/isci/host.c:1352: warning: Excess function parameter 'controller' description in 'sci_controller_set_interrupt_coalescence'
 drivers/scsi/isci/host.c:2498: warning: Function parameter or member 'ihost' not described in 'sci_controller_allocate_remote_node_context'
 drivers/scsi/isci/host.c:2498: warning: Function parameter or member 'idev' not described in 'sci_controller_allocate_remote_node_context'
 drivers/scsi/isci/host.c:2498: warning: expecting prototype for This method allocates remote node index and the reserves the remote node(). Prototype was for sci_controller_allocate_remote_node_context() instead
 drivers/scsi/isci/host.c:2721: warning: Function parameter or member 'ihost' not described in 'sci_controller_start_task'
 drivers/scsi/isci/host.c:2721: warning: Function parameter or member 'idev' not described in 'sci_controller_start_task'
 drivers/scsi/isci/host.c:2721: warning: Function parameter or member 'ireq' not described in 'sci_controller_start_task'
 drivers/scsi/isci/host.c:2721: warning: Excess function parameter 'controller' description in 'sci_controller_start_task'
 drivers/scsi/isci/host.c:2721: warning: Excess function parameter 'remote_device' description in 'sci_controller_start_task'
 drivers/scsi/isci/host.c:2721: warning: Excess function parameter 'task_request' description in 'sci_controller_start_task'

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/host.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 7ebfa3c8cdc78..d690d9cf7eb15 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -89,16 +89,14 @@
 
 #define SCIC_SDS_CONTROLLER_PHY_START_TIMEOUT      100
 
-/**
- *
- *
+/*
  * The number of milliseconds to wait while a given phy is consuming power
  * before allowing another set of phys to consume power. Ultimately, this will
  * be specified by OEM parameter.
  */
 #define SCIC_SDS_CONTROLLER_POWER_CONTROL_INTERVAL 500
 
-/**
+/*
  * NORMALIZE_PUT_POINTER() -
  *
  * This macro will normalize the completion queue put pointer so its value can
@@ -108,7 +106,7 @@
 	((x) & SMU_COMPLETION_QUEUE_PUT_POINTER_MASK)
 
 
-/**
+/*
  * NORMALIZE_EVENT_POINTER() -
  *
  * This macro will normalize the completion queue event entry so its value can
@@ -120,7 +118,7 @@
 		>> SMU_COMPLETION_QUEUE_GET_EVENT_POINTER_SHIFT	\
 	)
 
-/**
+/*
  * NORMALIZE_GET_POINTER() -
  *
  * This macro will normalize the completion queue get pointer so its value can
@@ -129,7 +127,7 @@
 #define NORMALIZE_GET_POINTER(x) \
 	((x) & SMU_COMPLETION_QUEUE_GET_POINTER_MASK)
 
-/**
+/*
  * NORMALIZE_GET_POINTER_CYCLE_BIT() -
  *
  * This macro will normalize the completion queue cycle pointer so it matches
@@ -138,7 +136,7 @@
 #define NORMALIZE_GET_POINTER_CYCLE_BIT(x) \
 	((SMU_CQGR_CYCLE_BIT & (x)) << (31 - SMU_COMPLETION_QUEUE_GET_CYCLE_BIT_SHIFT))
 
-/**
+/*
  * COMPLETION_QUEUE_CYCLE_BIT() -
  *
  * This macro will return the cycle bit of the completion queue entry
@@ -637,7 +635,7 @@ irqreturn_t isci_error_isr(int vec, void *data)
 /**
  * isci_host_start_complete() - This function is called by the core library,
  *    through the ISCI Module, to indicate controller start status.
- * @isci_host: This parameter specifies the ISCI host object
+ * @ihost: This parameter specifies the ISCI host object
  * @completion_status: This parameter specifies the completion status from the
  *    core library.
  *
@@ -670,7 +668,7 @@ int isci_host_scan_finished(struct Scsi_Host *shost, unsigned long time)
  *    use any timeout value, but this method provides the suggested minimum
  *    start timeout value.  The returned value is based upon empirical
  *    information determined as a result of interoperability testing.
- * @controller: the handle to the controller object for which to return the
+ * @ihost: the handle to the controller object for which to return the
  *    suggested start timeout.
  *
  * This method returns the number of milliseconds for the suggested start
@@ -893,7 +891,7 @@ bool is_controller_start_complete(struct isci_host *ihost)
 
 /**
  * sci_controller_start_next_phy - start phy
- * @scic: controller
+ * @ihost: controller
  *
  * If all the phys have been started, then attempt to transition the
  * controller to the READY state and inform the user
@@ -1145,7 +1143,7 @@ void isci_host_completion_routine(unsigned long data)
  *    controller has been quiesced. This method will ensure that all IO
  *    requests are quiesced, phys are stopped, and all additional operation by
  *    the hardware is halted.
- * @controller: the handle to the controller object to stop.
+ * @ihost: the handle to the controller object to stop.
  * @timeout: This parameter specifies the number of milliseconds in which the
  *    stop operation should complete.
  *
@@ -1174,7 +1172,7 @@ static enum sci_status sci_controller_stop(struct isci_host *ihost, u32 timeout)
  *    considered destructive.  In other words, all current operations are wiped
  *    out.  No IO completions for outstanding devices occur.  Outstanding IO
  *    requests are not aborted or completed at the actual remote device.
- * @controller: the handle to the controller object to reset.
+ * @ihost: the handle to the controller object to reset.
  *
  * Indicate if the controller reset method succeeded or failed in some way.
  * SCI_SUCCESS if the reset operation successfully started. SCI_FATAL_ERROR if
@@ -1331,7 +1329,7 @@ static inline void sci_controller_starting_state_exit(struct sci_base_state_mach
 /**
  * sci_controller_set_interrupt_coalescence() - This method allows the user to
  *    configure the interrupt coalescence.
- * @controller: This parameter represents the handle to the controller object
+ * @ihost: This parameter represents the handle to the controller object
  *    for which its interrupt coalesce register is overridden.
  * @coalesce_number: Used to control the number of entries in the Completion
  *    Queue before an interrupt is generated. If the number of entries exceed
@@ -2479,12 +2477,13 @@ struct isci_request *sci_request_by_tag(struct isci_host *ihost, u16 io_tag)
 }
 
 /**
+ * sci_controller_allocate_remote_node_context()
  * This method allocates remote node index and the reserves the remote node
  *    context space for use. This method can fail if there are no more remote
  *    node index available.
- * @scic: This is the controller object which contains the set of
+ * @ihost: This is the controller object which contains the set of
  *    free remote node ids
- * @sci_dev: This is the device object which is requesting the a remote node
+ * @idev: This is the device object which is requesting the a remote node
  *    id
  * @node_id: This is the remote node id that is assinged to the device if one
  *    is available
@@ -2709,11 +2708,11 @@ enum sci_status sci_controller_continue_io(struct isci_request *ireq)
 /**
  * sci_controller_start_task() - This method is called by the SCIC user to
  *    send/start a framework task management request.
- * @controller: the handle to the controller object for which to start the task
+ * @ihost: the handle to the controller object for which to start the task
  *    management request.
- * @remote_device: the handle to the remote device object for which to start
+ * @idev: the handle to the remote device object for which to start
  *    the task management request.
- * @task_request: the handle to the task request object to start.
+ * @ireq: the handle to the task request object to start.
  */
 enum sci_status sci_controller_start_task(struct isci_host *ihost,
 					  struct isci_remote_device *idev,
-- 
2.27.0

