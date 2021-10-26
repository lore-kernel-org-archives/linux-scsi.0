Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90E1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 17:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 880BC6108D
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 17:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbhJZR50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 13:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232088AbhJZR50 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 13:57:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F349F610A0;
        Tue, 26 Oct 2021 17:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635270902;
        bh=mkwH7BIaCPFudpbvMssOFuBiibIOdNapKcN234az6u0=;
        h=From:To:Cc:Subject:Date:From;
        b=CH6Hi9OXLGfSanhuLJgk4HghK/0b+CmhD/a/7fXs/q/svQkpLHH2HZwGIBeJDqP/H
         1eho//SHGWfK+k+O4hlqgfeJzFbxvqgP+mtaEs5Gm/ZnYYit1koklUIMG4Cd3885j5
         QWKXTaE/eR7MNnAutGkzhkUr5MeC4ync0fpUVz0K3uOAvU0lEkezKgru9NmaNyeeXO
         jW5ikvtE1+b8JXlHskDwM6L8WcRF5KKAE6k6sxpQ5HVPQ64h+/6PcjigfW1d1/WxJa
         FT8oPgWWVnwWZSL71tMq9Ib0u7ieFzpuADeYbQ+MzSeJ3nk+VRofwouNVYIMZ9nXqg
         wUSI3QNMaYdmw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, sathya.prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] mpt fusion: use dev_addr_set()
Date:   Tue, 26 Oct 2021 10:55:00 -0700
Message-Id: <20211026175500.3197955-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it go through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/message/fusion/mptlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 3261cac762de..acdc257a900e 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -1350,7 +1350,7 @@ mpt_register_lan_device (MPT_ADAPTER *mpt_dev, int pnum)
 	HWaddr[5] = a[0];
 
 	dev->addr_len = FC_ALEN;
-	memcpy(dev->dev_addr, HWaddr, FC_ALEN);
+	dev_addr_set(dev, HWaddr);
 	memset(dev->broadcast, 0xff, FC_ALEN);
 
 	/* The Tx queue is 127 deep on the 909.
-- 
2.31.1

