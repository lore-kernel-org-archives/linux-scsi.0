From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v3 3/7] libsas: Use new workqueue to run sas event
Date: Mon, 10 Jul 2017 15:06:05 +0800
Message-ID: <1499670369-44143-4-git-send-email-wangyijing@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Yijing Wang <wangyijing@huawei.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Now all libsas works are queued to scsi host workqueue,
include sas event work post by LLDD and sas discovery
work, and a sas hotplug flow may be divided into several
works, e.g libsas receive a PORTE_BYTES_DMAED event,
now we process it as following steps:
sas_form_port  --- run in work in shot workq
	sas_discover_domain  --- run in another work in shost workq
		...
		sas_probe_devices  --- run in new work in shost workq
We found during hot-add a device, libsas may need run several
works in same workqueue to add device in system, the process is
not atomic, it may interrupt by other sas event works, like
PHYE_LOSS_OF_SIGNAL. Finally, we would found lots unexpected
errors. This patch is preparation of execute libsas sas event
in sync.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_event.c | 4 ++--
 drivers/scsi/libsas/sas_init.c  | 7 +++++++
 include/scsi/libsas.h           | 1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index a1370bd..a72a089 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -46,7 +46,7 @@ int sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
 		if (list_empty(&sw->drain_node))
 			list_add(&sw->drain_node, &ha->defer_q);
 	} else
-		rc = scsi_queue_work(ha->core.shost, &sw->work);
+		rc = queue_work(ha->event_q, &sw->work);
 
 	return rc;
 }
@@ -69,7 +69,7 @@ void __sas_drain_work(struct sas_ha_struct *ha)
 {
 	int ret;
 	unsigned long flags;
-	struct workqueue_struct *wq = ha->core.shost->work_q;
+	struct workqueue_struct *wq = ha->event_q;
 	struct sas_work *sw, *_sw;
 
 	set_bit(SAS_HA_DRAINING, &ha->state);
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index c227a8b..2f3b736 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -115,6 +115,7 @@ void sas_hae_reset(struct work_struct *work)
 
 int sas_register_ha(struct sas_ha_struct *sas_ha)
 {
+	char name[64];
 	int error = 0;
 
 	mutex_init(&sas_ha->disco_mutex);
@@ -146,6 +147,11 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 		goto Undo_ports;
 	}
 
+	snprintf(name, 64, "%s_event_q", dev_name(sas_ha->dev));
+	sas_ha->event_q = create_singlethread_workqueue(name);
+	if (!sas_ha->event_q)
+		goto Undo_ports;
+
 	INIT_LIST_HEAD(&sas_ha->eh_done_q);
 	INIT_LIST_HEAD(&sas_ha->eh_ata_q);
 
@@ -180,6 +186,7 @@ int sas_unregister_ha(struct sas_ha_struct *sas_ha)
 	mutex_lock(&sas_ha->drain_mutex);
 	__sas_drain_work(sas_ha);
 	mutex_unlock(&sas_ha->drain_mutex);
+	destroy_workqueue(sas_ha->event_q);
 
 	return 0;
 }
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 628f48b..a01ca42 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -402,6 +402,7 @@ struct sas_ha_struct {
 	char *sas_ha_name;
 	struct device *dev;	  /* should be set */
 	struct module *lldd_module; /* should be set */
+	struct workqueue_struct *event_q;
 
 	u8 *sas_addr;		  /* must be set */
 	u8 hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
-- 
2.5.0
