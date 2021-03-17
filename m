Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC27C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5645E64F37
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCQJNc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhCQJNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:02 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12465C061764
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:02 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so2955035wml.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DMv+vXcSwpokLRSaKZQvY2+l2E4jS8n/6HqcIh5ruyI=;
        b=wo/qe93wBkC8iHvSIg0ts3AjRIPH2+ru2o7fmIn2C8rMRuCJkQJ6aNDsuC7VLig04M
         C3/W365haDaXefPY2bnghnTyfDDBQt8fqwdrGAdJBzdxo7I36IeO/PS1OstnxYuW0rvX
         qHF3Wl9tKqGJFt4QpovgqaUtpK0C3Lfsr7lgSKeSPzs71nx5EiHz8EeNYVSSU4zs0iMt
         WSBpGo5rwU3M3LL/rwG1OqqGZMSi/qfkJUxAwfK8/56nh/jfnrn+spORrb7YUPeEWLjL
         ek3zFEB0SnTF3CjNmjlcO4cB7MZ3v9IJfz6x1+vD0nvY5OnayOxiNlAxcPvxga9hyoj5
         fuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DMv+vXcSwpokLRSaKZQvY2+l2E4jS8n/6HqcIh5ruyI=;
        b=a4BRUVyTT0dCNY05N0umPSuoIX75isHpR/Tq7MHUosyH+HazJKQ8OMfI2ghpbIk+Aq
         RqWLAcxKRNm3EdTDg6bsLyvcf2CI+AL0kkT0yIblmPU1lbgkyAWxNH3705Wg7OiKwfWQ
         YindcPdE4WAmq4xi6WIN2X9YDbaJWfhJCRoWfKfkRjM25nWbjtb/XZKBV83M2TxWxziR
         BIMkIMenir9KaIIpGgUGRt7GrHyvMtU9Yw0Efyh1s/3Sqo+hdAq7jYD/Gp2bsKHN4/JY
         QBus0HMsVQ8Yu8x17OK6tCAob7inpS0Xhp6d+H283mnNbv7hFp+UwJTm/o/zRWLQ/q7S
         wX8A==
X-Gm-Message-State: AOAM530YyzffCnQ2GMjLTl2/8boGk0IJcODui48GAq6vTT1LtGi0Tooy
        GZR2jfEzxdQ2o/bZDloLJI4agw==
X-Google-Smtp-Source: ABdhPJxIC+T1p6K66HOpBrk/7geC5D7oU5/QFHAIGwOUWZBc4LU8zciNqqq+rLZ4m5n4zibsiKKuGQ==
X-Received: by 2002:a1c:bc56:: with SMTP id m83mr2728457wmf.174.1615972380728;
        Wed, 17 Mar 2021 02:13:00 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:00 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 20/36] scsi: isci: request: Fix a myriad of kernel-doc issues
Date:   Wed, 17 Mar 2021 09:12:14 +0000
Message-Id: <20210317091230.2912389-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/request.c:211: warning: wrong kernel-doc identifier on line:
 drivers/scsi/isci/request.c:414: warning: wrong kernel-doc identifier on line:
 drivers/scsi/isci/request.c:472: warning: Function parameter or member 'ireq' not described in 'scu_ssp_task_request_construct_task_context'
 drivers/scsi/isci/request.c:472: warning: expecting prototype for The(). Prototype was for scu_ssp_task_request_construct_task_context() instead
 drivers/scsi/isci/request.c:501: warning: Function parameter or member 'ireq' not described in 'scu_sata_request_construct_task_context'
 drivers/scsi/isci/request.c:501: warning: expecting prototype for This method is will fill in the SCU Task Context for any type of SATA(). Prototype was for scu_sata_request_construct_task_context() instead
 drivers/scsi/isci/request.c:597: warning: Cannot understand  *
 drivers/scsi/isci/request.c:785: warning: expecting prototype for sci_req_tx_bytes(). Prototype was for SCU_TASK_CONTEXT_SRAM() instead
 drivers/scsi/isci/request.c:1399: warning: Cannot understand  *
 drivers/scsi/isci/request.c:1446: warning: Cannot understand  *
 drivers/scsi/isci/request.c:2465: warning: Function parameter or member 'task' not described in 'isci_request_process_response_iu'
 drivers/scsi/isci/request.c:2465: warning: Excess function parameter 'sas_task' description in 'isci_request_process_response_iu'
 drivers/scsi/isci/request.c:2501: warning: Function parameter or member 'task' not described in 'isci_request_set_open_reject_status'
 drivers/scsi/isci/request.c:2524: warning: Function parameter or member 'idev' not described in 'isci_request_handle_controller_specific_errors'
 drivers/scsi/isci/request.c:2524: warning: Function parameter or member 'task' not described in 'isci_request_handle_controller_specific_errors'
 drivers/scsi/isci/request.c:3337: warning: Function parameter or member 'idev' not described in 'isci_io_request_build'
 drivers/scsi/isci/request.c:3337: warning: Excess function parameter 'sci_device' description in 'isci_io_request_build'

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/request.c | 58 ++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 58e62162882f2..49ab2555c0cdf 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -207,11 +207,8 @@ static void sci_task_request_build_ssp_task_iu(struct isci_request *ireq)
 		SCI_CONTROLLER_INVALID_IO_TAG;
 }
 
