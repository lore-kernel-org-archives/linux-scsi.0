Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3BEC47083
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EA0061166
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhEXDK4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:56 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:45821 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbhEXDKx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:53 -0400
Received: by mail-pl1-f182.google.com with SMTP id s4so12350431plg.12
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O26m5ff/UM4P7ukUgVUUUql3+v4hDno01O90uSqt7+M=;
        b=BebXBBMSSw4bZO7ukZ2OObQHly0CosOPq4IVvoenCaIuTTKBYWkdrj69O2xxlL+SUc
         yuKk5MnCbr9QyWQpsCCFIhLmzCM/AKCLdwBT3sVbMs1wXVGsV25ZBbjVFBMJ2nLQUVfF
         x9ifcGxGeLm7SpWUCxGXiNCpQCZkzIb81V+VWGqy1yIUrPV8gDdqtv2cRgJ30G+LalJg
         /Fg/2D0t7rhJo8xPrUlHHpGmdAxA6mhzGElCEMHVcvoaCs5EBnkBYXVfXufCmZi1iHd3
         5yuh630bZm0WlCe+qIfsoIEwPkSeodNuqHgO2VAPtdTRE9y0UtZYwZJVIwM+KQuMutve
         H3UQ==
X-Gm-Message-State: AOAM53396/kaUIoeZJMeeCVHSP550sb3bn5nucDx4HkaLbyvnS6GON48
        FV60rU55chJI+w+W6cGsKvE=
X-Google-Smtp-Source: ABdhPJz5NwOSIDy7ELhVqFrVBuvE8QNn6CXbLDWNGgZIGVI3+uY/iEnK14ekJNCgW6U6NoUPuX+qPg==
X-Received: by 2002:a17:90b:b03:: with SMTP id bf3mr22456506pjb.107.1621825765312;
        Sun, 23 May 2021 20:09:25 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 14/51] advansys: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:19 -0700
Message-Id: <20210524030856.2824-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
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
