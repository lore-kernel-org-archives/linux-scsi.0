From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v3 1/7] libsas: Use static sas event pool to appease sas event lost
Date: Mon, 10 Jul 2017 15:06:03 +0800
Message-ID: <1499670369-44143-2-git-send-email-wangyijing@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Yijing Wang <wangyijing@huawei.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Now libsas hotplug work is static, every sas event type has its own
static work, LLDD driver queue the hotplug work into shost->work_q.
If LLDD driver burst post lots hotplug events to libsas, the hotplug
events may pending in the workqueue like

shost->work_q
new work[PORTE_BYTES_DMAED] --> |[PHYE_LOSS_OF_SIGNAL][PORTE_BYTES_DMAED] -> processing
                                |<-------wait worker to process-------->|
In this case, a new PORTE_BYTES_DMAED event coming, libsas try to queue it
to shost->work_q, but this work is already pending, so it would be lost.
Finally, libsas delete the related sas port and sas devices, but LLDD driver
expect libsas add the sas port and devices(last sas event).

This patch and use static sas event work pool to appease this issue, since
it's static work pool, it won't make memory exhaust.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_event.c    | 208 ++++++++++++++++++++++++++++++++-----
 drivers/scsi/libsas/sas_init.c     |   6 --
 drivers/scsi/libsas/sas_internal.h |   3 +
 drivers/scsi/libsas/sas_phy.c      |  48 +++------
 drivers/scsi/libsas/sas_port.c     |  18 ++--
 include/scsi/libsas.h              |  16 +--
 6 files changed, 216 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index c0d0d97..a1370bd 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -27,13 +27,20 @@
 #include "sas_internal.h"
 #include "sas_dump.h"
 
+static DEFINE_SPINLOCK(sas_event_lock);
+
+static const work_func_t sas_ha_event_fns[HA_NUM_EVENTS] = {
+	   [HAE_RESET] = sas_hae_reset,
+};
+
 int sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
 {
 	int rc = 0;
 
 	if (!test_bit(SAS_HA_REGISTERED, &ha->state))
-		return 0;
+		return rc;
 
+	rc = 1;
 	if (test_bit(SAS_HA_DRAINING, &ha->state)) {
 		/* add it to the defer list, if not already pending */
 		if (list_empty(&sw->drain_node))
@@ -44,19 +51,15 @@ int sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
 	return rc;
 }
 
-static int sas_queue_event(int event, unsigned long *pending,
-			    struct sas_work *work,
+static int sas_queue_event(int event, struct sas_work *work,
 			    struct sas_ha_struct *ha)
 {
 	int rc = 0;
+	unsigned long flags;
 
-	if (!test_and_set_bit(event, pending)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&ha->lock, flags);
-		rc = sas_queue_work(ha, work);
-		spin_unlock_irqrestore(&ha->lock, flags);
-	}
+	spin_lock_irqsave(&ha->lock, flags);
+	rc = sas_queue_work(ha, work);
+	spin_unlock_irqrestore(&ha->lock, flags);
 
 	return rc;
 }
@@ -64,6 +67,8 @@ static int sas_queue_event(int event, unsigned long *pending,
 
 void __sas_drain_work(struct sas_ha_struct *ha)
 {
+	int ret;
+	unsigned long flags;
 	struct workqueue_struct *wq = ha->core.shost->work_q;
 	struct sas_work *sw, *_sw;
 
@@ -78,7 +83,12 @@ void __sas_drain_work(struct sas_ha_struct *ha)
 	clear_bit(SAS_HA_DRAINING, &ha->state);
 	list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_node) {
 		list_del_init(&sw->drain_node);
-		sas_queue_work(ha, sw);
+		ret = sas_queue_work(ha, sw);
+		if (ret != 1) {
+			spin_lock_irqsave(&sas_event_lock, flags);
+			sw->used = false;
+			spin_unlock_irqrestore(&sas_event_lock, flags);
+		}
 	}
 	spin_unlock_irq(&ha->lock);
 }
@@ -119,51 +129,197 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
 		if (!test_and_clear_bit(ev, &d->pending))
 			continue;
 
-		sas_queue_event(ev, &d->pending, &d->disc_work[ev].work, ha);
+		sas_queue_event(ev, &d->disc_work[ev].work, ha);
 	}
 	mutex_unlock(&ha->disco_mutex);
 }
 
