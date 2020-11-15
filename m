Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8305C64E7B
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A8CB22314
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ur129V8W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgKOT1O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgKOT1N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:13 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52EAC0613CF
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:13 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 131so807014pfb.9
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=2u0sAV9XOyoqo6f4hthyZJuIVFC0WBAn50KZ4Fi0mrM=;
        b=Ur129V8WZ/pCutTa2Yw57BVP2cqp4wumvfJLWT66tL1AHdOCZbIzT2Z5lPXPoWz29/
         RiA5l5VJEgqhI9qF+C2feTSUPa0NGlE5TQgNi8XVj/LPOD25R5KWI1Bxc6ZnqkBxMKde
         nYTfavZb42EyJW4G4HgNtgKhhL1vGjgssXOA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=2u0sAV9XOyoqo6f4hthyZJuIVFC0WBAn50KZ4Fi0mrM=;
        b=gCtKFhDitkAHCZLDWCm26ib4hnJBVooyluZ1MxwwuqBh8z9n/gEBUb56cFPuh0VLv5
         w2ecDu4OVH9PvGCVMiZvfmbIPvmTDEPKryTE9d+IGQCcz5z9xaMQWhcUDVk/gdaY2+Xx
         fzXBb58LDipWAGsEOeedE/0Te9VbMrnl49uZidZx9fzLk5wddafnZOa5LI4ftRu5PYs4
         LdvXc8ifXXFmNd9kyd0i3sF0LP316wfGv50XNn443t0jBzY7HdyprpPr3jdLcZQzQjJq
         lfdmIC50Noh5uf+8nNwa2fC98PdeCKaY/jCKOEiMavjF2eZHyNcp7nrNDYjlcl3oJTDW
         sEoA==
X-Gm-Message-State: AOAM530UR/fNlWGi6ROcbzqysv0t+y4l4MzAMXqo60sLRPlm3D5GQOZi
        UbJsxijS0Xw9fP/sxQEiiozPKJr0ny69EUEmvdD3vR39SNCsGM/IyCYM7U5lExP8BcEC0n9r80x
        If00CsFuYxFqeIt5UASeZraRtRKp0ghQTRHfYsg6zxbO3F0M5bzLidove/F9sX8s6lltNm/hA8Y
        /kU58=
X-Google-Smtp-Source: ABdhPJxNwUSGVhZ0ewtFxZXKUKg6I2ISKY1ZSiguVNIsYX1BEy5wmdKDXtBTWNIU+D5NfUMqZhQdNw==
X-Received: by 2002:a17:90a:5b15:: with SMTP id o21mr11823636pji.45.1605468432126;
        Sun, 15 Nov 2020 11:27:12 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:27:11 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 13/17] lpfc: convert scsi path to use common io submission path
Date:   Sun, 15 Nov 2020 11:26:42 -0800
Message-Id: <20201115192646.12977-14-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a582af05b42a3f46"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000a582af05b42a3f46
Content-Transfer-Encoding: 8bit

This patch converts the scsi io path from the iocb-centric interfaces
to the common io submission path which supports native SLI-4 WQEs.

