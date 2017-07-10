From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v3 6/7] libsas: add wait-complete support to sync discovery event
Date: Mon, 10 Jul 2017 15:06:08 +0800
Message-ID: <1499670369-44143-7-git-send-email-wangyijing@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:9812 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdGJHCa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2017 03:02:30 -0400
In-Reply-To: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Yijing Wang <wangyijing@huawei.com>, Johannes Thumshirn <jthumshirn@suse.de>

Introduce a sync flag to tag discovery event whether need to
sync execute, per-event wait-complete ensure sync.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_discover.c |  8 ++++++--
 drivers/scsi/libsas/sas_expander.c | 12 +++++++++++-
 drivers/scsi/libsas/sas_internal.h | 27 +++++++++++++++++++++++++++
 include/scsi/libsas.h              |  2 ++
 4 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index a25d648..d68f8dd 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -378,6 +378,7 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 		list_del_init(&dev->disco_list_node);
 		sas_rphy_free(dev->rphy);
 		sas_unregister_common_dev(port, dev);
+		sas_disc_cancel_sync(&port->disc.disc_work[DISCE_DESTRUCT]);
 		return;
 	}
 
@@ -541,6 +542,7 @@ static void sas_discover_common_fn(struct work_struct *work)
 	struct asd_sas_port *port = ev->port;
 
 	sas_event_fns[ev->type](work);
+	sas_disc_wakeup(ev);
 	sas_port_put(port);
 }
 
@@ -571,8 +573,10 @@ static void sas_chain_work(struct sas_ha_struct *ha, struct sas_work *sw)
 	else
 		ret = scsi_queue_work(ha->core.shost, &sw->work);
 
-	if (ret != 1)
+	if (ret != 1) {
 		sas_port_put(port);
+		sas_disc_cancel_sync(ev);
+	}
 }
 
 static void sas_chain_event(int event, unsigned long *pending,
@@ -592,9 +596,9 @@ int sas_discover_event(struct asd_sas_port *port, enum discover_event ev)
 {
 	struct sas_discovery *disc;
 
+	disc = &port->disc;
 	if (!port)
 		return 0;
-	disc = &port->disc;
 
 	BUG_ON(ev >= DISC_NUM_EVENTS);
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 570b2cb..9d26c28 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -822,14 +822,18 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
 
+		sas_disc_wait_init(child->port, DISCE_PROBE);
 		res = sas_discover_sata(child);
 		if (res) {
+			sas_disc_cancel_sync(&child->port->disc.disc_work[DISCE_PROBE]);
 			SAS_DPRINTK("sas_discover_sata() for device %16llx at "
 				    "%016llx:0x%x returned 0x%x\n",
 				    SAS_ADDR(child->sas_addr),
 				    SAS_ADDR(parent->sas_addr), phy_id, res);
 			goto out_list_del;
 		}
+		sas_disc_wait_completion(child->port, DISCE_PROBE);
+
 	} else
 #endif
 	  if (phy->attached_tproto & SAS_PROTOCOL_SSP) {
@@ -847,14 +851,17 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
 
+		sas_disc_wait_init(child->port, DISCE_PROBE);
 		res = sas_discover_end_dev(child);
 		if (res) {
+			sas_disc_cancel_sync(&child->port->disc.disc_work[DISCE_PROBE]);
 			SAS_DPRINTK("sas_discover_end_dev() for device %16llx "
 				    "at %016llx:0x%x returned 0x%x\n",
 				    SAS_ADDR(child->sas_addr),
 				    SAS_ADDR(parent->sas_addr), phy_id, res);
 			goto out_list_del;
 		}
+		sas_disc_wait_completion(child->port, DISCE_PROBE);
 	} else {
 		SAS_DPRINTK("target proto 0x%x at %016llx:0x%x not handled\n",
 			    phy->attached_tproto, SAS_ADDR(parent->sas_addr),
@@ -1890,8 +1897,11 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 				if (child->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
 				    child->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
 					sas_unregister_ex_tree(parent->port, child);
-				else
+				else {
+					sas_disc_wait_init(parent->port, DISCE_DESTRUCT);
 					sas_unregister_dev(parent->port, child);
+					sas_disc_wait_completion(parent->port, DISCE_DESTRUCT);
+				}
 				found = child;
 				break;
 			}
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 890b5d26..09a9b10 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -134,6 +134,33 @@ static inline void sas_port_get(struct asd_sas_port *port)
 		kref_get(&port->ref);
 }
 
+static inline void sas_disc_cancel_sync(struct sas_discovery_event *event)
+{
+	event->is_sync = false;
+}
+
+static inline void sas_disc_wakeup(struct sas_discovery_event *event)
+{
+	if (event->is_sync)
+		complete(&event->completion);
+}
+
+static inline void sas_disc_wait_init(struct asd_sas_port *port,
+		enum discover_event event)
+{
+	port->disc.disc_work[event].is_sync = true;
+	init_completion(&port->disc.disc_work[event].completion);
+}
+
+static inline void sas_disc_wait_completion(struct asd_sas_port *port,
+		enum discover_event event)
+{
+	if (port->disc.disc_work[event].is_sync) {
+		wait_for_completion(&port->disc.disc_work[event].completion);
+		port->disc.disc_work[event].is_sync = false;
+	}
+}
+
 #ifdef CONFIG_SCSI_SAS_HOST_SMP
 extern int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 				struct request *rsp);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 4bcb9fe..21e9fb140 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -243,6 +243,8 @@ struct sas_discovery_event {
 	struct sas_work work;
 	struct asd_sas_port *port;
 	enum discover_event	type;
+	bool is_sync;
+	struct completion completion;
 };
 
 static inline struct sas_discovery_event *to_sas_discovery_event(struct work_struct *work)
-- 
2.5.0
