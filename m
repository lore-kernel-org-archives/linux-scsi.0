Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B03C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE39761446
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhENVfe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:34 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:55039 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbhENVfc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:32 -0400
Received: by mail-pj1-f42.google.com with SMTP id g24so520454pji.4
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hnj1CAegSg+E8lSbWvNGlsAIyJElNAUfG3sSIJO2hUQ=;
        b=gTdDZicP6hm5Q4yHVKgFk41OYmiReiudELua+AQcUaPF+zcAA/cLOXdCkvdszLlr2Q
         Z+nl4l14Yx6wPAkToIb9W3VXHDPia4V4AxUYF4uldrJS3kuT2gbp04lGFb3bVY05sU+O
         H9UoR3TxlFdhiDynC0gI9xfMMK+0/5wxieVA27eykfx6fF9TDd1gtKV73OfoTCKH9jMS
         OfKxphv3ZWBEVVqR4CRPoQZVPpK5BKrPlIriCZWAcBiTaB6rFi4ufw9tHs8uCWTGkPxS
         dADL4L9KmHyC2iNIsQBHZFY7jfrpLMkm3pP0o4QjOW7DAm/UvtGlT/XPBwTkwQ8zkJjq
         Xziw==
X-Gm-Message-State: AOAM533wis6YfozqRApHk67oL8w3NWJ5U8RTbLxLGSDMKHXXiqf8l+He
        S5ilGkYeFdNXcKCD0+8GFfA9MbKBE0o=
X-Google-Smtp-Source: ABdhPJxGkBvrmUPz9FXkyNcMQIyfW9ZYSkM0/srzHEVDaSvJwabhtnE7xx5n1mEs103kvdvnryex5w==
X-Received: by 2002:a17:90a:ab13:: with SMTP id m19mr13643633pjq.124.1621028058850;
        Fri, 14 May 2021 14:34:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH 08/50] rdma/iser: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:23 -0700
Message-Id: <20210514213356.5264-9-bvanassche@acm.org>
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
