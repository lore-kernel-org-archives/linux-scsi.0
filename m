Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2E9C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241332AbiA1WWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:15 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:33493 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351312AbiA1WV6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:58 -0500
Received: by mail-pf1-f169.google.com with SMTP id i186so4979152pfe.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V4U1EP9jsO3JA6BfufPhwM36Q3/2B/GqbJd1cBitlJk=;
        b=SjbVpoYeZcJaCMcgl+6ovSi2Fbp8eCZP/WAxQDOeqlWVUWt5C4YsOZLKobynW1rbu5
         hdURjuc9Js42sSD5zu37gRQhLfK7zIgvMosI1bMPHrzsDY2tOqqCZzEEnyVGt2g3u5TR
         3DtgLqrUbq5c/dx0I0XmHx5QrRL/OGlxTix1Ez/xsNJ4wBVZ/VrcB18/8+zQfQs+gSMe
         445XObe3Ev1dlrLgDuImGViMvHkEmUvCEqXFLquyL8y9DonsM1dnXDi3d+WDvQLytMV4
         s6Yjm3tVisxc1mWFhP2n/CZ3qursAro9cwDTcaFqzqj6f1K7P894jk+DTXbLBnteabcD
         uBxA==
X-Gm-Message-State: AOAM532EK3GN2n3oBOQEzWMf1dF5hsPjijJzuU+bRyaLob32fworNETg
        GosMZJ7LMWlXdzBC01v51mk=
X-Google-Smtp-Source: ABdhPJxdcS3v+EhP92efa8VCByz5FlMS4Fxre6ppiHeb/SqV10+Eqo3uDv+A7eAiDg6ak49CgBJvew==
X-Received: by 2002:a05:6a00:21c9:: with SMTP id t9mr5616243pfj.48.1643408513008;
        Fri, 28 Jan 2022 14:21:53 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:52 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 39/44] sym53c8xx_2: Move the SCSI pointer to private command data
Date:   Fri, 28 Jan 2022 14:19:04 -0800
Message-Id: <20220128221909.8141-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index b04bfde65e3f..da4ad1ae0401 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -118,7 +118,7 @@ struct sym_ucmd {		/* Override the SCSI pointer structure */
 	struct completion *eh_done;		/* SCSI error handling */
 };
 
-#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
+#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)scsi_cmd_priv(cmd))
 #define SYM_SOFTC_PTR(cmd) sym_get_hcb(cmd->device->host)
 
 /*
@@ -1629,7 +1629,8 @@ static int sym_detach(struct Scsi_Host *shost, struct pci_dev *pdev)
 static struct scsi_host_template sym2_template = {
 	.module			= THIS_MODULE,
 	.name			= "sym53c8xx",
-	.info			= sym53c8xx_info, 
+	.info			= sym53c8xx_info,
+	.cmd_size		= sizeof(struct sym_ucmd),
 	.queuecommand		= sym53c8xx_queue_command,
 	.slave_alloc		= sym53c8xx_slave_alloc,
 	.slave_configure	= sym53c8xx_slave_configure,
