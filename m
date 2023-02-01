Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5124FC05027
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Feb 2023 18:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjBASHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 13:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjBASHJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 13:07:09 -0500
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B381E2BD
        for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2023 10:07:04 -0800 (PST)
Received: by mail-pg1-f179.google.com with SMTP id 78so13100605pgb.8
        for <linux-scsi@vger.kernel.org>; Wed, 01 Feb 2023 10:07:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HLgqJs3CWjMWwmy6tt3q30R3AeoZpTnsb7sVFE148AI=;
        b=v0+5JJ/QUWYPb+yehkeI+pKO7+wN7TEZUhlxFEjnWQq5qPDshq3l8Nu9A6UBptGBDj
         ZlyZRI+cvtXwRheFxpifRaypb1QdqViDxtddCiAWDVVOU8o2iSWbvIdJsNIodRcl/5A1
         CPbejLb8f9bOIZnmi66ccZASYMWSklhqHFu0J0Dfd1ViTl3eHS/z/otGICT+Cj1z6kRg
         hce5jNjTtOhore6CjSdBmsJPWCXQn8ug/iUiTxHTipsiVjhKZmDEI14XK2shni65uLtt
         e1LnPEoFUQBrJGw5P22m+7kn7QxoWQw80B5bYmuI1U8gBtqKX3ypzo0/v6JjGY9k21gT
         AvyA==
X-Gm-Message-State: AO0yUKV/754tmmzmK5wrSjA18L7gc8V7TKbSJl+mX9jF4bLMMKnVQs2i
        SDywK2vSuXDz1N2465P/CK4=
X-Google-Smtp-Source: AK7set9t+EimO0hoRlkDFVc1hfMUCT1pKD4xaGIpW7LtOCrM/isRZX8eVt7fOSp1bkKenTm9u/PO5Q==
X-Received: by 2002:a62:1b8a:0:b0:593:b37c:c7ad with SMTP id b132-20020a621b8a000000b00593b37cc7admr2990521pfb.22.1675274824119;
        Wed, 01 Feb 2023 10:07:04 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f3cf:17ca:687:af15])
        by smtp.gmail.com with ESMTPSA id x13-20020aa78f0d000000b005825b8e0540sm7021264pfr.204.2023.02.01.10.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 10:07:03 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH 2/2] scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA
Date:   Wed,  1 Feb 2023 10:06:37 -0800
Message-Id: <20230201180637.2102556-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230201180637.2102556-1-bvanassche@acm.org>
References: <20230201180637.2102556-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Asutosh Das <asutoshd@codeaurora.org>

UFS devices perform better when using SYNCHRONIZE CACHE command
instead of the FUA flag. Hence this patch.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
[ bvanassche: modified a source code comment ]
---
 drivers/ufs/core/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bf3cb12ef02f..461aa51cfccc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5056,6 +5056,9 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	/* WRITE_SAME command is not supported */
 	sdev->no_write_same = 1;
 
+	/* Use SYNCHRONIZE CACHE instead of FUA to improve performance */
+	sdev->sdev_bflags = BLIST_BROKEN_FUA;
+
 	ufshcd_lu_init(hba, sdev);
 
 	ufshcd_setup_links(hba, sdev);
