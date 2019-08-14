Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AD0C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C65B020866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="odNE4KX1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbfHNX5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:42 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32937 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbfHNX5l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:41 -0400
Received: by mail-pl1-f193.google.com with SMTP id go14so31681plb.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=75gZIP1Yyja0doBR7GHj0THP0A5NsQ6jnfcaoPjRzUE=;
        b=odNE4KX1ZR7kHecaNyK1FwRTWSnMCW5oH3o2I1vjIJhOLHoSC+/nQinbf6NYZU3A50
         C06GDxloanifNRhhFD8o4AdWexh1yHGx7oD/gd1t2KAv1xzfSeICijjVdk2raAlBbGn/
         XM6I26dGRTA8v6fpTDNy0bCLESH+cWGM+ju0B+CJpFEgrqt03MjSNR4TbyrE7Id4om/E
         gYtiWRMBC95ZjWmYzzDCPLVCiYnLKZ51IW3jOeoRj8GSmO8yBoOz3hnhM1N5EPB5rECt
         q4XzU+1jzY2OlQNd1Jjitwixq5exEu4/HaWiU3qN8DkOgLAmHXk4GiIyr/qVIPs8oTKM
         Gp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=75gZIP1Yyja0doBR7GHj0THP0A5NsQ6jnfcaoPjRzUE=;
        b=Yp6u5zBfZ25NXVe+oorEioq8AE9DgoWFYDoPaSba4Wsjr7+Dp/AJUt2ZJTgX61YnGA
         KNEpk7qBBW9jl2bFuO5dOprA9HaClqkAeTln/6fUttup9faLqd+CGIZF7wQvytJpAQJX
         yDxH4UJkNv7IczaXzWeCD7BRV51LZs3Opy+fc4QkzIWk8urmMM3MbnQbI4hHPCjbTa/K
         9xGBv8JYGNSTBc19PhI0hXxqceil29kMv+AdGZTdfgjGH9HUFgyyNXQx0vzYINNu481x
         xqf8o/aUbsF/bbJrz84whjLZD+PDWxDDnNz0cSxfdo9MyWffSVaoTcWiBxH3uIhV+0Jg
         fGrQ==
X-Gm-Message-State: APjAAAXi1QwEBTMwsHBYqUm1WIiKw708KjXX+zseg+/s8yIdObYMlL+W
        TvT6feTfWwBNymvY/Pu5icCUuy4h
X-Google-Smtp-Source: APXvYqwE0KOo0K/9uxNFP0er4OK585lrmE2IhO7Xvgp+q4Utb74d/o0dAU3YNf6u9idwokNZ+0NSUA==
X-Received: by 2002:a17:902:223:: with SMTP id 32mr1843249plc.220.1565827060757;
        Wed, 14 Aug 2019 16:57:40 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:40 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 24/42] lpfc: Fix too many sg segments spamming in kernel log
Date:   Wed, 14 Aug 2019 16:56:54 -0700
Message-Id: <20190814235712.4487-25-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This issue is specific to SLI-3 adapters, specifically when DIF
is used.

Once seen, this message floods the logs:
9064 BLKGRD: lpfc_scsi_prep_dma_buf_s3: Too many sg segments from
  dma_map_sg

The driver, upon detecting an error such as too many elements in an
sglist, misrepresents the error by treating it as a temporary resource
issue by returning MLQUEUE_HOST_BUSY.  In these cases, no retry will
fix it and it should have been a hard error. The repeated retry was
causing the spamming of the log.

As for the initial reason of why an I/O encountered this issue at all
is not clear as parameters set by the driver should have avoided this.
The dm1 multipath maintainer has been notified of the issue.

Fix by changing the return code for the dma mapping routines to indicate
cases that are not retryable and return DID_ERROR on those cases.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 79 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 720a98266986..8ae24500806e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -918,9 +918,10 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			       "dma_map_sg.  Config %d, seg_cnt %d\n",
 			       __func__, phba->cfg_sg_seg_cnt,
 			       lpfc_cmd->seg_cnt);
