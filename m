Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DFC8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiBPVEx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbiBPVEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:34 -0500
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32082B1A93
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:15 -0800 (PST)
Received: by mail-pg1-f179.google.com with SMTP id l73so3157823pge.11
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wWx0oD4y/h5fR0o1HnTS+lemIDFT4V4tl6fYkeJP2UA=;
        b=GcOlPcC7A6oRHhTnvKrLHE2QIvpp9YCRkTnKAbKE+8xLtOYywUeBZkwmSXPr+mHVse
         gJOG1mCionM+O624310O21oV2n8VnMY8OtugH9vcy10wDjD9Ktz0VK4+qtBgqHVFdiE2
         oFwbzs6N2brYw6SiYZbfHf3jKB1s3+l7t+xulN0idnk6anHw70jUJUESiSId7TfGVHlf
         ddAfciBa4dL5ztYMwEFAbNjWEtLDXJeK3Bkf7ISaxbd19qCu7n4OXkvBvwbP1xRyuNzG
         IG8gkQVEaOsE+m5tuRr67Fs/QtI88q0DH6Vu+ZCWLetiiworOAyZloYPQ1XduY7ZZvhR
         SpMw==
X-Gm-Message-State: AOAM532/gwNWr3MlJC9sXZyaqgMmO4tnyjoi/RH+ObWXmW/UKaNSXnCl
        X1RJHZkAFrsY0aSguBVH/IQ=
X-Google-Smtp-Source: ABdhPJysJ6MCJyHmg1Y5UlaGSMQhfihNRNxzjqjcf2azSkt2m5XHBvHWNSQ4/G7xj2ZA+Ctf2axmJg==
X-Received: by 2002:a62:be0f:0:b0:4e1:9222:1ef3 with SMTP id l15-20020a62be0f000000b004e192221ef3mr5097060pff.18.1645045455110;
        Wed, 16 Feb 2022 13:04:15 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:04:14 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 45/50] scsi: sym53c8xx_2: Move the SCSI pointer to private command data
Date:   Wed, 16 Feb 2022 13:02:28 -0800
Message-Id: <20220216210233.28774-46-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index b04bfde65e3f..2e2852bd5860 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -118,7 +118,7 @@ struct sym_ucmd {		/* Override the SCSI pointer structure */
 	struct completion *eh_done;		/* SCSI error handling */
 };
 
-#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
+#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)scsi_cmd_priv(cmd))
 #define SYM_SOFTC_PTR(cmd) sym_get_hcb(cmd->device->host)
 
 /*
@@ -127,7 +127,6 @@ struct sym_ucmd {		/* Override the SCSI pointer structure */
 void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *cmd)
 {
 	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
-	BUILD_BUG_ON(sizeof(struct scsi_pointer) < sizeof(struct sym_ucmd));
 
 	if (ucmd->eh_done)
 		complete(ucmd->eh_done);
@@ -1630,6 +1629,7 @@ static struct scsi_host_template sym2_template = {
 	.module			= THIS_MODULE,
 	.name			= "sym53c8xx",
 	.info			= sym53c8xx_info, 
+	.cmd_size		= sizeof(struct sym_ucmd),
 	.queuecommand		= sym53c8xx_queue_command,
 	.slave_alloc		= sym53c8xx_slave_alloc,
 	.slave_configure	= sym53c8xx_slave_configure,
