Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCA3C2BD09
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 08:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1AAA20836
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 08:29:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SIbW8Tb2";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="AhHY2QgE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfLKI3I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 03:29:08 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:38672
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727298AbfLKI3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 03:29:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576052946;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        bh=/BB5ljNCe9y+zTWw1QriJNl51YdSMi3VwWBeDJgmCQ8=;
        b=SIbW8Tb266d6ejHR6ZRmtV7kAtgyqFK+yrHzcEwpTsR1ux9/zxH3cUCe6MdcLkp2
        fWTfB7Qv4bwLJt5Crb2YS9PCsaOi2I7aWInHAYoQWWg1Fr5G6zg2DdmmkVRy2zVDfGA
        VQMPSHqiyiUU75j758/v2g95/BWKC+qbxLFy5O2w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576052946;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:Feedback-ID;
        bh=/BB5ljNCe9y+zTWw1QriJNl51YdSMi3VwWBeDJgmCQ8=;
        b=AhHY2QgEft5+4E3Yz5Ux7fb+xRh6FpsWqCNl0hA6V/0sSMFRSmM4SGADw9OYeFwG
        OYYY08OeRskVcUlpeD5bhs5oRAlNAh5gTFVtXP+Wwe48LL4NfcCHOSj9gb5B3U4ddYx
        7bf9hQJCuqWPIlqOTEjgQqCiAxKUmN7cwm6Kmif0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A6C5AC4479C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/2] scsi: ufs: Modulize ufs-bsg
Date:   Wed, 11 Dec 2019 08:29:06 +0000
Message-ID: <0101016ef41374ea-8a4cb3e9-5bb0-49ce-952f-2b18abcecea3-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1576052892-13510-1-git-send-email-cang@codeaurora.org>
References: <1576052892-13510-1-git-send-email-cang@codeaurora.org>
X-SES-Outgoing: 2019.12.11-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order to improve the flexibility of ufs-bsg, modulizing it is a good
choice. This change introduces tristate to ufs-bsg to allow users compile
it as an external module.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/Kconfig   |  3 ++-
 drivers/scsi/ufs/Makefile  |  2 +-
 drivers/scsi/ufs/ufs_bsg.c | 49 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufs_bsg.h |  8 --------
 drivers/scsi/ufs/ufshcd.c  | 36 ++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h  |  7 ++++++-
 6 files changed, 87 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index d14c224..72620ce 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -38,6 +38,7 @@ config SCSI_UFSHCD
 	select PM_DEVFREQ
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	select NLS
+	select BLK_DEV_BSGLIB
 	---help---
 	This selects the support for UFS devices in Linux, say Y and make
 	  sure that you know the name of your UFS host adapter (the card
@@ -143,7 +144,7 @@ config SCSI_UFS_TI_J721E
 	  If unsure, say N.
 
 config SCSI_UFS_BSG
-	bool "Universal Flash Storage BSG device node"
+	tristate "Universal Flash Storage BSG device node"
 	depends on SCSI_UFSHCD
 	select BLK_DEV_BSGLIB
 	help
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 94c6c5d..904eff1 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
-ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
+obj-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 3a2e68f..302222f 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -164,13 +164,15 @@ static int ufs_bsg_request(struct bsg_job *job)
  */
 void ufs_bsg_remove(struct ufs_hba *hba)
 {
-	struct device *bsg_dev = &hba->bsg_dev;
+	struct device *bsg_dev = hba->bsg_dev;
 
 	if (!hba->bsg_queue)
 		return;
 
 	bsg_remove_queue(hba->bsg_queue);
 
+	hba->bsg_dev = NULL;
+	hba->bsg_queue = NULL;
 	device_del(bsg_dev);
 	put_device(bsg_dev);
 }
@@ -178,6 +180,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
 static inline void ufs_bsg_node_release(struct device *dev)
 {
 	put_device(dev->parent);
+	kfree(dev);
 }
 
 /**
@@ -186,14 +189,19 @@ static inline void ufs_bsg_node_release(struct device *dev)
  *
  * Called during initial loading of the driver, and before scsi_scan_host.
  */
-int ufs_bsg_probe(struct ufs_hba *hba)
+static int ufs_bsg_probe(struct ufs_hba *hba)
 {
-	struct device *bsg_dev = &hba->bsg_dev;
+	struct device *bsg_dev;
 	struct Scsi_Host *shost = hba->host;
 	struct device *parent = &shost->shost_gendev;
 	struct request_queue *q;
 	int ret;
 
+	bsg_dev = kzalloc(sizeof(*bsg_dev), GFP_KERNEL);
+	if (!bsg_dev)
+		return -ENOMEM;
+
+	hba->bsg_dev = bsg_dev;
 	device_initialize(bsg_dev);
 
 	bsg_dev->parent = get_device(parent);
@@ -217,6 +225,41 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 
 out:
 	dev_err(bsg_dev, "fail to initialize a bsg dev %d\n", shost->host_no);
+	hba->bsg_dev = NULL;
 	put_device(bsg_dev);
 	return ret;
 }
+
+static int __init ufs_bsg_init(void)
+{
+	struct list_head *hba_list = NULL;
+	struct ufs_hba *hba;
+	int ret = 0;
+
+	ufshcd_get_hba_list_lock(&hba_list);
+	list_for_each_entry(hba, hba_list, list) {
+		ret = ufs_bsg_probe(hba);
+		if (ret)
+			break;
+	}
+	ufshcd_put_hba_list_unlock();
+
+	return ret;
+}
+
+static void __exit ufs_bsg_exit(void)
+{
+	struct list_head *hba_list = NULL;
+	struct ufs_hba *hba;
+
+	ufshcd_get_hba_list_lock(&hba_list);
+	list_for_each_entry(hba, hba_list, list)
+		ufs_bsg_remove(hba);
+	ufshcd_put_hba_list_unlock();
+}
+
+late_initcall_sync(ufs_bsg_init);
+module_exit(ufs_bsg_exit);
+
+MODULE_ALIAS("ufs-bsg");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/scsi/ufs/ufs_bsg.h b/drivers/scsi/ufs/ufs_bsg.h
index d099187..9d922c0 100644
--- a/drivers/scsi/ufs/ufs_bsg.h
+++ b/drivers/scsi/ufs/ufs_bsg.h
@@ -12,12 +12,4 @@
 #include "ufshcd.h"
 #include "ufs.h"
 
-#ifdef CONFIG_SCSI_UFS_BSG
-void ufs_bsg_remove(struct ufs_hba *hba);
-int ufs_bsg_probe(struct ufs_hba *hba);
-#else
-static inline void ufs_bsg_remove(struct ufs_hba *hba) {}
-static inline int ufs_bsg_probe(struct ufs_hba *hba) {return 0; }
-#endif
-
 #endif /* UFS_BSG_H */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a86b0fd..7a83a8f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -108,6 +108,22 @@
 		       16, 4, buf, __len, false);                        \
 } while (0)
 
