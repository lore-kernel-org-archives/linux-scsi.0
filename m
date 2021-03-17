Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3257C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2DD964F37
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhCQJN6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhCQJN0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:26 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDF3C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:15 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e18so1004590wrt.6
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zjBaHIzTXXyZcZh/hf2ALRdddAT/JJaP6MXXLDQdjD4=;
        b=frmeAnhM5BxXjSAAx4w5jrrgvPMVg8We5PR8YNRtrjrjou/kpY0eN5VlPyUt1uMBwz
         5pgCukGPGRBr3JtgaRtGLTn5Dm/eRNxjiWR+3fyrGaOmB+7c+d8hWn/QZQC3nD2YPcip
         zcawozUVl6RKLbffmVFc8rn3WvIY/pWmUKIALM/4j6BC3nc9IfFL96cPz5dzB/Q44aig
         Je7wqAWY+rkVoE0f38VC/07pxs8smswPJAvo/2Xob6wyxaeMM5fBDq7eeWpWpmwIdeVk
         ec/7dJzxwW5XhSiUD4ReJc1xd/DG9Ze8uisLDncjEZt+ZQbbQ8pUuS4TAHr3zLhA8nUg
         mQjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zjBaHIzTXXyZcZh/hf2ALRdddAT/JJaP6MXXLDQdjD4=;
        b=jUOzxxjzQlZHemmO0s2qoErvfSsstJU+lvLd4PZBh+i/rcQWH7XW/07mP2yHyFEAqX
         keQcK2QcqjDYLNhM5NChR0Rs0w9HZBGxSX3/1nGcp4AFJlp/x79WBfNPDmWCfuWOrViP
         ldQduZIGx15uIK8WUSqZmxj5ZXqmaE/XiXN+Hxi80cCRzpVGsq2jGkoyR+QXAM0mgBws
         mxKeb58xDsKa+WZQWzeZuNP756lXzd1BjhfVXohuCrUbNPGHznQm5zArWnbuh1hF7cnW
         uITsebiHpz5hmgRtlEv81dpGQ6gOvl7ha1HE/wRvrnx5zXECKusf931FXlQDG9rESFLR
         LY6A==
X-Gm-Message-State: AOAM5317tJtpCWpr8a9EC3cVUvLpqHD67Xy20B05CdU/zcTWTzTb/NAC
        IZpzgmDIFzrKlKpYVuDcP8Dh9Q==
X-Google-Smtp-Source: ABdhPJxd2Igfnc0ZThXmRgnk6il2w5yk2KnyRALWuqCYxKTzjp9t0UMVPqDP7EJ1pMn5YEfJL7tisw==
X-Received: by 2002:a5d:6c67:: with SMTP id r7mr1165491wrz.373.1615972394340;
        Wed, 17 Mar 2021 02:13:14 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 34/36] scsi: ibmvscsi: ibmvfc: Fix a bunch of misdocumentation
