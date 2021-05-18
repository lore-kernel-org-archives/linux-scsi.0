Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1E1C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61D6B61209
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351233AbhERRqc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:32 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:52739 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351215AbhERRq3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:29 -0400
Received: by mail-pj1-f54.google.com with SMTP id q6so5921055pjj.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6VDMqIL9H4Vn/0bg6+sZt18TM3BKAyfd8LmUZUGrSQk=;
        b=fTWGoKXnYGGuPCZe6cRxaz7iVmh0ymYLgETwCwrJLEyf5HvL+9Su+boSiGO3Q0m2/b
         9oF83CaAvJe9db3/K4UQH6mr+XU1yGu4ePFJv9bMIlBPtwLnZvRvkyHWsfTLrVoeH3nC
         VqSWVehGstKDPuQF7omxrC3e+Fd4sMGAlM4Ar/nbgal/TRzFaxJuMHmRc086yp3Tvpl/
         qHehlBVzjxt/pcPwRsfzsbLdpYLzsKnm8YbcstiBGf7INJv6DnkHpp60BQIt0S0P15h1
         1RdSXgDiEvkwypriouF9CnDE72cAjlED/J+cipzHrumTBMrHhCKPtp0ZbGV4RQLAUAkU
         +n2g==
X-Gm-Message-State: AOAM532OX7V0mPpkBUQ4YoeJ+RK8MpLKLhjBVjv5cbTGNKM5benHb+Kz
        0lZfQfgk2kokDFyUXCT0QjY=
X-Google-Smtp-Source: ABdhPJxe2WZRb3rSqS+yx0C5vC8Jum+u5BxIaa8Q4vQsD5cXAaxrrrP851HjLiXuk8BtF54IFITGpA==
X-Received: by 2002:a17:902:d503:b029:f2:c88c:6349 with SMTP id b3-20020a170902d503b02900f2c88c6349mr5918419plg.84.1621359911333;
        Tue, 18 May 2021 10:45:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 13/50] aacraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:13 -0700
Message-Id: <20210518174450.20664-14-bvanassche@acm.org>
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
 drivers/scsi/aacraid/aachba.c  | 2 +-
 drivers/scsi/aacraid/commsup.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 46b8dffce2dd..567d305d3ab4 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1505,7 +1505,7 @@ static struct aac_srb * aac_scsi_common(struct fib * fib, struct scsi_cmnd * cmd
 	srbcmd->id       = cpu_to_le32(scmd_id(cmd));
 	srbcmd->lun      = cpu_to_le32(cmd->device->lun);
 	srbcmd->flags    = cpu_to_le32(flag);
-	timeout = cmd->request->timeout/HZ;
+	timeout = scsi_cmd_to_rq(cmd)->timeout / HZ;
 	if (timeout == 0)
 		timeout = (dev->sa_firmware ? AAC_SA_TIMEOUT : AAC_ARC_TIMEOUT);
 	srbcmd->timeout  = cpu_to_le32(timeout);  // timeout in seconds
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 54eb4d41bc2c..deb32c9f4b3e 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -224,7 +224,7 @@ struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 {
 	struct fib *fibptr;
 
-	fibptr = &dev->fibs[scmd->request->tag];
+	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
 	/*
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
