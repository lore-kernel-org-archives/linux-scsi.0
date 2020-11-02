Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02576C4742C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8912084C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tbjF9ZU5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgKBOY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgKBOYX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:23 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27317C0617A6
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:23 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id i16so9412465wrv.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YiKuxEo/wRHTJJqPU7mxaF4N92praJWOsPzk81kg8ns=;
        b=tbjF9ZU5V9QQwA7I40gxdrkwTvBLFOqeWGReA3201tpEwPfps0rEKTURYPc6d5P5pM
         5UBLpjxpqej1MQ1XjWiUbSNdxWGozwxXrb7Qf9cAqD8DkKbQzfuBvODPNf6T/icrg6Wr
         bGGL6vz56QVMnfpeQ1FqIXwxHgeqpPGdwFeOzM6+9NLh9lM6CPMA/SVCm4OZFqlqSv4+
         LqjCg5QG2eAxonev8i4VGcavO511CS2k9mk062USbmTCughEToBclX3L6qJVPaOLiH8J
         tFKHCWASs4zfGKb92o6Ay3gQgM7hczy/HtM3PN2e7p+13Q2YOTEWucY2I/FMnniKlCzI
         COMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YiKuxEo/wRHTJJqPU7mxaF4N92praJWOsPzk81kg8ns=;
        b=ETvtuWC1q4FHPfLhDJKXctY+rlRQxqf0qNsFrG3os7rOiKjytDLq/BTHJuuNZ6ewdy
         0t/kVoscoIr1OruPx7z0PI6FkKmJBd7YCYwcUrVS+Peq9MfwUrVGO32myFOMFMlL2ztn
         OIQDhlPqee7VroypGmWxFp5ZLi8P0BKihVvgHmt2V3YOzF6JijuKwvICECCOH0NoO29z
         yyZ/bwWp7B6L9FFM1ZWUEqrLShSCAkaFmX1zA06ifa19Uog/O8VARCuge1A6CfA1fE+x
         WpJH7pfuZ5gui/cm7n2pDXhSgUxmTT0KHyzelXlWuKJt+nFIztYhzSRT+fmCuFloJ+Z8
         2BsQ==
X-Gm-Message-State: AOAM533GraqL2Fqz3hivoHtzZfyDLKnxMgeTmG5R83/MZkkfU8kumxXh
        MgpkMaaTm2qM1rxmCNYeF+esOQ==
X-Google-Smtp-Source: ABdhPJz0WN8Bx9yzKpxS+qQtclExNDAebvE1c+5gQ2g/maOWMn7FFA68UYuUlqX4pemgNEhzHevjqA==
X-Received: by 2002:adf:eace:: with SMTP id o14mr21089866wrn.308.1604327061915;
        Mon, 02 Nov 2020 06:24:21 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:21 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [RESEND 14/19] scsi: lpfc: lpfc_nvmet: Fix-up some formatting and doc-rot issues
Date:   Mon,  2 Nov 2020 14:23:54 +0000
Message-Id: <20201102142359.561122-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_nvmet.c:386: warning: Function parameter or member 'ctx_buf' not described in 'lpfc_nvmet_ctxbuf_post'
 drivers/scsi/lpfc/lpfc_nvmet.c:386: warning: Excess function parameter 'ctxp' description in 'lpfc_nvmet_ctxbuf_post'
 drivers/scsi/lpfc/lpfc_nvmet.c:386: warning: Excess function parameter 'mp' description in 'lpfc_nvmet_ctxbuf_post'
 drivers/scsi/lpfc/lpfc_nvmet.c:1310: warning: Function parameter or member 'targetport' not described in 'lpfc_nvmet_ls_req'
 drivers/scsi/lpfc/lpfc_nvmet.c:1310: warning: Function parameter or member 'hosthandle' not described in 'lpfc_nvmet_ls_req'
 drivers/scsi/lpfc/lpfc_nvmet.c:1310: warning: Function parameter or member 'pnvme_lsreq' not described in 'lpfc_nvmet_ls_req'
 drivers/scsi/lpfc/lpfc_nvmet.c:1350: warning: Function parameter or member 'hosthandle' not described in 'lpfc_nvmet_ls_abort'
 drivers/scsi/lpfc/lpfc_nvmet.c:1350: warning: Function parameter or member 'pnvme_lsreq' not described in 'lpfc_nvmet_ls_abort'
 drivers/scsi/lpfc/lpfc_nvmet.c:3607: warning: Function parameter or member 'phba' not described in 'lpfc_nvmet_invalidate_host'
 drivers/scsi/lpfc/lpfc_nvmet.c:3607: warning: Function parameter or member 'ndlp' not described in 'lpfc_nvmet_invalidate_host'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index d4ade7cdb93a9..675253093e877 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -371,8 +371,7 @@ lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 /**
  * lpfc_nvmet_ctxbuf_post - Repost a NVMET RQ DMA buffer and clean up context
  * @phba: HBA buffer is associated with
- * @ctxp: context to clean up
- * @mp: Buffer to free
+ * @ctx_buf: ctx buffer context
  *
  * Description: Frees the given DMA buffer in the appropriate way given by
  * reposting it to its associated RQ so it can be reused.
@@ -1291,10 +1290,10 @@ lpfc_nvmet_ls_req_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 
 /**
  * lpfc_nvmet_ls_req - Issue an Link Service request
- * @targetport - pointer to target instance registered with nvmet transport.
- * @hosthandle - hosthandle set by the driver in a prior ls_rqst_rcv.
+ * @targetport: pointer to target instance registered with nvmet transport.
+ * @hosthandle: hosthandle set by the driver in a prior ls_rqst_rcv.
  *               Driver sets this value to the ndlp pointer.
- * @pnvme_lsreq - the transport nvme_ls_req structure for the LS
+ * @pnvme_lsreq: the transport nvme_ls_req structure for the LS
  *
  * Driver registers this routine to handle any link service request
  * from the nvme_fc transport to a remote nvme-aware port.
@@ -1336,9 +1335,9 @@ lpfc_nvmet_ls_req(struct nvmet_fc_target_port *targetport,
 /**
  * lpfc_nvmet_ls_abort - Abort a prior NVME LS request
  * @targetport: Transport targetport, that LS was issued from.
- * @hosthandle - hosthandle set by the driver in a prior ls_rqst_rcv.
+ * @hosthandle: hosthandle set by the driver in a prior ls_rqst_rcv.
  *               Driver sets this value to the ndlp pointer.
- * @pnvme_lsreq - the transport nvme_ls_req structure for LS to be aborted
+ * @pnvme_lsreq: the transport nvme_ls_req structure for LS to be aborted
  *
  * Driver registers this routine to abort an NVME LS request that is
  * in progress (from the transports perspective).
@@ -3596,8 +3595,8 @@ lpfc_nvme_unsol_ls_issue_abort(struct lpfc_hba *phba,
 /**
  * lpfc_nvmet_invalidate_host
  *
- * @phba - pointer to the driver instance bound to an adapter port.
- * @ndlp - pointer to an lpfc_nodelist type
+ * @phba: pointer to the driver instance bound to an adapter port.
+ * @ndlp: pointer to an lpfc_nodelist type
  *
  * This routine upcalls the nvmet transport to invalidate an NVME
  * host to which this target instance had active connections.
-- 
2.25.1

