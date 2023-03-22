Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E892C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjCVT57 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjCVT5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:31 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE21269CE8
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:10 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so20254927pjz.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIPb3HYAXuW5r7Endmq1PVAaSjgIGGcvZm+x2bOLt/M=;
        b=IAG0gBYE1dACvnIBJ6vOwGWxM0j1jz32CytFTDsUv3zjg7D1XgvIaMat29uzzPsRKQ
         qHr0VG4Sx/Rl1wHx/C7p2mtMewtthjXcZSrUujkguhXCckfe1rLmQUPl/jVwXSijkDzm
         UnKXnb/MJ9SLRtyuyZQmo/FTnJXaRMKLbszU9n0VFFlKj79H/KXXiTJMl1H417I8wcPq
         DpCkpmpNeCQ1G33XgVaJZSRPF5wcx3ew+lDBJEUhWvvmf+mvUbT+kVLR38eOJy9/k4SB
         ZMzANWc9wzVARmkDmZ2FOHFm1uyDkd1fIchGJz45NHYKTgaKk+e2cw54i9xaExxzQZql
         BRNA==
X-Gm-Message-State: AAQBX9eW7cUhY+CPm2lhx1FxkjxoQXmaLnhN15nQLhJnYY2hcA1O85vX
        kTCYqTAYrxCj1+BccSVv6ns=
X-Google-Smtp-Source: AKy350ZxRJXYqdjZ1McqZ/noir3TjnMUwYcTfyF+dLEow+XlsIVeO++MQVn448gDj6kHtjz83ds8Ug==
X-Received: by 2002:a17:90a:8b92:b0:240:883:8ff8 with SMTP id z18-20020a17090a8b9200b0024008838ff8mr3244144pjn.3.1679515030153;
        Wed, 22 Mar 2023 12:57:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 27/80] scsi: oak: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:22 -0700
Message-Id: <20230322195515.1267197-28-bvanassche@acm.org>
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
 drivers/scsi/arm/oak.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index f18a0620c808..d69245007096 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -100,7 +100,7 @@ printk("reading %p len %d\n", addr, len);
 
 #include "../NCR5380.c"
 
-static struct scsi_host_template oakscsi_template = {
+static const struct scsi_host_template oakscsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Oak 16-bit SCSI",
 	.info			= oakscsi_info,
