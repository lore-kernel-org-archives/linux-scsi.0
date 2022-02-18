Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854D9C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiBRTxp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238324AbiBRTxb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:31 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9049A291FB8
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:09 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id g1so3151190pfv.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wWx0oD4y/h5fR0o1HnTS+lemIDFT4V4tl6fYkeJP2UA=;
        b=4zgx8In2tUpXWITd22+Ph5Qdr4f68JfiW4EBPsMSbDpw4xPdW2yKho4Ts9M1Eg/bBk
         iIREaxVuzcGfQm2lR2ymTxhmGY/nwi36GVAXzOQN6961LWgKUd0pM3+kdiKB63JK9IRe
         lk4Of5pEVP4BiN1cSNFliOcNIgGIfFhlMvYh82YbawND10C3JOkbH1wLApQpraC+89Jt
         W+G3ymUg2SI2ON/iymWcaJiar0LqsyCHLkwJK0/oKVJVcHD05RFZcopJIhE9FS3uoVlm
         9Nprs65M0RjPUieB3xnH5ED35/Yc6263qIWh+f0i6f97zM/pGJKYkRIcl2BBCsC97z8D
         ARjg==
X-Gm-Message-State: AOAM5306S6QfHdZiBh+n6CwoA4sl0ra9mLTDj5SCeFPgYgXf+OdtzMV1
        ClRLnYSGv9r3FSfvnBb4Nhg=
X-Google-Smtp-Source: ABdhPJy4VX70XtfXApEy6ouS3hY9/al7DHoTCoYhX4Po0CvmbM7Iy1K4uSS+NVQjkE4vPdZ8KUAkYA==
X-Received: by 2002:a05:6a00:124f:b0:4c0:6242:c14e with SMTP id u15-20020a056a00124f00b004c06242c14emr9197198pfi.83.1645213989023;
        Fri, 18 Feb 2022 11:53:09 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:53:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 44/49] scsi: sym53c8xx_2: Move the SCSI pointer to private command data
Date:   Fri, 18 Feb 2022 11:51:12 -0800
Message-Id: <20220218195117.25689-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
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
