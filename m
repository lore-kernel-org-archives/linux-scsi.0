From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 4/4] scsi: provide UAPI version of scsi/sg.h and scsi/scsi_ioctl.h
Date: Thu, 17 Sep 2015 15:47:27 +0200
Message-ID: <1442497647-17778-1-git-send-email-pbonzini@redhat.com>
References: <1442497338-17019-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbbIQNrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Sep 2015 09:47:31 -0400
In-Reply-To: <1442497338-17019-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Provide a UAPI version of the header in the kernel, making it easier
for interested projects to use an up-to-date version of the header.

The new headers are placed under uapi/linux/ so as not to conflict
with the glibc-provided headers in /usr/include/scsi.

struct scsi_ioctl_command and struct scsi_idlun used to be under
"#ifdef __KERNEL__", but they are actually useful for userspace as
well.  Add them to the new header.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/scsi/scsi_ioctl.h                 |  50 +-----
 include/scsi/sg.h                         | 260 +-----------------------------
 include/uapi/linux/Kbuild                 |   2 +
 include/{scsi => uapi/linux}/scsi_ioctl.h |  23 +--
 include/{scsi => uapi/linux}/sg.h         |  20 +--
 5 files changed, 20 insertions(+), 335 deletions(-)
 copy include/{scsi => uapi/linux}/scsi_ioctl.h (77%)
 copy include/{scsi => uapi/linux}/sg.h (97%)

diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
index 2bd9d67c201a..d54f9db2e079 100644
--- a/include/scsi/scsi_ioctl.h
+++ b/include/scsi/scsi_ioctl.h
@@ -1,60 +1,12 @@
 #ifndef _SCSI_IOCTL_H
 #define _SCSI_IOCTL_H 
 
-#define SCSI_IOCTL_SEND_COMMAND 1
-#define SCSI_IOCTL_TEST_UNIT_READY 2
-#define SCSI_IOCTL_BENCHMARK_COMMAND 3
-#define SCSI_IOCTL_SYNC 4			/* Request synchronous parameters */
-#define SCSI_IOCTL_START_UNIT 5
-#define SCSI_IOCTL_STOP_UNIT 6
-/* The door lock/unlock constants are compatible with Sun constants for
-   the cdrom */
-#define SCSI_IOCTL_DOORLOCK 0x5380		/* lock the eject mechanism */
-#define SCSI_IOCTL_DOORUNLOCK 0x5381		/* unlock the mechanism	  */
-
-/*
- * Here are some obsolete SCSI-specific ioctl commands.
- *
- * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
- */
-
-/* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ */
-#define SCSI_IOCTL_GET_IDLUN		0x5382
-
-/* 0x5383 and 0x5384 were used for SCSI_IOCTL_TAGGED_{ENABLE,DISABLE} */
-
-/* Used to obtain the host number of a device. */
-#define SCSI_IOCTL_PROBE_HOST		0x5385
-
-/* Used to obtain the bus number for a device */
-#define SCSI_IOCTL_GET_BUS_NUMBER	0x5386
-
-/* Used to obtain the PCI location of a device */
-#define SCSI_IOCTL_GET_PCI		0x5387
-
-#ifdef __KERNEL__
+#include <uapi/linux/scsi_ioctl.h>
 
 struct scsi_device;
 
-/*
- * Structures used for scsi_ioctl et al.
- */
-
-typedef struct scsi_ioctl_command {
-	unsigned int inlen;
-	unsigned int outlen;
-	unsigned char data[0];
-} Scsi_Ioctl_Command;
-
-typedef struct scsi_idlun {
-	__u32 dev_id;
-	__u32 host_unique_id;
-} Scsi_Idlun;
-
-
 int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
 		int cmd, bool ndelay);
 extern int scsi_ioctl(struct scsi_device *, int, void __user *);
 
-#endif /* __KERNEL__ */
 #endif /* _SCSI_IOCTL_H */
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 370c78c37926..1c80177b9793 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -2,267 +2,11 @@
 #define _SCSI_GENERIC_H
 
 #include <linux/compiler.h>
