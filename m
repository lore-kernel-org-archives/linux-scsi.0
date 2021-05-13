Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBC4C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0039A613CD
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhEMWjY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 18:39:24 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:52113 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhEMWjV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 18:39:21 -0400
Received: by mail-pj1-f49.google.com with SMTP id k5so4693624pjj.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 15:38:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G1uH0Qqhl+VItQLjiPAhxwr5Xmm1kr0yUknPMfVM2WY=;
        b=NSPKwcJwR2RoPdrW5zfYwunvYSxphBANV6jCpkAyIc95JjCnCzdYwJPuQSEDehjOa4
         Fi2FfEMvTvOPkwRfwWUUECvENfilCcUBsbg98eeYuDecCHsbKKrD38X/NVNACS/pR7Rj
         K8HcnmICfs0HuYUhUvuV6OfqaxzeoLGtOICUXwdzhpmbhJ4/CKsCMXDyx0WUCRI1OHtO
         wkjALCinOMbC4oANn4X+opvrpWXrq/L1LhGdwctItpxdxK0fniwObIHVmMnMY2i7GQ7K
         soOAl8Uq72YGeJfB4v9xzUTVdTaIcqXW7HgjDpf8/CxqVelsjQxE74j/5/wkJqDAqTGQ
         BE2Q==
X-Gm-Message-State: AOAM530z+2X6zbgKH+BUf11GVRnfwtXWJjOXZmG5vv0L3jbO3lvu4Fnw
        bOLQkgHQkIHX54uW3FfGZ7M=
X-Google-Smtp-Source: ABdhPJxwzdGTiqMbMHw8kyM4WAb8zOAAdGnuyQ0di0+g4Lfh1Nx8yBptv27VJqBTqpsJc/jvVEoVSw==
X-Received: by 2002:a17:90a:b796:: with SMTP id m22mr47808240pjr.220.1620945490295;
        Thu, 13 May 2021 15:38:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:54a8:4531:57a:cfd8])
        by smtp.gmail.com with ESMTPSA id j23sm2852582pfh.179.2021.05.13.15.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 15:38:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncan@suse.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v3 4/8] isci: Use scsi_get_sector() instead of scsi_get_lba()
Date:   Thu, 13 May 2021 15:37:53 -0700
Message-Id: <20210513223757.3938-5-bvanassche@acm.org>
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

Reviewed-by: Lee Duncan <lduncan@suse.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/isci/request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index e7c6cb4c1556..ad24ddbcaea3 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -341,7 +341,7 @@ static void scu_ssp_ireq_dif_insert(struct isci_request *ireq, u8 type, u8 op)
 	tc->reserved_E8_0 = 0;
 
 	if ((type & SCSI_PROT_DIF_TYPE1) || (type & SCSI_PROT_DIF_TYPE2))
-		tc->ref_tag_seed_gen = scsi_get_lba(scmd) & 0xffffffff;
+		tc->ref_tag_seed_gen = lower_32_bits(scsi_get_sector(scmd));
 	else if (type & SCSI_PROT_DIF_TYPE3)
 		tc->ref_tag_seed_gen = 0;
 }
@@ -369,7 +369,7 @@ static void scu_ssp_ireq_dif_strip(struct isci_request *ireq, u8 type, u8 op)
 	tc->app_tag_gen = 0;
 
 	if ((type & SCSI_PROT_DIF_TYPE1) || (type & SCSI_PROT_DIF_TYPE2))
-		tc->ref_tag_seed_verify = scsi_get_lba(scmd) & 0xffffffff;
+		tc->ref_tag_seed_verify = lower_32_bits(scsi_get_sector(scmd));
 	else if (type & SCSI_PROT_DIF_TYPE3)
 		tc->ref_tag_seed_verify = 0;
 
