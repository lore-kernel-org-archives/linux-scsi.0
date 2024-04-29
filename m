Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E042190686
	for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 21:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714427893; cv=none; b=G1yvxLdrpc9WfahVrxRhLPncGdlbd8ZieUmSrvHL/1tD1kHpH7JPOnbRrM7OUOJMqpajp5ZNUn7KLdVSqluXyJUQ8L8gWA3qS9tY1YpyltRQlJaw0bOu5deBj8IaiRAB/QkEaWhWEth2yzt386wSV8MFSTaiEYbvlkJQ3n5vZ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714427893; c=relaxed/simple;
	bh=DwJij8zOxDZ13GNXAql7wOpuJaf5uRGPYEugVHDZTGU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FMa6GYrtumjF1QwfXjJjKyj+sg193u8j2MJuYj2niKaXBS5oLjavHB7/q+dnpXolRThLf8hEq8//4ATHMJSVKA9GmDQf+tmngYb3AIp4QvYFfb6yXdcyHK7pO4qDHrUxhxHCrL6B+HJoAcayuN1xZ0QxklY5EIoDEn8r8Edi8NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AemFzpeW; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AemFzpeW"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6a0deac228eso97926d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 14:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714427891; x=1715032691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6/FwonSSWBYgXyymPbR5K4q/DzuCuHaqGSiUxb8Gnw=;
        b=AemFzpeWRorS1Eb5yoh86RHZ7pdOpbL4DMIB+h5z12D6nflQka6EanZdKSRowhKLb/
         fwei6GUtfpW7ZlivLek1hqcsARf5ioJRMEUA7E59h61VHTpwdq+mcOQLsuu0wXjX/Foh
         hH7WFJwa3unMPMYU5qBxtQBwtOL2a1AwYkMBWJ6ZB2dTAMiwU1waLKRrH2cU+CNnXm7R
         T9WnTJB2Q0HiUzqyH3/MNJrXxJF+kIYi7H5djCoXOh3r9JDuCgfCmXYeE+tp3DFpYi/9
         fZk022IPsjOM0POBrBOtzD31FcSiGskL1YGRqAfS99a5oNTfSsSpXYI/aOrJMA3tun7l
         eIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714427891; x=1715032691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R6/FwonSSWBYgXyymPbR5K4q/DzuCuHaqGSiUxb8Gnw=;
        b=uWNIdwwffbpfS6HdeJGDDnWWUVj0UYSyg9dUxZwAKsFte1x4g9UrBECWYuL+q4YwDF
         2PnXwx8KjHaP5NaaKobrb2ayZhWQaoB+FhllSlMBbDCy/0B2o+zcUee7g7mli0+KhyRh
         92YxSKz7Gmn1yJp+FER99dHDYRjbKk3bMTJe/l/531/lcHt3pcmWjGDt3hSEmTeCzly+
         qzmJM9m+jaSdbcvQL/cb+Scg6RAa2IfshQO59Pq51N1SD6OpX35pMycifN7pDzYlQaU6
         jMbMX7Z9BDBb+cDtRcvnpR/cgmLgnoVhqtHASb0X+b5rx9VJHNzq8JMEUeyMr7aEGlyO
         Huow==
X-Gm-Message-State: AOJu0YxVoIKwL46oH79zddKW152VfX9SprxuTtuIeWkXC4UfNd1Ov31g
	6C/K83eVYXr+ZYlqLRcFtG2LyjEbW9Cq6A/hce4wTl13GtMq/aiCkluwLA==
X-Google-Smtp-Source: AGHT+IF80rstngPPyniPxzw6lPS7r7NWENMNghO6R+dnuNIRKaBWXu4ocBE4Sm0zSkiBY1qVz3pvfQ==
X-Received: by 2002:a05:6214:23ca:b0:696:b235:f39 with SMTP id hr10-20020a05621423ca00b00696b2350f39mr12772817qvb.6.1714427890677;
        Mon, 29 Apr 2024 14:58:10 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mh12-20020a056214564c00b006a0cc9ef675sm1528280qvb.16.2024.04.29.14.58.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2024 14:58:10 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 6/8] lpfc: Add support for 32 byte CDBs