+			WARN_ON_ONCE(lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt);
 			lpfc_cmd->seg_cnt = 0;
 			scsi_dma_unmap(scsi_cmnd);
-			return 1;
+			return 2;
 		}
 
 		/*
@@ -2430,7 +2431,10 @@ lpfc_bg_scsi_adjust_dl(struct lpfc_hba *phba,
  *
  * This is the protection/DIF aware version of
  * lpfc_scsi_prep_dma_buf(). It may be a good idea to combine the
- * two functions eventually, but for now, it's here
+ * two functions eventually, but for now, it's here.
+ * RETURNS 0 - SUCCESS,
+ *         1 - Failed DMA map, retry.
+ *         2 - Invalid scsi cmd or prot-type. Do not rety.
  **/
 static int
 lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
@@ -2444,6 +2448,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 	int datasegcnt, protsegcnt, datadir = scsi_cmnd->sc_data_direction;
 	int prot_group_type = 0;
 	int fcpdl;
+	int ret = 1;
 	struct lpfc_vport *vport = phba->pport;
 
 	/*
@@ -2467,8 +2472,11 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 		lpfc_cmd->seg_cnt = datasegcnt;
 
 		/* First check if data segment count from SCSI Layer is good */
-		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt)
+		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
+			WARN_ON_ONCE(lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt);
+			ret = 2;
 			goto err;
+		}
 
 		prot_group_type = lpfc_prot_group_type(phba, scsi_cmnd);
 
@@ -2476,14 +2484,18 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 		case LPFC_PG_TYPE_NO_DIF:
 
 			/* Here we need to add a PDE5 and PDE6 to the count */
-			if ((lpfc_cmd->seg_cnt + 2) > phba->cfg_total_seg_cnt)
+			if ((lpfc_cmd->seg_cnt + 2) > phba->cfg_total_seg_cnt) {
+				ret = 2;
 				goto err;
+			}
 
 			num_bde = lpfc_bg_setup_bpl(phba, scsi_cmnd, bpl,
 					datasegcnt);
 			/* we should have 2 or more entries in buffer list */
-			if (num_bde < 2)
+			if (num_bde < 2) {
+				ret = 2;
 				goto err;
+			}
 			break;
 
 		case LPFC_PG_TYPE_DIF_BUF:
@@ -2507,15 +2519,19 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 			 * protection data segment.
 			 */
 			if ((lpfc_cmd->prot_seg_cnt * 4) >
-			    (phba->cfg_total_seg_cnt - 2))
+			    (phba->cfg_total_seg_cnt - 2)) {
+				ret = 2;
 				goto err;
+			}
 
 			num_bde = lpfc_bg_setup_bpl_prot(phba, scsi_cmnd, bpl,
 					datasegcnt, protsegcnt);
 			/* we should have 3 or more entries in buffer list */
 			if ((num_bde < 3) ||
-			    (num_bde > phba->cfg_total_seg_cnt))
+			    (num_bde > phba->cfg_total_seg_cnt)) {
+				ret = 2;
 				goto err;
+			}
 			break;
 
 		case LPFC_PG_TYPE_INVALID:
@@ -2526,7 +2542,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 					"9022 Unexpected protection group %i\n",
 					prot_group_type);
-			return 1;
+			return 2;
 		}
 	}
 
@@ -2576,7 +2592,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 
 	lpfc_cmd->seg_cnt = 0;
 	lpfc_cmd->prot_seg_cnt = 0;
-	return 1;
+	return ret;
 }
 
 /*
@@ -2962,7 +2978,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
  * field of @lpfc_cmd for device with SLI-4 interface spec.
  *
  * Return codes:
- *	1 - Error
+ *	2 - Error - Do not retry
+ *	1 - Error - Retry
  *	0 - Success
  **/
 static int
@@ -3012,9 +3029,10 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 				"dma_map_sg.  Config %d, seg_cnt %d\n",
 				__func__, phba->cfg_sg_seg_cnt,
 			       lpfc_cmd->seg_cnt);
