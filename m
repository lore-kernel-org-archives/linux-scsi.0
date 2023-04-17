Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE622C77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 19:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjDQTGV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 15:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjDQTGS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 15:06:18 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4171F5BA7
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:06:05 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b7b18a336so572544b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681758365; x=1684350365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FxCTlqIflmSxJx0SNE+LeDybU9chqbGt7VlLZobaq3w=;
        b=r77SXbILOsBQ/t1MhN4McAyh3i8nW4JqhnYLiTI3FiVYZ69gsaSp+KfnP3hCqpeeQM
         JfMbCAuOV70bE6K6P6KtMrwpS+ydfsngjM29jjGcs1/j1GZNqGZQlGajU3J2tCZH5Iu3
         6vIJ09t0PKrh0sMsFPZe6AJ3tiGdl4SZg0ll/YfCI5qMg7y2AHNCVseHyUBup4T7Fdhq
         7myvEN6iXiQo4rcukA3BQAUnywilkkgFkucsA/TAi5PstEWPbBOg0z4CCjSQBp63lHbC
         OhWOMfivP4G9L2zO2ZzWpcdiHQOLI2wT2gwIokN0vsDOAigha10j14uBpm8ssjtwT48B
         gcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758365; x=1684350365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FxCTlqIflmSxJx0SNE+LeDybU9chqbGt7VlLZobaq3w=;
        b=F3zbHh1kD0Q3BE6iORpAw0jSiHX8W+Ut73uLeiRPxZlLZKVNz3QX9/brg/4fcYEaix
         uxJ/smc43MGHMt1bxluV7Qe1SieSTEdVO5xBOA9bVO4ZFczxfx2t63JZ+J79W8G3x1na
         5sEN/Xue3nr2Vg9uidwsD81wKFth4xGelzkfiIFFdfpEmBIzoVYNioGFVg5bx61MAT/2
         QOJqE20OBjSAxkt+jek5FSlVmni4nkp8bfvVENHSe1FWjEezwVzEW3PxKj+5ASHNeqb8
         G3dLrZGXTmJPVXLjPfqb6OSubNvBUzgSUhh1qrCXWmAY1cLdDuTnQbB7n7PGc5noKkZ+
         7MQA==
X-Gm-Message-State: AAQBX9dghSelKj4uwMw3YoZQSVsEwYLtApCuCMWrXdlHtYeu1sbT87tg
        rWfmFd1bTGE9un40vW/vE9FQOP0X79E=
X-Google-Smtp-Source: AKy350aq/MKOGQo5ASGTrw8tsBsbedQhDHFPNCqcvXsN+37lTSz+6t5V9YiBZdUxbCPnXk/XRN8WqA==
X-Received: by 2002:a05:6a00:338f:b0:5e4:f141:568b with SMTP id cm15-20020a056a00338f00b005e4f141568bmr13298805pfb.3.1681758364788;
        Mon, 17 Apr 2023 12:06:04 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x18-20020aa793b2000000b0063b7c42a070sm4291439pff.68.2023.04.17.12.06.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Apr 2023 12:06:04 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 5/7] lpfc: Add new RCQE status for handling DMA failures
