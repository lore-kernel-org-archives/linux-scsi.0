From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 1/4] esas2r: Directly call kernel functions for atomic bit operations
Date: Tue, 1 Oct 2013 14:26:01 -0400
Message-ID: <1380651964-8124-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:51974 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751077Ab3JASfV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2013 14:35:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, Bradley Grove <bgrove@attotech.com>

Previously the code embedded the kernel's test_bit/clear_bit
functions in wrappers that accepted u32 parameters.  The
wrapper cast these parameters to longs before passing them
to the kernel's bit functions.   This did not work properly
on platforms with 64-bit longs.

Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r.h        | 125 +++++++++++++++----------------
 drivers/scsi/esas2r/esas2r_disc.c   |  55 +++++++-------
 drivers/scsi/esas2r/esas2r_flash.c  |  34 +++++----
 drivers/scsi/esas2r/esas2r_init.c   | 143 +++++++++++++++++-------------------
 drivers/scsi/esas2r/esas2r_int.c    |  97 ++++++++++++------------
 drivers/scsi/esas2r/esas2r_io.c     |  73 +++++++++---------
 drivers/scsi/esas2r/esas2r_ioctl.c  |  28 +++----
 drivers/scsi/esas2r/esas2r_main.c   |  34 ++++-----
 drivers/scsi/esas2r/esas2r_targdb.c |   2 +-
 drivers/scsi/esas2r/esas2r_vda.c    |   6 +-
 10 files changed, 291 insertions(+), 306 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 0838e26..d128c96 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -799,47 +799,47 @@ struct esas2r_adapter {
 	struct esas2r_target *targetdb_end;
 	unsigned char *regs;
 	unsigned char *data_window;
-	u32 volatile flags;
-	#define AF_PORT_CHANGE      (u32)(0x00000001)
-	#define AF_CHPRST_NEEDED    (u32)(0x00000004)
-	#define AF_CHPRST_PENDING   (u32)(0x00000008)
-	#define AF_CHPRST_DETECTED  (u32)(0x00000010)
-	#define AF_BUSRST_NEEDED    (u32)(0x00000020)
-	#define AF_BUSRST_PENDING   (u32)(0x00000040)
-	#define AF_BUSRST_DETECTED  (u32)(0x00000080)
-	#define AF_DISABLED         (u32)(0x00000100)
-	#define AF_FLASH_LOCK       (u32)(0x00000200)
-	#define AF_OS_RESET         (u32)(0x00002000)
-	#define AF_FLASHING         (u32)(0x00004000)
-	#define AF_POWER_MGT        (u32)(0x00008000)
-	#define AF_NVR_VALID        (u32)(0x00010000)
-	#define AF_DEGRADED_MODE    (u32)(0x00020000)
-	#define AF_DISC_PENDING     (u32)(0x00040000)
-	#define AF_TASKLET_SCHEDULED    (u32)(0x00080000)
-	#define AF_HEARTBEAT        (u32)(0x00200000)
-	#define AF_HEARTBEAT_ENB    (u32)(0x00400000)
-	#define AF_NOT_PRESENT      (u32)(0x00800000)
-	#define AF_CHPRST_STARTED   (u32)(0x01000000)
-	#define AF_FIRST_INIT       (u32)(0x02000000)
-	#define AF_POWER_DOWN       (u32)(0x04000000)
-	#define AF_DISC_IN_PROG     (u32)(0x08000000)
-	#define AF_COMM_LIST_TOGGLE (u32)(0x10000000)
-	#define AF_LEGACY_SGE_MODE  (u32)(0x20000000)
-	#define AF_DISC_POLLED      (u32)(0x40000000)
-	u32 volatile flags2;
-	#define AF2_SERIAL_FLASH    (u32)(0x00000001)
-	#define AF2_DEV_SCAN        (u32)(0x00000002)
-	#define AF2_DEV_CNT_OK      (u32)(0x00000004)
-	#define AF2_COREDUMP_AVAIL  (u32)(0x00000008)
-	#define AF2_COREDUMP_SAVED  (u32)(0x00000010)
-	#define AF2_VDA_POWER_DOWN  (u32)(0x00000100)
-	#define AF2_THUNDERLINK     (u32)(0x00000200)
-	#define AF2_THUNDERBOLT     (u32)(0x00000400)
-	#define AF2_INIT_DONE       (u32)(0x00000800)
-	#define AF2_INT_PENDING     (u32)(0x00001000)
-	#define AF2_TIMER_TICK      (u32)(0x00002000)
-	#define AF2_IRQ_CLAIMED     (u32)(0x00004000)
-	#define AF2_MSI_ENABLED     (u32)(0x00008000)
+	long flags;
+	#define AF_PORT_CHANGE      0
+	#define AF_CHPRST_NEEDED    1
+	#define AF_CHPRST_PENDING   2
+	#define AF_CHPRST_DETECTED  3
+	#define AF_BUSRST_NEEDED    4
+	#define AF_BUSRST_PENDING   5
+	#define AF_BUSRST_DETECTED  6
+	#define AF_DISABLED         7
+	#define AF_FLASH_LOCK       8
+	#define AF_OS_RESET         9
+	#define AF_FLASHING         10
+	#define AF_POWER_MGT        11
+	#define AF_NVR_VALID        12
+	#define AF_DEGRADED_MODE    13
+	#define AF_DISC_PENDING     14
+	#define AF_TASKLET_SCHEDULED    15
+	#define AF_HEARTBEAT        16
+	#define AF_HEARTBEAT_ENB    17
+	#define AF_NOT_PRESENT      18
+	#define AF_CHPRST_STARTED   19
+	#define AF_FIRST_INIT       20
+	#define AF_POWER_DOWN       21
+	#define AF_DISC_IN_PROG     22
+	#define AF_COMM_LIST_TOGGLE 23
+	#define AF_LEGACY_SGE_MODE  24
+	#define AF_DISC_POLLED      25
+	long flags2;
+	#define AF2_SERIAL_FLASH    0
+	#define AF2_DEV_SCAN        1
+	#define AF2_DEV_CNT_OK      2
+	#define AF2_COREDUMP_AVAIL  3
+	#define AF2_COREDUMP_SAVED  4
+	#define AF2_VDA_POWER_DOWN  5
+	#define AF2_THUNDERLINK     6
+	#define AF2_THUNDERBOLT     7
+	#define AF2_INIT_DONE       8
+	#define AF2_INT_PENDING     9
+	#define AF2_TIMER_TICK      10
+	#define AF2_IRQ_CLAIMED     11
+	#define AF2_MSI_ENABLED     12
 	atomic_t disable_cnt;
 	atomic_t dis_ints_cnt;
 	u32 int_stat;
@@ -1150,16 +1150,6 @@ void esas2r_queue_fw_event(struct esas2r_adapter *a,
 			   int data_sz);
 
 /* Inline functions */
-static inline u32 esas2r_lock_set_flags(volatile u32 *flags, u32 bits)
-{
-	return test_and_set_bit(ilog2(bits), (volatile unsigned long *)flags);
-}
-
-static inline u32 esas2r_lock_clear_flags(volatile u32 *flags, u32 bits)
-{
-	return test_and_clear_bit(ilog2(bits),
-				  (volatile unsigned long *)flags);
-}
 
 /* Allocate a chip scatter/gather list entry */
 static inline struct esas2r_mem_desc *esas2r_alloc_sgl(struct esas2r_adapter *a)
@@ -1303,10 +1293,13 @@ static inline void esas2r_rq_destroy_request(struct esas2r_request *rq,
 
 static inline bool esas2r_is_tasklet_pending(struct esas2r_adapter *a)
 {
-	return (a->flags & (AF_BUSRST_NEEDED | AF_BUSRST_DETECTED
-			    | AF_CHPRST_NEEDED | AF_CHPRST_DETECTED
-			    | AF_PORT_CHANGE))
-	       ? true : false;
+
+	return test_bit(AF_BUSRST_NEEDED, &a->flags) ||
+	       test_bit(AF_BUSRST_DETECTED, &a->flags) ||
+	       test_bit(AF_CHPRST_NEEDED, &a->flags) ||
+	       test_bit(AF_CHPRST_DETECTED, &a->flags) ||
+	       test_bit(AF_PORT_CHANGE, &a->flags);
+
 }
 
 /*
@@ -1345,24 +1338,24 @@ static inline void esas2r_enable_chip_interrupts(struct esas2r_adapter *a)
 static inline void esas2r_schedule_tasklet(struct esas2r_adapter *a)
 {
 	/* make sure we don't schedule twice */
-	if (!(esas2r_lock_set_flags(&a->flags, AF_TASKLET_SCHEDULED) &
-	      ilog2(AF_TASKLET_SCHEDULED)))
+	if (!test_and_set_bit(AF_TASKLET_SCHEDULED, &a->flags))
 		tasklet_hi_schedule(&a->tasklet);
 }
 
 static inline void esas2r_enable_heartbeat(struct esas2r_adapter *a)
 {
-	if (!(a->flags & (AF_DEGRADED_MODE | AF_CHPRST_PENDING))
-	    && (a->nvram->options2 & SASNVR2_HEARTBEAT))
-		esas2r_lock_set_flags(&a->flags, AF_HEARTBEAT_ENB);
+	if (!test_bit(AF_DEGRADED_MODE, &a->flags) &&
+	    !test_bit(AF_CHPRST_PENDING, &a->flags) &&
+	    (a->nvram->options2 & SASNVR2_HEARTBEAT))
+		set_bit(AF_HEARTBEAT_ENB, &a->flags);
 	else
-		esas2r_lock_clear_flags(&a->flags, AF_HEARTBEAT_ENB);
+		clear_bit(AF_HEARTBEAT_ENB, &a->flags);
 }
 
 static inline void esas2r_disable_heartbeat(struct esas2r_adapter *a)
 {
-	esas2r_lock_clear_flags(&a->flags, AF_HEARTBEAT_ENB);
-	esas2r_lock_clear_flags(&a->flags, AF_HEARTBEAT);
+	clear_bit(AF_HEARTBEAT_ENB, &a->flags);
+	clear_bit(AF_HEARTBEAT, &a->flags);
 }
 
 /* Set the initial state for resetting the adapter on the next pass through
@@ -1372,9 +1365,9 @@ static inline void esas2r_local_reset_adapter(struct esas2r_adapter *a)
 {
 	esas2r_disable_heartbeat(a);
 
-	esas2r_lock_set_flags(&a->flags, AF_CHPRST_NEEDED);
-	esas2r_lock_set_flags(&a->flags, AF_CHPRST_PENDING);
-	esas2r_lock_set_flags(&a->flags, AF_DISC_PENDING);
+	set_bit(AF_CHPRST_NEEDED, &a->flags);
+	set_bit(AF_CHPRST_PENDING, &a->flags);
+	set_bit(AF_DISC_PENDING, &a->flags);
 }
 
 /* See if an interrupt is pending on the adapter. */
diff --git a/drivers/scsi/esas2r/esas2r_disc.c b/drivers/scsi/esas2r/esas2r_disc.c
index dec6c33..1c079f4 100644
--- a/drivers/scsi/esas2r/esas2r_disc.c
+++ b/drivers/scsi/esas2r/esas2r_disc.c
@@ -86,9 +86,9 @@ void esas2r_disc_initialize(struct esas2r_adapter *a)
 
 	esas2r_trace_enter();
 
-	esas2r_lock_clear_flags(&a->flags, AF_DISC_IN_PROG);
-	esas2r_lock_clear_flags(&a->flags2, AF2_DEV_SCAN);
-	esas2r_lock_clear_flags(&a->flags2, AF2_DEV_CNT_OK);
+	clear_bit(AF_DISC_IN_PROG, &a->flags);
+	clear_bit(AF2_DEV_SCAN, &a->flags2);
+	clear_bit(AF2_DEV_CNT_OK, &a->flags2);
 
 	a->disc_start_time = jiffies_to_msecs(jiffies);
 	a->disc_wait_time = nvr->dev_wait_time * 1000;
@@ -107,7 +107,8 @@ void esas2r_disc_initialize(struct esas2r_adapter *a)
 
 	a->general_req.interrupt_cx = NULL;
 
-	if (a->flags & (AF_CHPRST_DETECTED | AF_POWER_MGT)) {
+	if (test_bit(AF_CHPRST_DETECTED, &a->flags) ||
+	    test_bit(AF_POWER_MGT, &a->flags)) {
 		if (a->prev_dev_cnt == 0) {
 			/* Don't bother waiting if there is nothing to wait
 			 * for.
@@ -212,9 +213,7 @@ void esas2r_disc_check_complete(struct esas2r_adapter *a)
 			|| a->disc_wait_cnt == 0)) {
 			/* After three seconds of waiting, schedule a scan. */
 			if (time >= 3000
-			    && !(esas2r_lock_set_flags(&a->flags2,
-						       AF2_DEV_SCAN) &
-				 ilog2(AF2_DEV_SCAN))) {
+			    && !test_and_set_bit(AF2_DEV_SCAN, &a->flags2)) {
 				spin_lock_irqsave(&a->mem_lock, flags);
 				esas2r_disc_queue_event(a, DCDE_DEV_SCAN);
 				spin_unlock_irqrestore(&a->mem_lock, flags);
@@ -228,18 +227,14 @@ void esas2r_disc_check_complete(struct esas2r_adapter *a)
 		 * We are done waiting...we think.  Adjust the wait time to
 		 * consume events after the count is met.
 		 */
-		if (!(esas2r_lock_set_flags(&a->flags2, AF2_DEV_CNT_OK)
-		      & ilog2(AF2_DEV_CNT_OK)))
+		if (!test_and_set_bit(AF2_DEV_CNT_OK, &a->flags2))
 			a->disc_wait_time = time + 3000;
 
 		/* If we haven't done a full scan yet, do it now. */
-		if (!(esas2r_lock_set_flags(&a->flags2,
-					    AF2_DEV_SCAN) &
-		      ilog2(AF2_DEV_SCAN))) {
+		if (!test_and_set_bit(AF2_DEV_SCAN, &a->flags2)) {
 			spin_lock_irqsave(&a->mem_lock, flags);
 			esas2r_disc_queue_event(a, DCDE_DEV_SCAN);
 			spin_unlock_irqrestore(&a->mem_lock, flags);
-
 			esas2r_trace_exit();
 			return;
 		}
@@ -253,9 +248,7 @@ void esas2r_disc_check_complete(struct esas2r_adapter *a)
 			return;
 		}
 	} else {
-		if (!(esas2r_lock_set_flags(&a->flags2,
-					    AF2_DEV_SCAN) &
-		      ilog2(AF2_DEV_SCAN))) {
+		if (!test_and_set_bit(AF2_DEV_SCAN, &a->flags2)) {
 			spin_lock_irqsave(&a->mem_lock, flags);
 			esas2r_disc_queue_event(a, DCDE_DEV_SCAN);
 			spin_unlock_irqrestore(&a->mem_lock, flags);
@@ -265,8 +258,8 @@ void esas2r_disc_check_complete(struct esas2r_adapter *a)
 	/* We want to stop waiting for devices. */
 	a->disc_wait_time = 0;
 
-	if ((a->flags & AF_DISC_POLLED)
-	    && (a->flags & AF_DISC_IN_PROG)) {
+	if (test_bit(AF_DISC_POLLED, &a->flags) &&
+	    test_bit(AF_DISC_IN_PROG, &a->flags)) {
 		/*
 		 * Polled discovery is still pending so continue the active
 		 * discovery until it is done.  At that point, we will stop
@@ -280,14 +273,14 @@ void esas2r_disc_check_complete(struct esas2r_adapter *a)
 		 * driven; i.e. There is no transition.
 		 */
 		esas2r_disc_fix_curr_requests(a);
-		esas2r_lock_clear_flags(&a->flags, AF_DISC_PENDING);
+		clear_bit(AF_DISC_PENDING, &a->flags);
 
 		/*
 		 * We have deferred target state changes until now because we
 		 * don't want to report any removals (due to the first arrival)
 		 * until the device wait time expires.
 		 */
-		esas2r_lock_set_flags(&a->flags, AF_PORT_CHANGE);
+		set_bit(AF_PORT_CHANGE, &a->flags);
 	}
 
 	esas2r_trace_exit();
@@ -308,7 +301,8 @@ void esas2r_disc_queue_event(struct esas2r_adapter *a, u8 disc_evt)
 	 * Don't start discovery before or during polled discovery.  if we did,
 	 * we would have a deadlock if we are in the ISR already.
 	 */
-	if (!(a->flags & (AF_CHPRST_PENDING | AF_DISC_POLLED)))
+	if (!test_bit(AF_CHPRST_PENDING, &a->flags) &&
+	    !test_bit(AF_DISC_POLLED, &a->flags))
 		esas2r_disc_start_port(a);
 
 	esas2r_trace_exit();
@@ -322,7 +316,7 @@ bool esas2r_disc_start_port(struct esas2r_adapter *a)
 
 	esas2r_trace_enter();
 
-	if (a->flags & AF_DISC_IN_PROG) {
+	if (test_bit(AF_DISC_IN_PROG, &a->flags)) {
 		esas2r_trace_exit();
 
 		return false;
@@ -330,7 +324,7 @@ bool esas2r_disc_start_port(struct esas2r_adapter *a)
 
 	/* If there is a discovery waiting, process it. */
 	if (dc->disc_evt) {
-		if ((a->flags & AF_DISC_POLLED)
+		if (test_bit(AF_DISC_POLLED, &a->flags)
 		    && a->disc_wait_time == 0) {
 			/*
 			 * We are doing polled discovery, but we no longer want
@@ -347,7 +341,7 @@ bool esas2r_disc_start_port(struct esas2r_adapter *a)
 
 		esas2r_hdebug("disc done");
 
-		esas2r_lock_set_flags(&a->flags, AF_PORT_CHANGE);
+		set_bit(AF_PORT_CHANGE, &a->flags);
 
 		esas2r_trace_exit();
 
@@ -356,10 +350,10 @@ bool esas2r_disc_start_port(struct esas2r_adapter *a)
 
 	/* Handle the discovery context */
 	esas2r_trace("disc_evt: %d", dc->disc_evt);
-	esas2r_lock_set_flags(&a->flags, AF_DISC_IN_PROG);
+	set_bit(AF_DISC_IN_PROG, &a->flags);
 	dc->flags = 0;
 
-	if (a->flags & AF_DISC_POLLED)
+	if (test_bit(AF_DISC_POLLED, &a->flags))
 		dc->flags |= DCF_POLLED;
 
 	rq->interrupt_cx = dc;
@@ -379,7 +373,7 @@ bool esas2r_disc_start_port(struct esas2r_adapter *a)
 	}
 
 	/* Continue interrupt driven discovery */
-	if (!(a->flags & AF_DISC_POLLED))
+	if (!test_bit(AF_DISC_POLLED, &a->flags))
 		ret = esas2r_disc_continue(a, rq);
 	else
 		ret = true;
@@ -453,10 +447,10 @@ static bool esas2r_disc_continue(struct esas2r_adapter *a,
 	/* Discovery is done...for now. */
 	rq->interrupt_cx = NULL;
 
-	if (!(a->flags & AF_DISC_PENDING))
+	if (!test_bit(AF_DISC_PENDING, &a->flags))
 		esas2r_disc_fix_curr_requests(a);
 
-	esas2r_lock_clear_flags(&a->flags, AF_DISC_IN_PROG);
+	clear_bit(AF_DISC_IN_PROG, &a->flags);
 
 	/* Start the next discovery. */
 	return esas2r_disc_start_port(a);
@@ -480,7 +474,8 @@ static bool esas2r_disc_start_request(struct esas2r_adapter *a,
 
 	spin_lock_irqsave(&a->queue_lock, flags);
 
-	if (!(a->flags & (AF_CHPRST_PENDING | AF_FLASHING)))
+	if (!test_bit(AF_CHPRST_PENDING, &a->flags) &&
+	    !test_bit(AF_FLASHING, &a->flags))
 		esas2r_disc_local_start_request(a, rq);
 	else
 		list_add_tail(&rq->req_list, &a->defer_list);
diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
index 2ec3c23..b7dc59f 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -231,7 +231,7 @@ static bool load_image(struct esas2r_adapter *a, struct esas2r_request *rq)
 	 * RS_PENDING, FM API tasks will continue.
 	 */
 	rq->req_stat = RS_PENDING;
-	if (a->flags & AF_DEGRADED_MODE)
+	if (test_bit(AF_DEGRADED_MODE, &a->flags))
 		/* not suppported for now */;
 	else
 		build_flash_msg(a, rq);
@@ -315,7 +315,7 @@ static bool complete_fmapi_req(struct esas2r_adapter *a,
 		memset(fc->scratch, 0, FM_BUF_SZ);
 
 	esas2r_enable_heartbeat(a);
-	esas2r_lock_clear_flags(&a->flags, AF_FLASH_LOCK);
+	clear_bit(AF_FLASH_LOCK, &a->flags);
 	return false;
 }
 
@@ -526,7 +526,7 @@ no_cfg:
 			 * The download is complete.  If in degraded mode,
 			 * attempt a chip reset.
 			 */
-			if (a->flags & AF_DEGRADED_MODE)
+			if (test_bit(AF_DEGRADED_MODE, &a->flags))
 				esas2r_local_reset_adapter(a);
 
 			a->flash_ver = fi->cmp_hdr[CH_IT_BIOS].version;
@@ -890,7 +890,7 @@ bool esas2r_process_fs_ioctl(struct esas2r_adapter *a,
 		}
 	}
 
-	if (a->flags & AF_DEGRADED_MODE) {
+	if (test_bit(AF_DEGRADED_MODE, &a->flags)) {
 		fs->status = ATTO_STS_DEGRADED;
 		return false;
 	}
@@ -945,8 +945,12 @@ static bool esas2r_flash_access(struct esas2r_adapter *a, u32 function)
 
 	/* Now wait for the firmware to process it */
 	starttime = jiffies_to_msecs(jiffies);
-	timeout = a->flags &
-		  (AF_CHPRST_PENDING | AF_DISC_PENDING) ? 40000 : 5000;
+
+	if (test_bit(AF_CHPRST_PENDING, &a->flags) ||
+	    test_bit(AF_DISC_PENDING, &a->flags))
+		timeout = 40000;
+	else
+		timeout = 5000;
 
 	while (true) {
 		intstat = esas2r_read_register_dword(a, MU_INT_STATUS_OUT);
@@ -1008,7 +1012,7 @@ bool esas2r_read_flash_block(struct esas2r_adapter *a,
 		u32 offset;
 		u32 iatvr;
 
-		if (a->flags2 & AF2_SERIAL_FLASH)
+		if (test_bit(AF2_SERIAL_FLASH, &a->flags2))
 			iatvr = MW_DATA_ADDR_SER_FLASH + (from & -WINDOW_SIZE);
 		else
 			iatvr = MW_DATA_ADDR_PAR_FLASH + (from & -WINDOW_SIZE);
@@ -1236,9 +1240,9 @@ static void esas2r_nvram_callback(struct esas2r_adapter *a,
 	if (rq->req_stat != RS_PENDING) {
 		/* update the NVRAM state */
 		if (rq->req_stat == RS_SUCCESS)
-			esas2r_lock_set_flags(&a->flags, AF_NVR_VALID);
+			set_bit(AF_NVR_VALID, &a->flags);
 		else
-			esas2r_lock_clear_flags(&a->flags, AF_NVR_VALID);
+			clear_bit(AF_NVR_VALID, &a->flags);
 
 		esas2r_enable_heartbeat(a);
 
@@ -1258,7 +1262,7 @@ bool esas2r_nvram_write(struct esas2r_adapter *a, struct esas2r_request *rq,
 	u32 *sas_address_dwords = (u32 *)&sas_address_bytes[0];
 	struct atto_vda_flash_req *vrq = &rq->vrq->flash;
 
-	if (a->flags & AF_DEGRADED_MODE)
+	if (test_bit(AF_DEGRADED_MODE, &a->flags))
 		return false;
 
 	if (down_interruptible(&a->nvram_semaphore))
@@ -1302,7 +1306,7 @@ bool esas2r_nvram_write(struct esas2r_adapter *a, struct esas2r_request *rq,
 			       FLS_OFFSET_NVR,
 			       sizeof(struct esas2r_sas_nvram));
 
-	if (a->flags & AF_LEGACY_SGE_MODE) {
+	if (test_bit(AF_LEGACY_SGE_MODE, &a->flags)) {
 
 		vrq->data.sge[0].length =
 			cpu_to_le32(SGE_LAST |
@@ -1337,7 +1341,7 @@ bool esas2r_nvram_validate(struct esas2r_adapter *a)
 	} else if (n->version > SASNVR_VERSION) {
 		esas2r_hdebug("invalid NVRAM version");
 	} else {
-		esas2r_lock_set_flags(&a->flags, AF_NVR_VALID);
+		set_bit(AF_NVR_VALID, &a->flags);
 		rslt = true;
 	}
 
@@ -1359,7 +1363,7 @@ void esas2r_nvram_set_defaults(struct esas2r_adapter *a)
 	struct esas2r_sas_nvram *n = a->nvram;
 	u32 time = jiffies_to_msecs(jiffies);
 
-	esas2r_lock_clear_flags(&a->flags, AF_NVR_VALID);
+	clear_bit(AF_NVR_VALID, &a->flags);
 	*n = default_sas_nvram;
 	n->sas_addr[3] |= 0x0F;
 	n->sas_addr[4] = HIBYTE(LOWORD(time));
@@ -1389,7 +1393,7 @@ bool esas2r_fm_api(struct esas2r_adapter *a, struct esas2r_flash_img *fi,
 	u8 j;
 	struct esas2r_component_header *ch;
 
-	if (esas2r_lock_set_flags(&a->flags, AF_FLASH_LOCK) & AF_FLASH_LOCK) {
+	if (test_and_set_bit(AF_FLASH_LOCK, &a->flags)) {
 		/* flag was already set */
 		fi->status = FI_STAT_BUSY;
 		return false;
@@ -1413,7 +1417,7 @@ bool esas2r_fm_api(struct esas2r_adapter *a, struct esas2r_flash_img *fi,
 		return complete_fmapi_req(a, rq, FI_STAT_IMG_VER);
 	}
 
-	if (a->flags & AF_DEGRADED_MODE)
+	if (test_bit(AF_DEGRADED_MODE, &a->flags))
 		return complete_fmapi_req(a, rq, FI_STAT_DEGRADED);
 
 	switch (fi->action) {
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index da1869d..15d222b 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -216,7 +216,7 @@ use_legacy_interrupts:
 			goto use_legacy_interrupts;
 		}
 		a->intr_mode = INTR_MODE_MSI;
-		esas2r_lock_set_flags(&a->flags2, AF2_MSI_ENABLED);
+		set_bit(AF2_MSI_ENABLED, &a->flags2);
 		break;
 
 
@@ -252,7 +252,7 @@ static void esas2r_claim_interrupts(struct esas2r_adapter *a)
 		return;
 	}
 
-	esas2r_lock_set_flags(&a->flags2, AF2_IRQ_CLAIMED);
+	set_bit(AF2_IRQ_CLAIMED, &a->flags2);
 	esas2r_log(ESAS2R_LOG_INFO,
 		   "claimed IRQ %d flags: 0x%lx",
 		   a->pcid->irq, flags);
@@ -380,10 +380,10 @@ int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
 	/* interrupts will be disabled until we are done with init */
 	atomic_inc(&a->dis_ints_cnt);
 	atomic_inc(&a->disable_cnt);
-	a->flags |= AF_CHPRST_PENDING
-		    | AF_DISC_PENDING
-		    | AF_FIRST_INIT
-		    | AF_LEGACY_SGE_MODE;
+	set_bit(AF_CHPRST_PENDING, &a->flags);
+	set_bit(AF_DISC_PENDING, &a->flags);
+	set_bit(AF_FIRST_INIT, &a->flags);
+	set_bit(AF_LEGACY_SGE_MODE, &a->flags);
 
 	a->init_msg = ESAS2R_INIT_MSG_START;
 	a->max_vdareq_size = 128;
@@ -440,11 +440,11 @@ int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
 
 	esas2r_claim_interrupts(a);
 
-	if (a->flags2 & AF2_IRQ_CLAIMED)
+	if (test_bit(AF2_IRQ_CLAIMED, &a->flags2))
 		esas2r_enable_chip_interrupts(a);
 
-	esas2r_lock_set_flags(&a->flags2, AF2_INIT_DONE);
-	if (!(a->flags & AF_DEGRADED_MODE))
+	set_bit(AF2_INIT_DONE, &a->flags2);
+	if (!test_bit(AF_DEGRADED_MODE, &a->flags))
 		esas2r_kickoff_timer(a);
 	esas2r_debug("esas2r_init_adapter done for %p (%d)",
 		     a, a->disable_cnt);
@@ -457,8 +457,8 @@ static void esas2r_adapter_power_down(struct esas2r_adapter *a,
 {
 	struct esas2r_mem_desc *memdesc, *next;
 
-	if ((a->flags2 & AF2_INIT_DONE)
-	    &&  (!(a->flags & AF_DEGRADED_MODE))) {
+	if ((test_bit(AF2_INIT_DONE, &a->flags2))
+	    &&  (!test_bit(AF_DEGRADED_MODE, &a->flags))) {
 		if (!power_management) {
 			del_timer_sync(&a->timer);
 			tasklet_kill(&a->tasklet);
@@ -508,19 +508,19 @@ static void esas2r_adapter_power_down(struct esas2r_adapter *a,
 	}
 
 	/* Clean up interrupts */
-	if (a->flags2 & AF2_IRQ_CLAIMED) {
+	if (test_bit(AF2_IRQ_CLAIMED, &a->flags2)) {
 		esas2r_log_dev(ESAS2R_LOG_INFO,
 			       &(a->pcid->dev),
 			       "free_irq(%d) called", a->pcid->irq);
 
 		free_irq(a->pcid->irq, a);
 		esas2r_debug("IRQ released");
-		esas2r_lock_clear_flags(&a->flags2, AF2_IRQ_CLAIMED);
+		clear_bit(AF2_IRQ_CLAIMED, &a->flags2);
 	}
 
-	if (a->flags2 & AF2_MSI_ENABLED) {
+	if (test_bit(AF2_MSI_ENABLED, &a->flags2)) {
 		pci_disable_msi(a->pcid);
-		esas2r_lock_clear_flags(&a->flags2, AF2_MSI_ENABLED);
+		clear_bit(AF2_MSI_ENABLED, &a->flags2);
 		esas2r_debug("MSI disabled");
 	}
 
@@ -641,12 +641,10 @@ void esas2r_kill_adapter(int i)
 		pci_set_drvdata(a->pcid, NULL);
 		esas2r_adapters[i] = NULL;
 
-		if (a->flags2 & AF2_INIT_DONE) {
-			esas2r_lock_clear_flags(&a->flags2,
-						AF2_INIT_DONE);
+		if (test_bit(AF2_INIT_DONE, &a->flags2)) {
+			clear_bit(AF2_INIT_DONE, &a->flags2);
 
-			esas2r_lock_set_flags(&a->flags,
-					      AF_DEGRADED_MODE);
+			set_bit(AF_DEGRADED_MODE, &a->flags);
 
 			esas2r_log_dev(ESAS2R_LOG_INFO,
 				       &(a->host->shost_gendev),
@@ -759,7 +757,7 @@ int esas2r_resume(struct pci_dev *pdev)
 
 	esas2r_claim_interrupts(a);
 
-	if (a->flags2 & AF2_IRQ_CLAIMED) {
+	if (test_bit(AF2_IRQ_CLAIMED, &a->flags2)) {
 		/*
 		 * Now that system interrupt(s) are claimed, we can enable
 		 * chip interrupts.
@@ -781,7 +779,7 @@ error_exit:
 
 bool esas2r_set_degraded_mode(struct esas2r_adapter *a, char *error_str)
 {
-	esas2r_lock_set_flags(&a->flags, AF_DEGRADED_MODE);
+	set_bit(AF_DEGRADED_MODE, &a->flags);
 	esas2r_log(ESAS2R_LOG_CRIT,
 		   "setting adapter to degraded mode: %s\n", error_str);
 	return false;
@@ -896,7 +894,7 @@ bool esas2r_init_adapter_struct(struct esas2r_adapter *a,
 	    && (a->pcid->subsystem_device & ATTO_SSDID_TBT))
 		a->flags2 |= AF2_THUNDERBOLT;
 
-	if (a->flags2 & AF2_THUNDERBOLT)
+	if (test_bit(AF2_THUNDERBOLT, &a->flags2))
 		a->flags2 |= AF2_SERIAL_FLASH;
 
 	if (a->pcid->subsystem_device == ATTO_TLSH_1068)
@@ -956,14 +954,14 @@ bool esas2r_init_adapter_struct(struct esas2r_adapter *a,
 	a->outbound_copy = (u32 volatile *)high;
 	high += sizeof(u32);
 
-	if (!(a->flags & AF_NVR_VALID))
+	if (!test_bit(AF_NVR_VALID, &a->flags))
 		esas2r_nvram_set_defaults(a);
 
 	/* update the caller's uncached memory area pointer */
 	*uncached_area = (void *)high;
 
 	/* initialize the allocated memory */
-	if (a->flags & AF_FIRST_INIT) {
+	if (test_bit(AF_FIRST_INIT, &a->flags)) {
 		memset(a->req_table, 0,
 		       (num_requests + num_ae_requests +
 			1) * sizeof(struct esas2r_request *));
@@ -1019,7 +1017,7 @@ bool esas2r_check_adapter(struct esas2r_adapter *a)
 	 * if the chip reset detected flag is set, we can bypass a bunch of
 	 * stuff.
 	 */
-	if (a->flags & AF_CHPRST_DETECTED)
+	if (test_bit(AF_CHPRST_DETECTED, &a->flags))
 		goto skip_chip_reset;
 
 	/*
@@ -1057,14 +1055,12 @@ bool esas2r_check_adapter(struct esas2r_adapter *a)
 						    doorbell);
 
 			if (ver == DRBL_FW_VER_0) {
-				esas2r_lock_set_flags(&a->flags,
-						      AF_LEGACY_SGE_MODE);
+				set_bit(AF_LEGACY_SGE_MODE, &a->flags);
 
 				a->max_vdareq_size = 128;
 				a->build_sgl = esas2r_build_sg_list_sge;
 			} else if (ver == DRBL_FW_VER_1) {
-				esas2r_lock_clear_flags(&a->flags,
-							AF_LEGACY_SGE_MODE);
+				clear_bit(AF_LEGACY_SGE_MODE, &a->flags);
 
 				a->max_vdareq_size = 1024;
 				a->build_sgl = esas2r_build_sg_list_prd;
@@ -1139,7 +1135,7 @@ skip_chip_reset:
 	*a->outbound_copy =
 		a->last_write =
 			a->last_read = a->list_size - 1;
-	esas2r_lock_set_flags(&a->flags, AF_COMM_LIST_TOGGLE);
+	set_bit(AF_COMM_LIST_TOGGLE, &a->flags);
 	esas2r_write_register_dword(a, MU_IN_LIST_WRITE, MU_ILW_TOGGLE |
 				    a->last_write);
 	esas2r_write_register_dword(a, MU_OUT_LIST_COPY, MU_OLC_TOGGLE |
@@ -1204,9 +1200,9 @@ skip_chip_reset:
 	 */
 	doorbell = esas2r_read_register_dword(a, MU_DOORBELL_IN_ENB);
 	if (doorbell & DRBL_POWER_DOWN)
-		esas2r_lock_set_flags(&a->flags2, AF2_VDA_POWER_DOWN);
+		set_bit(AF2_VDA_POWER_DOWN, &a->flags2);
 	else
-		esas2r_lock_clear_flags(&a->flags2, AF2_VDA_POWER_DOWN);
+		clear_bit(AF2_VDA_POWER_DOWN, &a->flags2);
 
 	/*
 	 * enable assertion of outbound queue and doorbell interrupts in the
@@ -1266,9 +1262,8 @@ static bool esas2r_format_init_msg(struct esas2r_adapter *a,
 		 * unsupported config requests correctly.
 		 */
 
-		if ((a->flags2 & AF2_THUNDERBOLT)
-		    || (be32_to_cpu(a->fw_version) >
-			be32_to_cpu(0x47020052))) {
+		if ((test_bit(AF2_THUNDERBOLT, &a->flags2))
+		    || (be32_to_cpu(a->fw_version) > 0x00524702)) {
 			esas2r_hdebug("CFG get init");
 			esas2r_build_cfg_req(a,
 					     rq,
@@ -1361,10 +1356,10 @@ bool esas2r_init_adapter_hw(struct esas2r_adapter *a, bool init_poll)
 	struct esas2r_request *rq;
 	u32 i;
 
-	if (a->flags & AF_DEGRADED_MODE)
+	if (test_bit(AF_DEGRADED_MODE, &a->flags))
 		goto exit;
 
-	if (!(a->flags & AF_NVR_VALID)) {
+	if (!test_bit(AF_NVR_VALID, &a->flags)) {
 		if (!esas2r_nvram_read_direct(a))
 			esas2r_log(ESAS2R_LOG_WARN,
 				   "invalid/missing NVRAM parameters");
@@ -1376,8 +1371,8 @@ bool esas2r_init_adapter_hw(struct esas2r_adapter *a, bool init_poll)
 	}
 
 	/* The firmware is ready. */
-	esas2r_lock_clear_flags(&a->flags, AF_DEGRADED_MODE);
-	esas2r_lock_clear_flags(&a->flags, AF_CHPRST_PENDING);
+	clear_bit(AF_DEGRADED_MODE, &a->flags);
+	clear_bit(AF_CHPRST_PENDING, &a->flags);
 
 	/* Post all the async event requests */
 	for (i = 0, rq = a->first_ae_req; i < num_ae_requests; i++, rq++)
@@ -1398,8 +1393,8 @@ bool esas2r_init_adapter_hw(struct esas2r_adapter *a, bool init_poll)
 
 	esas2r_hdebug("firmware revision: %s", a->fw_rev);
 
-	if ((a->flags & AF_CHPRST_DETECTED)
-	    && (a->flags & AF_FIRST_INIT)) {
+	if (test_bit(AF_CHPRST_DETECTED, &a->flags)
+	    && (test_bit(AF_FIRST_INIT, &a->flags))) {
 		esas2r_enable_chip_interrupts(a);
 		return true;
 	}
@@ -1423,18 +1418,18 @@ bool esas2r_init_adapter_hw(struct esas2r_adapter *a, bool init_poll)
 		 * Block Tasklets from getting scheduled and indicate this is
 		 * polled discovery.
 		 */
-		esas2r_lock_set_flags(&a->flags, AF_TASKLET_SCHEDULED);
-		esas2r_lock_set_flags(&a->flags, AF_DISC_POLLED);
+		set_bit(AF_TASKLET_SCHEDULED, &a->flags);
+		set_bit(AF_DISC_POLLED, &a->flags);
 
 		/*
 		 * Temporarily bring the disable count to zero to enable
 		 * deferred processing.  Note that the count is already zero
 		 * after the first initialization.
 		 */
-		if (a->flags & AF_FIRST_INIT)
+		if (test_bit(AF_FIRST_INIT, &a->flags))
 			atomic_dec(&a->disable_cnt);
 
-		while (a->flags & AF_DISC_PENDING) {
+		while (test_bit(AF_DISC_PENDING, &a->flags)) {
 			schedule_timeout_interruptible(msecs_to_jiffies(100));
 
 			/*
@@ -1453,7 +1448,7 @@ bool esas2r_init_adapter_hw(struct esas2r_adapter *a, bool init_poll)
 			 * we have to make sure the timer tick processes the
 			 * doorbell indicating the firmware is ready.
 			 */
-			if (!(a->flags & AF_CHPRST_PENDING))
+			if (!test_bit(AF_CHPRST_PENDING, &a->flags))
 				esas2r_disc_check_for_work(a);
 
 			/* Simulate a timer tick. */
@@ -1473,11 +1468,11 @@ bool esas2r_init_adapter_hw(struct esas2r_adapter *a, bool init_poll)
 
 		}
 
-		if (a->flags & AF_FIRST_INIT)
+		if (test_bit(AF_FIRST_INIT, &a->flags))
 			atomic_inc(&a->disable_cnt);
 
-		esas2r_lock_clear_flags(&a->flags, AF_DISC_POLLED);
-		esas2r_lock_clear_flags(&a->flags, AF_TASKLET_SCHEDULED);
+		clear_bit(AF_DISC_POLLED, &a->flags);
+		clear_bit(AF_TASKLET_SCHEDULED, &a->flags);
 	}
 
 
@@ -1504,26 +1499,26 @@ exit:
 	 * need to get done before we exit.
 	 */
 
-	if ((a->flags & AF_CHPRST_DETECTED)
-	    && (a->flags & AF_FIRST_INIT)) {
+	if (test_bit(AF_CHPRST_DETECTED, &a->flags) &&
+	    test_bit(AF_FIRST_INIT, &a->flags)) {
 		/*
 		 * Reinitialization was performed during the first
 		 * initialization.  Only clear the chip reset flag so the
 		 * original device polling is not cancelled.
 		 */
 		if (!rslt)
-			esas2r_lock_clear_flags(&a->flags, AF_CHPRST_PENDING);
+			clear_bit(AF_CHPRST_PENDING, &a->flags);
 	} else {
 		/* First initialization or a subsequent re-init is complete. */
 		if (!rslt) {
-			esas2r_lock_clear_flags(&a->flags, AF_CHPRST_PENDING);
-			esas2r_lock_clear_flags(&a->flags, AF_DISC_PENDING);
+			clear_bit(AF_CHPRST_PENDING, &a->flags);
+			clear_bit(AF_DISC_PENDING, &a->flags);
 		}
 
 
 		/* Enable deferred processing after the first initialization. */
-		if (a->flags & AF_FIRST_INIT) {
-			esas2r_lock_clear_flags(&a->flags, AF_FIRST_INIT);
+		if (test_bit(AF_FIRST_INIT, &a->flags)) {
+			clear_bit(AF_FIRST_INIT, &a->flags);
 
 			if (atomic_dec_return(&a->disable_cnt) == 0)
 				esas2r_do_deferred_processes(a);
@@ -1535,7 +1530,7 @@ exit:
 
 void esas2r_reset_adapter(struct esas2r_adapter *a)
 {
-	esas2r_lock_set_flags(&a->flags, AF_OS_RESET);
+	set_bit(AF_OS_RESET, &a->flags);
 	esas2r_local_reset_adapter(a);
 	esas2r_schedule_tasklet(a);
 }
@@ -1550,17 +1545,17 @@ void esas2r_reset_chip(struct esas2r_adapter *a)
 	 * dump is located in the upper 512KB of the onchip SRAM.  Make sure
 	 * to not overwrite a previous crash that was saved.
 	 */
-	if ((a->flags2 & AF2_COREDUMP_AVAIL)
-	    && !(a->flags2 & AF2_COREDUMP_SAVED)) {
+	if (test_bit(AF2_COREDUMP_AVAIL, &a->flags2) &&
+	    !test_bit(AF2_COREDUMP_SAVED, &a->flags2)) {
 		esas2r_read_mem_block(a,
 				      a->fw_coredump_buff,
 				      MW_DATA_ADDR_SRAM + 0x80000,
 				      ESAS2R_FWCOREDUMP_SZ);
 
-		esas2r_lock_set_flags(&a->flags2, AF2_COREDUMP_SAVED);
+		set_bit(AF2_COREDUMP_SAVED, &a->flags2);
 	}
 
-	esas2r_lock_clear_flags(&a->flags2, AF2_COREDUMP_AVAIL);
+	clear_bit(AF2_COREDUMP_AVAIL, &a->flags2);
 
 	/* Reset the chip */
 	if (a->pcid->revision == MVR_FREY_B2)
@@ -1606,10 +1601,10 @@ static void esas2r_power_down_notify_firmware(struct esas2r_adapter *a)
  */
 void esas2r_power_down(struct esas2r_adapter *a)
 {
-	esas2r_lock_set_flags(&a->flags, AF_POWER_MGT);
-	esas2r_lock_set_flags(&a->flags, AF_POWER_DOWN);
+	set_bit(AF_POWER_MGT, &a->flags);
+	set_bit(AF_POWER_DOWN, &a->flags);
 
-	if (!(a->flags & AF_DEGRADED_MODE)) {
+	if (!test_bit(AF_DEGRADED_MODE, &a->flags)) {
 		u32 starttime;
 		u32 doorbell;
 
@@ -1649,14 +1644,14 @@ void esas2r_power_down(struct esas2r_adapter *a)
 		 * For versions of firmware that support it tell them the driver
 		 * is powering down.
 		 */
-		if (a->flags2 & AF2_VDA_POWER_DOWN)
+		if (test_bit(AF2_VDA_POWER_DOWN, &a->flags2))
 			esas2r_power_down_notify_firmware(a);
 	}
 
 	/* Suspend I/O processing. */
-	esas2r_lock_set_flags(&a->flags, AF_OS_RESET);
-	esas2r_lock_set_flags(&a->flags, AF_DISC_PENDING);
-	esas2r_lock_set_flags(&a->flags, AF_CHPRST_PENDING);
+	set_bit(AF_OS_RESET, &a->flags);
+	set_bit(AF_DISC_PENDING, &a->flags);
+	set_bit(AF_CHPRST_PENDING, &a->flags);
 
 	esas2r_process_adapter_reset(a);
 
@@ -1673,9 +1668,9 @@ bool esas2r_power_up(struct esas2r_adapter *a, bool init_poll)
 {
 	bool ret;
 
-	esas2r_lock_clear_flags(&a->flags, AF_POWER_DOWN);
+	clear_bit(AF_POWER_DOWN, &a->flags);
 	esas2r_init_pci_cfg_space(a);
-	esas2r_lock_set_flags(&a->flags, AF_FIRST_INIT);
+	set_bit(AF_FIRST_INIT, &a->flags);
 	atomic_inc(&a->disable_cnt);
 
 	/* reinitialize the adapter */
@@ -1687,17 +1682,17 @@ bool esas2r_power_up(struct esas2r_adapter *a, bool init_poll)
 	esas2r_send_reset_ae(a, true);
 
 	/* clear this flag after initialization. */
-	esas2r_lock_clear_flags(&a->flags, AF_POWER_MGT);
+	clear_bit(AF_POWER_MGT, &a->flags);
 	return ret;
 }
 
 bool esas2r_is_adapter_present(struct esas2r_adapter *a)
 {
-	if (a->flags & AF_NOT_PRESENT)
+	if (test_bit(AF_NOT_PRESENT, &a->flags))
 		return false;
 
 	if (esas2r_read_register_dword(a, MU_DOORBELL_OUT) == 0xFFFFFFFF) {
-		esas2r_lock_set_flags(&a->flags, AF_NOT_PRESENT);
+		set_bit(AF_NOT_PRESENT, &a->flags);
 
 		return false;
 	}
diff --git a/drivers/scsi/esas2r/esas2r_int.c b/drivers/scsi/esas2r/esas2r_int.c
index c2d4ff5..f16d6bc 100644
--- a/drivers/scsi/esas2r/esas2r_int.c
+++ b/drivers/scsi/esas2r/esas2r_int.c
@@ -96,7 +96,7 @@ irqreturn_t esas2r_interrupt(int irq, void *dev_id)
 	if (!esas2r_adapter_interrupt_pending(a))
 		return IRQ_NONE;
 
-	esas2r_lock_set_flags(&a->flags2, AF2_INT_PENDING);
+	set_bit(AF2_INT_PENDING, &a->flags2);
 	esas2r_schedule_tasklet(a);
 
 	return IRQ_HANDLED;
@@ -317,9 +317,10 @@ void esas2r_do_deferred_processes(struct esas2r_adapter *a)
 	 *  = 2 - can start any request
 	 */
 
-	if (a->flags & (AF_CHPRST_PENDING | AF_FLASHING))
+	if (test_bit(AF_CHPRST_PENDING, &a->flags) ||
+	    test_bit(AF_FLASHING, &a->flags))
 		startreqs = 0;
-	else if (a->flags & AF_DISC_PENDING)
+	else if (test_bit(AF_DISC_PENDING, &a->flags))
 		startreqs = 1;
 
 	atomic_inc(&a->disable_cnt);
@@ -367,7 +368,7 @@ void esas2r_do_deferred_processes(struct esas2r_adapter *a)
 				 * Flashing could have been set by last local
 				 * start
 				 */
-				if (a->flags & AF_FLASHING)
+				if (test_bit(AF_FLASHING, &a->flags))
 					break;
 			}
 		}
@@ -404,7 +405,7 @@ void esas2r_process_adapter_reset(struct esas2r_adapter *a)
 
 		dc->disc_evt = 0;
 
-		esas2r_lock_clear_flags(&a->flags, AF_DISC_IN_PROG);
+		clear_bit(AF_DISC_IN_PROG, &a->flags);
 	}
 
 	/*
@@ -425,7 +426,7 @@ void esas2r_process_adapter_reset(struct esas2r_adapter *a)
 		a->last_write =
 			a->last_read = a->list_size - 1;
 
-	esas2r_lock_set_flags(&a->flags, AF_COMM_LIST_TOGGLE);
+	set_bit(AF_COMM_LIST_TOGGLE, &a->flags);
 
 	/* Kill all the requests on the active list */
 	list_for_each(element, &a->defer_list) {
@@ -470,7 +471,7 @@ static void esas2r_process_bus_reset(struct esas2r_adapter *a)
 	if (atomic_read(&a->disable_cnt) == 0)
 		esas2r_do_deferred_processes(a);
 
-	esas2r_lock_clear_flags(&a->flags, AF_OS_RESET);
+	clear_bit(AF_OS_RESET, &a->flags);
 
 	esas2r_trace_exit();
 }
@@ -478,10 +479,10 @@ static void esas2r_process_bus_reset(struct esas2r_adapter *a)
 static void esas2r_chip_rst_needed_during_tasklet(struct esas2r_adapter *a)
 {
 
-	esas2r_lock_clear_flags(&a->flags, AF_CHPRST_NEEDED);
-	esas2r_lock_clear_flags(&a->flags, AF_BUSRST_NEEDED);
-	esas2r_lock_clear_flags(&a->flags, AF_BUSRST_DETECTED);
-	esas2r_lock_clear_flags(&a->flags, AF_BUSRST_PENDING);
+	clear_bit(AF_CHPRST_NEEDED, &a->flags);
+	clear_bit(AF_BUSRST_NEEDED, &a->flags);
+	clear_bit(AF_BUSRST_DETECTED, &a->flags);
+	clear_bit(AF_BUSRST_PENDING, &a->flags);
 	/*
 	 * Make sure we don't get attempt more than 3 resets
 	 * when the uptime between resets does not exceed one
@@ -507,10 +508,10 @@ static void esas2r_chip_rst_needed_during_tasklet(struct esas2r_adapter *a)
 		 * prevent the heartbeat from trying to recover.
 		 */
 
-		esas2r_lock_set_flags(&a->flags, AF_DEGRADED_MODE);
-		esas2r_lock_set_flags(&a->flags, AF_DISABLED);
-		esas2r_lock_clear_flags(&a->flags, AF_CHPRST_PENDING);
-		esas2r_lock_clear_flags(&a->flags, AF_DISC_PENDING);
+		set_bit(AF_DEGRADED_MODE, &a->flags);
+		set_bit(AF_DISABLED, &a->flags);
+		clear_bit(AF_CHPRST_PENDING, &a->flags);
+		clear_bit(AF_DISC_PENDING, &a->flags);
 
 		esas2r_disable_chip_interrupts(a);
 		a->int_mask = 0;
@@ -519,18 +520,17 @@ static void esas2r_chip_rst_needed_during_tasklet(struct esas2r_adapter *a)
 		esas2r_log(ESAS2R_LOG_CRIT,
 			   "Adapter disabled because of hardware failure");
 	} else {
-		u32 flags =
-			esas2r_lock_set_flags(&a->flags, AF_CHPRST_STARTED);
+		bool alrdyrst = test_and_set_bit(AF_CHPRST_STARTED, &a->flags);
 
-		if (!(flags & AF_CHPRST_STARTED))
+		if (!alrdyrst)
 			/*
 			 * Only disable interrupts if this is
 			 * the first reset attempt.
 			 */
 			esas2r_disable_chip_interrupts(a);
 
-		if ((a->flags & AF_POWER_MGT) && !(a->flags & AF_FIRST_INIT) &&
-		    !(flags & AF_CHPRST_STARTED)) {
+		if ((test_bit(AF_POWER_MGT, &a->flags)) &&
+		    !test_bit(AF_FIRST_INIT, &a->flags) && !alrdyrst) {
 			/*
 			 * Don't reset the chip on the first
 			 * deferred power up attempt.
@@ -543,10 +543,10 @@ static void esas2r_chip_rst_needed_during_tasklet(struct esas2r_adapter *a)
 		/* Kick off the reinitialization */
 		a->chip_uptime += ESAS2R_CHP_UPTIME_CNT;
 		a->chip_init_time = jiffies_to_msecs(jiffies);
-		if (!(a->flags & AF_POWER_MGT)) {
+		if (!test_bit(AF_POWER_MGT, &a->flags)) {
 			esas2r_process_adapter_reset(a);
 
-			if (!(flags & AF_CHPRST_STARTED)) {
+			if (!alrdyrst) {
 				/* Remove devices now that I/O is cleaned up. */
 				a->prev_dev_cnt =
 					esas2r_targ_db_get_tgt_cnt(a);
@@ -560,38 +560,37 @@ static void esas2r_chip_rst_needed_during_tasklet(struct esas2r_adapter *a)
 
 static void esas2r_handle_chip_rst_during_tasklet(struct esas2r_adapter *a)
 {
-	while (a->flags & AF_CHPRST_DETECTED) {
+	while (test_bit(AF_CHPRST_DETECTED, &a->flags)) {
 		/*
 		 * Balance the enable in esas2r_initadapter_hw.
 		 * Esas2r_power_down already took care of it for power
 		 * management.
 		 */
-		if (!(a->flags & AF_DEGRADED_MODE) && !(a->flags &
-							AF_POWER_MGT))
+		if (!test_bit(AF_DEGRADED_MODE, &a->flags) &&
+		    !test_bit(AF_POWER_MGT, &a->flags))
 			esas2r_disable_chip_interrupts(a);
 
 		/* Reinitialize the chip. */
 		esas2r_check_adapter(a);
 		esas2r_init_adapter_hw(a, 0);
 
-		if (a->flags & AF_CHPRST_NEEDED)
+		if (test_bit(AF_CHPRST_NEEDED, &a->flags))
 			break;
 
-		if (a->flags & AF_POWER_MGT) {
+		if (test_bit(AF_POWER_MGT, &a->flags)) {
 			/* Recovery from power management. */
-			if (a->flags & AF_FIRST_INIT) {
+			if (test_bit(AF_FIRST_INIT, &a->flags)) {
 				/* Chip reset during normal power up */
 				esas2r_log(ESAS2R_LOG_CRIT,
 					   "The firmware was reset during a normal power-up sequence");
 			} else {
 				/* Deferred power up complete. */
-				esas2r_lock_clear_flags(&a->flags,
-							AF_POWER_MGT);
+				clear_bit(AF_POWER_MGT, &a->flags);
 				esas2r_send_reset_ae(a, true);
 			}
 		} else {
 			/* Recovery from online chip reset. */
-			if (a->flags & AF_FIRST_INIT) {
+			if (test_bit(AF_FIRST_INIT, &a->flags)) {
 				/* Chip reset during driver load */
 			} else {
 				/* Chip reset after driver load */
@@ -602,14 +601,14 @@ static void esas2r_handle_chip_rst_during_tasklet(struct esas2r_adapter *a)
 				   "Recovering from a chip reset while the chip was online");
 		}
 
-		esas2r_lock_clear_flags(&a->flags, AF_CHPRST_STARTED);
+		clear_bit(AF_CHPRST_STARTED, &a->flags);
 		esas2r_enable_chip_interrupts(a);
 
 		/*
 		 * Clear this flag last!  this indicates that the chip has been
 		 * reset already during initialization.
 		 */
-		esas2r_lock_clear_flags(&a->flags, AF_CHPRST_DETECTED);
+		clear_bit(AF_CHPRST_DETECTED, &a->flags);
 	}
 }
 
@@ -617,26 +616,28 @@ static void esas2r_handle_chip_rst_during_tasklet(struct esas2r_adapter *a)
 /* Perform deferred tasks when chip interrupts are disabled */
 void esas2r_do_tasklet_tasks(struct esas2r_adapter *a)
 {
-	if (a->flags & (AF_CHPRST_NEEDED | AF_CHPRST_DETECTED)) {
-		if (a->flags & AF_CHPRST_NEEDED)
+
+	if (test_bit(AF_CHPRST_NEEDED, &a->flags) ||
+	    test_bit(AF_CHPRST_DETECTED, &a->flags)) {
+		if (test_bit(AF_CHPRST_NEEDED, &a->flags))
 			esas2r_chip_rst_needed_during_tasklet(a);
 
 		esas2r_handle_chip_rst_during_tasklet(a);
 	}
 
-	if (a->flags & AF_BUSRST_NEEDED) {
+	if (test_bit(AF_BUSRST_NEEDED, &a->flags)) {
 		esas2r_hdebug("hard resetting bus");
 
-		esas2r_lock_clear_flags(&a->flags, AF_BUSRST_NEEDED);
+		clear_bit(AF_BUSRST_NEEDED, &a->flags);
 
-		if (a->flags & AF_FLASHING)
-			esas2r_lock_set_flags(&a->flags, AF_BUSRST_DETECTED);
+		if (test_bit(AF_FLASHING, &a->flags))
+			set_bit(AF_BUSRST_DETECTED, &a->flags);
 		else
 			esas2r_write_register_dword(a, MU_DOORBELL_IN,
 						    DRBL_RESET_BUS);
 	}
 
-	if (a->flags & AF_BUSRST_DETECTED) {
+	if (test_bit(AF_BUSRST_DETECTED, &a->flags)) {
 		esas2r_process_bus_reset(a);
 
 		esas2r_log_dev(ESAS2R_LOG_WARN,
@@ -645,14 +646,14 @@ void esas2r_do_tasklet_tasks(struct esas2r_adapter *a)
 
 		scsi_report_bus_reset(a->host, 0);
 
-		esas2r_lock_clear_flags(&a->flags, AF_BUSRST_DETECTED);
-		esas2r_lock_clear_flags(&a->flags, AF_BUSRST_PENDING);
+		clear_bit(AF_BUSRST_DETECTED, &a->flags);
+		clear_bit(AF_BUSRST_PENDING, &a->flags);
 
 		esas2r_log(ESAS2R_LOG_WARN, "Bus reset complete");
 	}
 
-	if (a->flags & AF_PORT_CHANGE) {
-		esas2r_lock_clear_flags(&a->flags, AF_PORT_CHANGE);
+	if (test_bit(AF_PORT_CHANGE, &a->flags)) {
+		clear_bit(AF_PORT_CHANGE, &a->flags);
 
 		esas2r_targ_db_report_changes(a);
 	}
@@ -672,10 +673,10 @@ static void esas2r_doorbell_interrupt(struct esas2r_adapter *a, u32 doorbell)
 	esas2r_write_register_dword(a, MU_DOORBELL_OUT, doorbell);
 
 	if (doorbell & DRBL_RESET_BUS)
-		esas2r_lock_set_flags(&a->flags, AF_BUSRST_DETECTED);
+		set_bit(AF_BUSRST_DETECTED, &a->flags);
 
 	if (doorbell & DRBL_FORCE_INT)
-		esas2r_lock_clear_flags(&a->flags, AF_HEARTBEAT);
+		clear_bit(AF_HEARTBEAT, &a->flags);
 
 	if (doorbell & DRBL_PANIC_REASON_MASK) {
 		esas2r_hdebug("*** Firmware Panic ***");
@@ -683,7 +684,7 @@ static void esas2r_doorbell_interrupt(struct esas2r_adapter *a, u32 doorbell)
 	}
 
 	if (doorbell & DRBL_FW_RESET) {
-		esas2r_lock_set_flags(&a->flags2, AF2_COREDUMP_AVAIL);
+		set_bit(AF2_COREDUMP_AVAIL, &a->flags2);
 		esas2r_local_reset_adapter(a);
 	}
 
@@ -918,7 +919,7 @@ void esas2r_complete_request(struct esas2r_adapter *a,
 {
 	if (rq->vrq->scsi.function == VDA_FUNC_FLASH
 	    && rq->vrq->flash.sub_func == VDA_FLASH_COMMIT)
-		esas2r_lock_clear_flags(&a->flags, AF_FLASHING);
+		clear_bit(AF_FLASHING, &a->flags);
 
 	/* See if we setup a callback to do special processing */
 
diff --git a/drivers/scsi/esas2r/esas2r_io.c b/drivers/scsi/esas2r/esas2r_io.c
index 324e262..a8df916 100644
--- a/drivers/scsi/esas2r/esas2r_io.c
+++ b/drivers/scsi/esas2r/esas2r_io.c
@@ -49,7 +49,8 @@ void esas2r_start_request(struct esas2r_adapter *a, struct esas2r_request *rq)
 	struct esas2r_request *startrq = rq;
 	unsigned long flags;
 
-	if (unlikely(a->flags & (AF_DEGRADED_MODE | AF_POWER_DOWN))) {
+	if (unlikely(test_bit(AF_DEGRADED_MODE, &a->flags) ||
+		     test_bit(AF_POWER_DOWN, &a->flags))) {
 		if (rq->vrq->scsi.function == VDA_FUNC_SCSI)
 			rq->req_stat = RS_SEL2;
 		else
@@ -69,8 +70,8 @@ void esas2r_start_request(struct esas2r_adapter *a, struct esas2r_request *rq)
 			 * Note that if AF_DISC_PENDING is set than this will
 			 * go on the defer queue.
 			 */
-			if (unlikely(t->target_state != TS_PRESENT
-				     && !(a->flags & AF_DISC_PENDING)))
+			if (unlikely(t->target_state != TS_PRESENT &&
+				     !test_bit(AF_DISC_PENDING, &a->flags)))
 				rq->req_stat = RS_SEL;
 		}
 	}
@@ -91,8 +92,9 @@ void esas2r_start_request(struct esas2r_adapter *a, struct esas2r_request *rq)
 	spin_lock_irqsave(&a->queue_lock, flags);
 
 	if (likely(list_empty(&a->defer_list) &&
-		   !(a->flags &
-		     (AF_CHPRST_PENDING | AF_FLASHING | AF_DISC_PENDING))))
+		   !test_bit(AF_CHPRST_PENDING, &a->flags) &&
+		   !test_bit(AF_FLASHING, &a->flags) &&
+		   !test_bit(AF_DISC_PENDING, &a->flags)))
 		esas2r_local_start_request(a, startrq);
 	else
 		list_add_tail(&startrq->req_list, &a->defer_list);
@@ -124,7 +126,7 @@ void esas2r_local_start_request(struct esas2r_adapter *a,
 
 	if (unlikely(rq->vrq->scsi.function == VDA_FUNC_FLASH
 		     && rq->vrq->flash.sub_func == VDA_FLASH_COMMIT))
-		esas2r_lock_set_flags(&a->flags, AF_FLASHING);
+		set_bit(AF_FLASHING, &a->flags);
 
 	list_add_tail(&rq->req_list, &a->active_list);
 	esas2r_start_vda_request(a, rq);
@@ -147,11 +149,10 @@ void esas2r_start_vda_request(struct esas2r_adapter *a,
 	if (a->last_write >= a->list_size) {
 		a->last_write = 0;
 		/* update the toggle bit */
-		if (a->flags & AF_COMM_LIST_TOGGLE)
-			esas2r_lock_clear_flags(&a->flags,
-						AF_COMM_LIST_TOGGLE);
+		if (test_bit(AF_COMM_LIST_TOGGLE, &a->flags))
+			clear_bit(AF_COMM_LIST_TOGGLE, &a->flags);
 		else
-			esas2r_lock_set_flags(&a->flags, AF_COMM_LIST_TOGGLE);
+			set_bit(AF_COMM_LIST_TOGGLE, &a->flags);
 	}
 
 	element =
@@ -169,7 +170,7 @@ void esas2r_start_vda_request(struct esas2r_adapter *a,
 	/* Update the write pointer */
 	dw = a->last_write;
 
-	if (a->flags & AF_COMM_LIST_TOGGLE)
+	if (test_bit(AF_COMM_LIST_TOGGLE, &a->flags))
 		dw |= MU_ILW_TOGGLE;
 
 	esas2r_trace("rq->vrq->scsi.handle:%x", rq->vrq->scsi.handle);
@@ -687,18 +688,14 @@ static void esas2r_handle_pending_reset(struct esas2r_adapter *a, u32 currtime)
 			esas2r_write_register_dword(a, MU_DOORBELL_OUT,
 						    doorbell);
 			if (ver == DRBL_FW_VER_0) {
-				esas2r_lock_set_flags(&a->flags,
-						      AF_CHPRST_DETECTED);
-				esas2r_lock_set_flags(&a->flags,
-						      AF_LEGACY_SGE_MODE);
+				set_bit(AF_CHPRST_DETECTED, &a->flags);
+				set_bit(AF_LEGACY_SGE_MODE, &a->flags);
 
 				a->max_vdareq_size = 128;
 				a->build_sgl = esas2r_build_sg_list_sge;
 			} else if (ver == DRBL_FW_VER_1) {
-				esas2r_lock_set_flags(&a->flags,
-						      AF_CHPRST_DETECTED);
-				esas2r_lock_clear_flags(&a->flags,
-							AF_LEGACY_SGE_MODE);
+				set_bit(AF_CHPRST_DETECTED, &a->flags);
+				clear_bit(AF_LEGACY_SGE_MODE, &a->flags);
 
 				a->max_vdareq_size = 1024;
 				a->build_sgl = esas2r_build_sg_list_prd;
@@ -719,28 +716,27 @@ void esas2r_timer_tick(struct esas2r_adapter *a)
 	a->last_tick_time = currtime;
 
 	/* count down the uptime */
-	if (a->chip_uptime
-	    && !(a->flags & (AF_CHPRST_PENDING | AF_DISC_PENDING))) {
+	if (a->chip_uptime &&
+	    !test_bit(AF_CHPRST_PENDING, &a->flags) &&
+	    !test_bit(AF_DISC_PENDING, &a->flags)) {
 		if (deltatime >= a->chip_uptime)
 			a->chip_uptime = 0;
 		else
 			a->chip_uptime -= deltatime;
 	}
 
-	if (a->flags & AF_CHPRST_PENDING) {
-		if (!(a->flags & AF_CHPRST_NEEDED)
-		    && !(a->flags & AF_CHPRST_DETECTED))
+	if (test_bit(AF_CHPRST_PENDING, &a->flags)) {
+		if (!test_bit(AF_CHPRST_NEEDED, &a->flags) &&
+		    !test_bit(AF_CHPRST_DETECTED, &a->flags))
 			esas2r_handle_pending_reset(a, currtime);
 	} else {
-		if (a->flags & AF_DISC_PENDING)
+		if (test_bit(AF_DISC_PENDING, &a->flags))
 			esas2r_disc_check_complete(a);
-
-		if (a->flags & AF_HEARTBEAT_ENB) {
-			if (a->flags & AF_HEARTBEAT) {
+		if (test_bit(AF_HEARTBEAT_ENB, &a->flags)) {
+			if (test_bit(AF_HEARTBEAT, &a->flags)) {
 				if ((currtime - a->heartbeat_time) >=
 				    ESAS2R_HEARTBEAT_TIME) {
-					esas2r_lock_clear_flags(&a->flags,
-								AF_HEARTBEAT);
+					clear_bit(AF_HEARTBEAT, &a->flags);
 					esas2r_hdebug("heartbeat failed");
 					esas2r_log(ESAS2R_LOG_CRIT,
 						   "heartbeat failed");
@@ -748,7 +744,7 @@ void esas2r_timer_tick(struct esas2r_adapter *a)
 					esas2r_local_reset_adapter(a);
 				}
 			} else {
-				esas2r_lock_set_flags(&a->flags, AF_HEARTBEAT);
+				set_bit(AF_HEARTBEAT, &a->flags);
 				a->heartbeat_time = currtime;
 				esas2r_force_interrupt(a);
 			}
@@ -812,7 +808,7 @@ bool esas2r_send_task_mgmt(struct esas2r_adapter *a,
 	rqaux->vrq->scsi.flags |=
 		cpu_to_le16(task_mgt_func * LOBIT(FCP_CMND_TM_MASK));
 
-	if (a->flags & AF_FLASHING) {
+	if (test_bit(AF_FLASHING, &a->flags)) {
 		/* Assume success.  if there are active requests, return busy */
 		rqaux->req_stat = RS_SUCCESS;
 
@@ -831,7 +827,7 @@ bool esas2r_send_task_mgmt(struct esas2r_adapter *a,
 
 	spin_unlock_irqrestore(&a->queue_lock, flags);
 
-	if (!(a->flags & AF_FLASHING))
+	if (!test_bit(AF_FLASHING, &a->flags))
 		esas2r_start_request(a, rqaux);
 
 	esas2r_comp_list_drain(a, &comp_list);
@@ -848,11 +844,12 @@ void esas2r_reset_bus(struct esas2r_adapter *a)
 {
 	esas2r_log(ESAS2R_LOG_INFO, "performing a bus reset");
 
-	if (!(a->flags & AF_DEGRADED_MODE)
-	    && !(a->flags & (AF_CHPRST_PENDING | AF_DISC_PENDING))) {
-		esas2r_lock_set_flags(&a->flags, AF_BUSRST_NEEDED);
-		esas2r_lock_set_flags(&a->flags, AF_BUSRST_PENDING);
-		esas2r_lock_set_flags(&a->flags, AF_OS_RESET);
+	if (!test_bit(AF_DEGRADED_MODE, &a->flags) &&
+	    !test_bit(AF_CHPRST_PENDING, &a->flags) &&
+	    !test_bit(AF_DISC_PENDING, &a->flags)) {
+		set_bit(AF_BUSRST_NEEDED, &a->flags);
+		set_bit(AF_BUSRST_PENDING, &a->flags);
+		set_bit(AF_OS_RESET, &a->flags);
 
 		esas2r_schedule_tasklet(a);
 	}
diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index e5b0902..d89a027 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -347,7 +347,7 @@ static bool csmi_ioctl_tunnel(struct esas2r_adapter *a,
 {
 	struct atto_vda_ioctl_req *ioctl = &rq->vrq->ioctl;
 
-	if (a->flags & AF_DEGRADED_MODE)
+	if (test_bit(AF_DEGRADED_MODE, &a->flags))
 		return false;
 
 	esas2r_sgc_init(sgc, a, rq, rq->vrq->ioctl.sge);
@@ -463,7 +463,7 @@ static int csmi_ioctl_callback(struct esas2r_adapter *a,
 		gcc->bios_minor_rev = LOBYTE(HIWORD(a->flash_ver));
 		gcc->bios_build_rev = LOWORD(a->flash_ver);
 
-		if (a->flags2 & AF2_THUNDERLINK)
+		if (test_bit(AF2_THUNDERLINK, &a->flags2))
 			gcc->cntlr_flags = CSMI_CNTLRF_SAS_HBA
 					   | CSMI_CNTLRF_SATA_HBA;
 		else
@@ -485,7 +485,7 @@ static int csmi_ioctl_callback(struct esas2r_adapter *a,
 	{
 		struct atto_csmi_get_cntlr_sts *gcs = &ioctl_csmi->cntlr_sts;
 
-		if (a->flags & AF_DEGRADED_MODE)
+		if (test_bit(AF_DEGRADED_MODE, &a->flags))
 			gcs->status = CSMI_CNTLR_STS_FAILED;
 		else
 			gcs->status = CSMI_CNTLR_STS_GOOD;
@@ -819,10 +819,10 @@ static int hba_ioctl_callback(struct esas2r_adapter *a,
 
 		gai->adap_type = ATTO_GAI_AT_ESASRAID2;
 
-		if (a->flags2 & AF2_THUNDERLINK)
+		if (test_bit(AF2_THUNDERLINK, &a->flags2))
 			gai->adap_type = ATTO_GAI_AT_TLSASHBA;
 
-		if (a->flags & AF_DEGRADED_MODE)
+		if (test_bit(AF_DEGRADED_MODE, &a->flags))
 			gai->adap_flags |= ATTO_GAI_AF_DEGRADED;
 
 		gai->adap_flags |= ATTO_GAI_AF_SPT_SUPP |
@@ -938,7 +938,7 @@ static int hba_ioctl_callback(struct esas2r_adapter *a,
 				u32 total_len = ESAS2R_FWCOREDUMP_SZ;
 
 				/* Size is zero if a core dump isn't present */
-				if (!(a->flags2 & AF2_COREDUMP_SAVED))
+				if (!test_bit(AF2_COREDUMP_SAVED, &a->flags2))
 					total_len = 0;
 
 				if (len > total_len)
@@ -960,8 +960,7 @@ static int hba_ioctl_callback(struct esas2r_adapter *a,
 				memset(a->fw_coredump_buff, 0,
 				       ESAS2R_FWCOREDUMP_SZ);
 
-				esas2r_lock_clear_flags(&a->flags2,
-							AF2_COREDUMP_SAVED);
+				clear_bit(AF2_COREDUMP_SAVED, &a->flags2);
 			} else if (trc->trace_func != ATTO_TRC_TF_GET_INFO) {
 				hi->status = ATTO_STS_UNSUPPORTED;
 				break;
@@ -973,7 +972,7 @@ static int hba_ioctl_callback(struct esas2r_adapter *a,
 			trc->total_length = ESAS2R_FWCOREDUMP_SZ;
 
 			/* Return zero length buffer if core dump not present */
-			if (!(a->flags2 & AF2_COREDUMP_SAVED))
+			if (!test_bit(AF2_COREDUMP_SAVED, &a->flags2))
 				trc->total_length = 0;
 		} else {
 			hi->status = ATTO_STS_UNSUPPORTED;
@@ -1048,6 +1047,7 @@ static int hba_ioctl_callback(struct esas2r_adapter *a,
 		else if (spt->flags & ATTO_SPTF_HEAD_OF_Q)
 			rq->vrq->scsi.flags |= cpu_to_le32(FCP_CMND_TA_HEAD_Q);
 
+
 		if (!esas2r_build_sg_list(a, rq, sgc)) {
 			hi->status = ATTO_STS_OUT_OF_RSRC;
 			break;
@@ -1139,15 +1139,15 @@ static int hba_ioctl_callback(struct esas2r_adapter *a,
 			break;
 		}
 
-		if (a->flags & AF_CHPRST_NEEDED)
+		if (test_bit(AF_CHPRST_NEEDED, &a->flags))
 			ac->adap_state = ATTO_AC_AS_RST_SCHED;
-		else if (a->flags & AF_CHPRST_PENDING)
+		else if (test_bit(AF_CHPRST_PENDING, &a->flags))
 			ac->adap_state = ATTO_AC_AS_RST_IN_PROG;
-		else if (a->flags & AF_DISC_PENDING)
+		else if (test_bit(AF_DISC_PENDING, &a->flags))
 			ac->adap_state = ATTO_AC_AS_RST_DISC;
-		else if (a->flags & AF_DISABLED)
+		else if (test_bit(AF_DISABLED, &a->flags))
 			ac->adap_state = ATTO_AC_AS_DISABLED;
-		else if (a->flags & AF_DEGRADED_MODE)
+		else if (test_bit(AF_DEGRADED_MODE, &a->flags))
 			ac->adap_state = ATTO_AC_AS_DEGRADED;
 		else
 			ac->adap_state = ATTO_AC_AS_OK;
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 4abf127..f37f3e3 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -889,7 +889,7 @@ int esas2r_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	/* Assume success, if it fails we will fix the result later. */
 	cmd->result = DID_OK << 16;
 
-	if (unlikely(a->flags & AF_DEGRADED_MODE)) {
+	if (unlikely(test_bit(AF_DEGRADED_MODE, &a->flags))) {
 		cmd->result = DID_NO_CONNECT << 16;
 		cmd->scsi_done(cmd);
 		return 0;
@@ -1050,7 +1050,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 
 	esas2r_log(ESAS2R_LOG_INFO, "eh_abort (%p)", cmd);
 
-	if (a->flags & AF_DEGRADED_MODE) {
+	if (test_bit(AF_DEGRADED_MODE, &a->flags)) {
 		cmd->result = DID_ABORT << 16;
 
 		scsi_set_resid(cmd, 0);
@@ -1131,7 +1131,7 @@ static int esas2r_host_bus_reset(struct scsi_cmnd *cmd, bool host_reset)
 	struct esas2r_adapter *a =
 		(struct esas2r_adapter *)cmd->device->host->hostdata;
 
-	if (a->flags & AF_DEGRADED_MODE)
+	if (test_bit(AF_DEGRADED_MODE, &a->flags))
 		return FAILED;
 
 	if (host_reset)
@@ -1141,14 +1141,14 @@ static int esas2r_host_bus_reset(struct scsi_cmnd *cmd, bool host_reset)
 
 	/* above call sets the AF_OS_RESET flag.  wait for it to clear. */
 
-	while (a->flags & AF_OS_RESET) {
+	while (test_bit(AF_OS_RESET, &a->flags)) {
 		msleep(10);
 
-		if (a->flags & AF_DEGRADED_MODE)
+		if (test_bit(AF_DEGRADED_MODE, &a->flags))
 			return FAILED;
 	}
 
-	if (a->flags & AF_DEGRADED_MODE)
+	if (test_bit(AF_DEGRADED_MODE, &a->flags))
 		return FAILED;
 
 	return SUCCESS;
@@ -1176,7 +1176,7 @@ static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
 	u8 task_management_status = RS_PENDING;
 	bool completed;
 
-	if (a->flags & AF_DEGRADED_MODE)
+	if (test_bit(AF_DEGRADED_MODE, &a->flags))
 		return FAILED;
 
 retry:
@@ -1229,7 +1229,7 @@ retry:
 			msleep(10);
 	}
 
-	if (a->flags & AF_DEGRADED_MODE)
+	if (test_bit(AF_DEGRADED_MODE, &a->flags))
 		return FAILED;
 
 	if (task_management_status == RS_BUSY) {
@@ -1666,13 +1666,13 @@ void esas2r_adapter_tasklet(unsigned long context)
 {
 	struct esas2r_adapter *a = (struct esas2r_adapter *)context;
 
-	if (unlikely(a->flags2 & AF2_TIMER_TICK)) {
-		esas2r_lock_clear_flags(&a->flags2, AF2_TIMER_TICK);
+	if (unlikely(test_bit(AF2_TIMER_TICK, &a->flags2))) {
+		clear_bit(AF2_TIMER_TICK, &a->flags2);
 		esas2r_timer_tick(a);
 	}
 
-	if (likely(a->flags2 & AF2_INT_PENDING)) {
-		esas2r_lock_clear_flags(&a->flags2, AF2_INT_PENDING);
+	if (likely(test_bit(AF2_INT_PENDING, &a->flags2))) {
+		clear_bit(AF2_INT_PENDING, &a->flags2);
 		esas2r_adapter_interrupt(a);
 	}
 
@@ -1680,12 +1680,12 @@ void esas2r_adapter_tasklet(unsigned long context)
 		esas2r_do_tasklet_tasks(a);
 
 	if (esas2r_is_tasklet_pending(a)
-	    || (a->flags2 & AF2_INT_PENDING)
-	    || (a->flags2 & AF2_TIMER_TICK)) {
-		esas2r_lock_clear_flags(&a->flags, AF_TASKLET_SCHEDULED);
+	    || (test_bit(AF2_INT_PENDING, &a->flags2))
+	    || (test_bit(AF2_TIMER_TICK, &a->flags2))) {
+		clear_bit(AF_TASKLET_SCHEDULED, &a->flags);
 		esas2r_schedule_tasklet(a);
 	} else {
-		esas2r_lock_clear_flags(&a->flags, AF_TASKLET_SCHEDULED);
+		clear_bit(AF_TASKLET_SCHEDULED, &a->flags);
 	}
 }
 
@@ -1707,7 +1707,7 @@ static void esas2r_timer_callback(unsigned long context)
 {
 	struct esas2r_adapter *a = (struct esas2r_adapter *)context;
 
-	esas2r_lock_set_flags(&a->flags2, AF2_TIMER_TICK);
+	set_bit(AF2_TIMER_TICK, &a->flags2);
 
 	esas2r_schedule_tasklet(a);
 
diff --git a/drivers/scsi/esas2r/esas2r_targdb.c b/drivers/scsi/esas2r/esas2r_targdb.c
index e540a2f..bf45bea 100644
--- a/drivers/scsi/esas2r/esas2r_targdb.c
+++ b/drivers/scsi/esas2r/esas2r_targdb.c
@@ -86,7 +86,7 @@ void esas2r_targ_db_report_changes(struct esas2r_adapter *a)
 
 	esas2r_trace_enter();
 
-	if (a->flags & AF_DISC_PENDING) {
+	if (test_bit(AF_DISC_PENDING, &a->flags)) {
 		esas2r_trace_exit();
 		return;
 	}
diff --git a/drivers/scsi/esas2r/esas2r_vda.c b/drivers/scsi/esas2r/esas2r_vda.c
index fd13928..27e9721 100644
--- a/drivers/scsi/esas2r/esas2r_vda.c
+++ b/drivers/scsi/esas2r/esas2r_vda.c
@@ -84,7 +84,7 @@ bool esas2r_process_vda_ioctl(struct esas2r_adapter *a,
 		return false;
 	}
 
-	if (a->flags & AF_DEGRADED_MODE) {
+	if (test_bit(AF_DEGRADED_MODE, &a->flags)) {
 		vi->status = ATTO_STS_DEGRADED;
 		return false;
 	}
@@ -389,7 +389,7 @@ void esas2r_build_mgt_req(struct esas2r_adapter *a,
 	vrq->length = cpu_to_le32(length);
 
 	if (vrq->length) {
-		if (a->flags & AF_LEGACY_SGE_MODE) {
+		if (test_bit(AF_LEGACY_SGE_MODE, &a->flags)) {
 			vrq->sg_list_offset = (u8)offsetof(
 				struct atto_vda_mgmt_req, sge);
 
@@ -427,7 +427,7 @@ void esas2r_build_ae_req(struct esas2r_adapter *a, struct esas2r_request *rq)
 
 	vrq->length = cpu_to_le32(sizeof(struct atto_vda_ae_data));
 
-	if (a->flags & AF_LEGACY_SGE_MODE) {
+	if (test_bit(AF_LEGACY_SGE_MODE, &a->flags)) {
 		vrq->sg_list_offset =
 			(u8)offsetof(struct atto_vda_ae_req, sge);
 		vrq->sge[0].length = cpu_to_le32(SGE_LAST | vrq->length);
-- 
1.8.3.1

