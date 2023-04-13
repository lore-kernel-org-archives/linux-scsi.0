Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32635C77B6C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Apr 2023 07:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjDMHtA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Apr 2023 03:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjDMHs4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2023 03:48:56 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9699083FA;
        Thu, 13 Apr 2023 00:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=4Zscu
        iQPwnHKfbAbpvcHFmQ/w/W3FQBM8Le/KlBVmX8=; b=OqoNaQIYuk9GQjrKGTqFb
        y40Lu2Tr6qvWr7iLUmFWo/K0o8h6ReWDgrmcn7w85RPfGUPzQlEKMbis1A5SHFAz
        JzW3w3RaLCxd0PtcBUQC8HGlSwlB+zLJxF/MOsUwJ0ZINmrlghJBDLSXQ/iZmvqv
        X+Ie+SZ3728uGNA5Ohxv2M=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g3-3 (Coremail) with SMTP id _____wA3nmaFszdkGDBrBQ--.49914S2;
        Thu, 13 Apr 2023 15:47:17 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     sathya.prakash@broadcom.com
Cc:     sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH RESEND] scsi: message: mptlan: Fix use after free bug in mptlan_remove due to race condition
Date:   Thu, 13 Apr 2023 15:47:15 +0800
Message-Id: <20230413074715.237471-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wA3nmaFszdkGDBrBQ--.49914S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrurykGF4Dur1fWry5Wr13CFg_yoW8Jry7pr
        ZFka48CrZ5Jw1Iy3WDtFy8AFyrC3WIgrWkKrWSg342vr1FkFyYq340kFy2kw1xXFs5Ga13
        Zr4DJFs7GayDKFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziYFAtUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiQgdQU1aEE+PxogAAs3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In mptlan_probe, it called mpt_register_lan_device and bound 
&priv->post_buckets_task with mpt_lan_post_receive_buckets_work.
When it calls lan_reply, it will finally call 
mpt_lan_wake_post_buckets_task to start the work.

When we call mptlan_remove to remove the driver, there
may be a sequence as follows:

Fix it by finishing the work before cleanup in mptlan_remove

CPU0                  CPU1

                    |mpt_lan_post_receive_buckets_work
mptlan_remove       |
  free_netdev       |
    kfree(dev);     |
                    |
                    | dev->mtu
                    |   //use

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/message/fusion/mptlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 142eb5d5d9df..de2e7bcf4784 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -1433,7 +1433,9 @@ mptlan_remove(struct pci_dev *pdev)
 {
 	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
 	struct net_device	*dev = ioc->netdev;
+	struct mpt_lan_priv *priv = netdev_priv(dev);
 
+	cancel_delayed_work_sync(&priv->post_buckets_task);
 	if(dev != NULL) {
 		unregister_netdev(dev);
 		free_netdev(dev);
-- 
2.25.1

