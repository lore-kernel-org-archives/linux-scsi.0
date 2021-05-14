Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDAAC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B82361442
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhENVhR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:17 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:51851 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbhENVhH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:07 -0400
Received: by mail-pj1-f44.google.com with SMTP id k5so536338pjj.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GvsrBHqxeTpj5yobzDPB/XspzX453ScHpA5H8S53VJU=;
        b=Mm/bgpIYSEOEsw/tQbS4rdrw2yI+jgNhGU5KbedXWZl0MH2knBz2ljdgjB7PIgT9Jb
         dKZ6kNP0qJp0f2DaRwRmgtazhHe8Pwwv0v4fNY6m441nN8ODzIUVZ9/1BXtCB550q8/6
         2WYjOFZhq+KE8oV1fA8E3l5y38qjQM8NJy5Y2laQ09i9DomYdauSWunGBrS0HbiKdU6m
         ypth0p9Bb+f+Txh07FvxSz/iWahnjtBx4c7NLgX2EfXOsHdDVcCMXVuo36jBbI08HmjB
         PkFixGcNK6RTwNvYvm7INrgnih5zuETFBfPc2+eohpuv5b8uVboYiSuW86PkFTLkQemw
         cT7A==
X-Gm-Message-State: AOAM533dV/lQQ+Z1xO4hl0AfpttY19p5DAWE9pT3ok/a+VoUBv7CZmIa
        PhTZ7cslditPTkqDfsgnqsmyDKijOAi+0g==
X-Google-Smtp-Source: ABdhPJxti4CLD4tgEVpnvYGFI/CXH2M0HYANomLTVzcM6hvOyc+r45p+sSZ5tDG5BGOZaQ13pS4s1A==
X-Received: by 2002:a17:902:8bcb:b029:ef:96ea:f53 with SMTP id r11-20020a1709028bcbb02900ef96ea0f53mr11412034plo.54.1621028155123;
        Fri, 14 May 2021 14:35:55 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 13/50] aacraid: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:19 -0700
Message-Id: <20210514213356.5264-65-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/aachba.c  | 2 +-
 drivers/scsi/aacraid/commsup.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 46b8dffce2dd..73570f8e89e0 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1505,7 +1505,7 @@ static struct aac_srb * aac_scsi_common(struct fib * fib, struct scsi_cmnd * cmd
 	srbcmd->id       = cpu_to_le32(scmd_id(cmd));
 	srbcmd->lun      = cpu_to_le32(cmd->device->lun);
 	srbcmd->flags    = cpu_to_le32(flag);
-	timeout = cmd->request->timeout/HZ;
+	timeout = blk_req(cmd)->timeout / HZ;
 	if (timeout == 0)
 		timeout = (dev->sa_firmware ? AAC_SA_TIMEOUT : AAC_ARC_TIMEOUT);
 	srbcmd->timeout  = cpu_to_le32(timeout);  // timeout in seconds
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 54eb4d41bc2c..4745c0622e53 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -224,7 +224,7 @@ struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 {
 	struct fib *fibptr;
 
-	fibptr = &dev->fibs[scmd->request->tag];
+	fibptr = &dev->fibs[blk_req(scmd)->tag];
 	/*
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
