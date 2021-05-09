Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81905C433ED
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 507C6613C9
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhEIVo0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 May 2021 17:44:26 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:44886 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhEIVoZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2021 17:44:25 -0400
Received: by mail-pg1-f171.google.com with SMTP id y32so11877311pga.11
        for <linux-scsi@vger.kernel.org>; Sun, 09 May 2021 14:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/uEiR8Myw753xwA4FBJJWxbBNnQCiKa0NeoVyaUQmYs=;
        b=YAItiyJoeyWVnUI5W5MfUPRNMumuA7sMRkevNz6i7u3lLBd67twf6J3lDUlqocS/Rd
         LsK4otwKCN324tM69eu5De6qg9wuMOETkqjY3xmNHfh/Gqdcauf2jxw36Ygq/CwDNeTS
         FBT102zVwvmEQ0AMbg7PX6uwx6NEri9iFUejd4ZDw4rHdBIXYx9WIP6i40JntdXoTmlK
         Xo9nfWnEOISNPP+2AnW+fflRL2kve9ogt1A578yGHlq5PlvyUdt5SiSSkxnPf8zRrQMy
         nK5iZWMOTRbWlBz32TIHtqwv+tHSNkkkuMIpm/R+871cCCefKAjmLbqOFsM3+e9XdO0X
         k6AQ==
X-Gm-Message-State: AOAM532F0UakXZSOOFv3q1t8vdmORxhhMxD5FntAJ17S3LiJIWqBvrMp
        9cFykBJZoC1w5vCieg+gV58=
X-Google-Smtp-Source: ABdhPJzIyOs3JBUOdil7EUqE8qi4lb54IiUfSzF1OBp4V7GjA8ia1Of2csxsM/HPQW+614sj9zZOfA==
X-Received: by 2002:a62:8fd2:0:b029:28e:8c64:52a4 with SMTP id n201-20020a628fd20000b029028e8c6452a4mr22130785pfd.3.1620596600896;
        Sun, 09 May 2021 14:43:20 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:1f3e:222f:39bb:cb2e])
        by smtp.gmail.com with ESMTPSA id t4sm9712567pfq.165.2021.05.09.14.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 14:43:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncan@suse.com>
Subject: [PATCH 4/7] iscsi: Use scsi_get_pos() instead of scsi_get_lba()
Date:   Sun,  9 May 2021 14:43:04 -0700
Message-Id: <20210509214307.4610-5-bvanassche@acm.org>
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

Cc: Lee Duncan <lduncan@suse.com>
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
 
