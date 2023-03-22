Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D459C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjCVUCr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjCVUCL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:02:11 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61476BC26
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:09 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id d13so19542744pjh.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NjinhKeW7v86XI4sdE5pIezlr7cmvUsX5RCaWRammAQ=;
        b=dwA0djAZ4/GyxK4TcYYYUsFlFlfvxU8m1+d8o7rdGJd+oAVbri5wElIOczzJlYCUyT
         ZTEpL4GqT/WSu5YKt+6Xqw5ql0fG558LzmaeTEUoE2OnEFaGj5F1ILkocqjwL8yTZ3KQ
         vK8tcTiR8LNLHerntg7/1IxK9BlZqGXDLcO911neu3bFuxRwZNq8OrA8oxZsQwQaZ9zv
         6ceizmzbhJEMlB4h/i5VWxJlHkVrGN2g5ZvChnVla7WOZoGihAPcWtsYa313PhPbFjWF
         TXotM42923lniT2XP6ysiBwqk00jzbTIHS/SaRKiTisXgB9IWAFOaNvtwUj35k/JVZX6
         ns+Q==
X-Gm-Message-State: AAQBX9eECVyWkOum87icQTtSmW5NIz0csqQMmRgp/jehiAADP3TUD0+R
        vxjDv0I7U5dUZP8oe7esT2k=
X-Google-Smtp-Source: AKy350akWXzJJ9hZ6QH6QPq9Sw8puYmA6B435HZZBnYTSZTHAMktLXQolet7eQ2W2fzgzmH9dBY/FA==
X-Received: by 2002:a17:90b:17c5:b0:23f:634a:6c7 with SMTP id me5-20020a17090b17c500b0023f634a06c7mr3033826pjb.15.1679515127890;
        Wed, 22 Mar 2023 12:58:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 73/80] scsi: sym53c8xx: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:08 -0700
Message-Id: <20230322195515.1267197-74-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
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
