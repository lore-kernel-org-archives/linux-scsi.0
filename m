Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCBDC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjCIT20 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjCIT2I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:08 -0500
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C272A6C0
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:06 -0800 (PST)
Received: by mail-pg1-f177.google.com with SMTP id 16so1695087pge.11
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIPb3HYAXuW5r7Endmq1PVAaSjgIGGcvZm+x2bOLt/M=;
        b=o+q7B5vWET7UTDYotPegqHUr9vRSwmvw+NMb9P/Iv2PtU5nMEENKWzv8k5a5FL0Pz2
         BxDZLNoEvbRPBrOWv5ChpY0q52bo+Urn63AqcvcdqQV8HPB88xvUrnQcLUpEtFCApBzJ
         fYxpy5SAT9dDnm9EjaecNWUx1HDkN87UXaJgxTrqXhdt/NtlH01E6VetdYN3oiioTDX3
         UNFGCLSCNxr2WjFt4WOVdOWFjGGOFUONo+0LLs9uzAPN5NHCyLJGD7/qG6i+JlkSIo24
         fA+QOoQs1i6qgyIJC0+9gSzgzA2YwPrPHvWy8Y5W7qrO/h885N+mShNcYWFu/sTXk8Ji
         7m/Q==
X-Gm-Message-State: AO0yUKU+SUBk+BfiNOSFcPGww+olF+XlHczGh8JJ7ErgV/GYG7dX0CZm
        cO1F5+LUTOlZDNwu5Nn9IIw=
X-Google-Smtp-Source: AK7set+QWozXYtQz9RHcf67ybPqy3fTkeYUu7lA/3gu8+ZRRx9fBpzOlIaL9dFXgLmuGSi2rB+yZkA==
X-Received: by 2002:a62:1748:0:b0:5dc:6dec:e9b9 with SMTP id 69-20020a621748000000b005dc6dece9b9mr21508420pfx.21.1678390085907;
        Thu, 09 Mar 2023 11:28:05 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 27/82] scsi: oak: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:19 -0800
Message-Id: <20230309192614.2240602-28-bvanassche@acm.org>
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
