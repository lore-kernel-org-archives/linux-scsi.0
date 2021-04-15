Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE84FC43470
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85076610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbhDOWJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:18 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:35782 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbhDOWJR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:17 -0400
Received: by mail-pj1-f49.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so15227379pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YMKuvSuStmi+Y5MBD+/AJkPa4jmcUESw9esKkMO9iHU=;
        b=lRiNefsJwfkuD5Iukdwq5Pyi7tnzbRkMxAGB5/oadpDbH16JEoBsxSfcrEwub8pHBa
         deS9H6bPFq1yOb68V1KRyPnS3oWHlZuTD3sOFSoYOmB0zZTZzGreeML0UMVt8I/59cXn
         azhKra95FE3AoqlhWyd+EZKr7kmASbmUuzrufYNHbO7QubUFgHbH5Ngxl1ps1sc873jg
         Zdy4ShAf2Z2PkTk8xkfP4WJCacIyBlfBknBOjc9B3V13eJT1lYEJ68frOk+WSk9LkHGA
         xMVHSX/r+okjdPtTTdssWKwBdyrreXF76HHtHLNyZZPdGzT4U64R73rOyDae2qAnOwAp
         86ew==
X-Gm-Message-State: AOAM532wYN2rNnv8Y3RaiV7bIg/o6i5EHyBPTArZSpmJGP3+bsnr1UIs
        2i0MGQ6xhtZiWfUGkgqMt28=
X-Google-Smtp-Source: ABdhPJxWdD9RjVlrKoUWvN1jQUIT3V2tNmDDDFiM40lx1Zn/ck6l08cAd6k6mJW/i+I59tMp6x88Aw==
X-Received: by 2002:a17:90a:a589:: with SMTP id b9mr2265139pjq.80.1618524533270;
        Thu, 15 Apr 2021 15:08:53 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH v2 15/20] dc395x: Open-code status_byte(u8) calls
Date:   Thu, 15 Apr 2021 15:08:21 -0700
Message-Id: <20210415220826.29438-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The dc395x driver is one of the two drivers that passes an u8 argument
to status_byte() instead of an s32 argument. Open-code status_byte() in
preparation of changing SCSI status values into a structure.

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/dc395x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 1e9ec4d8c605..be87d5a7583d 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3258,10 +3258,10 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		/*
 		 * target status..........................
 		 */
-		if (status_byte(status) == CHECK_CONDITION) {
+		if (status >> 1 == CHECK_CONDITION) {
 			request_sense(acb, dcb, srb);
 			return;
-		} else if (status_byte(status) == QUEUE_FULL) {
+		} else if (status >> 1 == QUEUE_FULL) {
 			tempcnt = (u8)list_size(&dcb->srb_going_list);
 			dprintkl(KERN_INFO, "QUEUE_FULL for dev <%02i-%i> with %i cmnds\n",
 			     dcb->target_id, dcb->target_lun, tempcnt);
