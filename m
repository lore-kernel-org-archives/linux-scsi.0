Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D3BC4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 731B661132
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242739AbhHETTZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:25 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:39764 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242899AbhHETTS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:18 -0400
Received: by mail-pj1-f51.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so8405557pjn.4
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zjtNFhM1KDGLUdflS1XytX4Z043p6HTcOrxBauZ4T6Y=;
        b=qxkpAyBGwKoLR8C/F21beG//GkjfxiJptf8kBM4UM3K+UO8L7fEDR+WqPgnTgufObo
         tuwtoLFI6fof7gQVrRr61OljCP1gxiILjANAZAJ5bEOa2B9706wiMethua5XEH+QNlK2
         OCSsjeK1EmQIin0biqAFlRFHsr6RZfgGVKXXnD0YhoANwMsyn2tLvkABl29ce3FDs7y6
         9ZHcGvqNkyUDyNZzYY95t/URDHWehedfvwun/oir5tQORI8nf6HiUPxALnJ2+8XtNrGq
         UB21a1hW/9BEW2wv/qCRU3L/7Tt2UPsMw6laPKYwPl75JsDlvTrljt6du0uESSipKVXs
         GLXg==
X-Gm-Message-State: AOAM532gWq0+rSm6dXD7+5tU7KJZpF3btGEKh2ZY5T0Zdmft9bK55lWv
        i/igsb6QyHNLKOseDg5nrUc=
X-Google-Smtp-Source: ABdhPJzgHlG5mp1EczLdKUdxPfGcj/do3ThoNjGTWq14jCRhRMU7CAq7o8x/0u3mDbrIBOz6Yvy5mw==
X-Received: by 2002:aa7:9e0d:0:b029:3a9:e8dc:2085 with SMTP id y13-20020aa79e0d0000b02903a9e8dc2085mr6705069pfq.73.1628191137963;
        Thu, 05 Aug 2021 12:18:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 12/52] NCR5380: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:48 -0700
Message-Id: <20210805191828.3559897-13-bvanassche@acm.org>
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
 drivers/scsi/NCR5380.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 3baadd068768..c6f76c25f6c1 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -778,7 +778,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
 	}
 
 #ifdef CONFIG_SUN3
-	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request)))) {
+	if (sun3scsi_dma_finish(rq_data_dir(scsi_cmd_to_rq(hostdata->connected)))) {
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
