Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119B2C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4FE9613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhDTAKD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:03 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:42562 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbhDTAJt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:49 -0400
Received: by mail-pf1-f174.google.com with SMTP id w8so20841756pfn.9
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bwhJU3blTj5cJOg2YRhDaO68/7QYG4meDuTF0D7smJ4=;
        b=p2MppB0O1PWEf5TH5jZRNtSxsiHWlo522+PkPwxA+EsIUB44yjc2YMAkOEXRHuQi68
         tagn+c5qoFUm/rH6hRuQarsjFbBStOmuQDhfIYQkvG6u9+AukBEmRG1vMc3EE5JREAHi
         6/s3qYPW6fAE1uTIjFeZLJCrdt3OGcsKZA07swr3FzVqVUJW1/xGL4vFrkGWEUeWMjaS
         jhRziFA3e+jhg2BZuig0gM9J/d7Du8aNisPIdt+6uZLhX2UDRjjxHBWcZ5toZb1hK6qg
         alZs8mjpJmKT5tKVszz1NArxi3fKQtOrgWbgjCbTfjEbvRl/nS4PpdW4sLb2B4z7l14K
         xYIw==
X-Gm-Message-State: AOAM533iXA7yfib3RYim+FsKFNHe9Xqu/w3UNsB9OaWEwy4eAuJ84o+k
        Ty6fmyOihac5lblTKaj6XRc=
X-Google-Smtp-Source: ABdhPJzlexHI8k4ngeMDHOVnotCcD/rx3rHdB1jSAh/U+7CDes8Wo1WAKEfpko/BwbhdJ34qRounXg==
X-Received: by 2002:a63:e903:: with SMTP id i3mr14162603pgh.374.1618877359004;
        Mon, 19 Apr 2021 17:09:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 023/117] a100u2w: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:11 -0700
Message-Id: <20210420000845.25873-24-bvanassche@acm.org>
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
 drivers/scsi/a100u2w.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 028af6b1057c..d6bed0ccd6d8 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1040,7 +1040,7 @@ static void inia100_scb_handler(struct orc_host *host, struct orc_scb *scb)
 		memcpy((unsigned char *) &cmd->sense_buffer[0],
 		   (unsigned char *) &escb->sglist[0], SENSE_SIZE);
 	}
-	cmd->result = scb->tastat | (scb->hastat << 16);
+	cmd->status.combined = scb->tastat | (scb->hastat << 16);
 	scsi_dma_unmap(cmd);
 	cmd->scsi_done(cmd);	/* Notify system DONE           */
 	orc_release_scb(host, scb);	/* Release SCB for current channel */
