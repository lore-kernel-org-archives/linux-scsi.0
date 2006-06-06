From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 6/7] aic94xx: use bitops
Date: Tue, 06 Jun 2006 16:51:59 -0700
Message-ID: <1149637920.25278.81.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:190 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751377AbWFFXwQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2006 19:52:16 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56NqGOX010515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 19:52:16 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k56NqGrb052516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:52:16 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k56NqFdS006615
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:52:15 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56NqFjA006610
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:52:15 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Use bitops for testing, setting and clearing bits

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>


---
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_internal.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_internal.h	2006-06-05 13:12:57.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_internal.h	2006-06-06 09:23:29.000000000 -0700
@@ -76,21 +76,22 @@
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
+static inline void sas_begin_event(int event, spinlock_t *lock, 
+				   unsigned long *pending)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(lock, flags);
-	*pending &= ~(1 << event);
+	__clear_bit(event, pending);
 	spin_unlock_irqrestore(lock, flags);
 }
 