Date:   Wed, 17 Mar 2021 09:12:28 +0000
Message-Id: <20210317091230.2912389-35-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/ibmvscsi/ibmvfc.c:331: warning: Function parameter or member 'vhost' not described in 'ibmvfc_get_err_result'
 drivers/scsi/ibmvscsi/ibmvfc.c:653: warning: Excess function parameter 'job_step' description in 'ibmvfc_del_tgt'
 drivers/scsi/ibmvscsi/ibmvfc.c:773: warning: Function parameter or member 'queue' not described in 'ibmvfc_init_event_pool'
 drivers/scsi/ibmvscsi/ibmvfc.c:773: warning: Function parameter or member 'size' not described in 'ibmvfc_init_event_pool'
 drivers/scsi/ibmvscsi/ibmvfc.c:823: warning: Function parameter or member 'queue' not described in 'ibmvfc_free_event_pool'
 drivers/scsi/ibmvscsi/ibmvfc.c:1413: warning: Function parameter or member 'vhost' not described in 'ibmvfc_gather_partition_info'
 drivers/scsi/ibmvscsi/ibmvfc.c:1483: warning: Function parameter or member 'queue' not described in 'ibmvfc_get_event'
 drivers/scsi/ibmvscsi/ibmvfc.c:1483: warning: Excess function parameter 'vhost' description in 'ibmvfc_get_event'
 drivers/scsi/ibmvscsi/ibmvfc.c:1630: warning: Function parameter or member 't' not described in 'ibmvfc_timeout'
 drivers/scsi/ibmvscsi/ibmvfc.c:1630: warning: Excess function parameter 'evt' description in 'ibmvfc_timeout'
 drivers/scsi/ibmvscsi/ibmvfc.c:1893: warning: Function parameter or member 'shost' not described in 'ibmvfc_queuecommand'
 drivers/scsi/ibmvscsi/ibmvfc.c:1893: warning: Excess function parameter 'done' description in 'ibmvfc_queuecommand'
 drivers/scsi/ibmvscsi/ibmvfc.c:2324: warning: Function parameter or member 'rport' not described in 'ibmvfc_match_rport'
 drivers/scsi/ibmvscsi/ibmvfc.c:2324: warning: Excess function parameter 'device' description in 'ibmvfc_match_rport'
 drivers/scsi/ibmvscsi/ibmvfc.c:3133: warning: Function parameter or member 'evt_doneq' not described in 'ibmvfc_handle_crq'
 drivers/scsi/ibmvscsi/ibmvfc.c:3317: warning: Excess function parameter 'reason' description in 'ibmvfc_change_queue_depth'
 drivers/scsi/ibmvscsi/ibmvfc.c:3390: warning: Function parameter or member 'attr' not described in 'ibmvfc_show_log_level'
 drivers/scsi/ibmvscsi/ibmvfc.c:3413: warning: Function parameter or member 'attr' not described in 'ibmvfc_store_log_level'
 drivers/scsi/ibmvscsi/ibmvfc.c:3413: warning: Function parameter or member 'count' not described in 'ibmvfc_store_log_level'
 drivers/scsi/ibmvscsi/ibmvfc.c:4121: warning: Function parameter or member 'done' not described in '__ibmvfc_tgt_get_implicit_logout_evt'
 drivers/scsi/ibmvscsi/ibmvfc.c:4438: warning: Function parameter or member 't' not described in 'ibmvfc_adisc_timeout'
 drivers/scsi/ibmvscsi/ibmvfc.c:4438: warning: Excess function parameter 'tgt' description in 'ibmvfc_adisc_timeout'
 drivers/scsi/ibmvscsi/ibmvfc.c:4641: warning: Function parameter or member 'target' not described in 'ibmvfc_alloc_target'
 drivers/scsi/ibmvscsi/ibmvfc.c:4641: warning: Excess function parameter 'scsi_id' description in 'ibmvfc_alloc_target'
 drivers/scsi/ibmvscsi/ibmvfc.c:5068: warning: Function parameter or member 'evt' not described in 'ibmvfc_npiv_logout_done'
 drivers/scsi/ibmvscsi/ibmvfc.c:5068: warning: Excess function parameter 'vhost' description in 'ibmvfc_npiv_logout_done'