+#include <uapi/linux/sg.h>
 
-/*
- * History:
- *  Started: Aug 9 by Lawrence Foard (entropy@world.std.com), to allow user
- *   process control of SCSI devices.
- *  Development Sponsored by Killy Corp. NY NY
- *
- * Original driver (sg.h):
- *       Copyright (C) 1992 Lawrence Foard
- * Version 2 and 3 extensions to driver:
- *	Copyright (C) 1998 - 2014 Douglas Gilbert
- *
- *  Version: 3.5.36 (20140603)
- *  This version is for 2.6 and 3 series kernels.
- *
- * Documentation
- * =============
- * A web site for the SG device driver can be found at:
- *	http://sg.danny.cz/sg  [alternatively check the MAINTAINERS file]
- * The documentation for the sg version 3 driver can be found at:
- *	http://sg.danny.cz/sg/p/sg_v3_ho.html
- * Also see: <kernel_source>/Documentation/scsi/scsi-generic.txt
- *
- * For utility and test programs see: http://sg.danny.cz/sg/sg3_utils.html
- */
-
-#ifdef __KERNEL__
 extern int sg_big_buff; /* for sysctl */
-#endif
-
-
-typedef struct sg_iovec /* same structure as used by readv() Linux system */
-{                       /* call. It defines one scatter-gather element. */
-    void __user *iov_base;      /* Starting address  */
-    size_t iov_len;             /* Length in bytes  */
-} sg_iovec_t;
-
-
-typedef struct sg_io_hdr
-{
-    int interface_id;           /* [i] 'S' for SCSI generic (required) */
-    int dxfer_direction;        /* [i] data transfer direction  */
-    unsigned char cmd_len;      /* [i] SCSI command length */
-    unsigned char mx_sb_len;    /* [i] max length to write to sbp */
-    unsigned short iovec_count; /* [i] 0 implies no scatter gather */
-    unsigned int dxfer_len;     /* [i] byte count of data transfer */
-    void __user *dxferp;	/* [i], [*io] points to data transfer memory
-					      or scatter gather list */
-    unsigned char __user *cmdp; /* [i], [*i] points to command to perform */
-    void __user *sbp;		/* [i], [*o] points to sense_buffer memory */
-    unsigned int timeout;       /* [i] MAX_UINT->no timeout (unit: millisec) */
-    unsigned int flags;         /* [i] 0 -> default, see SG_FLAG... */
-    int pack_id;                /* [i->o] unused internally (normally) */
-    void __user * usr_ptr;      /* [i->o] unused internally */
-    unsigned char status;       /* [o] scsi status */
-    unsigned char masked_status;/* [o] shifted, masked scsi status */
-    unsigned char msg_status;   /* [o] messaging level data (optional) */
-    unsigned char sb_len_wr;    /* [o] byte count actually written to sbp */
-    unsigned short host_status; /* [o] errors from host adapter */
-    unsigned short driver_status;/* [o] errors from software driver */
-    int resid;                  /* [o] dxfer_len - actual_transferred */
-    unsigned int duration;      /* [o] time taken by cmd (unit: millisec) */
-    unsigned int info;          /* [o] auxiliary information */
-} sg_io_hdr_t;  /* 64 bytes long (on i386) */
-
-#define SG_INTERFACE_ID_ORIG 'S'
-
-/* Use negative values to flag difference from original sg_header structure */
-#define SG_DXFER_NONE (-1)      /* e.g. a SCSI Test Unit Ready command */
-#define SG_DXFER_TO_DEV (-2)    /* e.g. a SCSI WRITE command */
-#define SG_DXFER_FROM_DEV (-3)  /* e.g. a SCSI READ command */
-#define SG_DXFER_TO_FROM_DEV (-4) /* treated like SG_DXFER_FROM_DEV with the
-				   additional property than during indirect
-				   IO the user buffer is copied into the
-				   kernel buffers before the transfer */
-#define SG_DXFER_UNKNOWN (-5)   /* Unknown data direction */
-
-/* following flag values can be "or"-ed together */
-#define SG_FLAG_DIRECT_IO 1     /* default is indirect IO */
-#define SG_FLAG_UNUSED_LUN_INHIBIT 2   /* default is overwrite lun in SCSI */
-				/* command block (when <= SCSI_2) */
-#define SG_FLAG_MMAP_IO 4       /* request memory mapped IO */
-#define SG_FLAG_NO_DXFER 0x10000 /* no transfer of kernel buffers to/from */
-				/* user space (debug indirect IO) */
-/* defaults:: for sg driver: Q_AT_HEAD; for block layer: Q_AT_TAIL */
-#define SG_FLAG_Q_AT_TAIL 0x10
-#define SG_FLAG_Q_AT_HEAD 0x20
-
-/* following 'info' values are "or"-ed together */
-#define SG_INFO_OK_MASK 0x1
-#define SG_INFO_OK 0x0          /* no sense, host nor driver "noise" */
-#define SG_INFO_CHECK 0x1       /* something abnormal happened */
-
-#define SG_INFO_DIRECT_IO_MASK 0x6
-#define SG_INFO_INDIRECT_IO 0x0 /* data xfer via kernel buffers (or no xfer) */
-#define SG_INFO_DIRECT_IO 0x2   /* direct IO requested and performed */
-#define SG_INFO_MIXED_IO 0x4    /* part direct, part indirect IO */
-
-
-typedef struct sg_scsi_id { /* used by SG_GET_SCSI_ID ioctl() */
-    int host_no;        /* as in "scsi<n>" where 'n' is one of 0, 1, 2 etc */
-    int channel;
-    int scsi_id;        /* scsi id of target device */
-    int lun;
-    int scsi_type;      /* TYPE_... defined in scsi/scsi.h */
-    short h_cmd_per_lun;/* host (adapter) maximum commands per lun */
-    short d_queue_depth;/* device (or adapter) maximum queue length */
-    int unused[2];      /* probably find a good use, set 0 for now */
-} sg_scsi_id_t; /* 32 bytes long on i386 */
-
-typedef struct sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
-    char req_state;     /* 0 -> not used, 1 -> written, 2 -> ready to read */
-    char orphan;        /* 0 -> normal request, 1 -> from interruped SG_IO */
-    char sg_io_owned;   /* 0 -> complete with read(), 1 -> owned by SG_IO */
-    char problem;       /* 0 -> no problem detected, 1 -> error to report */
-    int pack_id;        /* pack_id associated with request */
-    void __user *usr_ptr;     /* user provided pointer (in new interface) */
-    unsigned int duration; /* millisecs elapsed since written (req_state==1)
-			      or request duration (req_state==2) */
-    int unused;
-} sg_req_info_t; /* 20 bytes long on i386 */
-
-
-/* IOCTLs: Those ioctls that are relevant to the SG 3.x drivers follow.
- [Those that only apply to the SG 2.x drivers are at the end of the file.]
- (_GET_s yield result via 'int *' 3rd argument unless otherwise indicated) */
-
-#define SG_EMULATED_HOST 0x2203 /* true for emulated host adapter (ATAPI) */
-
-/* Used to configure SCSI command transformation layer for ATAPI devices */
-/* Only supported by the ide-scsi driver */
-#define SG_SET_TRANSFORM 0x2204 /* N.B. 3rd arg is not pointer but value: */
-		      /* 3rd arg = 0 to disable transform, 1 to enable it */
-#define SG_GET_TRANSFORM 0x2205
-
-#define SG_SET_RESERVED_SIZE 0x2275  /* request a new reserved buffer size */
-#define SG_GET_RESERVED_SIZE 0x2272  /* actual size of reserved buffer */
-
-/* The following ioctl has a 'sg_scsi_id_t *' object as its 3rd argument. */
-#define SG_GET_SCSI_ID 0x2276   /* Yields fd's bus, chan, dev, lun + type */
-/* SCSI id information can also be obtained from SCSI_IOCTL_GET_IDLUN */
-
-/* Override host setting and always DMA using low memory ( <16MB on i386) */
-#define SG_SET_FORCE_LOW_DMA 0x2279  /* 0-> use adapter setting, 1-> force */
-#define SG_GET_LOW_DMA 0x227a   /* 0-> use all ram for dma; 1-> low dma ram */
-
-/* When SG_SET_FORCE_PACK_ID set to 1, pack_id is input to read() which
-   tries to fetch a packet with a matching pack_id, waits, or returns EAGAIN.
-   If pack_id is -1 then read oldest waiting. When ...FORCE_PACK_ID set to 0
-   then pack_id ignored by read() and oldest readable fetched. */
-#define SG_SET_FORCE_PACK_ID 0x227b
-#define SG_GET_PACK_ID 0x227c /* Yields oldest readable pack_id (or -1) */
-
-#define SG_GET_NUM_WAITING 0x227d /* Number of commands awaiting read() */
-
-/* Yields max scatter gather tablesize allowed by current host adapter */
-#define SG_GET_SG_TABLESIZE 0x227F  /* 0 implies can't do scatter gather */
-
-#define SG_GET_VERSION_NUM 0x2282 /* Example: version 2.1.34 yields 20134 */
 
