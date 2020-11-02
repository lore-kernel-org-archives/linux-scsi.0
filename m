Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70543C388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06295208A9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bdhOjo5J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKBOZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgKBOYU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:20 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED4BC061A48
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:20 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id a9so14799751wrg.12
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dlRlfgBmVVvi0XaSviLroiHJRxOcA6L90EI31nd/fJo=;
        b=bdhOjo5JJNkkNaW0Dd2roG3kYOhEiRQ6ljiwDvIVErpzInsnmypt1B/ya9Y08OyJDQ
         hYvk2LuDA44N+sVtz7rmzyvai8BniDNcdQm2hS87fPjjuMAF6QaYXh1pKcnn2AKaWUfz
         qfCOeb1h4+tWyuFuevcSl3eQvCnuYpCiJ9uj3zF+1JHxvb5Gka8LT/d9dkZ9mcN0xcFU
         SRBUHCxoMkj8yxGS3rUJrsd8FpG3ZHQ97aq40IcVHmgJ/9NB8mgKrh2Zo5uSZ0eY/5PH
         Zq2aYfAAp10J8nhRzRUGJZWXN/RaytpTSanH0Fzs/yJZ0IaQF/RYEvtztj8czUfxoXqT
         ZLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dlRlfgBmVVvi0XaSviLroiHJRxOcA6L90EI31nd/fJo=;
        b=DNBwBjiFjx7jN5cboufu/PBFYj46Kpa9F7PIS2wVV7BjT1uf0/6c9Dh+r2IyoT5hNV
         t8VnLrC3nOpyhsR0JJrDjnnSCopPvSOOUDaSoYavZQx448sG7Tf39BaIXiE1aU0m6jMm
         8+4ZwfIBoNAeibX1A9D2v/x5xWFWCxWFyG8bC4h/0D6oM6fah8NHhAYnYp/H4TcwBod4
         NPznwofDSOl+qP7MJ5xO9TddJmNL18uu44gqFvpiSwXxmNbMHpCS5cdo/E+S1ygm3FMw
         LIa2zdvPHAb/A4VwB05oEpHJ4fYOzEUokgxlVLCwEjHuvYn9nC4OGcEPBG2sUznco1g3
         jHaA==
X-Gm-Message-State: AOAM531LdR/MBPxqLApDb1ZRv76+XHUbMQzIpPnZ0cgzRwe29h5HLNWq
        6rXcn8wppp6zY7Xlhhao74Q+jA==
X-Google-Smtp-Source: ABdhPJys/5LgLK6NEDr60Vmpb1u/H+ilriScrJVIJl3BovaMT8Uz7Iukbd4L0r5TxT9iUUQc2b85FQ==
X-Received: by 2002:a5d:4207:: with SMTP id n7mr20398224wrq.76.1604327058983;
        Mon, 02 Nov 2020 06:24:18 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:18 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [RESEND 12/19] scsi: lpfc: lpfc_nvme: Fix some kernel-doc related issues
