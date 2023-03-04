Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A20C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCDAfx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjCDAfN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:13 -0500
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A511835A5
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:33 -0800 (PST)
Received: by mail-pl1-f179.google.com with SMTP id i5so4560397pla.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NjinhKeW7v86XI4sdE5pIezlr7cmvUsX5RCaWRammAQ=;
        b=Y7w3JTtZphWb6f6zqlhNAp63MNy2RxmeOwZfNGkMDCLsUwUA7CFvL+CvgOUpbmW+9M
         ZqG1WS6PC7Ey3vJ9eK2qCXRkJEoWbNeFGlcJ9vB5P8QdnA5nuH7tkp64i7oNmHEqWff8
         keb80CyQdP+Y1UOsPu1G40HLC65QW53/6JsMdzxYNBMCDDJdYN+C/vYPFj8fKVN132mp
         cgUkiO7RDeDvAt7Btxw+Zp7nTJrS9YQy3CR0vCEAii4pwFYNYfZJuXZBuIH3LTdrAq3E
         IWkTUYnUtViZ5FJGviVMf+5T49k0F8KcuTOjBIyNw7X4nuKpiqW3cbDIRyG014XUUVq5
         whBw==
X-Gm-Message-State: AO0yUKXc/3zWLOgsOroyrJGMkhWUNs6p+ASmX6y5SAmKAJH7ZH3nphVq
        LNzkoV1wuAZqXrsivme1WEs=
X-Google-Smtp-Source: AK7set+/XXGpb4K6YR1l2GCza7zK/xz3TbUj6NnmJkj+4+VMK+6CaP0nmsTINqUUPadv94yfV7LiBg==
X-Received: by 2002:a17:902:ee45:b0:19e:6c7a:481 with SMTP id 5-20020a170902ee4500b0019e6c7a0481mr3046286plo.68.1677890073127;
        Fri, 03 Mar 2023 16:34:33 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:32 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 73/81] scsi: sym53c8xx: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:55 -0800
Message-Id: <20230304003103.2572793-74-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 2e2852bd5860..ee36a9c15d9c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1224,7 +1224,7 @@ static void sym_free_resources(struct sym_hcb *np, struct pci_dev *pdev,
  *  If all is OK, install interrupt handling and
  *  start the timer daemon.
  */
-static struct Scsi_Host *sym_attach(struct scsi_host_template *tpnt, int unit,
+static struct Scsi_Host *sym_attach(const struct scsi_host_template *tpnt, int unit,
 				    struct sym_device *dev)
 {
 	struct sym_data *sym_data;
@@ -1625,7 +1625,7 @@ static int sym_detach(struct Scsi_Host *shost, struct pci_dev *pdev)
 /*
  * Driver host template.
  */
-static struct scsi_host_template sym2_template = {
+static const struct scsi_host_template sym2_template = {
 	.module			= THIS_MODULE,
 	.name			= "sym53c8xx",
 	.info			= sym53c8xx_info, 
