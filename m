Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A0BC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7D352072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OMQNzCIk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgGMIAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729391AbgGMIAc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:32 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ED6C08C5DE
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:32 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z13so14748045wrw.5
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+pfHqz62aOBK6PBea5QXT7uvBZ9qWm4NsoFX/E3qCoE=;
        b=OMQNzCIkwe1GVASXwbfKfH1EZwrbqbXJaABHgLPdkhAX8BlySZr/cJtaAmbu3lO5Dp
         QUjt6VBarH3WtCQa02JufhxUMDiPd/J20La3KPX3ITnqgS678lMApEqT6a0TeOb7Uf44
         Mhr5RSGU5/+PNqLEXp9q/ATrpbJ06YAqTz4nVZQSjxeeYtTTg04PvNt7XawJao+PG00i
         z3Ow2A3IeyAbobQ7QZycFeEqurb1R6yqp7NX0lRiofw5JIeCRsErwYOSdjQ9OlAPJ6E9
         JrULg3ZRD5SPQ8rDv+QJjVKjDi/XQTMCjSIVM91EeGF/xNB8e+8wxldN5EpB3mR16Dha
         sKZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+pfHqz62aOBK6PBea5QXT7uvBZ9qWm4NsoFX/E3qCoE=;
        b=V0pqIeK0lFnkj9iJZcilsxEwZOPz1Att/BB3bTRnpDPUFGhBeNPlzvuGTF6RAjgpwe
         iOEePz4c1l7w0qyOhYNsgslbGRqwtrVNgyERWfzXlAYxDF2pkVFjglSZwjpe9Vl4VQfa
         43UDZRHIh3XDTZju8r80qIY2SdaBPFIigIKWG2xh++6HtB+qqNFiW4RFbbpsyO0RMelF
         kcInygFk0k1CkaxIP7K8m9x3Lr6XxnrcrEeYK4jYYe4gx/ZYzx03Oacd3gCTYkv6TYPo
         vGIRnMSiNisCQR5dQ5NqFPCNIIT3gzLwzSCUbb+5wBkEdAGkS+6eV3J6FkpfgTOmvSVe
         2n8g==
X-Gm-Message-State: AOAM531eyrvsjnE9won5AYQ9/HQEAnVMwCIGe53db/5HwSvB29n0WS+p
        YVdvx4VfXjEl4hP/1t8HbURnBn8KPqs=
X-Google-Smtp-Source: ABdhPJwnLkZgGI/dI/JctrAd6AVpOpcp/TK2xuuAUiMzCVkq5c9Ux7WTDrHVOJOqeoDQgiUnbkGS7w==
X-Received: by 2002:a5d:63ce:: with SMTP id c14mr84151373wrw.254.1594627229930;
        Mon, 13 Jul 2020 01:00:29 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:29 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 20/24] scsi: lpfc: lpfc_nvme: Correct some pretty obvious misdocumentation
