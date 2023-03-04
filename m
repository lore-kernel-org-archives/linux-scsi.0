Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597C1C64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCDAck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjCDAce (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:34 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518046A1F2
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:34 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id h8so4510774plf.10
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kH268M7KVsr02fjw5NLBwrnT+cyJ3HjwvjHBuiPtPhM=;
        b=qUUTxr4OLcTbhMlClsiEzkqAZjODCeI6JEprBLfZC7N/yXO/z8dhV4ZBvbBuiUwnDD
         Cfoch1JrjBBKiBsSsNjmk6OGdrBRDj0Z/CdqJap0ouLECeQArzSwdI9R5FXJp3Bs8C63
         mg4kunuRTZOvKCwbZaZxsj5LTCGbZ1NYkFPeYEbrJ7TO8WqKWV7sGfROpJA46rhxCtx0
         G+0jumQzkYoUdXPcNppuTMhpJcxun7GEQc7Xvs1yqkyJopVZ93R/UTV+FXtby6D/SQQ8
         +d8CCsvfBRQ4DfVlCorK+aYTQxoGaPC0+4iOUvx10u91wiaFGM+UeYTiuVVoD5HxJx2w
         jNoA==
X-Gm-Message-State: AO0yUKUViHPy2nEMRP0GRCQrFi+UDMHkRsIrsvxWiRAGm7iLdPq+LPbU
        7GdJQxbavsQI4m7fTKbyles=
X-Google-Smtp-Source: AK7set/ZJLvm8qNWqPzEtvsFK12a4wGPTtiYy0r2kBsX7u1TtImIA/BAdwkxVmzUNmXNN5MOGyCRNw==
X-Received: by 2002:a17:903:41cd:b0:19c:94ad:cbe8 with SMTP id u13-20020a17090341cd00b0019c94adcbe8mr4092835ple.36.1677889953957;
        Fri, 03 Mar 2023 16:32:33 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 24/81] scsi: aha1740: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:06 -0800
Message-Id: <20230304003103.2572793-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha1740.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 134255751819..3d18945abaf7 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -543,7 +543,7 @@ static int aha1740_eh_abort_handler (struct scsi_cmnd *dummy)
 	return SUCCESS;
 }
 
-static struct scsi_host_template aha1740_template = {
+static const struct scsi_host_template aha1740_template = {
 	.module           = THIS_MODULE,
 	.proc_name        = "aha1740",
 	.show_info        = aha1740_show_info,
