From: "Moore, Eric Dean" <emoore@lsil.com>
Subject: [PATCH] 2.6.0-test9 - MPT Fusion driver 2.05.00.05 update
Date: Mon, 17 Nov 2003 11:33:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57035AA306@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5799 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263439AbTKQQdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 11:33:55 -0500
Received: from mhbs.lsil.com (mhbs.lsil.com [147.145.31.100])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id hAHGJDmD007616
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2003 08:31:25 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, akpm@osdl.org, linux-scsi@vger.kernel.org

James: Please apply the patch below to the 2.6 tree.

If you find this inline patch malformed,
please kindly download this patch from this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-patches/


2.05.00.05 changes
* error handling fixes, e.g. use of host_lock

2.05.00.04 changes
* removed __init from mptscsih_setup
* removed __init from get_setup_token
* changed copyright from 2002 to 2003
* added new mailto, and removed Pam.Delaney
* added some fix for 32bit emulation when unloading mptctl module



diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/isense.c
linux-2.6.0-test9/drivers/message/fusion/isense.c
--- linux-2.6.0-test9-reference/drivers/message/fusion/isense.c
2003-10-25 12:43:38.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/isense.c    2003-11-11
10:33:58.000000000 -0700
@@ -5,11 +5,11 @@
  *      Error Report logging output.  This module implements SCSI-3
  *      Opcode lookup and a sorted table of SCSI-3 ASC/ASCQ strings.
  *
- *  Copyright (c) 1991-2002 Steven J. Ralston
+ *  Copyright (c) 1991-2003 Steven J. Ralston
  *  Written By: Steven J. Ralston
  *  (yes I wrote some of the orig. code back in 1991!)
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: isense.c,v 1.33 2002/02/27 18:44:19 sralston Exp $
  */
@@ -66,7 +66,7 @@
 #endif
 
 #define MODULEAUTHOR "Steven J. Ralston"
-#define COPYRIGHT "Copyright (c) 2001-2002 " MODULEAUTHOR
+#define COPYRIGHT "Copyright (c) 2001-2003 " MODULEAUTHOR
 #include "mptbase.h"
 
 #include "isense.h"
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptbase.c
linux-2.6.0-test9/drivers/message/fusion/mptbase.c
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptbase.c
2003-11-12 21:38:36.900108256 -0700
+++ linux-2.6.0-test9/drivers/message/fusion/mptbase.c    2003-11-11
10:33:58.000000000 -0700
@@ -44,10 +44,10 @@
  *      for gobs of hard work fixing and optimizing LAN code.
  *      THANK YOU!
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptbase.c,v 1.126 2002/12/16 15:28:45 pdelaney Exp $
  */
