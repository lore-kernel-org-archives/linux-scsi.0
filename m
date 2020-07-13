Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84449C433EA
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A7CB20674
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="udRqTFtV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgGMHrB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729115AbgGMHq7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:46:59 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E91AC061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:58 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f7so14681547wrw.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8R5JqiLjYcza4fbV6goyYqcdxR7v8Q2JkVSQFyfGqhI=;
        b=udRqTFtVMJHrG8FeYyUiq433O2fFQWC945bPEuJp10f4RrlpzSBC3G1uT3JrWYA1z+
         KkuTTQHCBdHe1LYCAy/Iu3gl9yKuqzR0//GRW+h8lH+KZWAZK605JeIx5pB2kAKHOSXI
         V335Wh3pK7UbDMZzCDpcb1FmsQkI8K+4bAYGhygGqjF9tBjGZSaj7UJQVmYRRKniBfXr
         SCBIkyICY6k35WAoLl9qqCFZJfpliOIQY1ByScnoV6kBjLvUTTfL9aJVq/QlI5KXWYzP
         VMQdVskZjbYEcfJ7cJY+OgjrxcgZjB6XG39HbAY8rYrFvKZnFv+LkC0PtP30tOSv65uW
         AZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8R5JqiLjYcza4fbV6goyYqcdxR7v8Q2JkVSQFyfGqhI=;
        b=PpZq4lRDyzHjvrQeJOZ4qyHwpb6InMpr8mTh+HUHGKWWgSOAOWNiUdcy56eXCNLy6D
         8sCfehgjiwMmNjGxhkU2y1VxzmYpaRW6VsbblBGNHh1S7rrR/mXjh32SzS6yDQsxs953
         Xzz90DVcJz9UUcWgGarPJjQ20BvW/tyc0Xz0WHTWyxtWQ8ygZXaBQSQW6L9ZtWQimllf
         qbWAMCqaBvh2IxQOANKecZSDq96ua2Wn0mma2XqVvJdsoY0bukiIXtyPaI6aeSuHi3d6
         UOggFl62Wcdv3k9kjCjfUsyQ2JsRVpVzQrOIvJk1dVKanvA206XeVjMVGrAcxK5pTI3R
         E3vQ==
X-Gm-Message-State: AOAM532W4LRghZ2637WujTOTBOPpb88FLZviXZZ9KolBminA3cEQAGtS
        HIyheMSGtC92x8Hwu2R7e1FcR8jbRYk=
X-Google-Smtp-Source: ABdhPJzSaAiAW3pCxf6bHROZk6HR9qPvG3gRkewkP6qZUrfb7C/flDBz3JdziBfir+fa/ZfAKDVxNQ==
X-Received: by 2002:a5d:664e:: with SMTP id f14mr78870952wrw.6.1594626417338;
        Mon, 13 Jul 2020 00:46:57 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:46:56 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@cavium.com
Subject: [PATCH v2 09/29] scsi: qedf: qedf_main: Remove set but not checked variable 'tmp'
Date:   Mon, 13 Jul 2020 08:46:25 +0100
Message-Id: <20200713074645.126138-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks like the return value of readw() has never been checked.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qedf/qedf_main.c: In function ‘__qedf_probe’:
 drivers/scsi/qedf/qedf_main.c:3203:6: warning: variable ‘tmp’ set but not used [-Wunused-but-set-variable]

Cc: QLogic-Storage-Upstream@cavium.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qedf/qedf_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index a77a74fad6a7e..47fc14f5ed9d7 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3199,7 +3199,6 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	void *task_start, *task_end;
 	struct qed_slowpath_params slowpath_params;
 	struct qed_probe_params qed_params;
-	u16 tmp;
 
 	/*
 	 * When doing error recovery we didn't reap the lport so don't try
@@ -3393,9 +3392,9 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	    "Writing %d to primary and secondary BDQ doorbell registers.\n",
 	    qedf->bdq_prod_idx);
 	writew(qedf->bdq_prod_idx, qedf->bdq_primary_prod);
-	tmp = readw(qedf->bdq_primary_prod);
+	readw(qedf->bdq_primary_prod);
 	writew(qedf->bdq_prod_idx, qedf->bdq_secondary_prod);
-	tmp = readw(qedf->bdq_secondary_prod);
+	readw(qedf->bdq_secondary_prod);
 
 	qed_ops->common->set_power_state(qedf->cdev, PCI_D0);
 
-- 
2.25.1

