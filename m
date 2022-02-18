Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C065C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbiBRTwb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238324AbiBRTwN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:13 -0500
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79184291FA7
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:56 -0800 (PST)
Received: by mail-pg1-f175.google.com with SMTP id f8so8736517pgc.8
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwYKhyFHil4fSG2RLAlZPEkTLtDpBryjbZMFKiNxE5M=;
        b=6Lj6+PrFZ5QgSAsr0Lgh5a5y5YJejkik9vPD7/QG5/AKS1/omeI6FKuB/tMu+4yW3D
         h29pUej8U9SE1w/s3shDGk0BY2+aXT9U3zY35icDIfG26CkESEZJBBqk8Qzjgx7Nq4XX
         rAPRRtvArbabOY9ZAU96gpF00uGGPJhEWVhbeGlhGzjDgtHcj/FoJ0p4ltgCDwlwFK3g
         xW8hELQaywRqdifQbpJaAxRXYRyRG3UAOIDRqv+5V2hgnhMy3ax8UA5PrlCjgkyKHEeA
         3PApclUyweMc3BwJIHQgtkT+L+iSd+3y/qpJ8xjZbQ45SJoTmmmi85XY1Y8hFY4L/pqv
         ikRQ==
X-Gm-Message-State: AOAM530ONOV3SBZeKRQCRk6xNbsloa2G6srgcwlG+BNHEePScLs9eSyt
        ZIh0Hnb6CW89OkK2S4FTlgY=
X-Google-Smtp-Source: ABdhPJwNKPM2ciRMKk4lPYnP2g94DYqH+hAR5Nhq/gJ2SculozSWDQAiB3DgzwscB7qc6X+onJFXIw==
X-Received: by 2002:a63:b345:0:b0:363:8ee2:6669 with SMTP id x5-20020a63b345000000b003638ee26669mr7586365pgt.20.1645213915888;
        Fri, 18 Feb 2022 11:51:55 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:51:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 14/49] scsi: aha1542: Remove a set-but-not-used array
Date:   Fri, 18 Feb 2022 11:50:42 -0800
Message-Id: <20220218195117.25689-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following W=1 warning:

drivers/scsi/aha1542.c:209:12: warning: variable ‘inquiry_result’ set but not used [-Wunused-but-set-variable]
  209 |         u8 inquiry_result[4];

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha1542.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index f0e8ae9f5e40..cf7bba2ca68d 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -206,7 +206,6 @@ static int makecode(unsigned hosterr, unsigned scsierr)
 
 static int aha1542_test_port(struct Scsi_Host *sh)
 {
-	u8 inquiry_result[4];
 	int i;
 
 	/* Quick and dirty test for presence of the card. */
@@ -240,7 +239,7 @@ static int aha1542_test_port(struct Scsi_Host *sh)
 	for (i = 0; i < 4; i++) {
 		if (!wait_mask(STATUS(sh->io_port), DF, DF, 0, 0))
 			return 0;
-		inquiry_result[i] = inb(DATA(sh->io_port));
+		(void)inb(DATA(sh->io_port));
 	}
 
 	/* Reading port should reset DF */
