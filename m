From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] split private and public scsi headers
Date: Sat, 26 Apr 2003 23:30:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030426233054.A22823@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:11272 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263037AbTDZVSo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 17:18:44 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Two new headers:

  scsi_priv.h - for macros/declarations private to the scsi midlayer
		  (= not EXPORT_SYMBOL()ed)
  scsi_logging.h - for SCSI_LOG_* and friends, semi-private to the
  		midlayer and the upper drivers.  One abuse of this
		in dpt_i2o killed.


--- 1.27/drivers/scsi/dpt_i2o.c	Wed Feb 26 22:03:02 2003
+++ edited/drivers/scsi/dpt_i2o.c	Sat Apr 26 20:04:25 2003
@@ -2495,8 +2495,6 @@
 				pDev->pScsi_dev->online = FALSE;
 				if (pDev->pScsi_dev->access_count) {
 					// A drive that was mounted is no longer there... bad!
-					SCSI_LOG_ERROR_RECOVERY(1, printk ("%s:Rescan: Previously "
-								 "mounted drive not found!\n",pHba->name));
 					printk(KERN_WARNING"%s:Mounted drive taken offline\n",pHba->name);
 				}
 			}
--- 1.57/drivers/scsi/hosts.c	Tue Apr 15 13:20:37 2003
+++ edited/drivers/scsi/hosts.c	Sat Apr 26 20:04:25 2003
@@ -32,19 +32,19 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/mm.h>
-#include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/completion.h>
-
-#define __KERNEL_SYSCALLS__
-
 #include <linux/unistd.h>
 #include <asm/dma.h>
 
 #include "scsi.h"
 #include "hosts.h"
+
+#include "scsi_priv.h"
+#include "scsi_logging.h"
+
 
 static LIST_HEAD(scsi_host_list);
 static spinlock_t scsi_host_list_lock = SPIN_LOCK_UNLOCKED;
===== drivers/scsi/hosts.h 1.58 vs edited =====
--- 1.58/drivers/scsi/hosts.h	Mon Mar 24 07:14:28 2003
+++ edited/drivers/scsi/hosts.h	Sat Apr 26 20:04:25 2003
@@ -527,13 +527,6 @@
         return shost->host_gendev;
 }
 
-/*
- * Prototypes for functions/data in scsi_scan.c
- */
-extern void scsi_scan_host(struct Scsi_Host *);
-extern void scsi_forget_host(struct Scsi_Host *);
-
-
 struct Scsi_Device_Template
 {
     struct list_head list;
@@ -572,16 +565,8 @@
 extern int scsi_register_host(Scsi_Host_Template *);
 extern int scsi_unregister_host(Scsi_Host_Template *);
 
-extern struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_hn_get(unsigned short);
 extern void scsi_host_put(struct Scsi_Host *);
-extern void scsi_host_init(void);
-
-/*
- * host_busy inc/dec/test functions
- */
-extern void scsi_host_busy_inc(struct Scsi_Host *, Scsi_Device *);
-extern void scsi_host_busy_dec_and_test(struct Scsi_Host *, Scsi_Device *);
 
 /**
  * scsi_find_device - find a device given the host
@@ -610,21 +595,3 @@
 extern struct device_class shost_devclass;
 
 #endif
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
--- 1.105/drivers/scsi/scsi.c	Sat Apr 26 14:36:16 2003
+++ edited/drivers/scsi/scsi.c	Sat Apr 26 20:04:43 2003
@@ -55,6 +55,9 @@
 #include "scsi.h"
 #include "hosts.h"
 
+#include "scsi_priv.h"
+#include "scsi_logging.h"
+
 
 /*
  * Definitions and constants.
--- 1.75/drivers/scsi/scsi.h	Wed Apr 23 04:06:29 2003
+++ edited/drivers/scsi/scsi.h	Sat Apr 26 20:04:25 2003
@@ -18,7 +18,6 @@
 #include <linux/config.h>	    /* for CONFIG_SCSI_LOGGING */
 #include <scsi/scsi.h>
 
-
 /*
  * These are the values that the SCpnt->sc_data_direction and 
  * SRpnt->sr_data_direction can take.  These need to be set
@@ -126,144 +125,11 @@
 #define SCSI_STATE_BHQUEUE         0x100a
 #define SCSI_STATE_MLQUEUE         0x100b
 
-/*
- * These are the values that the owner field can take.
- * They are used as an indication of who the command belongs to.
- */
-#define SCSI_OWNER_HIGHLEVEL      0x100
-#define SCSI_OWNER_MIDLEVEL       0x101
-#define SCSI_OWNER_LOWLEVEL       0x102
-#define SCSI_OWNER_ERROR_HANDLER  0x103
-#define SCSI_OWNER_BH_HANDLER     0x104
-#define SCSI_OWNER_NOBODY         0x105
-
 #define IDENTIFY_BASE       0x80
 #define IDENTIFY(can_disconnect, lun)   (IDENTIFY_BASE |\
 		     ((can_disconnect) ?  0x40 : 0) |\
 		     ((lun) & 0x07))
 
