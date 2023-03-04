Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A47C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCDAcP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCDAcE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:04 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDC869214
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:04 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id v11so4522463plz.8
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xOqT7dLP4YcCtL1jZVtGdq9lau6Z+QsWChHpf/+Jq3I=;
        b=FK85We2eILnZzqaSNgmQYZIwJrF8cc02NYUdkpHp6p5xkFvg8W167HiKsJimKyG4ns
         pyUc/U9jV2BslqSnrycjF5Z3pxz2J0ZG+ROtpyPzDRl6pF2yYnzK7FGOG6eeik84qLvg
         b1t/8UXYpTlxLcjkHfkxfBkB7hZSqwhp53OjQnvgYgLojmNB5BwY8WyAX94B5x8D9kTW
         kzXI+AEeckqGFvYF8BdUxlvYYzsxY7pQHDto3R7ltY6wF4sdLYSDjc4ewk24tdpucE2u
         UJpDAdXhLrQFp5QlZx+Dn4ijvirBXIQUhrhW/YBTLLKbGS7OgvADtseLOQoPBB41VMmc
         8vzw==
X-Gm-Message-State: AO0yUKXDPGwjcwp5kKEcai1ITcAYYbBLVf5Mi0zlJKA87mV835JPEXPJ
        qloSHtk5gX08Nn8m9NIhhfc=
X-Google-Smtp-Source: AK7set8J+xRmkyg9WCOs3sQMwc9DvHWLkXHF/VdSdtAgSE4NhayAIPi0XFi4FguYoOvnfvV/PljlIQ==
X-Received: by 2002:a17:903:8cb:b0:19e:8e73:e977 with SMTP id lk11-20020a17090308cb00b0019e8e73e977mr3974928plb.67.1677889923679;
        Fri, 03 Mar 2023 16:32:03 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:03 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 14/81] scsi: a2091: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:56 -0800
Message-Id: <20230304003103.2572793-15-bvanassche@acm.org>
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
