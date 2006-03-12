From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] aic94xx: remove event thread
Date: Sun, 12 Mar 2006 10:29:30 -0600
Message-ID: <1142180971.3297.22.camel@mulgrave.il.steeleye.com>
References: <1142179567.3297.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:20437 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751469AbWCLQ3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Mar 2006 11:29:33 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k2CGTV211274
	for <linux-scsi@vger.kernel.org>; Sun, 12 Mar 2006 11:29:32 -0500
In-Reply-To: <1142179567.3297.13.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2006-03-12 at 10:06 -0600, James Bottomley wrote:
> This patch moves the discovery and event processing entirely over to
> being workqueue based.  Additionally, it tries to ensure discovery gets
> time to proceed before finishing the module load.  There's still a
> non-determinism in there since it starts with a port interrupt for a
> connected phy after phys are enabled, so there's a ssleep(1) in there to
> capture this before the scsi_flush_work() waits for it to complete.

Er, OK, this time with the actual correct patch.

James

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 924075d..161106e 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi_host.h>
 
@@ -632,6 +633,11 @@ static int __devinit asd_pci_probe(struc
 		goto Err_en_phys;
 	}
 	ASD_DPRINTK("enabled phys\n");
+	/* give the phy enabling interrupt event time to come in (1s
+	 * is empirically about all it takes) */
+	ssleep(1);
+	/* Wait for discovery to finish */
+	scsi_flush_work(asd_ha->sas_ha.core.shost);
 
 	return 0;
 Err_en_phys:
diff --git a/drivers/scsi/sas/sas_discover.c b/drivers/scsi/sas/sas_discover.c
index 05ff2ed..c10b453 100644
--- a/drivers/scsi/sas/sas_discover.c
+++ b/drivers/scsi/sas/sas_discover.c
@@ -567,9 +567,13 @@ void sas_unregister_dev(struct domain_de
 	sas_rphy_delete(dev->rphy);
 }
 