-
-/*
- * This defines the scsi logging feature.  It is a means by which the
- * user can select how much information they get about various goings on,
- * and it can be really useful for fault tracing.  The logging word is divided
- * into 8 nibbles, each of which describes a loglevel.  The division of things
- * is somewhat arbitrary, and the division of the word could be changed if it
- * were really needed for any reason.  The numbers below are the only place where these
- * are specified.  For a first go-around, 3 bits is more than enough, since this
- * gives 8 levels of logging (really 7, since 0 is always off).  Cutting to 2 bits
- * might be wise at some point.
- */
-
-#define SCSI_LOG_ERROR_SHIFT              0
-#define SCSI_LOG_TIMEOUT_SHIFT            3
-#define SCSI_LOG_SCAN_SHIFT               6
-#define SCSI_LOG_MLQUEUE_SHIFT            9
-#define SCSI_LOG_MLCOMPLETE_SHIFT         12
-#define SCSI_LOG_LLQUEUE_SHIFT            15
-#define SCSI_LOG_LLCOMPLETE_SHIFT         18
-#define SCSI_LOG_HLQUEUE_SHIFT            21
-#define SCSI_LOG_HLCOMPLETE_SHIFT         24
-#define SCSI_LOG_IOCTL_SHIFT              27
-
-#define SCSI_LOG_ERROR_BITS               3
-#define SCSI_LOG_TIMEOUT_BITS             3
-#define SCSI_LOG_SCAN_BITS                3
-#define SCSI_LOG_MLQUEUE_BITS             3
-#define SCSI_LOG_MLCOMPLETE_BITS          3
-#define SCSI_LOG_LLQUEUE_BITS             3
-#define SCSI_LOG_LLCOMPLETE_BITS          3
-#define SCSI_LOG_HLQUEUE_BITS             3
-#define SCSI_LOG_HLCOMPLETE_BITS          3
-#define SCSI_LOG_IOCTL_BITS               3
-
-#ifdef CONFIG_SCSI_LOGGING
-
-#define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)     \
-{                                                       \
-        unsigned int mask;                              \
-                                                        \
-        mask = (1 << (BITS)) - 1;                       \
-        if( ((scsi_logging_level >> (SHIFT)) & mask) > (LEVEL) ) \
-        {                                               \
-                (CMD);                                  \
-        }						\
-}
-
-#define SCSI_SET_LOGGING(SHIFT, BITS, LEVEL)            \
-{                                                       \
-        unsigned int mask;                              \
-                                                        \
-        mask = ((1 << (BITS)) - 1) << SHIFT;            \
-        scsi_logging_level = ((scsi_logging_level & ~mask) \
-                              | ((LEVEL << SHIFT) & mask));     \
-}
-
-
-
-#else
-
-/*
- * With no logging enabled, stub these out so they don't do anything.
- */
-#define SCSI_SET_LOGGING(SHIFT, BITS, LEVEL)
-
-#define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)
-#endif
-
-/*
- * These are the macros that are actually used throughout the code to
- * log events.  If logging isn't enabled, they are no-ops and will be
- * completely absent from the user's code.
- *
- * The 'set' versions of the macros are really intended to only be called
- * from the /proc filesystem, and in production kernels this will be about
- * all that is ever used.  It could be useful in a debugging environment to
- * bump the logging level when certain strange events are detected, however.
- */
-#define SCSI_LOG_ERROR_RECOVERY(LEVEL,CMD)  \
-        SCSI_CHECK_LOGGING(SCSI_LOG_ERROR_SHIFT, SCSI_LOG_ERROR_BITS, LEVEL,CMD);
-#define SCSI_LOG_TIMEOUT(LEVEL,CMD)  \
-        SCSI_CHECK_LOGGING(SCSI_LOG_TIMEOUT_SHIFT, SCSI_LOG_TIMEOUT_BITS, LEVEL,CMD);
-#define SCSI_LOG_SCAN_BUS(LEVEL,CMD)  \
-        SCSI_CHECK_LOGGING(SCSI_LOG_SCAN_SHIFT, SCSI_LOG_SCAN_BITS, LEVEL,CMD);
-#define SCSI_LOG_MLQUEUE(LEVEL,CMD)  \
-        SCSI_CHECK_LOGGING(SCSI_LOG_MLQUEUE_SHIFT, SCSI_LOG_MLQUEUE_BITS, LEVEL,CMD);
-#define SCSI_LOG_MLCOMPLETE(LEVEL,CMD)  \
-        SCSI_CHECK_LOGGING(SCSI_LOG_MLCOMPLETE_SHIFT, SCSI_LOG_MLCOMPLETE_BITS, LEVEL,CMD);
-#define SCSI_LOG_LLQUEUE(LEVEL,CMD)  \
-        SCSI_CHECK_LOGGING(SCSI_LOG_LLQUEUE_SHIFT, SCSI_LOG_LLQUEUE_BITS, LEVEL,CMD);
-#define SCSI_LOG_LLCOMPLETE(LEVEL,CMD)  \
-        SCSI_CHECK_LOGGING(SCSI_LOG_LLCOMPLETE_SHIFT, SCSI_LOG_LLCOMPLETE_BITS, LEVEL,CMD);
-#define SCSI_LOG_HLQUEUE(LEVEL,CMD)  \
-        SCSI_CHECK_LOGGING(SCSI_LOG_HLQUEUE_SHIFT, SCSI_LOG_HLQUEUE_BITS, LEVEL,CMD);
-#define SCSI_LOG_HLCOMPLETE(LEVEL,CMD)  \
-        SCSI_CHECK_LOGGING(SCSI_LOG_HLCOMPLETE_SHIFT, SCSI_LOG_HLCOMPLETE_BITS, LEVEL,CMD);
-#define SCSI_LOG_IOCTL(LEVEL,CMD)  \
-        SCSI_CHECK_LOGGING(SCSI_LOG_IOCTL_SHIFT, SCSI_LOG_IOCTL_BITS, LEVEL,CMD);
-
-
-#define SCSI_SET_ERROR_RECOVERY_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_ERROR_SHIFT, SCSI_LOG_ERROR_BITS, LEVEL);
-#define SCSI_SET_TIMEOUT_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_TIMEOUT_SHIFT, SCSI_LOG_TIMEOUT_BITS, LEVEL);
-#define SCSI_SET_SCAN_BUS_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_SCAN_SHIFT, SCSI_LOG_SCAN_BITS, LEVEL);
-#define SCSI_SET_MLQUEUE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_MLQUEUE_SHIFT, SCSI_LOG_MLQUEUE_BITS, LEVEL);
-#define SCSI_SET_MLCOMPLETE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_MLCOMPLETE_SHIFT, SCSI_LOG_MLCOMPLETE_BITS, LEVEL);
-#define SCSI_SET_LLQUEUE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_LLQUEUE_SHIFT, SCSI_LOG_LLQUEUE_BITS, LEVEL);
-#define SCSI_SET_LLCOMPLETE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_LLCOMPLETE_SHIFT, SCSI_LOG_LLCOMPLETE_BITS, LEVEL);
-#define SCSI_SET_HLQUEUE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_HLQUEUE_SHIFT, SCSI_LOG_HLQUEUE_BITS, LEVEL);
-#define SCSI_SET_HLCOMPLETE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_HLCOMPLETE_SHIFT, SCSI_LOG_HLCOMPLETE_BITS, LEVEL);
-#define SCSI_SET_IOCTL_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_IOCTL_SHIFT, SCSI_LOG_IOCTL_BITS, LEVEL);
-
 /* host byte codes */
 #define DID_OK          0x00	/* NO error                                */
 #define DID_NO_CONNECT  0x01	/* Couldn't connect before timeout period  */