A wrapper routine is put in place to distinguish SLI-3 from SLI. If SLI-3,
the same iocb-centric paths are used, perhaps with refactored code that
is explicitly for SLI-3.  For SLI-4, any iocb-related formatting is
replaced by wqe-based formatting, although much of that is addressed by
the common wqe templates in the SLI-4 path.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |   4 +
 drivers/scsi/lpfc/lpfc_scsi.c | 455 ++++++++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_sli.c  |  55 ++--
 3 files changed, 365 insertions(+), 149 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 63a87c103bc5..a54c8da30273 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -664,6 +664,10 @@ struct lpfc_hba {
 	void (*lpfc_scsi_prep_cmnd)
 		(struct lpfc_vport *, struct lpfc_io_buf *,
 		 struct lpfc_nodelist *);
+	int (*lpfc_scsi_prep_cmnd_buf)
+		(struct lpfc_vport *vport,
+		 struct lpfc_io_buf *lpfc_cmd,
+		 uint8_t tmo);
 
 	/* IOCB interface function jump table entries */
 	int (*__lpfc_sli_issue_iocb)
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 5ec1fc1372fa..4d6492faab81 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -633,7 +633,6 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	struct lpfc_io_buf *lpfc_cmd;
 	struct lpfc_sli4_hdw_queue *qp;
 	struct sli4_sge *sgl;
-	IOCB_t *iocb;
 	dma_addr_t pdma_phys_fcp_rsp;
 	dma_addr_t pdma_phys_fcp_cmd;
 	uint32_t cpu, idx;
@@ -703,24 +702,6 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	sgl->word2 = cpu_to_le32(sgl->word2);
 	sgl->sge_len = cpu_to_le32(sizeof(struct fcp_rsp));
 
-	/*
-	 * Since the IOCB for the FCP I/O is built into this
-	 * lpfc_io_buf, initialize it with all known data now.
-	 */
-	iocb = &lpfc_cmd->cur_iocbq.iocb;
-	iocb->un.fcpi64.bdl.ulpIoTag32 = 0;
-	iocb->un.fcpi64.bdl.bdeFlags = BUFF_TYPE_BDE_64;
-	/* setting the BLP size to 2 * sizeof BDE may not be correct.
-	 * We are setting the bpl to point to out sgl. An sgl's
-	 * entries are 16 bytes, a bpl entries are 12 bytes.
-	 */
-	iocb->un.fcpi64.bdl.bdeSize = sizeof(struct fcp_cmnd);
-	iocb->un.fcpi64.bdl.addrLow = putPaddrLow(pdma_phys_fcp_cmd);
-	iocb->un.fcpi64.bdl.addrHigh = putPaddrHigh(pdma_phys_fcp_cmd);
-	iocb->ulpBdeCount = 1;
-	iocb->ulpLe = 1;
-	iocb->ulpClass = CLASS3;
-
 	if (lpfc_ndlp_check_qdepth(phba, ndlp)) {
 		atomic_inc(&ndlp->cmd_pending);
 		lpfc_cmd->flags |= LPFC_SBUF_BUMP_QDEPTH;
@@ -817,6 +798,25 @@ lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 	phba->lpfc_release_scsi_buf(phba, psb);
 }
 
+/**
+ * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB
+ * @data: A pointer to the immediate command data portion of the IOCB.
+ * @fcp_cmnd: The FCP Command that is provided by the SCSI layer.
+ *
+ * The routine copies the entire FCP command from @fcp_cmnd to @data while
+ * byte swapping the data to big endian format for transmission on the wire.
+ **/
+static void
+lpfc_fcpcmd_to_iocb(u8 *data, struct fcp_cmnd *fcp_cmnd)
+{
+	int i, j;
+
+	for (i = 0, j = 0; i < sizeof(struct fcp_cmnd);
+	     i += sizeof(uint32_t), j++) {
+		((uint32_t *)data)[j] = cpu_to_be32(((uint32_t *)fcp_cmnd)[j]);
+	}
+}
+
 /**
  * lpfc_scsi_prep_dma_buf_s3 - DMA mapping for scsi buffer to SLI3 IF spec
  * @phba: The Hba for which this call is being executed.
@@ -953,6 +953,7 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	 * we need to set word 4 of IOCB here
 	 */
 	iocb_cmd->un.fcpi.fcpi_parm = scsi_bufflen(scsi_cmnd);
+	lpfc_fcpcmd_to_iocb(iocb_cmd->unsli3.fcp_ext.icd, fcp_cmnd);
 	return 0;
 }
 
@@ -3050,7 +3051,9 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
 	struct sli4_sge *sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
 	struct sli4_sge *first_data_sgl;
-	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
+	struct lpfc_iocbq *pwqeq = &lpfc_cmd->cur_iocbq;
+	struct lpfc_vport *vport = phba->pport;
+	union lpfc_wqe128 *wqe = &pwqeq->wqe;
 	dma_addr_t physaddr;
 	uint32_t num_bde = 0;
 	uint32_t dma_len;
@@ -3191,13 +3194,16 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		if ((phba->sli3_options & LPFC_SLI4_PERFH_ENABLED) ||
 		    phba->cfg_enable_pbde) {
 			bde = (struct ulp_bde64 *)
-				&(iocb_cmd->unsli3.sli3Words[5]);
+				&wqe->words[13];
 			bde->addrLow = first_data_sgl->addr_lo;
 			bde->addrHigh = first_data_sgl->addr_hi;
 			bde->tus.f.bdeSize =
 					le32_to_cpu(first_data_sgl->sge_len);
 			bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 			bde->tus.w = cpu_to_le32(bde->tus.w);
+
+		} else {
+			memset(&wqe->words[13], 0, (sizeof(uint32_t) * 3));
 		}
 	} else {
 		sgl += 1;
@@ -3209,11 +3215,15 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		if ((phba->sli3_options & LPFC_SLI4_PERFH_ENABLED) ||
 		    phba->cfg_enable_pbde) {
 			bde = (struct ulp_bde64 *)
-				&(iocb_cmd->unsli3.sli3Words[5]);
+				&wqe->words[13];
 			memset(bde, 0, (sizeof(uint32_t) * 3));
 		}
 	}
 
+	/* Word 11 */
+	if (phba->cfg_enable_pbde)
+		bf_set(wqe_pbde, &wqe->generic.wqe_com, 1);
+
 	/*
 	 * Finish initializing those IOCB fields that are dependent on the
 	 * scsi_cmnd request_buffer.  Note that for SLI-2 the bdeSize is
@@ -3221,12 +3231,23 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	 * all iocb memory resources are reused.
 	 */
 	fcp_cmnd->fcpDl = cpu_to_be32(scsi_bufflen(scsi_cmnd));
