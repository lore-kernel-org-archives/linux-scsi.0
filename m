Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D8EC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F6976109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhDTAJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:55 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:40779 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbhDTAJq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:46 -0400
Received: by mail-pj1-f42.google.com with SMTP id g1-20020a17090adac1b0290150d07f9402so791163pjx.5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k9PGR7gcL0h9CQwt86u+nPPbbmNhrdNsOaEgLLiFlWI=;
        b=mVfZSkm8YsVYnGFSI4fvllTyXhkGYa3DK470jhJmPmPG6GNJ8Tm6kpiyFFbn1tYIRk
         5TzHUM65U8VgD+ofFTmT3LwkILKTN+ZdVz7NbvsYCbfIakKez/hWIijFCQh7d1+nPzEj
         SNkrXX+EKw6a8qbfv4Su5rdZ8l9hgKckcQjot5eKmeYZR2BMjEHGSux1SP+xxlqOLwW7
         zPUZEKmDRRpHOC4Zgoexsh/Guub9JVe0gqYHKaRXxTLCbtwyttjrUHsDzLc83P2LPUdn
         2nKp6SNuYg7lB6/8rvaTaRyNa9PcmzstDJNuJmeKQn45+2FZMb8yvfp94kDQiOtVw1/d
         NNag==
X-Gm-Message-State: AOAM531maLzLAAz5GLbGtx8A8aO9HrQ3w3Ue0rq9gtn5HB8KiVewzjGe
        ik4JFkzfs+Cuw3UPU5V+Hls=
X-Google-Smtp-Source: ABdhPJzJZ48icVj8FfreV6TM2/Bj0Efv8YYfGgk3EuSF0RXp+k5IoU+83YCTwHURzlUbxDkshzkdbQ==
X-Received: by 2002:a17:902:20a:b029:eb:873d:d73d with SMTP id 10-20020a170902020ab02900eb873dd73dmr23358584plc.54.1618877355627;
        Mon, 19 Apr 2021 17:09:15 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 020/117] 53c700: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:08 -0700
Message-Id: <20210420000845.25873-21-bvanassche@acm.org>
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
 drivers/scsi/53c700.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index ab42feab233f..dba27011eeee 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -634,7 +634,7 @@ NCR_700_scsi_done(struct NCR_700_Host_Parameters *hostdata,
 		NCR_700_set_depth(SCp->device, NCR_700_get_depth(SCp->device) - 1);
 
 		SCp->host_scribble = NULL;
-		SCp->result = result;
+		SCp->status.combined = result;
 		SCp->scsi_done(SCp);
 	} else {
 		printk(KERN_ERR "53c700: SCSI DONE HAS NULL SCp\n");
@@ -1571,7 +1571,7 @@ NCR_700_intr(int irq, void *dev_id)
 				 * command again otherwise we'll
 				 * deadlock on the
 				 * hostdata->state_lock */
-				SCp->result = DID_RESET << 16;
+				SCp->status.combined = DID_RESET << 16;
 				SCp->scsi_done(SCp);
 			}
 			mdelay(25);