+static void sas_free_ha_event(struct sas_ha_event *event)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&sas_event_lock, flags);
+	event->work.used = false;
+	spin_unlock_irqrestore(&sas_event_lock, flags);
+}
+
+static void sas_free_port_event(struct asd_sas_event *event)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&sas_event_lock, flags);
+	event->work.used = false;
+	spin_unlock_irqrestore(&sas_event_lock, flags);
+}
+
+static void sas_free_phy_event(struct asd_sas_event *event)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&sas_event_lock, flags);
+	event->work.used = false;
+	spin_unlock_irqrestore(&sas_event_lock, flags);
+}
+
+static void sas_ha_event_worker(struct work_struct *work)
+{
+	struct sas_ha_event *ev = to_sas_ha_event(work);
+
+	sas_ha_event_fns[ev->type](work);
+	sas_free_ha_event(ev);
+}
+
+static void sas_port_event_worker(struct work_struct *work)
+{
+	struct asd_sas_event *ev = to_asd_sas_event(work);
+
+	sas_port_event_fns[ev->type](work);
+	sas_free_port_event(ev);
+}
+
+static void sas_phy_event_worker(struct work_struct *work)
+{
+	struct asd_sas_event *ev = to_asd_sas_event(work);
+
+	sas_phy_event_fns[ev->type](work);
+	sas_free_phy_event(ev);
+}
+
+static struct sas_ha_event *sas_alloc_ha_event(struct sas_ha_struct *sas_ha)
+{
+	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sas_event_lock, flags);
+	for (i = 0; i < HA_NUM_EVENTS; i++)
+		if (!sas_ha->ha_events[i].work.used)
+			break;
+
+	if (i == HA_NUM_EVENTS) {
+		spin_unlock_irqrestore(&sas_event_lock, flags);
+		return NULL;
+	}
+
+	sas_ha->ha_events[i].work.used = true;
+	spin_unlock_irqrestore(&sas_event_lock, flags);
+	return &sas_ha->ha_events[i];
+}
+
 static int notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event event)
 {
+	int ret;
+	struct sas_ha_event *ev;
+
 	BUG_ON(event >= HA_NUM_EVENTS);
 
-	return sas_queue_event(event, &sas_ha->pending,
-			       &sas_ha->ha_events[event].work, sas_ha);
+	ev = sas_alloc_ha_event(sas_ha);
+	if (!ev) {
+		pr_err("%s: alloc sas ha event fail!\n", __func__);
+		return 0;
+	}
+
+	INIT_SAS_WORK(&ev->work, sas_ha_event_worker);
+	ev->ha = sas_ha;
+	ev->type = event;
+	ret = sas_queue_event(event, &ev->work, sas_ha);
+	if (ret != 1)
+		sas_free_ha_event(ev);
+
+	return ret;
+}
+
+struct asd_sas_event *sas_alloc_port_event(struct asd_sas_phy *phy)
+{
+	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sas_event_lock, flags);
+	for (i = 0; i < PORT_POOL_SIZE; i++)
+	{
+		if (!phy->port_events[i].work.used)
+			break;
+	}
+
+	if (i == PORT_POOL_SIZE) {
+		spin_unlock_irqrestore(&sas_event_lock, flags);
+		return NULL;
+	}
+
+	phy->port_events[i].work.used = true;
+	spin_unlock_irqrestore(&sas_event_lock, flags);
+	return &phy->port_events[i];
 }
 
 static int notify_port_event(struct asd_sas_phy *phy, enum port_event event)
 {
+	int ret;
+	struct asd_sas_event *ev;
 	struct sas_ha_struct *ha = phy->ha;
 
 	BUG_ON(event >= PORT_NUM_EVENTS);
 
-	return sas_queue_event(event, &phy->port_events_pending,
-			       &phy->port_events[event].work, ha);
+	ev = sas_alloc_port_event(phy);
+	if (!ev) {
+		pr_err("%s: alloc sas port event fail!\n", __func__);
+		return 0;
+	}
+
+	INIT_SAS_WORK(&ev->work, sas_port_event_worker);
+	ev->phy = phy;
+	ev->type = event;
+	ret = sas_queue_event(event, &ev->work, ha);
+	if (ret != 1)
+		sas_free_port_event(ev);
+
+	return ret;
 }
 
