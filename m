Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139F3C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E56FB60BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242775AbhHETTX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:23 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:52100 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242666AbhHETTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:07 -0400
Received: by mail-pj1-f46.google.com with SMTP id mt6so11323524pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rFB2g9DT7BccO/4omZWlRnioQu1FtC1vePbQZ6R/JSo=;
        b=A6zzlqmGQ3lRLGAAaG0Kmg0XDUfujHvNq0VbgIXxgATLywWXIY0X54dgBcwTPPJJK+
         EnM3/5mJY5eDVQjGlT2eGn2a7VmHVBTDp+FpQ+fglAHMCuWrHBzvtKVecTBjRSJxp1dP
         yTQyoZnY/v27c0o0PTRDSaXStwLz5fXVT1a37tYAVC+608h0aQzyjay3FQ1ftTd4Isoa
         TFnzzjkAsyXUK8EOk4JqX4NMU7AYvvf3R2hrrCim4aOpqS6iG8U0M5DZJsvTeSn6EtnL
         K15AyYukxkIeDpWka4qcOsGwSviA5tLC9m/ZhqXSSRxl+7W3emhHaRfIv3jr1Y6yqm5C
         qPRg==
X-Gm-Message-State: AOAM530W10pRnxz5IeJWMD9Mbvxe1csU6eJN2hT+YIQvMSzLDIp3cazl
        mw9e8JQlv+0dVIcGkKCDYY4=
X-Google-Smtp-Source: ABdhPJxNuO+hkmkC6fsNMvbeqgzceNZcwoAJWMIPOU4jHbYMkKUoiDmJjlXtwJSV/qddhlnY6awtNw==
X-Received: by 2002:a17:902:aa86:b029:116:3e3a:2051 with SMTP id d6-20020a170902aa86b02901163e3a2051mr5306757plr.38.1628191131557;
        Thu, 05 Aug 2021 12:18:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v4 08/52] RDMA/iser: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:44 -0700
Message-Id: <20210805191828.3559897-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
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
