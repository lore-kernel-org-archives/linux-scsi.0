From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 1/5] mpt fusion: Changes for logging support in Kconfig, Makefile, mptbase.h and addition of mptdebug.h
Date: Tue, 24 Jul 2007 15:40:08 +0530
Message-ID: <20070724101007.GB1831@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42690 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761947AbXGXKMf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 06:12:35 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l6OABF4L000328
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 03:11:15 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com


This patch adds a new file mptdebug.h in the fusion source directory, which
contains different debug macros. 
The existing debug macros and flags are removed from the mptbase.h and
Makefile
In Kconfig a new configuration parameter FUSION_LOGGING is added to
enable/disable the logging support during compile time.

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff -Naurp b/drivers/message/fusion/Kconfig a/drivers/message/fusion/Kconfig
--- b/drivers/message/fusion/Kconfig	2007-07-23 14:24:35.000000000 +0530
+++ a/drivers/message/fusion/Kconfig	2007-07-23 16:37:01.000000000 +0530
@@ -102,4 +102,18 @@ config FUSION_LAN
 
 	  If unsure whether you really want or need this, say N.
 
+config FUSION_LOGGING
+	bool "Fusion MPT logging facility"
+	depends on FUSION
+	---help---
+	  This turns on a logging facility that can be used to debug a number
+	  of Fusion MPT related problems.
+
+	  The debug level can be programmed on the fly via SysFS (hex values)
+
+	  echo [level] > /sys/class/scsi_host/host#/debug_level
+
+	  There are various debug levels that an be found in the source:
+	  file:drivers/message/fusion/mptdebug.h
+
 endmenu
diff -Naurp b/drivers/message/fusion/Makefile a/drivers/message/fusion/Makefile
--- b/drivers/message/fusion/Makefile	2007-07-09 05:02:17.000000000 +0530
+++ a/drivers/message/fusion/Makefile	2007-07-23 16:37:08.000000000 +0530
@@ -1,39 +1,8 @@
 # Fusion MPT drivers; recognized debug defines...
-#  MPT general:
-#EXTRA_CFLAGS += -DMPT_DEBUG
-#EXTRA_CFLAGS += -DMPT_DEBUG_MSG_FRAME
-#EXTRA_CFLAGS += -DMPT_DEBUG_SG
-#EXTRA_CFLAGS += -DMPT_DEBUG_EVENTS
-#EXTRA_CFLAGS += -DMPT_DEBUG_VERBOSE_EVENTS
-#EXTRA_CFLAGS += -DMPT_DEBUG_INIT
-#EXTRA_CFLAGS += -DMPT_DEBUG_EXIT
-#EXTRA_CFLAGS += -DMPT_DEBUG_FAIL
-#EXTRA_CFLAGS += -DMPT_DEBUG_DV
-#EXTRA_CFLAGS += -DMPT_DEBUG_TM
-#EXTRA_CFLAGS += -DMPT_DEBUG_REPLY
 
-#
-# driver/module specifics...
-#
-#  For mptbase:
-#CFLAGS_mptbase.o += -DMPT_DEBUG_HANDSHAKE
-#CFLAGS_mptbase.o += -DMPT_DEBUG_CONFIG
-#CFLAGS_mptbase.o += -DMPT_DEBUG_DL
-#CFLAGS_mptbase.o += -DMPT_DEBUG_IRQ
-#CFLAGS_mptbase.o += -DMPT_DEBUG_RESET
-#
-#  For mptscsih:
-#CFLAGS_mptscsih.o += -DMPT_DEBUG_SCSI
-#
-#  For mptctl:
-#CFLAGS_mptctl.o += -DMPT_DEBUG_IOCTL
-#
-#  For mptfc:
-#CFLAGS_mptfc.o += -DMPT_DEBUG_FC
-
-#  For mptsas:
-#CFLAGS_mptsas.o += -DMPT_DEBUG_SAS
-#CFLAGS_mptsas.o += -DMPT_DEBUG_SAS_WIDE
+# enable verbose logging
+# CONFIG_FUSION_LOGGING needs to be enabled in Kconfig
+#EXTRA_CFLAGS += -DMPT_DEBUG_VERBOSE
 
 
 #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-} LSI_LOGIC
diff -Naurp b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-07-23 14:24:35.000000000 +0530
+++ a/drivers/message/fusion/mptbase.h	2007-07-23 16:37:16.000000000 +0530
@@ -186,6 +186,7 @@
  * MPT drivers.  NOTE: Users of these macro defs must
  * themselves define their own MYNAM.
  */