+struct asd_sas_event *sas_alloc_phy_event(struct asd_sas_phy *phy)
+{
+	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sas_event_lock, flags);
+	for (i = 0; i < PHY_POOL_SIZE; i++)
+		if (!phy->phy_events[i].work.used)
+			break;
+
+	if (i == PHY_POOL_SIZE) {
+		spin_unlock_irqrestore(&sas_event_lock, flags);
+		return NULL;
+	}
+
+	phy->phy_events[i].work.used = true;
+	spin_unlock_irqrestore(&sas_event_lock, flags);
+	return &phy->phy_events[i];
+}
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
 {
+	int ret;
+	struct asd_sas_event *ev;
 	struct sas_ha_struct *ha = phy->ha;
 
 	BUG_ON(event >= PHY_NUM_EVENTS);
 
-	return sas_queue_event(event, &phy->phy_events_pending,
-			       &phy->phy_events[event].work, ha);
+	ev = sas_alloc_phy_event(phy);
+	if (!ev) {
+		pr_err("%s: alloc sas phy event fail!\n", __func__);
+		return 0;
+	}
+
+	INIT_SAS_WORK(&ev->work, sas_phy_event_worker);
+	ev->phy = phy;
+	ev->type = event;
+	ret = sas_queue_event(event, &ev->work, ha);
+	if (ret != 1)
+		sas_free_phy_event(ev);
+
+	return ret;
 }
 
 int sas_init_events(struct sas_ha_struct *sas_ha)
 {
-	static const work_func_t sas_ha_event_fns[HA_NUM_EVENTS] = {
-		[HAE_RESET] = sas_hae_reset,
-	};
-
 	int i;
 
-	for (i = 0; i < HA_NUM_EVENTS; i++) {
-		INIT_SAS_WORK(&sas_ha->ha_events[i].work, sas_ha_event_fns[i]);
-		sas_ha->ha_events[i].ha = sas_ha;
-	}
+	for (i = 0; i < HA_NUM_EVENTS; i++)
+		sas_ha->ha_events[i].work.used = false;
 
 	sas_ha->notify_ha_event = notify_ha_event;
 	sas_ha->notify_port_event = notify_port_event;
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 64e9cdd..c227a8b 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -111,10 +111,6 @@ void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
 
 void sas_hae_reset(struct work_struct *work)
 {
-	struct sas_ha_event *ev = to_sas_ha_event(work);
-	struct sas_ha_struct *ha = ev->ha;
-
-	clear_bit(HAE_RESET, &ha->pending);
 }
 
 int sas_register_ha(struct sas_ha_struct *sas_ha)
@@ -375,8 +371,6 @@ void sas_prep_resume_ha(struct sas_ha_struct *ha)
 		struct asd_sas_phy *phy = ha->sas_phy[i];
 
 		memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
-		phy->port_events_pending = 0;
-		phy->phy_events_pending = 0;
 		phy->frame_rcvd_size = 0;
 	}
 }
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index a216c95..f03ce64 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -97,6 +97,9 @@ void sas_hae_reset(struct work_struct *work);
 
 void sas_free_device(struct kref *kref);
 
+extern const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS];
+extern const work_func_t sas_port_event_fns[PORT_NUM_EVENTS];
+
 #ifdef CONFIG_SCSI_SAS_HOST_SMP
 extern int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 				struct request *rsp);
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index cdee446c..07766ad 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -35,7 +35,6 @@ static void sas_phye_loss_of_signal(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	clear_bit(PHYE_LOSS_OF_SIGNAL, &phy->phy_events_pending);
 	phy->error = 0;
 	sas_deform_port(phy, 1);
 }
@@ -45,7 +44,6 @@ static void sas_phye_oob_done(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	clear_bit(PHYE_OOB_DONE, &phy->phy_events_pending);
 	phy->error = 0;
 }
 
