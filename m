Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9462C07E95
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 03:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8549561206
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 03:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhGKDjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Jul 2021 23:39:19 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:36479 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhGKDjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jul 2021 23:39:19 -0400
Received: by mail-pj1-f53.google.com with SMTP id d9-20020a17090ae289b0290172f971883bso10018784pjz.1
        for <linux-scsi@vger.kernel.org>; Sat, 10 Jul 2021 20:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJv5Q2mUDVi5xcdQYYlqkcpXwW1wCTQ+oAZZb+FZouY=;
        b=UqwMXWPC46kcqPGuOT6smcn+P2WmCVxWo/OstbmJmEgwo7dmRoO2aeaBTJ9cncUIOP
         xTlAxsL+Pwl3/t8uNItzwyLI53c9qVcW7b40PVmPM8sG3k2yquRxMKCsmWG6yK9a0oLF
         9trY73vDVPSMO0KhBSd/WH8Jg1nNP/nI/5gOqxuNAkQ4odPTZnVbOD9+/DmoAB+P6USy
         7+Nk9lRcTiKhI9YWbd3PU+JYVyr8UIbbZHzVdMEOuG8maVhXJJ4gar/3n+lkpX5YmNlD
         h4lc66Os2RaM7Xkhx5mFgttNnQvWtsVuopPB9SpXOVQ53fjI0Kzz1K9B39TSuqj/50mf
         Xppg==
X-Gm-Message-State: AOAM532klT5Qn9MagflsKspF7ZlBsxVaP8T3q0ebFNclTTJ+wiao3WJI
        hLPb9uFZyPM84n3Azn4fHX0=
X-Google-Smtp-Source: ABdhPJzphGWilpAJQ1oWZefHL7MTEBMzmXfkknkbCYbCjbQtASISUAkw/lEUEiHHhpYK7Or7xunlDg==
X-Received: by 2002:a17:90a:8e82:: with SMTP id f2mr7464632pjo.177.1625974591695;
        Sat, 10 Jul 2021 20:36:31 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4cac:d4d:4724:a273])
        by smtp.gmail.com with ESMTPSA id z9sm10689468pfa.2.2021.07.10.20.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 20:36:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi: fas216: Fix a build error
Date:   Sat, 10 Jul 2021 20:36:23 -0700
Message-Id: <20210711033623.11267-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use SAM_STAT_GOOD instead of GOOD since GOOD has been removed.

Cc: Hannes Reinecke <hare@suse.de>
Fixes: 3d45cefc8edd ("scsi: core: Drop obsolete Linux-specific SCSI status codes")
Fixes: df1303147649 ("scsi: fas216: Use get_status_byte() to avoid using Linux-specific status codes")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/fas216.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 30ed3d23635a..6baa9b36367d 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2010,7 +2010,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 		   "request sense complete, result=0x%04x%02x%02x",
 		   result, SCpnt->SCp.Message, SCpnt->SCp.Status);
 
-	if (result != DID_OK || SCpnt->SCp.Status != GOOD)
+	if (result != DID_OK || SCpnt->SCp.Status != SAM_STAT_GOOD)
 		/*
 		 * Something went wrong.  Make sure that we don't
 		 * have valid data in the sense buffer that could
