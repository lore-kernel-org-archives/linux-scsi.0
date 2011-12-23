From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 06/28] libsas: convert ha->state to flags
Date: Thu, 22 Dec 2011 18:59:00 -0800
Message-ID: <20111223025900.21827.7539.stgit@localhost6.localdomain6>
References: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11985 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259Ab1LWC7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2011 21:59:00 -0500
In-Reply-To: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

In preparation for adding new states (SAS_HA_DRAINING, SAS_HA_FROZEN),
convert ha->state into a set of flags.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_init.c     |    4 ++--
 drivers/scsi/libsas/sas_internal.h |    2 +-
 include/scsi/libsas.h              |    3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index a435876..da244e6 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -112,7 +112,7 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 	else if (sas_ha->lldd_queue_size == -1)
 		sas_ha->lldd_queue_size = 128; /* Sanity */
 
-	sas_ha->state = SAS_HA_REGISTERED;
+	set_bit(SAS_HA_REGISTERED, &sas_ha->state);
 	spin_lock_init(&sas_ha->state_lock);
 
 	error = sas_register_phys(sas_ha);
@@ -160,7 +160,7 @@ int sas_unregister_ha(struct sas_ha_struct *sas_ha)
 	/* Set the state to unregistered to avoid further
 	 * events to be queued */
 	spin_lock_irqsave(&sas_ha->state_lock, flags);
-	sas_ha->state = SAS_HA_UNREGISTERED;
+	clear_bit(SAS_HA_REGISTERED, &sas_ha->state);
 	spin_unlock_irqrestore(&sas_ha->state_lock, flags);
 	scsi_flush_work(sas_ha->core.shost);
 
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 7fe4ede..1fd84b3 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -100,7 +100,7 @@ static inline void sas_queue_event(int event, unsigned long *pending,
 		unsigned long flags;
 
 		spin_lock_irqsave(&sas_ha->state_lock, flags);
-		if (sas_ha->state != SAS_HA_UNREGISTERED)
+		if (test_bit(SAS_HA_REGISTERED, &sas_ha->state))
 			scsi_queue_work(sas_ha->core.shost, work);
 		spin_unlock_irqrestore(&sas_ha->state_lock, flags);
 	}
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index de63a66..8e402d5 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -330,7 +330,6 @@ struct sas_ha_event {
 
 enum sas_ha_state {
 	SAS_HA_REGISTERED,
-	SAS_HA_UNREGISTERED
 };
 
 struct sas_ha_struct {
@@ -338,7 +337,7 @@ struct sas_ha_struct {
 	struct sas_ha_event ha_events[HA_NUM_EVENTS];
 	unsigned long	 pending;
 
-	enum sas_ha_state state;
+	unsigned long	  state;
 	spinlock_t 	  state_lock;
 
 	struct scsi_core core;

