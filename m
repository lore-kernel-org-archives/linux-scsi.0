From: Anton Blanchard <anton@samba.org>
Subject: qlogic FC driver in 2.5
Date: Fri, 13 Dec 2002 00:51:24 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021212135124.GF6278@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

I started looking at the various qlogic FC drivers. I spent a number of
hours trying to work through the qlogic vendor driver but did not have
much luck (my test box is ppc64...). I also couldnt get the in kernel
driver to work. This was all in 2.4.

I tried Matt Jacob's and to my surprise it worked first time (also 2.4).
Based on this I took a look at what needed to be done for 2.5. Here is
the patch so far, still lots of loose ends but its enough to get us
up and running with ppc64/2.5.51 and a rather large fastt700 array.

Summary:

- We now use page_address(sg->page) + sg->offset not sg->address
- isplinux_biosparam changed arguments
- slave_configure now looks to set the tag depth on a per device basis.
  Seems to replace select_queue_depths which is not used any more.
  NFI what I should be doing here. 63 sounds like a good magic number.
- Need to take the host_lock in the interrupt routine
- loaded_as_module got killed. Im not using modules so I hardwired this
  guy for the moment.
- No more io_request_lock (per HBA host_lock replaced it)

The locking needs a look over in light of the 2.5 changes (Matt was
suggesting the driver spinlock could be replaced with the host_lock).
He also mentioned my 63 magic number should be fixed :) 

Any thoughts on these issues? Id like to see them sorted out so we
can get this merged into 2.5.

PS the driver can be found at:

http://www.feral.com/isp.html

Anton

diff -ru isp_orig/linux/isp_linux.c isp/linux/isp_linux.c
--- isp_orig/linux/isp_linux.c	2002-10-15 11:18:36.000000000 +1000
+++ isp/linux/isp_linux.c	2002-12-11 18:53:03.000000000 +1100
@@ -819,6 +819,7 @@
     if (isp->isp_psco[Cmnd->channel][Cmnd->target] == 0) {
 	int i, b;
 	caddr_t iqd;
+	struct scatterlist *sg;
 	sdparam *sdp = (sdparam *) isp->isp_param;
 
 	sdp += Cmnd->channel;
@@ -826,7 +827,8 @@
 	    if (Cmnd->use_sg == 0) {
 		iqd = (caddr_t) Cmnd->buffer;
 	    } else {
-		iqd = ((struct scatterlist *) Cmnd->request_buffer)->address;
+		sg = ((struct scatterlist *)Cmnd->request_buffer);
+		iqd = page_address(sg->page) + sg->offset;
 	    }
 	    sdp->isp_devparam[Cmnd->target].goal_flags &=
 		~(DPARM_TQING|DPARM_SYNC|DPARM_WIDE);
@@ -2329,9 +2331,10 @@
 }
 
 int
-isplinux_biosparam(Disk *disk, kdev_t n, int ip[])
+isplinux_biosparam(struct scsi_device *sdev, struct block_device *n,
+		   sector_t capacity, int ip[])
 {
-    int size = disk->capacity;
+    int size = capacity;
     ip[0] = 64;
     ip[1] = 32;
     ip[2] = size >> 11;
@@ -2347,6 +2350,7 @@
  * Set the queue depth for this device.
  */
 
+#if 0
 void
 isplinux_sqd(struct Scsi_Host *host, Scsi_Device *devs)
 {
@@ -2382,6 +2386,16 @@
 	devs = devs->next;
     }
 }
