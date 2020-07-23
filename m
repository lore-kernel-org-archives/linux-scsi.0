Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114D8C433F1
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEEC0206D7
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L4NPiGsA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgGWM0Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgGWMZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:25 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A41DC0619E4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:25 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id c80so4795971wme.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AaZgBLVOS7q2pS/xZr9TUPVbAiWNyUa8nia5ipOZ1l8=;
        b=L4NPiGsAWDTD1nsJw/ag6ubha3NoEhKHTIsoQP9Z6ez8vCP9hdKkeHZfTo9OPSeI1b
         G77NktUZ2uR8mccWrmbf8raSXWOxfOG3fg82j+h1WEeIUjGuCEPt8foKFctz/SkQTXXB
         YDkLkSVNCK3Sp3t4bnlYPFtHwDrpXQ7P1oc2cfkpTXraoJothR1jEZNHpil1slPo4G98
         oRohUZQWfvPlnz/FwZLgwcsJk8oOV6zFZ7m29xPr5tKu9+B4uE0LnTnw8fgWX11TZbmf
         DPrqNnQ9CF7m4gyy2xOAsZbVlpBqrySWbrqqf6VC83tCKlnwv7X7IEZJDpfOGqjKEk9T
         4pSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AaZgBLVOS7q2pS/xZr9TUPVbAiWNyUa8nia5ipOZ1l8=;
        b=Kw2h4G+pWsLlgGnMiX5vRMtuHPPhNBIPvqEhH8PrJlXIpd4Rtckq0eMTyNGT51wreC
         zKKbTeqZPkjfAOFNQ/tchZXb+iQMjehV+KziHLJCze68H7RZUGrgoR7KeAH5bWnLPZuw
         asRdWTiPx/cnsaZRRHempc8z0PF/XeMq0DEVcHuiqvyxuOEPSCTNHAme2AoLFDLarbIn
         FEju5b/MYyh83UtWgmeoMHmcNq3Yurf/+exljtNjLC/gp0n3uSKai9DJkiAqqpwa3qWi
         va4UOCoSqymCs65JNYCcUsuWF39LmMXrIsjxB2xlBfbMTYm3TEkVvhK+IkQ3mijqQj2k
         jNHw==
X-Gm-Message-State: AOAM532i5C4osuQ3t/OhcjliaGDEU9M/8s7R65bMGDyKviQoHIBsk47+
        vfoqfzKWqmxxb9m7h54PLde67A==
X-Google-Smtp-Source: ABdhPJyDuBDumRaByCmjSjCph47AToEM6UBkDJ1LMumMb1DZXuohHZ+MbmLdxN0BJoLL3vWs8XrORA==
X-Received: by 2002:a1c:a757:: with SMTP id q84mr1701761wme.1.1595507124038;
        Thu, 23 Jul 2020 05:25:24 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:23 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Anil Veerabhadrappa <anilgv@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>
