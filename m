Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF1DC43219
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 14:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiJTORe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 10:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJTORb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 10:17:31 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB695BC81
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 07:17:30 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MtV6S4hQfzHv3l
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 22:17:20 +0800 (CST)
Received: from localhost.localdomain (10.67.165.2) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 22:17:28 +0800
From:   Yihang Li <liyihang9@huawei.com>
To:     <john.garry@huawei.com>, <linuxarm@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <chenxiang66@hisilicon.com>,
        <prime.zeng@hisilicon.com>, <yangxingui@huawei.com>,
        <liyihang9@huawei.com>
Subject: [PATCH 2/2] scsi: libsas: Add sas_check_port_linkrate()
Date:   Thu, 20 Oct 2022 22:16:35 +0800
Message-ID: <20221020141635.2479412-3-liyihang9@huawei.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20221020141635.2479412-1-liyihang9@huawei.com>
References: <20221020141635.2479412-1-liyihang9@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We found that in the scenario where the expander device is connected to
a wide port, a physical link connected to the wide port link down and
re-establish the link at a lower link rate, while the expander device
link rate and all expander PHY link rates maintain the original link rate,
the following error occurs:

[175712.419423] hisi_sas_v3_hw 0000:74:02.0: erroneous completion iptt=2985 task=00000000268357f1 dev id=10 exp 0x500e004aaaaaaa1f phy9 addr=500e004aaaaaaa09 CQ hdr: 0x102b 0xa0ba9 0x1000 0x20000 Error info: 0x200 0x0 0x0 0x0

After analysis, it is concluded that: when the physical link is
re-established, the link rate of the expander device and the expander PHY
are not updated. As a result, the expander PHY attached to a SATA PHY is
using link rate greater than the physical PHY link rate.

Therefore, add support for check whether the link rate of physical PHY
which is connected to the port changes after the phy up occur, if the
link rate of the newly established physical phy is lower than the link
rate of the port, a smaller link rate is transmitted to the port and
update the device link rate that needs to be updated in port->dev_list.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/libsas/sas_discover.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 6998560812f2..e453d94fbd30 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -164,6 +164,20 @@ static int sas_get_port_device(struct asd_sas_port *port)
 	return 0;
 }
 
+static void sas_check_port_linkrate(struct asd_sas_port *port)
+{
+	struct asd_sas_phy *phy;
+	u32 link_rate = port->linkrate;
+
+	list_for_each_entry(phy, &port->phy_list, port_phy_el)
+		link_rate = min(link_rate, phy->linkrate);
+
+	if (port->linkrate != link_rate) {
+		port->linkrate = link_rate;
+		sas_update_linkrate(port);
+	}
+}
+
 /* ---------- Discover and Revalidate ---------- */
 
 int sas_notify_lldd_dev_found(struct domain_device *dev)
@@ -435,8 +449,10 @@ static void sas_discover_domain(struct work_struct *work)
 
 	clear_bit(DISCE_DISCOVER_DOMAIN, &port->disc.pending);
 
-	if (port->port_dev)
+	if (port->port_dev) {
+		sas_check_port_linkrate(port);
 		return;
+	}
 
 	error = sas_get_port_device(port);
 	if (error)
-- 
2.30.0

