Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FB8C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67703611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351210AbhERRq2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:28 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:41721 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351184AbhERRqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:24 -0400
Received: by mail-pl1-f177.google.com with SMTP id z4so3324240plg.8
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xq2In6yA8nfG4vkGKAZQxjMGbrLD12Ty5gK+54XT82g=;
        b=XN5eKmjqnLGQugUBOFxIfpyl/02m6fZq+Yl2/nxDJIut5SJQz1OpHf64rJYSO84L6n
         oONVPdYrnHSGRZjcL989maLIRjbwDTGOlXFirTIEg1UQV0LyWKVk8LfRitXTGAbOijz3
         TAJRt4A138yIzMAXlgo6QQRv3dG/sqoaqv9ojF76ew2pbLnMN0KDLwX14ut/Wo8Ge81m
         OoH2zhLyKrQ8kBzW+dBWz+NG67KnqXZOocRD77TfEnkgE1xiIQJ7TNRYCI99/cH6aZIF
         5Iyk0jxZ/CuOvmNK2ctAzyaUKXdBO+lbO9oOmRh1eK+TecLGpPxriGtRMLTyGiX6lQPl
         OOrA==
X-Gm-Message-State: AOAM533tcSzHKEcKzQxg0RtY5oHB9r+hA5QFcK7NI+o5wMWYh/7TcR1W
        eQJy7r4KSFBJTqAgUe58ZrM=
X-Google-Smtp-Source: ABdhPJy+U9pIr2n7aOuTOVBIwQVH2HJ9BsmazDWYvHYQHhvfpfYQw9eN6YbcEiOICYp3TUh2H2ZR9w==
X-Received: by 2002:a17:902:bc88:b029:ee:7ef1:e770 with SMTP id bb8-20020a170902bc88b02900ee7ef1e770mr5881407plb.19.1621359906043;
        Tue, 18 May 2021 10:45:06 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v2 08/50] RDMA/iser: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:08 -0700
Message-Id: <20210518174450.20664-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

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