-
-	/*
-	 * Due to difference in data length between DIF/non-DIF paths,
-	 * we need to set word 4 of IOCB here
-	 */
-	iocb_cmd->un.fcpi.fcpi_parm = scsi_bufflen(scsi_cmnd);
+	/* Set first-burst provided it was successfully negotiated */
+	if (!(phba->hba_flag & HBA_FCOE_MODE) &&
+	    vport->cfg_first_burst_size &&
+	    scsi_cmnd->sc_data_direction == DMA_TO_DEVICE) {
+		u32 init_len, total_len;
+
+		total_len = be32_to_cpu(fcp_cmnd->fcpDl);
+		init_len = min(total_len, vport->cfg_first_burst_size);
+
+		/* Word 4 & 5 */
+		wqe->fcp_iwrite.initial_xfer_len = init_len;
+		wqe->fcp_iwrite.total_xfer_len = total_len;
+	} else {
+		/* Word 4 */
+		wqe->fcp_iwrite.total_xfer_len =
+			be32_to_cpu(fcp_cmnd->fcpDl);
+	}
 
 	/*
 	 * If the OAS driver feature is enabled and the lun is enabled for
@@ -3237,6 +3258,17 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		lpfc_cmd->cur_iocbq.iocb_flag |= (LPFC_IO_OAS | LPFC_IO_FOF);
 		lpfc_cmd->cur_iocbq.priority = ((struct lpfc_device_data *)
 			scsi_cmnd->device->hostdata)->priority;
+
+		/* Word 10 */
+		bf_set(wqe_oas, &wqe->generic.wqe_com, 1);
+		bf_set(wqe_ccpe, &wqe->generic.wqe_com, 1);
+
+		if (lpfc_cmd->cur_iocbq.priority)
+			bf_set(wqe_ccp, &wqe->generic.wqe_com,
+			       (lpfc_cmd->cur_iocbq.priority << 1));
+		else
+			bf_set(wqe_ccp, &wqe->generic.wqe_com,
+			       (phba->cfg_XLanePriority << 1));
 	}
 
 	return 0;
@@ -3262,7 +3294,8 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
 	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
 	struct sli4_sge *sgl = (struct sli4_sge *)(lpfc_cmd->dma_sgl);
-	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
+	struct lpfc_iocbq *pwqeq = &lpfc_cmd->cur_iocbq;
+	union lpfc_wqe128 *wqe = &pwqeq->wqe;
 	uint32_t num_sge = 0;
 	int datasegcnt, protsegcnt, datadir = scsi_cmnd->sc_data_direction;
 	int prot_group_type = 0;
@@ -3394,28 +3427,50 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	fcpdl = lpfc_bg_scsi_adjust_dl(phba, lpfc_cmd);
 	fcp_cmnd->fcpDl = be32_to_cpu(fcpdl);
 
-	/*
-	 * Due to difference in data length between DIF/non-DIF paths,
-	 * we need to set word 4 of IOCB here
-	 */
-	iocb_cmd->un.fcpi.fcpi_parm = fcpdl;
+	/* Set first-burst provided it was successfully negotiated */
+	if (!(phba->hba_flag & HBA_FCOE_MODE) &&
+	    vport->cfg_first_burst_size &&
+	    scsi_cmnd->sc_data_direction == DMA_TO_DEVICE) {
+		u32 init_len, total_len;
 
-	/*
-	 * For First burst, we may need to adjust the initial transfer
-	 * length for DIF
-	 */
-	if (iocb_cmd->un.fcpi.fcpi_XRdy &&
-	    (fcpdl < vport->cfg_first_burst_size))
-		iocb_cmd->un.fcpi.fcpi_XRdy = fcpdl;
+		total_len = be32_to_cpu(fcp_cmnd->fcpDl);
+		init_len = min(total_len, vport->cfg_first_burst_size);
+
+		/* Word 4 & 5 */
+		wqe->fcp_iwrite.initial_xfer_len = init_len;
+		wqe->fcp_iwrite.total_xfer_len = total_len;
+	} else {
+		/* Word 4 */
+		wqe->fcp_iwrite.total_xfer_len =
+			be32_to_cpu(fcp_cmnd->fcpDl);
+	}
 
 	/*
 	 * If the OAS driver feature is enabled and the lun is enabled for
 	 * OAS, set the oas iocb related flags.
 	 */
 	if ((phba->cfg_fof) && ((struct lpfc_device_data *)
-		scsi_cmnd->device->hostdata)->oas_enabled)
+		scsi_cmnd->device->hostdata)->oas_enabled) {
 		lpfc_cmd->cur_iocbq.iocb_flag |= (LPFC_IO_OAS | LPFC_IO_FOF);
 
+		/* Word 10 */
+		bf_set(wqe_oas, &wqe->generic.wqe_com, 1);
+		bf_set(wqe_ccpe, &wqe->generic.wqe_com, 1);
+		bf_set(wqe_ccp, &wqe->generic.wqe_com,
+		       (phba->cfg_XLanePriority << 1));
+	}
+
+	/* Word 7. DIF Flags */
+	if (lpfc_cmd->cur_iocbq.iocb_flag & LPFC_IO_DIF_PASS)
+		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_PASSTHRU);
+	else if (lpfc_cmd->cur_iocbq.iocb_flag & LPFC_IO_DIF_STRIP)
+		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_STRIP);
+	else if (lpfc_cmd->cur_iocbq.iocb_flag & LPFC_IO_DIF_INSERT)
+		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_INSERT);
+
+	lpfc_cmd->cur_iocbq.iocb_flag &= ~(LPFC_IO_DIF_PASS |
+				 LPFC_IO_DIF_STRIP | LPFC_IO_DIF_INSERT);
+
 	return 0;
 err:
 	if (lpfc_cmd->seg_cnt)
