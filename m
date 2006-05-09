From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 8/8] aic94xx: use bitops for testing, setting and clearing
	bits
Date: Tue, 09 May 2006 14:42:43 -0700
Message-ID: <1147210963.11847.69.camel@localhost.localdomain>
References: <1147209211.11847.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:446 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751177AbWEIVmo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 May 2006 17:42:44 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k49Lgilv016947
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 17:42:44 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k49Lgi7r159588
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:42:44 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k49Lgi3C016040
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:42:44 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.121])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id k49Lgh1d016013
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:42:44 -0600
In-Reply-To: <1147209211.11847.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Use bitops for testing, setting and clearing bits

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
Signed-off-by: Mike Anderson <andmike@us.ibm.com>

---
 drivers/scsi/sas/sas_internal.h |   16 +++++++++-------
 include/scsi/sas/sas_class.h    |    8 ++++----
 2 files changed, 13 insertions(+), 11 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_internal.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_internal.h
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_internal.h
@@ -27,6 +27,7 @@
 #define _SAS_INTERNAL_H_
 
 #include <scsi/sas/sas_class.h>
+#include <linux/bitops.h>
 #include <scsi/scsi_host.h>
 
 #define sas_printk(fmt, ...) printk(KERN_NOTICE "sas: " fmt, ## __VA_ARGS__)
@@ -70,28 +71,29 @@ void sas_notify_lldd_dev_gone(struct dom
 
 void sas_hae_reset(void *);
 
-static inline void sas_queue_event(int event, spinlock_t *lock, u32 *pending,
-				   struct work_struct *work,
-				   struct Scsi_Host *shost)
+static inline void sas_queue_event(int event, spinlock_t *lock, unsigned
+				   long *pending, struct work_struct
+				   *work, struct Scsi_Host *shost)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(lock, flags);
-	if (*pending & (1 << event)) {
+	if (test_bit(event, pending)) {
 		spin_unlock_irqrestore(lock, flags);
 		return;
 	}
-	*pending |= (1 << event);
+	__set_bit(event, pending);
 	spin_unlock_irqrestore(lock, flags);
 	scsi_queue_work(shost, work);
 }
 
-static inline void sas_begin_event(int event, spinlock_t *lock, u32 *pending)
+static inline void sas_begin_event(int event, spinlock_t *lock, unsigned
+				   long *pending)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(lock, flags);
-	*pending &= ~(1 << event);
+	__clear_bit(event, pending);
 	spin_unlock_irqrestore(lock, flags);
 }
 
Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_class.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_class.h
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_class.h
@@ -94,8 +94,8 @@ struct asd_sas_phy {
 	struct work_struct   port_events[PORT_NUM_EVENTS];
 	struct work_struct   phy_events[PHY_NUM_EVENTS];
 
-	u32 port_events_pending;
-	u32 phy_events_pending;
+	unsigned long port_events_pending;
+	unsigned long phy_events_pending;
 
 	int error;
 
@@ -138,7 +138,7 @@ struct sas_port;
 struct sas_discovery {
 	spinlock_t disc_event_lock;
 	struct work_struct disc_work[DISC_NUM_EVENTS];
-	u32    pending;
+	unsigned long    pending;
 	u8     fanout_sas_addr[8];
 	u8     eeds_a[8];
 	u8     eeds_b[8];
@@ -199,7 +199,7 @@ struct sas_ha_struct {
 /* private: */
 	spinlock_t       event_lock;
 	struct work_struct ha_events[HA_NUM_EVENTS];
-	u32		 pending;
+	unsigned long	 pending;
 
 	struct scsi_core core;
 


