Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10404CA9EC6
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2EFF21A4A
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572451130;
	bh=KOUMRaIXAGCb/5lzwRYuWypD1T7l7uduhC7ayCsSL/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HaoC6YXfnp/UDprphnDwKigQfa425yUvQ7KZ7gncWpxYHqpNfQ1lhGzyDrar+CxXg
	 z77D0ktnznjtMpXOb3vTyPZImJCTVJ9VCVRPPmqm/9LdzczxXIaeF0nHOOG2G0SRt2
	 aU5I4L0Uw9Xgnt3fNiP9T2RsYjTYDIYOqFMno1oQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfJ3P6I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 11:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbfJ3P6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Oct 2019 11:58:07 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64FA921835;
        Wed, 30 Oct 2019 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572451086;
        bh=KOUMRaIXAGCb/5lzwRYuWypD1T7l7uduhC7ayCsSL/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09sbo8HaWY8Wxa3P8PSOijmPcp+9aUQcKNG/xWbBgi7UUubInHnWmtkfRbSHeYnC9
         C9jmeKGWXNZFDDYlElQB53tZ0dktBXAFw5OSlBpVHkgEGjvu0vSXyLrBb7/PtQvXey
         7upNopQIuZNIzc/iRfVQVqEU8U5WFeNtdmN9OIEE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/13] scsi: sni_53c710: fix compilation error
Date:   Wed, 30 Oct 2019 11:57:44 -0400
Message-Id: <20191030155751.10960-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155751.10960-1-sashal@kernel.org>
References: <20191030155751.10960-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 0ee6211408a8e939428f662833c7301394125b80 ]

Drop out memory dev_printk() with wrong device pointer argument.

[mkp: typo]

Link: https://lore.kernel.org/r/20191009151118.32350-1-tbogendoerfer@suse.de
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sni_53c710.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 76278072147e2..b0f5220ae23a8 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -78,10 +78,8 @@ static int snirm710_probe(struct platform_device *dev)
 
 	base = res->start;
 	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
-	if (!hostdata) {
-		dev_printk(KERN_ERR, dev, "Failed to allocate host data\n");
+	if (!hostdata)
 		return -ENOMEM;
-	}
 
 	hostdata->dev = &dev->dev;
 	dma_set_mask(&dev->dev, DMA_BIT_MASK(32));
-- 
2.20.1