@@ -3474,6 +3529,26 @@ lpfc_bg_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	return phba->lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
 }
 
+/**
+ * lpfc_scsi_prep_cmnd_buf - Wrapper function for IOCB/WQE mapping of scsi
+ * buffer
+ * @phba: The Hba for which this call is being executed.
+ * @lpfc_cmd: The scsi buffer which is going to be mapped.
+ * @tmo: Timeout value for IO
+ *
+ * This routine initializes IOCB/WQE data structure from scsi command
+ *
+ * Return codes:
+ *	1 - Error
+ *	0 - Success
+ **/
+static inline int
+lpfc_scsi_prep_cmnd_buf(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
+			uint8_t tmo)
+{
+	return vport->phba->lpfc_scsi_prep_cmnd_buf(vport, lpfc_cmd, tmo);
+}
+
 /**
  * lpfc_send_scsi_error_event - Posts an event when there is SCSI error
  * @phba: Pointer to hba context object.
@@ -4052,72 +4127,30 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 }
 
 /**
- * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB
- * @data: A pointer to the immediate command data portion of the IOCB.
- * @fcp_cmnd: The FCP Command that is provided by the SCSI layer.
+ * lpfc_scsi_prep_cmnd_buf_s3 - SLI-3 IOCB init for the IO
+ * @phba: Pointer to vport object for which IO is executed
+ * @lpfc_cmd: The scsi buffer which is going to be prep'ed.
+ * @tmo: timeout value for the IO
  *
- * The routine copies the entire FCP command from @fcp_cmnd to @data while
- * byte swapping the data to big endian format for transmission on the wire.
- **/
-static void
-lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
-{
-	int i, j;
-	for (i = 0, j = 0; i < sizeof(struct fcp_cmnd);
-	     i += sizeof(uint32_t), j++) {
-		((uint32_t *)data)[j] = cpu_to_be32(((uint32_t *)fcp_cmnd)[j]);
-	}
-}
-
-/**
- * lpfc_scsi_prep_cmnd - Wrapper func for convert scsi cmnd to FCP info unit
- * @vport: The virtual port for which this call is being executed.
- * @lpfc_cmd: The scsi command which needs to send.
- * @pnode: Pointer to lpfc_nodelist.
+ * Based on the data-direction of the command, initialize IOCB
+ * in the IO buffer. Fill in the IOCB fields which are independent
+ * of the scsi buffer
  *
- * This routine initializes fcp_cmnd and iocb data structure from scsi command
- * to transfer for device with SLI3 interface spec.
+ * RETURNS 0 - SUCCESS,
  **/
