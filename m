Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8771DC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 688C261159
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhEXDLm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:42 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:43858 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbhEXDLj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:39 -0400
Received: by mail-pj1-f49.google.com with SMTP id ep16-20020a17090ae650b029015d00f578a8so10316897pjb.2
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nOVo62aD3xBlvWPJJ5wlCyfpxi8Hex+qVuCS0WhbLxU=;
        b=q3JolGpEII4JsMxJF1SF47Bu+Z0KM+8v8XWYC1nFwO8SsUmGNJqayk5LTfbX9RgTGS
         TNntQrkarSwnzoEmV7gzgJuNJkaxtp/IyNQy2lrCA8BMjF82wDcuKEnifRWA5gT2LIfi
         L145QZ+Z0TXBLVsK/ItBihwA8aayV/E5QIgAFCpZu8JiCcBZ8I0TGnH83VmLiG+zos6U
         ih0npKJ+0lldBHXGLg2KfdkGY0Ruv4Gx4GsOykLX6LfKZTl4rCSgewXZMp9Ft/b+8enM
         Z1F3mXJUukhk9GYuzDNq3SrqF7ntTqoxxfSZcicLwEl5vSqp64qlXROSx7jbhsOJGslX
         j7BQ==
X-Gm-Message-State: AOAM533bU6dqj2NC4Bgizv4PxyLOnzfhZw1rj7LNnLi47glJvweLc7V1
        8c83o+1Isd1PztY1VkMAKgo=
X-Google-Smtp-Source: ABdhPJzQmnKZinC5LbjBEVgjy3BOIGFPSiNwt8MpxMaXDKTToNVpSRs0yXZZQ7LhWKDSrNsdgXwR1Q==
X-Received: by 2002:a17:90a:fa14:: with SMTP id cm20mr3787180pjb.90.1621825810442;
        Sun, 23 May 2021 20:10:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 39/51] qlogicpti: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:44 -0700
Message-Id: <20210524030856.2824-40-bvanassche@acm.org>
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
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index d84e218d32cb..8e7e833a36cc 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -890,7 +890,7 @@ static inline void cmd_frob(struct Command_Entry *cmd, struct scsi_cmnd *Cmnd,
 		cmd->control_flags |= CFLAG_WRITE;
 	else
 		cmd->control_flags |= CFLAG_READ;
-	cmd->time_out = Cmnd->request->timeout/HZ;
+	cmd->time_out = scsi_cmd_to_rq(Cmnd)->timeout / HZ;
 	memcpy(cmd->cdb, Cmnd->cmnd, Cmnd->cmd_len);
 }
 
