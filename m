From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH] mpt2sas: fix hotplug event processing
Date: Tue, 14 Apr 2009 03:26:30 -0600
Message-ID: <20090414092628.GA20904@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og52.obsmtp.com ([64.18.14.169]:48693 "EHLO
	chip3og52.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZDNXAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 19:00:38 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EN0ZIb007567
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 16:00:35 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EN0aEU031148
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 16:00:36 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here's a fix for hotplug events.  The useage of queue_delayed_work seems
to broke the fifo for processing of firmware events.  After several iterations
of adding and removing cabling connected to jbods, the devices are not
getting added.

This patch applies over the patch set posted earlier today.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-13 17:39:20.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-14 15:43:53.000000000 -0600
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
 
@@ -5170,7 +5170,7 @@ static void
 _firmware_event_work(struct work_struct *work)
 {
 	struct fw_event_work *fw_event = container_of(work,
-	    struct fw_event_work, work.work);
+	    struct fw_event_work, work);
 	unsigned long flags;
 	struct MPT2SAS_ADAPTER *ioc = fw_event->ioc;
 
