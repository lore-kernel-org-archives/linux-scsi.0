From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] scsi: megaraid: Convert timers to use timer_setup()
Date: Wed, 1 Nov 2017 00:17:56 +0530
Message-ID: <92b3d37d10162a899d5a829351fd1512@mail.gmail.com>
References: <20171025100720.GA145069@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:44650 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdJaSsA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2017 14:48:00 -0400
Received: by mail-oi0-f67.google.com with SMTP id v132so28264044oie.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2017 11:47:59 -0700 (PDT)
In-Reply-To: <20171025100720.GA145069@beast>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

-----Original Message-----
From: Kees Cook [mailto:keescook@chromium.org]
Sent: Wednesday, October 25, 2017 3:37 PM
To: Martin K. Petersen
Cc: Kashyap Desai; Sumit Saxena; Shivasharan S; James E.J. Bottomley;
megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: megaraid: Convert timers to use timer_setup()

In preparation for unconditionally passing the struct timer_list pointer
to all timer callbacks, switch to using the new timer_setup() and
from_timer() to pass the timer pointer explicitly. Also consolidates the
timer setup functions arguments, which are all identical, and corrects
on-stack timer usage.

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/megaraid/megaraid_ioctl.h      |  6 +++++
 drivers/scsi/megaraid/megaraid_mbox.c       | 26 ++++++++++-----------
 drivers/scsi/megaraid/megaraid_mm.c         | 27 +++++++++++-----------
 drivers/scsi/megaraid/megaraid_sas_base.c   | 35
+++++++++++------------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 15 +++----------
 5 files changed, 47 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_ioctl.h
b/drivers/scsi/megaraid/megaraid_ioctl.h
index 05f6e4ec3453..eedcbde46459 100644
--- a/drivers/scsi/megaraid/megaraid_ioctl.h
+++ b/drivers/scsi/megaraid/megaraid_ioctl.h
@@ -19,6 +19,7 @@

 #include <linux/types.h>
 #include <linux/semaphore.h>
+#include <linux/timer.h>

 #include "mbox_defs.h"

@@ -153,6 +154,11 @@ typedef struct uioc {

 } __attribute__ ((aligned(1024),packed)) uioc_t;

+/* For on-stack uioc timers. */
+struct uioc_timeout {
+	struct timer_list timer;
+	uioc_t		  *uioc;
+};

 /**
  * struct mraid_hba_info - information about the controller diff --git
a/drivers/scsi/megaraid/megaraid_mbox.c
b/drivers/scsi/megaraid/megaraid_mbox.c
index ec3c43854978..530358cdcb39 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -3904,19 +3904,19 @@ megaraid_sysfs_get_ldmap_done(uioc_t *uioc)
 	wake_up(&raid_dev->sysfs_wait_q);
 }

-
 /**
  * megaraid_sysfs_get_ldmap_timeout - timeout handling for get ldmap
- * @data	: timed out packet
+ * @t	: timed out timer
  *
  * Timeout routine to recover and return to application, in case the
adapter
  * has stopped responding. A timeout of 60 seconds for this command seems
like
  * a good value.
  */
 static void