@@ -356,6 +222,7 @@
  * Forward-declaration of structs for prototypes.
  */
 struct Scsi_Host;
+struct scsi_target;
 struct scatterlist;
 
 /*
@@ -365,24 +232,12 @@
 typedef struct scsi_cmnd Scsi_Cmnd;
 typedef struct scsi_request Scsi_Request;
 
-#define SCSI_CMND_MAGIC 0xE25C23A5
-#define SCSI_REQ_MAGIC  0x75F6D354
-
-/*
- * Here is where we prototype most of the mid-layer.
- */
-
-extern unsigned int scsi_logging_level;		/* What do we log? */
-
 /*
  * These are the error handling functions defined in scsi_error.c
  */
-extern void scsi_times_out(Scsi_Cmnd * SCpnt);
 extern void scsi_add_timer(Scsi_Cmnd * SCset, int timeout,
 			   void (*complete) (Scsi_Cmnd *));
 extern int scsi_delete_timer(Scsi_Cmnd * SCset);
-extern void scsi_error_handler(void *host);
-extern int scsi_decide_disposition(Scsi_Cmnd * SCpnt);
 extern int scsi_block_when_processing_errors(Scsi_Device *);
 extern void scsi_sleep(int);
 
@@ -396,23 +251,12 @@
 /*
  * Prototypes for functions in scsi_lib.c
  */
-extern int scsi_maybe_unblock_host(Scsi_Device * SDpnt);
-extern void scsi_setup_cmd_retry(Scsi_Cmnd *SCpnt);
 extern void scsi_io_completion(Scsi_Cmnd * SCpnt, int good_sectors,
 			       int block_sectors);
-extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
-extern void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd);
-extern request_queue_t *scsi_alloc_queue(struct scsi_device *sdev);
-extern void scsi_free_queue(request_queue_t *q);
-extern int scsi_init_queue(void);
-extern void scsi_exit_queue(void);
 
 /*
  * Prototypes for functions in scsi.c
  */
-extern int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt);
-extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
-extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int flags);
 extern void scsi_put_command(struct scsi_cmnd *cmd);
 extern void scsi_adjust_queue_depth(Scsi_Device *, int, int);
