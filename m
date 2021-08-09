Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49EDC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAB1D60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbhHIXFG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:06 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:35338 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236275AbhHIXE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:59 -0400
Received: by mail-pj1-f44.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so1520194pjs.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2V8/BN2iPNBw51OsSyudNN7wtqGW0C1CVr1gqNgEZw=;
        b=irFtQH5g+iYR2p1xp0U4lc95IIsgOdIqOvXSQfxvnCEn3e94x6KFVF49yqG6b8LGoX
         hkP1pzYLxlQuyH9hP4f9ZhmKlGrGWCljaFNT98nEmACnJO/hB2AmU2eSWjT4wuAYRx5R
         kwKuYUPHCBuZ6xHlE8OqgADuFbv5MTIrRttYpsq4F99x3sflt57lbnKc7RFWErPK+tQB
         x3DZzrJFlo6KuG47r8ng7q40zMUS4gStPfZfpmUxldNaePJsnVuZwAu7IIhoVxxx/lHz
         WDR66iaXc7Jo05cBSUGAJwQdgDBFqTG2wNysLwqkTuE00fQgY9vA4OHYJAsTSIvXyOSU
         JGSQ==
X-Gm-Message-State: AOAM530LP0uNWWhu2zDsrYN8boLm8QXh5af81GYt+bBmu7xHRHZrZIqt
        lKaKnMBzAg4HptuoP6+JmgQ=
X-Google-Smtp-Source: ABdhPJw/5lKfgmdJ33khV+KDx0kWUOk1DhJG1uVWSb3mkfnJhTONp/KgwMbnbQi5pgdIv9vtjGgVKQ==
X-Received: by 2002:a63:2541:: with SMTP id l62mr889844pgl.183.1628550278462;
        Mon, 09 Aug 2021 16:04:38 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 23/52] ibmvfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:26 -0700
Message-Id: <20210809230355.8186-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index bee1bec49c09..c372bbc5e218 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1911,7 +1911,7 @@ static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	struct ibmvfc_cmd *vfc_cmd;
 	struct ibmvfc_fcp_cmd_iu *iu;
 	struct ibmvfc_event *evt;
-	u32 tag_and_hwq = blk_mq_unique_tag(cmnd->request);
+	u32 tag_and_hwq = blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
 	u16 hwq = blk_mq_unique_tag_to_hwq(tag_and_hwq);
 	u16 scsi_channel;
 	int rc;
