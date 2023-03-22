Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5949AC6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjCVT5y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjCVT53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:29 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB6967712
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:04 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id kc4so5682072plb.10
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wYcUKal3ePL60VfjZpcDaHb80w6LZ6piZfKEAvYH9Uc=;
        b=jQ5Fyu0a7ASJXe/AGoIb2yzpthPqTXQZiAFmSIGUYvkNrYfYXpYvHZz9/hImKgXbx6
         +W19KoIoa9IR9cF7RENfmCZx/rMht0LSSBcqtSjRwlp22gyuJGnXgmEXqCgYszZbKh+p
         uzLM1cXOlSJT4D0zHljFGVYH0t6fJbOd8MJpj4xeeruR8YAKpBtvGnIafivgWODjtpEe
         FTWzTAJILFAVCJZQbylrTF5PcT61b4ex9aUY8We4NLpf8aWympJSFU0Voc3YKMh9nHdE
         gNuii+1KQwaKvhSAitXPrNA/gL9WcJlmWbS7w6/3xTdmZ4+HrqF+b/B3Gc1I1T7kMrLQ
         tENA==
X-Gm-Message-State: AAQBX9eaYdp5UV+CqrbrFQ5ObVhbCKPy9P5UfRtC0limh3WhcxNf39QT
        wPLd1y7uk4qPb8pd6YVqcgL5JD9aWSQ=
X-Google-Smtp-Source: AKy350Yq+J7zi3Cz+8Nw4ySBSX9gcTftzYmJfFDKa/kaetoH1dR4o5q5xdFyd/5B5EIKfNpsrcUYKw==
X-Received: by 2002:a17:90b:164c:b0:237:50b6:9843 with SMTP id il12-20020a17090b164c00b0023750b69843mr3258202pjb.0.1679515023416;
        Wed, 22 Mar 2023 12:57:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 22/80] scsi: acornscsi: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:17 -0700
Message-Id: <20230322195515.1267197-23-bvanassche@acm.org>
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
 drivers/scsi/arm/acornscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 7602639da9b3..0b046e4b395c 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2780,7 +2780,7 @@ static int acornscsi_show_info(struct seq_file *m, struct Scsi_Host *instance)
     return 0;
 }
 
-static struct scsi_host_template acornscsi_template = {
+static const struct scsi_host_template acornscsi_template = {
 	.module			= THIS_MODULE,
 	.show_info		= acornscsi_show_info,
 	.name			= "AcornSCSI",
