Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5E2C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92D8C61396
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229466AbhEMWjY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 18:39:24 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:40943 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbhEMWjW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 18:39:22 -0400
Received: by mail-pf1-f182.google.com with SMTP id x188so23001096pfd.7
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 15:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4q3FA50wBjx6d5PWtN3cGBmGZcfeCP+7EjnG+hxyEoU=;
        b=PtVZ2ZyVSeYVMuDEM0BIBE2EFs/TKGPdyDEP4oHV5+BLK6DNq/ZZ70ra3x/GIoVdWY
         3okf9d44u3YwlOd5XhRGDxvbMAl5vQ/MW1Xe8MCUabQkc3tzRqcVGOrw6au+bl75gKY2
         2O6qTiyf+TcDK7vMVDCR+ddiU2c0bbQoaaOwG7i4afqELhx57gGAFAUimBgJll0P6+OU
         oi6ImxFrC6KPOeG7BiLUackZRtuZWsPNJud/+i2TGAFaoIvR7Pf18FKM9VEL8YLKk55y
         DHEOOlK18IVIDDsGVH6ZebdlaqkXZWDRcNDFN/iWgz4P6Y4W+lsw8vergpFQCVvUbBB3
         iOoA==
X-Gm-Message-State: AOAM532wEhi6uqfYm4hMOmdu+EIuorQpIA0xXhoujVjNVxfktV9bu9Ly
        0mLwMMTDeW6PqercngAEqK5tQlurCVY=
X-Google-Smtp-Source: ABdhPJwgK+0aDLxRM4C/w9JYrTMynDp9eqfp4XSZXV65+WY/tulN6TSdcvCLW9UHlfoWHBk6MOVPkA==
X-Received: by 2002:a62:8fd2:0:b029:28e:8c64:52a4 with SMTP id n201-20020a628fd20000b029028e8c6452a4mr43066841pfd.3.1620945491629;
        Thu, 13 May 2021 15:38:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:54a8:4531:57a:cfd8])
        by smtp.gmail.com with ESMTPSA id j23sm2852582pfh.179.2021.05.13.15.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 15:38:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH v3 5/8] lpfc: Use scsi_get_sector() instead of scsi_get_lba()
Date:   Thu, 13 May 2021 15:37:54 -0700
Message-Id: <20210513223757.3938-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513223757.3938-1-bvanassche@acm.org>
References: <20210513223757.3938-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_sector() instead of scsi_get_lba() since the name of the
latter is confusing. This patch does not change any functionality.

Cc: James Smart <james.smart@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index eefbb9b22798..8c6b25807f12 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2963,7 +2963,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9059 BLKGRD: Guard Tag error in cmd"
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				(u64)scsi_get_sector(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -2980,7 +2980,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9060 BLKGRD: Ref Tag error in cmd"
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				(u64)scsi_get_sector(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -2997,7 +2997,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9062 BLKGRD: App Tag error in cmd"
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				(u64)scsi_get_sector(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -3028,7 +3028,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 			break;
 		}
 
-		failing_sector = scsi_get_lba(cmd);
+		failing_sector = scsi_get_sector(cmd);
 		failing_sector += bghm;
 
 		/* Descriptor Information */
@@ -3041,7 +3041,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9068 BLKGRD: Unknown error in cmd"
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				(u64)scsi_get_sector(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
@@ -3174,7 +3174,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 			break;
 		}
 
-		failing_sector = scsi_get_lba(cmd);
+		failing_sector = scsi_get_sector(cmd);
 		failing_sector += bghm;
 
 		/* Descriptor Information */
