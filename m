From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 20/21] libsas: Add SAS_HA state flags to avoid queueing events while unloading
Date: Thu, 11 Jan 2007 14:15:43 -0800
Message-ID: <20070111221543.3543.47653.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40724 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640AbXAKWPY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:15:24 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMFNeH015953
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:23 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMFNcF274046
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:23 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMFNvQ019254
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:23 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Track sas_ha_struct state so that we ignore events that come in while
we're shutting things down.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
---

 drivers/scsi/libsas/sas_discover.c |    2 +-
 drivers/scsi/libsas/sas_event.c    |    6 +++---
 drivers/scsi/libsas/sas_init.c     |   12 ++++++++++++
 drivers/scsi/libsas/sas_internal.h |    9 +++++++--
 include/scsi/libsas.h              |    8 ++++++++
 5 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 21f538e..b6ba0e0 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -753,7 +753,7 @@ int sas_discover_event(struct asd_sas_po
 	BUG_ON(ev >= DISC_NUM_EVENTS);
 
 	sas_queue_event(ev, &disc->disc_event_lock, &disc->pending,
-			&disc->disc_work[ev].work, port->ha->core.shost);
+			&disc->disc_work[ev].work, port->ha);
 
 	return 0;
 }
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index d83392e..9db30fb 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -31,7 +31,7 @@ static void notify_ha_event(struct sas_h
 	BUG_ON(event >= HA_NUM_EVENTS);
 
 	sas_queue_event(event, &sas_ha->event_lock, &sas_ha->pending,
-			&sas_ha->ha_events[event].work, sas_ha->core.shost);
+			&sas_ha->ha_events[event].work, sas_ha);
 }
 
 static void notify_port_event(struct asd_sas_phy *phy, enum port_event event)
@@ -41,7 +41,7 @@ static void notify_port_event(struct asd
 	BUG_ON(event >= PORT_NUM_EVENTS);
 
 	sas_queue_event(event, &ha->event_lock, &phy->port_events_pending,
-			&phy->port_events[event].work, ha->core.shost);
+			&phy->port_events[event].work, ha);
 }
 
 static void notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
@@ -51,7 +51,7 @@ static void notify_phy_event(struct asd_
 	BUG_ON(event >= PHY_NUM_EVENTS);
 
 	sas_queue_event(event, &ha->event_lock, &phy->phy_events_pending,
-			&phy->phy_events[event].work, ha->core.shost);
+			&phy->phy_events[event].work, ha);
 }
 
 int sas_init_events(struct sas_ha_struct *sas_ha)
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 4df73d6..965698c 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -87,6 +87,9 @@ int sas_register_ha(struct sas_ha_struct
 	else if (sas_ha->lldd_queue_size == -1)
 		sas_ha->lldd_queue_size = 128; /* Sanity */
 
+	sas_ha->state = SAS_HA_REGISTERED;
+	spin_lock_init(&sas_ha->state_lock);
+
 	error = sas_register_phys(sas_ha);
 	if (error) {
 		printk(KERN_NOTICE "couldn't register sas phys:%d\n", error);
@@ -127,6 +130,15 @@ Undo_phys:
 
 int sas_unregister_ha(struct sas_ha_struct *sas_ha)
 {
+	unsigned long flags;
+
+	/* Set the state to unregistered to avoid further
+	 * events to be queued */
+	spin_lock_irqsave(&sas_ha->state_lock, flags);
+	sas_ha->state = SAS_HA_UNREGISTERED;
+	spin_unlock_irqrestore(&sas_ha->state_lock, flags);
+	scsi_flush_work(sas_ha->core.shost);
+
 	sas_unregister_ports(sas_ha);
 
 	if (sas_ha->lldd_max_execute_num > 1) {
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 137d7e4..a78638d 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -80,7 +80,7 @@ void sas_hae_reset(struct work_struct *w
 static inline void sas_queue_event(int event, spinlock_t *lock,
 				   unsigned long *pending,
 				   struct work_struct *work,
-				   struct Scsi_Host *shost)
+				   struct sas_ha_struct *sas_ha)
 {
 	unsigned long flags;
 
@@ -91,7 +91,12 @@ static inline void sas_queue_event(int e
 	}
 	__set_bit(event, pending);
 	spin_unlock_irqrestore(lock, flags);
-	scsi_queue_work(shost, work);
+
+	spin_lock_irqsave(&sas_ha->state_lock, flags);
+	if (sas_ha->state != SAS_HA_UNREGISTERED) {
+		scsi_queue_work(sas_ha->core.shost, work);
+	}
+	spin_unlock_irqrestore(&sas_ha->state_lock, flags);
 }
 
 static inline void sas_begin_event(int event, spinlock_t *lock,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index c834263..ca39392 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -323,12 +323,20 @@ struct sas_ha_event {
 	struct sas_ha_struct *ha;
 };
 
+enum sas_ha_state {
+	SAS_HA_REGISTERED,
+	SAS_HA_UNREGISTERED
+};
+
 struct sas_ha_struct {
 /* private: */
 	spinlock_t       event_lock;
 	struct sas_ha_event ha_events[HA_NUM_EVENTS];
 	unsigned long	 pending;
 
+	enum sas_ha_state state;
+	spinlock_t 	  state_lock;
+
 	struct scsi_core core;
 
 /* public: */
