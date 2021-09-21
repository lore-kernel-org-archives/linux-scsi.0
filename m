Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49334C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 261E161178
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhIURgb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 13:36:31 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:33317 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhIURga (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 13:36:30 -0400
Received: by mail-pf1-f173.google.com with SMTP id s16so234766pfk.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 10:35:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=27GFIeefWPZHjxBpQo7Oio5U/8onCBpvEAOm6fcyxA8=;
        b=sgx8AFr08FtzQn5BjSoA6u0zBkCz38pYuHWEZ7hD0r8zjXyQ4RctTse+yJACkWopa/
         NjHKn6dF8nUsAAsusGXRUZDE77lI2rswDSZYZHfQzVPQMnVk4dWdf8jLbzv/TD5/o3oI
         MkTyNs8qv8S2uqmiI9Pb/GqowgPA2yVQJijGxIeZ6PoJBochXBxkKcqdiH9G/fzNU+uJ
         mwksTA19zssKMTtRS37xOjQC2v1uqgwG4ChCC4KI4b5oWIYs9ZvoJ1NUXCDnnsx+zlhS
         sajbI3ljuVQ3NSsneJCifdFxvmn59myA0YHvjBA6MP9NO/kFgHKx2FeDDVjFOrOuWwad
         z+zg==
X-Gm-Message-State: AOAM533l/Grd8QbyhDDhxMFlV5NeHYJTjxlWgL/3HiixkCHe363d1/y4
        6jLJ8u4xWy8HmAoVRYvIbCE=
X-Google-Smtp-Source: ABdhPJyM6woAOo2wY1wSoFfRHW15o4ATlC0wq/FadMAfEWd2lFRiol6AV2zE8/tE0E1XQV1lj9PvEQ==
X-Received: by 2002:a63:da49:: with SMTP id l9mr28881764pgj.277.1632245701506;
        Tue, 21 Sep 2021 10:35:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3f15:8d17:800:eea3])
        by smtp.gmail.com with ESMTPSA id w22sm14561603pgc.56.2021.09.21.10.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 10:35:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 80/84] staging: rts5208: Call scsi_done() directly
Date:   Tue, 21 Sep 2021 10:34:32 -0700
Message-Id: <20210921173436.3533078-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210921173436.3533078-1-bvanassche@acm.org>
References: <20210921173436.3533078-1-bvanassche@acm.org>
Reply-To: 20210918000607.450448-1-bvanassche@acm.org
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
