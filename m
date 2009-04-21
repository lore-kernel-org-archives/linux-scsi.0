From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 9/10] mpt2sas : mpt2sas: fix hotplug event processing
Date: Tue, 21 Apr 2009 15:43:33 -0600
Message-ID: <20090421214331.GA18593@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og57.obsmtp.com ([64.18.14.179]:53023 "EHLO
	chip3og57.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZDUVlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 17:41:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Here's a fix for hotplug events.  The useage of queue_delayed_work seems
to broke the fifo for processing of firmware events.  After several iterations
of adding and removing cabling connected to jbods, the devices are not
getting added becuase kernel thread is activited out of order.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-13 15:58:57.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-21 15:09:21.000000000 -0600
@@ -119,7 +119,7 @@ struct sense_info {
  */
 struct fw_event_work {
 	struct list_head 	list;
-	struct delayed_work	work;
+	struct work_struct	work;
 	struct MPT2SAS_ADAPTER *ioc;
 	u8			VF_ID;
 	u8			host_reset_handling;
@@ -2007,8 +2007,8 @@ _scsih_fw_event_add(struct MPT2SAS_ADAPT
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	list_add_tail(&fw_event->list, &ioc->fw_event_list);
-	INIT_DELAYED_WORK(&fw_event->work, _firmware_event_work);
-	queue_delayed_work(ioc->firmware_event_thread, &fw_event->work, 1);
+	INIT_WORK(&fw_event->work, _firmware_event_work);
+	queue_work(ioc->firmware_event_thread, &fw_event->work);
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
@@ -2052,7 +2052,7 @@ _scsih_fw_event_requeue(struct MPT2SAS_A
 		return;
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
-	queue_delayed_work(ioc->firmware_event_thread, &fw_event->work, delay);
+	queue_work(ioc->firmware_event_thread, &fw_event->work);
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
@@ -4961,7 +4961,7 @@ static void
 _firmware_event_work(struct work_struct *work)
 {
 	struct fw_event_work *fw_event = container_of(work,
-	    struct fw_event_work, work.work);
+	    struct fw_event_work, work);
 	unsigned long flags;
 	struct MPT2SAS_ADAPTER *ioc = fw_event->ioc;
 
