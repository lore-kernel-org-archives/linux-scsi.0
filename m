Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AAD3C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76DC161442
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhENVfm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:42 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:42796 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbhENVfj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:39 -0400
Received: by mail-pj1-f42.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so474078pjv.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GvsrBHqxeTpj5yobzDPB/XspzX453ScHpA5H8S53VJU=;
        b=HFM1DZC0s5shmjpCz1+YVbsnCoU7afi6m85/qM0hnuPdEACufeFuZJPUPCi/vAoEgO
         EKmmUWjJ7YuVzn9uT1hIn+/Kl+qCBG0D1RZpg/Rqx9LfOcGP1gbDEwBlcEWmYFCfnpd6
         9lyXZO7twm1H+l2pvBJBlidQKSFfe9wou+oLyZFzy/mO9GNEBigVtaxxDH6BXPIVIIDr
         f6hkfgM+A1NL4OvTUTrNkBJMprqwTwlO/3EFhpowQbyTnumD/1wNegxCSt2jfTCZyATx
         9rSM9t7oHg7L+jepq2ROeaHPWRWlAhfi6CE/lY/WuzZ5y/C9CwOK6ZZ0CY9gxO977mox
         Qc5Q==
X-Gm-Message-State: AOAM531TQf86hqGTaJdTlrDOcVdxKNrgcjGKhOpVjAwT1mnmAADsFKns
        mmAdy7ReotiQk64LXK9NGG4=
X-Google-Smtp-Source: ABdhPJwZn36k16+7GVqgrLm0AiLtNZntnDgKPZmor+Z9vSLJwvwng0WVOMcb793FmFHV+ED9Q8Q0YQ==
X-Received: by 2002:a17:902:264:b029:eb:3d3a:a09c with SMTP id 91-20020a1709020264b02900eb3d3aa09cmr47176973plc.0.1621028066790;
        Fri, 14 May 2021 14:34:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 13/50] aacraid: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:28 -0700
Message-Id: <20210514213356.5264-14-bvanassche@acm.org>
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
