From: <kashyap.desai@lsi.com>
Subject: [PATCH 03/05] mptfusion: Avoid out of order Event processing due
 to timer migration feature of OS
Date: Thu, 4 Aug 2011 16:42:46 +0530
Message-ID: <201108041051.p74ApSNP005859@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:60292 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287Ab1HDKwm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2011 06:52:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com, JBottomley@parallels.com

Driver will schedule MPI event using "delay_work_queue_on" to 
specify same CPU to be used to schedule work.
Earlier it used "delay_work_queue" which can cause migration 
of work due to kernel' timer migration feature.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 83f5f79..c65aa75 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -290,10 +290,11 @@ mptsas_add_fw_event(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	list_add_tail(&fw_event->list, &ioc->fw_event_list);
 	INIT_DELAYED_WORK(&fw_event->work, mptsas_firmware_event_work);
-	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: add (fw_event=0x%p)\n",
-	    ioc->name, __func__, fw_event));
-	queue_delayed_work(ioc->fw_event_q, &fw_event->work,
-	    delay);
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: add (fw_event=0x%p)"
+		"on cpuid %d\n", ioc->name, __func__,
+		fw_event, smp_processor_id()));
+	queue_delayed_work_on(smp_processor_id(), ioc->fw_event_q,
+	    &fw_event->work, delay);
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
@@ -305,10 +306,11 @@ mptsas_requeue_fw_event(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
 	unsigned long flags;
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: reschedule task "
-	    "(fw_event=0x%p)\n", ioc->name, __func__, fw_event));
+	    "(fw_event=0x%p)on cpuid %d\n", ioc->name, __func__,
+		fw_event, smp_processor_id()));
 	fw_event->retries++;
-	queue_delayed_work(ioc->fw_event_q, &fw_event->work,
-	    msecs_to_jiffies(delay));
+	queue_delayed_work_on(smp_processor_id(), ioc->fw_event_q,
+	    &fw_event->work, msecs_to_jiffies(delay));
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
