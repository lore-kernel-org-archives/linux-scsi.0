Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5B41AC891
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 23:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045296; cv=none; b=XSHkPSy2UT7q3mfM3IOl943TNxwwIoeO1el0VefHjihWeSHFVi5z5HMVgz6p6G3EQDYzBycmlRBZAELAo9tMtS8FNzDhVkJVUNq06ZAdJq7b7+B0fVt0pOo+k9H3+Z73qJ6LqyMdOYtlZ2/Rifp4GcqiV57uX0RyjGzkHF413kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045296; c=relaxed/simple;
	bh=MporgaBP+YT4H5zMS/tYt2U7ssQT/oZfKZFIr3IujkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LqEggE0AMsnq+aQwf3V2kKIAM/5KyuNnVAsxA6uwxyc/F5FxHXCnhgIt0l0mrUSogKJ6vZz1e1ER9fl1OizyuXzCzU9BeSg+2NfQSXHf7PIka0tAjG2VcwQscHtqXJ0Bel657RNYasyo7s4kCepXXAU47/jeuKsxeTnu0RiGlPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bv2RVTW6; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bv2RVTW6"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2166651f752so12493965ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 15:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734045294; x=1734650094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YR8SiEdVaIQ47sGhV1TV0vxBfohKg5TKJO+4RTaj1uU=;
        b=bv2RVTW6mh4W+ByWjvvy80zR4tM2scpnzZkISEwuAHVkT71gb6J5XDGNiRfUdi2O18
         3pp7Kjj5k0CcJXassOhJTIjXPKhPJzI0+0ndnIK4VN2SKJ6r9bt9id19R26pUDaUewtV
         +C7CQ1ZemS3JdYuJ36mfiCcuM8YLCEmZ4YPZbyJwYC8vFbwYy6THmw7gyFWEJPocaRF/
         QTFaTBsoy1RoVo2S2uWlJeZ0wV7UsDv4Uf+VjhruIt9n79RCQtLXtwkUSsxscukitOAX
         HwyQSp0CAT1ukmDszRe+BoXXcQHdqAX8q4WspLs/lNKjhKbRcluRpiVdCfXMasFv75l3
         FNzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734045294; x=1734650094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YR8SiEdVaIQ47sGhV1TV0vxBfohKg5TKJO+4RTaj1uU=;
        b=mlKa635rEMqvkRnroBWxXnofgTEp5rs+n4tIQ/Kq7KhdImVJrx9a7KUycMW7pl5Jnn
         U/yFdbzUXK2o3idL7x2hB/eQJbcMzg6pDXgpJhAfQqAHJdrFvGN5IOkAnJ5kHvNOBPte
         OaZNlpZ2F+NRBLHllFHL9FVqkkPOOh4M42ac6RCYvHMIxt0nODZ44EkIf/eyoUk/o5DP
         /Zt0b8dXr2zQq1iUd5wmQ1adW3WjGGh1ZM88unciajLqKoew25XLIzvzlRyhqtsiHLvX
         +LA/81vW7d98wh9Qe5LFWQcf8xrsvn5CnUmiPdc7ikukm5k4KwFKPlqK+yRbuJTEr74j
         ltyA==
X-Gm-Message-State: AOJu0YyU9+Jq9gw4FQymo0toFJVkSs5n410ateKGLXNj5DmmmJ3QimPr
	cKguUjOkgyGuD380kbUpqIgiZWo0ERfigjSr8lddwmzHHZVJDqIqq7DhOg==
X-Gm-Gg: ASbGncv9LJOarQY5zGM7QU38Hleo+y/SCjbjtx2Z4BZ3yM+tKeJlMu6SKTvXfkWk9ri
	GUwrjEZi2fjH/gMFwvPzS1rCTp5B+NjTasq6dlFHaIZos2JWlCOsgsnhfLSd+OWLrh9NN+CgLBc
	zmSrVqoQstt5E9RJ8AAhcHNjwU/WRJjQxMG0T2GICfjr1Jvo242ilV1YEAJQ851++7PEpWl/6GS
	P5ZU0UxJG2DgXaUPNtH4RAdwIdYlaW7uWQ3jSTMVN2NKYCGOXrID0BcmgxhvU4iX824DxuvVfk9
	Pu3bZJFC6DdL3WoQu5OghgEqe4zwBI7vvqNAp8FBPg==
