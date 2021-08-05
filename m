Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28380C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1042E61078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242816AbhHETTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:43 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:42772 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242907AbhHETTg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:36 -0400
Received: by mail-pj1-f41.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso12012004pjo.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eMqFVEuFWl1HmCq0tOtP+C4GAxmEPY2IcI6/DJJ1ex8=;
        b=TjLdPYFphhVG4ovLmOHU6piyfs7t8/2OHOqC9NUWCW8+cd1nAn4lSNM/+eos9s9ppZ
         nslyadlxcSCPx6OsrhSbTxAv5U9XJffgzJ/CSmpzL9nTVCMCpNtaPXqxCmR+Zle/qEff
         bLuFOCBmzR41CPWuKwcOz74wQlYVxoZYmg2vtmcueQYAKXxsT9VmC2lqqdYXAaUU+3Ns
         tsuOnTnNr4Dp/OFJ/CGLxtbnCuYrt6tC3PS3Le+Qrl0TGlkwllNQvGvGR/NEgIB8T3dO
         1HV9XpTGWdPYpOLfqms4Y7YX5Wemkb8ybITNL1VqaO9FIM6KoXL4QncEuq80C45EruPj
         MVpA==
X-Gm-Message-State: AOAM5310BOtvDc1IupJi4bORGRGVmdDhKE0DnWJVpc7kGYDZVyq/8wyk
        Y1D+/Y18eZbo6n9EfhQwVEw=
X-Google-Smtp-Source: ABdhPJw3pbiYSg3Eza4NeuFIMvCgUeMLnj3grHbqUst/ugoxwnL0lNdZj61mPfipFPiWNeDZU2Pp0w==
X-Received: by 2002:a63:c058:: with SMTP id z24mr1831163pgi.220.1628191161956;
        Thu, 05 Aug 2021 12:19:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 24/52] ibmvscsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:00 -0700
Message-Id: <20210805191828.3559897-25-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index e6a3eaaa57d9..50df7dd9cb91 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1072,7 +1072,7 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cmnd *cmnd,
 	init_event_struct(evt_struct,
 			  handle_cmd_rsp,
 			  VIOSRP_SRP_FORMAT,
-			  cmnd->request->timeout/HZ);
+			  scsi_cmd_to_rq(cmnd)->timeout / HZ);
 
 	evt_struct->cmnd = cmnd;
 	evt_struct->cmnd_done = done;
