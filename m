Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2165EC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjCITaX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCIT3T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:29:19 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95B2CF0CD
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:18 -0800 (PST)
Received: by mail-pg1-f174.google.com with SMTP id 132so1696343pgh.13
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5og9in4ZDwqfZwJ0CvUxtEC6V3f2+08GwjGlKQ+E7A=;
        b=WDkFNsNJjGBhTAwQ7adILfF1N08tD3N93+jGvlVcn2XvyaZTblIVp+/OFryQC/NIrL
         ehAeAcjaAMufjrOLbofWdMAbij/oyPTbPbXdbIn5VTj0Jg+WglJXBqXGU1xtve/4Y7xH
         /3lkCA66Ii9Vnt+/SOMX289B7BO+VRWpShiAeHqj61F5qIgBSvRzeiaLurGPBrSjC8Ik
         BW7gqJKaY+9QE/Ostmjt1G+Y0UW0HveFWqvZSkDzxebI7PITzqReKLYZhGdvnd21hQca
         LGoLDcc3Hs+N9wtYVHZA1l0FEvR04ILMCDIkV+ZR2Zf0+S5P0wQe6GbhOo360ZILLMZu
         6i1g==
X-Gm-Message-State: AO0yUKU4sP7K8n/iOiiWhjba62173HCBeJA5jDWjXQRHaXW+rOXF9HJe
        H7MDkQUpxidtPQGsWPQrRnY=
X-Google-Smtp-Source: AK7set8pnCkK1kL2dQUM+kSgX+w31Djnp3ZlLpeLuJGxx/w4ADY74Ed6FaV7O908c+8eciRyQtBSuQ==
X-Received: by 2002:a62:1c41:0:b0:5ad:8c9:2c9a with SMTP id c62-20020a621c41000000b005ad08c92c9amr23651348pfc.11.1678390158350;
        Thu, 09 Mar 2023 11:29:18 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:17 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 55/82] scsi: mpt3sas: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:47 -0800
Message-Id: <20230309192614.2240602-56-bvanassche@acm.org>
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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8e24ebcebfe5..7e4a97c61873 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11926,7 +11926,7 @@ static void scsih_map_queues(struct Scsi_Host *shost)
 }
 
 /* shost template for SAS 2.0 HBA devices */
-static struct scsi_host_template mpt2sas_driver_template = {
+static const struct scsi_host_template mpt2sas_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "Fusion MPT SAS Host",
 	.proc_name			= MPT2SAS_DRIVER_NAME,
@@ -11964,7 +11964,7 @@ static struct raid_function_template mpt2sas_raid_functions = {
 };
 
 /* shost template for SAS 3.0 HBA devices */
-static struct scsi_host_template mpt3sas_driver_template = {
+static const struct scsi_host_template mpt3sas_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "Fusion MPT SAS Host",
 	.proc_name			= MPT3SAS_DRIVER_NAME,