@@ -422,13 +266,6 @@
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern void scsi_set_device_offline(struct scsi_device *);
-extern void scsi_done(Scsi_Cmnd * SCpnt);
-extern void scsi_finish_command(Scsi_Cmnd *);
-extern int scsi_retry_command(Scsi_Cmnd *);
-extern int scsi_attach_device(struct scsi_device *);
-extern void scsi_detach_device(struct scsi_device *);
-extern void scsi_rescan_device(struct scsi_device *);
-extern int scsi_get_device_flags(unsigned char *vendor, unsigned char *model);
 
 /*
  * Newer request-based interfaces.
@@ -438,30 +275,10 @@
 extern void scsi_wait_req(Scsi_Request *, const void *cmnd,
 			  void *buffer, unsigned bufflen,
 			  int timeout, int retries);
-
 extern void scsi_do_req(Scsi_Request *, const void *cmnd,
 			void *buffer, unsigned bufflen,
 			void (*done) (struct scsi_cmnd *),
 			int timeout, int retries);
-extern int scsi_insert_special_req(Scsi_Request * SRpnt, int);
-extern void scsi_init_cmd_from_req(Scsi_Cmnd *, Scsi_Request *);
-
-/*
- * Prototypes for functions in scsi_proc.c
- */
-#ifdef CONFIG_PROC_FS
-extern int scsi_init_procfs(void);
-extern void scsi_exit_procfs(void);
-
-extern void scsi_proc_host_add(struct Scsi_Host *);
-extern void scsi_proc_host_rm(struct Scsi_Host *);
-#else
-static inline int scsi_init_procfs(void) { return 0; }
-static inline void scsi_exit_procfs(void) { ; }
-
-static inline void scsi_proc_host_add(struct Scsi_Host *);
-static inline void scsi_proc_host_rm(struct Scsi_Host *);
-#endif /* CONFIG_PROC_FS */
 
 /*
  * Prototypes for functions in scsi_scan.c
@@ -486,40 +303,6 @@
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char);
 
-/*
- * dev_info: for the black/white list in the old scsi_static_device_list
- */
-struct dev_info {
-	char *vendor;
-	char *model;
-	char *revision;	/* revision known to be bad, unused */
-	unsigned flags;
-};
-
-extern struct dev_info scsi_static_device_list[];
-
-/*
- * scsi_dev_info_list: structure to hold black/white listed devices.
- */
-struct scsi_dev_info_list {
-	struct list_head dev_info_list;
-	char vendor[8];
-	char model[16];
-	unsigned flags;
-	unsigned compatible; /* for use with scsi_static_device_list entries */
-};
-extern struct list_head scsi_dev_info_list;
-extern int scsi_dev_info_list_add_str(char *);
-
-/*
- * scsi_target: representation of a scsi target, for now, this is only
- * used for single_lun devices. If no one has active IO to the target,
- * starget_sdev_user is NULL, else it points to the active sdev.
- */
-struct scsi_target {
-	struct scsi_device *starget_sdev_user;
-	unsigned int starget_refcnt;
-};
 
 /*
  *  The scsi_device struct contains what we know about each given scsi
@@ -817,11 +600,6 @@
 };
 
 /*
- *  Flag bit for the internal_timeout array
- */
-#define NORMAL_TIMEOUT 0
-
-/*
  * Definitions and prototypes used for scsi mid-level queue.
  */
 #define SCSI_MLQUEUE_HOST_BUSY   0x1055
@@ -829,8 +607,7 @@
 #define SCSI_MLQUEUE_EH_RETRY    0x1057
 
 /*
- * old style reset request from external source
- * (private to sg.c and scsi_error.c, supplied by scsi_obsolete.c)
+ * Reset request from external source
  */
 #define SCSI_TRY_RESET_DEVICE	1
 #define SCSI_TRY_RESET_BUS	2
@@ -922,34 +699,6 @@
         return (Scsi_Cmnd *)req->special;
 }
 
-#define scsi_eh_eflags_chk(scp, flags) (scp->eh_eflags & flags)
-
-#define scsi_eh_eflags_set(scp, flags) do { \
-	scp->eh_eflags |= flags; \
-	} while(0)
-
-#define scsi_eh_eflags_clr(scp, flags) do { \
-	scp->eh_eflags &= ~flags; \
-	} while(0)
-
-#define scsi_eh_eflags_clr_all(scp) (scp->eh_eflags = 0)
-
-/*
- * Scsi Error Handler Flags
- */
-#define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
-#define SCSI_EH_REC_TIMEOUT	0x0002	/* EH retry timed out */
-
-#define SCSI_SENSE_VALID(scmd) ((scmd->sense_buffer[0] & 0x70) == 0x70)
-
-extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
-
 int scsi_set_medium_removal(Scsi_Device *dev, char state);