-megaraid_sysfs_get_ldmap_timeout(unsigned long data)
+megaraid_sysfs_get_ldmap_timeout(struct timer_list *t)
 {
-	uioc_t		*uioc = (uioc_t *)data;
+	struct uioc_timeout *timeout = from_timer(timeout, t, timer);
+	uioc_t		*uioc = timeout->uioc;
 	adapter_t	*adapter = (adapter_t *)uioc->buf_vaddr;
 	mraid_device_t	*raid_dev = ADAP2RAIDDEV(adapter);

@@ -3951,8 +3951,7 @@ megaraid_sysfs_get_ldmap(adapter_t *adapter)
 	mbox64_t		*mbox64;
 	mbox_t			*mbox;
 	char			*raw_mbox;
-	struct timer_list	sysfs_timer;
-	struct timer_list	*timerp;
+	struct uioc_timeout	timeout;
 	caddr_t			ldmap;
 	int			rval = 0;

@@ -3988,14 +3987,12 @@ megaraid_sysfs_get_ldmap(adapter_t *adapter)
 	/*
 	 * Setup a timer to recover from a non-responding controller
 	 */
-	timerp	= &sysfs_timer;
-	init_timer(timerp);
-
-	timerp->function	= megaraid_sysfs_get_ldmap_timeout;
-	timerp->data		= (unsigned long)uioc;
-	timerp->expires		= jiffies + 60 * HZ;
+	timeout.uioc = uioc;
+	timer_setup_on_stack(&timeout.timer,
+			     megaraid_sysfs_get_ldmap_timeout, 0);

Kees,
Does calling "timer_setup_on_stack" instead of "timer_setup" intentional ?
If yes, please help me understand the reason.
Otherwise changes look good to me.

-	add_timer(timerp);
+	timeout.timer.expires		= jiffies + 60 * HZ;
+	add_timer(&timeout.timer);

 	/*
 	 * Send the command to the firmware
@@ -4033,7 +4030,8 @@ megaraid_sysfs_get_ldmap(adapter_t *adapter)
 	}


-	del_timer_sync(timerp);
+	del_timer_sync(&timeout.timer);
+	destroy_timer_on_stack(&timeout.timer);

 	mutex_unlock(&raid_dev->sysfs_mtx);

diff --git a/drivers/scsi/megaraid/megaraid_mm.c
b/drivers/scsi/megaraid/megaraid_mm.c
index 65b6f6ace3a5..bb802b0c12b8 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -35,7 +35,7 @@ static int kioc_to_mimd(uioc_t *, mimd_t __user *);
static int handle_drvrcmd(void __user *, uint8_t, int *);  static int
lld_ioctl(mraid_mmadp_t *, uioc_t *);  static void ioctl_done(uioc_t *);
-static void lld_timedout(unsigned long);
+static void lld_timedout(struct timer_list *);
 static void hinfo_to_cinfo(mraid_hba_info_t *, mcontroller_t *);  static
mraid_mmadp_t *mraid_mm_get_adapter(mimd_t __user *, int *);  static
uioc_t *mraid_mm_alloc_kioc(mraid_mmadp_t *); @@ -686,8 +686,7 @@ static
int  lld_ioctl(mraid_mmadp_t *adp, uioc_t *kioc)  {
 	int			rval;
-	struct timer_list	timer;
-	struct timer_list	*tp = NULL;
+	struct uioc_timeout	timeout = { };

 	kioc->status	= -ENODATA;
 	rval		= adp->issue_uioc(adp->drvr_data, kioc,
IOCTL_ISSUE);
@@ -698,14 +697,12 @@ lld_ioctl(mraid_mmadp_t *adp, uioc_t *kioc)
 	 * Start the timer
 	 */
 	if (adp->timeout > 0) {
-		tp		= &timer;
-		init_timer(tp);
+		timeout.uioc = kioc;
+		timer_setup_on_stack(&timeout.timer, lld_timedout, 0);

Same question as above.

-		tp->function	= lld_timedout;
-		tp->data	= (unsigned long)kioc;
-		tp->expires	= jiffies + adp->timeout * HZ;
+		timeout.timer.expires	= jiffies + adp->timeout * HZ;

-		add_timer(tp);
+		add_timer(&timeout.timer);
 	}

 	/*
@@ -713,8 +710,9 @@ lld_ioctl(mraid_mmadp_t *adp, uioc_t *kioc)
 	 * call, the ioctl either completed successfully or timedout.
 	 */
 	wait_event(wait_q, (kioc->status != -ENODATA));
-	if (tp) {
-		del_timer_sync(tp);
+	if (timeout.timer.function) {
+		del_timer_sync(&timeout.timer);
+		destroy_timer_on_stack(&timeout.timer);
 	}

 	/*
@@ -783,12 +781,13 @@ ioctl_done(uioc_t *kioc)

 /**
  * lld_timedout	- callback from the expired timer
- * @ptr		: ioctl packet that timed out
+ * @t		: timer that timed out
  */
 static void
-lld_timedout(unsigned long ptr)
+lld_timedout(struct timer_list *t)
 {
-	uioc_t *kioc	= (uioc_t *)ptr;
+	struct uioc_timeout *timeout = from_timer(timeout, t, timer);
+	uioc_t *kioc	= timeout->uioc;

 	kioc->status 	= -ETIME;
 	kioc->timedout	= 1;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
b/drivers/scsi/megaraid/megaraid_sas_base.c
index e518dadc8161..a36e18156e49 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2114,22 +2114,19 @@ static void megasas_complete_cmd_dpc(unsigned long
instance_addr)
 	megasas_check_and_restore_queue_depth(instance);
 }

+static void megasas_sriov_heartbeat_handler(struct timer_list *t);
+
 /**
- * megasas_start_timer - Initializes a timer object
+ * megasas_start_timer - Initializes sriov heartbeat timer object
  * @instance:		Adapter soft state
- * @timer:		timer object to be initialized
- * @fn:			timer function
- * @interval:		time interval between timer function call
  *
  */
-void megasas_start_timer(struct megasas_instance *instance,
-			struct timer_list *timer,
-			void *fn, unsigned long interval)
-{
-	init_timer(timer);
-	timer->expires = jiffies + interval;
-	timer->data = (unsigned long)instance;
-	timer->function = fn;
+void megasas_start_timer(struct megasas_instance *instance) {
+	struct timer_list *timer = &instance->sriov_heartbeat_timer;
+
+	timer_setup(timer, megasas_sriov_heartbeat_handler, 0);
+	timer->expires = jiffies + MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF;
 	add_timer(timer);
 }

@@ -2515,10 +2512,10 @@ int megasas_sriov_start_heartbeat(struct
megasas_instance *instance,  }

 /* Handler for SR-IOV heartbeat */
-void megasas_sriov_heartbeat_handler(unsigned long instance_addr)
+static void megasas_sriov_heartbeat_handler(struct timer_list *t)
 {
 	struct megasas_instance *instance =
-		(struct megasas_instance *)instance_addr;
+		from_timer(instance, t, sriov_heartbeat_timer);

 	if (instance->hb_host_mem->HB.fwCounter !=
 	    instance->hb_host_mem->HB.driverCounter) { @@ -5493,10 +5490,7
@@ static int megasas_init_fw(struct megasas_instance *instance)
 	/* Launch SR-IOV heartbeat timer */
 	if (instance->requestorId) {
 		if (!megasas_sriov_start_heartbeat(instance, 1))
-			megasas_start_timer(instance,
-
&instance->sriov_heartbeat_timer,
-
megasas_sriov_heartbeat_handler,
-
MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
+			megasas_start_timer(instance);
 		else
 			instance->skip_heartbeat_timer_del = 1;
 	}
@@ -6507,10 +6501,7 @@ megasas_resume(struct pci_dev *pdev)
 	/* Re-launch SR-IOV heartbeat timer */
 	if (instance->requestorId) {
 		if (!megasas_sriov_start_heartbeat(instance, 0))
-			megasas_start_timer(instance,
-
&instance->sriov_heartbeat_timer,
-
megasas_sriov_heartbeat_handler,
-
MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
+			megasas_start_timer(instance);
 		else {
 			instance->skip_heartbeat_timer_del = 1;
 			goto fail_init_mfi;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 11bd2e698b84..3c399e7b3fe1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -85,12 +85,9 @@ int megasas_transition_to_ready(struct megasas_instance
*instance, int ocr);  void megaraid_sas_kill_hba(struct megasas_instance
*instance);

 extern u32 megasas_dbg_lvl;
-void megasas_sriov_heartbeat_handler(unsigned long instance_addr);  int
megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 				  int initial);
-void megasas_start_timer(struct megasas_instance *instance,
-			struct timer_list *timer,
-			 void *fn, unsigned long interval);
+void megasas_start_timer(struct megasas_instance *instance);
 extern struct megasas_mgmt_info megasas_mgmt_info;  extern unsigned int
resetwaittime;  extern unsigned int dual_qdepth_disable; @@ -4369,10
+4366,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			/* Restart SR-IOV heartbeat */
 			if (instance->requestorId) {
 				if
(!megasas_sriov_start_heartbeat(instance, 0))
-					megasas_start_timer(instance,
-
&instance->sriov_heartbeat_timer,
-
megasas_sriov_heartbeat_handler,
-
MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
+					megasas_start_timer(instance);
 				else
 					instance->skip_heartbeat_timer_del
= 1;
 			}
@@ -4404,10 +4398,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost,
int reason)
 	} else {
 		/* For VF: Restart HB timer if we didn't OCR */
 		if (instance->requestorId) {
-			megasas_start_timer(instance,
-
&instance->sriov_heartbeat_timer,
-
megasas_sriov_heartbeat_handler,
-
MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
+			megasas_start_timer(instance);
 		}
 		clear_bit(MEGASAS_FUSION_IN_RESET,
&instance->reset_flags);
 		instance->instancet->enable_intr(instance);
--
2.7.4


-- 
Kees Cook
Pixel Security
