Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19336C64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCDAcv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjCDAcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:42 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848836A1EB
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:40 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id l1so4371376pjt.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIPb3HYAXuW5r7Endmq1PVAaSjgIGGcvZm+x2bOLt/M=;
        b=mBqv8/xtFpbuVlv1mJ3K9dpX3cGcSAPziHt9mf4mJ6uUsHnjNV/DceI2k/re00chq+
         WTODAYj3aQEx4rPGA2ilqkGSJMygnYpfEnXggHX8LQwPxOP3A4GX6Eemx0LFY0RDqA8D
         hort1Jah4GZ88BBi7AgrrWAwOA2b8aQVy8d+fYFbngUDq4YBKXem/D/mlJFPyjeAMO4g
         U5Z52babwM383SreAgt42SbHZWE4B7YScQlllpxHX+p/cqZYUlmVI7TgUGgm1hTssFyP
         s71k837SeyGMsZ5AstF0noBt6LE3HK0JyampbUaMOvk0E+xovAHgIm94JLl1IzzuhZHk
         zDKQ==
X-Gm-Message-State: AO0yUKXMIV//VnS1DagGOAANtKcJshCPZ8tD1J6rtNaQ1LRdYzyuzIig
        5pTg01Yr/3u5IAlRPp2lnRU=
X-Google-Smtp-Source: AK7set8ZjvI5WGCBgIsahe8DkZSKA8NZp4hJ0Zdd0cPW3LLksKk9jZ57CSucqap6bEFFMXf+gd5ltw==
X-Received: by 2002:a17:903:41cd:b0:19c:94ad:cbe8 with SMTP id u13-20020a17090341cd00b0019c94adcbe8mr4093118ple.36.1677889959988;
        Fri, 03 Mar 2023 16:32:39 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:39 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 27/81] scsi: oak: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:09 -0800
Message-Id: <20230304003103.2572793-28-bvanassche@acm.org>
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
