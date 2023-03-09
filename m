Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3358C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCITbu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjCITbE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:31:04 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1909060D48
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:30:07 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id ky4so3134920plb.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:30:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NjinhKeW7v86XI4sdE5pIezlr7cmvUsX5RCaWRammAQ=;
        b=j7KsFKdqpinkyY+1tsBpQSw6pgCpbvrUrs7AQlLePNFGmPhLis1xq/eg6qGJKCZoAy
         1D47F/PQJQU093i2yzp0EIQ0H/Xo/lu6f906YpLOeOepKgxm0zQ53dioxeopcZLkCpXH
         f1fQPe6pF6+MkKSPx+Kr1DxB8ymr8z8cysRpwseHIiHLItUA6gikX6mMi3ybjYOwLEwZ
         M9BY4CFWJWczNWtOJ2h2PdNixV+kCu11c29g1jTfggFMRxGP+rzTwyiloPowAhu2RM4B
         wsibno1RbL/Se3rJM3ap/RX2jvo33UGQOIcGARnzGX3cVougNAw1z7DrLnt6Va+ZgYZ+
         qFyA==
X-Gm-Message-State: AO0yUKW+rihPUr3QmD95bYjcO/o8DDnbjgdg6376NmkMnWdazrvxnlY+
        U8T8s9MKTZoxwi53In6Hn6U=
X-Google-Smtp-Source: AK7set8a0f8Kn/gyiL6pBTpOUo7eGeUodnQ4NFCbhG1s2/SCRJjUmWo5rmd0NBIRL8K2bmXlqT/6aA==
X-Received: by 2002:a05:6a20:1d60:b0:cc:b8b4:d774 with SMTP id cs32-20020a056a201d6000b000ccb8b4d774mr18123269pzb.7.1678390206564;
        Thu, 09 Mar 2023 11:30:06 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:30:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 74/82] scsi: sym53c8xx: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:06 -0800
Message-Id: <20230309192614.2240602-75-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
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
