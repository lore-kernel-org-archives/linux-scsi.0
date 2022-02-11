Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B193C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 06:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345608AbiBKGsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 01:48:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245378AbiBKGsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 01:48:22 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC75E10EA
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 22:48:20 -0800 (PST)
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jw3xH2vQzzZfQq;
        Fri, 11 Feb 2022 14:44:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Fri, 11 Feb 2022 14:48:18 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 1/4] scsi: libsas: Use void for sas_discover_event() return code
Date:   Fri, 11 Feb 2022 14:42:55 +0800
Message-ID: <1644561778-183074-2-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1644561778-183074-1-git-send-email-chenxiang66@hisilicon.com>
References: <1644561778-183074-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

The callers of function sas_discover_event() don't check its return value,
and also it only returns 0, so use void for its return code.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_discover.c | 6 ++----
 include/scsi/libsas.h              | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 758213694091..d5bc1314c341 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -545,19 +545,17 @@ static void sas_chain_event(int event, unsigned long *pending,
 	}
 }
 
-int sas_discover_event(struct asd_sas_port *port, enum discover_event ev)
+void sas_discover_event(struct asd_sas_port *port, enum discover_event ev)
 {
 	struct sas_discovery *disc;
 
 	if (!port)
-		return 0;
+		return;
 	disc = &port->disc;
 
 	BUG_ON(ev >= DISC_NUM_EVENTS);
 
 	sas_chain_event(ev, &disc->pending, &disc->disc_work[ev].work, port->ha);
-
-	return 0;
 }
 
 /**
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 698f2032807b..1bb7ceded135 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -685,7 +685,7 @@ int  sas_ex_revalidate_domain(struct domain_device *);
 
 void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
 void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
-int  sas_discover_event(struct asd_sas_port *, enum discover_event ev);
+void sas_discover_event(struct asd_sas_port *, enum discover_event ev);
 
 int  sas_discover_sata(struct domain_device *);
 int  sas_discover_end_dev(struct domain_device *);
-- 
2.33.0

