Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573CAC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D94560F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343596AbhIRAKn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:43 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:37532 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345133AbhIRAJt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:49 -0400
Received: by mail-pj1-f44.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so10463174pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLjrkUrDGjiUH0yp0QEebobu1TDlTcuEBk039zm4Bj8=;
        b=LMt20obShGApzR5a7wnp5oF4soka1+YT4zCJ9A0MHRPMB6lmkHAV2F/SN4wWvvzkjL
         oQsohiHp/P7NRMbKMzlRD2nlnjHSVLc7iQeOkrNaLQnh7a3yiXPjr4v+eggrG6JR+ew6
         couN8amTFPd70/b0AqiGwA4ZY6BtVt3W4VUrtsa5NwDjbmd3x31Zcppd6j3dxXujl8mk
         aAfJ8wsKa0YbahR14QmCRUVdGW68Zln+V7r5stVDkc9pM6urzqUvJYaS9QJZiUx11pfc
         xoXl4TyaUNkkWlv366PgoFXT3pQm8WJeHCAj7xPlUFZkGhnLPEQ049M3hJ3vCIGrluvH
         18fw==
X-Gm-Message-State: AOAM533N/wl10S06IIlgUqpKfsQM2ksvh0JV2Q8VssDXV3TfwIWugFUp
        bp2b/mBRw0EQCz9h+NCdlbI=
X-Google-Smtp-Source: ABdhPJysCuqaFqKduoI3X96tQMFt8KiFpKJSHs04qGN4Ca0N3QZd//ZL5+2eXLyetO1R/VGPwML51g==
X-Received: by 2002:a17:90a:de0b:: with SMTP id m11mr24297358pjv.39.1631923706116;
        Fri, 17 Sep 2021 17:08:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 78/84] wd719x: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:06:01 -0700
Message-Id: <20210918000607.450448-79-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/wd719x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 6f10a43510fb..1a7947554581 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -200,7 +200,7 @@ static void wd719x_finish_cmd(struct wd719x_scb *scb, int result)
 			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 
 	cmd->result = result << 16;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 /* Build a SCB and send it to the card */
@@ -295,7 +295,7 @@ static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 			 DMA_BIDIRECTIONAL);
 out_error:
 	cmd->result = DID_ERROR << 16;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	return 0;
 }
 
