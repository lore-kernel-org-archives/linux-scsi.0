From: Yijing Wang <wangyijing@huawei.com>
Subject: [Resend][PATCH v2 2/2] libsas: Enhance libsas hotplug
Date: Wed, 14 Jun 2017 15:36:41 +0800
Message-ID: <1497425801-19249-3-git-send-email-wangyijing@huawei.com>
References: <1497425801-19249-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497425801-19249-1-git-send-email-wangyijing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Yijing Wang <wangyijing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Libsas complete a hotplug event notified by LLDD in several works,
for example, if libsas receive a PHYE_LOSS_OF_SIGNAL, we process it
in following steps:

notify_phy_event	[interrupt context]
	sas_queue_event		[queue work on shost->work_q]
		sas_phye_loss_of_signal		[running in shost->work_q]
			sas_deform_port		[remove sas port]
				sas_unregister_dev
					sas_discover_event	[queue destruct work on shost->work_q tail]

In above case, complete whole hotplug in two works, remove sas port first, then
put the destruction of device in another work and queue it on in the tail of
workqueue, since sas port is the parent of the children rphy device, so if remove
sas port first, the children rphy device would also be deleted, when the destruction
work coming, it would find the target has been removed already, and report a
sysfs warning calltrace.

queue tail                                             queue head
DISCE_DESTRUCT----> PORTE_BYTES_DMAED event ----->PHYE_LOSS_OF_SIGNAL[running]

There are other hotplug issues in current framework, in above case, if there is
hotadd sas event queued between hotremove works, the hotplug order would be broken
and unexpected issues would happen.

In this patch, we try to solve these issues in following steps:
1. create a new workqueue used to run sas event work, instead of scsi host workqueue,
   because we may block sas event work, we cannot block the normal scsi works.
   When libsas receive a phy down event, sas_deform_port would be called, and now we
   block sas_deform_port and wait for destruction work finish, in sas_destruct_devices,
   we may wait ata error handler, it would take a long time, so if do all stuff in scsi
   host workq, libsas may block other scsi works too long.
2. create a new workqueue used to run sas discovery events work, instead of scsi host
   workqueue, because in some cases, eg. in revalidate domain event, we may unregister
   a sas device and discover new one, we must sync the execution, wait the remove process
   finish, then start a new discovery. So we must put the probe and destruct discovery
   events in a new workqueue to avoid deadlock.
3. introudce a asd_sas_port level wait-complete and a sas_discovery level wait-complete
   we use former wait-complete to achieve a sas event atomic process and use latter to
   make a sas discovery sync.
4. remove disco_mutex in sas_revalidate_domain, since now sas_revalidate_domain sync
   the destruct discovery event execution, it's no need to lock disco mutex there.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/scsi/libsas/sas_discover.c | 58 ++++++++++++++++++++++++++----------
 drivers/scsi/libsas/sas_event.c    |  2 +-
 drivers/scsi/libsas/sas_expander.c |  9 +++++-
 drivers/scsi/libsas/sas_init.c     | 23 +++++++++++++-
 drivers/scsi/libsas/sas_internal.h | 61 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_port.c     |  4 +++
 include/scsi/libsas.h              |  9 ++++++
 7 files changed, 148 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 60de662..43e8a1e 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -503,11 +503,10 @@ static void sas_revalidate_domain(struct work_struct *work)
 	struct domain_device *ddev = port->port_dev;
 
 	/* prevent revalidation from finding sata links in recovery */
-	mutex_lock(&ha->disco_mutex);
 	if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)) {
 		SAS_DPRINTK("REVALIDATION DEFERRED on port %d, pid:%d\n",
 			    port->id, task_pid_nr(current));
-		goto out;
+		return;
 	}
 
 	clear_bit(DISCE_REVALIDATE_DOMAIN, &port->disc.pending);
@@ -521,20 +520,57 @@ static void sas_revalidate_domain(struct work_struct *work)
 
 	SAS_DPRINTK("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
 		    port->id, task_pid_nr(current), res);