-/* Returns -EBUSY if occupied. 3rd argument pointer to int (see next) */
-#define SG_SCSI_RESET 0x2284
-/* Associated values that can be given to SG_SCSI_RESET follow.
- * SG_SCSI_RESET_NO_ESCALATE may be OR-ed to the _DEVICE, _TARGET, _BUS
- * or _HOST reset value so only that action is attempted. */
-#define		SG_SCSI_RESET_NOTHING	0
-#define		SG_SCSI_RESET_DEVICE	1
-#define		SG_SCSI_RESET_BUS	2
-#define		SG_SCSI_RESET_HOST	3
-#define		SG_SCSI_RESET_TARGET	4
-#define		SG_SCSI_RESET_NO_ESCALATE	0x100
-
-/* synchronous SCSI command ioctl, (only in version 3 interface) */
-#define SG_IO 0x2285   /* similar effect as write() followed by read() */
-
-#define SG_GET_REQUEST_TABLE 0x2286   /* yields table of active requests */
-
-/* How to treat EINTR during SG_IO ioctl(), only in SG 3.x series */
-#define SG_SET_KEEP_ORPHAN 0x2287 /* 1 -> hold for read(), 0 -> drop (def) */
-#define SG_GET_KEEP_ORPHAN 0x2288
-
-/* yields scsi midlevel's access_count for this SCSI device */
-#define SG_GET_ACCESS_COUNT 0x2289  
-
-
-#define SG_SCATTER_SZ (8 * 4096)
-/* Largest size (in bytes) a single scatter-gather list element can have.
-   The value used by the driver is 'max(SG_SCATTER_SZ, PAGE_SIZE)'.
-   This value should be a power of 2 (and may be rounded up internally).
-   If scatter-gather is not supported by adapter then this value is the
-   largest data block that can be read/written by a single scsi command. */
-
-#define SG_DEFAULT_RETRIES 0
-
-/* Defaults, commented if they differ from original sg driver */
-#define SG_DEF_FORCE_LOW_DMA 0  /* was 1 -> memory below 16MB on i386 */
-#define SG_DEF_FORCE_PACK_ID 0
-#define SG_DEF_KEEP_ORPHAN 0
-#define SG_DEF_RESERVED_SIZE SG_SCATTER_SZ /* load time option */
-
-/* maximum outstanding requests, write() yields EDOM if exceeded */
-#define SG_MAX_QUEUE 16
-
-#define SG_BIG_BUFF SG_DEF_RESERVED_SIZE    /* for backward compatibility */
-
-
-/* vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv */
-/*   The older SG interface based on the 'sg_header' structure follows.   */
-/* ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ */
-
-#define SG_MAX_SENSE 16   /* this only applies to the sg_header interface */
-
-struct sg_header
-{
-    int pack_len;    /* [o] reply_len (ie useless), ignored as input */
-    int reply_len;   /* [i] max length of expected reply (inc. sg_header) */
-    int pack_id;     /* [io] id number of packet (use ints >= 0) */
-    int result;      /* [o] 0==ok, else (+ve) Unix errno (best ignored) */
-    unsigned int twelve_byte:1;
-	/* [i] Force 12 byte command length for group 6 & 7 commands  */
-    unsigned int target_status:5;   /* [o] scsi status from target */
-    unsigned int host_status:8;     /* [o] host status (see "DID" codes) */
-    unsigned int driver_status:8;   /* [o] driver status+suggestion */
-    unsigned int other_flags:10;    /* unused */
-    unsigned char sense_buffer[SG_MAX_SENSE]; /* [o] Output in 3 cases:
-	   when target_status is CHECK_CONDITION or
-	   when target_status is COMMAND_TERMINATED or
-	   when (driver_status & DRIVER_SENSE) is true. */
-};      /* This structure is 36 bytes long on i386 */
-
-
-/* IOCTLs: The following are not required (or ignored) when the sg_io_hdr_t
-	   interface is used. They are kept for backward compatibility with
-	   the original and version 2 drivers. */
-
-#define SG_SET_TIMEOUT 0x2201  /* unit: jiffies (10ms on i386) */
-#define SG_GET_TIMEOUT 0x2202  /* yield timeout as _return_ value */
-
-/* Get/set command queuing state per fd (default is SG_DEF_COMMAND_Q.
-   Each time a sg_io_hdr_t object is seen on this file descriptor, this
-   command queuing flag is set on (overriding the previous setting). */
-#define SG_GET_COMMAND_Q 0x2270   /* Yields 0 (queuing off) or 1 (on) */
-#define SG_SET_COMMAND_Q 0x2271   /* Change queuing state with 0 or 1 */
-
-/* Turn on/off error sense trace (1 and 0 respectively, default is off).
-   Try using: "# cat /proc/scsi/sg/debug" instead in the v3 driver */
-#define SG_SET_DEBUG 0x227e    /* 0 -> turn off debug */
-
-#define SG_NEXT_CMD_LEN 0x2283  /* override SCSI command length with given
-		   number on the next write() on this file descriptor */
-
-
-/* Defaults, commented if they differ from original sg driver */
-#ifdef __KERNEL__
+/* Keep in sync with SG_DEFAULT_TIMEOUT of uapi/linux/sg.h  */
 #define SG_DEFAULT_TIMEOUT_USER	(60*USER_HZ) /* HZ == 'jiffies in 1 second' */
