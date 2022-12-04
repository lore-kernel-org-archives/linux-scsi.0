Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2EEC4708D
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Dec 2022 07:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiLDH4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Dec 2022 02:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiLDH4G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Dec 2022 02:56:06 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC0A175BA
        for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2022 23:56:05 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NPzVt0g66zmW7d;
        Sun,  4 Dec 2022 15:55:18 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 4 Dec
 2022 15:56:03 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 2/6] scsi: libsas: delete wrapper function sas_discover_end_dev()
Date:   Sun, 4 Dec 2022 16:16:39 +0800
Message-ID: <20221204081643.3835966-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221204081643.3835966-1-yanaijie@huawei.com>
References: <20221204081643.3835966-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After commit 0558f33c06bb ("scsi: libsas: direct call probe and destruct")
this function is only a wrapper of sas_notify_lldd_dev_found(). And the
function name does not reflect the real purpose of this function now.
Remove it and call sas_notify_lldd_dev_found() directly. The log is also
changed accordingly.

Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_discover.c | 13 +------------
 drivers/scsi/libsas/sas_expander.c |  4 ++--
 include/scsi/libsas.h              |  1 -
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index d5bc1314c341..efc6bf95bb67 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -269,17 +269,6 @@ static void sas_resume_devices(struct work_struct *work)
 	sas_resume_sata(port);
 }
 
-/**
- * sas_discover_end_dev - discover an end device (SSP, etc)
- * @dev: pointer to domain device of interest
- *
- * See comment in sas_discover_sata().
- */
-int sas_discover_end_dev(struct domain_device *dev)
-{
-	return sas_notify_lldd_dev_found(dev);
-}
-
 /* ---------- Device registration and unregistration ---------- */
 
 void sas_free_device(struct kref *kref)
@@ -447,7 +436,7 @@ static void sas_discover_domain(struct work_struct *work)
 
 	switch (dev->dev_type) {
 	case SAS_END_DEVICE:
-		error = sas_discover_end_dev(dev);
+		error = sas_notify_lldd_dev_found(dev);
 		break;
 	case SAS_EDGE_EXPANDER_DEVICE:
 	case SAS_FANOUT_EXPANDER_DEVICE:
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index a04cad620e93..aa8ea3b1f2e4 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -855,9 +855,9 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
 
-		res = sas_discover_end_dev(child);
+		res = sas_notify_lldd_dev_found(child);
 		if (res) {
-			pr_notice("sas_discover_end_dev() for device %016llx at %016llx:%02d returned 0x%x\n",
+			pr_notice("notify lldd for device %016llx at %016llx:%02d returned 0x%x\n",
 				  SAS_ADDR(child->sas_addr),
 				  SAS_ADDR(parent->sas_addr), phy_id, res);
 			goto out_list_del;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 1aee3d0ebbb2..87682390fb76 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -736,7 +736,6 @@ void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
 void sas_discover_event(struct asd_sas_port *, enum discover_event ev);
 
 int  sas_discover_sata(struct domain_device *);
-int  sas_discover_end_dev(struct domain_device *);
 
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
 
-- 
2.31.1

