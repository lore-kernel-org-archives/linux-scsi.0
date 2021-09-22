Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451FEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29D45611EE
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhIVQ1p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:27:45 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:45905 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236612AbhIVQ1p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 12:27:45 -0400
Received: by mail-pf1-f176.google.com with SMTP id w19so3126047pfn.12
        for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2021 09:26:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=27GFIeefWPZHjxBpQo7Oio5U/8onCBpvEAOm6fcyxA8=;
        b=Cq3gyi2yrav4kvtN8o4+abpJwSYgkAaAbmjTPW0HOQtU7KbI02FB25lsP6FeFiIwcF
         H181OsV8BDr2MAQS/VtXg3VG7rX2O4ipMPcwcbcRfy67VbwMJHk96/oiF2u8ms+R2Kkh
         Yye54fLJyT5WStezOLFiH6CYzZZrWmlEXonjcuxGU/jntz1B5JgvqQS6nRVwNp1kcrU4
         W/gbhE6m40x0YsRGhN9y3MixSRdCmkQAO79dWZpVI6OXhxCZQr9kjrLulbg8xzYRlT0w
         FJjW52ZEx3rlzEsFF21xEqEUKGahEzpALao9cdw9I95Ops8mtaWyim/7Lgth+4Ir3SG6
         rmJw==
X-Gm-Message-State: AOAM532G16f9D8RE2tu3W8mTqPRLGoslYVshdHYQ7F/kSsKIgk2Pr7el
        7PA/DwqVG65Jrw0nOCTz1vbbdijWcI0=
X-Google-Smtp-Source: ABdhPJwS2lhpa/GMA66jS1rMhtpvRG5yOS9kaDh3XlseWKL85av1e70v/LvIc4NdydDAcdNmBX883w==
X-Received: by 2002:a62:51c6:0:b0:43d:e849:c69d with SMTP id f189-20020a6251c6000000b0043de849c69dmr274073pfb.31.1632327974742;
        Wed, 22 Sep 2021 09:26:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f3b9:da7d:f0c0:c71c])
        by smtp.gmail.com with ESMTPSA id p26sm2311697pfw.137.2021.09.22.09.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 09:26:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 80/84] staging: rts5208: Call scsi_done() directly
Date:   Wed, 22 Sep 2021 09:25:58 -0700
Message-Id: <20210922162603.476745-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210922162603.476745-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210922162603.476745-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/staging/rts5208/rtsx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index 898add4d1fc8..f1136f6bcee2 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -140,7 +140,6 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 	}
 
 	/* enqueue the command and wake up the control thread */
-	srb->scsi_done = done;
 	chip->srb = srb;
 	complete(&dev->cmnd_ready);
 
@@ -423,7 +422,7 @@ static int rtsx_control_thread(void *__dev)
 
 		/* indicate that the command is done */
 		else if (chip->srb->result != DID_ABORT << 16) {
-			chip->srb->scsi_done(chip->srb);
+			scsi_done(chip->srb);
 		} else {
 skip_for_abort:
 			dev_err(&dev->pci->dev, "scsi command aborted\n");
@@ -635,7 +634,7 @@ static void quiesce_and_remove_host(struct rtsx_dev *dev)
 	if (chip->srb) {
 		chip->srb->result = DID_NO_CONNECT << 16;
 		scsi_lock(host);
-		chip->srb->scsi_done(dev->chip->srb);
+		scsi_done(dev->chip->srb);
 		chip->srb = NULL;
 		scsi_unlock(host);
 	}
