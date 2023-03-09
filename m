Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0F0C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjCIT2M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjCIT2D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:03 -0500
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A164200
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:57 -0800 (PST)
Received: by mail-pf1-f177.google.com with SMTP id x7so2191910pff.7
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wYcUKal3ePL60VfjZpcDaHb80w6LZ6piZfKEAvYH9Uc=;
        b=n5elWFgO6TMJFxYY5asZtBdJgLriwkxv90jOV+CRfqgg47o7TRYUuPhK0nmQMHNuQc
         3M2fafRxtoOA7QNwXnETFiRcT2rX3taDqJpqNzUr2JBQp0Set9wiDvcrDi2jypqChbQ3
         eFPKwTilt1d6ZpAVxQFrUhauz4ev22T87frJ9JjKG0OBpU0wNnyXJk9vVjZPKmLQLL9P
         jKXOWBuX0eeDy6l/reCB+tt4FLiZ75aa4JMTA3h7Qv+BSbWhmozNx5n2NTFtxqheE+OB
         qMvYzNAhJzWTzCBKXqSyosgz5Gy5aDUA2KXZ+6xfxI4eWMmZn8O4hiecGa6y1HodnESZ
         U92Q==
X-Gm-Message-State: AO0yUKVepguKZErLD7Isne6TWp83RRPUJDO6q0M3smyKT+/ja4Ap2DZA
        27ahmTLbSOJ24Z35fmS7b1Y=
X-Google-Smtp-Source: AK7set8anRgufQbZOqeDUdajZ6FMFnfjkR/+Vsh1MB82Ne2VXUDANqaD1YjIsLSL813Lz+n62Ht08Q==
X-Received: by 2002:a62:1d13:0:b0:590:7330:353c with SMTP id d19-20020a621d13000000b005907330353cmr22365746pfd.6.1678390077182;
        Thu, 09 Mar 2023 11:27:57 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 22/82] scsi: acornscsi: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:14 -0800
Message-Id: <20230309192614.2240602-23-bvanassche@acm.org>
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
