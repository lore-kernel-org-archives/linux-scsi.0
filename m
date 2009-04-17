From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 13/14 - 2nd post] mpt2sas: fix hotplug event processing
Date: Fri, 17 Apr 2009 10:33:51 -0600
Message-ID: <20090417163350.GE7071@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og63.obsmtp.com ([64.18.14.203]:38436 "EHLO
	chip3og63.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761387AbZDQQcq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 12:32:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

Here's a fix for hotplug events.  The useage of queue_delayed_work seems
to broke the fifo for processing of firmware events.  After several iterations
of adding and removing cabling connected to jbods, the devices are not
getting added becuase kernel thread is activited out of order.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uarpN a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-17 09:08:48.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-17 09:09:42.000000000 -0600
@@ -1,4 +1,4 @@
-/*
+f/*
  * Scsi Host Layer for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_scsih.c
@@ -119,7 +119,7 @@ struct sense_info {
  */
 struct fw_event_work {
 	struct list_head 	list;
-	struct delayed_work	work;
+	struct work_struct	work;
 	struct MPT2SAS_ADAPTER *ioc;
 	u8			VF_ID;
 	u8			host_reset_handling;
@@ -2113,8 +2113,8 @@ _scsih_fw_event_add(struct MPT2SAS_ADAPT
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	list_add_tail(&fw_event->list, &ioc->fw_event_list);
-	INIT_DELAYED_WORK(&fw_event->work, _firmware_event_work);
-	queue_delayed_work(ioc->firmware_event_thread, &fw_event->work, 1);
+	INIT_WORK(&fw_event->work, _firmware_event_work);
+	queue_work(ioc->firmware_event_thread, &fw_event->work);
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
@@ -2158,7 +2158,7 @@ _scsih_fw_event_requeue(struct MPT2SAS_A
 		return;
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
-	queue_delayed_work(ioc->firmware_event_thread, &fw_event->work, delay);
+	queue_work(ioc->firmware_event_thread, &fw_event->work);
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
@@ -5182,7 +5182,7 @@ static void
 _firmware_event_work(struct work_struct *work)
 {
 	struct fw_event_work *fw_event = container_of(work,
-	    struct fw_event_work, work.work);
+	    struct fw_event_work, work);
 	unsigned long flags;
 	struct MPT2SAS_ADAPTER *ioc = fw_event->ioc;
 
