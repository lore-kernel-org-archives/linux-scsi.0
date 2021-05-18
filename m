Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B69BC43470
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EBE761074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351230AbhERRqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:31 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:41793 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351211AbhERRq2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:28 -0400
Received: by mail-pj1-f49.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso1978720pji.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LXPFyN7HL/YvhI+SDs8OvanjEXM60MW2yKKeGDCzmRM=;
        b=KO4bK9BZjLwX36G0oTPoMa8fMMfHeLsHQeM5eUrpFMRzbtszBfqS+4Ae0NjcQGmwRl
         WZuJN39mWchgp/w7B76hd0Dm+8wBXohz/jrlo5GQTO/sMok1TzEczRXUUKvet2WPvj87
         lTdgbt1wERV4Pf4FUx5wma4ojWD96ouTGpLimaDRbWcimdBsy0xCjwqwJt/ymykJ0QR+
         zHfDNA3UWQG3yFA80BAHP2N1ow5jJ63S8Om6mkONvrunBZU3cGSoNUwJ8q2kL8DrZLYs
         CoOXJaAClfciP8PCWgJ98kl6Ms8PiSx5AgDiC6nuinYbH3PNA6KqdXV8M8hUqbW1pxcg
         +llg==
X-Gm-Message-State: AOAM531hbWUrsH6GQMwDE1QbOCtDSGiI2qRUpjNmW8sQjN5OKhdTSKfP
        4FXjcSv1T5/XL1QimrJwvzk=
X-Google-Smtp-Source: ABdhPJzql8gbU5+aJuPmmgPbfp5Dab163mTopsKEDjRd9UyioBc9Kttzl6asnBy5PzZPXxD9Azi+dA==
X-Received: by 2002:a17:90b:14d7:: with SMTP id jz23mr6791243pjb.105.1621359910145;
        Tue, 18 May 2021 10:45:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 12/50] NCR5380: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:12 -0700
Message-Id: <20210518174450.20664-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/NCR5380.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 2ddbcaa667d1..47502f63a167 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -778,7 +778,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
 	}
 
 #ifdef CONFIG_SUN3
-	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request)))) {
+	if ((sun3scsi_dma_finish(rq_data_dir(scsi_cmd_to_rq(hostdata->connected))))) {
 		pr_err("scsi%d: overrun in UDC counter -- not prepared to deal with this!\n",
 		       instance->host_no);
 		BUG();
@@ -1710,7 +1710,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				count = sun3scsi_dma_xfer_len(hostdata, cmd);
 
 				if (count > 0) {
-					if (rq_data_dir(cmd->request))
+					if (rq_data_dir(scsi_cmd_to_rq(cmd)))
 						sun3scsi_dma_send_setup(hostdata,
 						                        cmd->SCp.ptr, count);
 					else
@@ -2158,7 +2158,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		count = sun3scsi_dma_xfer_len(hostdata, tmp);
 
 		if (count > 0) {
-			if (rq_data_dir(tmp->request))
+			if (rq_data_dir(scsi_cmd_to_rq(tmp)))
 				sun3scsi_dma_send_setup(hostdata,
 				                        tmp->SCp.ptr, count);
 			else
