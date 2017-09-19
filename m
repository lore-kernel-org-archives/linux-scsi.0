From: Jason Yan <yanaijie@huawei.com>
Subject: [RESEND PATCH v4 3/6] libsas: make the event threshold configurable
Date: Tue, 19 Sep 2017 15:09:03 +0800
Message-ID: <1505804946-39266-4-git-send-email-yanaijie@huawei.com>
References: <1505804946-39266-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505804946-39266-1-git-send-email-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, chenweilong@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, Jason Yan <yanaijie@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

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
 drivers/scsi/libsas/sas_init.c        | 27 +++++++++++++++++++++++++++
 include/scsi/libsas.h                 |  1 +
 3 files changed, 34 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5e47abb..9eceed1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1470,6 +1470,11 @@ EXPORT_SYMBOL_GPL(hisi_sas_rescan_topology);
 struct scsi_transport_template *hisi_sas_stt;
 EXPORT_SYMBOL_GPL(hisi_sas_stt);
 
+struct device_attribute *host_attrs[] = {
+    &dev_attr_phy_event_threshold,
+    NULL,
+};
+
 static struct scsi_host_template _hisi_sas_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -1489,6 +1494,7 @@ static struct scsi_host_template _hisi_sas_sht = {
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+	.shost_attrs		= host_attrs,
 };
 struct scsi_host_template *hisi_sas_sht = &_hisi_sas_sht;
 EXPORT_SYMBOL_GPL(hisi_sas_sht);
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index b1e03d5..e2d98a8 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -537,6 +537,33 @@ static struct sas_function_template sft = {
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
+	return count;
+}
+
+DEVICE_ATTR(phy_event_threshold,
+             S_IRUGO|S_IWUSR,
+             phy_event_threshold_show,
+             phy_event_threshold_store);
+EXPORT_SYMBOL_GPL(dev_attr_phy_event_threshold);
+
 struct scsi_transport_template *
 sas_domain_attach_transport(struct sas_domain_function_template *dft)
 {
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 2fa0b13..08c1c32 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -679,6 +679,7 @@ extern int sas_bios_param(struct scsi_device *,
 			  sector_t capacity, int *hsc);
 extern struct scsi_transport_template *
 sas_domain_attach_transport(struct sas_domain_function_template *);
+extern struct device_attribute dev_attr_phy_event_threshold;
 
 int  sas_discover_root_expander(struct domain_device *);
 
-- 
2.5.0
