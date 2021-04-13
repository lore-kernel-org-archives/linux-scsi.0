Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2473C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC3C5613B7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347128AbhDMRIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:08:10 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:33436 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347094AbhDMRH7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:59 -0400
Received: by mail-pf1-f173.google.com with SMTP id a85so11395150pfa.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZN3MZuHTHJ4rNU+gilbE6/v3nJ1AHPWmwmhT/kjNJ/I=;
        b=GUpDWhC8FWZrbZoXEgYH3ZNjPmdOzrodigcFcH74WxgJ/xcTcczghczb7v2toyy1X6
         3J9qZDOTogY1qGunGFZVKkVC40ZtpcIVW8stYUbUCk75+Zooy+BIhCNXmskxgotdakEP
         B1Dib92oRy3y9IR3jR6EadSBkKUaIrP/U5INyWAJYI/GEDnyxak8Ua1rOsN4AOmDraIk
         KZqGKzTkrXJldhtXX3OXWbh4UDIM1ZJlV2yH2+xvAotq0t/Hp0gEL/UO2i+nrpj9+C8C
         8B2MnabhttIR3fkRlLkOeenfL01FEQzxLtzJ6Wj16BHdD8NjRHgXc0V6gZ5bE866Z9PJ
         /ZNw==
X-Gm-Message-State: AOAM530Xw8uCZxTM0ulJln62cOO5yLsofeMRIRfUSQYYcwRxN5NkSXXl
        v7+miSeUf0gIqlFMkl8Piw9JtSgszps6LQ==
X-Google-Smtp-Source: ABdhPJz3WBLR6eztDTMTUaPgNxmOU6TC/G86GP4jAPT7UW9vQWVFP4tBNtND2g9MuMARvWQ2Cdn4nw==
X-Received: by 2002:a62:2943:0:b029:24b:f35d:2565 with SMTP id p64-20020a6229430000b029024bf35d2565mr12294817pfp.52.1618333659171;
        Tue, 13 Apr 2021 10:07:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 15/20] 53c700: Open-code status_byte(u8) calls
Date:   Tue, 13 Apr 2021 10:07:09 -0700
Message-Id: <20210413170714.2119-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
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
