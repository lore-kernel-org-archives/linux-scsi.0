Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF87C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 18:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AC9161056
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 18:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhJMSan (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 14:30:43 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:54476
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229814AbhJMSam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 14:30:42 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 8FED83FFE6;
        Wed, 13 Oct 2021 18:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634149714;
        bh=ivCvvMe+6aYbDfW2ELvNV9hLUKXBYBw1RTt59vjh5iM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=t2UAjnwZuUMpCU0LaRul4ccPJlZouBUS6Of1LI2hMsUQh6ql0eGVKVyeYJaNWYbhc
         NdpEx7W5B3JUf3unGE2pd+1o5xJT9zqvWmdut3YWLtpkzx5yuc54tI2F95ZLQ10jLp
         HvC53ErK+JiW//8718iqFg6xJNy/oR9SrGWGyj3ZudeJF3Ro9sn1YCbu+e4HlRRelo
         yBBmZZ4sF5VJ1VGROi0kVBlDDP1JGk5twjkvU30mgLB4Xji36+mghy+6lNPMSoTgqY
         63jOEjoConUMhFQQaXFdB3H/0+tJ95G9r1rxMy2rGyrjP2t3rpSiZ691D5wV8c15Rc
         YQW937QdRFF2Q==
From:   Colin King <colin.king@canonical.com>
To:     Adam Radford <aradford@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: 3w-xxx: Remove redundant initialization of variable retval
Date:   Wed, 13 Oct 2021 19:28:34 +0100
Message-Id: <20211013182834.137410-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable retvasl is being initialized with a value that is never
read, it is being updated immediately afterwards. The assignment is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/3w-xxxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 4ee485ab2714..e2f8a7a95d9b 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2252,7 +2252,7 @@ static int tw_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 {
 	struct Scsi_Host *host = NULL;
 	TW_Device_Extension *tw_dev;
-	int retval = -ENODEV;
+	int retval;
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
-- 
2.32.0