-static void
-lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
-		    struct lpfc_nodelist *pnode)
+static int lpfc_scsi_prep_cmnd_buf_s3(struct lpfc_vport *vport,
+				      struct lpfc_io_buf *lpfc_cmd,
+				      uint8_t tmo)
 {
-	struct lpfc_hba *phba = vport->phba;
+	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
+	struct lpfc_iocbq *piocbq = &lpfc_cmd->cur_iocbq;
 	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
 	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
-	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
-	struct lpfc_iocbq *piocbq = &(lpfc_cmd->cur_iocbq);
-	struct lpfc_sli4_hdw_queue *hdwq = NULL;
+	struct lpfc_nodelist *pnode = lpfc_cmd->ndlp;
 	int datadir = scsi_cmnd->sc_data_direction;
-	int idx;
-	uint8_t *ptr;
-	bool sli4;
-	uint32_t fcpdl;
-
-	if (!pnode)
-		return;
+	u32 fcpdl;
 
-	lpfc_cmd->fcp_rsp->rspSnsLen = 0;
-	/* clear task management bits */
-	lpfc_cmd->fcp_cmnd->fcpCntl2 = 0;
-
-	int_to_scsilun(lpfc_cmd->pCmd->device->lun,
-			&lpfc_cmd->fcp_cmnd->fcp_lun);
-
-	ptr = &fcp_cmnd->fcpCdb[0];
-	memcpy(ptr, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
-	if (scsi_cmnd->cmd_len < LPFC_FCP_CDB_LEN) {
-		ptr += scsi_cmnd->cmd_len;
-		memset(ptr, 0, (LPFC_FCP_CDB_LEN - scsi_cmnd->cmd_len));
-	}
-
-	fcp_cmnd->fcpCntl1 = SIMPLE_Q;
-
-	sli4 = (phba->sli_rev == LPFC_SLI_REV4);
 	piocbq->iocb.un.fcpi.fcpi_XRdy = 0;
-	idx = lpfc_cmd->hdwq_no;
-	if (phba->sli4_hba.hdwq)
-		hdwq = &phba->sli4_hba.hdwq[idx];
 
 	/*
 	 * There are three possibilities here - use scatter-gather segment, use
@@ -4131,42 +4164,31 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 			iocb_cmd->ulpPU = PARM_READ_CHECK;
 			if (vport->cfg_first_burst_size &&
 			    (pnode->nlp_flag & NLP_FIRSTBURST)) {
+				u32 xrdy_len;
+
 				fcpdl = scsi_bufflen(scsi_cmnd);
-				if (fcpdl < vport->cfg_first_burst_size)
-					piocbq->iocb.un.fcpi.fcpi_XRdy = fcpdl;
-				else
-					piocbq->iocb.un.fcpi.fcpi_XRdy =
-						vport->cfg_first_burst_size;
+				xrdy_len = min(fcpdl,
+					       vport->cfg_first_burst_size);
+				piocbq->iocb.un.fcpi.fcpi_XRdy = xrdy_len;
 			}
 			fcp_cmnd->fcpCntl3 = WRITE_DATA;
-			if (hdwq)
-				hdwq->scsi_cstat.output_requests++;
 		} else {
 			iocb_cmd->ulpCommand = CMD_FCP_IREAD64_CR;
 			iocb_cmd->ulpPU = PARM_READ_CHECK;
 			fcp_cmnd->fcpCntl3 = READ_DATA;
-			if (hdwq)
-				hdwq->scsi_cstat.input_requests++;
 		}
 	} else {
 		iocb_cmd->ulpCommand = CMD_FCP_ICMND64_CR;
 		iocb_cmd->un.fcpi.fcpi_parm = 0;
 		iocb_cmd->ulpPU = 0;
 		fcp_cmnd->fcpCntl3 = 0;
-		if (hdwq)
-			hdwq->scsi_cstat.control_requests++;
 	}
-	if (phba->sli_rev == 3 &&
-	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED))
-		lpfc_fcpcmd_to_iocb(iocb_cmd->unsli3.fcp_ext.icd, fcp_cmnd);
+
 	/*
 	 * Finish initializing those IOCB fields that are independent
 	 * of the scsi_cmnd request_buffer
 	 */
 	piocbq->iocb.ulpContext = pnode->nlp_rpi;
-	if (sli4)
-		piocbq->iocb.ulpContext =
-		  phba->sli4_hba.rpi_ids[pnode->nlp_rpi];
 	if (pnode->nlp_fcp_info & NLP_FCP_2_DEVICE)
 		piocbq->iocb.ulpFCP2Rcvy = 1;
 	else
@@ -4174,9 +4196,160 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 
 	piocbq->iocb.ulpClass = (pnode->nlp_fcp_info & 0x0f);
 	piocbq->context1  = lpfc_cmd;
-	piocbq->iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
-	piocbq->iocb.ulpTimeout = lpfc_cmd->timeout;
+	if (!piocbq->iocb_cmpl)
+		piocbq->iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
+	piocbq->iocb.ulpTimeout = tmo;
 	piocbq->vport = vport;
+	return 0;
+}
+
+/**
+ * lpfc_scsi_prep_cmnd_buf_s4 - SLI-4 WQE init for the IO
+ * @phba: Pointer to vport object for which IO is executed
+ * @lpfc_cmd: The scsi buffer which is going to be prep'ed.
+ * @tmo: timeout value for the IO
+ *
+ * Based on the data-direction of the command copy WQE template
+ * to IO buffer WQE. Fill in the WQE fields which are independent
+ * of the scsi buffer
+ *
+ * RETURNS 0 - SUCCESS,
+ **/
+static int lpfc_scsi_prep_cmnd_buf_s4(struct lpfc_vport *vport,
+				      struct lpfc_io_buf *lpfc_cmd,
+				      uint8_t tmo)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
+	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
+	struct lpfc_sli4_hdw_queue *hdwq = NULL;
+	struct lpfc_iocbq *pwqeq = &lpfc_cmd->cur_iocbq;
+	struct lpfc_nodelist *pnode = lpfc_cmd->ndlp;
+	union lpfc_wqe128 *wqe = &pwqeq->wqe;
+	u16 idx = lpfc_cmd->hdwq_no;
+	int datadir = scsi_cmnd->sc_data_direction;
+
+	hdwq = &phba->sli4_hba.hdwq[idx];
+
+	/* Initialize 64 bytes only */
+	memset(wqe, 0, sizeof(union lpfc_wqe128));
+
+	/*
+	 * There are three possibilities here - use scatter-gather segment, use
+	 * the single mapping, or neither.
+	 */
+	if (scsi_sg_count(scsi_cmnd)) {
+		if (datadir == DMA_TO_DEVICE) {
+			/* From the iwrite template, initialize words 7 -  11 */
+			memcpy(&wqe->words[7],
+			       &lpfc_iwrite_cmd_template.words[7],
+			       sizeof(uint32_t) * 5);
+
+			fcp_cmnd->fcpCntl3 = WRITE_DATA;
+			if (hdwq)
+				hdwq->scsi_cstat.output_requests++;
+		} else {
+			/* From the iread template, initialize words 7 - 11 */
+			memcpy(&wqe->words[7],
+			       &lpfc_iread_cmd_template.words[7],
+			       sizeof(uint32_t) * 5);
+
+			/* Word 7 */
+			bf_set(wqe_tmo, &wqe->fcp_iread.wqe_com, tmo);
+
+			fcp_cmnd->fcpCntl3 = READ_DATA;
+			if (hdwq)
+				hdwq->scsi_cstat.input_requests++;
+		}
+	} else {
+		/* From the icmnd template, initialize words 4 - 11 */
+		memcpy(&wqe->words[4], &lpfc_icmnd_cmd_template.words[4],
+		       sizeof(uint32_t) * 8);
+
+		/* Word 7 */
+		bf_set(wqe_tmo, &wqe->fcp_icmd.wqe_com, tmo);
+
+		fcp_cmnd->fcpCntl3 = 0;
+		if (hdwq)
+			hdwq->scsi_cstat.control_requests++;
+	}
+
+	/*
+	 * Finish initializing those WQE fields that are independent
+	 * of the request_buffer
+	 */
+
+	 /* Word 3 */
+	bf_set(payload_offset_len, &wqe->fcp_icmd,
+	       sizeof(struct fcp_cmnd) + sizeof(struct fcp_rsp));
+
+	/* Word 6 */
+	bf_set(wqe_ctxt_tag, &wqe->generic.wqe_com,
+	       phba->sli4_hba.rpi_ids[pnode->nlp_rpi]);
+	bf_set(wqe_xri_tag, &wqe->generic.wqe_com, pwqeq->sli4_xritag);
+
+	/* Word 7*/
+	if (pnode->nlp_fcp_info & NLP_FCP_2_DEVICE)
+		bf_set(wqe_erp, &wqe->generic.wqe_com, 1);
+
+	bf_set(wqe_class, &wqe->generic.wqe_com,
+	       (pnode->nlp_fcp_info & 0x0f));
+
+	 /* Word 8 */
+	wqe->generic.wqe_com.abort_tag = pwqeq->iotag;
+
+	/* Word 9 */
+	bf_set(wqe_reqtag, &wqe->generic.wqe_com, pwqeq->iotag);
+
+	pwqeq->vport = vport;
+	pwqeq->vport = vport;
+	pwqeq->context1 = lpfc_cmd;
+	pwqeq->hba_wqidx = lpfc_cmd->hdwq_no;
+	if (!pwqeq->iocb_cmpl)
+		pwqeq->iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
+
+	return 0;
+}
+
+/**
+ * lpfc_scsi_prep_cmnd - Wrapper func for convert scsi cmnd to FCP info unit
+ * @vport: The virtual port for which this call is being executed.
+ * @lpfc_cmd: The scsi command which needs to send.
+ * @pnode: Pointer to lpfc_nodelist.
+ *
+ * This routine initializes fcp_cmnd and iocb data structure from scsi command
+ * to transfer for device with SLI3 interface spec.
+ **/
+static int
+lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
+		    struct lpfc_nodelist *pnode)
+{
+	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
+	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
+	u8 *ptr;
+
+	if (!pnode)
+		return 0;
+
+	lpfc_cmd->fcp_rsp->rspSnsLen = 0;
+	/* clear task management bits */
+	lpfc_cmd->fcp_cmnd->fcpCntl2 = 0;
+
+	int_to_scsilun(lpfc_cmd->pCmd->device->lun,
+		       &lpfc_cmd->fcp_cmnd->fcp_lun);
+
+	ptr = &fcp_cmnd->fcpCdb[0];
+	memcpy(ptr, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
+	if (scsi_cmnd->cmd_len < LPFC_FCP_CDB_LEN) {
+		ptr += scsi_cmnd->cmd_len;
+		memset(ptr, 0, (LPFC_FCP_CDB_LEN - scsi_cmnd->cmd_len));
+	}
+
+	fcp_cmnd->fcpCntl1 = SIMPLE_Q;
+
+	lpfc_scsi_prep_cmnd_buf(vport, lpfc_cmd, lpfc_cmd->timeout);
+
+	return 0;
 }
 
 /**
@@ -4262,7 +4435,6 @@ lpfc_scsi_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 {
 
 	phba->lpfc_scsi_unprep_dma_buf = lpfc_scsi_unprep_dma_buf;
-	phba->lpfc_scsi_prep_cmnd = lpfc_scsi_prep_cmnd;
 
 	switch (dev_grp) {
 	case LPFC_PCI_DEV_LP:
@@ -4270,12 +4442,14 @@ lpfc_scsi_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->lpfc_bg_scsi_prep_dma_buf = lpfc_bg_scsi_prep_dma_buf_s3;
 		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s3;
 		phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf_s3;
+		phba->lpfc_scsi_prep_cmnd_buf = lpfc_scsi_prep_cmnd_buf_s3;
 		break;
 	case LPFC_PCI_DEV_OC:
 		phba->lpfc_scsi_prep_dma_buf = lpfc_scsi_prep_dma_buf_s4;
 		phba->lpfc_bg_scsi_prep_dma_buf = lpfc_bg_scsi_prep_dma_buf_s4;
 		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s4;
 		phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf_s4;
+		phba->lpfc_scsi_prep_cmnd_buf = lpfc_scsi_prep_cmnd_buf_s4;
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -4591,8 +4765,13 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	lpfc_cmd->pCmd  = cmnd;
 	lpfc_cmd->rdata = rdata;
 	lpfc_cmd->ndlp = ndlp;
+	lpfc_cmd->cur_iocbq.iocb_cmpl = NULL;
 	cmnd->host_scribble = (unsigned char *)lpfc_cmd;
 
+	err = lpfc_scsi_prep_cmnd(vport, lpfc_cmd, ndlp);
+	if (err)
+		goto out_host_busy_release_buf;
+
 	if (scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
 		if (vport->phba->cfg_enable_bg) {
 			lpfc_printf_vlog(vport,
@@ -4628,7 +4807,6 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 		goto out_host_busy_free_buf;
 	}
 
-	lpfc_scsi_prep_cmnd(vport, lpfc_cmd, ndlp);
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))
@@ -4649,24 +4827,30 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 #endif
 	if (err) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-				 "3376 FCP could not issue IOCB err %x"
-				 "FCP cmd x%x <%d/%llu> "
-				 "sid: x%x did: x%x oxid: x%x "
-				 "Data: x%x x%x x%x x%x\n",
-				 err, cmnd->cmnd[0],
-				 cmnd->device ? cmnd->device->id : 0xffff,
-				 cmnd->device ? cmnd->device->lun : (u64) -1,
-				 vport->fc_myDID, ndlp->nlp_DID,
-				 phba->sli_rev == LPFC_SLI_REV4 ?
-				 lpfc_cmd->cur_iocbq.sli4_xritag : 0xffff,
-				 lpfc_cmd->cur_iocbq.iocb.ulpContext,
-				 lpfc_cmd->cur_iocbq.iocb.ulpIoTag,
-				 lpfc_cmd->cur_iocbq.iocb.ulpTimeout,
-				 (uint32_t)
-				 (cmnd->request->timeout / 1000));
+				   "3376 FCP could not issue IOCB err %x "
+				   "FCP cmd x%x <%d/%llu> "
+				   "sid: x%x did: x%x oxid: x%x "
+				   "Data: x%x x%x x%x x%x\n",
+				   err, cmnd->cmnd[0],
+				   cmnd->device ? cmnd->device->id : 0xffff,
+				   cmnd->device ? cmnd->device->lun : (u64)-1,
+				   vport->fc_myDID, ndlp->nlp_DID,
+				   phba->sli_rev == LPFC_SLI_REV4 ?
+				   lpfc_cmd->cur_iocbq.sli4_xritag : 0xffff,
+				   phba->sli_rev == LPFC_SLI_REV4 ?
+				   phba->sli4_hba.rpi_ids[ndlp->nlp_rpi] :
+				   lpfc_cmd->cur_iocbq.iocb.ulpContext,
+				   lpfc_cmd->cur_iocbq.iotag,
+				   phba->sli_rev == LPFC_SLI_REV4 ?
+				   bf_get(wqe_tmo,
+				   &lpfc_cmd->cur_iocbq.wqe.generic.wqe_com) :
+				   lpfc_cmd->cur_iocbq.iocb.ulpTimeout,
+				   (uint32_t)
+				   (cmnd->request->timeout / 1000));
 
 		goto out_host_busy_free_buf;
 	}
+
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_handle_fast_ring_event(phba,
 			&phba->sli.sli3_ring[LPFC_FCP_RING], HA_R0RE_REQ);
@@ -4695,6 +4879,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 			phba->sli4_hba.hdwq[idx].scsi_cstat.control_requests--;
 		}
 	}
+ out_host_busy_release_buf:
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
  out_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 31c524a3373f..2007835b6a5a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10251,7 +10251,7 @@ __lpfc_sli_issue_fcp_io_s3(struct lpfc_hba *phba, uint32_t ring_number,
 	int rc;
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
-	rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
+	rc = __lpfc_sli_issue_iocb_s3(phba, ring_number, piocb, flag);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
 	return rc;
@@ -10275,22 +10275,47 @@ static int
 __lpfc_sli_issue_fcp_io_s4(struct lpfc_hba *phba, uint32_t ring_number,
 			   struct lpfc_iocbq *piocb, uint32_t flag)
 {
-	struct lpfc_sli_ring *pring;
-	struct lpfc_queue *eq;
-	unsigned long iflags;
 	int rc;
+	struct lpfc_io_buf *lpfc_cmd =
+		(struct lpfc_io_buf *)piocb->context1;
+	union lpfc_wqe128 *wqe = &piocb->wqe;
+	struct sli4_sge *sgl;
 
-	eq = phba->sli4_hba.hdwq[piocb->hba_wqidx].hba_eq;
+	/* 128 byte wqe support here */
+	sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
 
-	pring = lpfc_sli4_calc_ring(phba, piocb);
-	if (unlikely(pring == NULL))
-		return IOCB_ERROR;
+	if (phba->fcp_embed_io) {
+		struct fcp_cmnd *fcp_cmnd;
+		u32 *ptr;
 
-	spin_lock_irqsave(&pring->ring_lock, iflags);
-	rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
-	spin_unlock_irqrestore(&pring->ring_lock, iflags);
+		fcp_cmnd = lpfc_cmd->fcp_cmnd;
+
+		/* Word 0-2 - FCP_CMND */
+		wqe->generic.bde.tus.f.bdeFlags =
+			BUFF_TYPE_BDE_IMMED;
+		wqe->generic.bde.tus.f.bdeSize = sgl->sge_len;
+		wqe->generic.bde.addrHigh = 0;
+		wqe->generic.bde.addrLow =  88;  /* Word 22 */
 
-	lpfc_sli4_poll_eq(eq, LPFC_POLL_FASTPATH);
+		bf_set(wqe_wqes, &wqe->fcp_iwrite.wqe_com, 1);
+		bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 0);
+
+		/* Word 22-29  FCP CMND Payload */
+		ptr = &wqe->words[22];
+		memcpy(ptr, fcp_cmnd, sizeof(struct fcp_cmnd));
+	} else {
+		/* Word 0-2 - Inline BDE */
+		wqe->generic.bde.tus.f.bdeFlags =  BUFF_TYPE_BDE_64;
+		wqe->generic.bde.tus.f.bdeSize = sizeof(struct fcp_cmnd);
+		wqe->generic.bde.addrHigh = sgl->addr_hi;
+		wqe->generic.bde.addrLow =  sgl->addr_lo;
+
+		/* Word 10 */
+		bf_set(wqe_dbde, &wqe->generic.wqe_com, 1);
+		bf_set(wqe_wqes, &wqe->generic.wqe_com, 0);
+	}
+
+	rc = lpfc_sli4_issue_wqe(phba, lpfc_cmd->hdwq, piocb);
 	return rc;
 }
 
