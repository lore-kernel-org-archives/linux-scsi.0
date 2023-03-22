Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAA4C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjCVUA1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjCVT7i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:59:38 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BC312F04
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:12 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id a16so15160858pjs.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AnK8Yqpa8id/oOS0MLZlCpDLRfS4lc4w7yWCDfvnNtc=;
        b=l9kqm71KcakfY6963mBmUmGBHujTWCA1y0nC5Nde4pbRh2P9EjT8axe3NuN+95Pf3s
         tr9DwE0+kqwgbe/aCAi3Mal49GvDaZlXAbpssnCknl8erxG3WpuHQEVPRCz74A/nF6kF
         eijSUBIHiOskpK7hvkJQyBbTsmzv3qP9+bgiN7Gi5sVaUVB7GBQO70GeU6vJaDqxjzgy
         VxORpj+Bzr2ude/qowejHm4y92MbTizqTQDHD8UmDmPLt8v3FlPqT3pNNSVzoWb62WNg
         aQx1ak/4cc9qR/KjL4wldlCGNT1I4qF/2gsYCJHhKuuLcQPQGW6Fx4AViOis/lnK9z4i
         nyXA==
X-Gm-Message-State: AO0yUKVx/z1bSuNSUrwAw+aruXb0zV/3cNv7/nKE6KODW6lVF6yDBhcv
        WUl8c9JU/keuj6h/SE5/ifk=
X-Google-Smtp-Source: AK7set/M9cuVdBAlbt24Nz+2EYxmIygt9efcFwYgXd5iKVcBSZ308FkK/EbWtvNuUGYVUSLmsR42dQ==
X-Received: by 2002:a17:90b:4b8e:b0:23c:ffd2:6502 with SMTP id lr14-20020a17090b4b8e00b0023cffd26502mr5415387pjb.12.1679515090257;
        Wed, 22 Mar 2023 12:58:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 55/80] scsi: mvme147: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:50 -0700
Message-Id: <20230322195515.1267197-56-bvanassche@acm.org>
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
 drivers/scsi/mvme147.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index 472fa043094f..98b99c0f5bc7 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -69,7 +69,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	m147_pcc->dma_cntrl = 0;
 }
 
-static struct scsi_host_template mvme147_host_template = {
+static const struct scsi_host_template mvme147_host_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "MVME147",
 	.name			= "MVME147 built-in SCSI",
