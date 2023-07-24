Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A1EC41513
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjGXUJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjGXUJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:09:22 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF26F10D9
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:09:21 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so3353425a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:09:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690229361; x=1690834161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=khmFSi//VDGaMV5tP25J15l0jgygMFTCGaN0qRY+97s=;
        b=GaSBuXfa8iOvbznLWeDO4hyCAySkF/RsfgdYNIkga5LWqSuNdHbo3fmFseNriZpTR7
         d+lDYmvytqPWSPSiJmAmRquCIzNdojNN7OawswoZyIJ3YKOsqzDd8EK6LOKWZ9QDH82r
         f/DrCmlEpPhlNa4i6Bg35hBhGKrj03AI50umltYfGaf05UVg82X3R8/FPI2hONfDnREy
         3y3DxAue9I+I5c+3Qf5eXxsNyzukzlFlO+eiUH38jfRoauHzSy5B3LD5Ugiy2Cdpry+M
         2e6L+PBb0Tyowuo1UiISIox8zTZ/cWK8tzgEdZsepBUJ5ETUZ3g8IXAIPMobFxKzlWPA
         UZpg==
X-Gm-Message-State: ABy/qLYYA3B/8ym+L599ct8HrmfLEeVX+cuY1tzBdOMZ9CpiyNnhF3Nb
        RbnFK2/PVVrIqZJeyGpDZKg=
X-Google-Smtp-Source: APBJJlFYrxqkyhRmDy68/6v4h0WFmhkoHylw144XOXBKHM2A2O/8xsl3nSCaFcSv2mA+CrA+Yvbc5Q==
X-Received: by 2002:a17:90a:9c09:b0:263:f583:a6a1 with SMTP id h9-20020a17090a9c0900b00263f583a6a1mr10696721pjp.34.1690229361076;
        Mon, 24 Jul 2023 13:09:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id e23-20020a17090ab39700b002609cadc56esm6726861pjr.11.2023.07.24.13.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:09:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Damien Le Moal <dlemoal@kernel.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        David Dillow <dave@thedillows.org>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH v2 2/2] RDMA/srp: Fix residual handling
Date:   Mon, 24 Jul 2023 13:08:30 -0700
Message-ID: <20230724200843.3376570-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724200843.3376570-1-bvanassche@acm.org>
References: <20230724200843.3376570-1-bvanassche@acm.org>
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
