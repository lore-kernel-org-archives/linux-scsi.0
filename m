Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689FAC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B55860F35
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbhHIXEh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:37 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:38572 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236239AbhHIXEg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:36 -0400
Received: by mail-pj1-f51.google.com with SMTP id lw7-20020a17090b1807b029017881cc80b7so1425142pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9d7F+ZwZQTU6353dFvZDkaFpptApgI2Bi+l027yCdhk=;
        b=CvyEX/pVZDUJrKZmWAQlmLDcKSCqw4Q4nHIESprEE6hz/JTib2FO1wuGne8sX+CG0Y
         IvvUBmsEjew1DHeqxN+Wb7WxQFu+HGYWRkJJ7b9QRDBfi+ijSTr+C4k4x/+MvwIyKtIU
         JsWXj1MZZt+rK63GGalz386uO5qMVIoFH8cRg8UIFr2Uw2h7NGLzpbTSYZmhVEvWGTCN
         VNiz+gR1/ivHpDcMXmfd7nQfob+P5AIHgXKfwS9P/eWN36nEY50Zm5kXIRroW39FV7KW
         Wxbsx3bVxbRcuzecbo0/cz24zFHNolBFR1QI6LAD5LN/XwgovvwS0YpzUPJqOmKGX8N5
         b6qQ==
X-Gm-Message-State: AOAM532SCsYgmM14PKOE42GlM2OVQMIlCIixGHbjypzJejjw/58abXUG
        A3uX7JGjkVzJIbEDPy2QivU=
X-Google-Smtp-Source: ABdhPJxnsghvv3Oke3bjP3m8BtXHpJx+FXxBbd8txwpTaG4io+OzBcSu5paoXhfOZ3QRirzBVZ5orA==
X-Received: by 2002:a17:902:8ec6:b029:12b:ab33:15d4 with SMTP id x6-20020a1709028ec6b029012bab3315d4mr22223955plo.80.1628550255139;
        Mon, 09 Aug 2021 16:04:15 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v5 08/52] RDMA/iser: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:11 -0700
Message-Id: <20210809230355.8186-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
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
