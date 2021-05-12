Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C547C43460
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16D5E61288
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344476AbhELVXX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 17:23:23 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:35475 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385594AbhELUKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 16:10:11 -0400
Received: by mail-pf1-f180.google.com with SMTP id i13so19608502pfu.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 13:09:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sutxvrScGseWL3oq4pAsmqCdsjMY72J2IRMLeUnwK5Y=;
        b=NTbVqfGuNW3CbgWTsOgcaDA5WJ0J/Gi22W9COChPVqsUAvjTRYtf1PhklnTxNKE2Rp
         rhF+j5BzUp5Fdr/rSafCyynSsfb/Ia4DYGMa7JKdVwrXZbzDIrTjGN1wdoNNFreAiG15
         Oznfsnidm0V1jTtVktD3rzJYnr1+TEvxE1KP7DGAuhztB8GXM7ZckF526UDXpHIVDDzo
         cG9bkWQJOkta9GdKzsU4I+nbLcdqWc9SIm4NemzQZZq2FNfU6mTNcyX/v0fU2xQgDZrm
         l3sbOliuBdN7Z9q50woHGOhCqgppXmDAnwjLJcmhbgQTNIh6AyrjbRKa6rBPpIdQdyGj
         Lh/w==
X-Gm-Message-State: AOAM530V34Jc51D5W+PvZyMxh5eFvmgdNZS+np0XYhIotWDH6OkZ6w4z
        WDdMgFirJQydTn1AbxPaIng=
X-Google-Smtp-Source: ABdhPJxA31hEqcXNHVVH7S6GBGfDlwiTSMWI2rd+WLuG+fc82dgltR+I7NJH+9d6CWsiY+Xe28uwOg==
X-Received: by 2002:a65:45c3:: with SMTP id m3mr37316451pgr.179.1620850143283;
        Wed, 12 May 2021 13:09:03 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:993e:1516:b2ba:76fe])
        by smtp.gmail.com with ESMTPSA id l21sm513948pfc.114.2021.05.12.13.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:09:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncan@suse.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 4/7] isci: Use scsi_get_pos() instead of scsi_get_lba()
Date:   Wed, 12 May 2021 13:08:46 -0700
Message-Id: <20210512200849.9002-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512200849.9002-1-bvanassche@acm.org>
References: <20210512200849.9002-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_pos() instead of scsi_get_lba() since the name of the latter
is confusing. Additionally, use lower_32_bits() instead of open-coding it.
This patch does not change any functionality.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/isci/request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index e7c6cb4c1556..1c25f28385fd 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -341,7 +341,7 @@ static void scu_ssp_ireq_dif_insert(struct isci_request *ireq, u8 type, u8 op)
 	tc->reserved_E8_0 = 0;
 
 	if ((type & SCSI_PROT_DIF_TYPE1) || (type & SCSI_PROT_DIF_TYPE2))
-		tc->ref_tag_seed_gen = scsi_get_lba(scmd) & 0xffffffff;
+		tc->ref_tag_seed_gen = lower_32_bits(scsi_get_pos(scmd));
 	else if (type & SCSI_PROT_DIF_TYPE3)
 		tc->ref_tag_seed_gen = 0;
 }
@@ -369,7 +369,7 @@ static void scu_ssp_ireq_dif_strip(struct isci_request *ireq, u8 type, u8 op)
 	tc->app_tag_gen = 0;
 
 	if ((type & SCSI_PROT_DIF_TYPE1) || (type & SCSI_PROT_DIF_TYPE2))
-		tc->ref_tag_seed_verify = scsi_get_lba(scmd) & 0xffffffff;
+		tc->ref_tag_seed_verify = lower_32_bits(scsi_get_pos(scmd));
 	else if (type & SCSI_PROT_DIF_TYPE3)
 		tc->ref_tag_seed_verify = 0;
 