Date: Mon, 29 Apr 2024 15:15:45 -0700
Message-Id: <20240429221547.6842-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240429221547.6842-1-justintee8345@gmail.com>
References: <20240429221547.6842-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver's I/O path is updated to support 32 byte CDBs.

Changes to accommodate 32 byte CDBs include:

- updating various size fields to allow for the larger 32 byte CDB
- starting the FCP command payload at an earlier offset in WQE submission
  to fit the 32 byte CDB
- redefining relevant structs to __le32/__be32 data types for proper cpu
  endianness macro usage

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  8 +++++
 drivers/scsi/lpfc/lpfc_init.c | 11 ++++---
 drivers/scsi/lpfc/lpfc_scsi.c | 57 +++++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_scsi.h | 30 +++++++++++++-----
 drivers/scsi/lpfc/lpfc_sli.c  | 12 ++++----
 5 files changed, 80 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 367e6b066d42..500253007b1d 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2146,6 +2146,14 @@ struct sli4_sge {	/* SLI-4 */
 	uint32_t sge_len;
 };
 
+struct sli4_sge_le {
+	__le32 addr_hi;
+	__le32 addr_lo;
+
+	__le32 word2;
+	__le32 sge_len;
+};
+
 struct sli4_hybrid_sgl {
 	struct list_head list_node;
 	struct sli4_sge *dma_sgl;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 10e8b8479ad9..e1dfa96c2a55 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4773,7 +4773,10 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	shost->max_id = LPFC_MAX_TARGET;
 	shost->max_lun = vport->cfg_max_luns;
 	shost->this_id = -1;
-	shost->max_cmd_len = 16;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		shost->max_cmd_len = LPFC_FCP_CDB_LEN_32;
+	else
+		shost->max_cmd_len = LPFC_FCP_CDB_LEN;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		if (!phba->cfg_fcp_mq_threshold ||
@@ -8231,7 +8234,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		 * our max amount and we need to limit lpfc_sg_seg_cnt
 		 * to minimize the risk of running out.
 		 */
-		phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd) +
+		phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd32) +
 				sizeof(struct fcp_rsp) + max_buf_size;
 
 		/* Total SGEs for scsi_sg_list and scsi_sg_prot_list */
@@ -8253,7 +8256,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		 * the FCP rsp, a SGE for each, and a SGE for up to
 		 * cfg_sg_seg_cnt data segments.
 		 */
-		phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd) +
+		phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd32) +
 				sizeof(struct fcp_rsp) +
 				((phba->cfg_sg_seg_cnt + extra) *
 				sizeof(struct sli4_sge));