X-Google-Smtp-Source: AGHT+IFgKRxO2GhTbaLE+zBhw9CNxUKNs3qR281skEOT6PN1p1NuRO0TwyJaubOz9rZTVITGTiljZg==
X-Received: by 2002:a17:902:ced0:b0:216:668d:690c with SMTP id d9443c01a7336-21892a01d38mr8202805ad.28.1734045293764;
        Thu, 12 Dec 2024 15:14:53 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216325f51d6sm92727875ad.197.2024.12.12.15.14.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2024 15:14:53 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 08/10] lpfc: Add support for large fw object application layer reads
Date: Thu, 12 Dec 2024 15:33:07 -0800
Message-Id: <20241212233309.71356-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241212233309.71356-1-justintee8345@gmail.com>
References: <20241212233309.71356-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current lpfc bsg implementation allows a maximum fw read object size of
30KB.  Implementation and support for read object mailbox commands for fw
objects larger than 30KB are now required for proprietary applications.

Thus, update the lpfc_sli_config_emb0_subsys structure and its associated
submission and completion paths to accommodate for an alternative form of
read object command that supports large fw objects.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c  | 210 ++++++++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_bsg.h  |  17 ++-
 drivers/scsi/lpfc/lpfc_scsi.c |   6 +
 3 files changed, 224 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 1c6b024160da..c8f8496bbdf8 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -120,6 +120,16 @@ enum ELX_LOOPBACK_CMD {
 #define ELX_LOOPBACK_HEADER_SZ \
 	(size_t)(&((struct lpfc_sli_ct_request *)NULL)->un)
 
+/* For non-embedded read object command */
+#define READ_OBJ_EMB0_SCHEME_0 {1, 10, 256, 128}
+#define READ_OBJ_EMB0_SCHEME_1 {11, LPFC_EMB0_MAX_RD_OBJ_HBD_CNT, 512, 192}
+static const struct lpfc_read_object_cmd_scheme {
+	u32 min_hbd_cnt;
+	u32 max_hbd_cnt;
+	u32 cmd_size;
+	u32 payload_word_offset;
+}  rd_obj_scheme[2] = {READ_OBJ_EMB0_SCHEME_0, READ_OBJ_EMB0_SCHEME_1};
+
 struct lpfc_dmabufext {
 	struct lpfc_dmabuf dma;
 	uint32_t size;
@@ -3538,6 +3548,103 @@ lpfc_bsg_mbox_ext_session_reset(struct lpfc_hba *phba)
 	return;
 }
 
+/**
+ * lpfc_rd_obj_emb0_handle_job - Handles completion for non-embedded
+ *                               READ_OBJECT_V0 mailbox commands
+ * @phba: pointer to lpfc_hba data struct
+ * @pmb_buf: pointer to mailbox buffer
+ * @sli_cfg_mbx: pointer to SLI_CONFIG mailbox memory region
+ * @job: pointer to bsg_job struct
+ * @bsg_reply: point to bsg_reply struct
+ *
+ * Given a non-embedded READ_OBJECT_V0's HBD_CNT, this routine copies
+ * a READ_OBJECT_V0 mailbox command's read data payload into a bsg_job
+ * structure for passing back to application layer.
+ *
+ * Return codes
+ *      0 - successful
+ *      -EINVAL - invalid HBD_CNT
+ *      -ENODEV - pointer to bsg_job struct is NULL
+ **/
+static int
+lpfc_rd_obj_emb0_handle_job(struct lpfc_hba *phba, u8 *pmb_buf,
+			    struct lpfc_sli_config_mbox *sli_cfg_mbx,
+			    struct bsg_job *job,
+			    struct fc_bsg_reply *bsg_reply)
+{
+	struct lpfc_dmabuf *curr_dmabuf, *next_dmabuf;
+	struct lpfc_sli_config_emb0_subsys *emb0_subsys;
+	u32 hbd_cnt;
+	u32 dma_buf_len;
+	u8 i = 0;
+	size_t extra_bytes;
+	off_t skip = 0;
+
+	if (!job) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
+				"2496 NULL job\n");
+		return -ENODEV;
+	}
+
+	if (!bsg_reply) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
+				"2498 NULL bsg_reply\n");
+		return -ENODEV;
+	}
+
+	emb0_subsys = &sli_cfg_mbx->un.sli_config_emb0_subsys;
+
+	hbd_cnt = bsg_bf_get(lpfc_emb0_subcmnd_rd_obj_hbd_cnt,
+			     emb0_subsys);
+
+	/* Calculate where the read object's read data payload is located based
+	 * on HBD count scheme.
+	 */
+	if (hbd_cnt >= rd_obj_scheme[0].min_hbd_cnt &&
+	    hbd_cnt <= rd_obj_scheme[0].max_hbd_cnt) {
+		skip = rd_obj_scheme[0].payload_word_offset * 4;
+	} else if (hbd_cnt >= rd_obj_scheme[1].min_hbd_cnt &&
+		   hbd_cnt <= rd_obj_scheme[1].max_hbd_cnt) {
+		skip = rd_obj_scheme[1].payload_word_offset * 4;
+	} else {
+		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
+				"2497 bad hbd_count 0x%08x\n",
+				hbd_cnt);
+		return -EINVAL;
+	}
+
+	/* Copy SLI_CONFIG command and READ_OBJECT response first */
+	bsg_reply->reply_payload_rcv_len =
+		sg_copy_from_buffer(job->reply_payload.sg_list,
+				    job->reply_payload.sg_cnt,
+				    pmb_buf, skip);
+
+	/* Copy data from hbds */
+	list_for_each_entry_safe(curr_dmabuf, next_dmabuf,
+				 &phba->mbox_ext_buf_ctx.ext_dmabuf_list,
+				 list) {
+		dma_buf_len = emb0_subsys->hbd[i].buf_len;
+
+		/* Use sg_copy_buffer to specify a skip offset */
+		extra_bytes = sg_copy_buffer(job->reply_payload.sg_list,
+					     job->reply_payload.sg_cnt,
+					     curr_dmabuf->virt,
+					     dma_buf_len, skip, false);
+
+		bsg_reply->reply_payload_rcv_len += extra_bytes;
+
+		skip += extra_bytes;
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
+				"2499 copied hbd[%d] "
+				"0x%zx bytes\n",
+				i, extra_bytes);
+		i++;
+	}
+
+	return 0;
+}
+
 /**
  * lpfc_bsg_issue_mbox_ext_handle_job - job handler for multi-buffer mbox cmpl
  * @phba: Pointer to HBA context object.
@@ -3551,10 +3658,10 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct bsg_job_data *dd_data;
 	struct bsg_job *job;
-	struct fc_bsg_reply *bsg_reply;
+	struct fc_bsg_reply *bsg_reply = NULL;
 	uint8_t *pmb, *pmb_buf;
 	unsigned long flags;
-	uint32_t size;
+	u32 size, opcode;
 	int rc = 0;
 	struct lpfc_dmabuf *dmabuf;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
@@ -3591,6 +3698,24 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 		lpfc_sli_pcimem_bcopy(&pmbx[sizeof(MAILBOX_t)],
 			&pmbx[sizeof(MAILBOX_t)],
 			sli_cfg_mbx->un.sli_config_emb0_subsys.mse[0].buf_len);
+
+		/* Special handling for non-embedded READ_OBJECT */
+		opcode = bsg_bf_get(lpfc_emb0_subcmnd_opcode,
+				    &sli_cfg_mbx->un.sli_config_emb0_subsys);
+		switch (opcode) {
+		case COMN_OPCODE_READ_OBJECT:
+			if (job) {
+				rc = lpfc_rd_obj_emb0_handle_job(phba, pmb_buf,
+								 sli_cfg_mbx,
+								 job,
+								 bsg_reply);
+				bsg_reply->result = rc;
+				goto done;
+			}
+			break;
+		default:
+			break;
+		}
 	}
 
 	/* Complete the job if the job is still active */