- out:
-	mutex_unlock(&ha->disco_mutex);
+}
+
+static const work_func_t sas_event_fns[DISC_NUM_EVENTS] = {
+	[DISCE_DISCOVER_DOMAIN] = sas_discover_domain,
+	[DISCE_REVALIDATE_DOMAIN] = sas_revalidate_domain,
+	[DISCE_PROBE] = sas_probe_devices,
+	[DISCE_SUSPEND] = sas_suspend_devices,
+	[DISCE_RESUME] = sas_resume_devices,
+	[DISCE_DESTRUCT] = sas_destruct_devices,
+};
+
+/* a simple wrapper for sas discover event funtions */
+static void sas_discover_common_fn(struct work_struct *work)
+{
+	struct sas_discovery_event *ev = to_sas_discovery_event(work);
+	struct asd_sas_port *port = ev->port;
+
+	sas_event_fns[ev->type](work);
+	sas_unbusy_port(port);
 }
 
 /* ---------- Events ---------- */
 
 static void sas_chain_work(struct sas_ha_struct *ha, struct sas_work *sw)
 {
+	int ret;
+	struct sas_discovery_event *ev = to_sas_discovery_event(&sw->work);
+	struct asd_sas_port *port = ev->port;
+
 	/* chained work is not subject to SA_HA_DRAINING or
 	 * SAS_HA_REGISTERED, because it is either submitted in the
 	 * workqueue, or known to be submitted from a context that is
 	 * not racing against draining
 	 */
-	scsi_queue_work(ha->core.shost, &sw->work);
+	sas_busy_port(port);
+
+	/*
+	 * discovery event probe and destruct would be called in other
+	 * discovery event like discover domain and revalidate domain
+	 * events, in some cases, we need to sync execute probe and destruct
+	 * events, so run discover events except probe/destruct in a new
+	 * workqueue.
+	 */
+	if (ev->type == DISCE_PROBE || ev->type == DISCE_DESTRUCT)
+		ret = scsi_queue_work(ha->core.shost, &sw->work);
+	else
+		ret = queue_work(ha->disc_q, &sw->work);
+
+	if (ret != 1)
+		/* queue a work fail, unbusy the ha before return */
+		sas_unbusy_port(port);
 }
 
 static void sas_chain_event(int event, unsigned long *pending,
@@ -575,18 +611,10 @@ void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *port)
 {
 	int i;
 
-	static const work_func_t sas_event_fns[DISC_NUM_EVENTS] = {
-		[DISCE_DISCOVER_DOMAIN] = sas_discover_domain,
-		[DISCE_REVALIDATE_DOMAIN] = sas_revalidate_domain,
-		[DISCE_PROBE] = sas_probe_devices,
-		[DISCE_SUSPEND] = sas_suspend_devices,
-		[DISCE_RESUME] = sas_resume_devices,
-		[DISCE_DESTRUCT] = sas_destruct_devices,
-	};
-
 	disc->pending = 0;
 	for (i = 0; i < DISC_NUM_EVENTS; i++) {
-		INIT_SAS_WORK(&disc->disc_work[i].work, sas_event_fns[i]);
+		INIT_SAS_WORK(&disc->disc_work[i].work, sas_discover_common_fn);
 		disc->disc_work[i].port = port;
+		disc->disc_work[i].type = i;
 	}
 }
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 06c5c4b..c0fc07d 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -41,7 +41,7 @@ void sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
 		if (list_empty(&sw->drain_node))
 			list_add(&sw->drain_node, &ha->defer_q);
 	} else
