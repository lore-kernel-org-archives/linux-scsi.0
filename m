Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765FDC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A05861074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351325AbhERRrM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:12 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:45007 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351319AbhERRrG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:06 -0400
Received: by mail-pj1-f49.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso1333960pjq.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qjkKBA4uNCWH2mTP+yZ3vIfvVwLp3WuZYDfjgLtrzT4=;
        b=uYkJwwvyVk5GuVDfTAWuGue8Jgx0lqI1oxYtWTSd4UYSAsT0RQeT4tlWRMxMOPpS0P
         hIG29XS++1BPnRGCEHUj2k0qt2A14J//QKpgPAiHVt7QLaa0b4AIxDZ6uuJGNQ+9plTn
         mN/Q/8chFTHUvNq+5vrM01D0Bu1TbBD2mIk8osbUKHbxKid15ZQutprpZmEotsvZcDM5
         lHiYSMl7bJ4mmRmbBQQ13lEw4QRZ2QKAiODIeSdUBbErY61+qVRhj3iWceKIJlN16iQt
         Y4QB75qa1sAQuLZ3ATUP719ZyY1P3VFsWN5ix61U0UqYCkEtuSNfgmQdbjvd9jqNnBGk
         r1Dg==
X-Gm-Message-State: AOAM532jWe4gh/Z7xkQGJkGdvRtOM4ixElDDRrZL4Nl3ysPOvOthFeGO
        rJ2PF8FRaUBxRjQPxMfTEH0=
X-Google-Smtp-Source: ABdhPJz14/cQARLna4JV80ZZ1Ae+K3H0sjdkEzkhZXW9+RPl+WSw2hmQAYkQY7HVKLNDYrCZhGX8KQ==
X-Received: by 2002:a17:902:bc88:b029:ee:7ef1:e770 with SMTP id bb8-20020a170902bc88b02900ee7ef1e770mr5884922plb.19.1621359948034;
        Tue, 18 May 2021 10:45:48 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 43/50] sun3_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:43 -0700
Message-Id: <20210518174450.20664-44-bvanassche@acm.org>
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
 drivers/scsi/sun3_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 2e3fbc2fae97..d6000a397f73 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -336,7 +336,7 @@ static int sun3scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 {
 	int wanted_len = cmd->SCp.this_residual;
 
-	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(cmd->request))
+	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)))
 		return 0;
 
 	return wanted_len;
