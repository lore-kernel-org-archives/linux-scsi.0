From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 5/8] scsi: libsas: check if the same sata device when flutter
Date: Tue, 29 May 2018 10:23:06 +0800
Message-ID: <20180529022309.21071-6-yanaijie@huawei.com>
References: <20180529022309.21071-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529022309.21071-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Jason Yan <yanaijie@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

The ata device do not have a real sas address. If a ata device is
replaced with another one, the sas address is the same. Now libsas treat
this senario as flutter and do not delete the old one and discover the
new one. This will cause the data read from or write to the wrong
device.

And also when hotplugging a sata device, libsas entered to the flutter
case and sometimes found the phy attached address is abnormal. The log
is like this:

sas: ex 500e004aaaaaaa1f phy6 originated BROADCAST(CHANGE)
sas: ex 500e004aaaaaaa1f phy06:U:0 attached: 0000000000000000 (no device)
sas: ex 500e004aaaaaaa1f phy 0x6 broadcast flutter

Fix this issue by checking the phy attached address and the ata device's
class and id if they are the same as the origin. The ata class and id is
readed in ata EH process. When ata EH is scheduled, revalidate will be
deferred and a new bcast will be raised.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
CC: chenxiang <chenxiang66@hisilicon.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Tejun Heo <tj@kernel.org>
CC: Hannes Reinecke <hare@suse.com>
---
 drivers/ata/libata-core.c          |  3 ++-
 drivers/scsi/libsas/sas_ata.c      | 18 ++++++++++++++++++
 drivers/scsi/libsas/sas_expander.c | 28 ++++++++++++++++++++++++++++
 include/linux/libata.h             |  2 ++
 include/scsi/libsas.h              |  1 +
 5 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 68596bd4cf06..7656ad58b381 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4228,7 +4228,7 @@ void ata_std_postreset(struct ata_link *link, unsigned int *classes)
  *	RETURNS:
  *	1 if @dev matches @new_class and @new_id, 0 otherwise.
  */
-static int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
+int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
 			       const u16 *new_id)
 {
 	const u16 *old_id = dev->id;
@@ -7391,3 +7391,4 @@ EXPORT_SYMBOL_GPL(ata_cable_80wire);
 EXPORT_SYMBOL_GPL(ata_cable_unknown);
 EXPORT_SYMBOL_GPL(ata_cable_ignore);
 EXPORT_SYMBOL_GPL(ata_cable_sata);
+EXPORT_SYMBOL_GPL(ata_dev_same_device);
\ No newline at end of file
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 0cc1567eacc1..83f2c920480b 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -620,6 +620,22 @@ static int sas_get_ata_command_set(struct domain_device *dev)
 	return ata_dev_classify(&tf);
 }
 
+static void sas_ata_store_id(struct domain_device *dev)
+{
+	struct ata_device *ata_dev = sas_to_ata_dev(dev);
+	unsigned char model[ATA_ID_PROD_LEN + 1];
+	unsigned char serial[ATA_ID_SERNO_LEN + 1];
+
+	/* store the ata device's class and id */
+	memcpy(dev->sata_dev.id, ata_dev->id, ATA_ID_WORDS);
+	dev->sata_dev.class = ata_dev->class;
+
+	ata_id_c_string(ata_dev->id, model, ATA_ID_PROD, sizeof(model));
+	ata_id_c_string(ata_dev->id, serial, ATA_ID_SERNO, sizeof(serial));
+
+	sas_ata_printk(KERN_INFO, dev, "model:%s serial:%s\n", model, serial);
+}
+
 void sas_probe_sata(struct asd_sas_port *port)
 {
 	struct domain_device *dev, *n;
@@ -644,6 +660,8 @@ void sas_probe_sata(struct asd_sas_port *port)
 		 */
 		if (ata_dev_disabled(sas_to_ata_dev(dev)))
 			sas_fail_probe(dev, __func__, -ENODEV);
+		else
+			sas_ata_store_id(dev);
 	}
 
 }
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 25ad9ef54e6c..4617eccb0c43 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2053,9 +2053,37 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
 			action = ", needs recovery";
 		SAS_DPRINTK("ex %016llx phy 0x%x broadcast flutter%s\n",
 			    SAS_ADDR(dev->sas_addr), phy_id, action);
+
+		/* the phy attached address will be updated by sas_ex_phy_discover()
+		 * and sometimes become abnormal
+		 */
+		if (SAS_ADDR(phy->attached_sas_addr) != SAS_ADDR(sas_addr) ||
+		    SAS_ADDR(phy->attached_sas_addr) == 0) {
+			/* if attached_sas_addr become abnormal, we must set the
+			 * original address back so that the device can be unregistered
+			 */
+			memcpy(phy->attached_sas_addr, sas_addr, SAS_ADDR_SIZE);
+			SAS_DPRINTK("phy address(%016llx) abnormal, origin:%016llx\n",
+				    SAS_ADDR(phy->attached_sas_addr),
+				    SAS_ADDR(sas_addr));
+			goto unregister;
+		}
+
+
+		if (ata_dev) {
+			struct ata_device *adev = sas_to_ata_dev(ata_dev);
+			unsigned int class = ata_dev->sata_dev.class;
+			u16 *id = ata_dev->sata_dev.id;
+
+			/* to see if the disk is replaced with another one */
+			if (!ata_dev_same_device(adev, class, id))
+				goto unregister;
+		}
+
 		return res;
 	}
 
+unregister:
 	/* we always have to delete the old device when we went here */
 	SAS_DPRINTK("ex %016llx phy 0x%x replace %016llx\n",
 		    SAS_ADDR(dev->sas_addr), phy_id,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 1795fecdea17..a1aff2fdf11b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1140,6 +1140,8 @@ extern int sata_scr_write(struct ata_link *link, int reg, u32 val);
 extern int sata_scr_write_flush(struct ata_link *link, int reg, u32 val);
 extern bool ata_link_online(struct ata_link *link);
 extern bool ata_link_offline(struct ata_link *link);
+extern int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
+			     const u16 *new_id);
 #ifdef CONFIG_PM
 extern int ata_host_suspend(struct ata_host *host, pm_message_t mesg);
 extern void ata_host_resume(struct ata_host *host);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 225ab7783dfd..8f403b7bb552 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -164,6 +164,7 @@ struct sata_device {
 	struct ata_host ata_host;
 	struct smp_resp rps_resp ____cacheline_aligned; /* report_phy_sata_resp */
 	u8     fis[ATA_RESP_FIS_SIZE];
+	u16    id[ATA_ID_WORDS];
 };
 
 struct ssp_device {
-- 
2.13.6
