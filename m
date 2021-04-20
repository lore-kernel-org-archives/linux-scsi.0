Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043C4C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D323461363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhDTAK2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:28 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:35791 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbhDTAKS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:18 -0400
Received: by mail-pj1-f49.google.com with SMTP id j21-20020a17090ae615b02901505b998b45so6028529pjy.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nL9cxygs1wA1Iy23q/ju/a4ZANjJRPco9wm6Co0e7Wc=;
        b=TD8O1EgNSabDeUJWo4ciXr6YGSs+8x6CXvYc1pvIhHDVm25vIx3WpOvGtLHdcFC2Sm
         qOQyzaGDeDUUCxBTrVFZNveYBp0bCpoM+FLAvqtDO/YXiljWWOsySSW0mfIBc4Bzem8k
         IsIXHfcqAqjxTaM2rS/6jeW5x7BlBNgW6sjI3AJzV9Mjpu7is+j7B8pjaCoC5ojlrtxE
         K6tkXKv95ZsAMn+27p+nUApRTVxIfgfXnxlSDh2kBbesOwe1bPUi1quuXGeZfH7OewbK
         Cr79nEdGY/5OTTSGzLAuae+KwBE/P2mRQ+HkkkBDofSdU1FcyNh6CaRAVRuFr91P2T0s
         wBzg==
X-Gm-Message-State: AOAM533nz0w9s6foOpsTx7+GS+2vFoKozGXgyTpwpbTj8hGNTmsYFtyA
        EDbRzoMF4zLmCKb60sLGzAY=
X-Google-Smtp-Source: ABdhPJxanPHQao3CEr1XhwSjXNFoXJbbCW+LOJhOCWNG/XFdxvRTsHiF5Ap4hAcXpHaNAkbMrN8t2g==
X-Received: by 2002:a17:902:59d4:b029:ea:bbc5:c775 with SMTP id d20-20020a17090259d4b02900eabbc5c775mr25980609plj.11.1618877387425;
        Mon, 19 Apr 2021 17:09:47 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 048/117] fdomain: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:36 -0700
Message-Id: <20210420000845.25873-49-bvanassche@acm.org>
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
 drivers/scsi/fdomain.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 772bdc93930a..a985a15588dc 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -206,7 +206,7 @@ static void fdomain_finish_cmd(struct fdomain *fd, int result)
 {
 	outb(0, fd->base + REG_ICTL);
 	fdomain_make_bus_idle(fd);
-	fd->cur_cmd->result = result;
+	fd->cur_cmd->status.combined = result;
 	fd->cur_cmd->scsi_done(fd->cur_cmd);
 	fd->cur_cmd = NULL;
 }
@@ -439,7 +439,7 @@ static int fdomain_abort(struct scsi_cmnd *cmd)
 
 	fdomain_make_bus_idle(fd);
 	fd->cur_cmd->SCp.phase |= aborted;
-	fd->cur_cmd->result = DID_ABORT << 16;
+	fd->cur_cmd->status.combined = DID_ABORT << 16;
 
 	/* Aborts are not done well. . . */
 	fdomain_finish_cmd(fd, DID_ABORT << 16);