-static void sas_unregister_domain_devices(struct sas_port *port)
+static void sas_unregister_domain_devices(void *data)
 {
 	struct domain_device *dev, *n;
+	struct sas_port *port = data;
+
+	sas_begin_event(DISCE_PORT_GONE, &port->disc.disc_event_lock,
+			&port->disc.pending);
 
 	list_for_each_entry_reverse_safe(dev,n,&port->dev_list,dev_list_node)
 		sas_unregister_dev(dev);
@@ -586,16 +590,20 @@ static void sas_unregister_domain_device
  * Discover process only interrogates devices in order to discover the
  * domain.
  */
-static int sas_discover_domain(struct sas_port *port)
+static void sas_discover_domain(void *data)
 {
 	int error = 0;
+	struct sas_port *port = data;
+
+	sas_begin_event(DISCE_DISCOVER_DOMAIN, &port->disc.disc_event_lock,
+			&port->disc.pending);
 
 	if (port->port_dev)
-		return 0;
+		return ;
 	else {
 		error = sas_get_port_device(port);
 		if (error)
-			return error;
+			return;
 	}
 
 	SAS_DPRINTK("DOING DISCOVERY on port %d, pid:%d\n", port->id,
@@ -625,13 +633,15 @@ static int sas_discover_domain(struct sa
 
 	SAS_DPRINTK("DONE DISCOVERY on port %d, pid:%d, result:%d\n", port->id,
 		    current->pid, error);
-
-	return error;
 }
 
-static int sas_revalidate_domain(struct sas_port *port)
+static void sas_revalidate_domain(void *data)
 {
 	int res = 0;
+	struct sas_port *port = data;
+
+	sas_begin_event(DISCE_REVALIDATE_DOMAIN, &port->disc.disc_event_lock,
+			&port->disc.pending);
 
 	SAS_DPRINTK("REVALIDATING DOMAIN on port %d, pid:%d\n", port->id,
 		    current->pid);
@@ -640,81 +650,20 @@ static int sas_revalidate_domain(struct 
 
 	SAS_DPRINTK("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
 		    port->id, current->pid, res);
-	return res;
 }
 
-/* ---------- Threads and events ---------- */
-
-static void sas_discover_work_fn(void *_sas_port)
-{
-	struct sas_port *port = _sas_port;
-	struct sas_discovery *disc = &port->disc;
-
-	spin_lock(&disc->disc_event_lock);
-	disc->disc_thread = 1;
-	while (!disc->disc_thread_quit && !list_empty(&disc->disc_event_list)){
-		struct list_head *head = disc->disc_event_list.next;
-		enum discover_event disc_ev = container_of(head,
-							   struct sas_event,
-							   el)->event;
-		list_del_init(head);
-		spin_unlock(&disc->disc_event_lock);
-
-		switch (disc_ev) {
-		case DISCE_DISCOVER_DOMAIN:
-			sas_discover_domain(port);
-			break;
-		case DISCE_REVALIDATE_DOMAIN:
-			sas_revalidate_domain(port);
-			break;
-		case DISCE_PORT_GONE:
-			sas_unregister_domain_devices(port);
-			complete(&port->port_gone_completion);
-			break;
-		}
-		spin_lock(&disc->disc_event_lock);
-	}
-	INIT_LIST_HEAD(&disc->disc_event_list);
-	disc->disc_thread = 0;
-	spin_unlock(&disc->disc_event_lock);
-	up(&disc->disc_sema);
-}
+/* ---------- Events ---------- */
 
 int sas_discover_event(struct sas_port *port, enum discover_event ev)
 {
 	struct sas_discovery *disc = &port->disc;
 
-	spin_lock(&disc->disc_event_lock);
-	list_move_tail(&disc->disc_events[ev].el,
-		       &disc->disc_event_list);
-	if (disc->disc_thread) {
-		spin_unlock(&disc->disc_event_lock);
-		return 0;
-	}
-	down_interruptible(&disc->disc_sema);
-	disc->disc_thread_quit = 0;
-	spin_unlock(&disc->disc_event_lock);
-
-	/* The event thread (caller) is single threaded so this is safe. */
-	INIT_WORK(&port->work, sas_discover_work_fn, port);
-	scsi_queue_work(port->ha->core.shost, &port->work);
+	BUG_ON(ev >= DISC_NUM_EVENTS);
 
-	return 0;
-}
-
-void sas_kill_disc_thread(struct sas_port *port)
-{
-	struct sas_discovery *disc = &port->disc;
+	sas_queue_event(ev, &disc->disc_event_lock, &disc->pending,
+			&disc->disc_work[ev], port->ha->core.shost);
 
-	spin_lock(&disc->disc_event_lock);
-	disc->disc_thread_quit = 1;
-	if (disc->disc_thread) {
-		spin_unlock(&disc->disc_event_lock);
-		scsi_flush_work(port->ha->core.shost);
-		down_interruptible(&disc->disc_sema);
-		return;
-	}
-	spin_unlock(&disc->disc_event_lock);
+	return 0;
 }
 
 /**
@@ -727,17 +676,16 @@ void sas_init_disc(struct sas_discovery 
 {
 	int i;
 
+	static void (*sas_event_fns[DISC_NUM_EVENTS])(void *) = {
+		[DISCE_DISCOVER_DOMAIN] = sas_discover_domain,
+		[DISCE_REVALIDATE_DOMAIN] = sas_revalidate_domain,
+		[DISCE_PORT_GONE] = sas_unregister_domain_devices,
+	};
+
 	spin_lock_init(&disc->disc_event_lock);
-	INIT_LIST_HEAD(&disc->disc_event_list);
-	init_MUTEX(&disc->disc_sema);
-	disc->disc_thread = 0;
-	disc->disc_thread_quit = 0;
-
-	for (i = 0; i < DISC_NUM_EVENTS; i++) {
-		struct sas_event *ev = &disc->disc_events[i];
-		ev->event = i;
-		INIT_LIST_HEAD(&ev->el);
-	}
+	disc->pending = 0;
+	for (i = 0; i < DISC_NUM_EVENTS; i++)
+		INIT_WORK(&disc->disc_work[i], sas_event_fns[i], port);
 }
 
 void sas_unregister_devices(struct sas_ha_struct *sas_ha)
diff --git a/drivers/scsi/sas/sas_event.c b/drivers/scsi/sas/sas_event.c
index f06f4a3..587368b 100644
--- a/drivers/scsi/sas/sas_event.c
+++ b/drivers/scsi/sas/sas_event.c
@@ -68,227 +68,50 @@
 #include "sas_dump.h"
 #include <scsi/sas/sas_discover.h>
 
-static void sas_process_phy_event(struct asd_sas_phy *phy)
-{
-	unsigned long flags;
-	struct sas_ha_struct *sas_ha = phy->ha;
-	enum phy_event phy_event;
-
-	spin_lock_irqsave(&sas_ha->event_lock, flags);
-	while (!list_empty(&phy->phy_event_list)) {
-		struct list_head *head = phy->phy_event_list.next;
-		phy_event = container_of(head, struct sas_event, el)->event;
-		list_del_init(head);
-		spin_unlock_irqrestore(&sas_ha->event_lock, flags);
-
-		sas_dprint_phye(phy->id, phy_event);
-
-		switch(phy_event) {
-		case PHYE_LOSS_OF_SIGNAL:
-			sas_phye_loss_of_signal(phy);
-			break;
-		case PHYE_OOB_DONE:
-			sas_phye_oob_done(phy);
-			break;
-		case PHYE_OOB_ERROR:
-			sas_phye_oob_error(phy);
-			break;
-		case PHYE_SPINUP_HOLD:
-			sas_phye_spinup_hold(phy);
-			break;
-		}
-		spin_lock_irqsave(&sas_ha->event_lock, flags);
-	}
-	/* Clear the bit in case we received events in due time. */
-	sas_ha->phye_mask &= ~(1 << phy->id);
-	spin_unlock_irqrestore(&sas_ha->event_lock, flags);
-}
-
-static void sas_process_port_event(struct asd_sas_phy *phy)
-{
-	unsigned long flags;
-	struct sas_ha_struct *sas_ha = phy->ha;
-	enum port_event port_event;
-
-	spin_lock_irqsave(&sas_ha->event_lock, flags);
-	while (!list_empty(&phy->port_event_list)) {
-		struct list_head *head = phy->port_event_list.next;
-		port_event = container_of(head, struct sas_event, el)->event;
-		list_del_init(head);
-		spin_unlock_irqrestore(&sas_ha->event_lock, flags);
-
-		sas_dprint_porte(phy->id, port_event);
-
-		switch (port_event) {
-		case PORTE_BYTES_DMAED:
-			sas_porte_bytes_dmaed(phy);
-			break;
-		case PORTE_BROADCAST_RCVD:
-			sas_porte_broadcast_rcvd(phy);
-			break;
-		case PORTE_LINK_RESET_ERR:
-			sas_porte_link_reset_err(phy);
-			break;
-		case PORTE_TIMER_EVENT:
-			sas_porte_timer_event(phy);
-			break;
-		case PORTE_HARD_RESET:
-			sas_porte_hard_reset(phy);
-			break;
-		}
-		spin_lock_irqsave(&sas_ha->event_lock, flags);
-	}
-	/* Clear the bit in case we received events in due time. */
-	sas_ha->porte_mask &= ~(1 << phy->id);
-	spin_unlock_irqrestore(&sas_ha->event_lock, flags);
-}
-
-static void sas_process_ha_event(struct sas_ha_struct *sas_ha)
-{
-	unsigned long flags;
-	enum ha_event ha_event;
-
-	spin_lock_irqsave(&sas_ha->event_lock, flags);
-	while (!list_empty(&sas_ha->ha_event_list)) {
-		struct list_head *head = sas_ha->ha_event_list.next;
-		ha_event = container_of(head, struct sas_event, el)->event;
-		list_del_init(head);
-		spin_unlock_irqrestore(&sas_ha->event_lock, flags);
-
-		sas_dprint_hae(sas_ha, ha_event);
-
-		switch (ha_event) {
-		case HAE_RESET:
-			sas_hae_reset(sas_ha);
-			break;
-		}
-		spin_lock_irqsave(&sas_ha->event_lock, flags);
-	}
-	spin_unlock_irqrestore(&sas_ha->event_lock, flags);
-}
-
-static void sas_process_events(struct sas_ha_struct *sas_ha)
-{
-	unsigned long flags;
-	u32 porte_mask, phye_mask;
-	int p;
-
-	spin_lock_irqsave(&sas_ha->event_lock, flags);
-	phye_mask = sas_ha->phye_mask;
-	sas_ha->phye_mask = 0;
-	spin_unlock_irqrestore(&sas_ha->event_lock, flags);
-
-	for (p = 0; phye_mask != 0; phye_mask >>= 1, p++)
-		if (phye_mask & 01)
-			sas_process_phy_event(sas_ha->sas_phy[p]);
-
-	spin_lock_irqsave(&sas_ha->event_lock, flags);
-	porte_mask = sas_ha->porte_mask;
-	sas_ha->porte_mask = 0;
-	spin_unlock_irqrestore(&sas_ha->event_lock, flags);
-
-	for (p = 0; porte_mask != 0; porte_mask >>= 1, p++)
-		if (porte_mask & 01)
-			sas_process_port_event(sas_ha->sas_phy[p]);
-
-	sas_process_ha_event(sas_ha);
-}
-
 static void notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event event)
 {
-	unsigned long flags;
+	BUG_ON(event >= HA_NUM_EVENTS);
 
-	spin_lock_irqsave(&sas_ha->event_lock, flags);
-	list_move_tail(&sas_ha->ha_events[event].el, &sas_ha->ha_event_list);
-	up(&sas_ha->event_sema);
-	spin_unlock_irqrestore(&sas_ha->event_lock, flags);
+	sas_queue_event(event, &sas_ha->event_lock, &sas_ha->pending,
+			&sas_ha->ha_events[event], sas_ha->core.shost);
 }
 
 static void notify_port_event(struct asd_sas_phy *phy, enum port_event event)
 {
 	struct sas_ha_struct *ha = phy->ha;
-	unsigned long flags;
 
-	spin_lock_irqsave(&ha->event_lock, flags);
-	list_move_tail(&phy->port_events[event].el, &phy->port_event_list);
-	ha->porte_mask |= (1 << phy->id);
-	up(&ha->event_sema);
-	spin_unlock_irqrestore(&ha->event_lock, flags);
+	BUG_ON(event >= PORT_NUM_EVENTS);
+
+	sas_queue_event(event, &ha->event_lock, &phy->port_events_pending,
+			&phy->port_events[event], ha->core.shost);
 }
 
 static void notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
 {
 	struct sas_ha_struct *ha = phy->ha;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ha->event_lock, flags);
-	list_move_tail(&phy->phy_events[event].el, &phy->phy_event_list);
-	ha->phye_mask |= (1 << phy->id);
-	up(&ha->event_sema);
-	spin_unlock_irqrestore(&ha->event_lock, flags);
-}
 
-static DECLARE_COMPLETION(event_th_comp);
+	BUG_ON(event >= PHY_NUM_EVENTS);
 
-static int sas_event_thread(void *_sas_ha)
-{
-	struct sas_ha_struct *sas_ha = _sas_ha;
-
-	daemonize("sas_event_%d", sas_ha->core.shost->host_no);
-	current->flags |= PF_NOFREEZE;
-
-	complete(&event_th_comp);
-
-	while (1) {
-		down_interruptible(&sas_ha->event_sema);
-		if (sas_ha->event_thread_kill)
-			break;
-		sas_process_events(sas_ha);
-	}
-
-	complete(&event_th_comp);
-
-	return 0;
+	sas_queue_event(event, &ha->event_lock, &phy->phy_events_pending,
+			&phy->phy_events[event], ha->core.shost);
 }
 
-int sas_start_event_thread(struct sas_ha_struct *sas_ha)
+int sas_init_events(struct sas_ha_struct *sas_ha)
 {
-	int i;
+	static void (*sas_ha_event_fns[HA_NUM_EVENTS])(void *) = {
+		[HAE_RESET] = sas_hae_reset,
+	};
 
-	init_MUTEX_LOCKED(&sas_ha->event_sema);
-	sas_ha->event_thread_kill = 0;
+	int i;
 
 	spin_lock_init(&sas_ha->event_lock);
-	INIT_LIST_HEAD(&sas_ha->ha_event_list);
-	sas_ha->porte_mask = 0;
-	sas_ha->phye_mask = 0;
-
-	for (i = 0; i < HA_NUM_EVENTS; i++) {
-		struct sas_event *ev = &sas_ha->ha_events[i];
-		ev->event = i;
-		INIT_LIST_HEAD(&ev->el);
-	}
+
+	for (i = 0; i < HA_NUM_EVENTS; i++)
+		INIT_WORK(&sas_ha->ha_events[i], sas_ha_event_fns[i], sas_ha);
 
 	sas_ha->notify_ha_event = notify_ha_event;
 	sas_ha->notify_port_event = notify_port_event;
 	sas_ha->notify_phy_event = notify_phy_event;
 
-	i = kernel_thread(sas_event_thread, sas_ha, 0);
-	if (i >= 0)
-		wait_for_completion(&event_th_comp);
-
-	return i < 0 ? i : 0;
-}
-
-void sas_kill_event_thread(struct sas_ha_struct *sas_ha)
-{
-	int i;
-
-	init_completion(&event_th_comp);
-	sas_ha->event_thread_kill = 1;
-	up(&sas_ha->event_sema);
-	wait_for_completion(&event_th_comp);
-
-	for (i = 0; i < sas_ha->num_phys; i++)
-		sas_kill_disc_thread(sas_ha->sas_port[i]);
+	return 0;
 }
diff --git a/drivers/scsi/sas/sas_init.c b/drivers/scsi/sas/sas_init.c
index 4f89cf5..39d4f99 100644
--- a/drivers/scsi/sas/sas_init.c
+++ b/drivers/scsi/sas/sas_init.c
@@ -40,9 +40,12 @@ kmem_cache_t *sas_task_cache;
 
 /* ---------- HA events ---------- */
 
-void sas_hae_reset(struct sas_ha_struct *sas_ha)
+void sas_hae_reset(void *data)
 {
-	;
+	struct sas_ha_struct *ha = data;
+
+	sas_begin_event(HAE_RESET, &ha->event_lock,
+			&ha->pending);
 }
 
 int sas_register_ha(struct sas_ha_struct *sas_ha,
@@ -77,7 +80,7 @@ int sas_register_ha(struct sas_ha_struct
 		goto Undo_phys;
 	}
 
-	error = sas_start_event_thread(sas_ha);
+	error = sas_init_events(sas_ha);
 	if (error) {
 		printk(KERN_NOTICE "couldn't start event thread:%d\n", error);
 		goto Undo_ports;
@@ -92,8 +95,6 @@ int sas_register_ha(struct sas_ha_struct
 		}
 	}
 
-	/* wait for discovery to finish */
-	scsi_flush_work(sas_ha->core.shost);
 	return 0;
 
 Undo_ports:
@@ -113,8 +114,6 @@ int sas_unregister_ha(struct sas_ha_stru
 		sas_shutdown_queue(sas_ha);
 	}
 
-	sas_kill_event_thread(sas_ha);
-
 	sas_unregister_ports(sas_ha);
 
 	sas_unregister_scsi_host(sas_ha);
diff --git a/drivers/scsi/sas/sas_internal.h b/drivers/scsi/sas/sas_internal.h
index bc9c1cb..90d772e 100644
--- a/drivers/scsi/sas/sas_internal.h
+++ b/drivers/scsi/sas/sas_internal.h
@@ -28,6 +28,7 @@
 #define _SAS_INTERNAL_H_
 
 #include <scsi/sas/sas_class.h>
+#include <scsi/scsi_host.h>
 
 #define sas_printk(fmt, ...) printk(KERN_NOTICE "sas: " fmt, ## __VA_ARGS__)
 
@@ -53,29 +54,43 @@ extern int  sas_register_scsi_host(struc
 				   struct scsi_transport_template *);
 void sas_unregister_scsi_host(struct sas_ha_struct *sas_ha);
 
-int  sas_start_event_thread(struct sas_ha_struct *sas_ha);
-void sas_kill_event_thread(struct sas_ha_struct *sas_ha);
-
 int  sas_init_queue(struct sas_ha_struct *sas_ha);
+int  sas_init_events(struct sas_ha_struct *sas_ha);
 void sas_shutdown_queue(struct sas_ha_struct *sas_ha);
 
-void sas_phye_loss_of_signal(struct asd_sas_phy *phy);
-void sas_phye_oob_done(struct asd_sas_phy *phy);
-void sas_phye_oob_error(struct asd_sas_phy *phy);
-void sas_phye_spinup_hold(struct asd_sas_phy *phy);
-
 void sas_deform_port(struct asd_sas_phy *phy);
 
-void sas_porte_bytes_dmaed(struct asd_sas_phy *phy);
-void sas_porte_broadcast_rcvd(struct asd_sas_phy *phy);
-void sas_porte_link_reset_err(struct asd_sas_phy *phy);
-void sas_porte_timer_event(struct asd_sas_phy *phy);
-void sas_porte_hard_reset(struct asd_sas_phy *phy);
-
-int  sas_reserve_free_id(struct sas_port *port);
-void sas_reserve_scsi_id(struct sas_port *port, int id);
-void sas_release_scsi_id(struct sas_port *port, int id);
-
-void sas_hae_reset(struct sas_ha_struct *sas_ha);
+void sas_porte_bytes_dmaed(void *);
+void sas_porte_broadcast_rcvd(void *);
+void sas_porte_link_reset_err(void *);
+void sas_porte_timer_event(void *);
+void sas_porte_hard_reset(void *);
+
+void sas_hae_reset(void *);
+
+static inline void sas_queue_event(int event, spinlock_t *lock, u32 *pending,
+				   struct work_struct *work,
+				   struct Scsi_Host *shost)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(lock, flags);
+	if (*pending & (1 << event)) {
+		spin_unlock_irqrestore(lock, flags);
+		return;
+	}
+	*pending |= (1 << event);
+	spin_unlock_irqrestore(lock, flags);
+	scsi_queue_work(shost, work);
+}
+
+static inline void sas_begin_event(int event, spinlock_t *lock, u32 *pending)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(lock, flags);
+	*pending &= ~(1 << event);
+	spin_unlock_irqrestore(lock, flags);
+}
 
 #endif /* _SAS_INTERNAL_H_ */
