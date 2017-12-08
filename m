From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 3/7] scsi: libsas: make the event threshold configurable
Date: Fri, 8 Dec 2017 17:42:06 +0800
Message-ID: <20171208094210.24887-4-yanaijie@huawei.com>
References: <20171208094210.24887-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2266 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753226AbdLHJgk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Dec 2017 04:36:40 -0500
In-Reply-To: <20171208094210.24887-1-yanaijie@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiyou.wangcong@gmail.com, Jason Yan <yanaijie@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>

Add a sysfs attr that LLDD can configure it for every host. We made
a example in hisi_sas. Other LLDDs using libsas can implement it if
they want.

Suggested-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c |  6 ++++++
 drivers/scsi/libsas/sas_init.c        | 31 +++++++++++++++++++++++++++++++
 include/scsi/libsas.h                 |  1 +
 3 files changed, 38 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5f503cb..b5ce64a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1561,6 +1561,11 @@ EXPORT_SYMBOL_GPL(hisi_sas_kill_tasklets);
 struct scsi_transport_template *hisi_sas_stt;
 EXPORT_SYMBOL_GPL(hisi_sas_stt);
 
+struct device_attribute *host_attrs[] = {
+	&dev_attr_phy_event_threshold,
+	NULL,
+};
+
 static struct scsi_host_template _hisi_sas_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -1580,6 +1585,7 @@ static struct scsi_host_template _hisi_sas_sht = {
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+	.shost_attrs		= host_attrs,
 };
 struct scsi_host_template *hisi_sas_sht = &_hisi_sas_sht;
 EXPORT_SYMBOL_GPL(hisi_sas_sht);
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 22bfc02..afd928b 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -538,6 +538,37 @@ static struct sas_function_template sft = {
 	.smp_handler = sas_smp_handler,
 };
 
+static inline ssize_t phy_event_threshold_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", sha->event_thres);
+}
+
+static inline ssize_t phy_event_threshold_store(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+
+	sha->event_thres = simple_strtol(buf, NULL, 10);
+
+	/* threshold cannot be set too small */
+	if (sha->event_thres < 32)
+		sha->event_thres = 32;
+
+	return count;
+}
+
+DEVICE_ATTR(phy_event_threshold,
+	S_IRUGO|S_IWUSR,
+	phy_event_threshold_show,
+	phy_event_threshold_store);
+EXPORT_SYMBOL_GPL(dev_attr_phy_event_threshold);
+
 struct scsi_transport_template *
 sas_domain_attach_transport(struct sas_domain_function_template *dft)
 {
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 26683e2..701c67f 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -681,6 +681,7 @@ extern int sas_bios_param(struct scsi_device *,
 			  sector_t capacity, int *hsc);
 extern struct scsi_transport_template *
 sas_domain_attach_transport(struct sas_domain_function_template *);
+extern struct device_attribute dev_attr_phy_event_threshold;
 
 int  sas_discover_root_expander(struct domain_device *);
 
-- 
2.9.5