Date:   Mon, 13 Jul 2020 08:59:57 +0100
Message-Id: <20200713080001.128044-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Either due to API slippage before the driver was mainlined or copy/paste errors.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_nvme.c:254: warning: Function parameter or member 'pnvme_lport' not described in 'lpfc_nvme_create_queue'
 drivers/scsi/lpfc/lpfc_nvme.c:254: warning: Function parameter or member 'qsize' not described in 'lpfc_nvme_create_queue'
 drivers/scsi/lpfc/lpfc_nvme.c:254: warning: Excess function parameter 'lpfc_pnvme' description in 'lpfc_nvme_create_queue'
 drivers/scsi/lpfc/lpfc_nvme.c:311: warning: Function parameter or member 'pnvme_lport' not described in 'lpfc_nvme_delete_queue'
 drivers/scsi/lpfc/lpfc_nvme.c:311: warning: Excess function parameter 'lpfc_pnvme' description in 'lpfc_nvme_delete_queue'
 drivers/scsi/lpfc/lpfc_nvme.c:689: warning: Function parameter or member 'gen_req_cmp' not described in '__lpfc_nvme_ls_req'
 drivers/scsi/lpfc/lpfc_nvme.c:801: warning: Function parameter or member 'pnvme_lport' not described in 'lpfc_nvme_ls_req'
 drivers/scsi/lpfc/lpfc_nvme.c:801: warning: Function parameter or member 'pnvme_rport' not described in 'lpfc_nvme_ls_req'
 drivers/scsi/lpfc/lpfc_nvme.c:801: warning: Function parameter or member 'pnvme_lsreq' not described in 'lpfc_nvme_ls_req'
 drivers/scsi/lpfc/lpfc_nvme.c:801: warning: Excess function parameter 'lpfc_nvme_lport' description in 'lpfc_nvme_ls_req'
 drivers/scsi/lpfc/lpfc_nvme.c:801: warning: Excess function parameter 'lpfc_nvme_rport' description in 'lpfc_nvme_ls_req'
 drivers/scsi/lpfc/lpfc_nvme.c:937: warning: Function parameter or member 'pnvme_lport' not described in 'lpfc_nvme_ls_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:937: warning: Function parameter or member 'pnvme_rport' not described in 'lpfc_nvme_ls_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:937: warning: Function parameter or member 'pnvme_lsreq' not described in 'lpfc_nvme_ls_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:937: warning: Excess function parameter 'lpfc_nvme_lport' description in 'lpfc_nvme_ls_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:937: warning: Excess function parameter 'lpfc_nvme_rport' description in 'lpfc_nvme_ls_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1075: warning: Function parameter or member 'phba' not described in 'lpfc_nvme_io_cmd_wqe_cmpl'
 drivers/scsi/lpfc/lpfc_nvme.c:1075: warning: Function parameter or member 'pwqeIn' not described in 'lpfc_nvme_io_cmd_wqe_cmpl'
 drivers/scsi/lpfc/lpfc_nvme.c:1075: warning: Function parameter or member 'wcqe' not described in 'lpfc_nvme_io_cmd_wqe_cmpl'
 drivers/scsi/lpfc/lpfc_nvme.c:1075: warning: Excess function parameter 'lpfc_pnvme' description in 'lpfc_nvme_io_cmd_wqe_cmpl'
 drivers/scsi/lpfc/lpfc_nvme.c:1075: warning: Excess function parameter 'lpfc_nvme_lport' description in 'lpfc_nvme_io_cmd_wqe_cmpl'
 drivers/scsi/lpfc/lpfc_nvme.c:1075: warning: Excess function parameter 'lpfc_nvme_rport' description in 'lpfc_nvme_io_cmd_wqe_cmpl'
 drivers/scsi/lpfc/lpfc_nvme.c:1313: warning: Function parameter or member 'vport' not described in 'lpfc_nvme_prep_io_cmd'
 drivers/scsi/lpfc/lpfc_nvme.c:1313: warning: Function parameter or member 'lpfc_ncmd' not described in 'lpfc_nvme_prep_io_cmd'
 drivers/scsi/lpfc/lpfc_nvme.c:1313: warning: Function parameter or member 'pnode' not described in 'lpfc_nvme_prep_io_cmd'
 drivers/scsi/lpfc/lpfc_nvme.c:1313: warning: Function parameter or member 'cstat' not described in 'lpfc_nvme_prep_io_cmd'
 drivers/scsi/lpfc/lpfc_nvme.c:1313: warning: Excess function parameter 'lpfc_pnvme' description in 'lpfc_nvme_prep_io_cmd'
 drivers/scsi/lpfc/lpfc_nvme.c:1313: warning: Excess function parameter 'lpfc_nvme_lport' description in 'lpfc_nvme_prep_io_cmd'
 drivers/scsi/lpfc/lpfc_nvme.c:1313: warning: Excess function parameter 'lpfc_nvme_rport' description in 'lpfc_nvme_prep_io_cmd'
 drivers/scsi/lpfc/lpfc_nvme.c:1313: warning: Excess function parameter 'lpfc_nvme_fcreq' description in 'lpfc_nvme_prep_io_cmd'
 drivers/scsi/lpfc/lpfc_nvme.c:1313: warning: Excess function parameter 'hw_queue_handle' description in 'lpfc_nvme_prep_io_cmd'
 drivers/scsi/lpfc/lpfc_nvme.c:1420: warning: Function parameter or member 'vport' not described in 'lpfc_nvme_prep_io_dma'
 drivers/scsi/lpfc/lpfc_nvme.c:1420: warning: Function parameter or member 'lpfc_ncmd' not described in 'lpfc_nvme_prep_io_dma'
 drivers/scsi/lpfc/lpfc_nvme.c:1420: warning: Excess function parameter 'lpfc_pnvme' description in 'lpfc_nvme_prep_io_dma'
 drivers/scsi/lpfc/lpfc_nvme.c:1420: warning: Excess function parameter 'lpfc_nvme_lport' description in 'lpfc_nvme_prep_io_dma'
 drivers/scsi/lpfc/lpfc_nvme.c:1420: warning: Excess function parameter 'lpfc_nvme_rport' description in 'lpfc_nvme_prep_io_dma'
 drivers/scsi/lpfc/lpfc_nvme.c:1420: warning: Excess function parameter 'lpfc_nvme_fcreq' description in 'lpfc_nvme_prep_io_dma'
 drivers/scsi/lpfc/lpfc_nvme.c:1420: warning: Excess function parameter 'hw_queue_handle' description in 'lpfc_nvme_prep_io_dma'
 drivers/scsi/lpfc/lpfc_nvme.c:1598: warning: bad line:  indicated in @lpfc_nvme_rport.
 drivers/scsi/lpfc/lpfc_nvme.c:1609: warning: Function parameter or member 'pnvme_lport' not described in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1609: warning: Function parameter or member 'pnvme_rport' not described in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1609: warning: Function parameter or member 'pnvme_fcreq' not described in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1609: warning: Excess function parameter 'lpfc_pnvme' description in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1609: warning: Excess function parameter 'lpfc_nvme_lport' description in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1609: warning: Excess function parameter 'lpfc_nvme_rport' description in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1609: warning: Excess function parameter 'lpfc_nvme_fcreq' description in 'lpfc_nvme_fcp_io_submit'
 drivers/scsi/lpfc/lpfc_nvme.c:1856: warning: Function parameter or member 'abts_cmpl' not described in 'lpfc_nvme_abort_fcreq_cmpl'
 drivers/scsi/lpfc/lpfc_nvme.c:1856: warning: Excess function parameter 'rspiocb' description in 'lpfc_nvme_abort_fcreq_cmpl'
 drivers/scsi/lpfc/lpfc_nvme.c:1892: warning: Function parameter or member 'pnvme_lport' not described in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1892: warning: Function parameter or member 'pnvme_rport' not described in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1892: warning: Function parameter or member 'pnvme_fcreq' not described in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1892: warning: Excess function parameter 'lpfc_pnvme' description in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1892: warning: Excess function parameter 'lpfc_nvme_lport' description in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1892: warning: Excess function parameter 'lpfc_nvme_rport' description in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:1892: warning: Excess function parameter 'lpfc_nvme_fcreq' description in 'lpfc_nvme_fcp_abort'
 drivers/scsi/lpfc/lpfc_nvme.c:2093: warning: Function parameter or member 'ndlp' not described in 'lpfc_get_nvme_buf'
 drivers/scsi/lpfc/lpfc_nvme.c:2093: warning: Function parameter or member 'idx' not described in 'lpfc_get_nvme_buf'
 drivers/scsi/lpfc/lpfc_nvme.c:2093: warning: Function parameter or member 'expedite' not described in 'lpfc_get_nvme_buf'
 drivers/scsi/lpfc/lpfc_nvme.c:2197: warning: Function parameter or member 'vport' not described in 'lpfc_nvme_create_localport'
 drivers/scsi/lpfc/lpfc_nvme.c:2330: warning: Function parameter or member 'vport' not described in 'lpfc_nvme_destroy_localport'
 drivers/scsi/lpfc/lpfc_nvme.c:2330: warning: Excess function parameter 'pnvme' description in 'lpfc_nvme_destroy_localport'
 drivers/scsi/lpfc/lpfc_nvme.c:2543: warning: Function parameter or member 'vport' not described in 'lpfc_nvme_rescan_port'
 drivers/scsi/lpfc/lpfc_nvme.c:2543: warning: Function parameter or member 'ndlp' not described in 'lpfc_nvme_rescan_port'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 38 ++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index fdfca02704dc0..91696814174eb 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -234,8 +234,10 @@ lpfc_nvme_prep_abort_wqe(struct lpfc_iocbq *pwqeq, u16 xritag, u8 opt)
 
 /**
  * lpfc_nvme_create_queue -
+ * @pnvme_lport: Transport localport that LS is to be issued from
  * @lpfc_pnvme: Pointer to the driver's nvme instance data
  * @qidx: An cpu index used to affinitize IO queues and MSIX vectors.
+ * @qsize: Size of the queue in bytes
  * @handle: An opaque driver handle used in follow-up calls.
  *
  * Driver registers this routine to preallocate and initialize any
@@ -292,7 +294,7 @@ lpfc_nvme_create_queue(struct nvme_fc_local_port *pnvme_lport,
 
 /**
  * lpfc_nvme_delete_queue -
- * @lpfc_pnvme: Pointer to the driver's nvme instance data
+ * @pnvme_lport: Transport localport that LS is to be issued from
  * @qidx: An cpu index used to affinitize IO queues and MSIX vectors.
  * @handle: An opaque driver handle from lpfc_nvme_create_queue
  *
@@ -672,6 +674,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
  * @vport: The local port issuing the LS
  * @ndlp: The remote port to send the LS to
  * @pnvme_lsreq: Pointer to LS request structure from the transport
+ * @gen_req_cmp: Completion call-back
  *
  * Routine validates the ndlp, builds buffers and sends a GEN_REQUEST
  * WQE to perform the LS operation.
@@ -783,9 +786,9 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 /**
  * lpfc_nvme_ls_req - Issue an NVME Link Service request
- * @lpfc_nvme_lport: Transport localport that LS is to be issued from.
- * @lpfc_nvme_rport: Transport remoteport that LS is to be sent to.
- * @pnvme_lsreq - the transport nvme_ls_req structure for the LS
+ * @pnvme_lport: Transport localport that LS is to be issued from.
+ * @nvme_rport: Transport remoteport that LS is to be sent to.
+ * @pnvme_lsreq: the transport nvme_ls_req structure for the LS
  *
  * Driver registers this routine to handle any link service request
  * from the nvme_fc transport to a remote nvme-aware port.
@@ -923,9 +926,9 @@ lpfc_nvme_xmt_ls_rsp(struct nvme_fc_local_port *localport,
 
 /**
  * lpfc_nvme_ls_abort - Abort a prior NVME LS request
- * @lpfc_nvme_lport: Transport localport that LS is to be issued from.
- * @lpfc_nvme_rport: Transport remoteport that LS is to be sent to.
- * @pnvme_lsreq - the transport nvme_ls_req structure for the LS
+ * @pnvme_lport: Transport localport that LS is to be issued from.
+ * @pnvme_rport: Transport remoteport that LS is to be sent to.
+ * @pnvme_lsreq: the transport nvme_ls_req structure for the LS
  *
  * Driver registers this routine to abort a NVME LS request that is
  * in progress (from the transports perspective).
@@ -1055,11 +1058,8 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 }
 
 
-/**
+/*
  * lpfc_nvme_io_cmd_wqe_cmpl - Complete an NVME-over-FCP IO
- * @lpfc_pnvme: Pointer to the driver's nvme instance data
- * @lpfc_nvme_lport: Pointer to the driver's local port data
- * @lpfc_nvme_rport: Pointer to the rport getting the @lpfc_nvme_ereq
  *
  * Driver registers this routine as it io request handler.  This
  * routine issues an fcp WQE with data from the @lpfc_nvme_fcpreq
@@ -1291,11 +1291,10 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 
 /**
  * lpfc_nvme_prep_io_cmd - Issue an NVME-over-FCP IO
- * @lpfc_pnvme: Pointer to the driver's nvme instance data
- * @lpfc_nvme_lport: Pointer to the driver's local port data
- * @lpfc_nvme_rport: Pointer to the rport getting the @lpfc_nvme_ereq
- * @lpfc_nvme_fcreq: IO request from nvme fc to driver.
- * @hw_queue_handle: Driver-returned handle in lpfc_nvme_create_queue
+ * @vport: pointer to a host virtual N_Port data structure
+ * @lpfcn_cmd: Pointer to lpfc scsi command
+ * @pnode: pointer to a node-list data structure
+ * @cstat: pointer to the control status structure
  *
  * Driver registers this routine as it io request handler.  This
  * routine issues an fcp WQE with data from the @lpfc_nvme_fcpreq
@@ -1400,11 +1399,8 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 
 /**
  * lpfc_nvme_prep_io_dma - Issue an NVME-over-FCP IO
- * @lpfc_pnvme: Pointer to the driver's nvme instance data
- * @lpfc_nvme_lport: Pointer to the driver's local port data
- * @lpfc_nvme_rport: Pointer to the rport getting the @lpfc_nvme_ereq
- * @lpfc_nvme_fcreq: IO request from nvme fc to driver.
- * @hw_queue_handle: Driver-returned handle in lpfc_nvme_create_queue
+ * @vport: pointer to a host virtual N_Port data structure
+ * @lpfcn_cmd: Pointer to lpfc scsi command
  *
  * Driver registers this routine as it io request handler.  This
  * routine issues an fcp WQE with data from the @lpfc_nvme_fcpreq
-- 
2.25.1

