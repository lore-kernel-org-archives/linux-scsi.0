Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB64C433B4
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D219613C5
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhEIVo1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 May 2021 17:44:27 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:40463 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhEIVo0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2021 17:44:26 -0400
Received: by mail-pf1-f178.google.com with SMTP id x188so12247903pfd.7
        for <linux-scsi@vger.kernel.org>; Sun, 09 May 2021 14:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8jH2Jxi9XojAxNVkKHEc9MTbyOFDVnZbcqlLKnfbM78=;
        b=LaGGIn8w0dB/IyVwZiZIq2eHopUwJzcg7YM0yjojKK81LgLU8s7dcjvFjAZZaOR0t8
         9fj9jBfl/S5tzgx/rG+4wc2OOdx1sk03JMeV9RWivnsiu4b5YaIEXhXq7klw8h6FlJRt
         fyLkXeRDfZIMX96/TtpZFqa+NqJzgToAHTCiZiNy4bfreAvmCoNfVoQJvM3c5GQsv7nm
         gZcTT3Z1JlDcGyGqk/pBtdYLSZwTancCi1+g6KHqul+CXnE5N4SSd2Ie49uv7wUtaDpy
         yy5wuZb+QZWIoqzOj2rEafdpUV0s+WFNXC2zAw7LeQmiTjyEcnsN0a/Y9CYR2wvQUOOr
         ZG1A==
X-Gm-Message-State: AOAM5311wKD+fThwVCjIDirkHfTwM6wrhBoY5ToDo4SMhVuf8XWqaLBX
        9wxyeVGXSoHhUisS/Nsc1tM=
X-Google-Smtp-Source: ABdhPJz868R0exg6ThxGdGgXvs+boL54oE2874XVm0/1oweFKXcFE6ObYnMyo191l9m/kCZ4XtmPZA==
X-Received: by 2002:aa7:8503:0:b029:27d:497f:1da6 with SMTP id v3-20020aa785030000b029027d497f1da6mr22370189pfn.28.1620596602336;
        Sun, 09 May 2021 14:43:22 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:1f3e:222f:39bb:cb2e])
        by smtp.gmail.com with ESMTPSA id t4sm9712567pfq.165.2021.05.09.14.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 14:43:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 5/7] qla2xxx: Use scsi_get_pos() instead of scsi_get_lba()
Date:   Sun,  9 May 2021 14:43:05 -0700
Message-Id: <20210509214307.4610-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509214307.4610-1-bvanassche@acm.org>
References: <20210509214307.4610-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_pos() instead of scsi_get_lba() since the name of the latter
is confusing. Additionally, use lower_32_bits() instead of open-coding it.
This patch does not change any functionality.

Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c   | 12 ++++++------
 drivers/scsi/qla2xxx/qla_iocb.c |  9 +++------
 drivers/scsi/qla2xxx/qla_isr.c  |  8 ++++----
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index eefbb9b22798..ebce57c7b742 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2963,7 +2963,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9059 BLKGRD: Guard Tag error in cmd"
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				(u64)scsi_get_pos(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -2980,7 +2980,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9060 BLKGRD: Ref Tag error in cmd"
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				(u64)scsi_get_pos(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -2997,7 +2997,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9062 BLKGRD: App Tag error in cmd"
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				(u64)scsi_get_pos(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -3028,7 +3028,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 			break;
 		}
 
-		failing_sector = scsi_get_lba(cmd);
+		failing_sector = scsi_get_pos(cmd);
 		failing_sector += bghm;
 
 		/* Descriptor Information */
@@ -3041,7 +3041,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9068 BLKGRD: Unknown error in cmd"
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				(u64)scsi_get_pos(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
@@ -3174,7 +3174,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 			break;
 		}
 
-		failing_sector = scsi_get_lba(cmd);
+		failing_sector = scsi_get_pos(cmd);
 		failing_sector += bghm;
 
 		/* Descriptor Information */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 38b5bdde2405..66e469890a7d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -778,8 +778,7 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_context *pkt,
 		 * No check for ql2xenablehba_err_chk, as it would be an
 		 * I/O error if hba tag generation is not done.
 		 */
-		pkt->ref_tag = cpu_to_le32((uint32_t)
-		    (0xffffffff & scsi_get_lba(cmd)));
+		pkt->ref_tag = cpu_to_le32(lower_32_bits(scsi_get_pos(cmd)));
 
 		if (!qla2x00_hba_err_chk_enabled(sp))
 			break;
@@ -799,8 +798,7 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_context *pkt,
 		pkt->app_tag_mask[0] = 0x0;
 		pkt->app_tag_mask[1] = 0x0;
 
-		pkt->ref_tag = cpu_to_le32((uint32_t)
-		    (0xffffffff & scsi_get_lba(cmd)));
+		pkt->ref_tag = cpu_to_le32(lower_32_bits(scsi_get_pos(cmd)));
 
 		if (!qla2x00_hba_err_chk_enabled(sp))
 			break;
@@ -824,8 +822,7 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_context *pkt,
 	 * 16 bit app tag.
 	 */
 	case SCSI_PROT_DIF_TYPE1:
-		pkt->ref_tag = cpu_to_le32((uint32_t)
-		    (0xffffffff & scsi_get_lba(cmd)));
+		pkt->ref_tag = cpu_to_le32(lower_32_bits(scsi_get_pos(cmd)));
 		pkt->app_tag = cpu_to_le16(0);
 		pkt->app_tag_mask[0] = 0x0;
 		pkt->app_tag_mask[1] = 0x0;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 67229af4c142..d6b405d71f45 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2632,7 +2632,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 	    "DIF ERROR in cmd 0x%x lba 0x%llx act ref"
 	    " tag=0x%x, exp ref_tag=0x%x, act app tag=0x%x, exp app"
 	    " tag=0x%x, act guard=0x%x, exp guard=0x%x.\n",
-	    cmd->cmnd[0], (u64)scsi_get_lba(cmd), a_ref_tag, e_ref_tag,
+	    cmd->cmnd[0], (u64)scsi_get_pos(cmd), a_ref_tag, e_ref_tag,
 	    a_app_tag, e_app_tag, a_guard, e_guard);
 
 	/*
@@ -2644,10 +2644,10 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 	    (scsi_get_prot_type(cmd) != SCSI_PROT_DIF_TYPE3 ||
 	     a_ref_tag == be32_to_cpu(T10_PI_REF_ESCAPE))) {
 		uint32_t blocks_done, resid;
-		sector_t lba_s = scsi_get_lba(cmd);
+		sector_t pos = scsi_get_pos(cmd);
 
 		/* 2TB boundary case covered automatically with this */
-		blocks_done = e_ref_tag - (uint32_t)lba_s + 1;
+		blocks_done = e_ref_tag - (uint32_t)pos + 1;
 
 		resid = scsi_bufflen(cmd) - (blocks_done *
 		    cmd->device->sector_size);
@@ -2677,7 +2677,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 			if (k != blocks_done) {
 				ql_log(ql_log_warn, vha, 0x302f,
 				    "unexpected tag values tag:lba=%x:%llx)\n",
-				    e_ref_tag, (unsigned long long)lba_s);
+				    e_ref_tag, (u64)pos);
 				return 1;
 			}
 