-#else
-#define SG_DEFAULT_TIMEOUT	(60*HZ)	     /* HZ == 'jiffies in 1 second' */
-#endif
-
-#define SG_DEF_COMMAND_Q 0     /* command queuing is always on when
-				  the new interface is used */
-#define SG_DEF_UNDERRUN_FLAG 0
 
 #endif
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 70ff1d9abf0d..61ad1c5a4aae 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -357,6 +357,7 @@ header-y += scc.h
 header-y += sched.h
 header-y += scif_ioctl.h
 header-y += screen_info.h
+header-y += scsi_ioctl.h
 header-y += sctp.h
 header-y += sdla.h
 header-y += seccomp.h
@@ -367,6 +368,7 @@ header-y += serial_core.h
 header-y += serial.h
 header-y += serial_reg.h
 header-y += serio.h
+header-y += sg.h
 header-y += shm.h
 header-y += signalfd.h
 header-y += signal.h
diff --git a/include/scsi/scsi_ioctl.h b/include/uapi/linux/scsi_ioctl.h
similarity index 77%
copy from include/scsi/scsi_ioctl.h
copy to include/uapi/linux/scsi_ioctl.h
index 2bd9d67c201a..14a3c374d918 100644
--- a/include/scsi/scsi_ioctl.h
+++ b/include/uapi/linux/scsi_ioctl.h
@@ -1,5 +1,9 @@
-#ifndef _SCSI_IOCTL_H
-#define _SCSI_IOCTL_H 
+#ifndef _UAPI_LINUX_SCSI_IOCTL_H
+#define _UAPI_LINUX_SCSI_IOCTL_H
+
+/*
+ * These ioctls are obsolete.  Use linux/sg.h instead.
+ */
 
 #define SCSI_IOCTL_SEND_COMMAND 1
 #define SCSI_IOCTL_TEST_UNIT_READY 2
