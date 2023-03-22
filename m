Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C81C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCVT4o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjCVT4h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:37 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF60B5ADD5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:26 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso1993877pjf.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WxAjcxps+NaGSsvzYRzXC0eCmye/BzJ2UmkE/1cUug0=;
        b=g49SPbGEgm5bB5OUIcE5xcbEwyI07ZsYJ10UKFx/boVF9BqBstIBXfy5MNOhFtBH5B
         aOhwnpyKo6Y+/su3LplINZ1QljHIzqdb5SukdhoI3EqQh+7mWImsE3iItI1K9KUWxibF
         XN/QoJ2d5c7P6wIRuzWSRDj45JUMDuuV+pNtdifE3CAtZSTtM/GnRKeMlbCYUTr8mTW0
         ste8gFfO2DzjmWhDTyfLfEa7Ik4MnER5BIesheLNhcCjVKkwZ5ScBMrDgbfzkCQxVgYX
         eZ8/w7ynWJBDnoyj8KVuRjiJ2vjN5NRS8fxWaG5jPYufo5289LDKEQp+pQYjotfW/eCq
         rpBw==
X-Gm-Message-State: AO0yUKVDBM/WaAGP4vsAwBPHW19L3CXV9en2Lev8mPh9vRKNq9HrbN99
        7t8VH+5jDSvWNh0cLxtNEtdfrMxzYGc=
X-Google-Smtp-Source: AK7set9Il9XujsDeR3aGoSNqQlk1SbqJYRT6XqbD/sbE+R+f8PExD3AGBuBfMBIaHGhhDP749PouVw==
X-Received: by 2002:a17:90b:1e0a:b0:23d:3698:8ee8 with SMTP id pg10-20020a17090b1e0a00b0023d36988ee8mr4773100pjb.31.1679514986143;
        Wed, 22 Mar 2023 12:56:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH v3 06/80] RDMA/srp: Declare the SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:01 -0700
Message-Id: <20230322195515.1267197-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SRP host template is not modified.

Acked-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index df21b30b7735..3446fbf5a560 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3077,7 +3077,7 @@ static struct attribute *srp_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(srp_host);
 
-static struct scsi_host_template srp_template = {
+static const struct scsi_host_template srp_template = {
 	.module				= THIS_MODULE,
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
