From: tglx@linutronix.de
Subject: (unknown)
Date: Wed, 12 Jan 2005 23:37:56 +0100
Message-ID: <20050112233756.17.patchmail@tglx>
References: <20050112233741.1.patchmail@tglx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pD953A867.dip.t-dialin.net ([217.83.168.103]:44166 "EHLO
	tglx.tec.linutronix.de") by vger.kernel.org with ESMTP
	id S261488AbVALWid (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 17:38:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: akpm@osdl.org, SCSI <mingo@elte.hu>

Sorry guys for making noise. I messed up the trees. The previous one
was against 2.6.10. I also fixed the requested patchsplits and maintainer
address changes

tglx

Use the new lock initializers DEFINE_SPIN_LOCK and DEFINE_RW_LOCK

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 aha1542.c              |    2 +-
 dpt_i2o.c              |    2 +-
 eata.c                 |    2 +-
 esp.c                  |    2 +-
 imm.c                  |    2 +-
 ipr.c                  |    2 +-
 osst.c                 |    2 +-
 ppa.c                  |    2 +-
 qlogicpti.c            |    2 +-
 scsi.c                 |    2 +-
 scsi_debug.c           |    6 +++---
 sd.c                   |    2 +-
 sg.c                   |    2 +-
 sr.c                   |    2 +-
 st.c                   |    2 +-
 sym53c416.c            |    2 +-
 sym53c8xx_2/sym_glue.c |    2 +-
 sym53c8xx_comm.h       |    2 +-
 u14-34f.c              |    2 +-
 19 files changed, 21 insertions(+), 21 deletions(-)
---
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/aha1542.c linux-2.6.11-rc1-l4/drivers/scsi/aha1542.c
--- linux-2.6.11-rc1.orig/drivers/scsi/aha1542.c	2005-01-12 22:56:21.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/aha1542.c	2005-01-12 23:01:53.000000000 +0100
@@ -167,7 +167,7 @@
 
 static struct Scsi_Host *aha_host[7];	/* One for each IRQ level (9-15) */
 
-static spinlock_t aha1542_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(aha1542_lock);
 
 
 
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/dpt_i2o.c linux-2.6.11-rc1-l4/drivers/scsi/dpt_i2o.c
--- linux-2.6.11-rc1.orig/drivers/scsi/dpt_i2o.c	2005-01-12 22:56:22.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/dpt_i2o.c	2005-01-12 23:01:55.000000000 +0100
@@ -145,7 +145,7 @@
 
 static struct adpt_i2o_post_wait_data *adpt_post_wait_queue = NULL;
 static u32 adpt_post_wait_id = 0;
-static spinlock_t adpt_post_wait_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(adpt_post_wait_lock);
 
 
 /*============================================================================
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/eata.c linux-2.6.11-rc1-l4/drivers/scsi/eata.c
--- linux-2.6.11-rc1.orig/drivers/scsi/eata.c	2005-01-12 22:56:22.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/eata.c	2005-01-12 23:01:56.000000000 +0100
@@ -839,7 +839,7 @@
 static struct Scsi_Host *sh[MAX_BOARDS];
 static const char *driver_name = "EATA";
 static char sha[MAX_BOARDS];
-static spinlock_t driver_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(driver_lock);
 
 /* Initialize num_boards so that ihdlr can work while detect is in progress */
 static unsigned int num_boards = MAX_BOARDS;
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/esp.c linux-2.6.11-rc1-l4/drivers/scsi/esp.c
--- linux-2.6.11-rc1.orig/drivers/scsi/esp.c	2004-10-18 23:55:29.000000000 +0200
+++ linux-2.6.11-rc1-l4/drivers/scsi/esp.c	2005-01-12 23:01:49.000000000 +0100
@@ -185,7 +185,7 @@
 
 /* The master ring of all esp hosts we are managing in this driver. */
 static struct esp *espchain;
-static spinlock_t espchain_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(espchain_lock);
 static int esps_running = 0;
 
 /* Forward declarations. */
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/imm.c linux-2.6.11-rc1-l4/drivers/scsi/imm.c
--- linux-2.6.11-rc1.orig/drivers/scsi/imm.c	2005-01-12 13:25:19.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/imm.c	2005-01-12 23:01:53.000000000 +0100
@@ -60,7 +60,7 @@
 	return *(imm_struct **)&host->hostdata;
 }
 
-static spinlock_t arbitration_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(arbitration_lock);
 
 static void got_it(imm_struct *dev)
 {
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/ipr.c linux-2.6.11-rc1-l4/drivers/scsi/ipr.c
--- linux-2.6.11-rc1.orig/drivers/scsi/ipr.c	2005-01-12 22:56:22.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/ipr.c	2005-01-12 23:01:51.000000000 +0100
@@ -89,7 +89,7 @@
 static unsigned int ipr_log_level = IPR_DEFAULT_LOG_LEVEL;
 static unsigned int ipr_max_speed = 1;
 static int ipr_testmode = 0;
-static spinlock_t ipr_driver_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(ipr_driver_lock);
 
 /* This table describes the differences between DMA controller chips */
 static const struct ipr_chip_cfg_t ipr_chip_cfg[] = {
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/osst.c linux-2.6.11-rc1-l4/drivers/scsi/osst.c
--- linux-2.6.11-rc1.orig/drivers/scsi/osst.c	2005-01-12 13:25:20.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/osst.c	2005-01-12 23:01:58.000000000 +0100
@@ -148,7 +148,7 @@
 static int osst_nr_dev;
 
 static OS_Scsi_Tape **os_scsi_tapes = NULL;
-static rwlock_t  os_scsi_tapes_lock = RW_LOCK_UNLOCKED;
+static DEFINE_RWLOCK(os_scsi_tapes_lock);
 
 static int modes_defined = FALSE;
 
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/ppa.c linux-2.6.11-rc1-l4/drivers/scsi/ppa.c
--- linux-2.6.11-rc1.orig/drivers/scsi/ppa.c	2004-10-18 23:55:36.000000000 +0200
+++ linux-2.6.11-rc1-l4/drivers/scsi/ppa.c	2005-01-12 23:01:56.000000000 +0100
@@ -49,7 +49,7 @@
 	return *(ppa_struct **)&host->hostdata;
 }
 
-static spinlock_t arbitration_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(arbitration_lock);
 
 static void got_it(ppa_struct *dev)
 {
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/qlogicpti.c linux-2.6.11-rc1-l4/drivers/scsi/qlogicpti.c
--- linux-2.6.11-rc1.orig/drivers/scsi/qlogicpti.c	2004-10-18 23:54:39.000000000 +0200
+++ linux-2.6.11-rc1-l4/drivers/scsi/qlogicpti.c	2005-01-12 23:01:50.000000000 +0100
@@ -56,7 +56,7 @@
 #include "qlogicpti_asm.c"
 
 static struct qlogicpti *qptichain = NULL;
-static spinlock_t qptichain_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(qptichain_lock);
 static int qptis_running = 0;
 
 #define PACKB(a, b)			(((a)<<4)|(b))
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/scsi.c linux-2.6.11-rc1-l4/drivers/scsi/scsi.c
--- linux-2.6.11-rc1.orig/drivers/scsi/scsi.c	2005-01-12 22:56:23.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/scsi.c	2005-01-12 23:01:59.000000000 +0100
@@ -925,7 +925,7 @@
  */
 void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, int tags)
 {
-	static spinlock_t device_request_lock = SPIN_LOCK_UNLOCKED;
+	static DEFINE_SPINLOCK(device_request_lock);
 	unsigned long flags;
 
 	/*
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/scsi_debug.c linux-2.6.11-rc1-l4/drivers/scsi/scsi_debug.c
--- linux-2.6.11-rc1.orig/drivers/scsi/scsi_debug.c	2005-01-12 22:56:23.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/scsi_debug.c	2005-01-12 23:01:51.000000000 +0100
@@ -169,7 +169,7 @@
 	container_of(d, struct sdebug_host_info, dev)
 
 static LIST_HEAD(sdebug_host_list);
-static spinlock_t sdebug_host_list_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sdebug_host_list_lock);
 
 typedef void (* done_funct_t) (struct scsi_cmnd *);
 
@@ -213,8 +213,8 @@
 static int num_bus_resets = 0;
 static int num_host_resets = 0;
 
-static spinlock_t queued_arr_lock = SPIN_LOCK_UNLOCKED;
-static rwlock_t atomic_rw = RW_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(queued_arr_lock);
+static DEFINE_RWLOCK(atomic_rw);
 
 static char sdebug_proc_name[] = "scsi_debug";
 
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/sd.c linux-2.6.11-rc1-l4/drivers/scsi/sd.c
--- linux-2.6.11-rc1.orig/drivers/scsi/sd.c	2005-01-12 13:25:22.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/sd.c	2005-01-12 23:01:58.000000000 +0100
@@ -105,7 +105,7 @@
 };
 
 static DEFINE_IDR(sd_index_idr);
-static spinlock_t sd_index_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sd_index_lock);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
  * face of object destruction (i.e. we can't allow a get on an
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/sg.c linux-2.6.11-rc1-l4/drivers/scsi/sg.c
--- linux-2.6.11-rc1.orig/drivers/scsi/sg.c	2005-01-12 13:25:22.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/sg.c	2005-01-12 23:01:59.000000000 +0100
@@ -108,7 +108,7 @@
 
 static Scsi_Request *dummy_cmdp;	/* only used for sizeof */
 
-static rwlock_t sg_dev_arr_lock = RW_LOCK_UNLOCKED;	/* Also used to lock
+static DEFINE_RWLOCK(sg_dev_arr_lock);	/* Also used to lock
 							   file descriptor list for device */
 
 static struct class_interface sg_interface = {
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/sr.c linux-2.6.11-rc1-l4/drivers/scsi/sr.c
--- linux-2.6.11-rc1.orig/drivers/scsi/sr.c	2005-01-12 22:56:24.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/sr.c	2005-01-12 23:01:55.000000000 +0100
@@ -85,7 +85,7 @@
 };
 
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
-static spinlock_t sr_index_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sr_index_lock);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
  * face of object destruction (i.e. we can't allow a get on an
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/st.c linux-2.6.11-rc1-l4/drivers/scsi/st.c
--- linux-2.6.11-rc1.orig/drivers/scsi/st.c	2005-01-12 13:25:22.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/st.c	2005-01-12 23:01:57.000000000 +0100
@@ -167,7 +167,7 @@
    24 bits) */
 #define SET_DENS_AND_BLK 0x10001
 
-static rwlock_t st_dev_arr_lock = RW_LOCK_UNLOCKED;
+static DEFINE_RWLOCK(st_dev_arr_lock);
 
 static int st_fixed_buffer_size = ST_FIXED_BUFFER_SIZE;
 static int st_max_sg_segs = ST_MAX_SG;
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/sym53c416.c linux-2.6.11-rc1-l4/drivers/scsi/sym53c416.c
--- linux-2.6.11-rc1.orig/drivers/scsi/sym53c416.c	2005-01-12 13:25:22.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/sym53c416.c	2005-01-12 23:01:50.000000000 +0100
@@ -239,7 +239,7 @@
 	outb((len & 0xFF0000) >> 16, base + TC_HIGH);
 }
 
-static spinlock_t sym53c416_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sym53c416_lock);
 
 /* Returns the number of bytes read */
 static __inline__ unsigned int sym53c416_read(int base, unsigned char *buffer, unsigned int len)
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/sym53c8xx_2/sym_glue.c linux-2.6.11-rc1-l4/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linux-2.6.11-rc1.orig/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-01-12 13:25:23.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-01-12 23:02:03.000000000 +0100
@@ -147,7 +147,7 @@
 }
 
 /* This lock protects only the memory allocation/free.  */