-
-extern int scsi_device_register(struct scsi_device *);
-extern void scsi_device_unregister(struct scsi_device *);
-
-extern int scsi_sysfs_register(void);
-extern void scsi_sysfs_unregister(void);
 
 #endif /* _SCSI_H */
--- 1.31/drivers/scsi/scsi_debug.c	Mon Mar 31 15:52:02 2003
+++ edited/drivers/scsi/scsi_debug.c	Sat Apr 26 20:04:25 2003
@@ -52,6 +52,7 @@
 #include <linux/version.h>
 #endif
 
+#include "scsi_logging.h"
 #include "scsi_debug.h"
 
 static const char * scsi_debug_version_str = "Version: 1.69 (20030329)";
--- 1.48/drivers/scsi/scsi_error.c	Mon Apr 21 10:17:33 2003
+++ edited/drivers/scsi/scsi_error.c	Sat Apr 26 20:04:25 2003
@@ -28,6 +28,9 @@
 #include "scsi.h"
 #include "hosts.h"
 
+#include "scsi_priv.h"
+#include "scsi_logging.h"
+
 #ifdef DEBUG
 #define SENSE_TIMEOUT SCSI_TIMEOUT
 #else
--- 1.16/drivers/scsi/scsi_ioctl.c	Wed Mar 26 04:47:18 2003
+++ edited/drivers/scsi/scsi_ioctl.c	Sat Apr 26 20:04:25 2003
@@ -23,6 +23,8 @@
 #include "hosts.h"
 #include <scsi/scsi_ioctl.h>
 
+#include "scsi_logging.h"
+
 #define NORMAL_RETRIES			5
 #define IOCTL_NORMAL_TIMEOUT			(10 * HZ)
 #define FORMAT_UNIT_TIMEOUT		(2 * 60 * 60 * HZ)
--- 1.84/drivers/scsi/scsi_lib.c	Mon Apr 21 10:17:33 2003
+++ edited/drivers/scsi/scsi_lib.c	Sat Apr 26 20:04:25 2003
@@ -19,6 +19,9 @@
 #include "scsi.h"
 #include "hosts.h"
 
+#include "scsi_priv.h"
+#include "scsi_logging.h"
+
 
 #define SG_MEMPOOL_NR		5
 #define SG_MEMPOOL_SIZE		32
--- 1.19/drivers/scsi/scsi_proc.c	Wed Apr 23 04:03:43 2003
+++ edited/drivers/scsi/scsi_proc.c	Sat Apr 26 20:46:26 2003
@@ -29,6 +29,10 @@
 #include "scsi.h"
 #include "hosts.h"
 
+#include "scsi_priv.h"
+#include "scsi_logging.h"
+
+
 /* 4K page size, but our output routines, use some slack for overruns */
 #define PROC_BLOCK_SIZE (3*1024)
 
--- 1.80/drivers/scsi/scsi_scan.c	Thu Apr 24 12:55:44 2003
+++ edited/drivers/scsi/scsi_scan.c	Sat Apr 26 20:04:25 2003
@@ -33,9 +33,9 @@
 #include "scsi.h"
 #include "hosts.h"
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
+#include "scsi_priv.h"
+#include "scsi_logging.h"
+
 
 /*
  * Flags for SCSI devices that need special treatment
--- 1.31/drivers/scsi/scsi_syms.c	Mon Apr 21 06:10:29 2003
+++ edited/drivers/scsi/scsi_syms.c	Sat Apr 26 20:04:25 2003
@@ -104,8 +104,6 @@
 /*
  * Externalize timers so that HBAs can safely start/restart commands.
  */
-extern void scsi_add_timer(Scsi_Cmnd *, int, void ((*) (Scsi_Cmnd *)));
-extern int scsi_delete_timer(Scsi_Cmnd *);
 EXPORT_SYMBOL(scsi_add_timer);
 EXPORT_SYMBOL(scsi_delete_timer);
 
--- 1.9/drivers/scsi/scsi_sysfs.c	Mon Mar 17 11:30:31 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Sat Apr 26 20:04:25 2003
@@ -14,6 +14,7 @@
 #include "scsi.h"
 #include "hosts.h"
 
+#include "scsi_priv.h"
 
 /*
  * shost_show_function: macro to create an attr function that can be used to
--- 1.108/drivers/scsi/sd.c	Fri Apr 18 11:58:55 2003
+++ edited/drivers/scsi/sd.c	Sat Apr 26 20:04:25 2003
@@ -52,6 +52,9 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 
+#include "scsi_logging.h"
+
+
 /*
  * Remaining dev_t-handling stuff
  */
--- 1.52/drivers/scsi/sg.c	Sat Apr 26 10:28:28 2003
+++ edited/drivers/scsi/sg.c	Sat Apr 26 20:04:25 2003
@@ -67,6 +67,8 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
 
+#include "scsi_logging.h"
+
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
 static int sg_proc_init(void);
--- 1.76/drivers/scsi/sr.c	Sat Apr 19 17:18:27 2003
+++ edited/drivers/scsi/sr.c	Sat Apr 26 20:04:25 2003
@@ -50,6 +50,7 @@
 #include "hosts.h"
 #include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
 