@@ -8316,7 +8319,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	phba->lpfc_cmd_rsp_buf_pool =
 			dma_pool_create("lpfc_cmd_rsp_buf_pool",
 					&phba->pcidev->dev,
-					sizeof(struct fcp_cmnd) +
+					sizeof(struct fcp_cmnd32) +
 					sizeof(struct fcp_rsp),
 					i, 0);
 	if (!phba->lpfc_cmd_rsp_buf_pool) {
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f1255e7c0445..98ce9d97a225 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -600,7 +600,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 {
 	struct lpfc_io_buf *lpfc_cmd;
 	struct lpfc_sli4_hdw_queue *qp;
-	struct sli4_sge *sgl;
+	struct sli4_sge_le *sgl;
 	dma_addr_t pdma_phys_fcp_rsp;
 	dma_addr_t pdma_phys_fcp_cmd;
 	uint32_t cpu, idx;
@@ -651,23 +651,23 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	 * The balance are sg list bdes. Initialize the
 	 * first two and leave the rest for queuecommand.
 	 */
-	sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
+	sgl = (struct sli4_sge_le *)lpfc_cmd->dma_sgl;
 	pdma_phys_fcp_cmd = tmp->fcp_cmd_rsp_dma_handle;
 	sgl->addr_hi = cpu_to_le32(putPaddrHigh(pdma_phys_fcp_cmd));
 	sgl->addr_lo = cpu_to_le32(putPaddrLow(pdma_phys_fcp_cmd));
-	sgl->word2 = le32_to_cpu(sgl->word2);
-	bf_set(lpfc_sli4_sge_last, sgl, 0);
-	sgl->word2 = cpu_to_le32(sgl->word2);
-	sgl->sge_len = cpu_to_le32(sizeof(struct fcp_cmnd));
+	bf_set_le32(lpfc_sli4_sge_last, sgl, 0);
+	if (cmnd && cmnd->cmd_len > LPFC_FCP_CDB_LEN)
+		sgl->sge_len = cpu_to_le32(sizeof(struct fcp_cmnd32));
+	else
+		sgl->sge_len = cpu_to_le32(sizeof(struct fcp_cmnd));
+
 	sgl++;
 
 	/* Setup the physical region for the FCP RSP */
-	pdma_phys_fcp_rsp = pdma_phys_fcp_cmd + sizeof(struct fcp_cmnd);
+	pdma_phys_fcp_rsp = pdma_phys_fcp_cmd + sizeof(struct fcp_cmnd32);
 	sgl->addr_hi = cpu_to_le32(putPaddrHigh(pdma_phys_fcp_rsp));
 	sgl->addr_lo = cpu_to_le32(putPaddrLow(pdma_phys_fcp_rsp));
-	sgl->word2 = le32_to_cpu(sgl->word2);
-	bf_set(lpfc_sli4_sge_last, sgl, 1);
-	sgl->word2 = cpu_to_le32(sgl->word2);
+	bf_set_le32(lpfc_sli4_sge_last, sgl, 1);
 	sgl->sge_len = cpu_to_le32(sizeof(struct fcp_rsp));
 
 	if (lpfc_ndlp_check_qdepth(phba, ndlp)) {
@@ -2608,7 +2608,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 	iocb_cmd->ulpLe = 1;
 
 	fcpdl = lpfc_bg_scsi_adjust_dl(phba, lpfc_cmd);
-	fcp_cmnd->fcpDl = be32_to_cpu(fcpdl);
+	fcp_cmnd->fcpDl = cpu_to_be32(fcpdl);
 
 	/*
 	 * Due to difference in data length between DIF/non-DIF paths,
@@ -3225,14 +3225,18 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	 * explicitly reinitialized.
 	 * all iocb memory resources are reused.
 	 */
-	fcp_cmnd->fcpDl = cpu_to_be32(scsi_bufflen(scsi_cmnd));
+	if (scsi_cmnd->cmd_len > LPFC_FCP_CDB_LEN)
+		((struct fcp_cmnd32 *)fcp_cmnd)->fcpDl =
+				cpu_to_be32(scsi_bufflen(scsi_cmnd));
+	else
+		fcp_cmnd->fcpDl = cpu_to_be32(scsi_bufflen(scsi_cmnd));
 	/* Set first-burst provided it was successfully negotiated */
 	if (!test_bit(HBA_FCOE_MODE, &phba->hba_flag) &&
 	    vport->cfg_first_burst_size &&
 	    scsi_cmnd->sc_data_direction == DMA_TO_DEVICE) {
 		u32 init_len, total_len;
 
-		total_len = be32_to_cpu(fcp_cmnd->fcpDl);
+		total_len = scsi_bufflen(scsi_cmnd);
 		init_len = min(total_len, vport->cfg_first_burst_size);
 
 		/* Word 4 & 5 */
@@ -3420,7 +3424,10 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	}
 
 	fcpdl = lpfc_bg_scsi_adjust_dl(phba, lpfc_cmd);
-	fcp_cmnd->fcpDl = be32_to_cpu(fcpdl);
+	if (lpfc_cmd->pCmd->cmd_len > LPFC_FCP_CDB_LEN)
+		((struct fcp_cmnd32 *)fcp_cmnd)->fcpDl = cpu_to_be32(fcpdl);
+	else
+		fcp_cmnd->fcpDl = cpu_to_be32(fcpdl);
 
 	/* Set first-burst provided it was successfully negotiated */
 	if (!test_bit(HBA_FCOE_MODE, &phba->hba_flag) &&
@@ -3428,7 +3435,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	    scsi_cmnd->sc_data_direction == DMA_TO_DEVICE) {
 		u32 init_len, total_len;
 
-		total_len = be32_to_cpu(fcp_cmnd->fcpDl);
+		total_len = fcpdl;
 		init_len = min(total_len, vport->cfg_first_burst_size);
 
 		/* Word 4 & 5 */
@@ -3436,8 +3443,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 		wqe->fcp_iwrite.total_xfer_len = total_len;
 	} else {
 		/* Word 4 */
-		wqe->fcp_iwrite.total_xfer_len =
-			be32_to_cpu(fcp_cmnd->fcpDl);
+		wqe->fcp_iwrite.total_xfer_len = fcpdl;
 	}
 
 	/*
@@ -3894,7 +3900,10 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 			 fcprsp->rspInfo3);
 
 	scsi_set_resid(cmnd, 0);
-	fcpDl = be32_to_cpu(fcpcmd->fcpDl);
+	if (cmnd->cmd_len > LPFC_FCP_CDB_LEN)
+		fcpDl = be32_to_cpu(((struct fcp_cmnd32 *)fcpcmd)->fcpDl);
+	else
+		fcpDl = be32_to_cpu(fcpcmd->fcpDl);
 	if (resp_info & RESID_UNDER) {
 		scsi_set_resid(cmnd, be32_to_cpu(fcprsp->rspResId));
 
@@ -4723,6 +4732,14 @@ static int lpfc_scsi_prep_cmnd_buf_s4(struct lpfc_vport *vport,
 				bf_set(wqe_iod, &wqe->fcp_iread.wqe_com,
 				       LPFC_WQE_IOD_NONE);
 		}
+
+		/* Additional fcp cdb length field calculation.
+		 * LPFC_FCP_CDB_LEN_32 - normal 16 byte cdb length,
+		 * then divide by 4 for the word count.
+		 * shift 2 because of the RDDATA/WRDATA.
+		 */
+		if (scsi_cmnd->cmd_len > LPFC_FCP_CDB_LEN)
+			fcp_cmnd->fcpCntl3 |= 4 << 2;
 	} else {
 		/* From the icmnd template, initialize words 4 - 11 */
 		memcpy(&wqe->words[4], &lpfc_icmnd_cmd_template.words[4],
@@ -4743,7 +4760,7 @@ static int lpfc_scsi_prep_cmnd_buf_s4(struct lpfc_vport *vport,
 
 	 /* Word 3 */
 	bf_set(payload_offset_len, &wqe->fcp_icmd,
-	       sizeof(struct fcp_cmnd) + sizeof(struct fcp_rsp));
+	       sizeof(struct fcp_cmnd32) + sizeof(struct fcp_rsp));
 
 	/* Word 6 */
 	bf_set(wqe_ctxt_tag, &wqe->generic.wqe_com,
@@ -4798,7 +4815,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 	int_to_scsilun(lpfc_cmd->pCmd->device->lun,
 		       &lpfc_cmd->fcp_cmnd->fcp_lun);
 
-	ptr = &fcp_cmnd->fcpCdb[0];
+	ptr = &((struct fcp_cmnd32 *)fcp_cmnd)->fcpCdb[0];
 	memcpy(ptr, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
 	if (scsi_cmnd->cmd_len < LPFC_FCP_CDB_LEN) {
 		ptr += scsi_cmnd->cmd_len;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index eae56944f31b..e034a48124f5 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -24,6 +24,7 @@
 
 struct lpfc_hba;
 #define LPFC_FCP_CDB_LEN 16
+#define LPFC_FCP_CDB_LEN_32 32
 
 #define list_remove_head(list, entry, type, member)		\
 	do {							\
@@ -99,17 +100,11 @@ struct fcp_rsp {
 #define SNSCOD_BADCMD 0x20	/* sense code is byte 13 ([12]) */
 };
 
-struct fcp_cmnd {
-	struct scsi_lun  fcp_lun;
-
-	uint8_t fcpCntl0;	/* FCP_CNTL byte 0 (reserved) */
-	uint8_t fcpCntl1;	/* FCP_CNTL byte 1 task codes */
 #define  SIMPLE_Q        0x00
 #define  HEAD_OF_Q       0x01
 #define  ORDERED_Q       0x02
 #define  ACA_Q           0x04
 #define  UNTAGGED        0x05
-	uint8_t fcpCntl2;	/* FCP_CTL byte 2 task management codes */
 #define  FCP_ABORT_TASK_SET  0x02	/* Bit 1 */
 #define  FCP_CLEAR_TASK_SET  0x04	/* bit 2 */
 #define  FCP_BUS_RESET       0x08	/* bit 3 */
@@ -117,12 +112,31 @@ struct fcp_cmnd {
 #define  FCP_TARGET_RESET    0x20	/* bit 5 */
 #define  FCP_CLEAR_ACA       0x40	/* bit 6 */
 #define  FCP_TERMINATE_TASK  0x80	/* bit 7 */
-	uint8_t fcpCntl3;
 #define  WRITE_DATA      0x01	/* Bit 0 */
 #define  READ_DATA       0x02	/* Bit 1 */
 
+struct fcp_cmnd {
+	struct scsi_lun  fcp_lun;
+
+	uint8_t fcpCntl0;	/* FCP_CNTL byte 0 (reserved) */
+	uint8_t fcpCntl1;	/* FCP_CNTL byte 1 task codes */
+	uint8_t fcpCntl2;	/* FCP_CTL byte 2 task management codes */
+	uint8_t fcpCntl3;
+
 	uint8_t fcpCdb[LPFC_FCP_CDB_LEN]; /* SRB cdb field is copied here */
-	uint32_t fcpDl;		/* Total transfer length */
+	__be32 fcpDl;		/* Total transfer length */
+
+};
+struct fcp_cmnd32 {
+	struct scsi_lun  fcp_lun;
+
+	uint8_t fcpCntl0;	/* FCP_CNTL byte 0 (reserved) */
+	uint8_t fcpCntl1;	/* FCP_CNTL byte 1 task codes */
+	uint8_t fcpCntl2;	/* FCP_CTL byte 2 task management codes */
+	uint8_t fcpCntl3;
+
+	uint8_t fcpCdb[LPFC_FCP_CDB_LEN_32]; /* SRB cdb field is copied here */
+	__be32 fcpDl;		/* Total transfer length */
 
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7f373c0b7eb5..f475e7ece41a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10595,18 +10595,18 @@ lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			BUFF_TYPE_BDE_IMMED;
 		wqe->generic.bde.tus.f.bdeSize = sgl->sge_len;
 		wqe->generic.bde.addrHigh = 0;
-		wqe->generic.bde.addrLow =  88;  /* Word 22 */
+		wqe->generic.bde.addrLow =  72;  /* Word 18 */
 
 		bf_set(wqe_wqes, &wqe->fcp_iwrite.wqe_com, 1);
 		bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 0);
 
-		/* Word 22-29  FCP CMND Payload */
-		ptr = &wqe->words[22];
-		memcpy(ptr, fcp_cmnd, sizeof(struct fcp_cmnd));
+		/* Word 18-29  FCP CMND Payload */
+		ptr = &wqe->words[18];
+		memcpy(ptr, fcp_cmnd, sgl->sge_len);
 	} else {
 		/* Word 0-2 - Inline BDE */
 		wqe->generic.bde.tus.f.bdeFlags =  BUFF_TYPE_BDE_64;
-		wqe->generic.bde.tus.f.bdeSize = sizeof(struct fcp_cmnd);
+		wqe->generic.bde.tus.f.bdeSize = sgl->sge_len;
 		wqe->generic.bde.addrHigh = sgl->addr_hi;
 		wqe->generic.bde.addrLow =  sgl->addr_lo;
 
@@ -22469,7 +22469,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 		}
 
 		tmp->fcp_rsp = (struct fcp_rsp *)((uint8_t *)tmp->fcp_cmnd +
-				sizeof(struct fcp_cmnd));
+				sizeof(struct fcp_cmnd32));
 
 		spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 		list_add_tail(&tmp->list_node, &lpfc_buf->dma_cmd_rsp_list);
-- 
2.38.0