+#endif
+
+static int
+isplinux_slave_configure(Scsi_Device * device)
+{
+	if (device->tagged_supported)
+                scsi_adjust_queue_depth(device, MSG_ORDERED_TAG, 63);
+
+        return 0;
+}
 
 /*
  * Periodic watchdog timer.. the main purpose here is to restart
@@ -2454,11 +2468,14 @@
     u_int16_t isr, sema, mbox;
     Scsi_Cmnd *Cmnd;
 
+    spin_lock(isp->isp_osinfo.host->host_lock);
+
     ISP_ILOCK_SOFTC(isp);
     isp->isp_intcnt++;
     if (ISP_READ_ISR(isp, &isr, &sema, &mbox) == 0) {
 	isp->isp_intbogus++;
 	ISP_IUNLK_SOFTC(isp);
+	spin_unlock(isp->isp_osinfo.host->host_lock);
 	return;
     }
     isp_intr(isp, isr, sema, mbox);
@@ -2499,6 +2516,7 @@
 	}
 	ISP_UNLK_SCSI_DONE(isp);
     }
+    spin_unlock(isp->isp_osinfo.host->host_lock);
 }
 
 static INLINE int
@@ -2889,7 +2907,7 @@
     int action, nactions, exit_thread = 0;
     isp_thread_action_t curactions[MAX_THREAD_ACTION];
 
-    if (isp->isp_host->loaded_as_module) {
+    if (0) {
 	siginitsetinv(&current->blocked, sigmask(SIGHUP));
     } else {
 	siginitsetinv(&current->blocked, 0);
@@ -2904,13 +2922,13 @@
     if (isp->isp_osinfo.task_ctl_sem) {
 	up(isp->isp_osinfo.task_ctl_sem);
     }
-    isp_prt(isp, ISP_LOGDEBUG1, "isp_task_thread starting (%d)",
+    isp_prt(isp, ISP_LOGDEBUG1, "isp_task_thread starting (%lx)",
 	in_interrupt());
 
     while (exit_thread == 0) {
 	isp_prt(isp, ISP_LOGDEBUG1, "isp_task_thread sleeping");
 	down_interruptible(&thread_sleep_semaphore);
-	if (isp->isp_host->loaded_as_module) {
+	if (0) {
 	    if (signal_pending(current))
 		break;
 	}
@@ -2986,7 +3004,7 @@
 		ISP_UNLKU_SOFTC(isp);
 		break;
 	    case ISP_THREAD_EXIT:
-		if (isp->isp_host->loaded_as_module) {
+		if (0) {
 		    exit_thread = 1;
 		}
 		break;
diff -ru isp_orig/linux/isp_linux.h isp/linux/isp_linux.h
--- isp_orig/linux/isp_linux.h	2002-10-15 11:18:36.000000000 +1000
+++ isp/linux/isp_linux.h	2002-12-12 00:05:06.000000000 +1100
@@ -95,7 +95,6 @@
 #include <linux/interrupt.h>
 #include "scsi.h"
 #include "hosts.h"
-#include "sd.h"
 
 /*
  * These bits and pieces of keeping track of Linux versions
@@ -397,8 +396,13 @@
 #define	ISP_LOCKU_SOFTC			ISP_ILOCK_SOFTC
 #define	ISP_UNLKU_SOFTC			ISP_IUNLK_SOFTC
 #define	ISP_TLOCK_INIT(isp)		spin_lock_init(&isp->isp_osinfo.tlock)
+#if 0
 #define	ISP_DRIVER_ENTRY_LOCK(isp)	spin_unlock_irq(&io_request_lock)
 #define	ISP_DRIVER_EXIT_LOCK(isp)	spin_lock_irq(&io_request_lock)
+#else
+#define	ISP_DRIVER_ENTRY_LOCK(isp)
+#define	ISP_DRIVER_EXIT_LOCK(isp)
+#endif
 
 #define	ISP_MUST_POLL(isp)	(in_interrupt() || isp->mbintsok == 0)
 /*
@@ -721,9 +725,8 @@
 #endif
 const char *isplinux_info(struct Scsi_Host *);
 int isplinux_queuecommand(Scsi_Cmnd *, void (* done)(Scsi_Cmnd *));
-int isplinux_biosparam(Disk *, kdev_t, int[]);
-
-
+int isplinux_biosparam(struct scsi_device *, struct block_device *, sector_t,
+		      int[]);
 /*
  * Driver wide data...
  */
@@ -878,7 +881,6 @@
 int isplinux_sreset(Scsi_Cmnd *);
 int isplinux_hreset(Scsi_Cmnd *);
 #define QLOGICISP {							\
-	next:				NULL,				\
 	module:				NULL,				\
 	proc_info:			isplinux_proc_info,		\
 	name:				"Qlogic ISP 10X0/2X00",		\
@@ -886,7 +888,6 @@
 	release:			isplinux_release,		\
 	info:				isplinux_info,			\
 	queuecommand:			isplinux_queuecommand,		\
-	use_new_eh_code:		1,				\
 	eh_abort_handler:		isplinux_abort,			\
 	eh_device_reset_handler:	isplinux_bdr,			\
 	eh_bus_reset_handler:		isplinux_sreset,		\
@@ -895,7 +896,8 @@
 	can_queue:			1,	   			\
 	sg_tablesize:			SG_ALL,				\
 	use_clustering:			ENABLE_CLUSTERING,		\
-	cmd_per_lun:			1				\
+	cmd_per_lun:			1,				\
+	slave_configure:		isplinux_slave_configure,	\
 }
 /*
  * mode: c
diff -ru isp_orig/linux/isp_pci.c isp/linux/isp_pci.c
--- isp_orig/linux/isp_pci.c	2002-10-15 11:18:36.000000000 +1000
+++ isp/linux/isp_pci.c	2002-12-11 13:39:21.000000000 +1100
@@ -787,7 +787,7 @@
 	goto bad;
     }
     host->irq = irq;
-    host->select_queue_depths = isplinux_sqd;
+    //host->select_queue_depths = isplinux_sqd;
     isp->isp_param = &isp_pci->params;
 #ifdef	LINUX_ISP_TARGET_MODE
     isp->isp_osinfo.pool = isp_pci->rpool;