Subject: [PATCH 28/40] scsi: bnx2i: bnx2i_hwi: Fix a whole host of kerneldoc issues
Date:   Thu, 23 Jul 2020 13:24:34 +0100
Message-Id: <20200723122446.1329773-29-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Mainly renames and docrot issues.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bnx2i/bnx2i_hwi.c:194: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_get_rq_buf'
 drivers/scsi/bnx2i/bnx2i_hwi.c:194: warning: Excess function parameter 'conn' description in 'bnx2i_get_rq_buf'
 drivers/scsi/bnx2i/bnx2i_hwi.c:232: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_put_rq_buf'
 drivers/scsi/bnx2i/bnx2i_hwi.c:232: warning: Excess function parameter 'conn' description in 'bnx2i_put_rq_buf'
 drivers/scsi/bnx2i/bnx2i_hwi.c:269: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_ring_sq_dbell'
 drivers/scsi/bnx2i/bnx2i_hwi.c:269: warning: Excess function parameter 'conn' description in 'bnx2i_ring_sq_dbell'
 drivers/scsi/bnx2i/bnx2i_hwi.c:293: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_ring_dbell_update_sq_params'
 drivers/scsi/bnx2i/bnx2i_hwi.c:293: warning: Excess function parameter 'conn' description in 'bnx2i_ring_dbell_update_sq_params'
 drivers/scsi/bnx2i/bnx2i_hwi.c:331: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_send_iscsi_login'
 drivers/scsi/bnx2i/bnx2i_hwi.c:331: warning: Function parameter or member 'task' not described in 'bnx2i_send_iscsi_login'
 drivers/scsi/bnx2i/bnx2i_hwi.c:331: warning: Excess function parameter 'conn' description in 'bnx2i_send_iscsi_login'
 drivers/scsi/bnx2i/bnx2i_hwi.c:331: warning: Excess function parameter 'cmd' description in 'bnx2i_send_iscsi_login'
 drivers/scsi/bnx2i/bnx2i_hwi.c:384: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_send_iscsi_tmf'
 drivers/scsi/bnx2i/bnx2i_hwi.c:384: warning: Excess function parameter 'conn' description in 'bnx2i_send_iscsi_tmf'
 drivers/scsi/bnx2i/bnx2i_hwi.c:458: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_send_iscsi_text'
 drivers/scsi/bnx2i/bnx2i_hwi.c:458: warning: Excess function parameter 'conn' description in 'bnx2i_send_iscsi_text'
 drivers/scsi/bnx2i/bnx2i_hwi.c:506: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_send_iscsi_scsicmd'
 drivers/scsi/bnx2i/bnx2i_hwi.c:506: warning: Excess function parameter 'conn' description in 'bnx2i_send_iscsi_scsicmd'
 drivers/scsi/bnx2i/bnx2i_hwi.c:533: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_send_iscsi_nopout'
 drivers/scsi/bnx2i/bnx2i_hwi.c:533: warning: Function parameter or member 'task' not described in 'bnx2i_send_iscsi_nopout'
 drivers/scsi/bnx2i/bnx2i_hwi.c:533: warning: Excess function parameter 'conn' description in 'bnx2i_send_iscsi_nopout'
 drivers/scsi/bnx2i/bnx2i_hwi.c:533: warning: Excess function parameter 'cmd' description in 'bnx2i_send_iscsi_nopout'
 drivers/scsi/bnx2i/bnx2i_hwi.c:590: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_send_iscsi_logout'
 drivers/scsi/bnx2i/bnx2i_hwi.c:590: warning: Function parameter or member 'task' not described in 'bnx2i_send_iscsi_logout'
 drivers/scsi/bnx2i/bnx2i_hwi.c:590: warning: Excess function parameter 'conn' description in 'bnx2i_send_iscsi_logout'
 drivers/scsi/bnx2i/bnx2i_hwi.c:590: warning: Excess function parameter 'cmd' description in 'bnx2i_send_iscsi_logout'
 drivers/scsi/bnx2i/bnx2i_hwi.c:686: warning: Function parameter or member 't' not described in 'bnx2i_ep_ofld_timer'
 drivers/scsi/bnx2i/bnx2i_hwi.c:686: warning: Excess function parameter 'data' description in 'bnx2i_ep_ofld_timer'
 drivers/scsi/bnx2i/bnx2i_hwi.c:1672: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_unsol_pdu_adjust_rq'
 drivers/scsi/bnx2i/bnx2i_hwi.c:1672: warning: Excess function parameter 'conn' description in 'bnx2i_unsol_pdu_adjust_rq'
 drivers/scsi/bnx2i/bnx2i_hwi.c:1900: warning: Function parameter or member 'session' not described in 'bnx2i_queue_scsi_cmd_resp'
 drivers/scsi/bnx2i/bnx2i_hwi.c:1900: warning: Function parameter or member 'cqe' not described in 'bnx2i_queue_scsi_cmd_resp'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2476: warning: Function parameter or member 'context' not described in 'bnx2i_indicate_kcqe'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2476: warning: Function parameter or member 'kcqe' not described in 'bnx2i_indicate_kcqe'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2476: warning: Function parameter or member 'num_cqe' not described in 'bnx2i_indicate_kcqe'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2476: warning: Excess function parameter 'hba' description in 'bnx2i_indicate_kcqe'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2476: warning: Excess function parameter 'update_kcqe' description in 'bnx2i_indicate_kcqe'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2624: warning: Function parameter or member 'cm_sk' not described in 'bnx2i_cm_remote_close'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2624: warning: Excess function parameter 'hba' description in 'bnx2i_cm_remote_close'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2624: warning: Excess function parameter 'update_kcqe' description in 'bnx2i_cm_remote_close'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2641: warning: Function parameter or member 'cm_sk' not described in 'bnx2i_cm_remote_abort'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2641: warning: Excess function parameter 'hba' description in 'bnx2i_cm_remote_abort'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2641: warning: Excess function parameter 'update_kcqe' description in 'bnx2i_cm_remote_abort'
 drivers/scsi/bnx2i/bnx2i_hwi.c:2677: warning: cannot understand function prototype: 'struct cnic_ulp_ops bnx2i_cnic_cb = '

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 53 +++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index e53ebc5eff85e..bad396e5c6014 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -181,7 +181,7 @@ int bnx2i_arm_cq_event_coalescing(struct bnx2i_endpoint *ep, u8 action)
 
 /**
  * bnx2i_get_rq_buf - copy RQ buffer contents to driver buffer
- * @conn:		iscsi connection on which RQ event occurred
+ * @bnx2i_conn:		iscsi connection on which RQ event occurred
  * @ptr:		driver buffer to which RQ buffer contents is to
  *			be copied
  * @len:		length of valid data inside RQ buf
@@ -223,7 +223,7 @@ static void bnx2i_ring_577xx_doorbell(struct bnx2i_conn *conn)
 
 /**
  * bnx2i_put_rq_buf - Replenish RQ buffer, if required ring on chip doorbell
- * @conn:	iscsi connection on which event to post
+ * @bnx2i_conn:	iscsi connection on which event to post
  * @count:	number of RQ buffer being posted to chip
  *
  * No need to ring hardware doorbell for 57710 family of devices
@@ -258,7 +258,7 @@ void bnx2i_put_rq_buf(struct bnx2i_conn *bnx2i_conn, int count)
 
 /**
  * bnx2i_ring_sq_dbell - Ring SQ doorbell to wake-up the processing engine
- * @conn: 		iscsi connection to which new SQ entries belong
+ * @bnx2i_conn:		iscsi connection to which new SQ entries belong
  * @count: 		number of SQ WQEs to post
  *
  * SQ DB is updated in host memory and TX Doorbell is rung for 57710 family
@@ -283,7 +283,7 @@ static void bnx2i_ring_sq_dbell(struct bnx2i_conn *bnx2i_conn, int count)
 
 /**
  * bnx2i_ring_dbell_update_sq_params - update SQ driver parameters
- * @conn:	iscsi connection to which new SQ entries belong
+ * @bnx2i_conn:	iscsi connection to which new SQ entries belong
  * @count:	number of SQ WQEs to post
  *
  * this routine will update SQ driver parameters and ring the doorbell
@@ -320,9 +320,9 @@ static void bnx2i_ring_dbell_update_sq_params(struct bnx2i_conn *bnx2i_conn,
 
 /**
  * bnx2i_send_iscsi_login - post iSCSI login request MP WQE to hardware
- * @conn:	iscsi connection
- * @cmd:	driver command structure which is requesting
- *		a WQE to sent to chip for further processing
+ * @bnx2i_conn:	iscsi connection
+ * @task: transport layer's command structure pointer which is requesting
+ *	  a WQE to sent to chip for further processing
  *
  * prepare and post an iSCSI Login request WQE to CNIC firmware
  */