+#define MYIOC_s_DEBUG_FMT		KERN_DEBUG MYNAM ": %s: "
 #define MYIOC_s_INFO_FMT		KERN_INFO MYNAM ": %s: "
 #define MYIOC_s_NOTE_FMT		KERN_NOTICE MYNAM ": %s: "
 #define MYIOC_s_WARN_FMT		KERN_WARNING MYNAM ": %s: WARNING - "
@@ -543,6 +544,7 @@ typedef struct _MPT_ADAPTER
 	char			 board_tracer[16];
 	u16			 nvdata_version_persistent;
 	u16			 nvdata_version_default;
+	int			 debug_level;
 	u8			 io_missing_delay;
 	u8			 device_missing_delay;
 	SYSIF_REGS __iomem	*chip;		/* == c8817000 (mmap) */
@@ -718,171 +720,7 @@ typedef struct _mpt_sge {
 /*
  *  Funky (private) macros...
  */
-#ifdef MPT_DEBUG
-#define dprintk(x)  printk x
-#else
-#define dprintk(x)
-#endif
-
-#ifdef MPT_DEBUG_INIT
-#define dinitprintk(x)  printk x
-#define DBG_DUMP_FW_REQUEST_FRAME(mfp) \
-	{	int  i, n = 10;						\
-		u32 *m = (u32 *)(mfp);					\
-		printk(KERN_INFO " ");					\
-		for (i=0; i<n; i++)					\
-			printk(" %08x", le32_to_cpu(m[i]));		\
-		printk("\n");						\
-	}
-#else
-#define dinitprintk(x)
-#define DBG_DUMP_FW_REQUEST_FRAME(mfp)
-#endif
-
-#ifdef MPT_DEBUG_EXIT
-#define dexitprintk(x)  printk x
-#else
-#define dexitprintk(x)
-#endif
-
-#if defined MPT_DEBUG_FAIL || defined (MPT_DEBUG_SG)
-#define dfailprintk(x) printk x
-#else
-#define dfailprintk(x)
-#endif
-
-#ifdef MPT_DEBUG_HANDSHAKE
-#define dhsprintk(x)  printk x
-#else
-#define dhsprintk(x)
-#endif
-
-#if defined(MPT_DEBUG_EVENTS) || defined(MPT_DEBUG_VERBOSE_EVENTS)
-#define devtprintk(x)  printk x
-#else
-#define devtprintk(x)
-#endif
-
-#ifdef MPT_DEBUG_VERBOSE_EVENTS
-#define devtverboseprintk(x)  printk x
-#else
-#define devtverboseprintk(x)
-#endif
-
-#ifdef MPT_DEBUG_RESET
-#define drsprintk(x)  printk x
-#else
-#define drsprintk(x)
-#endif
-
-//#if defined(MPT_DEBUG) || defined(MPT_DEBUG_MSG_FRAME)
-#if defined(MPT_DEBUG_MSG_FRAME)
-#define dmfprintk(x)  printk x
-#define DBG_DUMP_REQUEST_FRAME(mfp) \
-	{	int  i, n = 24;						\
-		u32 *m = (u32 *)(mfp);					\
-		for (i=0; i<n; i++) {					\
-			if (i && ((i%8)==0))				\
-				printk("\n");				\
-			printk("%08x ", le32_to_cpu(m[i]));		\
-		}							\
-		printk("\n");						\
-	}
-#else
-#define dmfprintk(x)
-#define DBG_DUMP_REQUEST_FRAME(mfp)
-#endif
-
-#ifdef MPT_DEBUG_IRQ
-#define dirqprintk(x)  printk x
-#else
-#define dirqprintk(x)
-#endif
-
-#ifdef MPT_DEBUG_SG
-#define dsgprintk(x)  printk x
-#else
-#define dsgprintk(x)
-#endif
-
-#if defined(MPT_DEBUG_DL) || defined(MPT_DEBUG)
-#define ddlprintk(x)  printk x
-#else
-#define ddlprintk(x)
-#endif
-
-#ifdef MPT_DEBUG_DV
-#define ddvprintk(x)  printk x
-#else
-#define ddvprintk(x)
-#endif
-
-#if defined(MPT_DEBUG_DV) || defined(MPT_DEBUG_DV_TINY)
-#define ddvtprintk(x)  printk x
-#else
-#define ddvtprintk(x)
-#endif
-
-#ifdef MPT_DEBUG_IOCTL
-#define dctlprintk(x) printk x
-#else
-#define dctlprintk(x)
-#endif
-
-#ifdef MPT_DEBUG_REPLY
-#define dreplyprintk(x) printk x
-#else
-#define dreplyprintk(x)
-#endif
-
-#ifdef DMPT_DEBUG_FC
-#define dfcprintk(x) printk x
-#else
-#define dfcprintk(x)
-#endif
-
-#ifdef MPT_DEBUG_TM
-#define dtmprintk(x) printk x
-#define DBG_DUMP_TM_REQUEST_FRAME(mfp) \
-	{	u32 *m = (u32 *)(mfp);					\
-		int  i, n = 13;						\
-		printk("TM_REQUEST:\n");				\
-		for (i=0; i<n; i++) {					\
-			if (i && ((i%8)==0))				\
-				printk("\n");				\
-			printk("%08x ", le32_to_cpu(m[i]));		\
-		}							\
-		printk("\n");						\
-	}
-#define DBG_DUMP_TM_REPLY_FRAME(mfp) \
-	{	u32 *m = (u32 *)(mfp);					\
-		int  i, n = (le32_to_cpu(m[0]) & 0x00FF0000) >> 16;	\
-		printk("TM_REPLY MessageLength=%d:\n", n);		\
-		for (i=0; i<n; i++) {					\
-			if (i && ((i%8)==0))				\
-				printk("\n");				\
-			printk(" %08x", le32_to_cpu(m[i]));		\
-		}							\
-		printk("\n");						\
-	}
-#else
-#define dtmprintk(x)
-#define DBG_DUMP_TM_REQUEST_FRAME(mfp)
-#define DBG_DUMP_TM_REPLY_FRAME(mfp)
-#endif
-
-#if defined(MPT_DEBUG_CONFIG) || defined(MPT_DEBUG)
-#define dcprintk(x) printk x
-#else
-#define dcprintk(x)
-#endif
-
-#if defined(MPT_DEBUG_SCSI) || defined(MPT_DEBUG) || defined(MPT_DEBUG_MSG_FRAME)
-#define dsprintk(x) printk x
-#else
-#define dsprintk(x)
-#endif
-
+#include "mptdebug.h"
 
 #define MPT_INDEX_2_MFPTR(ioc,idx) \
 	(MPT_FRAME_HDR*)( (u8*)(ioc)->req_frames + (ioc)->req_sz * (idx) )
@@ -893,36 +731,6 @@ typedef struct _mpt_sge {
 #define MPT_INDEX_2_RFPTR(ioc,idx) \
 	(MPT_FRAME_HDR*)( (u8*)(ioc)->reply_frames + (ioc)->req_sz * (idx) )
 
-#if defined(MPT_DEBUG) || defined(MPT_DEBUG_MSG_FRAME)
-#define DBG_DUMP_REPLY_FRAME(mfp) \
-	{	u32 *m = (u32 *)(mfp);					\
-		int  i, n = (le32_to_cpu(m[0]) & 0x00FF0000) >> 16;	\
-		printk(KERN_INFO " ");					\
-		for (i=0; i<n; i++)					\
-			printk(" %08x", le32_to_cpu(m[i]));		\
-		printk("\n");						\
-	}
-#define DBG_DUMP_REQUEST_FRAME_HDR(mfp) \
-	{	int  i, n = 3;						\
-		u32 *m = (u32 *)(mfp);					\
-		printk(KERN_INFO " ");					\
-		for (i=0; i<n; i++)					\
-			printk(" %08x", le32_to_cpu(m[i]));		\
-		printk("\n");						\
-	}
-#else
-#define DBG_DUMP_REPLY_FRAME(mfp)
-#define DBG_DUMP_REQUEST_FRAME_HDR(mfp)
-#endif
-
-// debug sas wide ports
-#ifdef MPT_DEBUG_SAS_WIDE
-#define dsaswideprintk(x) printk x
-#else
-#define dsaswideprintk(x)
-#endif
-
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
 #define SCSI_STD_SENSE_BYTES    18
diff -Naurp b/drivers/message/fusion/mptdebug.h a/drivers/message/fusion/mptdebug.h
--- b/drivers/message/fusion/mptdebug.h	1970-01-01 05:30:00.000000000 +0530
+++ a/drivers/message/fusion/mptdebug.h	2007-07-23 16:37:21.000000000 +0530
@@ -0,0 +1,288 @@
+/*
+ *  linux/drivers/message/fusion/mptdebug.h
+ *      For use with LSI PCI chip/adapter(s)
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
+ *
+ *  Copyright (c) 1999-2007 LSI Corporation
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
+ *
+ */
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+
+#ifndef MPTDEBUG_H_INCLUDED
+#define MPTDEBUG_H_INCLUDED
+
+/*
+ * debug level can be programmed on the fly via SysFS (hex values)
+ *
+ * Example:  (programming for MPT_DEBUG_EVENTS on host 5)
+ *
+ * echo 8 > /sys/class/scsi_host/host5/debug_level
+ *
+ * --------------------------------------------------------
+ * mpt_debug_level - command line parameter
+ * this allow enabling debug at driver load time (for all iocs)
+ *
+ * Example  (programming for MPT_DEBUG_EVENTS)
+ *
+ * insmod mptbase.ko mpt_debug_level=8
+ *
+ * --------------------------------------------------------
+ * CONFIG_FUSION_LOGGING - enables compiling debug into driver
+ * this can be enabled in the driver Makefile
+ *
+ *
+ * --------------------------------------------------------
+ * Please note most debug prints are set to logging priority = debug
+ * This is the lowest level, and most verbose.  Please refer to manual
+ * pages for syslogd or syslogd-ng on how to configure this.
+ */
+
+#define MPT_DEBUG			0x00000001
+#define MPT_DEBUG_MSG_FRAME		0x00000002
+#define MPT_DEBUG_SG			0x00000004
+#define MPT_DEBUG_EVENTS		0x00000008
+#define MPT_DEBUG_VERBOSE_EVENTS	0x00000010
+#define MPT_DEBUG_INIT			0x00000020
+#define MPT_DEBUG_EXIT			0x00000040
+#define MPT_DEBUG_FAIL			0x00000080
+#define MPT_DEBUG_TM			0x00000100
+#define MPT_DEBUG_DV			0x00000200
+#define MPT_DEBUG_REPLY			0x00000400
+#define MPT_DEBUG_HANDSHAKE		0x00000800
+#define MPT_DEBUG_CONFIG		0x00001000
+#define MPT_DEBUG_DL			0x00002000
+#define MPT_DEBUG_RESET			0x00008000
+#define MPT_DEBUG_SCSI			0x00010000
+#define MPT_DEBUG_IOCTL			0x00020000
+#define MPT_DEBUG_FC			0x00080000
+#define MPT_DEBUG_SAS			0x00100000
+#define MPT_DEBUG_SAS_WIDE		0x00200000
+
+/*
+ * CONFIG_FUSION_LOGGING - enabled in Kconfig
+ */
+
+#ifdef CONFIG_FUSION_LOGGING
+#define MPT_CHECK_LOGGING(IOC, CMD, BITS)			\
+{								\
+	if (IOC->debug_level & BITS)				\
+		CMD;						\
+}
+#else
+#define MPT_CHECK_LOGGING(IOC, CMD, BITS)
+#endif
+
+
+/*
+ * debug macros
+ */
+
+#define dprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG)
+
+#define dsgprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_SG)
+
+#define devtprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_EVENTS)
+
+#define devtverboseprintk(IOC, CMD)		\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_VERBOSE_EVENTS)
+
+#define dinitprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_INIT)
+
+#define dexitprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_EXIT)
+
+#define dfailprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_FAIL)
+
+#define dtmprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_TM)
+
+#define ddvprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_DV)
+
+#define dreplyprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_REPLY)
+
+#define dhsprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_HANDSHAKE)
+
+#define dcprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_CONFIG)
+
+#define ddlprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_DL)
+
+#define drsprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_RESET)
+
+#define dsprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_SCSI)
+
+#define dctlprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_IOCTL)
+
+#define dfcprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_FC)
+
+#define dsasprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_SAS)
+
+#define dsaswideprintk(IOC, CMD)		\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_SAS_WIDE)
+
+
+
+/*
+ * Verbose logging
+ */
+#if defined(MPT_DEBUG_VERBOSE) && defined(CONFIG_FUSION_LOGGING)
+static inline void
+DBG_DUMP_FW_DOWNLOAD(MPT_ADAPTER *ioc, u32  *mfp, int numfrags)
+{
+	int i;
+
+	if (!(ioc->debug_level & MPT_DEBUG))
+		return;
+	printk(KERN_DEBUG "F/W download request:\n");
+	for (i=0; i < 7+numfrags*2; i++)
+		printk(" %08x", le32_to_cpu(mfp[i]));
+	printk("\n");
+}
+
+static inline void
+DBG_DUMP_PUT_MSG_FRAME(MPT_ADAPTER *ioc, u32 *mfp)
+{
+	int	 ii, n;
+
+	if (!(ioc->debug_level & MPT_DEBUG_MSG_FRAME))
+		return;
+	printk(KERN_DEBUG "%s: About to Put msg frame @ %p:\n",
+		ioc->name, mfp);
+	n = ioc->req_sz/4 - 1;
+	while (mfp[n] == 0)
+		n--;
+	for (ii=0; ii<=n; ii++) {
+		if (ii && ((ii%8)==0))
+			printk("\n");
+		printk(" %08x", le32_to_cpu(mfp[ii]));
+	}
+	printk("\n");
+}
+
+static inline void
+DBG_DUMP_FW_REQUEST_FRAME(MPT_ADAPTER *ioc, u32 *mfp)
+{
+	int  i, n;
+
+	if (!(ioc->debug_level & MPT_DEBUG_MSG_FRAME))
+		return;
+	n = 10;
+	printk(KERN_INFO " ");
+	for (i = 0; i < n; i++)
+		printk(" %08x", le32_to_cpu(mfp[i]));
+	printk("\n");
+}
+
+static inline void
+DBG_DUMP_REQUEST_FRAME(MPT_ADAPTER *ioc, u32 *mfp)
+{
+	int  i, n;
+
+	if (!(ioc->debug_level & MPT_DEBUG_MSG_FRAME))
+		return;
+	n = 24;
+	for (i=0; i<n; i++) {
+		if (i && ((i%8)==0))
+			printk("\n");
+		printk("%08x ", le32_to_cpu(mfp[i]));
+	}
+	printk("\n");
+}
+
+static inline void
+DBG_DUMP_REPLY_FRAME(MPT_ADAPTER *ioc, u32 *mfp)
+{
+	int  i, n;
+
+	if (!(ioc->debug_level & MPT_DEBUG_MSG_FRAME))
+		return;
+	n = (le32_to_cpu(mfp[0]) & 0x00FF0000) >> 16;
+	printk(KERN_INFO " ");
+	for (i=0; i<n; i++)
+		printk(" %08x", le32_to_cpu(mfp[i]));
+	printk("\n");
+}
+
+static inline void
+DBG_DUMP_REQUEST_FRAME_HDR(MPT_ADAPTER *ioc, u32 *mfp)
+{
+	int  i, n;
+
+	if (!(ioc->debug_level & MPT_DEBUG_MSG_FRAME))
+		return;
+	n = 3;
+	printk(KERN_INFO " ");
+	for (i=0; i<n; i++)
+		printk(" %08x", le32_to_cpu(mfp[i]));
+	printk("\n");
+}
+
+static inline void
+DBG_DUMP_TM_REQUEST_FRAME(MPT_ADAPTER *ioc, u32 *mfp)
+{
+	int  i, n;
+
+	if (!(ioc->debug_level & MPT_DEBUG_TM))
+		return;
+	n = 13;
+	printk(KERN_DEBUG "TM_REQUEST:\n");
+	for (i=0; i<n; i++) {
+		if (i && ((i%8)==0))
+			printk("\n");
+		printk("%08x ", le32_to_cpu(mfp[i]));
+	}
+	printk("\n");
+}
+
+static inline void
+DBG_DUMP_TM_REPLY_FRAME(MPT_ADAPTER *ioc, u32 *mfp)
+{
+	int  i, n;
+
+	if (!(ioc->debug_level & MPT_DEBUG_TM))
+		return;
+	n = (le32_to_cpu(mfp[0]) & 0x00FF0000) >> 16;
+	printk(KERN_DEBUG "TM_REPLY MessageLength=%d:\n", n);
+	for (i=0; i<n; i++) {
+		if (i && ((i%8)==0))
+			printk("\n");
+		printk(" %08x", le32_to_cpu(mfp[i]));
+	}
+	printk("\n");
+}
+
+#define dmfprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_MSG_FRAME)
+
+# else /* ifdef MPT_DEBUG_MF */
+
+#define DBG_DUMP_FW_DOWNLOAD(IOC, mfp, numfrags)
+#define DBG_DUMP_PUT_MSG_FRAME(IOC, mfp)
+#define DBG_DUMP_FW_REQUEST_FRAME(IOC, mfp)
+#define DBG_DUMP_REQUEST_FRAME(IOC, mfp)
+#define DBG_DUMP_REPLY_FRAME(IOC, mfp)
+#define DBG_DUMP_REQUEST_FRAME_HDR(IOC, mfp)
+#define DBG_DUMP_TM_REQUEST_FRAME(IOC, mfp)
+#define DBG_DUMP_TM_REPLY_FRAME(IOC, mfp)
+
+#define dmfprintk(IOC, CMD)			\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_MSG_FRAME)
+
+#endif /* defined(MPT_DEBUG_VERBOSE) && defined(CONFIG_FUSION_LOGGING) */
+
+#endif /* ifndef MPTDEBUG_H_INCLUDED */