Date:   Mon, 17 Apr 2023 12:15:56 -0700
Message-Id: <20230417191558.83100-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230417191558.83100-1-justintee8345@gmail.com>
References: <20230417191558.83100-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A new RCQE status value indicating DMA failure when transferring
asynchronously received data to an RQE is introduced.  Such errors are
unexpected and handlers are updated to log KERN_ERR and dump lpfc's debug
trace buffer to kmsg.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h |  7 ++--
 drivers/scsi/lpfc/lpfc_sli.c | 64 ++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index a42811682ac7..082f8a109e55 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -536,9 +536,9 @@ struct sli4_wcqe_xri_aborted {
 /* completion queue entry structure for rqe completion */
 struct lpfc_rcqe {
 	uint32_t word0;
-#define lpfc_rcqe_bindex_SHIFT		16
-#define lpfc_rcqe_bindex_MASK		0x0000FFF
-#define lpfc_rcqe_bindex_WORD		word0
+#define lpfc_rcqe_iv_SHIFT		31
+#define lpfc_rcqe_iv_MASK		0x00000001
+#define lpfc_rcqe_iv_WORD		word0
 #define lpfc_rcqe_status_SHIFT		8
 #define lpfc_rcqe_status_MASK		0x000000FF
 #define lpfc_rcqe_status_WORD		word0
@@ -546,6 +546,7 @@ struct lpfc_rcqe {
 #define FC_STATUS_RQ_BUF_LEN_EXCEEDED 	0x11 /* payload truncated */
 #define FC_STATUS_INSUFF_BUF_NEED_BUF 	0x12 /* Insufficient buffers */
 #define FC_STATUS_INSUFF_BUF_FRM_DISC 	0x13 /* Frame Discard */
+#define FC_STATUS_RQ_DMA_FAILURE	0x14 /* DMA failure */
 	uint32_t word1;
 #define lpfc_rcqe_fcf_id_v1_SHIFT	0
 #define lpfc_rcqe_fcf_id_v1_MASK	0x0000003F
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 35b1d5d4079f..5f979daae9fc 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -14682,6 +14682,38 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		workposted = true;
 		break;
+	case FC_STATUS_RQ_DMA_FAILURE:
+		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+				"2564 RQE DMA Error x%x, x%08x x%08x x%08x "
+				"x%08x\n",
+				status, rcqe->word0, rcqe->word1,
+				rcqe->word2, rcqe->word3);
+
+		/* If IV set, no further recovery */
+		if (bf_get(lpfc_rcqe_iv, rcqe))
+			break;
+
+		/* recycle consumed resource */
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		lpfc_sli4_rq_release(hrq, drq);
+		dma_buf = lpfc_sli_hbqbuf_get(&phba->hbqs[0].hbq_buffer_list);
+		if (!dma_buf) {
+			hrq->RQ_no_buf_found++;
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			break;
+		}
+		hrq->RQ_rcv_buf++;
+		hrq->RQ_buf_posted--;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		lpfc_in_buf_free(phba, &dma_buf->dbuf);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+				"2565 Unexpected RQE Status x%x, w0-3 x%08x "
+				"x%08x x%08x x%08x\n",
+				status, rcqe->word0, rcqe->word1,
+				rcqe->word2, rcqe->word3);
+		break;
 	}
 out:
 	return workposted;
@@ -15203,6 +15235,38 @@ lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		hrq->RQ_no_posted_buf++;
 		/* Post more buffers if possible */
 		break;
+	case FC_STATUS_RQ_DMA_FAILURE:
+		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+				"2575 RQE DMA Error x%x, x%08x x%08x x%08x "
+				"x%08x\n",
+				status, rcqe->word0, rcqe->word1,
+				rcqe->word2, rcqe->word3);
+
+		/* If IV set, no further recovery */
+		if (bf_get(lpfc_rcqe_iv, rcqe))
+			break;
+
+		/* recycle consumed resource */
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		lpfc_sli4_rq_release(hrq, drq);
+		dma_buf = lpfc_sli_rqbuf_get(phba, hrq);
+		if (!dma_buf) {
+			hrq->RQ_no_buf_found++;
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			break;
+		}
+		hrq->RQ_rcv_buf++;
+		hrq->RQ_buf_posted--;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		lpfc_rq_buf_free(phba, &dma_buf->hbuf);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+				"2576 Unexpected RQE Status x%x, w0-3 x%08x "
+				"x%08x x%08x x%08x\n",
+				status, rcqe->word0, rcqe->word1,
+				rcqe->word2, rcqe->word3);
+		break;
 	}
 out:
 	return workposted;
-- 
2.38.0