@@ -58,8 +56,6 @@ static void sas_phye_oob_error(struct work_struct *work)
 	struct sas_internal *i =
 		to_sas_internal(sas_ha->core.shost->transportt);
 
-	clear_bit(PHYE_OOB_ERROR, &phy->phy_events_pending);
-
 	sas_deform_port(phy, 1);
 
 	if (!port && phy->enabled && i->dft->lldd_control_phy) {
@@ -88,8 +84,6 @@ static void sas_phye_spinup_hold(struct work_struct *work)
 	struct sas_internal *i =
 		to_sas_internal(sas_ha->core.shost->transportt);
 
-	clear_bit(PHYE_SPINUP_HOLD, &phy->phy_events_pending);
-
 	phy->error = 0;
 	i->dft->lldd_control_phy(phy, PHY_FUNC_RELEASE_SPINUP_HOLD, NULL);
 }
@@ -99,8 +93,6 @@ static void sas_phye_resume_timeout(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	clear_bit(PHYE_RESUME_TIMEOUT, &phy->phy_events_pending);
-
 	/* phew, lldd got the phy back in the nick of time */
 	if (!phy->suspended) {
 		dev_info(&phy->phy->dev, "resume timeout cancelled\n");
@@ -112,30 +104,12 @@ static void sas_phye_resume_timeout(struct work_struct *work)
 	sas_deform_port(phy, 1);
 }
 
-
 /* ---------- Phy class registration ---------- */
 
 int sas_register_phys(struct sas_ha_struct *sas_ha)
 {
 	int i;
 
-	static const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS] = {
-		[PHYE_LOSS_OF_SIGNAL] = sas_phye_loss_of_signal,
-		[PHYE_OOB_DONE] = sas_phye_oob_done,
-		[PHYE_OOB_ERROR] = sas_phye_oob_error,
-		[PHYE_SPINUP_HOLD] = sas_phye_spinup_hold,
-		[PHYE_RESUME_TIMEOUT] = sas_phye_resume_timeout,
-
-	};
-
-	static const work_func_t sas_port_event_fns[PORT_NUM_EVENTS] = {
-		[PORTE_BYTES_DMAED] = sas_porte_bytes_dmaed,
-		[PORTE_BROADCAST_RCVD] = sas_porte_broadcast_rcvd,
-		[PORTE_LINK_RESET_ERR] = sas_porte_link_reset_err,
-		[PORTE_TIMER_EVENT] = sas_porte_timer_event,
-		[PORTE_HARD_RESET] = sas_porte_hard_reset,
-	};
-
 	/* Now register the phys. */
 	for (i = 0; i < sas_ha->num_phys; i++) {
 		int k;
@@ -143,15 +117,12 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 
 		phy->error = 0;
 		INIT_LIST_HEAD(&phy->port_phy_el);
-		for (k = 0; k < PORT_NUM_EVENTS; k++) {
-			INIT_SAS_WORK(&phy->port_events[k].work, sas_port_event_fns[k]);
-			phy->port_events[k].phy = phy;
-		}
 
-		for (k = 0; k < PHY_NUM_EVENTS; k++) {
-			INIT_SAS_WORK(&phy->phy_events[k].work, sas_phy_event_fns[k]);
-			phy->phy_events[k].phy = phy;
-		}
+		for (k = 0; k < PORT_POOL_SIZE; k++)
+			phy->port_events[k].work.used = false;
+
+		for (k = 0; k < PHY_POOL_SIZE; k++)
+			phy->phy_events[k].work.used = false;
 
 		phy->port = NULL;
 		phy->ha = sas_ha;
@@ -179,3 +150,12 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 
 	return 0;
 }
+
+const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS] = {
+	[PHYE_LOSS_OF_SIGNAL] = sas_phye_loss_of_signal,
+	[PHYE_OOB_DONE] = sas_phye_oob_done,
+	[PHYE_OOB_ERROR] = sas_phye_oob_error,
+	[PHYE_SPINUP_HOLD] = sas_phye_spinup_hold,
+	[PHYE_RESUME_TIMEOUT] = sas_phye_resume_timeout,
+
+};
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index d3c5297..9326628 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -261,8 +261,6 @@ void sas_porte_bytes_dmaed(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	clear_bit(PORTE_BYTES_DMAED, &phy->port_events_pending);
-
 	sas_form_port(phy);
 }
 
