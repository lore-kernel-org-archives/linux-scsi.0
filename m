Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84437C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A94261490
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhENVhG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:06 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:42971 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbhENVhA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:00 -0400
Received: by mail-pg1-f181.google.com with SMTP id z4so246350pgb.9
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hnj1CAegSg+E8lSbWvNGlsAIyJElNAUfG3sSIJO2hUQ=;
        b=eQU6svEchdy/Dzw80iHsgSe8tgSI9nAbN7hbdtE4X8mIf3+MBqvJfTNJBKSaBNvQ5n
         BKk7t+c1GM6IqX2IjNm0QehLlArfIn9ocDYR6GWGZ7Og6rDzQZ4Qp8bTH7MIlrSf1gjN
         yOEY3D6kw58Wskl2m3pF578pEcc5c35wJ72uaGyqqVEYXTW0NVfB2MLKN1k3UZh3DDKr
         FGvkkKmmWUs6AROLWQi7zB1LzUwyp5/yS2xz4zADXrJxFH0x9r9RyJByhv+nzVPjH+QH
         QJXyh5MIO7hCGrczcf37zRKEFHoT+OWeKVswL3zeNIIzAmFnDjamVqhurbsltPpI+t+6
         KqYg==
X-Gm-Message-State: AOAM533fiAiNxPwRRm0RgXhiX1vmpARtA5S+okJSpe+Wn8OlAXT2ta+/
        GCAXwBVZEzR4VmF2/lrQlCp+BMCDm8Giiw==
X-Google-Smtp-Source: ABdhPJyikEulo8kOVrT1f3dDISvgIbyiTtKlizcHWfPvKDYQ8PKBqdr6HSkIieHj5xW8EY/GunJuSg==
X-Received: by 2002:a63:3f8f:: with SMTP id m137mr28791680pga.56.1621028147626;
        Fri, 14 May 2021 14:35:47 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH 08/50] rdma/iser: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:14 -0700
Message-Id: <20210514213356.5264-60-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index afec40da9b58..37c5cffaeaa1 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -159,7 +159,7 @@ iser_set_dif_domain(struct scsi_cmnd *sc, struct ib_sig_domain *domain)
 {
 	domain->sig_type = IB_SIG_TYPE_T10_DIF;
 	domain->sig.dif.pi_interval = scsi_prot_interval(sc);
-	domain->sig.dif.ref_tag = t10_pi_ref_tag(sc->request);
+	domain->sig.dif.ref_tag = t10_pi_ref_tag(blk_req(sc));
 	/*
 	 * At the moment we hard code those, but in the future
 	 * we will take them from sc.