@@ -7,14 +11,13 @@
 #define SCSI_IOCTL_SYNC 4			/* Request synchronous parameters */
 #define SCSI_IOCTL_START_UNIT 5
 #define SCSI_IOCTL_STOP_UNIT 6
+
 /* The door lock/unlock constants are compatible with Sun constants for
    the cdrom */
 #define SCSI_IOCTL_DOORLOCK 0x5380		/* lock the eject mechanism */
 #define SCSI_IOCTL_DOORUNLOCK 0x5381		/* unlock the mechanism	  */
 
 /*
- * Here are some obsolete SCSI-specific ioctl commands.
- *
  * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
  */
 
@@ -32,10 +35,6 @@
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
-#ifdef __KERNEL__
-
-struct scsi_device;
-
 /*
  * Structures used for scsi_ioctl et al.
  */
@@ -51,10 +50,4 @@ typedef struct scsi_idlun {
 	__u32 host_unique_id;
 } Scsi_Idlun;
 
-
-int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
-		int cmd, bool ndelay);
-extern int scsi_ioctl(struct scsi_device *, int, void __user *);
-
-#endif /* __KERNEL__ */
-#endif /* _SCSI_IOCTL_H */
+#endif /* _UAPI_LINUX_SCSI_IOCTL_H */
diff --git a/include/scsi/sg.h b/include/uapi/linux/sg.h
similarity index 97%
copy from include/scsi/sg.h
copy to include/uapi/linux/sg.h
index 370c78c37926..55080b3da7a9 100644
--- a/include/scsi/sg.h
+++ b/include/uapi/linux/sg.h
@@ -1,7 +1,5 @@
-#ifndef _SCSI_GENERIC_H
-#define _SCSI_GENERIC_H
-
-#include <linux/compiler.h>
+#ifndef _UAPI_LINUX_SG_H
+#define _UAPI_LINUX_SG_H
 
 /*
  * History:
@@ -28,10 +26,6 @@
  * For utility and test programs see: http://sg.danny.cz/sg/sg3_utils.html
  */
 
