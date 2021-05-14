Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D0FC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69DBF61440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhENVg0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:26 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:33622 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbhENVgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:23 -0400
Received: by mail-pf1-f176.google.com with SMTP id h16so691031pfk.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vaTpjSBap2p/PgYWwrt5B4MG2Tp8iOwRKcBTdAuGYBw=;
        b=ihj3SqSDSqBGvzrEy64mr7HDFvSV3XoK3O9NMCom+DIfJ9agTB2SR5OqaT7DNrd5im
         PoDrnno1bJwQ7uVIMdTKlIRfV9AgXZzanGDMigX+mfLSx5wzC7eg5UYLsADOZ/RlpqsZ
         8N6Iy5NIphQ9NzxRH6HNf1qp+MbFKXc2y4w0MR4j8bFuSa4c+OJe79Hbw8+UcShANWZ4
         nFegfHNntkFd30tM6oO/MfiuwZjR0Nc2sWBV4H6N70LzPMQIlKUvKl1KFKoL3CR1+sMJ
         ebIBY84EU5nOcGk/0/QZ+LKMPPs+Xp0xAMdHAv67ow1rTt43O8ClHKror4kJMMZ0e3+e
         ZH2w==
X-Gm-Message-State: AOAM53210M2VtphfeGQlV+9O+3X+y51sucJqXM/AR9nID/keUfnq+NDZ
        SnnOJt66z3m2kzxRyl7bNSA=
X-Google-Smtp-Source: ABdhPJzo6SHycTHhEhahwCYp0DtO6m+qG8UC7TYgWBbfrsbBlsq7OYG+zicbNDDqam4DtSsthSs2NA==
X-Received: by 2002:a63:4423:: with SMTP id r35mr49668290pga.13.1621028110714;
        Fri, 14 May 2021 14:35:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 38/50] qlogicpti: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:53 -0700
Message-Id: <20210514213356.5264-39-bvanassche@acm.org>
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
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index d84e218d32cb..d7cd7dda24ce 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -890,7 +890,7 @@ static inline void cmd_frob(struct Command_Entry *cmd, struct scsi_cmnd *Cmnd,
 		cmd->control_flags |= CFLAG_WRITE;
 	else
 		cmd->control_flags |= CFLAG_READ;
-	cmd->time_out = Cmnd->request->timeout/HZ;
+	cmd->time_out = blk_req(Cmnd)->timeout / HZ;
 	memcpy(cmd->cdb, Cmnd->cmnd, Cmnd->cmd_len);
 }
 
