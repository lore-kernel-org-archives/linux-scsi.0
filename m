Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4722C43332
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 970EF64F70
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhCLJsA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbhCLJrx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:47:53 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482E9C061761
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:53 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so15401199wml.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QZLmH1LS3dvFu0B5FfwUETpqGDJKxfDe2SvKPVD/Hhw=;
        b=MWTXK+6VXn0O2eVB/e4l+XXDBvETAJFvZIMxNL0LloSGain13IcVkP/CElZ5lqO1Nc
         SlW+PSSG6w1xXoVYu+XrvWfAFFMeyDIa3U2KCbNQTMMsqOMorzSTxligLKNj8/UlaBUb
         sUj7djB/F3UCje2Uj+KuAkldupzH7JinsFwmVe7H+eOmKNE1GNiqLS/XJKWOp0ZDdFmv
         X4HAWMMYQHwsFE9R4YWmKWPNFkfOtWkhG2Xc48Y8GW0ujL++BG7tZ7Oyt64SBF1QA3r4
         sU842jQwhH8RYAME4fNadhUfwJChJRa3zIG9S6GTkTpyG5LUqugtJcV5sazG1rupbzY0
         w7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QZLmH1LS3dvFu0B5FfwUETpqGDJKxfDe2SvKPVD/Hhw=;
        b=dYOHPUXjLkhPRLxz1MavYr2Pc+DjIGsy/1fRQkm92LNKsyl114iCZMpuy/evzX7vru
         01nlaoUYqpHaLxlpo7jKvHDBXePGtqYHkyKnJz0Vg4wN3P/YCJquU2JdkJnIWhX/agSJ
         GiBNa7haoicbmWmVsCbm5sBQc0CzzJGvWSz7O3MdUv3C8YpKNEFijEutTG1VWOI2EZPY
         bO4uypOkOqw9DQYB0fcsI1QDHbpsHgPj1prc9ED1/cFBoyWpt6i6DWJb1lQS9tv/idNM
         MhzxCk2z301cFkHdop2LdR88h+G78rFSBPCzkfrcrh6UYsk84Nv1edv4LrU52UQSO4BI
         8D+g==
X-Gm-Message-State: AOAM533Pdemy5mIpFHJXRzq7dJeJuASc7fXqS2wOec0VPaYpdY5ZC9gT
        ZQCE2KeM4MeLK4kL3FoJvLY9EA==
X-Google-Smtp-Source: ABdhPJwMXc1Mh4ZmwJ6pzzlAFZJucA91pXmFg8AMtYupOUOt6P+cF4qOMaacj2jZraMimgYrg1puxA==
X-Received: by 2002:a1c:7916:: with SMTP id l22mr11999576wme.86.1615542472003;
        Fri, 12 Mar 2021 01:47:52 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:47:51 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 03/30] scsi: lpfc: lpfc_scsi: Fix a bunch of kernel-doc misdemeanours
Date:   Fri, 12 Mar 2021 09:47:11 +0000
Message-Id: <20210312094738.2207817-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_scsi.c:746: warning: expecting prototype for lpfc_release_scsi_buf(). Prototype was for lpfc_release_scsi_buf_s3() instead
 drivers/scsi/lpfc/lpfc_scsi.c:979: warning: expecting prototype for App checking is required for(). Prototype was for BG_ERR_CHECK() instead
 drivers/scsi/lpfc/lpfc_scsi.c:3701: warning: Function parameter or member 'vport' not described in 'lpfc_scsi_prep_cmnd_buf'
 drivers/scsi/lpfc/lpfc_scsi.c:3701: warning: Excess function parameter 'phba' description in 'lpfc_scsi_prep_cmnd_buf'
 drivers/scsi/lpfc/lpfc_scsi.c:3717: warning: Function parameter or member 'fcpi_parm' not described in 'lpfc_send_scsi_error_event'
 drivers/scsi/lpfc/lpfc_scsi.c:3717: warning: Excess function parameter 'rsp_iocb' description in 'lpfc_send_scsi_error_event'
 drivers/scsi/lpfc/lpfc_scsi.c:3837: warning: Function parameter or member 'fcpi_parm' not described in 'lpfc_handle_fcp_err'
 drivers/scsi/lpfc/lpfc_scsi.c:3837: warning: expecting prototype for lpfc_handler_fcp_err(). Prototype was for lpfc_handle_fcp_err() instead
 drivers/scsi/lpfc/lpfc_scsi.c:4021: warning: Function parameter or member 'wcqe' not described in 'lpfc_fcp_io_cmd_wqe_cmpl'
 drivers/scsi/lpfc/lpfc_scsi.c:4021: warning: Excess function parameter 'pwqeOut' description in 'lpfc_fcp_io_cmd_wqe_cmpl'
 drivers/scsi/lpfc/lpfc_scsi.c:4621: warning: Function parameter or member 'vport' not described in 'lpfc_scsi_prep_cmnd_buf_s3'
 drivers/scsi/lpfc/lpfc_scsi.c:4621: warning: Excess function parameter 'phba' description in 'lpfc_scsi_prep_cmnd_buf_s3'
 drivers/scsi/lpfc/lpfc_scsi.c:4698: warning: Function parameter or member 'vport' not described in 'lpfc_scsi_prep_cmnd_buf_s4'
 drivers/scsi/lpfc/lpfc_scsi.c:4698: warning: Excess function parameter 'phba' description in 'lpfc_scsi_prep_cmnd_buf_s4'
 drivers/scsi/lpfc/lpfc_scsi.c:4954: warning: expecting prototype for lpfc_taskmgmt_def_cmpl(). Prototype was for lpfc_tskmgmt_def_cmpl() instead
 drivers/scsi/lpfc/lpfc_scsi.c:5094: warning: expecting prototype for lpfc_poll_rearm_time(). Prototype was for lpfc_poll_rearm_timer() instead

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f0caf923f38c2..85f6a066de5a8 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -736,7 +736,7 @@ lpfc_get_scsi_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 }
 
 /**
- * lpfc_release_scsi_buf - Return a scsi buffer back to hba scsi buf list
+ * lpfc_release_scsi_buf_s3 - Return a scsi buffer back to hba scsi buf list
  * @phba: The Hba for which this call is being executed.
  * @psb: The scsi buffer which is being released.
  *
@@ -974,10 +974,10 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 #define BG_ERR_TGT	0x2
 /* Return BG_ERR_SWAP if swapping CSUM<-->CRC is required for error injection */
 #define BG_ERR_SWAP	0x10