@@ -3604,12 +3729,14 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 
 		/* result for successful */
 		bsg_reply->result = 0;
+done:
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 				"2937 SLI_CONFIG ext-buffer mailbox command "
 				"(x%x/x%x) complete bsg job done, bsize:%d\n",
 				phba->mbox_ext_buf_ctx.nembType,
-				phba->mbox_ext_buf_ctx.mboxType, size);
+				phba->mbox_ext_buf_ctx.mboxType,
+				job->reply_payload.payload_len);
 		lpfc_idiag_mbxacc_dump_bsg_mbox(phba,
 					phba->mbox_ext_buf_ctx.nembType,
 					phba->mbox_ext_buf_ctx.mboxType,
@@ -3819,14 +3946,16 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
+	struct lpfc_sli_config_emb0_subsys *emb0_subsys;
+	struct list_head *ext_dmabuf_list;
 	struct dfc_mbox_req *mbox_req;
 	struct lpfc_dmabuf *curr_dmabuf, *next_dmabuf;
-	uint32_t ext_buf_cnt, ext_buf_index;
+	u32 ext_buf_cnt, ext_buf_index, hbd_cnt;
 	struct lpfc_dmabuf *ext_dmabuf = NULL;
 	struct bsg_job_data *dd_data = NULL;
 	LPFC_MBOXQ_t *pmboxq = NULL;
 	MAILBOX_t *pmb;
-	uint8_t *pmbx;
+	u8 *pmbx, opcode;
 	int rc, i;
 
 	mbox_req =
@@ -3836,8 +3965,9 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 	sli_cfg_mbx = (struct lpfc_sli_config_mbox *)dmabuf->virt;
 
 	if (nemb_tp == nemb_mse) {
+		emb0_subsys = &sli_cfg_mbx->un.sli_config_emb0_subsys;
 		ext_buf_cnt = bsg_bf_get(lpfc_mbox_hdr_mse_cnt,
-			&sli_cfg_mbx->un.sli_config_emb0_subsys.sli_config_hdr);
+			&emb0_subsys->sli_config_hdr);
 		if (ext_buf_cnt > LPFC_MBX_SLI_CONFIG_MAX_MSE) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
 					"2945 Handled SLI_CONFIG(mse) rd, "
@@ -3847,6 +3977,57 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 			rc = -ERANGE;
 			goto job_error;
 		}
