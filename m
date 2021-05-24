Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F3AC47083
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1249861166
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbhEXDKs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:48 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:34588 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbhEXDKo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:44 -0400
Received: by mail-pf1-f179.google.com with SMTP id q25so1627567pfn.1
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R5KclDvO9a6xFzsM5jOel7yG2fn1Fo/rLdTZNwbuFTA=;
        b=FMsgXeS/J/GRwYKdrEOjmiTYuyrHYkEq9qEF5hfzqyijJhZ1rKd06fifJPhUe23ViT
         CLdZru0Bqk9Ib19/P44+KfqrMPkY+5jDi8/9Fr5KXNrqhw8qgaaMMIG1ucbm+JUnLeUW
         3bmerCD2Vfb/VcsrQ3yIbxZen1y+9+R6NqB9T4ez9uACg8XrmuS1lL3yCSiYN50trJ4B
         3Ya2AYR00cs7G0bj3mbtOFHFvUXW/ZSx9OmjyLvL1/Guihdjii9rk9tBW+vYlSnZoqWZ
         EynivHYShHNlCgjsMLgX+aH8tDYHV5vZi3Swn9htLmW8RsifZa/oNvFBoNSbSGgcw7Sc
         xDdg==
X-Gm-Message-State: AOAM531/Efr/RXvyMZS/z4+NQqNGP+scEnzKJAJUJNZTFWM2lZKJQEcX
        1jwtPKBpi20N4eczI7tb0q8=
X-Google-Smtp-Source: ABdhPJy0wpFaZggBYu3EYPUOkn7miTZP+dzREJnhDysjVagqcWDi1AQ3VpWM6cri1+Qr5mnLMFMOGA==
X-Received: by 2002:a65:4d44:: with SMTP id j4mr11135598pgt.275.1621825756078;
        Sun, 23 May 2021 20:09:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v3 08/51] RDMA/iser: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:13 -0700
Message-Id: <20210524030856.2824-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index afec40da9b58..9776b755d848 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -159,7 +159,7 @@ iser_set_dif_domain(struct scsi_cmnd *sc, struct ib_sig_domain *domain)
 {
 	domain->sig_type = IB_SIG_TYPE_T10_DIF;
 	domain->sig.dif.pi_interval = scsi_prot_interval(sc);
-	domain->sig.dif.ref_tag = t10_pi_ref_tag(sc->request);
+	domain->sig.dif.ref_tag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	/*
 	 * At the moment we hard code those, but in the future
 	 * we will take them from sc.
