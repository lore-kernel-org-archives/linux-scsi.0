Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12898C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9E7B611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351215AbhERRqc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:32 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:41729 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351218AbhERRqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:30 -0400
Received: by mail-pl1-f177.google.com with SMTP id z4so3324428plg.8
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O26m5ff/UM4P7ukUgVUUUql3+v4hDno01O90uSqt7+M=;
        b=DM5tK65AJkFHToJ7xUb4DwI/nFM09QIwiNHg7LPWzZ29ho7fhPcIg8ZXteZN0LlYHr
         QRAAxR7Z6h4TlZawRU+gcsIzAVB/cctoVY3KzY9/3obhOuBIfoCcLeImJ5kVSHQF7Nos
         +B9sw41G59WMjy9c5ObpigENxBm6kyvjNmmgV+hUKS47DNW3UYnkcXaFLgZ8lyxIaO9t
         BmrleP5fUIB6WGJl5p585vFf+HJ+MNi8z+yPLbbfx+M6D2Bi9z/yS2M6DOanj11dM3bY
         NsNToZIC4nkt1jZbOgfNMiTApH9MH+stJiXhDJELvVSReJtuAbGTkFvkSp8tODXQ44P4
         iKRg==
X-Gm-Message-State: AOAM532W0eh1/DTA4mxRtgptMtf1Uki6vPy8ax1JI9/yTWgzwDh8UGvx
        2t9+IwGj8db9SgSvuyAmC48=
X-Google-Smtp-Source: ABdhPJyVrbQ47Ev0Pz5AHhQorAbmUqee8PBcfwVk2x50KgMATT37hAAlNX4Md4M8wiazxMyDIPvJ4w==
X-Received: by 2002:a17:90a:5406:: with SMTP id z6mr6452506pjh.130.1621359912327;
        Tue, 18 May 2021 10:45:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 14/50] advansys: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:14 -0700
Message-Id: <20210518174450.20664-15-bvanassche@acm.org>
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
 drivers/scsi/advansys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 800052f10699..dd6355382c62 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7427,7 +7427,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	 * Set the srb_tag to the command tag + 1, as
 	 * srb_tag '0' is used internally by the chip.
 	 */
-	srb_tag = scp->request->tag + 1;
+	srb_tag = scsi_cmd_to_rq(scp)->tag + 1;
 	asc_scsi_q->q2.srb_tag = srb_tag;
 
 	/*
@@ -7641,7 +7641,7 @@ static int
 adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	      adv_req_t **adv_reqpp)
 {
-	u32 srb_tag = scp->request->tag;
+	u32 srb_tag = scsi_cmd_to_rq(scp)->tag;
 	adv_req_t *reqp;
 	ADV_SCSI_REQ_Q *scsiqp;
 	int ret;