-		scsi_queue_work(ha->core.shost, &sw->work);
+		queue_work(ha->event_q, &sw->work);
 }
 
 static void sas_queue_event(int event, struct sas_work *work,
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 570b2cb..7db4a28 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -822,7 +822,9 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
 
+		sas_wait_discover_event_init(child->port);
 		res = sas_discover_sata(child);
+		sas_wait_for_discover_event_finish(child->port);
 		if (res) {
 			SAS_DPRINTK("sas_discover_sata() for device %16llx at "
 				    "%016llx:0x%x returned 0x%x\n",
@@ -847,7 +849,9 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
 
+		sas_wait_discover_event_init(child->port);
 		res = sas_discover_end_dev(child);
+		sas_wait_for_discover_event_finish(child->port);
 		if (res) {
 			SAS_DPRINTK("sas_discover_end_dev() for device %16llx "
 				    "at %016llx:0x%x returned 0x%x\n",
@@ -1890,8 +1894,11 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 				if (child->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
 				    child->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
 					sas_unregister_ex_tree(parent->port, child);
-				else
+				else {
+					sas_wait_discover_event_init(parent->port);
 					sas_unregister_dev(parent->port, child);
+					sas_wait_for_discover_event_finish(parent->port);
+				}
 				found = child;
 				break;
 			}
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index c227a8b..c9907ec1 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -38,6 +38,8 @@
 
 #include "../scsi_sas_internal.h"
 
+static DEFINE_IDA(sas_ida);
+
 static struct kmem_cache *sas_task_cache;
 
 struct sas_task *sas_alloc_task(gfp_t flags)
@@ -116,6 +118,7 @@ void sas_hae_reset(struct work_struct *work)
 int sas_register_ha(struct sas_ha_struct *sas_ha)
 {
 	int error = 0;
+	char name[64];
 
 	mutex_init(&sas_ha->disco_mutex);
 	spin_lock_init(&sas_ha->phy_port_lock);
@@ -146,6 +149,22 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 		goto Undo_ports;
 	}
 
+	snprintf(name, 64, "%s_event_q", dev_name(sas_ha->dev));
+	sas_ha->event_q = create_singlethread_workqueue(name);
+	if (!sas_ha->event_q)
+		goto Undo_ports;
+
+	/*
+	 * sas-disc-xx workqueue run the discover work except
+	 * probe and destruct.
+	 */
+	snprintf(name, 64, "%s_disc_q", dev_name(sas_ha->dev));
+	sas_ha->disc_q = create_singlethread_workqueue(name);
+	if(!sas_ha->disc_q) {
+		destroy_workqueue(sas_ha->event_q);
+		goto Undo_ports;
+	}
+
 	INIT_LIST_HEAD(&sas_ha->eh_done_q);
 	INIT_LIST_HEAD(&sas_ha->eh_ata_q);
 
@@ -181,6 +200,9 @@ int sas_unregister_ha(struct sas_ha_struct *sas_ha)
 	__sas_drain_work(sas_ha);
 	mutex_unlock(&sas_ha->drain_mutex);
 
+	destroy_workqueue(sas_ha->event_q);
+	destroy_workqueue(sas_ha->disc_q);
+	ida_simple_remove(&sas_ida, sas_ha->id);
 	return 0;
 }
 
@@ -561,7 +583,6 @@ sas_domain_attach_transport(struct sas_domain_function_template *dft)
 EXPORT_SYMBOL_GPL(sas_domain_attach_transport);
 
 /* ---------- SAS Class register/unregister ---------- */
-
 static int __init sas_class_init(void)
 {
 	sas_task_cache = KMEM_CACHE(sas_task, SLAB_HWCACHE_ALIGN);
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 33ce7e5..d5fcae8 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -100,6 +100,67 @@ void sas_free_device(struct kref *kref);
 extern const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS];
 extern const work_func_t sas_port_event_fns[PORT_NUM_EVENTS];
 
+static inline void sas_wait_discover_event_init(struct asd_sas_port *port)
+{
+	if (port) {
+		init_completion(&port->disc.completion);
+		port->disc.wait = 1;
+		port->disc.busy = 0;
+	}
+}
+
+static inline void sas_wait_for_discover_event_finish(
+		struct asd_sas_port *port)
+{
+	if (port && port->disc.busy > 0)
+		wait_for_completion(&port->disc.completion);
+}
+
+static inline void sas_wait_sas_event_init(struct asd_sas_port *port)
+{
+	if (port) {
+		init_completion(&port->completion);
+		kref_init(&port->ref);
+	}
+}
+
+static inline void sas_wait_for_sas_event_finish(
+		struct asd_sas_port *port)
+{
+	if (port && (kref_read(&port->ref) > 1))
+		wait_for_completion(&port->completion);
+}
+
+static inline void sas_busy_port(struct asd_sas_port *port)
+{
+	if (port)
+		kref_get(&port->ref);
+
+	if (port->disc.wait == 1)
+		port->disc.busy++;
+}
+
+static void sas_complete_event(struct kref *kref)
+{
+	struct asd_sas_port *port = container_of(kref, struct asd_sas_port, ref);
+
+	complete(&port->completion);
+}
+
+static inline void sas_unbusy_port(struct asd_sas_port *port)
+{
+	if (!port)
+		return;
+
+	kref_put(&port->ref, sas_complete_event);
+
+	if (port->disc.wait == 1) {
+		complete(&port->disc.completion);
+		port->disc.wait = 0;
+		port->disc.busy = 0;
+	}
+}
+
 #ifdef CONFIG_SCSI_SAS_HOST_SMP
 extern int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 				struct request *rsp);
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 9326628..459f852 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -191,7 +191,9 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	if (si->dft->lldd_port_formed)
 		si->dft->lldd_port_formed(phy);
 
+	sas_wait_sas_event_init(port);
 	sas_discover_event(phy->port, DISCE_DISCOVER_DOMAIN);
+	sas_wait_for_sas_event_finish(port);
 }
 
 /**
@@ -218,7 +220,9 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
 		dev->pathways--;
 
 	if (port->num_phys == 1) {
+		sas_wait_sas_event_init(port);
 		sas_unregister_domain_devices(port, gone);
+		sas_wait_for_sas_event_finish(port);
 		sas_port_delete(port->port);
 		port->port = NULL;
 	} else {
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index e6ebad0..be09491 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -240,6 +240,7 @@ static inline void INIT_SAS_WORK(struct sas_work *sw, void (*fn)(struct work_str
 struct sas_discovery_event {
 	struct sas_work work;
 	struct asd_sas_port *port;
+	enum discover_event	type;
 };
 
 static inline struct sas_discovery_event *to_sas_discovery_event(struct work_struct *work)
@@ -256,6 +257,9 @@ struct sas_discovery {
 	u8     eeds_a[8];
 	u8     eeds_b[8];
 	int    max_level;
+	int    wait;
+	int    busy;
+	struct completion completion;
 };
 
 /* The port struct is Class:RW, driver:RO */
@@ -273,6 +277,8 @@ struct asd_sas_port {
 
 	struct sas_work work;
 	int suspended;
+	struct kref ref;
+	struct completion completion;
 
 /* public: */
 	int id;
@@ -387,6 +393,7 @@ struct sas_ha_struct {
 	int		  eh_active;
 	wait_queue_head_t eh_wait_q;
 	struct list_head  eh_dev_q;
+	int       id; /* for create workqueue */
 
 	struct mutex disco_mutex;
 
@@ -396,6 +403,8 @@ struct sas_ha_struct {
 	char *sas_ha_name;
 	struct device *dev;	  /* should be set */
 	struct module *lldd_module; /* should be set */
+	struct workqueue_struct	*event_q;
+	struct workqueue_struct	*disc_q;
 
 	u8 *sas_addr;		  /* must be set */
 	u8 hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
-- 
2.5.0