Cc: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a38d9d5d90ba3..a7a9b647ea178 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -326,6 +326,7 @@ static const char *ibmvfc_get_cmd_error(u16 status, u16 error)
 
 /**
  * ibmvfc_get_err_result - Find the scsi status to return for the fcp response
+ * @vhost:      ibmvfc host struct
  * @vfc_cmd:	ibmvfc command struct
  *
  * Return value:
@@ -650,8 +651,6 @@ static void ibmvfc_reinit_host(struct ibmvfc_host *vhost)
 /**
  * ibmvfc_del_tgt - Schedule cleanup and removal of the target
  * @tgt:		ibmvfc target struct
- * @job_step:	job step to perform
- *
  **/
 static void ibmvfc_del_tgt(struct ibmvfc_target *tgt)
 {
@@ -768,6 +767,8 @@ static int ibmvfc_send_crq_init_complete(struct ibmvfc_host *vhost)
 /**
  * ibmvfc_init_event_pool - Allocates and initializes the event pool for a host
  * @vhost:	ibmvfc host who owns the event pool
+ * @queue:      ibmvfc queue struct
+ * @size:       pool size
  *
  * Returns zero on success.
  **/
@@ -820,6 +821,7 @@ static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
 /**
  * ibmvfc_free_event_pool - Frees memory of the event pool of a host
  * @vhost:	ibmvfc host who owns the event pool
+ * @queue:      ibmvfc queue struct
  *
  **/
 static void ibmvfc_free_event_pool(struct ibmvfc_host *vhost,
@@ -1414,6 +1416,7 @@ static int ibmvfc_issue_fc_host_lip(struct Scsi_Host *shost)
 
 /**
  * ibmvfc_gather_partition_info - Gather info about the LPAR
+ * @vhost:      ibmvfc host struct
  *
  * Return value:
  *	none
@@ -1484,7 +1487,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 
 /**
  * ibmvfc_get_event - Gets the next free event in pool
- * @vhost:	ibmvfc host struct
+ * @queue:      ibmvfc queue struct
  *
  * Returns a free event from the pool.
  **/
@@ -1631,7 +1634,7 @@ static int ibmvfc_map_sg_data(struct scsi_cmnd *scmd,
 
 /**
  * ibmvfc_timeout - Internal command timeout handler
- * @evt:	struct ibmvfc_event that timed out
+ * @t:	struct ibmvfc_event that timed out
  *
  * Called when an internally generated command times out
  **/
@@ -1892,8 +1895,8 @@ static struct ibmvfc_cmd *ibmvfc_init_vfc_cmd(struct ibmvfc_event *evt, struct s
 
 /**
  * ibmvfc_queuecommand - The queuecommand function of the scsi template
+ * @shost:	scsi host struct
  * @cmnd:	struct scsi_cmnd to be executed
- * @done:	Callback function to be called when cmnd is completed
  *
  * Returns:
  *	0 on success / other on failure
@@ -2324,7 +2327,7 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 /**
  * ibmvfc_match_rport - Match function for specified remote port
  * @evt:	ibmvfc event struct
- * @device:	device to match (rport)
+ * @rport:	device to match
  *
  * Returns:
  *	1 if event matches rport / 0 if event does not match rport
@@ -3135,8 +3138,9 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
  * ibmvfc_handle_crq - Handles and frees received events in the CRQ
  * @crq:	Command/Response queue
  * @vhost:	ibmvfc host struct
+ * @evt_doneq:	Event done queue
  *
- **/
+**/
 static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
 			      struct list_head *evt_doneq)
 {
@@ -3317,7 +3321,6 @@ static int ibmvfc_slave_configure(struct scsi_device *sdev)
  * ibmvfc_change_queue_depth - Change the device's queue depth
  * @sdev:	scsi device struct
  * @qdepth:	depth to set
- * @reason:	calling context
  *
  * Return value:
  * 	actual depth set
@@ -3389,6 +3392,7 @@ static ssize_t ibmvfc_show_host_capabilities(struct device *dev,
 /**
  * ibmvfc_show_log_level - Show the adapter's error logging level
  * @dev:	class device struct
+ * @attr:	unused
  * @buf:	buffer
  *
  * Return value:
@@ -3411,7 +3415,9 @@ static ssize_t ibmvfc_show_log_level(struct device *dev,
 /**
  * ibmvfc_store_log_level - Change the adapter's error logging level
  * @dev:	class device struct
+ * @attr:	unused
  * @buf:	buffer
+ * @count:      buffer size
  *
  * Return value:
  * 	number of bytes printed to buffer
@@ -4121,6 +4127,7 @@ static void ibmvfc_tgt_implicit_logout_done(struct ibmvfc_event *evt)
 /**
  * __ibmvfc_tgt_get_implicit_logout_evt - Allocate and init an event for implicit logout
  * @tgt:		ibmvfc target struct
+ * @done:		Routine to call when the event is responded to
  *
  * Returns:
  *	Allocated and initialized ibmvfc_event struct
@@ -4437,7 +4444,7 @@ static void ibmvfc_tgt_adisc_cancel_done(struct ibmvfc_event *evt)
 
 /**
  * ibmvfc_adisc_timeout - Handle an ADISC timeout
- * @tgt:		ibmvfc target struct
+ * @t:		ibmvfc target struct
  *
  * If an ADISC times out, send a cancel. If the cancel times
  * out, reset the CRQ. When the ADISC comes back as cancelled,
@@ -4640,7 +4647,7 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_target *tgt)
 /**
  * ibmvfc_alloc_target - Allocate and initialize an ibmvfc target
  * @vhost:		ibmvfc host struct
- * @scsi_id:	SCSI ID to allocate target for
+ * @target:		Holds SCSI ID to allocate target forand the WWPN
  *
  * Returns:
  *	0 on success / other on failure
@@ -5070,7 +5077,7 @@ static void ibmvfc_npiv_login(struct ibmvfc_host *vhost)
 
 /**
  * ibmvfc_npiv_logout_done - Completion handler for NPIV Logout
- * @vhost:		ibmvfc host struct
+ * @evt:		ibmvfc event struct
  *
  **/
 static void ibmvfc_npiv_logout_done(struct ibmvfc_event *evt)
-- 
2.27.0

