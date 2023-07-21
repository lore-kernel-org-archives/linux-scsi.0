Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3B4EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjGUQDJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbjGUQCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:02:37 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081E32D47
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 09:02:33 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1b8ad9eede0so15788625ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 09:02:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689955352; x=1690560152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=khmFSi//VDGaMV5tP25J15l0jgygMFTCGaN0qRY+97s=;
        b=mCdn0wxoAOd/5kN6Rj7cJjXfquZCynL9QtjPE83cZs049QZrynVMS45ikR50hWLTun
         bW4t1NX/cWTCHxhuh4lucaAFIGneJtbaXkGvCMKxduPOq2VjqHYv1CfAFWBQRpQ1JaSH
         xZB1LmjCW2hm5ZrYszcvHJpksHrT22qgLapGuDKYTYPOSXp0OisUSfDkiUVj9bismzui
         NE6dR37z2ySGnLxsS/guHQT3bxAQmUXoomasM/Vy9HIEpEl1w2vqYzz8rK3VLKliRQF2
         A4lSnEQIKgXpuFyBPB0VzIboBC9t8smxBuFgjZ2e2limF4H8Uh2fuIaAsNDhrjjFrFUX
         5Gfw==
X-Gm-Message-State: ABy/qLb2yHtkY6GFG2jsPdUODLlzkuQE0UErnVPBTV3yrUowxecgqTjv
        JJIvfcQneZedilmNendvjGKmjX1P4cw=
X-Google-Smtp-Source: APBJJlGJCnceOKiitkUMC2jGEbltxlSYiFyMCItztzwIab1+/bZDrZ5oqOqJmH+djWjrbsu+qVvPUg==
X-Received: by 2002:a17:902:e9cb:b0:1bb:3e35:6416 with SMTP id 11-20020a170902e9cb00b001bb3e356416mr2346311plk.56.1689955352316;
        Fri, 21 Jul 2023 09:02:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5043:9124:70cb:43f9])
        by smtp.gmail.com with ESMTPSA id s24-20020a170902a51800b001b890b3bbb1sm3652298plq.211.2023.07.21.09.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:02:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Damien Le Moal <dlemoal@kernel.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        Roland Dreier <roland@purestorage.com>,
        David Dillow <dave@thedillows.org>
Subject: [PATCH 3/3] RDMA/srp: Fix residual handling
Date:   Fri, 21 Jul 2023 09:01:34 -0700
Message-ID: <20230721160154.874010-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230721160154.874010-1-bvanassche@acm.org>
References: <20230721160154.874010-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Although the code for residual handling in the SRP initiator follows the
SCSI documentation, that documentation has never been correct. Because
scsi_finish_command() starts from the data buffer length and subtracts
the residual, scsi_set_resid() must not be called if a residual overflow
occurs. Hence remove the scsi_set_resid() calls from the SRP initiator
if a residual overflow occurrs.

Cc: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Fixes: 9237f04e12cc ("scsi: core: Fix scsi_get/set_resid() interface")
Fixes: e714531a349f ("IB/srp: Fix residual handling")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0e513a7e5ac8..1574218764e0 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1979,12 +1979,8 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 
 		if (unlikely(rsp->flags & SRP_RSP_FLAG_DIUNDER))
 			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));
-		else if (unlikely(rsp->flags & SRP_RSP_FLAG_DIOVER))
-			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_in_res_cnt));
 		else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOUNDER))
 			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_out_res_cnt));
-		else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOOVER))
-			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_out_res_cnt));
 
 		srp_free_req(ch, req, scmnd,
 			     be32_to_cpu(rsp->req_lim_delta));