+
+		/* Special handling for non-embedded READ_OBJECT */
+		opcode = bsg_bf_get(lpfc_emb0_subcmnd_opcode, emb0_subsys);
+		switch (opcode) {
+		case COMN_OPCODE_READ_OBJECT:
+			hbd_cnt = bsg_bf_get(lpfc_emb0_subcmnd_rd_obj_hbd_cnt,
+					     emb0_subsys);
+			lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
+					"2449 SLI_CONFIG(mse) rd non-embedded "
+					"hbd count = %d\n",
+					hbd_cnt);
+
+			ext_dmabuf_list =
+					&phba->mbox_ext_buf_ctx.ext_dmabuf_list;
+
+			/* Allocate hbds */
+			for (i = 0; i < hbd_cnt; i++) {
+				ext_dmabuf = lpfc_bsg_dma_page_alloc(phba);
+				if (!ext_dmabuf) {
+					rc = -ENOMEM;
+					goto job_error;
+				}
+				list_add_tail(&ext_dmabuf->list,
+					      ext_dmabuf_list);
+			}
+
+			/* Fill out the physical memory addresses for the
+			 * hbds
+			 */
+			i = 0;
+			list_for_each_entry_safe(curr_dmabuf, next_dmabuf,
+						 ext_dmabuf_list, list) {
+				emb0_subsys->hbd[i].pa_hi =
+					putPaddrHigh(curr_dmabuf->phys);
+				emb0_subsys->hbd[i].pa_lo =
+					putPaddrLow(curr_dmabuf->phys);
+
+				lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
+						"2495 SLI_CONFIG(hbd)[%d], "
+						"bufLen:%d, addrHi:x%x, "
+						"addrLo:x%x\n", i,
+						emb0_subsys->hbd[i].buf_len,
+						emb0_subsys->hbd[i].pa_hi,
+						emb0_subsys->hbd[i].pa_lo);
+				i++;
+			}
+			break;
+		default:
+			break;
+		}
+
 		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 				"2941 Handled SLI_CONFIG(mse) rd, "
 				"ext_buf_cnt:%d\n", ext_buf_cnt);
@@ -4223,6 +4404,7 @@ lpfc_bsg_handle_sli_cfg_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 			case COMN_OPCODE_GET_CNTL_ATTRIBUTES:
 			case COMN_OPCODE_GET_PROFILE_CONFIG:
 			case COMN_OPCODE_SET_FEATURES:
