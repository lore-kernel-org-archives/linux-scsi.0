Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F067C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjCVUAU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjCVT7d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:59:33 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C616146168
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:11 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id j13so19507236pjd.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/P/1tcizCKEHhKBtw/asQtJSTCjYYdz51F+CjW/a1Bc=;
        b=xPdQHuqmUfixAZCa6/ZqxwvtyQiQV/PSC9LIE/TpFVDvu1vZPAxMB/WTK/rB9nSiex
         oh43wHM9B7/Vc/NcmQMUwg7Xz85wiy3ooWuhGrEMtzBmjCar/DwoNOPrB64S2cGGWkWI
         X/SXEOWPei0/pBsRM+jBjTcevnfS7JHwS6Rya2IzfQhRLEZs36AoqEEf0FRwYk/QZo0/
         GfeswUtr0oHfeqrARD2zpUTwSiuTf6rWX2K1+4AkT+59psqupb1T9ueeO/4byXm1TNmX
         1hYnS7WdrXyqEsR1jsAmZI1ZHNvOBMP3dFQ7Elk1L7HySSxpZ7TcPpT8/x7ecdybKGyN
         C4HQ==
X-Gm-Message-State: AO0yUKXeyiNsiNJ0p4SsB2OTA5vYC+wehQfgirbHYSY2OLfVYDp3sldi
        nJIwH6dvX/R0eiUfbb5Vc9E=
X-Google-Smtp-Source: AK7set8Gj677XA7dh15nj6zAGG0KlN/JEPt95jgBCqvy0x/7dtJ/4u6XfVdvKJNj08XnMcgwetBncw==
X-Received: by 2002:a17:90b:1e0a:b0:234:159:4003 with SMTP id pg10-20020a17090b1e0a00b0023401594003mr4404456pjb.25.1679515088891;
        Wed, 22 Mar 2023 12:58:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 54/80] scsi: mpt3sas: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:49 -0700
Message-Id: <20230322195515.1267197-55-bvanassche@acm.org>
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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e2f09833659f..492d1940d596 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11925,7 +11925,7 @@ static void scsih_map_queues(struct Scsi_Host *shost)
 }
 
 /* shost template for SAS 2.0 HBA devices */
-static struct scsi_host_template mpt2sas_driver_template = {
+static const struct scsi_host_template mpt2sas_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "Fusion MPT SAS Host",
 	.proc_name			= MPT2SAS_DRIVER_NAME,
@@ -11963,7 +11963,7 @@ static struct raid_function_template mpt2sas_raid_functions = {
 };
 
 /* shost template for SAS 3.0 HBA devices */
-static struct scsi_host_template mpt3sas_driver_template = {
+static const struct scsi_host_template mpt3sas_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "Fusion MPT SAS Host",
 	.proc_name			= MPT3SAS_DRIVER_NAME,
