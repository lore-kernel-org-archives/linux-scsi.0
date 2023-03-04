Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7E1C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjCDAeK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjCDAdp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:45 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEDF83EC
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:14 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id l1so4372232pjt.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=239hkCXB94hvY9rEBCDXzyIlK2lqlyBB9GRut91MAN8=;
        b=60XQYqcF2iyuVEQJG5b9rmOHMkoEoNYkdSR3w4rPZuPJ9OmhMAU7vaidD1Xz9EeCFA
         ifnG/KP92rGKpgmz+MwrDdDjtr11tx7c4CTBdAZzihRwCkB+6X//0J888kqumtxuYURT
         t6AOLw2xLyfbfb4De5kmVeGhq4NwhN4wFAICQmI4q5RuPApv7afWYVAEBtB+fn3ClD+s
         5FVsvnlYrx+AQZkwEJRmu5AGHqeuY+sUApH5HAk9CDe/xzHXGNnGG1SOYafV0evoTYqm
         gLxpuWlxeHqLAQ8f/Fd1soUf8DXSKcYGtNCvQbCTUByKP9jKVl/bi3AWyKg/iDrxbQ7t
         fGHQ==
X-Gm-Message-State: AO0yUKXJlNiBUwOqk/aFQ60UnddtadvF9NByEaNml/xY3maUcSXiOK/O
        pw4sYWJTdYSey7kjlYDYhu4Cz48A7+odWQ==
X-Google-Smtp-Source: AK7set+D3WafH14WtXlG5kUQWdhq+p2M8+To0KrJHv2HWbZqkzWfYQo8+qbMOqknkx0E9hHwJ8QMpw==
X-Received: by 2002:a17:903:485:b0:19e:898f:8815 with SMTP id jj5-20020a170903048500b0019e898f8815mr3060789plb.9.1677889994172;
        Fri, 03 Mar 2023 16:33:14 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:13 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 43/81] scsi: hptiop: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:25 -0800
Message-Id: <20230304003103.2572793-44-bvanassche@acm.org>
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
 drivers/scsi/hptiop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 7e8903718245..06ccb51bf6a9 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1159,7 +1159,7 @@ static int hptiop_slave_config(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module                     = THIS_MODULE,
 	.name                       = driver_name,
 	.queuecommand               = hptiop_queuecommand,