-#ifdef __KERNEL__
-extern int sg_big_buff; /* for sysctl */
-#endif
-
 
 typedef struct sg_iovec /* same structure as used by readv() Linux system */
 {                       /* call. It defines one scatter-gather element. */
@@ -184,7 +178,7 @@ typedef struct sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
 #define SG_GET_KEEP_ORPHAN 0x2288
 
 /* yields scsi midlevel's access_count for this SCSI device */
-#define SG_GET_ACCESS_COUNT 0x2289  
+#define SG_GET_ACCESS_COUNT 0x2289
 
 
 #define SG_SCATTER_SZ (8 * 4096)
@@ -255,9 +249,9 @@ struct sg_header
 
 
 /* Defaults, commented if they differ from original sg driver */
-#ifdef __KERNEL__
-#define SG_DEFAULT_TIMEOUT_USER	(60*USER_HZ) /* HZ == 'jiffies in 1 second' */
-#else
+
+#ifndef __KERNEL__
+/* Keep in sync with SG_DEFAULT_TIMEOUT of scsi/sg.h  */
 #define SG_DEFAULT_TIMEOUT	(60*HZ)	     /* HZ == 'jiffies in 1 second' */
 #endif
 
@@ -265,4 +259,4 @@ struct sg_header
 				  the new interface is used */
 #define SG_DEF_UNDERRUN_FLAG 0
 
-#endif
+#endif /* _UAPI_LINUX_SG_H */
-- 
2.5.0

