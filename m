Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387DBC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 23:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243021AbiE3XPv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 19:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242938AbiE3XPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 19:15:43 -0400
Received: from beige.elm.relay.mailchannels.net (beige.elm.relay.mailchannels.net [23.83.212.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A3071D8B
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 16:15:41 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 51C42C0A85;
        Mon, 30 May 2022 23:15:41 +0000 (UTC)
Received: from pdx1-sub0-mail-a312.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 67673C0DEE;
        Mon, 30 May 2022 23:15:40 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1653952540; a=rsa-sha256;
        cv=none;
        b=2aImFOt9QS2ASMgmt/Y4BmTVuDboLOWrOlMmaN0bkwqcNl9O2zjrv6JvFKVtv0NG+Mzz++
        1iGCG9m0x3OyVNCpyGdsyW49nIQHen/fVMIo6kp8qxMK4FVo6pg5ZEmapGdLT6YRgLbVyG
        kl6+YS/jES/q37cqtwWTFfBiah2pkD7H14B/4sqj/FXYfMLiQh7cHPLew7CFvt3WL7MEvt
        bS9seFpXq0veCfiXw31LemRpbpQtmGpQkSkHiSgzcUiQWHAOdD7cDzh+/t+qOWxpwXwkWn
        pfpq8qVOSeerbNha7ogEY5FNYOf0S012GJ1wlBNZgRoes8V8dYBReRrGlVmqWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1653952540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=V1IMWtLw/kNCt3Stor1ZVTDAU6CkIBW33piu4s3bM94=;
        b=tbZ4f3wx+OmAiUZ/TnXPleGBhbC2/vARLvsE8v02aAwJip0TXU0ylbrrqfVimd7VvHuFMl
        kYynzEffxki+qLLPlVXRRPmdaI+m8+dyyz0t/j5wsuZgLAykByhxVsS/PCrjXMlLHYSCxH
        Y2eXYAzfYWQuFnezQnsntBWk+T3nvXu5Q70m2C0fTaLerFWCSev6g1Xc/fNlwNko9OJRzW
        F8nxO3u3Kv+6akJXjR2eqyeMYERnP6xcLxRChVFpOQo+Th8un46or9UJJTbqSRyY415qpO
        n4PcYqHoCTdbsSt7X68zv6ThXW1XVcr9P5AbftBVwPhU/3FzTWADpEmSE1M+Ig==
ARC-Authentication-Results: i=1;
        rspamd-54ff499d4f-fpjqt;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Spicy-Soft: 47447e21153db0c7_1653952540791_4041795566
X-MC-Loop-Signature: 1653952540791:1109267282
X-MC-Ingress-Time: 1653952540791
Received: from pdx1-sub0-mail-a312.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.101.255.183 (trex/6.7.1);
        Mon, 30 May 2022 23:15:40 +0000
Received: from localhost.localdomain (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a312.dreamhost.com (Postfix) with ESMTPSA id 4LBrqb5Fzyz2g;
        Mon, 30 May 2022 16:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1653952540;
        bh=V1IMWtLw/kNCt3Stor1ZVTDAU6CkIBW33piu4s3bM94=;
        h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
        b=axFBcZa8Q81oQHBvqLO3+tu33uB/tO1uKEbqQnK2WW0rxLFzgNNUYh5OIwIGS2jNk
         f1Cw7xB74flDQsYpsd8J5L7hJMWVUXvSu9JEvjm3zCQUSmcpUlQhbUiK9PVl9GJRkr
         7A5CED+HD+bkNP+wtAeJHun1dncaZ66MrZnxnBKjuebmdzBBperkClmO/b72ELWd7L
         aS5Bcg7ye/UhSPraSYzY25jgekim0V8ZIDwnLoMuPery0kRpPFKnYi7oJ6lCrYvfxO
         dF/YsnpIOQ6Pi7dqwo7d0AAHo56Y4smeYYeuVWZJV86czPDWocEOlH5cPsd+oxrlJF
         YeQN4nc7+KuuQ==
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, ejb@linux.ibm.com,
        bigeasy@linutronix.de, tglx@linutronix.de, dave@stgolabs.net,
        Bradley Grove <linuxdrivers@attotech.com>
Subject: [PATCH 07/10] scsi/esas2r: Replace tasklet with workqueue
Date:   Mon, 30 May 2022 16:15:09 -0700
Message-Id: <20220530231512.9729-8-dave@stgolabs.net>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530231512.9729-1-dave@stgolabs.net>
References: <20220530231512.9729-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tasklets have long been deprecated as being too heavy on the system
by running in irq context - and this is not a performance critical
path. If a higher priority process wants to run, it must wait for
the tasklet to finish before doing so.

Use an dedicated (single threaded) high-priority workqueue instead
such that async work can be done in task context instead. The
AF_WORK_SCHEDULED semantics remain the same for the tasklet scope.

Cc: Bradley Grove <linuxdrivers@attotech.com>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 drivers/scsi/esas2r/esas2r.h      | 19 +++++++++--------
 drivers/scsi/esas2r/esas2r_init.c | 20 ++++++++----------
 drivers/scsi/esas2r/esas2r_int.c  | 20 +++++++++---------
 drivers/scsi/esas2r/esas2r_io.c   |  2 +-
 drivers/scsi/esas2r/esas2r_main.c | 34 ++++++++++++++++++++-----------
 5 files changed, 52 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index ed63f7a9ea54..732309425956 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -64,6 +64,7 @@
 #define ESAS2R_H
 
 /* Global Variables */
+extern struct workqueue_struct *esas2r_wq;
 extern struct esas2r_adapter *esas2r_adapters[];
 extern u8 *esas2r_buffered_ioctl;
 extern dma_addr_t esas2r_buffered_ioctl_addr;
@@ -815,7 +816,7 @@ struct esas2r_adapter {
 	#define AF_NVR_VALID        12
 	#define AF_DEGRADED_MODE    13
 	#define AF_DISC_PENDING     14
-	#define AF_TASKLET_SCHEDULED    15
+	#define AF_WORK_SCHEDULED   15
 	#define AF_HEARTBEAT        16
 	#define AF_HEARTBEAT_ENB    17
 	#define AF_NOT_PRESENT      18
@@ -900,7 +901,7 @@ struct esas2r_adapter {
 	struct esas2r_flash_context flash_context;
 	u32 num_targets_backend;
 	u32 ioctl_tunnel;
-	struct tasklet_struct tasklet;
+	struct work_struct work;
 	struct pci_dev *pcid;
 	struct Scsi_Host *host;
 	unsigned int index;
@@ -992,7 +993,7 @@ int esas2r_write_vda(struct esas2r_adapter *a, const char *buf, long off,
 int esas2r_read_fs(struct esas2r_adapter *a, char *buf, long off, int count);
 int esas2r_write_fs(struct esas2r_adapter *a, const char *buf, long off,
 		    int count);
-void esas2r_adapter_tasklet(unsigned long context);
+void esas2r_adapter_work(struct work_struct *work);
 irqreturn_t esas2r_interrupt(int irq, void *dev_id);
 irqreturn_t esas2r_msi_interrupt(int irq, void *dev_id);
 void esas2r_kickoff_timer(struct esas2r_adapter *a);
@@ -1022,7 +1023,7 @@ bool esas2r_init_adapter_hw(struct esas2r_adapter *a, bool init_poll);
 void esas2r_start_request(struct esas2r_adapter *a, struct esas2r_request *rq);
 bool esas2r_send_task_mgmt(struct esas2r_adapter *a,
 			   struct esas2r_request *rqaux, u8 task_mgt_func);
-void esas2r_do_tasklet_tasks(struct esas2r_adapter *a);
+void esas2r_do_work_tasks(struct esas2r_adapter *a);
 void esas2r_adapter_interrupt(struct esas2r_adapter *a);
 void esas2r_do_deferred_processes(struct esas2r_adapter *a);
 void esas2r_reset_bus(struct esas2r_adapter *a);
@@ -1283,7 +1284,7 @@ static inline void esas2r_rq_destroy_request(struct esas2r_request *rq,
 	rq->data_buf = NULL;
 }
 
-static inline bool esas2r_is_tasklet_pending(struct esas2r_adapter *a)
+static inline bool esas2r_is_work_pending(struct esas2r_adapter *a)
 {
 
 	return test_bit(AF_BUSRST_NEEDED, &a->flags) ||
@@ -1324,14 +1325,14 @@ static inline void esas2r_enable_chip_interrupts(struct esas2r_adapter *a)
 					    ESAS2R_INT_ENB_MASK);
 }
 
-/* Schedule a TASKLET to perform non-interrupt tasks that may require delays
+/* Schedule work to perform non-interrupt tasks that may require delays
  * or long completion times.
  */
-static inline void esas2r_schedule_tasklet(struct esas2r_adapter *a)
+static inline void esas2r_schedule_work(struct esas2r_adapter *a)
 {
 	/* make sure we don't schedule twice */
-	if (!test_and_set_bit(AF_TASKLET_SCHEDULED, &a->flags))
-		tasklet_hi_schedule(&a->tasklet);
+	if (!test_and_set_bit(AF_WORK_SCHEDULED, &a->flags))
+		queue_work(esas2r_wq, &a->work);
 }
 
 static inline void esas2r_enable_heartbeat(struct esas2r_adapter *a)
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index c1a5ab662dc8..c7ca9435d395 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -401,9 +401,7 @@ int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
 		return 0;
 	}
 
-	tasklet_init(&a->tasklet,
-		     esas2r_adapter_tasklet,
-		     (unsigned long)a);
+	INIT_WORK(&a->work, esas2r_adapter_work);
 
 	/*
 	 * Disable chip interrupts to prevent spurious interrupts
@@ -441,7 +439,7 @@ static void esas2r_adapter_power_down(struct esas2r_adapter *a,
 	    &&  (!test_bit(AF_DEGRADED_MODE, &a->flags))) {
 		if (!power_management) {
 			del_timer_sync(&a->timer);
-			tasklet_kill(&a->tasklet);
+			cancel_work_sync(&a->work);
 		}
 		esas2r_power_down(a);
 
@@ -1338,7 +1336,7 @@ bool esas2r_init_adapter_hw(struct esas2r_adapter *a, bool init_poll)
 	 * usually requested during initial driver load and possibly when
 	 * resuming from a low power state.  deferred device waiting will use
 	 * interrupts.  chip reset recovery always defers device waiting to
-	 * avoid being in a TASKLET too long.
+	 * avoid being in a work too long.
 	 */
 	if (init_poll) {
 		u32 currtime = a->disc_start_time;
@@ -1346,10 +1344,10 @@ bool esas2r_init_adapter_hw(struct esas2r_adapter *a, bool init_poll)
 		u32 deltatime;
 
 		/*
-		 * Block Tasklets from getting scheduled and indicate this is
+		 * Block async work from getting scheduled and indicate this is
 		 * polled discovery.
 		 */
-		set_bit(AF_TASKLET_SCHEDULED, &a->flags);
+		set_bit(AF_WORK_SCHEDULED, &a->flags);
 		set_bit(AF_DISC_POLLED, &a->flags);
 
 		/*
@@ -1394,8 +1392,8 @@ bool esas2r_init_adapter_hw(struct esas2r_adapter *a, bool init_poll)
 				nexttick -= deltatime;
 
 			/* Do any deferred processing */
-			if (esas2r_is_tasklet_pending(a))
-				esas2r_do_tasklet_tasks(a);
+			if (esas2r_is_work_pending(a))
+				esas2r_do_work_tasks(a);
 
 		}
 
@@ -1403,7 +1401,7 @@ bool esas2r_init_adapter_hw(struct esas2r_adapter *a, bool init_poll)
 			atomic_inc(&a->disable_cnt);
 
 		clear_bit(AF_DISC_POLLED, &a->flags);
-		clear_bit(AF_TASKLET_SCHEDULED, &a->flags);
+		clear_bit(AF_WORK_SCHEDULED, &a->flags);
 	}
 
 
@@ -1463,7 +1461,7 @@ void esas2r_reset_adapter(struct esas2r_adapter *a)
 {
 	set_bit(AF_OS_RESET, &a->flags);
 	esas2r_local_reset_adapter(a);
-	esas2r_schedule_tasklet(a);
+	esas2r_schedule_work(a);
 }
 
 void esas2r_reset_chip(struct esas2r_adapter *a)
diff --git a/drivers/scsi/esas2r/esas2r_int.c b/drivers/scsi/esas2r/esas2r_int.c
index 5281d9356327..1b1b8b65539d 100644
--- a/drivers/scsi/esas2r/esas2r_int.c
+++ b/drivers/scsi/esas2r/esas2r_int.c
@@ -86,7 +86,7 @@ void esas2r_polled_interrupt(struct esas2r_adapter *a)
 
 /*
  * Legacy and MSI interrupt handlers.  Note that the legacy interrupt handler
- * schedules a TASKLET to process events, whereas the MSI handler just
+ * schedules work to process events, whereas the MSI handler just
  * processes interrupt events directly.
  */
 irqreturn_t esas2r_interrupt(int irq, void *dev_id)
@@ -97,7 +97,7 @@ irqreturn_t esas2r_interrupt(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	set_bit(AF2_INT_PENDING, &a->flags2);
-	esas2r_schedule_tasklet(a);
+	esas2r_schedule_work(a);
 
 	return IRQ_HANDLED;
 }
@@ -162,7 +162,7 @@ irqreturn_t esas2r_msi_interrupt(int irq, void *dev_id)
 	if (likely(atomic_read(&a->disable_cnt) == 0))
 		esas2r_do_deferred_processes(a);
 
-	esas2r_do_tasklet_tasks(a);
+	esas2r_do_work_tasks(a);
 
 	return 1;
 }
@@ -327,8 +327,8 @@ void esas2r_do_deferred_processes(struct esas2r_adapter *a)
 
 	/* Clear off the completed list to be processed later. */
 
-	if (esas2r_is_tasklet_pending(a)) {
-		esas2r_schedule_tasklet(a);
+	if (esas2r_is_work_pending(a)) {
+		esas2r_schedule_work(a);
 
 		startreqs = 0;
 	}
@@ -476,7 +476,7 @@ static void esas2r_process_bus_reset(struct esas2r_adapter *a)
 	esas2r_trace_exit();
 }
 
-static void esas2r_chip_rst_needed_during_tasklet(struct esas2r_adapter *a)
+static void esas2r_chip_rst_needed_during_work(struct esas2r_adapter *a)
 {
 
 	clear_bit(AF_CHPRST_NEEDED, &a->flags);
@@ -558,7 +558,7 @@ static void esas2r_chip_rst_needed_during_tasklet(struct esas2r_adapter *a)
 	}
 }
 
-static void esas2r_handle_chip_rst_during_tasklet(struct esas2r_adapter *a)
+static void esas2r_handle_chip_rst_during_work(struct esas2r_adapter *a)
 {
 	while (test_bit(AF_CHPRST_DETECTED, &a->flags)) {
 		/*
@@ -614,15 +614,15 @@ static void esas2r_handle_chip_rst_during_tasklet(struct esas2r_adapter *a)
 
 
 /* Perform deferred tasks when chip interrupts are disabled */
-void esas2r_do_tasklet_tasks(struct esas2r_adapter *a)
+void esas2r_do_work_tasks(struct esas2r_adapter *a)
 {
 
 	if (test_bit(AF_CHPRST_NEEDED, &a->flags) ||
 	    test_bit(AF_CHPRST_DETECTED, &a->flags)) {
 		if (test_bit(AF_CHPRST_NEEDED, &a->flags))
-			esas2r_chip_rst_needed_during_tasklet(a);
+			esas2r_chip_rst_needed_during_work(a);
 
-		esas2r_handle_chip_rst_during_tasklet(a);
+		esas2r_handle_chip_rst_during_work(a);
 	}
 
 	if (test_bit(AF_BUSRST_NEEDED, &a->flags)) {
diff --git a/drivers/scsi/esas2r/esas2r_io.c b/drivers/scsi/esas2r/esas2r_io.c
index a8df916cd57a..d45e6e16a858 100644
--- a/drivers/scsi/esas2r/esas2r_io.c
+++ b/drivers/scsi/esas2r/esas2r_io.c
@@ -851,7 +851,7 @@ void esas2r_reset_bus(struct esas2r_adapter *a)
 		set_bit(AF_BUSRST_PENDING, &a->flags);
 		set_bit(AF_OS_RESET, &a->flags);
 
-		esas2r_schedule_tasklet(a);
+		esas2r_schedule_work(a);
 	}
 }
 
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 7a4eadad23d7..abe45a934cce 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -530,7 +530,7 @@ static void esas2r_remove(struct pci_dev *pdev)
 
 static int __init esas2r_init(void)
 {
-	int i;
+	int i, ret;
 
 	esas2r_log(ESAS2R_LOG_INFO, "%s called", __func__);
 
@@ -606,7 +606,15 @@ static int __init esas2r_init(void)
 	for (i = 0; i < MAX_ADAPTERS; i++)
 		esas2r_adapters[i] = NULL;
 
-	return pci_register_driver(&esas2r_pci_driver);
+	esas2r_wq = alloc_ordered_workqueue("esas2r_wq", WQ_HIGHPRI);
+	if (!esas2r_wq)
+		return -ENOMEM;
+
+	ret = pci_register_driver(&esas2r_pci_driver);
+	if (ret)
+		destroy_workqueue(esas2r_wq);
+
+	return ret;
 }
 
 /* Handle ioctl calls to "/proc/scsi/esas2r/ATTOnode" */
@@ -649,6 +657,8 @@ static void __exit esas2r_exit(void)
 	esas2r_log(ESAS2R_LOG_INFO, "pci_unregister_driver() called");
 
 	pci_unregister_driver(&esas2r_pci_driver);
+
+	destroy_workqueue(esas2r_wq);
 }
 
 int esas2r_show_info(struct seq_file *m, struct Scsi_Host *sh)
@@ -1540,10 +1550,10 @@ void esas2r_complete_request_cb(struct esas2r_adapter *a,
 	esas2r_free_request(a, rq);
 }
 
-/* Run tasklet to handle stuff outside of interrupt context. */
-void esas2r_adapter_tasklet(unsigned long context)
+/* Handle stuff outside of interrupt context. */
+void esas2r_adapter_work(struct work_struct *work)
 {
-	struct esas2r_adapter *a = (struct esas2r_adapter *)context;
+	struct esas2r_adapter *a = (struct esas2r_adapter *)work;
 
 	if (unlikely(test_bit(AF2_TIMER_TICK, &a->flags2))) {
 		clear_bit(AF2_TIMER_TICK, &a->flags2);
@@ -1555,16 +1565,16 @@ void esas2r_adapter_tasklet(unsigned long context)
 		esas2r_adapter_interrupt(a);
 	}
 
-	if (esas2r_is_tasklet_pending(a))
-		esas2r_do_tasklet_tasks(a);
+	if (esas2r_is_work_pending(a))
+		esas2r_do_work_tasks(a);
 
-	if (esas2r_is_tasklet_pending(a)
+	if (esas2r_is_work_pending(a)
 	    || (test_bit(AF2_INT_PENDING, &a->flags2))
 	    || (test_bit(AF2_TIMER_TICK, &a->flags2))) {
-		clear_bit(AF_TASKLET_SCHEDULED, &a->flags);
-		esas2r_schedule_tasklet(a);
+		clear_bit(AF_WORK_SCHEDULED, &a->flags);
+		esas2r_schedule_work(a);
 	} else {
-		clear_bit(AF_TASKLET_SCHEDULED, &a->flags);
+		clear_bit(AF_WORK_SCHEDULED, &a->flags);
 	}
 }
 
@@ -1586,7 +1596,7 @@ static void esas2r_timer_callback(struct timer_list *t)
 
 	set_bit(AF2_TIMER_TICK, &a->flags2);
 
-	esas2r_schedule_tasklet(a);
+	esas2r_schedule_work(a);
 
 	esas2r_kickoff_timer(a);
 }
-- 
2.36.1

