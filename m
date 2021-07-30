Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B80C4320E
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 09:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D6EF61059
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 09:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238500AbhG3JvD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 05:51:03 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:51976
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238447AbhG3Jus (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jul 2021 05:50:48 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 25B883F112;
        Fri, 30 Jul 2021 09:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627638638;
        bh=YK/QXYKtOtVXVIFn4gCLUCZeIPFhKc4MjoA0AhD8gYc=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=MYX9DglRtGitHkflKpZaTCP5xpmESK+l3RIUBKUzWlJEBXkM5czOJi5T590rnN/yq
         hHEEiPCJYGgaD1z/IA5XL1C6MeZXpobW7srjS0w56oD8EXaVMJ+hdXyr2Y66bVWQTW
         YMZSGD9coPJERUcinUpN/m9E3/z5a+HYIfYiRiptKLBXee+ZwYD6VJfxH95ywf7Q9S
         G9O/8kt5RhZdu/H6qOQFMdkBBa4gDq1DzM3FVtNfsQYa8WF20Y8b4JYmGn9Nzuo/Av
         1V12iOvkQY/v5EcXRc23riAk8JURBE1R5vLCVRHg2DM0njnB6DWr1VWsRlMV/BI02T
         4eQQZnBeEgWgg==
From:   Colin King <colin.king@canonical.com>
To:     Khalid Aziz <khalid@gonehiking.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: BusLogic: use %X for u32 sized integer rather than %lX
Date:   Fri, 30 Jul 2021 10:50:31 +0100
Message-Id: <20210730095031.26981-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

An earlier fix changed the print format specifier for adapter->bios_addr
to use %lX however the integer is a u32 so the fix was wrong. Fix this
by using the correct %X format specifier.

Addresses-Coverity: ("Invalid type in argument")
Fixes: 43622697117c ("scsi: BusLogic: use %lX for unsigned long rather than %X")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/BusLogic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index adddcd589941..bd615db5c58c 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -1711,7 +1711,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 	if (adapter->adapter_bus_type != BLOGIC_PCI_BUS) {
 		blogic_info("  DMA Channel: None, ", adapter);
 		if (adapter->bios_addr > 0)
-			blogic_info("BIOS Address: 0x%lX, ", adapter,
+			blogic_info("BIOS Address: 0x%X, ", adapter,
 					adapter->bios_addr);
 		else
 			blogic_info("BIOS Address: None, ", adapter);
-- 
2.31.1

