Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF5EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B374C214DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592446957;
	bh=0Ay2VrYDZCNa/G+QpJVcum2WYAuiEWtwlcEtxLmeHNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GQeMknOtHMD7EEz0RdEx/PYsXadX/1an7bqk81+bukAKSEBfZn2j7OQovbob7KPDC
	 kjE5OiM5sMWMFFhpd440I0it7240PpAuokC/9AzlUVzTmOkGAzLGNqg/D+KLxmauza
	 fsxeyOcGtz9ADtZ5adYOiYxHrC1S60rOTODCCJek=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgFRCWg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbgFRBSX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 21:18:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1074B21D7E;
        Thu, 18 Jun 2020 01:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443102;
        bh=0Ay2VrYDZCNa/G+QpJVcum2WYAuiEWtwlcEtxLmeHNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+rQgKCoDnr78RVUIsl+KDx4grrsK2cg0xVVXrvZw65vWOmHuFxVtcDGh8IVSt+Oe
         aeAH3yN2cAS2RWsaZZTDkY4IJhwLvXbjtjZ27Q6Ouun0ws9XVmKK/VQgk8mWE8jC/Q
         E26T+Poo9Ef/mUWVcpD5gpuAIFcJwFU00MWDB+rg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Simon Arlott <simon@octiron.net>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 081/266] scsi: sr: Fix sr_probe() missing deallocate of device minor
Date:   Wed, 17 Jun 2020 21:13:26 -0400
Message-Id: <20200618011631.604574-81-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Simon Arlott <simon@octiron.net>

[ Upstream commit 6555781b3fdec5e94e6914511496144241df7dee ]

If the cdrom fails to be registered then the device minor should be
deallocated.

Link: https://lore.kernel.org/r/072dac4b-8402-4de8-36bd-47e7588969cd@0882a8b5-c6c3-11e9-b005-00805fc181fe
Signed-off-by: Simon Arlott <simon@octiron.net>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 4664fdf75c0f..70a28f6fb1d0 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -750,7 +750,7 @@ static int sr_probe(struct device *dev)
 	cd->cdi.disk = disk;
 
 	if (register_cdrom(&cd->cdi))
-		goto fail_put;
+		goto fail_minor;
 
 	/*
 	 * Initialize block layer runtime PM stuffs before the
@@ -768,6 +768,10 @@ static int sr_probe(struct device *dev)
 
 	return 0;
 
+fail_minor:
+	spin_lock(&sr_index_lock);
+	clear_bit(minor, sr_index_bits);
+	spin_unlock(&sr_index_lock);
 fail_put:
 	put_disk(disk);
 fail_free:
-- 
2.25.1