Date:   Mon,  2 Nov 2020 14:23:52 +0000
Message-Id: <20201102142359.561122-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_nvme.c: In function ‘lpfc_nvme_ls_abort’:
 drivers/scsi/lpfc/lpfc_nvme.c:943:19: warning: variable ‘phba’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/lpfc/lpfc_nvme.c:256: warning: Excess function parameter 'lpfc_pnvme' description in 'lpfc_nvme_create_queue'
 drivers/scsi/lpfc/lpfc_nvme.c:804: warning: Function parameter or member 'pnvme_rport' not described in 'lpfc_nvme_ls_req'
 drivers/scsi/lpfc/lpfc_nvme.c:804: warning: Excess function parameter 'nvme_rport' description in 'lpfc_nvme_ls_req'
 drivers/scsi/lpfc/lpfc_nvme.c:1312: warning: Function parameter or member 'lpfc_ncmd' not described in 'lpfc_nvme_prep_io_cmd'
 drivers/scsi/lpfc/lpfc_nvme.c:1312: warning: Excess function parameter 'lpfcn_cmd' description in 'lpfc_nvme_prep_io_cmd'
 drivers/scsi/lpfc/lpfc_nvme.c:1416: warning: Function parameter or member 'lpfc_ncmd' not described in 'lpfc_nvme_prep_io_dma'
 drivers/scsi/lpfc/lpfc_nvme.c:1416: warning: Excess function parameter 'lpfcn_cmd' description in 'lpfc_nvme_prep_io_dma'
 drivers/scsi/lpfc/lpfc_nvme.c:1594: warning: bad line:  indicated in @lpfc_nvme_rport.
 drivers/scsi/lpfc/lpfc_nvme.c:1605: warning: Function parameter or member 'pnvme_lport' not described in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1605: warning: Function parameter or member 'pnvme_rport' not described in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1605: warning: Function parameter or member 'pnvme_fcreq' not described in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1605: warning: Excess function parameter 'lpfc_pnvme' description in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1605: warning: Excess function parameter 'lpfc_nvme_lport' description in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1605: warning: Excess function parameter 'lpfc_nvme_rport' description in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1605: warning: Excess function parameter 'lpfc_nvme_fcreq' description in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1852: warning: Function parameter or member 'abts_cmpl' not described in 'lpfc_nvme_abort_fcreq_cmpl'
 drivers/scsi/lpfc/lpfc_nvme.c:1852: warning: Excess function parameter 'rspiocb' description in 'lpfc_nvme_abort_fcreq_cmpl'
 drivers/scsi/lpfc/lpfc_nvme.c:1888: warning: Function parameter or member 'pnvme_lport' not described in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1888: warning: Function parameter or member 'pnvme_rport' not described in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1888: warning: Function parameter or member 'pnvme_fcreq' not described in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1888: warning: Excess function parameter 'lpfc_pnvme' description in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1888: warning: Excess function parameter 'lpfc_nvme_lport' description in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1888: warning: Excess function parameter 'lpfc_nvme_rport' description in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1888: warning: Excess function parameter 'lpfc_nvme_fcreq' description in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:2089: warning: Function parameter or member 'ndlp' not described in 'lpfc_get_nvme_buf'
 drivers/scsi/lpfc/lpfc_nvme.c:2089: warning: Function parameter or member 'idx' not described in 'lpfc_get_nvme_buf'
 drivers/scsi/lpfc/lpfc_nvme.c:2089: warning: Function parameter or member 'expedite' not described in 'lpfc_get_nvme_buf'
 drivers/scsi/lpfc/lpfc_nvme.c:2193: warning: Function parameter or member 'vport' not described in 'lpfc_nvme_create_localport'
 drivers/scsi/lpfc/lpfc_nvme.c:2326: warning: Function parameter or member 'vport' not described in 'lpfc_nvme_destroy_localport'
 drivers/scsi/lpfc/lpfc_nvme.c:2326: warning: Excess function parameter 'pnvme' description in 'lpfc_nvme_destroy_localport'
 drivers/scsi/lpfc/lpfc_nvme.c:2544: warning: Function parameter or member 'vport' not described in 'lpfc_nvme_rescan_port'
 drivers/scsi/lpfc/lpfc_nvme.c:2544: warning: Function parameter or member 'ndlp' not described in 'lpfc_nvme_rescan_port'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 33d007ca5c8e6..42eb144fed0d1 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -235,7 +235,6 @@ lpfc_nvme_prep_abort_wqe(struct lpfc_iocbq *pwqeq, u16 xritag, u8 opt)
 /**
  * lpfc_nvme_create_queue -
  * @pnvme_lport: Transport localport that LS is to be issued from
- * @lpfc_pnvme: Pointer to the driver's nvme instance data
  * @qidx: An cpu index used to affinitize IO queues and MSIX vectors.
  * @qsize: Size of the queue in bytes
  * @handle: An opaque driver handle used in follow-up calls.
@@ -787,7 +786,7 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 /**
  * lpfc_nvme_ls_req - Issue an NVME Link Service request
  * @pnvme_lport: Transport localport that LS is to be issued from.
- * @nvme_rport: Transport remoteport that LS is to be sent to.
+ * @pnvme_rport: Transport remoteport that LS is to be sent to.
  * @pnvme_lsreq: the transport nvme_ls_req structure for the LS
  *
  * Driver registers this routine to handle any link service request
@@ -1290,7 +1289,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 /**
  * lpfc_nvme_prep_io_cmd - Issue an NVME-over-FCP IO
  * @vport: pointer to a host virtual N_Port data structure
- * @lpfcn_cmd: Pointer to lpfc scsi command
+ * @lpfc_ncmd: Pointer to lpfc scsi command
  * @pnode: pointer to a node-list data structure
  * @cstat: pointer to the control status structure
  *
@@ -1398,7 +1397,7 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 /**
  * lpfc_nvme_prep_io_dma - Issue an NVME-over-FCP IO
  * @vport: pointer to a host virtual N_Port data structure
- * @lpfcn_cmd: Pointer to lpfc scsi command
+ * @lpfc_ncmd: Pointer to lpfc scsi command
  *
  * Driver registers this routine as it io request handler.  This
  * routine issues an fcp WQE with data from the @lpfc_nvme_fcpreq
@@ -1580,16 +1579,14 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 
 /**
  * lpfc_nvme_fcp_io_submit - Issue an NVME-over-FCP IO
- * @lpfc_pnvme: Pointer to the driver's nvme instance data
- * @lpfc_nvme_lport: Pointer to the driver's local port data
- * @lpfc_nvme_rport: Pointer to the rport getting the @lpfc_nvme_ereq
- * @lpfc_nvme_fcreq: IO request from nvme fc to driver.
+ * @pnvme_lport: Pointer to the driver's local port data
+ * @pnvme_rport: Pointer to the rport getting the @lpfc_nvme_ereq
  * @hw_queue_handle: Driver-returned handle in lpfc_nvme_create_queue
+ * @pnvme_fcreq: IO request from nvme fc to driver.
  *
  * Driver registers this routine as it io request handler.  This
  * routine issues an fcp WQE with data from the @lpfc_nvme_fcpreq
- * data structure to the rport
- indicated in @lpfc_nvme_rport.
+ * data structure to the rport indicated in @lpfc_nvme_rport.
  *
  * Return value :
  *   0 - Success
@@ -1837,7 +1834,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
  * lpfc_nvme_abort_fcreq_cmpl - Complete an NVME FCP abort request.
  * @phba: Pointer to HBA context object
  * @cmdiocb: Pointer to command iocb object.
- * @rspiocb: Pointer to response iocb object.
+ * @abts_cmpl: Pointer to wcqe complete object.
  *
  * This is the callback function for any NVME FCP IO that was aborted.
  *
@@ -1863,11 +1860,10 @@ lpfc_nvme_abort_fcreq_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 /**
  * lpfc_nvme_fcp_abort - Issue an NVME-over-FCP ABTS
- * @lpfc_pnvme: Pointer to the driver's nvme instance data
- * @lpfc_nvme_lport: Pointer to the driver's local port data
- * @lpfc_nvme_rport: Pointer to the rport getting the @lpfc_nvme_ereq
- * @lpfc_nvme_fcreq: IO request from nvme fc to driver.
+ * @pnvme_lport: Pointer to the driver's local port data
+ * @pnvme_rport: Pointer to the rport getting the @lpfc_nvme_ereq
  * @hw_queue_handle: Driver-returned handle in lpfc_nvme_create_queue
+ * @pnvme_fcreq: IO request from nvme fc to driver.
  *
  * Driver registers this routine as its nvme request io abort handler.  This
  * routine issues an fcp Abort WQE with data from the @lpfc_nvme_fcpreq
@@ -2070,9 +2066,8 @@ static struct nvme_fc_port_template lpfc_nvme_template = {
 	.fcprqst_priv_sz = sizeof(struct lpfc_nvme_fcpreq_priv),
 };
 
-/**
+/*
  * lpfc_get_nvme_buf - Get a nvme buffer from io_buf_list of the HBA
- * @phba: The HBA for which this call is being executed.
  *
  * This routine removes a nvme buffer from head of @hdwq io_buf_list
  * and returns to caller.
@@ -2172,7 +2167,7 @@ lpfc_release_nvme_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd)
 
 /**
  * lpfc_nvme_create_localport - Create/Bind an nvme localport instance.
- * @pvport - the lpfc_vport instance requesting a localport.
+ * @vport - the lpfc_vport instance requesting a localport.
  *
  * This routine is invoked to create an nvme localport instance to bind
  * to the nvme_fc_transport.  It is called once during driver load
@@ -2319,7 +2314,7 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 
 /**
  * lpfc_nvme_destroy_localport - Destroy lpfc_nvme bound to nvme transport.
- * @pnvme: pointer to lpfc nvme data structure.
+ * @vport: pointer to a host virtual N_Port data structure
  *
  * This routine is invoked to destroy all lports bound to the phba.
  * The lport memory was allocated by the nvme fc transport and is
@@ -2538,7 +2533,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 #endif
 }
 
-/**
+/*
  * lpfc_nvme_rescan_port - Check to see if we should rescan this remoteport
  *
  * If the ndlp represents an NVME Target, that we are logged into,
-- 
2.25.1

