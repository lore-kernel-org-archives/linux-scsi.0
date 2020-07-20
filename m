Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E59C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 08:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FAE720709
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 08:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgGTIWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 04:22:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7790 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbgGTIWW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jul 2020 04:22:22 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E89D387299D0DBEA22D3;
        Mon, 20 Jul 2020 16:22:17 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 16:22:11 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] scsi: fnic: use eth_broadcast_addr() to assign broadcast address
Date:   Mon, 20 Jul 2020 16:24:58 +0800
Message-ID: <1595233498-13628-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Use eth_broadcast_addr() to assign broadcast address insetad of memset().

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 27535c90b248..03b1805b106c 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -23,6 +23,7 @@
 #include <linux/scatterlist.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
+#include <linux/etherdevice.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/delay.h>
@@ -275,7 +276,7 @@ int fnic_flogi_reg_handler(struct fnic *fnic, u32 fc_id)
 	}
 
 	if (fnic->ctlr.map_dest) {
-		memset(gw_mac, 0xff, ETH_ALEN);
+		eth_broadcast_addr(gw_mac);
 		format = FCPIO_FLOGI_REG_DEF_DEST;
 	} else {
 		memcpy(gw_mac, fnic->ctlr.dest_addr, ETH_ALEN);
-- 
2.19.1

