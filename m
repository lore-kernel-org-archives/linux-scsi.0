Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36604C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D2E3610EA
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhEMWjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 18:39:25 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:38846 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbhEMWjX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 18:39:23 -0400
Received: by mail-pf1-f170.google.com with SMTP id k19so23024915pfu.5
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 15:38:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jnR4DC0GInW4O0dC8OWaA+yRYG0YljiNTsBIUHiO75k=;
        b=hStWdimjwTy/QD3HVCgmJUSeD+IA92jewK93iiHgAng4Hplrn4GKKP18GWe87vesdR
         Aj7/pcvi6mM1jjtVpVoBJvJXs9N+p+P3uzbE+Mdp8Hp8Go47i+R9xTTil9f4rO3mi3kf
         8IzoUX8028H7YbKAJTlxJ+J9KxwunlGLM3vHcpLTdQfvzP6g+afnl3JQUGTeeswLipLQ
         LwTkDEy6jvm1juCRil//0PLMtXFuDk7dYuua4dXX798M5DBqbJslPOLIcpt8R6GUV4YW
         XIypJn9fRlY+d8MuuUyql1rwKnT6CRZKumaP7wMVLwZAo7wS2eLJvVYnR41NgAkyyD2o
         CCnQ==
X-Gm-Message-State: AOAM533FXxlKClwvCUIxyaqrnTUo4i0+jqpT4zmwTyoD6vWiX5BCOfwB
        Exwh4UA4x8pm2LdW+jH4A768DGmvtB8=
X-Google-Smtp-Source: ABdhPJxtXenSxPIlpsBB+Cd14mmi15KzXfDc5L0BLNMhMfMDOcL0DL4yukGavan7M3OLi+mCPAkerA==
X-Received: by 2002:a62:8389:0:b029:27d:28f4:d583 with SMTP id h131-20020a6283890000b029027d28f4d583mr42939393pfe.33.1620945493094;
        Thu, 13 May 2021 15:38:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:54a8:4531:57a:cfd8])
        by smtp.gmail.com with ESMTPSA id j23sm2852582pfh.179.2021.05.13.15.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 15:38:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH v3 6/8] qla2xxx: Use scsi_get_sector() instead of scsi_get_lba()
Date:   Thu, 13 May 2021 15:37:55 -0700
Message-Id: <20210513223757.3938-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513223757.3938-1-bvanassche@acm.org>
References: <20210513223757.3938-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_sector() instead of scsi_get_lba() since the name of the
latter is confusing. Additionally, use lower_32_bits() instead of
open-coding it. This patch does not change any functionality.

Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 9 +++------
 drivers/scsi/qla2xxx/qla_isr.c  | 8 ++++----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 38b5bdde2405..28e30a7e8883 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -778,8 +778,7 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_context *pkt,
 		 * No check for ql2xenablehba_err_chk, as it would be an
 		 * I/O error if hba tag generation is not done.
 		 */
-		pkt->ref_tag = cpu_to_le32((uint32_t)
-		    (0xffffffff & scsi_get_lba(cmd)));
+		pkt->ref_tag = cpu_to_le32(lower_32_bits(scsi_get_sector(cmd)));
 
 		if (!qla2x00_hba_err_chk_enabled(sp))
 			break;
@@ -799,8 +798,7 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_context *pkt,
 		pkt->app_tag_mask[0] = 0x0;
 		pkt->app_tag_mask[1] = 0x0;
 
-		pkt->ref_tag = cpu_to_le32((uint32_t)
-		    (0xffffffff & scsi_get_lba(cmd)));
+		pkt->ref_tag = cpu_to_le32(lower_32_bits(scsi_get_sector(cmd)));
 
 		if (!qla2x00_hba_err_chk_enabled(sp))
 			break;
@@ -824,8 +822,7 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_context *pkt,
 	 * 16 bit app tag.
 	 */
 	case SCSI_PROT_DIF_TYPE1:
-		pkt->ref_tag = cpu_to_le32((uint32_t)
-		    (0xffffffff & scsi_get_lba(cmd)));
+		pkt->ref_tag = cpu_to_le32(lower_32_bits(scsi_get_sector(cmd)));
 		pkt->app_tag = cpu_to_le16(0);
 		pkt->app_tag_mask[0] = 0x0;
 		pkt->app_tag_mask[1] = 0x0;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 67229af4c142..24d406411f81 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2632,7 +2632,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 	    "DIF ERROR in cmd 0x%x lba 0x%llx act ref"
 	    " tag=0x%x, exp ref_tag=0x%x, act app tag=0x%x, exp app"
 	    " tag=0x%x, act guard=0x%x, exp guard=0x%x.\n",
-	    cmd->cmnd[0], (u64)scsi_get_lba(cmd), a_ref_tag, e_ref_tag,
+	    cmd->cmnd[0], (u64)scsi_get_sector(cmd), a_ref_tag, e_ref_tag,
 	    a_app_tag, e_app_tag, a_guard, e_guard);
 
 	/*
@@ -2644,10 +2644,10 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 	    (scsi_get_prot_type(cmd) != SCSI_PROT_DIF_TYPE3 ||
 	     a_ref_tag == be32_to_cpu(T10_PI_REF_ESCAPE))) {
 		uint32_t blocks_done, resid;
-		sector_t lba_s = scsi_get_lba(cmd);
+		sector_t sector = scsi_get_sector(cmd);
 
 		/* 2TB boundary case covered automatically with this */
-		blocks_done = e_ref_tag - (uint32_t)lba_s + 1;
+		blocks_done = e_ref_tag - (uint32_t)sector + 1;
 
 		resid = scsi_bufflen(cmd) - (blocks_done *
 		    cmd->device->sector_size);
@@ -2677,7 +2677,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 			if (k != blocks_done) {
 				ql_log(ql_log_warn, vha, 0x302f,
 				    "unexpected tag values tag:lba=%x:%llx)\n",
-				    e_ref_tag, (unsigned long long)lba_s);
+				    e_ref_tag, (u64)sector);
 				return 1;
 			}
 
