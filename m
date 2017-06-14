From: Yijing Wang <wangyijing@huawei.com>
Subject: [Resend][PATCH v2 1/2] libsas: Don't process sas events in static works
Date: Wed, 14 Jun 2017 15:36:40 +0800
Message-ID: <1497425801-19249-2-git-send-email-wangyijing@huawei.com>
References: <1497425801-19249-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:8286 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754451AbdFNHd7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2017 03:33:59 -0400
In-Reply-To: <1497425801-19249-1-git-send-email-wangyijing@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Yijing Wang <wangyijing@huawei.com>, Yousong He <heyousong@huawei.com>

Now libsas hotplug work is static, LLDD driver queue
the hotplug work into shost->work_q. If LLDD driver
burst post lots hotplug events to libsas, the hotplug
events may pending in the workqueue like

shost->work_q
new work[PORTE_BYTES_DMAED] --> |[PHYE_LOSS_OF_SIGNAL][PORTE_BYTES_DMAED] -> processing
                                |<-------wait worker to process-------->|
In this case, a new PORTE_BYTES_DMAED event coming, libsas try to queue it
to shost->work_q, but this work is already pending, so it would be lost.
Finally, libsas delete the related sas port and sas devices, but LLDD driver
expect libsas add the sas port and devices(last sas event).

This patch remove the static defined hotplug work, and use dynamic work to
avoid missing hotplug events.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Yousong He <heyousong@huawei.com>
Signed-off-by: Qilin Chen <chenqilin2@huawei.com>
---
 drivers/scsi/libsas/sas_event.c    | 88 +++++++++++++++++++++++++++-----------
 drivers/scsi/libsas/sas_init.c     |  6 ---
 drivers/scsi/libsas/sas_internal.h |  3 ++
 drivers/scsi/libsas/sas_phy.c      | 45 ++++---------------
 drivers/scsi/libsas/sas_port.c     | 18 ++++----
 include/scsi/libsas.h              | 10 +----
 6 files changed, 84 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index aadbd53..06c5c4b 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -27,6 +27,10 @@
 #include "sas_internal.h"
 #include "sas_dump.h"
 
+static const work_func_t sas_ha_event_fns[HA_NUM_EVENTS] = {
+	[HAE_RESET] = sas_hae_reset,
+};
+
 void sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
 {
 	if (!test_bit(SAS_HA_REGISTERED, &ha->state))
@@ -40,17 +44,14 @@ void sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
 		scsi_queue_work(ha->core.shost, &sw->work);
 }
 
-static void sas_queue_event(int event, unsigned long *pending,
-			    struct sas_work *work,
+static void sas_queue_event(int event, struct sas_work *work,
 			    struct sas_ha_struct *ha)
 {
-	if (!test_and_set_bit(event, pending)) {
-		unsigned long flags;
+	unsigned long flags;
 
-		spin_lock_irqsave(&ha->lock, flags);
-		sas_queue_work(ha, work);
-		spin_unlock_irqrestore(&ha->lock, flags);
-	}
+	spin_lock_irqsave(&ha->lock, flags);
+	sas_queue_work(ha, work);
+	spin_unlock_irqrestore(&ha->lock, flags);
 }
 
 
@@ -111,52 +112,87 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
 		if (!test_and_clear_bit(ev, &d->pending))
 			continue;
 
-		sas_queue_event(ev, &d->pending, &d->disc_work[ev].work, ha);
+		sas_queue_event(ev, &d->disc_work[ev].work, ha);
 	}
 	mutex_unlock(&ha->disco_mutex);
 }
 