@@ -3138,7 +3138,7 @@
 {
     int hard_reset_done = 0;
     u32 ioc_state;
-    int cnt = 0;
+    int cntdn, cnt = 0;
 
     dprintk((KERN_WARNING MYNAM ": KickStarting %s!\n", ioc->name));
     if ((int)ioc->chip_type > (int)FC929) {
@@ -3161,7 +3161,8 @@
     dprintk((MYIOC_s_INFO_FMT "Diagnostic reset successful!\n",
             ioc->name));
 
-    for (cnt=0; cnt<HZ*20; cnt++) {
+    cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * 20;    /* 20 seconds
*/
+    for (cnt=0; cnt<cntdn; cnt++) {
         if ((ioc_state = mpt_GetIocState(ioc, 1)) == MPI_IOC_STATE_READY) {
             dprintk((MYIOC_s_INFO_FMT "KickStart successful! (cnt=%d)\n",
                     ioc->name, cnt));
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptbase.h
linux-2.6.0-test9/drivers/message/fusion/mptbase.h
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptbase.h
2003-10-25 12:43:02.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptbase.h    2003-11-11
10:33:58.000000000 -0700
@@ -8,10 +8,10 @@
  *  Credits:
  *     (see mptbase.c)
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptbase.h,v 1.144 2003/01/28 21:31:56 pdelaney Exp $
  */
@@ -77,11 +77,11 @@
 #endif
 
 #ifndef COPYRIGHT
-#define COPYRIGHT    "Copyright (c) 1999-2002 " MODULEAUTHOR
+#define COPYRIGHT    "Copyright (c) 1999-2003 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON    "2.05.00.03"
-#define MPT_LINUX_PACKAGE_NAME        "@(#)mptlinux-2.05.00.03"
+#define MPT_LINUX_VERSION_COMMON    "2.05.00.05"
+#define MPT_LINUX_PACKAGE_NAME        "@(#)mptlinux-2.05.00.05"
 #define WHAT_MAGIC_STRING        "@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptctl.c
linux-2.6.0-test9/drivers/message/fusion/mptctl.c
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptctl.c
2003-10-25 12:42:49.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptctl.c    2003-11-11
10:33:58.000000000 -0700
@@ -29,10 +29,10 @@
  *
  *      (see also mptbase.c)
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Originally By: Steven J. Ralston, Noah Romer
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptctl.c,v 1.63 2002/12/03 21:26:33 pdelaney Exp $
  */
@@ -91,7 +91,7 @@
 #include "../../scsi/scsi.h"
 #include "../../scsi/hosts.h"
 
-#define COPYRIGHT    "Copyright (c) 1999-2001 LSI Logic Corporation"
+#define COPYRIGHT    "Copyright (c) 1999-2003 LSI Logic Corporation"
 #define MODULEAUTHOR    "Steven J. Ralston, Noah Romer, Pamela Delaney"
 #include "mptbase.h"
 #include "mptctl.h"
@@ -2985,6 +2985,21 @@
     mpt_deregister(mptctl_id);
     printk(KERN_INFO MYNAM ": Deregistered from Fusion MPT base driver\n");
 
+#ifdef CONFIG_COMPAT
+    unregister_ioctl32_conversion(MPTIOCINFO);
+    unregister_ioctl32_conversion(MPTIOCINFO1);
+    unregister_ioctl32_conversion(MPTTARGETINFO);
+    unregister_ioctl32_conversion(MPTTEST);
+    unregister_ioctl32_conversion(MPTEVENTQUERY);
+    unregister_ioctl32_conversion(MPTEVENTENABLE);
+    unregister_ioctl32_conversion(MPTEVENTREPORT);
+    unregister_ioctl32_conversion(MPTHARDRESET);
+    unregister_ioctl32_conversion(MPTCOMMAND32);
+    unregister_ioctl32_conversion(MPTFWDOWNLOAD32);
+    unregister_ioctl32_conversion(HP_GETHOSTINFO);
+    unregister_ioctl32_conversion(HP_GETTARGETINFO);
+#endif
+
     /* Free allocated memory */
     for (i=0; i<MPT_MAX_ADAPTERS; i++) {
         ioc = NULL;
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptctl.h
linux-2.6.0-test9/drivers/message/fusion/mptctl.h
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptctl.h
2003-10-25 12:43:38.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptctl.h    2003-11-11
10:33:58.000000000 -0700
@@ -15,10 +15,10 @@
  *
  *      (see also mptbase.c)
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptctl.h,v 1.13 2002/12/03 21:26:33 pdelaney Exp $
  */
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptlan.c
linux-2.6.0-test9/drivers/message/fusion/mptlan.c
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptlan.c
2003-10-25 12:43:39.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptlan.c    2003-11-11
10:33:58.000000000 -0700
@@ -23,8 +23,9 @@
  *
  *      (see also mptbase.c)
  *
- *  Copyright (c) 2000-2002 LSI Logic Corporation
+ *  Copyright (c) 2000-2003 LSI Logic Corporation
  *  Originally By: Noah Romer
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptlan.c,v 1.53 2002/10/17 20:15:58 pdelaney Exp $
  */
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptscsih.c
linux-2.6.0-test9/drivers/message/fusion/mptscsih.c
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptscsih.c
2003-10-25 12:43:27.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptscsih.c    2003-11-12
21:33:30.000000000 -0700
@@ -21,10 +21,10 @@
  *
  *      (see mptbase.c)
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Original author: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptscsih.c,v 1.104 2002/12/03 21:26:34 pdelaney Exp $
  */
@@ -178,9 +178,12 @@
 static int    mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf,
MPT_FRAME_HDR *r);
 static void    mptscsih_timer_expired(unsigned long data);
 static void    mptscsih_taskmgmt_timeout(unsigned long data);
+static void    mptscsih_schedule_reset(void *hd);
 static int    mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static int    mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int portnum);
 
+static struct mpt_work_struct   mptscsih_rstTask;
+
 #ifndef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
 static int    mptscsih_do_raid(MPT_SCSI_HOST *hd, u8 action, INTERNAL_CMD
*io);
 static void    mptscsih_domainValidation(void *hd);
@@ -1058,7 +1061,7 @@
                         SCpnt->use_sg,
scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
             } else if (SCpnt->request_bufflen) {
                 scPrivate    *my_priv;
-       
+
                 my_priv = (scPrivate *) &SCpnt->SCp;
                 pci_unmap_single(hd->ioc->pcidev,
(dma_addr_t)(ulong)my_priv->p1,
                        SCpnt->request_bufflen,
@@ -2155,7 +2158,7 @@
     MPT_SCSI_HOST    *hd = NULL;
     int size = 0;
 
-    dprintk(("Called mptscsih_proc_info: hostno=%d, func=%d\n", hostno,
func));
+    dprintk(("Called mptscsih_proc_info: hostno=%d, func=%d\n",
host->host_no, func));
     dprintk(("buffer %p, start=%p (%p) offset=%ld length = %d\n",
             buffer, start, *start, offset, length));
 
@@ -2788,13 +2791,14 @@
     MPT_FRAME_HDR    *mf;
     u32         ctx2abort;
     int         scpnt_idx;
+    spinlock_t    *host_lock = SCpnt->device->host->host_lock;
 
     /* If we can't locate our host adapter structure, return FAILED status.
      */
     if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL) {
         SCpnt->result = DID_RESET << 16;
         SCpnt->scsi_done(SCpnt);
-        nehprintk((KERN_WARNING MYNAM ": mptscsih_abort: "
+        dtmprintk((KERN_WARNING MYNAM ": mptscsih_abort: "
                "Can't locate host! (sc=%p)\n",
                SCpnt));
         return FAILED;
@@ -2816,7 +2820,7 @@
 
         SCpnt->result = DID_RESET << 16;
         SCpnt->scsi_done(SCpnt);
-        nehprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "
+        dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "
                "Command not in the active list! (sc=%p)\n",
                hd->ioc->name, SCpnt));
         return SUCCESS;
@@ -2827,13 +2831,16 @@
      *  call to mptscsih_tm_pending_wait() will set the pending flag if we
are
      *  successful.
      */
+    spin_unlock_irq(host_lock);
     if (mptscsih_tm_pending_wait(hd) == FAILED){
-        nehprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "
+        dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "
                "Timed out waiting for previous TM to complete! "
                "(sc = %p)\n",
                hd->ioc->name, SCpnt));
+        spin_lock_irq(host_lock);
         return FAILED;
     }
+    spin_lock_irq(host_lock);
 
     /* If this command is pended, then timeout/hang occurred
      * during DV. Post command and flush pending Q
@@ -2842,7 +2849,7 @@
     if ((mf = mptscsih_search_pendingQ(hd, scpnt_idx)) != NULL) {
         mptscsih_put_msgframe(ScsiDoneCtx, hd->ioc->id, mf);
         post_pendingQ_commands(hd);
-        nehprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "
+        dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "
                "Found command in pending queue! (sc=%p)\n",
                hd->ioc->name, SCpnt));
     }
@@ -2858,8 +2865,10 @@
     ctx2abort = mf->u.frame.hwhdr.msgctxu.MsgContext;
 
     hd->abortSCpnt = SCpnt;
+
+    spin_unlock_irq(host_lock);
     if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
-                           SCpnt->device->id, SCpnt->device->lun,
ctx2abort, NO_SLEEP)
+                           SCpnt->device->id, SCpnt->device->lun,
ctx2abort, CAN_SLEEP)
         < 0) {
 
         /* The TM request failed and the subsequent FW-reload failed!
@@ -2873,8 +2882,10 @@
         hd->tmPending = 0;
         hd->tmState = TM_STATE_NONE;
 
+        spin_lock_irq(host_lock);
         return FAILED;
     }
+    spin_lock_irq(host_lock);
     return FAILED;
 
 }
@@ -2892,11 +2903,12 @@
 mptscsih_dev_reset(Scsi_Cmnd * SCpnt)
 {
     MPT_SCSI_HOST    *hd;
+    spinlock_t    *host_lock = SCpnt->device->host->host_lock;
 
     /* If we can't locate our host adapter structure, return FAILED status.
      */
     if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-        nehprintk((KERN_WARNING MYNAM ": mptscsih_dev_reset: "
+        dtmprintk((KERN_WARNING MYNAM ": mptscsih_dev_reset: "
                "Can't locate host! (sc=%p)\n",
                SCpnt));
         return FAILED;
@@ -2915,16 +2927,18 @@
      *  call to mptscsih_tm_pending_wait() will set the pending flag if we
are
      *  successful.
      */
+    spin_unlock_irq(host_lock);
     if (mptscsih_tm_pending_wait(hd) == FAILED) {
-        nehprintk((KERN_WARNING MYNAM ": %s: mptscsih_dev_reset: "
+        dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_dev_reset: "
                "Timed out waiting for previous TM to complete! "
                "(sc = %p)\n",
                hd->ioc->name, SCpnt));
+        spin_lock_irq(host_lock);
         return FAILED;
     }
 
     if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-                           SCpnt->device->id, 0, 0, NO_SLEEP)
+                           SCpnt->device->id, 0, 0, CAN_SLEEP)
         < 0){
         /* The TM request failed and the subsequent FW-reload failed!
          * Fatal error case.
@@ -2933,8 +2947,10 @@
                  hd->ioc->name, SCpnt);
         hd->tmPending = 0;
         hd->tmState = TM_STATE_NONE;
+        spin_lock_irq(host_lock);
         return FAILED;
     }
+    spin_lock_irq(host_lock);
     return SUCCESS;
 
 }
@@ -2952,11 +2968,12 @@
 mptscsih_bus_reset(Scsi_Cmnd * SCpnt)
 {
     MPT_SCSI_HOST    *hd;
+    spinlock_t    *host_lock = SCpnt->device->host->host_lock;
 
     /* If we can't locate our host adapter structure, return FAILED status.
      */
     if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-        nehprintk((KERN_WARNING MYNAM ": mptscsih_bus_reset: "
+        dtmprintk((KERN_WARNING MYNAM ": mptscsih_bus_reset: "
                "Can't locate host! (sc=%p)\n",
                SCpnt ) );
         return FAILED;
@@ -2973,17 +2990,19 @@
      *  call to mptscsih_tm_pending_wait() will set the pending flag if we
are
      *  successful.
      */
+    spin_unlock_irq(host_lock);
     if (mptscsih_tm_pending_wait(hd) == FAILED) {
-        nehprintk((KERN_WARNING MYNAM ": %s: mptscsih_bus_reset: "
+        dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_bus_reset: "
                "Timed out waiting for previous TM to complete! "
                "(sc = %p)\n",
                hd->ioc->name, SCpnt));
+        spin_lock_irq(host_lock);
         return FAILED;
     }
 
     /* We are now ready to execute the task management request. */
     if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-                           0, 0, 0, NO_SLEEP)
+                           0, 0, 0, CAN_SLEEP)
         < 0){
 
         /* The TM request failed and the subsequent FW-reload failed!
@@ -2994,9 +3013,10 @@
                hd->ioc->name, SCpnt);
         hd->tmPending = 0;
         hd->tmState = TM_STATE_NONE;
+        spin_lock_irq(host_lock);
         return FAILED;
     }
-
+    spin_lock_irq(host_lock);
     return SUCCESS;
 }
 
@@ -3015,10 +3035,11 @@
 {
     MPT_SCSI_HOST *  hd;
     int              status = SUCCESS;
+    spinlock_t    *host_lock = SCpnt->device->host->host_lock;
 
     /*  If we can't locate the host to reset, then we failed. */
     if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-        nehprintk( ( KERN_WARNING MYNAM ": mptscsih_host_reset: "
+        dtmprintk( ( KERN_WARNING MYNAM ": mptscsih_host_reset: "
                  "Can't locate host! (sc=%p)\n",
                  SCpnt ) );
         return FAILED;
@@ -3032,7 +3053,8 @@
     /*  If our attempts to reset the host failed, then return a failed
      *  status.  The host will be taken off line by the SCSI mid-layer.
      */
-    if (mpt_HardResetHandler(hd->ioc, NO_SLEEP) < 0){
+    spin_unlock_irq(host_lock);
+    if (mpt_HardResetHandler(hd->ioc, CAN_SLEEP) < 0){
         status = FAILED;
     } else {
         /*  Make sure TM pending is cleared and TM state is set to
@@ -3041,9 +3063,10 @@
         hd->tmPending = 0;
         hd->tmState = TM_STATE_NONE;
     }
+    spin_lock_irq(host_lock);
 
 
-    nehprintk( ( KERN_WARNING MYNAM ": mptscsih_host_reset: "
+    dtmprintk( ( KERN_WARNING MYNAM ": mptscsih_host_reset: "
              "Status = %s\n",
              (status == SUCCESS) ? "SUCCESS" : "FAILED" ) );
 
@@ -3075,7 +3098,8 @@
             break;
         }
         spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
-        mdelay(250);
+        set_current_state(TASK_INTERRUPTIBLE);
+        schedule_timeout(HZ/4);
     } while (--loop_count);
 
     return status;
@@ -4716,13 +4740,30 @@
     /* Call the reset handler. Already had a TM request
      * timeout - so issue a diagnostic reset
      */
-    if (mpt_HardResetHandler(hd->ioc, NO_SLEEP) < 0) {
+    MPT_INIT_WORK(&mptscsih_rstTask, mptscsih_schedule_reset, (void *)hd);
+    SCHEDULE_TASK(&mptscsih_rstTask);
+    return;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/*    mptscsih_schedule_reset - Call back for timeout on a
+ *    task management request.
+ *    @data: Pointer to MPT_SCSI_HOST recast as an unsigned long
+ *
+ */
+static void
+mptscsih_schedule_reset(void *arg)
+{
+        MPT_SCSI_HOST           *hd;
+        hd = (MPT_SCSI_HOST *) arg;
+
+    if (mpt_HardResetHandler(hd->ioc, CAN_SLEEP) < 0) {
         printk((KERN_WARNING " Firmware Reload FAILED!!\n"));
     } else {
         /* Because we have reset the IOC, no TM requests can be
          * pending.  So let's make sure the tmPending flag is reset.
          */
-        nehprintk((KERN_WARNING MYNAM
+        dtmprintk((KERN_WARNING MYNAM
                ": %s: mptscsih_taskmgmt_timeout\n",
                hd->ioc->name));
         hd->tmPending = 0;
@@ -6900,7 +6941,7 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static int
-__init get_setup_token(char *p)
+get_setup_token(char *p)
 {
     char *cur = setup_token;
     char *pc;
@@ -6918,7 +6959,7 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static int
-__init mptscsih_setup(char *str)
+mptscsih_setup(char *str)
 {
     char *cur = str;
     char *pc, *pv;
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptscsih.h
linux-2.6.0-test9/drivers/message/fusion/mptscsih.h
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptscsih.h
2003-10-25 12:44:58.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptscsih.h    2003-11-11
10:33:58.000000000 -0700
@@ -15,10 +15,10 @@
  *
  *      (see also mptbase.c)
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptscsih.h,v 1.21 2002/12/03 21:26:35 pdelaney Exp $
  */
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/scsi3.h
linux-2.6.0-test9/drivers/message/fusion/scsi3.h
--- linux-2.6.0-test9-reference/drivers/message/fusion/scsi3.h    2003-10-25
12:43:30.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/scsi3.h    2003-11-11
10:33:58.000000000 -0700
@@ -4,10 +4,10 @@
  *      (Ultimately) SCSI-3 definitions; for now, inheriting
  *      SCSI-2 definitions.
  *
- *  Copyright (c) 1996-2002 Steven J. Ralston
+ *  Copyright (c) 1996-2003 Steven J. Ralston
  *  Written By: Steven J. Ralston (19960517)
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: scsi3.h,v 1.9 2002/02/27 18:45:02 sralston Exp $
  */