-/**
+/*
  * This method is will fill in the SCU Task Context for any type of SSP request.
- * @sci_req:
- * @task_context:
- *
  */
 static void scu_ssp_request_construct_task_context(
 	struct isci_request *ireq,
@@ -410,10 +407,8 @@ static void scu_ssp_ireq_dif_strip(struct isci_request *ireq, u8 type, u8 op)
 	tc->ref_tag_seed_gen = 0;
 }
 
-/**
+/*
  * This method is will fill in the SCU Task Context for a SSP IO request.
- * @sci_req:
- *
  */
 static void scu_ssp_io_request_construct_task_context(struct isci_request *ireq,
 						      enum dma_data_direction dir,
@@ -456,17 +451,16 @@ static void scu_ssp_io_request_construct_task_context(struct isci_request *ireq,
 }
 
 /**
- * This method will fill in the SCU Task Context for a SSP Task request.  The
- *    following important settings are utilized: -# priority ==
- *    SCU_TASK_PRIORITY_HIGH.  This ensures that the task request is issued
- *    ahead of other task destined for the same Remote Node. -# task_type ==
- *    SCU_TASK_TYPE_IOREAD.  This simply indicates that a normal request type
- *    (i.e. non-raw frame) is being utilized to perform task management. -#
- *    control_frame == 1.  This ensures that the proper endianess is set so
- *    that the bytes are transmitted in the right order for a task frame.
- * @sci_req: This parameter specifies the task request object being
- *    constructed.
- *
+ * scu_ssp_task_request_construct_task_context() - This method will fill in
+ *    the SCU Task Context for a SSP Task request.  The following important
+ *    settings are utilized: -# priority == SCU_TASK_PRIORITY_HIGH.  This
+ *    ensures that the task request is issued ahead of other task destined
+ *    for the same Remote Node. -# task_type == SCU_TASK_TYPE_IOREAD.  This
+ *    simply indicates that a normal request type (i.e. non-raw frame) is
+ *    being utilized to perform task management. -#control_frame == 1.  This
+ *    ensures that the proper endianess is set so that the bytes are
+ *    transmitted in the right order for a task frame.
+ * @ireq: This parameter specifies the task request object being constructed.
  */
 static void scu_ssp_task_request_construct_task_context(struct isci_request *ireq)
 {
@@ -484,6 +478,7 @@ static void scu_ssp_task_request_construct_task_context(struct isci_request *ire
 }
 
 /**
+ * scu_sata_request_construct_task_context()
  * This method is will fill in the SCU Task Context for any type of SATA
  *    request.  This is called from the various SATA constructors.
  * @sci_req: The general IO request object which is to be used in
@@ -593,9 +588,9 @@ static enum sci_status sci_stp_pio_request_construct(struct isci_request *ireq,
 	return SCI_SUCCESS;
 }
 
-/**
- *
- * @sci_req: This parameter specifies the request to be constructed as an
+/*
+ * sci_stp_optimized_request_construct()
+ * @ireq: This parameter specifies the request to be constructed as an
  *    optimized request.
  * @optimized_task_type: This parameter specifies whether the request is to be
  *    an UDMA request or a NCQ request. - A value of 0 indicates UDMA. - A
@@ -778,11 +773,11 @@ static enum sci_status sci_io_request_construct_basic_sata(struct isci_request *
 	return status;
 }
 
+#define SCU_TASK_CONTEXT_SRAM 0x200000
 /**
  * sci_req_tx_bytes - bytes transferred when reply underruns request
  * @ireq: request that was terminated early
  */
-#define SCU_TASK_CONTEXT_SRAM 0x200000
 static u32 sci_req_tx_bytes(struct isci_request *ireq)
 {
 	struct isci_host *ihost = ireq->owning_controller;
@@ -1396,10 +1391,10 @@ static enum sci_status sci_stp_request_pio_data_out_transmit_data(struct isci_re
 }
 
 /**
- *
- * @stp_request: The request that is used for the SGL processing.
- * @data_buffer: The buffer of data to be copied.
- * @length: The length of the data transfer.
+ * sci_stp_request_pio_data_in_copy_data_buffer()
+ * @stp_req: The request that is used for the SGL processing.
+ * @data_buf: The buffer of data to be copied.
+ * @len: The length of the data transfer.
  *
  * Copy the data from the buffer for the length specified to the IO request SGL
  * specified data region. enum sci_status
@@ -1443,8 +1438,8 @@ sci_stp_request_pio_data_in_copy_data_buffer(struct isci_stp_request *stp_req,
 }
 
 /**
- *
- * @sci_req: The PIO DATA IN request that is to receive the data.
+ * sci_stp_request_pio_data_in_copy_data()
+ * @stp_req: The PIO DATA IN request that is to receive the data.
  * @data_buffer: The buffer to copy from.
  *
  * Copy the data buffer to the io request data region. enum sci_status
@@ -2452,7 +2447,7 @@ sci_io_request_tc_completion(struct isci_request *ireq,
  * isci_request_process_response_iu() - This function sets the status and
  *    response iu, in the task struct, from the request object for the upper
  *    layer driver.
- * @sas_task: This parameter is the task struct from the upper layer driver.
+ * @task: This parameter is the task struct from the upper layer driver.
  * @resp_iu: This parameter points to the response iu of the completed request.
  * @dev: This parameter specifies the linux device struct.
  *
@@ -2485,6 +2480,7 @@ static void isci_request_process_response_iu(
  * isci_request_set_open_reject_status() - This function prepares the I/O
  *    completion for OPEN_REJECT conditions.
  * @request: This parameter is the completed isci_request object.
+ * @task: This parameter is the task struct from the upper layer driver.
  * @response_ptr: This parameter specifies the service response for the I/O.
  * @status_ptr: This parameter specifies the exec status for the I/O.
  * @open_rej_reason: This parameter specifies the encoded reason for the
@@ -2509,7 +2505,9 @@ static void isci_request_set_open_reject_status(
 /**
  * isci_request_handle_controller_specific_errors() - This function decodes
  *    controller-specific I/O completion error conditions.
+ * @idev: Remote device
  * @request: This parameter is the completed isci_request object.
+ * @task: This parameter is the task struct from the upper layer driver.
  * @response_ptr: This parameter specifies the service response for the I/O.
  * @status_ptr: This parameter specifies the exec status for the I/O.
  *
@@ -3326,7 +3324,7 @@ static enum sci_status isci_smp_request_build(struct isci_request *ireq)
  * @ihost: This parameter specifies the ISCI host object
  * @request: This parameter points to the isci_request object allocated in the
  *    request construct function.
- * @sci_device: This parameter is the handle for the sci core's remote device
+ * @idev: This parameter is the handle for the sci core's remote device
  *    object that is the destination for this request.
  *
  * SCI_SUCCESS on successfull completion, or specific failure code.
-- 
2.27.0