+static void sas_ha_event_worker(struct work_struct *work)
+{
+	struct sas_ha_event *ev = to_sas_ha_event(work);
+
+	sas_ha_event_fns[ev->type](work);
+	kfree(ev);
+}
+
+static void sas_port_event_worker(struct work_struct *work)
+{
+	struct asd_sas_event *ev = to_asd_sas_event(work);
+
+	sas_port_event_fns[ev->type](work);
+	kfree(ev);
+}
+
+static void sas_phy_event_worker(struct work_struct *work)
+{
+	struct asd_sas_event *ev = to_asd_sas_event(work);
+
+	sas_phy_event_fns[ev->type](work);
+	kfree(ev);
+}
+
 static void notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event event)
 {
+	struct sas_ha_event *ev;
+
 	BUG_ON(event >= HA_NUM_EVENTS);
 
-	sas_queue_event(event, &sas_ha->pending,
-			&sas_ha->ha_events[event].work, sas_ha);
+	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
+	if (!ev)
+		return;
+
+	INIT_SAS_WORK(&ev->work, sas_ha_event_worker);
+	ev->ha = sas_ha;
+	ev->type = event;
+	sas_queue_event(event, &ev->work, sas_ha);
 }
 
 static void notify_port_event(struct asd_sas_phy *phy, enum port_event event)
 {
+	struct asd_sas_event *ev;
 	struct sas_ha_struct *ha = phy->ha;
 
 	BUG_ON(event >= PORT_NUM_EVENTS);
 
-	sas_queue_event(event, &phy->port_events_pending,
-			&phy->port_events[event].work, ha);
+	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
+	if (!ev)
+		return;
+
+	INIT_SAS_WORK(&ev->work, sas_port_event_worker);
+	ev->phy = phy;
+	ev->type = event;
+	sas_queue_event(event, &ev->work, ha);
 }
 
 void sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
 {
+	struct asd_sas_event *ev;
 	struct sas_ha_struct *ha = phy->ha;
 
 	BUG_ON(event >= PHY_NUM_EVENTS);
 
-	sas_queue_event(event, &phy->phy_events_pending,
-			&phy->phy_events[event].work, ha);
+	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
+	if (!ev)
+		return;
+
+	INIT_SAS_WORK(&ev->work, sas_phy_event_worker);
+	ev->phy = phy;
+	ev->type = event;
+	sas_queue_event(event, &ev->work, ha);
 }
 
 int sas_init_events(struct sas_ha_struct *sas_ha)
 {
-	static const work_func_t sas_ha_event_fns[HA_NUM_EVENTS] = {
-		[HAE_RESET] = sas_hae_reset,
-	};
-
-	int i;
-
-	for (i = 0; i < HA_NUM_EVENTS; i++) {
-		INIT_SAS_WORK(&sas_ha->ha_events[i].work, sas_ha_event_fns[i]);
-		sas_ha->ha_events[i].ha = sas_ha;
-	}
-
 	sas_ha->notify_ha_event = notify_ha_event;
 	sas_ha->notify_port_event = notify_port_event;
 	sas_ha->notify_phy_event = sas_notify_phy_event;
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
index b306b78..33ce7e5 100644
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
index cdee446c..7c4576d 100644
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
@@ -112,46 +104,18 @@ static void sas_phye_resume_timeout(struct work_struct *work)
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
-		int k;
 		struct asd_sas_phy *phy = sas_ha->sas_phy[i];
 
 		phy->error = 0;
 		INIT_LIST_HEAD(&phy->port_phy_el);
-		for (k = 0; k < PORT_NUM_EVENTS; k++) {
-			INIT_SAS_WORK(&phy->port_events[k].work, sas_port_event_fns[k]);
-			phy->port_events[k].phy = phy;
-		}
-
-		for (k = 0; k < PHY_NUM_EVENTS; k++) {
-			INIT_SAS_WORK(&phy->phy_events[k].work, sas_phy_event_fns[k]);
-			phy->phy_events[k].phy = phy;
-		}
 
 		phy->port = NULL;
 		phy->ha = sas_ha;
@@ -179,3 +143,12 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 
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
index dd0f72c..e6ebad0 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -300,6 +300,7 @@ struct asd_sas_port {
 struct asd_sas_event {
 	struct sas_work work;
 	struct asd_sas_phy *phy;
+	int type;
 };
 
 static inline struct asd_sas_event *to_asd_sas_event(struct work_struct *work)
@@ -314,11 +315,6 @@ static inline struct asd_sas_event *to_asd_sas_event(struct work_struct *work)
  */
 struct asd_sas_phy {
 /* private: */
-	struct asd_sas_event   port_events[PORT_NUM_EVENTS];
-	struct asd_sas_event   phy_events[PHY_NUM_EVENTS];
-
-	unsigned long port_events_pending;
-	unsigned long phy_events_pending;
 
 	int error;
 	int suspended;
@@ -365,6 +361,7 @@ struct scsi_core {
 struct sas_ha_event {
 	struct sas_work work;
 	struct sas_ha_struct *ha;
+	int type;
 };
 
 static inline struct sas_ha_event *to_sas_ha_event(struct work_struct *work)
@@ -383,9 +380,6 @@ enum sas_ha_state {
 
 struct sas_ha_struct {
 /* private: */
-	struct sas_ha_event ha_events[HA_NUM_EVENTS];
-	unsigned long	 pending;
-
 	struct list_head  defer_q; /* work queued while draining */
 	struct mutex	  drain_mutex;
 	unsigned long	  state;
-- 
2.5.0
