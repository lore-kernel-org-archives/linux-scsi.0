Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C607C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 01:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAE1E21924
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 01:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592442630;
	bh=DTCgtkWUhkeyQkENmpKt7QMNjpcD8gw5ONKHWXYAk/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WxN1xtUqFfArkAZB2ya7lQs+TxUB5RR13rv4MvbraNOry7LvxRHVmNZB9m9D4Ns4T
	 s+i9NexvPS4dggwgzzy9ZvwLKCIKj3E4u9eHqQWgqqhKco4HXQKcdUlDaR1zDxsWqK
	 JSwa/4f7I39Cf/ivW7ETEa/xiEeNKNKYs7KNEnig=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgFRBK3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728511AbgFRBK2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3E121D7B;
        Thu, 18 Jun 2020 01:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442628;
        bh=DTCgtkWUhkeyQkENmpKt7QMNjpcD8gw5ONKHWXYAk/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0/H4FCjgHIlXLAXgxztUHlZqGzHXLMG0v7UXN5QMQ5GgWrpEvyCO/siUzlsl6oed
         C9Oi8gMcvsOCfdtyxeIsh/1ruErEMOMJO0nZ1IYGzykkv7a+8FtWP2zoVYAOtP1V/j
         4RCbn9CmpFlNnWD8xMU4xhfi9jR6hDL8KuS2Z9T0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Simon Arlott <simon@octiron.net>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 106/388] scsi: sr: Fix sr_probe() missing deallocate of device minor
Date:   Wed, 17 Jun 2020 21:03:23 -0400
Message-Id: <20200618010805.600873-106-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
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
index 8d062d4f3ce0..1e13c6a0f0ca 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -797,7 +797,7 @@ static int sr_probe(struct device *dev)
 	cd->cdi.disk = disk;
 
 	if (register_cdrom(&cd->cdi))
-		goto fail_put;
+		goto fail_minor;
 
 	/*
 	 * Initialize block layer runtime PM stuffs before the
@@ -815,6 +815,10 @@ static int sr_probe(struct device *dev)
 
 	return 0;
 
+fail_minor:
+	spin_lock(&sr_index_lock);
+	clear_bit(minor, sr_index_bits);
+	spin_unlock(&sr_index_lock);
 fail_put:
 	put_disk(disk);
 	mutex_destroy(&cd->lock);
-- 
2.25.1