@@ -10360,9 +10385,10 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 				}
 			}
 		}
-	} else if (piocb->iocb_flag &  LPFC_IO_FCP)
+	} else if (piocb->iocb_flag &  LPFC_IO_FCP) {
 		/* These IO's already have an XRI and a mapped sgl. */
 		sglq = NULL;
+	}
 	else {
 		/*
 		 * This is a continuation of a commandi,(CX) so this
@@ -20468,7 +20494,8 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 	}
 
 	/* NVME_FCREQ and NVME_ABTS requests */
-	if (pwqe->iocb_flag & LPFC_IO_NVME) {
+	if (pwqe->iocb_flag & LPFC_IO_NVME ||
+	    pwqe->iocb_flag & LPFC_IO_FCP) {
 		/* Get the IO distribution (hba_wqidx) for WQ assignment. */
 		wq = qp->io_wq;
 		pring = wq->pring;
-- 
2.26.2


--000000000000a582af05b42a3f46
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQPwYJKoZIhvcNAQcCoIIQMDCCECwCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2UMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFQTCCBCmgAwIBAgIMfmKtsn6cI8G7HjzCMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTE3MDU0
NjI0WhcNMjIwOTE4MDU0NjI0WjCBjDELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRQwEgYDVQQDEwtKYW1l
cyBTbWFydDEnMCUGCSqGSIb3DQEJARYYamFtZXMuc21hcnRAYnJvYWRjb20uY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0B4Ym0dby5rc/1eyTwvNzsepN0S9eBGyF45ltfEmEmoe
sY3NAmThxJaLBzoPYjCpfPWh65cxrVIOw9R3a9TrkDN+aISE1NPyyHOabU57I8bKvfS8WMpCQKSJ
pDWUbzanP3MMP4C2qbJgQW+xh9UDzBi8u69f40kP+cLEPNJWbz0KxNNp7H/4zWNyTouJRtO6QKVh
XqR+mg0QW4TJlH5sJ7NIbVGZKzs0PEbUJJJw0zJsp3m0iS6AzNFtTGHWVO1me58DIYR/VDSiY9Sh
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg5F3BSVRC4+BsiDd+
VcYuyQ5ffwQ+Temal1Ou94AO2V0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNzEyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAMkzKMMHihFf9+ztQ6njZSpcg9rQ/xWSwogj
5Fod1zw7na9s/pkR/sU3fqtptkbXhVWs+L3o9vcqTLiufe3phDge7KQ+u/qHud3YjCQETawo0eir
1vzzNsOiHbC5KqcwKcFUqsKClxgDHcw5oK71vNfs4ZSxaZkFyxd1FOFRfsRz0uK/xJZRWlbVHbE1
Yyrc2o3+gK2y8yaFLPh8JnzqSaKL6O8AgBgN4f4FDJec6zzlwm9JIz/R1ZN670M6CpLcs6p69zBQ
AIIbPPodXecitv53PMiaLJIEWoTadLKgb0wipJwK0nnCKF3j/FIqiFPWAV3Lhl8FD/qlsY6o4A5s
cPw=
--000000000000a582af05b42a3f46--
