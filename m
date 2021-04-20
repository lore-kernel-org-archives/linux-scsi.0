Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130B9C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D520D6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhDTALM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:12 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:42801 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbhDTAKw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:52 -0400
Received: by mail-pg1-f180.google.com with SMTP id m12so4674340pgr.9
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZsY7CKaWNTKBIj/jYSqreOFYB/LRDS1HtLE5HSUxM5Y=;
        b=fiLh0bKWpVsTO+2u6GvAlhEP+kU3Io9Cs/PvogjNvypnHFRhEWwUt7kLBZciZ+yrCY
         puRcLnekBD31nsXCy2Q4NIdBqrebZHLjp3Pf6Rq+bhLKUkiJWpeSINkpKeha6muGjX2D
         5TVNZL/AkP4J5fJ4xHD4qlXp5Q6vaTG5/vEYccid7TmqF6VGNkoZ1xSHSisVXuvK5wN4
         g/Q9mdw9MmF+iG8Q+wChI0t+60aajoPoB7p0IWF+BheaWr2QulABmTJQUqrLxqVOfyMW
         GbcpOBCp3JC3JZEmXKAZhmRx9WIVj7IVC5kU9pDXiNvyXFIv4N2saVPX+GH9GiiocfNv
         Y0nA==
X-Gm-Message-State: AOAM530AIn13WQIu8yCOLcHbSUaCqUbb6P6ojTQr1iHc2pAkWYRY+ulR
        TVJ4FUlxLhVIesuQrQum8h0=
X-Google-Smtp-Source: ABdhPJwUPasm8mzx27QNu5wdCsJmJ0kS/40yXxqSzY+teMULYiVSSS3P2cLM9Gyuxf6cxX2EWMuMjA==
X-Received: by 2002:a62:9a11:0:b029:25c:908b:5284 with SMTP id o17-20020a629a110000b029025c908b5284mr11880547pfe.6.1618877421897;
        Mon, 19 Apr 2021 17:10:21 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 078/117] pktcdvd: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:06 -0700
Message-Id: <20210420000845.25873-79-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/block/pktcdvd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index fc4b0f1aa86d..95c51990d13c 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -723,7 +723,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 		rq->rq_flags |= RQF_QUIET;
 
 	blk_execute_rq(pd->bdev->bd_disk, rq, 0);
-	if (scsi_req(rq)->result)
+	if (scsi_req(rq)->status.combined)
 		ret = -EIO;
 out:
 	blk_put_request(rq);