+static LIST_HEAD(ufs_hba_list);
+static DEFINE_MUTEX(ufs_hba_list_lock);
+
+void ufshcd_get_hba_list_lock(struct list_head **list)
+{
+	mutex_lock(&ufs_hba_list_lock);
+	*list = &ufs_hba_list;
+}
+EXPORT_SYMBOL_GPL(ufshcd_get_hba_list_lock);
+
+void ufshcd_put_hba_list_unlock(void)
+{
+	mutex_unlock(&ufs_hba_list_lock);
+}
+EXPORT_SYMBOL_GPL(ufshcd_put_hba_list_unlock);
+
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix)
 {
@@ -2093,6 +2109,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	ufshcd_release(hba);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_send_uic_cmd);
 
 /**
  * ufshcd_map_sg - Map scatter-gather list to prdt
@@ -6024,6 +6041,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufshcd_exec_raw_upiu_cmd);
 
 /**
  * ufshcd_eh_device_reset_handler - device reset handler registered to
@@ -7043,9 +7061,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 			}
 			hba->clk_scaling.is_allowed = true;
 		}
-
-		ufs_bsg_probe(hba);
-
 		scsi_scan_host(hba->host);
 		pm_runtime_put_sync(hba->dev);
 	}
@@ -8248,7 +8263,16 @@ int ufshcd_shutdown(struct ufs_hba *hba)
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
-	ufs_bsg_remove(hba);
+	struct device *bsg_dev = hba->bsg_dev;
+
+	mutex_lock(&ufs_hba_list_lock);
+	list_del(&hba->list);
+	if (hba->bsg_queue) {
+		bsg_remove_queue(hba->bsg_queue);
+		device_del(bsg_dev);
+		put_device(bsg_dev);
+	}
+	mutex_unlock(&ufs_hba_list_lock);
 	ufs_sysfs_remove_nodes(hba->dev);
 	scsi_remove_host(hba->host);
 	scsi_host_put(hba->host);
@@ -8494,6 +8518,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
 
+	mutex_lock(&ufs_hba_list_lock);
+	list_add_tail(&hba->list, &ufs_hba_list);
+	mutex_unlock(&ufs_hba_list_lock);
+
 	return 0;
 
 out_remove_scsi_host:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2740f69..893debc 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -74,6 +74,9 @@
 
 struct ufs_hba;
 
+void ufshcd_get_hba_list_lock(struct list_head **list);
+void ufshcd_put_hba_list_unlock(void);
+
 enum dev_cmd_type {
 	DEV_CMD_TYPE_NOP		= 0x0,
 	DEV_CMD_TYPE_QUERY		= 0x1,
@@ -473,6 +476,7 @@ struct ufs_stats {
 
 /**
  * struct ufs_hba - per adapter private structure
+ * @list: Anchored at ufs_hba_list
  * @mmio_base: UFSHCI base register address
  * @ucdl_base_addr: UFS Command Descriptor base address
  * @utrdl_base_addr: UTP Transfer Request Descriptor base address
@@ -527,6 +531,7 @@ struct ufs_stats {
  * @scsi_block_reqs_cnt: reference counting for scsi block requests
  */
 struct ufs_hba {
+	struct list_head list;
 	void __iomem *mmio_base;
 
 	/* Virtual memory reference */
@@ -734,7 +739,7 @@ struct ufs_hba {
 	struct ufs_desc_size desc_size;
 	atomic_t scsi_block_reqs_cnt;
 
-	struct device		bsg_dev;
+	struct device		*bsg_dev;
 	struct request_queue	*bsg_queue;
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