@@ -373,7 +373,7 @@ int bnx2i_send_iscsi_login(struct bnx2i_conn *bnx2i_conn,
 
 /**
  * bnx2i_send_iscsi_tmf - post iSCSI task management request MP WQE to hardware
- * @conn:	iscsi connection
+ * @bnx2i_conn:	iscsi connection
  * @mtask:	driver command structure which is requesting
  *		a WQE to sent to chip for further processing
  *
@@ -447,7 +447,7 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 
 /**
  * bnx2i_send_iscsi_text - post iSCSI text WQE to hardware
- * @conn:	iscsi connection
+ * @bnx2i_conn:	iscsi connection
  * @mtask:	driver command structure which is requesting
  *		a WQE to sent to chip for further processing
  *
@@ -495,7 +495,7 @@ int bnx2i_send_iscsi_text(struct bnx2i_conn *bnx2i_conn,
 
 /**
  * bnx2i_send_iscsi_scsicmd - post iSCSI scsicmd request WQE to hardware
- * @conn:	iscsi connection
+ * @bnx2i_conn:	iscsi connection
  * @cmd:	driver command structure which is requesting
  *		a WQE to sent to chip for further processing
  *
@@ -517,9 +517,9 @@ int bnx2i_send_iscsi_scsicmd(struct bnx2i_conn *bnx2i_conn,
 
 /**
  * bnx2i_send_iscsi_nopout - post iSCSI NOPOUT request WQE to hardware
- * @conn:		iscsi connection
- * @cmd:		driver command structure which is requesting
- *			a WQE to sent to chip for further processing
+ * @bnx2i_conn:		iscsi connection
+ * @task:		transport layer's command structure pointer which is
+ *                      requesting a WQE to sent to chip for further processing
  * @datap:		payload buffer pointer
  * @data_len:		payload data length
  * @unsol:		indicated whether nopout pdu is unsolicited pdu or
@@ -579,9 +579,9 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 
 /**
  * bnx2i_send_iscsi_logout - post iSCSI logout request WQE to hardware
- * @conn:	iscsi connection
- * @cmd:	driver command structure which is requesting
- *		a WQE to sent to chip for further processing
+ * @bnx2i_conn:	iscsi connection
+ * @task:	transport layer's command structure pointer which is
+ *		requesting a WQE to sent to chip for further processing
  *
  * prepare and post logout request WQE to CNIC firmware
  */
@@ -678,7 +678,8 @@ void bnx2i_update_iscsi_conn(struct iscsi_conn *conn)
 
 /**
  * bnx2i_ep_ofld_timer - post iSCSI logout request WQE to hardware
- * @data:	endpoint (transport handle) structure pointer
+ * @t:	timer context used to fetch the endpoint (transport
+ *	handle) structure pointer
  *
  * routine to handle connection offload/destroy request timeout
  */
@@ -1662,7 +1663,7 @@ static void bnx2i_process_nopin_local_cmpl(struct iscsi_session *session,
 
 /**
  * bnx2i_unsol_pdu_adjust_rq - makes adjustments to RQ after unsol pdu is recvd
- * @conn:	iscsi connection
+ * @bnx2i_conn:	iscsi connection
  *
  * Firmware advances RQ producer index for every unsolicited PDU even if
  *	payload data length is '0'. This function makes corresponding
@@ -1885,7 +1886,9 @@ int bnx2i_percpu_io_thread(void *arg)
 
 /**
  * bnx2i_queue_scsi_cmd_resp - queue cmd completion to the percpu thread
+ * @session:		iscsi session
  * @bnx2i_conn:		bnx2i connection
+ * @cqe:		pointer to newly DMA'ed CQE entry for processing
  *
  * this function is called by generic KCQ handler to queue all pending cmd
  * completion CQEs
@@ -2466,8 +2469,9 @@ static void bnx2i_process_ofld_cmpl(struct bnx2i_hba *hba,
 
 /**
  * bnx2i_indicate_kcqe - process iscsi conn update completion KCQE
- * @hba:		adapter structure pointer
- * @update_kcqe:	kcqe pointer
+ * @context:		adapter structure pointer
+ * @kcqe:		kcqe pointer
+ * @num_cqe:		number of kcqes to process
  *
  * Generic KCQ event handler/dispatcher
  */
@@ -2614,8 +2618,7 @@ static void bnx2i_cm_abort_cmpl(struct cnic_sock *cm_sk)
 
 /**
  * bnx2i_cm_remote_close - process received TCP FIN
- * @hba:		adapter structure pointer
- * @update_kcqe:	kcqe pointer
+ * @cm_sk:	cnic sock structure pointer
  *
  * function callback exported via bnx2i - cnic driver interface to indicate
  *	async TCP events such as FIN
@@ -2631,8 +2634,7 @@ static void bnx2i_cm_remote_close(struct cnic_sock *cm_sk)
 
 /**
  * bnx2i_cm_remote_abort - process TCP RST and start conn cleanup
- * @hba:		adapter structure pointer
- * @update_kcqe:	kcqe pointer
+ * @cm_sk:	cnic sock structure pointer
  *
  * function callback exported via bnx2i - cnic driver interface to
  *	indicate async TCP events (RST) sent by the peer.
@@ -2669,10 +2671,9 @@ static int bnx2i_send_nl_mesg(void *context, u32 msg_type,
 }
 
 
-/**
+/*
  * bnx2i_cnic_cb - global template of bnx2i - cnic driver interface structure
  *			carrying callback function pointers
- *
  */
 struct cnic_ulp_ops bnx2i_cnic_cb = {
 	.cnic_init = bnx2i_ulp_init,
-- 
2.25.1

