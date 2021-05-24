Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA562C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE83561166
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhEXDKx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:53 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:41688 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbhEXDKv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:51 -0400
Received: by mail-pl1-f172.google.com with SMTP id z4so11713478plg.8
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6VDMqIL9H4Vn/0bg6+sZt18TM3BKAyfd8LmUZUGrSQk=;
        b=nPyiOojm2LNLNc86hHo5vNOBTzmxGOEaSef5Gw+X3E00ucsg+4Z+4dpTbOO3DsCN9o
         JQtJ7tQntE68xM+Sy2IAbYVSLRk9GrSrjr4lx++ei0Ig27CJIqBla/LNGbvvNGDFU+5c
         9adNH7MUCDS+Gej1R1wskkS3Nd2kzmt6OdCOhDEJpu/SAI+0/cs+qMf49lVOO6JR0DqH
         rBdmklwZMtDtJH0GuQm9XKCSO2FSuyIgkmzZ+/oHyroBIO05xx1hQUwgE6djdqy+C8yq
         +lRoy6KBfYVSL341ga43gjtpri6sxDCa/Jg4Ugo802SpfYGK+TJZdMEjNlm0vMoeOyY7
         BYXQ==
X-Gm-Message-State: AOAM532DaipU+Yx21IPaf0emcCCykoiSHm5ZfqlowZSf6jy2sgwXDgT8
        u8urLdFIoQtZX7VzDRXOMDg=
X-Google-Smtp-Source: ABdhPJx27aG0+eVyicJ/P3KEmJIuZTUmtAQsWDE0tHJ/p3k5wEnPo5MMPH4YhvXl9Qb+cTGMOJLobg==
X-Received: by 2002:a17:90a:284a:: with SMTP id p10mr22764260pjf.198.1621825763828;
        Sun, 23 May 2021 20:09:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 13/51] aacraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:18 -0700
Message-Id: <20210524030856.2824-14-bvanassche@acm.org>
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