+			WARN_ON_ONCE(lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt);
 			lpfc_cmd->seg_cnt = 0;
 			scsi_dma_unmap(scsi_cmnd);
-			return 1;
+			return 2;
 		}
 
 		/*
@@ -3110,6 +3128,10 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
  * This is the protection/DIF aware version of
  * lpfc_scsi_prep_dma_buf(). It may be a good idea to combine the
  * two functions eventually, but for now, it's here
+ * Return codes:
+ *	2 - Error - Do not retry
+ *	1 - Error - Retry
+ *	0 - Success
  **/
 static int
 lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
@@ -3123,6 +3145,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	int datasegcnt, protsegcnt, datadir = scsi_cmnd->sc_data_direction;
 	int prot_group_type = 0;
 	int fcpdl;
+	int ret = 1;
 	struct lpfc_vport *vport = phba->pport;
 
 	/*
@@ -3152,23 +3175,30 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 		lpfc_cmd->seg_cnt = datasegcnt;
 
 		/* First check if data segment count from SCSI Layer is good */
-		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt)
+		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
+			WARN_ON_ONCE(lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt);
+			ret = 2;
 			goto err;
+		}
 
 		prot_group_type = lpfc_prot_group_type(phba, scsi_cmnd);
 
 		switch (prot_group_type) {
 		case LPFC_PG_TYPE_NO_DIF:
 			/* Here we need to add a DISEED to the count */
-			if ((lpfc_cmd->seg_cnt + 1) > phba->cfg_total_seg_cnt)
+			if ((lpfc_cmd->seg_cnt + 1) > phba->cfg_total_seg_cnt) {
+				ret = 2;
 				goto err;
+			}
 
 			num_sge = lpfc_bg_setup_sgl(phba, scsi_cmnd, sgl,
 					datasegcnt);
 
 			/* we should have 2 or more entries in buffer list */
-			if (num_sge < 2)
+			if (num_sge < 2) {
+				ret = 2;
 				goto err;
+			}
 			break;
 
 		case LPFC_PG_TYPE_DIF_BUF:
@@ -3191,16 +3221,20 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 			 * protection data segment.
 			 */
 			if ((lpfc_cmd->prot_seg_cnt * 3) >
-			    (phba->cfg_total_seg_cnt - 2))
+			    (phba->cfg_total_seg_cnt - 2)) {
+				ret = 2;
 				goto err;
+			}
 
 			num_sge = lpfc_bg_setup_sgl_prot(phba, scsi_cmnd, sgl,
 					datasegcnt, protsegcnt);
 
 			/* we should have 3 or more entries in buffer list */
 			if ((num_sge < 3) ||
-			    (num_sge > phba->cfg_total_seg_cnt))
+			    (num_sge > phba->cfg_total_seg_cnt)) {
+				ret = 2;
 				goto err;
+			}
 			break;
 
 		case LPFC_PG_TYPE_INVALID:
@@ -3211,7 +3245,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 					"9083 Unexpected protection group %i\n",
 					prot_group_type);
-			return 1;
+			return 2;
 		}
 	}
 
@@ -3273,7 +3307,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 
 	lpfc_cmd->seg_cnt = 0;
 	lpfc_cmd->prot_seg_cnt = 0;
-	return 1;
+	return ret;
 }
 
 /**
@@ -4454,8 +4488,12 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 		err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
 	}
 
-	if (err)
+	if (err == 2) {
+		cmnd->result = DID_ERROR << 16;
+		goto out_fail_command_release_buf;
+	} else if (err) {
 		goto out_host_busy_free_buf;
+	}
 
 	lpfc_scsi_prep_cmnd(vport, lpfc_cmd, ndlp);
 
@@ -4526,6 +4564,9 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
  out_tgt_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
+ out_fail_command_release_buf:
+	lpfc_release_scsi_buf(phba, lpfc_cmd);
+
  out_fail_command:
 	cmnd->scsi_done(cmnd);
 	return 0;
-- 
2.13.7

