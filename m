Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD683C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7DF3610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbhDOWJZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:25 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:33494 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbhDOWJU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:20 -0400
Received: by mail-pf1-f178.google.com with SMTP id a85so16559899pfa.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HrsA+ZTOIXIqQ4alvqQ4RqCZAMiCw/ZE0lPl71+WLCc=;
        b=mXIOM8bzXv1XyUg9Ug3JYF0w8BncJiYUm4Bit+ykg0eQcEzRo1znGpo+bFGIcQeTGy
         y9PxTRvvoa9ee3Gkexb8+79rzNLR9tIbzfyAnp4nTJW4OmMRRoVRg4B+rBCJ40LUZuwP
         J9oLJ5AlZrj+t6ZhegXP/ejJnp4M/kx/n/OkXNtztsfvXydgC+4AtXm9qzAmW1ZttGDv
         HPnpRV++UP91hnNwDtS+leZRafFjUo75m8iq8/tqj+yJ866UUUxQujaGmMKFW4mF4LtG
         0kgFcxhLOueHfsGVzE1dVe/W8o8K7kBakw7f7sEaE+Vln5WA5+geU21TRxjGyL07bDUv
         wd6g==
X-Gm-Message-State: AOAM531acV6t2BLMlEIYLrX5CHbKK0UnlLxKZjCQ/HTPakB8hNiOi91w
        0mIVVgQ1Q/UiJSJbvqp/81o=
X-Google-Smtp-Source: ABdhPJykeVp8b4NzZ6+AeLYiDvUVOemQ9Qt1bdUGYyie8TgTfRFF/4FYhNw9KfiGmU2YojLU4C12Qg==
X-Received: by 2002:a63:6c83:: with SMTP id h125mr5277459pgc.50.1618524536619;
        Thu, 15 Apr 2021 15:08:56 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 18/20] target: Fix two format specifiers
Date:   Thu, 15 Apr 2021 15:08:24 -0700
Message-Id: <20210415220826.29438-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use format specifier '%u' to format the u32 data type instead of '%hu'.

Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_pr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index d61dc166bc5f..6fd5fec95539 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1637,8 +1637,7 @@ core_scsi3_decode_spec_i_port(
 			}
 
 			dest_tpg = tmp_tpg;
-			pr_debug("SPC-3 PR SPEC_I_PT: Located %s Node:"
-				" %s Port RTPI: %hu\n",
+			pr_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s Port RTPI: %u\n",
 				dest_tpg->se_tpg_tfo->fabric_name,
 				dest_node_acl->initiatorname, dest_rtpi);
 
@@ -1675,8 +1674,7 @@ core_scsi3_decode_spec_i_port(
 		dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl,
 					dest_rtpi);
 		if (!dest_se_deve) {
-			pr_err("Unable to locate %s dest_se_deve"
-				" from destination RTPI: %hu\n",
+			pr_err("Unable to locate %s dest_se_deve from destination RTPI: %u\n",
 				dest_tpg->se_tpg_tfo->fabric_name,
 				dest_rtpi);
 
