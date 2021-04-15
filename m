Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469B5C43460
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1783D610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbhDOWJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:18 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:41979 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbhDOWJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:16 -0400
Received: by mail-pl1-f181.google.com with SMTP id e2so8571938plh.8
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZN3MZuHTHJ4rNU+gilbE6/v3nJ1AHPWmwmhT/kjNJ/I=;
        b=tvfip9zHVZvwMTy9nOkrM01ytI0PpRbKuMYfWVy2A0X71hmUnrG254TMF2zwrTtui6
         Jy9QSzXJ0jN6P+Ja57Xzm2EeWM4DAwub5PdPJ2cx0qwHRJxevv3Ct9XTd3hQYCSdBDIZ
         dYpVpLVrTsCj2D4r4Tmm8DmWjMQMcaR3Y4TLagO2ZRKN1tQt4/T6mlCI6Px42xKhMRIq
         g27V7Py8rkxCYfs9oHP6sVWvAxmxgide2CbkEJNQnCJ3xzutuHkBXf3EEWCNM1mpCxdV
         JMCWqZEAqMXxxX0lFVJzNVNEvIARmLI6bYwXDUbciSZ8aNL3LwbI/AppRdGWMks1NmDT
         Q1Xg==
X-Gm-Message-State: AOAM532pB5AgzB7Fjs/fLpxOEaZaqVZZwXUF48x0zjPtI6+z0SAbyNuH
        S3fC1S80xergLp6DfeWSS2Q=
X-Google-Smtp-Source: ABdhPJwVXuv+15PpvqrVNlTFY4/6swCwGRfSvKsxF7Gm/ci6pyq4sqc8SyMrZqUFA/iB3t8VK2fWjQ==
X-Received: by 2002:a17:90a:c781:: with SMTP id gn1mr6262083pjb.205.1618524532181;
        Thu, 15 Apr 2021 15:08:52 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 14/20] 53c700: Open-code status_byte(u8) calls
Date:   Thu, 15 Apr 2021 15:08:20 -0700
Message-Id: <20210415220826.29438-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 53c700 driver is one of the two drivers that passes an u8 argument
to status_byte() instead of an s32 argument. Open-code status_byte in
preparation of changing SCSI status values into a structure.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/53c700.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 4fd91f81244d..ab42feab233f 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -981,8 +981,8 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 						  NCR_700_FINISHED_TAG_NEGOTIATION);
 			
 		/* check for contingent allegiance conditions */
-		if(status_byte(hostdata->status[0]) == CHECK_CONDITION ||
-		   status_byte(hostdata->status[0]) == COMMAND_TERMINATED) {
+		if (hostdata->status[0] >> 1 == CHECK_CONDITION ||
+		    hostdata->status[0] >> 1 == COMMAND_TERMINATED) {
 			struct NCR_700_command_slot *slot =
 				(struct NCR_700_command_slot *)SCp->host_scribble;
 			if(slot->flags == NCR_700_FLAG_AUTOSENSE) {
