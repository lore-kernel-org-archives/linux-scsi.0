Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B0DC3A5A7
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Dec 2022 07:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiLDH4J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Dec 2022 02:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiLDH4H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Dec 2022 02:56:07 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1790D175BB
        for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2022 23:56:06 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NPzRm6SpxzkXnY;
        Sun,  4 Dec 2022 15:52:36 +0800 (CST)
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
Subject: [PATCH 3/6] scsi: libsas: rename sas_discover_sata() and related refactors
Date:   Sun, 4 Dec 2022 16:16:40 +0800
Message-ID: <20221204081643.3835966-4-yanaijie@huawei.com>
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
this name does not reflect the real purpose of this function. So rename
it to sas_ata_notify_lldd_dev_found().

On the other hand, the coding style where calling this interface is
inconsistent with other interfaces for sata devices. The standard style
for other sata interfaces is like:

    #ifdefine CONFIG_SCSI_SAS_ATA
    void sas_ata_task_abort(struct sas_task *task);
    #else
    static inline void sas_ata_task_abort(struct sas_task *task)
    {
    }
    #endif

And the callers does not have to do things like "#ifdefine CONFIG_SCSI_SAS_ATA"
and may call the interface directly. So follow the standard style here.

Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_ata.c      | 4 ++--
 drivers/scsi/libsas/sas_discover.c | 8 +-------
 drivers/scsi/libsas/sas_expander.c | 4 ++--
 include/scsi/libsas.h              | 2 --
 include/scsi/sas_ata.h             | 6 ++++++
 5 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 34009c330eb2..01b6175a8960 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -738,14 +738,14 @@ void sas_resume_sata(struct asd_sas_port *port)
 }
 
 /**
- * sas_discover_sata - discover an STP/SATA domain device
+ * sas_ata_notify_lldd_dev_found - notify an STP/SATA domain device found
  * @dev: pointer to struct domain_device of interest
  *
  * Devices directly attached to a HA port, have no parents.  All other
  * devices do, and should have their "parent" pointer set appropriately
  * before calling this function.
  */
-int sas_discover_sata(struct domain_device *dev)
+int sas_ata_notify_lldd_dev_found(struct domain_device *dev)
 {
 	if (dev->dev_type == SAS_SATA_PM)
 		return -ENODEV;
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index efc6bf95bb67..e7e3e230e8d1 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -444,14 +444,8 @@ static void sas_discover_domain(struct work_struct *work)
 		break;
 	case SAS_SATA_DEV:
 	case SAS_SATA_PM:
-#ifdef CONFIG_SCSI_SAS_ATA
-		error = sas_discover_sata(dev);
+		error = sas_ata_notify_lldd_dev_found(dev);
 		break;
-#else
-		pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
-		fallthrough;
-#endif
-		/* Fall through - only for the #else condition above. */
 	default:
 		error = -ENXIO;
 		pr_err("unhandled device %d\n", dev->dev_type);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index aa8ea3b1f2e4..a8af723fab3c 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -830,9 +830,9 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
 
-		res = sas_discover_sata(child);
+		res = sas_ata_notify_lldd_dev_found(child);
 		if (res) {
-			pr_notice("sas_discover_sata() for device %16llx at %016llx:%02d returned 0x%x\n",
+			pr_notice("notify lldd for device %16llx at %016llx:%02d returned 0x%x\n",
 				  SAS_ADDR(child->sas_addr),
 				  SAS_ADDR(parent->sas_addr), phy_id, res);
 			goto out_list_del;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 87682390fb76..b8b05f653a96 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -735,8 +735,6 @@ void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
 void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
 void sas_discover_event(struct asd_sas_port *, enum discover_event ev);
 
-int  sas_discover_sata(struct domain_device *);
-
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
 
 void sas_init_dev(struct domain_device *);
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 9c927d46f136..a3857595ba55 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -36,6 +36,7 @@ void sas_ata_device_link_abort(struct domain_device *dev, bool force_reset);
 int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
 			int force_phy_id);
 int smp_ata_check_ready_type(struct ata_link *link);
+int sas_ata_notify_lldd_dev_found(struct domain_device *dev);
 #else
 
 
@@ -103,6 +104,11 @@ static inline int smp_ata_check_ready_type(struct ata_link *link)
 {
 	return 0;
 }
+static inline int sas_ata_notify_lldd_dev_found(struct domain_device *dev)
+{
+	pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
+	return -ENXIO;
+}
 #endif
 
 #endif /* _SAS_ATA_H_ */
-- 
2.31.1