@@ -273,8 +271,6 @@ void sas_porte_broadcast_rcvd(struct work_struct *work)
 	unsigned long flags;
 	u32 prim;
 
-	clear_bit(PORTE_BROADCAST_RCVD, &phy->port_events_pending);
-
 	spin_lock_irqsave(&phy->sas_prim_lock, flags);
 	prim = phy->sas_prim;
 	spin_unlock_irqrestore(&phy->sas_prim_lock, flags);
@@ -288,8 +284,6 @@ void sas_porte_link_reset_err(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	clear_bit(PORTE_LINK_RESET_ERR, &phy->port_events_pending);
-
 	sas_deform_port(phy, 1);
 }
 
@@ -298,8 +292,6 @@ void sas_porte_timer_event(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	clear_bit(PORTE_TIMER_EVENT, &phy->port_events_pending);
-
 	sas_deform_port(phy, 1);
 }
 
@@ -308,8 +300,6 @@ void sas_porte_hard_reset(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	clear_bit(PORTE_HARD_RESET, &phy->port_events_pending);
-
 	sas_deform_port(phy, 1);
 }
 
@@ -353,3 +343,11 @@ void sas_unregister_ports(struct sas_ha_struct *sas_ha)
 			sas_deform_port(sas_ha->sas_phy[i], 0);
 
 }
+
+const work_func_t sas_port_event_fns[PORT_NUM_EVENTS] = {
+	[PORTE_BYTES_DMAED] = sas_porte_bytes_dmaed,
+	[PORTE_BROADCAST_RCVD] = sas_porte_broadcast_rcvd,
+	[PORTE_LINK_RESET_ERR] = sas_porte_link_reset_err,
+	[PORTE_TIMER_EVENT] = sas_porte_timer_event,
+	[PORTE_HARD_RESET] = sas_porte_hard_reset,
+};
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index cfaeed2..c41328d 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -229,6 +229,8 @@ struct domain_device {
 struct sas_work {
 	struct list_head drain_node;
 	struct work_struct work;
+	struct list_head list;
+	bool used;
 };
 
 static inline void INIT_SAS_WORK(struct sas_work *sw, void (*fn)(struct work_struct *))
@@ -300,6 +302,7 @@ struct asd_sas_port {
 struct asd_sas_event {
 	struct sas_work work;
 	struct asd_sas_phy *phy;
+	int type;
 };
 
 static inline struct asd_sas_event *to_asd_sas_event(struct work_struct *work)
@@ -309,16 +312,16 @@ static inline struct asd_sas_event *to_asd_sas_event(struct work_struct *work)
 	return ev;
 }
 
+#define	PORT_POOL_SIZE	(PORT_NUM_EVENTS * 5)
+#define	PHY_POOL_SIZE	(PHY_NUM_EVENTS * 5)
+
 /* The phy pretty much is controlled by the LLDD.
  * The class only reads those fields.
  */
 struct asd_sas_phy {
 /* private: */
-	struct asd_sas_event   port_events[PORT_NUM_EVENTS];
-	struct asd_sas_event   phy_events[PHY_NUM_EVENTS];
-
-	unsigned long port_events_pending;
-	unsigned long phy_events_pending;
+	struct asd_sas_event   port_events[PORT_POOL_SIZE];
+	struct asd_sas_event   phy_events[PHY_POOL_SIZE];
 
 	int error;
 	int suspended;
@@ -365,6 +368,7 @@ struct scsi_core {
 struct sas_ha_event {
 	struct sas_work work;
 	struct sas_ha_struct *ha;
+	int type;
 };
 
 static inline struct sas_ha_event *to_sas_ha_event(struct work_struct *work)
@@ -384,8 +388,6 @@ enum sas_ha_state {
 struct sas_ha_struct {
 /* private: */
 	struct sas_ha_event ha_events[HA_NUM_EVENTS];
-	unsigned long	 pending;
-
 	struct list_head  defer_q; /* work queued while draining */
 	struct mutex	  drain_mutex;
 	unsigned long	  state;
-- 
2.5.0
