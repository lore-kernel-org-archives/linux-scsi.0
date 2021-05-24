Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2D5C47083
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E0E56115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhEXDLw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:52 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:45845 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbhEXDLr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:47 -0400
Received: by mail-pg1-f182.google.com with SMTP id q15so19040509pgg.12
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UMCYnVrhY8njikYx66obtRsVTDVDJ+hpIeqxgmK/N90=;
        b=Rd+gIrAurl9VNbJtYNfv3DVPXqYsBGWdQFxoLk+48QBMwJPBmNZb2KdmZPxjV/mwu2
         YBBnIjdY95OEupFjRh+W/3XZt9CLd+qPJmUpM81Q1SosCADGy2q7YSwbbxeWZSHK7If1
         B/dfMGpjTqn+x07rGJuhy9BITXBET+jIWwx5K31m/Prnlp9Dh9AxR5pBKAn6Lq/DR8iZ
         CvbPy9q6x8pvv8Wz/6OoeIoe8oULLymhQ1jT0aDegpmwTJ6AQZWcwg0pqa5uwshyS/B5
         tGh6NMgSGo/QdS3v+AO4xl9TTzUigVdI+g050VqGUEySJEH+0N2F1doIZ1laIwhGXHUn
         dn5Q==
X-Gm-Message-State: AOAM530t56opadTO6aLytC2DKTDPFZhUmAcPsOWg9ZCvdQRHsM5ri/hw
        Hoz0ar/tgrvhjTT+niVcHpc=
X-Google-Smtp-Source: ABdhPJwPngtihuATpCFQVK4e9DsiOm6CLBRJJCsRrVMYJGjWutBxe08DcU/xRA1IkCVN0dygVFJj0A==
X-Received: by 2002:a62:4e10:0:b029:2cb:cf3b:d195 with SMTP id c16-20020a624e100000b02902cbcf3bd195mr22333736pfb.74.1621825819487;
        Sun, 23 May 2021 20:10:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 45/51] sym53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:50 -0700
Message-Id: <20210524030856.2824-46-bvanassche@acm.org>
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
 drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d9a045f9858c..04cd28c268f2 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -502,8 +502,8 @@ static int sym53c8xx_queue_command_lck(struct scsi_cmnd *cmd,
 	 *  Shorten our settle_time if needed for 
 	 *  this command not to time out.
 	 */
-	if (np->s.settle_time_valid && cmd->request->timeout) {
-		unsigned long tlimit = jiffies + cmd->request->timeout;
+	if (np->s.settle_time_valid && scsi_cmd_to_rq(cmd)->timeout) {
+		unsigned long tlimit = jiffies + scsi_cmd_to_rq(cmd)->timeout;
 		tlimit -= SYM_CONF_TIMER_INTERVAL*2;
 		if (time_after(np->s.settle_time, tlimit)) {
 			np->s.settle_time = tlimit;