+#include "scsi_logging.h"
 #include "sr.h"
 
 
--- /dev/null	2002-08-30 19:31:37.000000000 -0400
+++ b/drivers/scsi/scsi_logging.h	2003-04-22 16:21:17.000000000 -0400
@@ -0,0 +1,117 @@
+#ifndef _SCSI_LOGGING_H
+#define _SCSI_LOGGING_H
+
+#include <linux/config.h>
+
+/*
+ * This defines the scsi logging feature.  It is a means by which the user
+ * can select how much information they get about various goings on, and it
+ * can be really useful for fault tracing.  The logging word is divided into
+ * 8 nibbles, each of which describes a loglevel.  The division of things is
+ * somewhat arbitrary, and the division of the word could be changed if it
+ * were really needed for any reason.  The numbers below are the only place
+ * where these are specified.  For a first go-around, 3 bits is more than
+ * enough, since this gives 8 levels of logging (really 7, since 0 is always
+ * off).  Cutting to 2 bits might be wise at some point.
+ */
+
+#define SCSI_LOG_ERROR_SHIFT              0
+#define SCSI_LOG_TIMEOUT_SHIFT            3
+#define SCSI_LOG_SCAN_SHIFT               6
+#define SCSI_LOG_MLQUEUE_SHIFT            9
+#define SCSI_LOG_MLCOMPLETE_SHIFT         12
+#define SCSI_LOG_LLQUEUE_SHIFT            15
+#define SCSI_LOG_LLCOMPLETE_SHIFT         18
+#define SCSI_LOG_HLQUEUE_SHIFT            21
+#define SCSI_LOG_HLCOMPLETE_SHIFT         24
+#define SCSI_LOG_IOCTL_SHIFT              27
+
+#define SCSI_LOG_ERROR_BITS               3
+#define SCSI_LOG_TIMEOUT_BITS             3
+#define SCSI_LOG_SCAN_BITS                3
+#define SCSI_LOG_MLQUEUE_BITS             3
+#define SCSI_LOG_MLCOMPLETE_BITS          3
+#define SCSI_LOG_LLQUEUE_BITS             3
+#define SCSI_LOG_LLCOMPLETE_BITS          3
+#define SCSI_LOG_HLQUEUE_BITS             3
+#define SCSI_LOG_HLCOMPLETE_BITS          3
+#define SCSI_LOG_IOCTL_BITS               3
+
+
+#ifdef CONFIG_SCSI_LOGGING
+extern unsigned int scsi_logging_level;
+#define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)		\
+{								\
+        unsigned int mask = (1 << (BITS)) - 1;			\
+        if (((scsi_logging_level >> (SHIFT)) & mask) > (LEVEL))	\
+		(CMD);						\
+}
+
+#define SCSI_SET_LOGGING(SHIFT, BITS, LEVEL)			\
+{								\
+        unsigned int mask = ((1 << (BITS)) - 1) << SHIFT;	\
+        scsi_logging_level = ((scsi_logging_level & ~mask)	\
+                              | ((LEVEL << SHIFT) & mask));	\
+}
+#else
+/*
+ * With no logging enabled, stub these out so they don't do anything.
+ */
+#define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)
+#define SCSI_SET_LOGGING(SHIFT, BITS, LEVEL)
+#endif /* CONFIG_SCSI_LOGGING */
+
+/*
+ * These are the macros that are actually used throughout the code to
+ * log events.  If logging isn't enabled, they are no-ops and will be
+ * completely absent from the user's code.
+ *
+ * The 'set' versions of the macros are really intended to only be called
+ * from the /proc filesystem, and in production kernels this will be about
+ * all that is ever used.  It could be useful in a debugging environment to
+ * bump the logging level when certain strange events are detected, however.
+ */
+#define SCSI_LOG_ERROR_RECOVERY(LEVEL,CMD)  \
+        SCSI_CHECK_LOGGING(SCSI_LOG_ERROR_SHIFT, SCSI_LOG_ERROR_BITS, LEVEL,CMD);
+#define SCSI_LOG_TIMEOUT(LEVEL,CMD)  \
+        SCSI_CHECK_LOGGING(SCSI_LOG_TIMEOUT_SHIFT, SCSI_LOG_TIMEOUT_BITS, LEVEL,CMD);
+#define SCSI_LOG_SCAN_BUS(LEVEL,CMD)  \
+        SCSI_CHECK_LOGGING(SCSI_LOG_SCAN_SHIFT, SCSI_LOG_SCAN_BITS, LEVEL,CMD);
+#define SCSI_LOG_MLQUEUE(LEVEL,CMD)  \
+        SCSI_CHECK_LOGGING(SCSI_LOG_MLQUEUE_SHIFT, SCSI_LOG_MLQUEUE_BITS, LEVEL,CMD);
+#define SCSI_LOG_MLCOMPLETE(LEVEL,CMD)  \
+        SCSI_CHECK_LOGGING(SCSI_LOG_MLCOMPLETE_SHIFT, SCSI_LOG_MLCOMPLETE_BITS, LEVEL,CMD);
+#define SCSI_LOG_LLQUEUE(LEVEL,CMD)  \
+        SCSI_CHECK_LOGGING(SCSI_LOG_LLQUEUE_SHIFT, SCSI_LOG_LLQUEUE_BITS, LEVEL,CMD);
+#define SCSI_LOG_LLCOMPLETE(LEVEL,CMD)  \
+        SCSI_CHECK_LOGGING(SCSI_LOG_LLCOMPLETE_SHIFT, SCSI_LOG_LLCOMPLETE_BITS, LEVEL,CMD);
+#define SCSI_LOG_HLQUEUE(LEVEL,CMD)  \
+        SCSI_CHECK_LOGGING(SCSI_LOG_HLQUEUE_SHIFT, SCSI_LOG_HLQUEUE_BITS, LEVEL,CMD);
+#define SCSI_LOG_HLCOMPLETE(LEVEL,CMD)  \
+        SCSI_CHECK_LOGGING(SCSI_LOG_HLCOMPLETE_SHIFT, SCSI_LOG_HLCOMPLETE_BITS, LEVEL,CMD);
+#define SCSI_LOG_IOCTL(LEVEL,CMD)  \
+        SCSI_CHECK_LOGGING(SCSI_LOG_IOCTL_SHIFT, SCSI_LOG_IOCTL_BITS, LEVEL,CMD);
+
+
+#define SCSI_SET_ERROR_RECOVERY_LOGGING(LEVEL)  \
+        SCSI_SET_LOGGING(SCSI_LOG_ERROR_SHIFT, SCSI_LOG_ERROR_BITS, LEVEL);
+#define SCSI_SET_TIMEOUT_LOGGING(LEVEL)  \
+        SCSI_SET_LOGGING(SCSI_LOG_TIMEOUT_SHIFT, SCSI_LOG_TIMEOUT_BITS, LEVEL);
+#define SCSI_SET_SCAN_BUS_LOGGING(LEVEL)  \
+        SCSI_SET_LOGGING(SCSI_LOG_SCAN_SHIFT, SCSI_LOG_SCAN_BITS, LEVEL);
+#define SCSI_SET_MLQUEUE_LOGGING(LEVEL)  \
+        SCSI_SET_LOGGING(SCSI_LOG_MLQUEUE_SHIFT, SCSI_LOG_MLQUEUE_BITS, LEVEL);
+#define SCSI_SET_MLCOMPLETE_LOGGING(LEVEL)  \
+        SCSI_SET_LOGGING(SCSI_LOG_MLCOMPLETE_SHIFT, SCSI_LOG_MLCOMPLETE_BITS, LEVEL);
+#define SCSI_SET_LLQUEUE_LOGGING(LEVEL)  \
+        SCSI_SET_LOGGING(SCSI_LOG_LLQUEUE_SHIFT, SCSI_LOG_LLQUEUE_BITS, LEVEL);
+#define SCSI_SET_LLCOMPLETE_LOGGING(LEVEL)  \
+        SCSI_SET_LOGGING(SCSI_LOG_LLCOMPLETE_SHIFT, SCSI_LOG_LLCOMPLETE_BITS, LEVEL);
+#define SCSI_SET_HLQUEUE_LOGGING(LEVEL)  \
+        SCSI_SET_LOGGING(SCSI_LOG_HLQUEUE_SHIFT, SCSI_LOG_HLQUEUE_BITS, LEVEL);
+#define SCSI_SET_HLCOMPLETE_LOGGING(LEVEL)  \
+        SCSI_SET_LOGGING(SCSI_LOG_HLCOMPLETE_SHIFT, SCSI_LOG_HLCOMPLETE_BITS, LEVEL);
+#define SCSI_SET_IOCTL_LOGGING(LEVEL)  \
+        SCSI_SET_LOGGING(SCSI_LOG_IOCTL_SHIFT, SCSI_LOG_IOCTL_BITS, LEVEL);
+
+#endif /* _SCSI_LOGGING_H */
--- /dev/null	2002-08-30 19:31:37.000000000 -0400
+++ b/drivers/scsi/scsi_priv.h	2003-04-26 20:40:32.000000000 -0400
@@ -0,0 +1,146 @@
+#ifndef _SCSI_PRIV_H
+#define _SCSI_PRIV_H
+
+/*
+ * These are the values that the owner field can take.
+ * They are used as an indication of who the command belongs to.
+ */
+#define SCSI_OWNER_HIGHLEVEL      0x100
+#define SCSI_OWNER_MIDLEVEL       0x101
+#define SCSI_OWNER_LOWLEVEL       0x102
+#define SCSI_OWNER_ERROR_HANDLER  0x103
+#define SCSI_OWNER_BH_HANDLER     0x104
+#define SCSI_OWNER_NOBODY         0x105
+
+/*
+ * Magic values for certain scsi structs. Shouldn't ever be used.
+ */
+#define SCSI_CMND_MAGIC		0xE25C23A5
+#define SCSI_REQ_MAGIC		0x75F6D354
+
+/*
+ *  Flag bit for the internal_timeout array
+ */
+#define NORMAL_TIMEOUT		0
+
+/*
+ * Scsi Error Handler Flags
+ */
+#define scsi_eh_eflags_chk(scp, flags) \
+	((scp)->eh_eflags & (flags))
+#define scsi_eh_eflags_set(scp, flags) \
+	do { (scp)->eh_eflags |= (flags); } while(0)
+#define scsi_eh_eflags_clr(scp, flags) \
+	do { (scp)->eh_eflags &= ~(flags); } while(0)
+#define scsi_eh_eflags_clr_all(scp) \
+	(scp->eh_eflags = 0)
+
+#define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
+#define SCSI_EH_REC_TIMEOUT	0x0002	/* EH retry timed out */
+
+#define SCSI_SENSE_VALID(scmd) \
+	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
+
+
+/*
+ * scsi_target: representation of a scsi target, for now, this is only
+ * used for single_lun devices. If no one has active IO to the target,
+ * starget_sdev_user is NULL, else it points to the active sdev.
+ */
+struct scsi_target {
+	struct scsi_device	*starget_sdev_user;
+	unsigned int		starget_refcnt;
+};
+
+
+/* hosts.c */
+extern void scsi_host_busy_inc(struct Scsi_Host *, Scsi_Device *);
+extern void scsi_host_busy_dec_and_test(struct Scsi_Host *, Scsi_Device *);
+extern struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *);
+extern void scsi_host_init(void);
+
+/* scsi.c */
+extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
+extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
+extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
+extern void scsi_done(struct scsi_cmnd *cmd);
+extern void scsi_finish_command(struct scsi_cmnd *cmd);
+extern int scsi_retry_command(struct scsi_cmnd *cmd);
+extern int scsi_attach_device(struct scsi_device *sdev);
+extern void scsi_detach_device(struct scsi_device *sdev);
+extern void scsi_rescan_device(struct scsi_device *sdev);
+extern int scsi_get_device_flags(unsigned char *vendor, unsigned char *model);
+extern int scsi_insert_special_req(struct scsi_request *sreq, int);
+extern void scsi_init_cmd_from_req(struct scsi_cmnd *cmd,
+		struct scsi_request *sreq);
+
+/* scsi_error.c */
+extern void scsi_times_out(struct scsi_cmnd *cmd);
+extern void scsi_error_handler(void *host);
+extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
+extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
+
+/* scsi_lib.c */
+extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
+extern void scsi_setup_cmd_retry(struct scsi_cmnd *cmd);
+extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern void scsi_queue_next_request(struct request_queue *q,
+			struct scsi_cmnd *cmd);
+extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
+extern void scsi_free_queue(struct request_queue *q);
+extern int scsi_init_queue(void);
+extern void scsi_exit_queue(void);
+
+/* scsi_proc.c */
+#ifdef CONFIG_PROC_FS
+extern void scsi_proc_host_add(struct Scsi_Host *);
+extern void scsi_proc_host_rm(struct Scsi_Host *);
+extern int scsi_init_procfs(void);
+extern void scsi_exit_procfs(void);
+#else
+# define scsi_proc_host_add(shost)	do { } while (0)
+# define scsi_proc_host_rm(shost)	do { } while (0)
+# define scsi_init_procfs()		(0)
+# define scsi_exit_procfs		do { } while (0)
+#endif /* CONFIG_PROC_FS */
+
+/* scsi_scan.c */
+extern void scsi_scan_host(struct Scsi_Host *shost);
+extern void scsi_forget_host(struct Scsi_Host *shost);
+
+/* scsi_sysfs.c */
+extern int scsi_device_register(struct scsi_device *);
+extern void scsi_device_unregister(struct scsi_device *);
+extern int scsi_upper_driver_register(struct Scsi_Device_Template *);
+extern void scsi_upper_driver_unregister(struct Scsi_Device_Template *);
+extern int scsi_sysfs_register(void);
+extern void scsi_sysfs_unregister(void);
+
+
+/*
+ * dev_info: for the black/white list in the old scsi_static_device_list
+ */
+struct dev_info {
+	char *vendor;
+	char *model;
+	char *revision;	/* revision known to be bad, unused */
+	unsigned flags;
+};
+
+extern struct dev_info scsi_static_device_list[];
+
+/*
+ * scsi_dev_info_list: structure to hold black/white listed devices.
+ */
+struct scsi_dev_info_list {
+	struct list_head dev_info_list;
+	char vendor[8];
+	char model[16];
+	unsigned flags;
+	unsigned compatible; /* for use with scsi_static_device_list entries */
+};
+
+extern struct list_head scsi_dev_info_list;
+extern int scsi_dev_info_list_add_str(char *);
+
+#endif /* _SCSI_PRIV_H */

