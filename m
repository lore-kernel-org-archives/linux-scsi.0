Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C754FC43462
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA4D6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhDTAJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:31 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:44015 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhDTAJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:28 -0400
Received: by mail-pl1-f180.google.com with SMTP id u15so10123429plf.10
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:08:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=olMxQNi6JGmQX++ziQUw17gqpwgachhoqWTVO9k2f7g=;
        b=XF5RZ3La+/OfdJZYd+o3z/YTWLZk6zMZeOV1+5I8+UqEkBzHTo6Z3GsPT31Zm0orL9
         VRP5CgeZRyURLgpcZaml3vdrJd0hXeANBNIEbBcRzmWv8GoScN6MLAecu+EF9FY2M3cT
         4NEBLwywb9BlF15sFxCsMHA9zcsZBaLbXA3TpcAkbW0SbWi98S9X1m1zd5wIiGQm1Czm
         wfu/nReeOpYVWtS1o+/WDFCqI+G5gGgqTYHjm3KugOU24uxn9b1u9xDpmVZgtPCnIXfJ
         FEj/yfElIxso061INVMj5PTNhy+oTUP+d9UAe8gNy0SgjRXvfhNFfEbr7L9Og8Vtg+LT
         H2/A==
X-Gm-Message-State: AOAM533g92mmOPw2i8duF9HZ8m3djGRz/0EqY9X0HDSGoz/3855HjOnn
        41Xh91vuOrCFkfRQUNCvjbfngnuF3i8=
X-Google-Smtp-Source: ABdhPJxYIcYaJ2e1mqVXg2sMiDjmxwJacZwYFv30Uf7CFBUa6v/JZ8pwwEMDOpgepCebzrHOLSP3Xw==
X-Received: by 2002:a17:902:cece:b029:ec:b451:5803 with SMTP id d14-20020a170902ceceb02900ecb4515803mr2198372plg.60.1618877337564;
        Mon, 19 Apr 2021 17:08:57 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:08:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 005/117] libsas: Use the host_status and sam_status enums
Date:   Mon, 19 Apr 2021 17:06:53 -0700
Message-Id: <20210420000845.25873-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow the compiler to verify the type of the values assigned to the ' hs'
and 'stat' variables.

Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libsas/sas_scsi_host.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1bf939818c98..0be979caf7e3 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -37,7 +37,8 @@
 static void sas_end_task(struct scsi_cmnd *sc, struct sas_task *task)
 {
 	struct task_status_struct *ts = &task->task_status;
-	int hs = 0, stat = 0;
+	enum host_status hs = 0;
+	enum sam_status stat = 0;
 
 	if (ts->resp == SAS_TASK_UNDELIVERED) {
 		/* transport error */
@@ -88,7 +89,7 @@ static void sas_end_task(struct scsi_cmnd *sc, struct sas_task *task)
 			stat = SAM_STAT_CHECK_CONDITION;
 			break;
 		default:
-			stat = ts->stat;
+			stat = (enum sam_status)ts->stat;
 			break;
 		}
 	}
