Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1C0C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD81D61396
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhEMWjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 18:39:19 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:40725 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhEMWjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 18:39:19 -0400
Received: by mail-pj1-f47.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso345346pjp.5
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 15:38:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WtUJxcNbPlQQMQs/dmB89rlHEGTen9crzWByxRcvXhA=;
        b=mtDtNXo41mMfoYhc3xUQelwGm3rHqYb88gDQIGpFOsfTx+UnaVSFF+HEXM5eDNAhIQ
         hwLHLvvxOVhEgMUl1U8f45xjHbtY8ZkxgshbKGqM/Sb0IVrGOwgyfT7hCTy7vd9CFf49
         9xxPpH9o01w3S/JOIFltVZVGJavEbpIUFSpZ3S/hzxQWVGId06ztsQDkqPjXcN3coYMb
         ah35aCstmceImlcZu/jlUPB3+5S27AuV81MjdKxncktc5ORWlIzkMinGHcvW66gJLM16
         S4hjsxnYHMmsb1hONJjaxKwqr1xCOsj9pXo/ytfPSOAxQQ1o587jhO9c5Yz7HE34ymf7
         Rolw==
X-Gm-Message-State: AOAM530jBnuKCCezj/CJLkHQQx+s8F9Z3FxCx56cNXqKDk7x4PnZCFvd
        Svntfvj56dqEy5UwDEBDrxg=
X-Google-Smtp-Source: ABdhPJwWu5As0LkX/dLtky3aFMkxdX3DoNkG1a4JrFFP7D+3eB9zFjYX+gDK2CyHj57uHcsgVJ6eUQ==
X-Received: by 2002:a17:90b:689:: with SMTP id m9mr3131168pjz.102.1620945488796;
        Thu, 13 May 2021 15:38:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:54a8:4531:57a:cfd8])
        by smtp.gmail.com with ESMTPSA id j23sm2852582pfh.179.2021.05.13.15.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 15:38:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH v3 3/8] zfcp: Use scsi_get_sector() instead of scsi_get_lba()
Date:   Thu, 13 May 2021 15:37:52 -0700
Message-Id: <20210513223757.3938-4-bvanassche@acm.org>
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

Cc: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/s390/scsi/zfcp_fsf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 2e4804ef2fb9..3d9a3dc4975b 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2600,7 +2600,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 
 	if (scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) {
 		io->data_block_length = scsi_cmnd->device->sector_size;
-		io->ref_tag_value = scsi_get_lba(scsi_cmnd) & 0xFFFFFFFF;
+		io->ref_tag_value = lower_32_bits(scsi_get_sector(scsi_cmnd));
 	}
 
 	if (zfcp_fsf_set_data_dir(scsi_cmnd, &io->data_direction))