-/**
+/*
  * Return BG_ERR_CHECK if disabling Guard/Ref/App checking is required for
  * error injection
- **/
+ */
 #define BG_ERR_CHECK	0x20
 
 /**
@@ -3699,7 +3699,7 @@ lpfc_bg_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 /**
  * lpfc_scsi_prep_cmnd_buf - Wrapper function for IOCB/WQE mapping of scsi
  * buffer
- * @phba: The Hba for which this call is being executed.
+ * @vport: Pointer to vport object.
  * @lpfc_cmd: The scsi buffer which is going to be mapped.
  * @tmo: Timeout value for IO
  *
@@ -3721,7 +3721,7 @@ lpfc_scsi_prep_cmnd_buf(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
  * @phba: Pointer to hba context object.
  * @vport: Pointer to vport object.
  * @lpfc_cmd: Pointer to lpfc scsi command which reported the error.
- * @rsp_iocb: Pointer to response iocb object which reported error.
+ * @fcpi_parm: FCP Initiator parameter.
  *
  * This function posts an event when there is a SCSI command reporting
  * error from the scsi device.
@@ -3836,10 +3836,10 @@ lpfc_scsi_unprep_dma_buf(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 }
 
 /**
- * lpfc_handler_fcp_err - FCP response handler
+ * lpfc_handle_fcp_err - FCP response handler
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_io_buf data structure.
- * @rsp_iocb: The response IOCB which contains FCP error.
+ * @fcpi_parm: FCP Initiator parameter.
  *
  * This routine is called to process response IOCB with status field
  * IOSTAT_FCP_RSP_ERROR. This routine sets result field of scsi command
@@ -4023,7 +4023,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
  * lpfc_fcp_io_cmd_wqe_cmpl - Complete a FCP IO
  * @phba: The hba for which this call is being executed.
  * @pwqeIn: The command WQE for the scsi cmnd.
- * @pwqeOut: The response WQE for the scsi cmnd.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * This routine assigns scsi command result by looking into response WQE
  * status field appropriately. This routine handles QUEUE FULL condition as
@@ -4619,7 +4619,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 
 /**
  * lpfc_scsi_prep_cmnd_buf_s3 - SLI-3 IOCB init for the IO
- * @phba: Pointer to vport object for which I/O is executed
+ * @vport: Pointer to vport object.
  * @lpfc_cmd: The scsi buffer which is going to be prep'ed.
  * @tmo: timeout value for the IO
  *
@@ -4696,7 +4696,7 @@ static int lpfc_scsi_prep_cmnd_buf_s3(struct lpfc_vport *vport,
 
 /**
  * lpfc_scsi_prep_cmnd_buf_s4 - SLI-4 WQE init for the IO
- * @phba: Pointer to vport object for which I/O is executed
+ * @vport: Pointer to vport object.
  * @lpfc_cmd: The scsi buffer which is going to be prep'ed.
  * @tmo: timeout value for the IO
  *
@@ -4953,7 +4953,7 @@ lpfc_scsi_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 }
 
 /**
- * lpfc_taskmgmt_def_cmpl - IOCB completion routine for task management command
+ * lpfc_tskmgmt_def_cmpl - IOCB completion routine for task management command
  * @phba: The Hba for which this call is being executed.
  * @cmdiocbq: Pointer to lpfc_iocbq data structure.
  * @rspiocbq: Pointer to lpfc_iocbq data structure.
@@ -5098,7 +5098,7 @@ lpfc_info(struct Scsi_Host *host)
 }
 
 /**
- * lpfc_poll_rearm_time - Routine to modify fcp_poll timer of hba
+ * lpfc_poll_rearm_timer - Routine to modify fcp_poll timer of hba
  * @phba: The Hba for which this call is being executed.
  *
  * This routine modifies fcp_poll_timer  field of @phba by cfg_poll_tmo.
-- 
2.27.0