-spinlock_t sym53c8xx_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(sym53c8xx_lock);
 
 static struct scsi_transport_template *sym2_transport_template = NULL;
 
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/sym53c8xx_comm.h linux-2.6.11-rc1-l4/drivers/scsi/sym53c8xx_comm.h
--- linux-2.6.11-rc1.orig/drivers/scsi/sym53c8xx_comm.h	2005-01-12 13:25:23.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/sym53c8xx_comm.h	2005-01-12 23:01:55.000000000 +0100
@@ -250,7 +250,7 @@
 	}
 }
 
-static spinlock_t ncr53c8xx_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(ncr53c8xx_lock);
 
 static void *__m_calloc2(m_pool_s *mp, int size, char *name, int uflags)
 {
diff -urN linux-2.6.11-rc1.orig/drivers/scsi/u14-34f.c linux-2.6.11-rc1-l4/drivers/scsi/u14-34f.c
--- linux-2.6.11-rc1.orig/drivers/scsi/u14-34f.c	2005-01-12 13:25:23.000000000 +0100
+++ linux-2.6.11-rc1-l4/drivers/scsi/u14-34f.c	2005-01-12 23:01:49.000000000 +0100
@@ -612,7 +612,7 @@
 static struct Scsi_Host *sh[MAX_BOARDS + 1];
 static const char *driver_name = "Ux4F";
 static char sha[MAX_BOARDS];
-static spinlock_t driver_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(driver_lock);
 
 /* Initialize num_boards so that ihdlr can work while detect is in progress */
 static unsigned int num_boards = MAX_BOARDS;
