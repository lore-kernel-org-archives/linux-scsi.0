Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1F3C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A425461019
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbhHIXFQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:16 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:39697 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbhHIXFN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:13 -0400
Received: by mail-pl1-f170.google.com with SMTP id l11so6719285plk.6
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PBomNPnl7STZls/aW5wCX5ThJyBjrSASUkls2nsP9Q0=;
        b=V+Glmfp4Trt7+n8ee/5bQqquGTh3XI6oPgMgo5LUzrww8LZCVaRo4Y0BC1nRJE/KPL
         OYQ6NShY37xw5+1azusayu8HlETtiTIbvJMMsVlkIbWZw+hqGf6iOW2tJUOY4dc3NBJS
         sswGths9EDLSyiuJN43+sl0C3o8R4YFIsKDmbyspciquAg8D8lU3rkeyDtZWKPWJAb2Q
         yOo2MtW+8+M8ThY4yQHZVz9kRo+1ryInpiZ4lLaqwQrjh7lKnlWe8q4qOZUrXmHiSVH0
         CnVE+rTgVAJ1OUX4jKWLAU67BMScXNmt72oi706yjpcIVL+6+78lFGmmOqeTXNUJTPFw
         mKUg==
X-Gm-Message-State: AOAM533VFEH9DWS7L4V54VY4i3iqN8/FKZaIAASSgc2RnvwmE/TULlea
        J5phLG2un4/d4H5ticOJYlg=
X-Google-Smtp-Source: ABdhPJxXYOU8rFjhkGWgwnXpxj2jVWhmCam2wFWEW/kTVcUz6mWJWay8Z1te5hHCPe6CEIUkjGEJ3g==
X-Received: by 2002:aa7:8d54:0:b029:3cd:6ce7:bec6 with SMTP id s20-20020aa78d540000b02903cd6ce7bec6mr3849362pfe.69.1628550292341;
        Mon, 09 Aug 2021 16:04:52 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 31/52] mvumi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:34 -0700
Message-Id: <20210809230355.8186-32-bvanassche@acm.org>
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
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 6bb03d7a254d..4d251bf630a3 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -702,7 +702,7 @@ static int mvumi_host_reset(struct scsi_cmnd *scmd)
 	mhba = (struct mvumi_hba *) scmd->device->host->hostdata;
 
 	scmd_printk(KERN_NOTICE, scmd, "RESET -%u cmd=%x retries=%x\n",
-			scmd->request->tag, scmd->cmnd[0], scmd->retries);
+			scsi_cmd_to_rq(scmd)->tag, scmd->cmnd[0], scmd->retries);
 
 	return mhba->instancet->reset_host(mhba);
 }