diff --git a/drivers/scsi/sas/sas_phy.c b/drivers/scsi/sas/sas_phy.c
index 6014351..bc2834c 100644
--- a/drivers/scsi/sas/sas_phy.c
+++ b/drivers/scsi/sas/sas_phy.c
@@ -29,22 +29,34 @@
 
 /* ---------- Phy events ---------- */
 
-void sas_phye_loss_of_signal(struct asd_sas_phy *phy)
+static void sas_phye_loss_of_signal(void *data)
 {
+	struct asd_sas_phy *phy = data;
+
+	sas_begin_event(PHYE_LOSS_OF_SIGNAL, &phy->ha->event_lock,
+			&phy->phy_events_pending);
 	phy->error = 0;
 	sas_deform_port(phy);
 }
 
-void sas_phye_oob_done(struct asd_sas_phy *phy)
+static void sas_phye_oob_done(void *data)
 {
+	struct asd_sas_phy *phy = data;
+
+	sas_begin_event(PHYE_OOB_DONE, &phy->ha->event_lock,
+			&phy->phy_events_pending);
 	phy->error = 0;
 }
 
-void sas_phye_oob_error(struct asd_sas_phy *phy)
+static void sas_phye_oob_error(void *data)
 {
+	struct asd_sas_phy *phy = data;
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_port *port = phy->port;
 
+	sas_begin_event(PHYE_OOB_ERROR, &phy->ha->event_lock,
+			&phy->phy_events_pending);
+
 	sas_deform_port(phy);
 
 	if (!port && phy->enabled && sas_ha->lldd_control_phy) {
@@ -64,10 +76,14 @@ void sas_phye_oob_error(struct asd_sas_p
 	}
 }
 
-void sas_phye_spinup_hold(struct asd_sas_phy *phy)
+static void sas_phye_spinup_hold(void *data)
 {
+	struct asd_sas_phy *phy = data;
 	struct sas_ha_struct *sas_ha = phy->ha;
 
+	sas_begin_event(PHYE_SPINUP_HOLD, &phy->ha->event_lock,
+			&phy->phy_events_pending);
+
 	phy->error = 0;
 	sas_ha->lldd_control_phy(phy, PHY_FUNC_RELEASE_SPINUP_HOLD);
 }
@@ -78,6 +94,21 @@ int sas_register_phys(struct sas_ha_stru
 {
 	int i;
 
+	static void (*sas_phy_event_fns[PHY_NUM_EVENTS])(void *) = {
+		[PHYE_LOSS_OF_SIGNAL] = sas_phye_loss_of_signal,
+		[PHYE_OOB_DONE] = sas_phye_oob_done,
+		[PHYE_OOB_ERROR] = sas_phye_oob_error,
+		[PHYE_SPINUP_HOLD] = sas_phye_spinup_hold,
+	};
+
+	static void (*sas_port_event_fns[PORT_NUM_EVENTS])(void *) = {
+		[PORTE_BYTES_DMAED] = sas_porte_bytes_dmaed,
+		[PORTE_BROADCAST_RCVD] = sas_porte_broadcast_rcvd,
+		[PORTE_LINK_RESET_ERR] = sas_porte_link_reset_err,
+		[PORTE_TIMER_EVENT] = sas_porte_timer_event,
+		[PORTE_HARD_RESET] = sas_porte_hard_reset,
+	};
+
 	/* Now register the phys. */
 	for (i = 0; i < sas_ha->num_phys; i++) {
 		int k;
@@ -85,18 +116,13 @@ int sas_register_phys(struct sas_ha_stru
 
 		phy->error = 0;
 		INIT_LIST_HEAD(&phy->port_phy_el);
-		INIT_LIST_HEAD(&phy->port_event_list);
-		INIT_LIST_HEAD(&phy->phy_event_list);
-		for (k = 0; k < PORT_NUM_EVENTS; k++) {
-			struct sas_event *ev = &phy->port_events[k];
-			ev->event = k;
-			INIT_LIST_HEAD(&ev->el);
-		}
-		for (k = 0; k < PHY_NUM_EVENTS; k++) {
-			struct sas_event *ev = &phy->phy_events[k];
-			ev->event = k;
-			INIT_LIST_HEAD(&ev->el);
-		}
+		for (k = 0; k < PORT_NUM_EVENTS; k++)
+			INIT_WORK(&phy->port_events[k], sas_port_event_fns[k],
+				  phy);
+
+		for (k = 0; k < PHY_NUM_EVENTS; k++)
+			INIT_WORK(&phy->phy_events[k], sas_phy_event_fns[k],
+				  phy);
 		phy->port = NULL;
 		phy->ha = sas_ha;
 		spin_lock_init(&phy->frame_rcvd_lock);
diff --git a/drivers/scsi/sas/sas_port.c b/drivers/scsi/sas/sas_port.c
index 53117e4..6177423 100644
--- a/drivers/scsi/sas/sas_port.c
+++ b/drivers/scsi/sas/sas_port.c
@@ -167,15 +167,24 @@ void sas_deform_port(struct asd_sas_phy 
 
 /* ---------- SAS port events ---------- */
 
-void sas_porte_bytes_dmaed(struct asd_sas_phy *phy)
+void sas_porte_bytes_dmaed(void *data)
 {
+	struct asd_sas_phy *phy = data;
+
+	sas_begin_event(PORTE_BYTES_DMAED, &phy->ha->event_lock,
+			&phy->port_events_pending);
+
 	sas_form_port(phy);
 }
 
-void sas_porte_broadcast_rcvd(struct asd_sas_phy *phy)
+void sas_porte_broadcast_rcvd(void *data)
 {
 	unsigned long flags;
 	u32 prim;
+	struct asd_sas_phy *phy = data;
+
+	sas_begin_event(PORTE_BROADCAST_RCVD, &phy->ha->event_lock,
+			&phy->port_events_pending);
 
 	spin_lock_irqsave(&phy->sas_prim_lock, flags);
 	prim = phy->sas_prim;
@@ -185,18 +194,33 @@ void sas_porte_broadcast_rcvd(struct asd
 	sas_discover_event(phy->port, DISCE_REVALIDATE_DOMAIN);
 }
 
-void sas_porte_link_reset_err(struct asd_sas_phy *phy)
+void sas_porte_link_reset_err(void *data)
 {
+	struct asd_sas_phy *phy = data;
+
+	sas_begin_event(PORTE_LINK_RESET_ERR, &phy->ha->event_lock,
+			&phy->port_events_pending);
+
 	sas_deform_port(phy);
 }
 
-void sas_porte_timer_event(struct asd_sas_phy *phy)
+void sas_porte_timer_event(void *data)
 {
+	struct asd_sas_phy *phy = data;
+
+	sas_begin_event(PORTE_TIMER_EVENT, &phy->ha->event_lock,
+			&phy->port_events_pending);
+
 	sas_deform_port(phy);
 }
 
-void sas_porte_hard_reset(struct asd_sas_phy *phy)
+void sas_porte_hard_reset(void *data)
 {
+	struct asd_sas_phy *phy = data;
+
+	sas_begin_event(PORTE_HARD_RESET, &phy->ha->event_lock,
+			&phy->port_events_pending);
+
 	sas_deform_port(phy);
 }
 
diff --git a/include/scsi/sas/sas_class.h b/include/scsi/sas/sas_class.h
index f7b8a26..e275fb6 100644
--- a/include/scsi/sas/sas_class.h
+++ b/include/scsi/sas/sas_class.h
@@ -86,21 +86,17 @@ enum discover_event {
 };
 #define DISC_NUM_EVENTS 3
 
-struct sas_event {
-	int    event;
-	struct list_head el;
-};
-
 /* The phy pretty much is controlled by the LLDD.
  * The class only reads those fields.
  */
 struct asd_sas_phy {
 /* private: */
 	/* protected by ha->event_lock */
-	struct list_head   port_event_list;
-	struct list_head   phy_event_list;
-	struct sas_event   port_events[PORT_NUM_EVENTS];
-	struct sas_event   phy_events[PHY_NUM_EVENTS];
+	struct work_struct   port_events[PORT_NUM_EVENTS];
+	struct work_struct   phy_events[PHY_NUM_EVENTS];
+
+	u32 port_events_pending;
+	u32 phy_events_pending;
 
 	int error;
 
@@ -142,12 +138,8 @@ struct sas_port;
 
 struct sas_discovery {
 	spinlock_t disc_event_lock;
-	unsigned        disc_thread_quit:1;
-	unsigned	disc_thread:1;
-	struct list_head disc_event_list;
-	struct sas_event disc_events[DISC_NUM_EVENTS];
-	struct semaphore  disc_sema;
-
+	struct work_struct disc_work[DISC_NUM_EVENTS];
+	u32    pending;
 	u8     fanout_sas_addr[8];
 	u8     eeds_a[8];
 	u8     eeds_b[8];
@@ -207,14 +199,9 @@ struct scsi_core {
 
 struct sas_ha_struct {
 /* private: */
-	struct semaphore event_sema;
-	int              event_thread_kill;
-
 	spinlock_t       event_lock;
-	struct list_head ha_event_list;
-	struct sas_event ha_events[HA_NUM_EVENTS];
-	u32              porte_mask; /* mask of phys for port events */
-	u32              phye_mask; /* mask of phys for phy events */
+	struct work_struct ha_events[HA_NUM_EVENTS];
+	u32		 pending;
 
 	struct scsi_core core;
 
diff --git a/include/scsi/sas/sas_discover.h b/include/scsi/sas/sas_discover.h
index 2aa56f3..df0cdcb 100644
--- a/include/scsi/sas/sas_discover.h
+++ b/include/scsi/sas/sas_discover.h
@@ -171,7 +171,6 @@ static inline void sas_init_dev(struct d
 }
 
 void sas_init_disc(struct sas_discovery *disc, struct sas_port *port);
-void sas_kill_disc_thread(struct sas_port *port);
 int  sas_discover_event(struct sas_port *sas_port, enum discover_event ev);
 
 int  sas_discover_sata(struct domain_device *dev);


