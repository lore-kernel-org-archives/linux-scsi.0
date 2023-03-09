Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC96C742A7
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjCIT1l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjCIT1c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:32 -0500
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF8DF05D6
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:28 -0800 (PST)
Received: by mail-pf1-f176.google.com with SMTP id ce7so2182415pfb.9
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xOqT7dLP4YcCtL1jZVtGdq9lau6Z+QsWChHpf/+Jq3I=;
        b=cN+vNmIX3weG+GazLlnQ8RH8ywwRPRk+/02/xdYrDupPyNBBOyX/hFkCEQj8ok65mj
         vcoozwEC8qz91jSq744E5cHtyMSzHHYgOQDeqhAlVVPu/mATe00+5MIvZfCJcrPmGFOS
         mCaydMoxKKCm0gT2Z/aX/sQTlASBRAFRxPXbcBvAjGa1fOwHRGH/4z1yOca9NZ6qffpR
         n+9rAMGOreSWRSt7640h9xNU9Gmr2Jg8Wuw/bXDquTr011qPpRiwsprRINTjxCmW5ItH
         Pcg9/k3yHbAjKb6KEvGHMWgVsCE7xagJRlzSGrPMSntauvGdMvsbWMIGNXR9dmyY0BhT
         Bjmg==
X-Gm-Message-State: AO0yUKVrGrcetaZWJ37jp7CiXSa0yI7xJPZfRVj92ZyXmWNGU/gb2nre
        R5BX/ojPSkp9acB9xy/f9nrwKgQSI7rW8g==
X-Google-Smtp-Source: AK7set/CAK7D0cDxsb32XNQlNubig5a004u0QukLn487pOUItJCTsvh9WKcqNhS1Ps346vNiJUoL6w==
X-Received: by 2002:aa7:9d84:0:b0:5a8:b958:e348 with SMTP id f4-20020aa79d84000000b005a8b958e348mr17145241pfq.28.1678390048301;
        Thu, 09 Mar 2023 11:27:28 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:27 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 14/82] scsi: a2091: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:06 -0800
Message-Id: <20230309192614.2240602-15-bvanassche@acm.org>
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
 drivers/scsi/a2091.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 74312400468b..204448bfd04b 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -180,7 +180,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static struct scsi_host_template a2091_scsi_template = {
+static const struct scsi_host_template a2091_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Commodore A2091/A590 SCSI",
 	.show_info		= wd33c93_show_info,