+			case COMN_OPCODE_READ_OBJECT:
 				lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 						"3106 Handled SLI_CONFIG "
 						"subsys_comn, opcode:x%x\n",
@@ -4665,8 +4847,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	bsg_reply->reply_payload_rcv_len = 0;
 
 	/* sanity check to protect driver */
-	if (job->reply_payload.payload_len > BSG_MBOX_SIZE ||
-	    job->request_payload.payload_len > BSG_MBOX_SIZE) {
+	if (job->request_payload.payload_len > BSG_MBOX_SIZE) {
 		rc = -ERANGE;
 		goto job_done;
 	}
@@ -4737,6 +4918,19 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	pmb->mbxOwner = OWN_HOST;
 	pmboxq->vport = vport;
 
+	/* non-embedded SLI_CONFIG requests already parsed, check others */
+	if (unlikely(job->reply_payload.payload_len > BSG_MBOX_SIZE)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"2729 Cmd x%x (x%x/x%x) request has "
+				"out-of-range reply payload length x%x\n",
+				pmb->mbxCommand,
+				lpfc_sli_config_mbox_subsys_get(phba, pmboxq),
+				lpfc_sli_config_mbox_opcode_get(phba, pmboxq),
+				job->reply_payload.payload_len);
+		rc = -ERANGE;
+		goto job_done;
+	}
+
 	/* If HBA encountered an error attention, allow only DUMP
 	 * or RESTART mailbox commands until the HBA is restarted.
 	 */
diff --git a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
index 3c04ca2d7455..86d509f669f1 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.h
+++ b/drivers/scsi/lpfc/lpfc_bsg.h
@@ -239,12 +239,27 @@ struct lpfc_sli_config_emb0_subsys {
 	uint32_t timeout;		/* comn_set_feature timeout */
 	uint32_t request_length;	/* comn_set_feature request len */
 	uint32_t version;		/* comn_set_feature version */
-	uint32_t csf_feature;		/* comn_set_feature feature */
+	uint32_t word68;		/* comn_set_feature feature */
+#define lpfc_emb0_subcmnd_csf_feat_SHIFT		0
+#define lpfc_emb0_subcmnd_csf_feat_MASK			0xffffffff
+#define lpfc_emb0_subcmnd_csf_feat_WORD			word68
+#define lpfc_emb0_subcmnd_rd_obj_des_rd_len_SHIFT	0
+#define lpfc_emb0_subcmnd_rd_obj_des_rd_len_MASK	0x00ffffff
+#define lpfc_emb0_subcmnd_rd_obj_des_rd_len_WORD	word68
 	uint32_t word69;		/* comn_set_feature parameter len */
 	uint32_t word70;		/* comn_set_feature parameter val0 */
 #define lpfc_emb0_subcmnd_csf_p0_SHIFT	0
 #define lpfc_emb0_subcmnd_csf_p0_MASK	0x3
 #define lpfc_emb0_subcmnd_csf_p0_WORD	word70
+	uint32_t reserved71[25];
+	uint32_t word96;		/* rd_obj hbd_count */
+#define lpfc_emb0_subcmnd_rd_obj_hbd_cnt_SHIFT	0
+#define lpfc_emb0_subcmnd_rd_obj_hbd_cnt_MASK	0xffffffff
+#define lpfc_emb0_subcmnd_rd_obj_hbd_cnt_WORD	word96
+#define LPFC_EMB0_MAX_RD_OBJ_HBD_CNT		31
+	struct lpfc_sli_config_hbd hbd[LPFC_EMB0_MAX_RD_OBJ_HBD_CNT];
+	uint32_t word190;
+	uint32_t word191;
 };
 
 struct lpfc_sli_config_emb1_subsys {
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 5ba3d4f32e1d..055ed632c14d 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5136,6 +5136,12 @@ lpfc_info(struct Scsi_Host *host)
 				goto buffer_done;
 		}
 
+		/* Support for BSG ioctls */
+		scnprintf(tmp, sizeof(tmp), " BSG");
+		if (strlcat(lpfcinfobuf, tmp, sizeof(lpfcinfobuf)) >=
+		    sizeof(lpfcinfobuf))
+			goto buffer_done;
+
 		/* PCI resettable */
 		if (!lpfc_check_pci_resettable(phba)) {
 			scnprintf(tmp, sizeof(tmp), " PCI resettable");
-- 
2.38.0

