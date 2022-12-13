Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74788C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 14:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbiLMOtK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 09:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235756AbiLMOtE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 09:49:04 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193075F86
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 06:49:01 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NWh9r3yStzJpKN;
        Tue, 13 Dec 2022 22:45:20 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 13 Dec
 2022 22:48:57 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 2/5] scsi: libsas: change the coding style of sas_discover_sata()
Date:   Tue, 13 Dec 2022 23:09:39 +0800
Message-ID: <20221213150942.988371-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213150942.988371-1-yanaijie@huawei.com>
References: <20221213150942.988371-1-yanaijie@huawei.com>
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

The coding style where calling this interface is inconsistent with other
interfaces for sata devices. The standard style for other sata interfaces
is like:

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
 drivers/scsi/libsas/sas_discover.c | 6 ------
 include/scsi/libsas.h              | 1 -
 include/scsi/sas_ata.h             | 6 ++++++
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index d5bc1314c341..72fdb2e5d047 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -455,14 +455,8 @@ static void sas_discover_domain(struct work_struct *work)
 		break;
 	case SAS_SATA_DEV:
 	case SAS_SATA_PM:
-#ifdef CONFIG_SCSI_SAS_ATA
 		error = sas_discover_sata(dev);
 		break;
-#else
-		pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
-		fallthrough;
-#endif
-		/* Fall through - only for the #else condition above. */
 	default:
 		error = -ENXIO;
 		pr_err("unhandled device %d\n", dev->dev_type);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 1aee3d0ebbb2..159823e0afbf 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -735,7 +735,6 @@ void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
 void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
 void sas_discover_event(struct asd_sas_port *, enum discover_event ev);
 
-int  sas_discover_sata(struct domain_device *);
 int  sas_discover_end_dev(struct domain_device *);
 
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 9c927d46f136..2fd15f194316 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -36,6 +36,7 @@ void sas_ata_device_link_abort(struct domain_device *dev, bool force_reset);
 int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
 			int force_phy_id);
 int smp_ata_check_ready_type(struct ata_link *link);
+int sas_discover_sata(struct domain_device *dev);
 #else
 
 
@@ -103,6 +104,11 @@ static inline int smp_ata_check_ready_type(struct ata_link *link)
 {
 	return 0;
 }
+static inline int sas_discover_sata(struct domain_device *dev)
+{
+	pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
+	return -ENXIO;
+}
 #endif
 
 #endif /* _SAS_ATA_H_ */
-- 
2.31.1

