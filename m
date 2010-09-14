From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH 9/17]: SCST debugging support routines
Date: Tue, 14 Sep 2010 18:44:43 +0400
Message-ID: <4C8F8A5B.9040306@vlnb.net>
References: <4C8F886E.2080407@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:49478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab0INOpC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2010 10:45:02 -0400
In-Reply-To: <4C8F886E.2080407@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>

This patch contains SCST debugging support routines.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 drivers/scst/scst_debug.c |  223 ++++++++++++++++++++++++++++++++++++
 include/scst/scst_debug.h |  284 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 507 insertions(+)

diff -uprN orig/linux-2.6.35/include/scst/scst_debug.h linux-2.6.35/include/scst/scst_debug.h
--- orig/linux-2.6.35/include/scst/scst_debug.h
+++ linux-2.6.35/include/scst/scst_debug.h
@@ -0,0 +1,284 @@
+/*
+ *  include/scst_debug.h
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  Contains macroses for execution tracing and error reporting
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef __SCST_DEBUG_H
+#define __SCST_DEBUG_H
+
+#include <generated/autoconf.h>	/* for CONFIG_* */
+
+#include <linux/bug.h>		/* for WARN_ON_ONCE */
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+#define EXTRACHECKS_BUG_ON(a)		BUG_ON(a)
+#define EXTRACHECKS_WARN_ON(a)		WARN_ON(a)
+#define EXTRACHECKS_WARN_ON_ONCE(a)	WARN_ON_ONCE(a)
+#else
+#define EXTRACHECKS_BUG_ON(a)		do { } while (0)
+#define EXTRACHECKS_WARN_ON(a)		do { } while (0)
+#define EXTRACHECKS_WARN_ON_ONCE(a)	do { } while (0)
+#endif
+
+#define TRACE_NULL           0x00000000
+#define TRACE_DEBUG          0x00000001
+#define TRACE_FUNCTION       0x00000002
+#define TRACE_LINE           0x00000004
+#define TRACE_PID            0x00000008
+#define TRACE_BUFF           0x00000020
+#define TRACE_MEMORY         0x00000040
+#define TRACE_SG_OP          0x00000080
+#define TRACE_OUT_OF_MEM     0x00000100
+#define TRACE_MINOR          0x00000200 /* less important events */
+#define TRACE_MGMT           0x00000400
+#define TRACE_MGMT_DEBUG     0x00000800
+#define TRACE_SCSI           0x00001000
+#define TRACE_SPECIAL        0x00002000 /* filtering debug, etc */
+#define TRACE_FLOW_CONTROL   0x00004000 /* flow control in action */
+#define TRACE_PRES           0x00008000
+#define TRACE_ALL            0xffffffff
+/* Flags 0xXXXX0000 are local for users */
+
+#define TRACE_MINOR_AND_MGMT_DBG	(TRACE_MINOR|TRACE_MGMT_DEBUG)
+
+#ifndef KERN_CONT
+#define KERN_CONT       ""
+#endif
+
+/*
+ * Note: in the next two printk() statements the KERN_CONT macro is only
+ * present to suppress a checkpatch warning (KERN_CONT is defined as "").
+ */
+#define PRINT(log_flag, format, args...)  \
+		printk(log_flag format "\n", ## args)
+#define PRINTN(log_flag, format, args...) \
+		printk(log_flag format, ## args)
+
+#ifdef LOG_PREFIX
+#define __LOG_PREFIX	LOG_PREFIX
+#else
+#define __LOG_PREFIX	NULL
+#endif
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+
+#ifndef CONFIG_SCST_DEBUG
+#define ___unlikely(a)		(a)
+#else
+#define ___unlikely(a)		unlikely(a)
+#endif
+
+/*
+ * We don't print prefix for debug traces to not put additional preasure
+ * on the logging system in case of a lot of logging.
+ */
+
+int debug_print_prefix(unsigned long trace_flag,
+	const char *prefix, const char *func, int line);
+void debug_print_buffer(const void *data, int len);
+const char *debug_transport_id_to_initiator_name(const uint8_t *transport_id);
+
+#define TRACING_MINOR() (trace_flag & TRACE_MINOR)
+
+#define TRACE(trace, format, args...)					\
+do {									\
+	if (___unlikely(trace_flag & (trace))) {			\
+		debug_print_prefix(trace_flag, __LOG_PREFIX,		\
+				       __func__, __LINE__);		\
+		PRINT(KERN_CONT, format, args);				\
+	}								\
+} while (0)
+
+#ifdef CONFIG_SCST_DEBUG
+
+#define PRINT_BUFFER(message, buff, len)                            \
+do {                                                                \
+	PRINT(KERN_INFO, "%s:%s:", __func__, message);		    \
+	debug_print_buffer(buff, len);				    \
+} while (0)
+
+#else
+
+#define PRINT_BUFFER(message, buff, len)                            \
+do {                                                                \
+	PRINT(KERN_INFO, "%s:", message);			    \
+	debug_print_buffer(buff, len);				    \
+} while (0)
+
+#endif
+
+#define PRINT_BUFF_FLAG(flag, message, buff, len)			\
+do {									\
+	if (___unlikely(trace_flag & (flag))) {				\
+		debug_print_prefix(trace_flag, NULL, __func__, __LINE__);\
+		PRINT(KERN_CONT, "%s:", message);			\
+		debug_print_buffer(buff, len);				\
+	}								\
+} while (0)
+
+#else  /* CONFIG_SCST_DEBUG || CONFIG_SCST_TRACING */
+
+#define TRACING_MINOR() (false)
+
+#define TRACE(trace, args...) do {} while (0)
+#define PRINT_BUFFER(message, buff, len) do {} while (0)
+#define PRINT_BUFF_FLAG(flag, message, buff, len) do {} while (0)
+
+#endif /* CONFIG_SCST_DEBUG || CONFIG_SCST_TRACING */
+
+#ifdef CONFIG_SCST_DEBUG
+
+#define TRACE_DBG_FLAG(trace, format, args...)				\
+do {									\
+	if (trace_flag & (trace)) {					\
+		debug_print_prefix(trace_flag, NULL, __func__, __LINE__);\
+		PRINT(KERN_CONT, format, args);				\
+	}								\
+} while (0)
+
+#define TRACE_MEM(args...)		TRACE_DBG_FLAG(TRACE_MEMORY, args)
+#define TRACE_SG(args...)		TRACE_DBG_FLAG(TRACE_SG_OP, args)
+#define TRACE_DBG(args...)		TRACE_DBG_FLAG(TRACE_DEBUG, args)
+#define TRACE_DBG_SPECIAL(args...)	TRACE_DBG_FLAG(TRACE_DEBUG|TRACE_SPECIAL, args)
+#define TRACE_MGMT_DBG(args...)		TRACE_DBG_FLAG(TRACE_MGMT_DEBUG, args)
+#define TRACE_MGMT_DBG_SPECIAL(args...)	\
+		TRACE_DBG_FLAG(TRACE_MGMT_DEBUG|TRACE_SPECIAL, args)
+#define TRACE_PR(args...)		TRACE_DBG_FLAG(TRACE_PRES, args)
+
+#define TRACE_BUFFER(message, buff, len)				\
+do {									\
+	if (trace_flag & TRACE_BUFF) {					\
+		debug_print_prefix(trace_flag, NULL, __func__, __LINE__);\
+		PRINT(KERN_CONT, "%s:", message);			\
+		debug_print_buffer(buff, len);				\
+	}								\
+} while (0)
+
+#define TRACE_BUFF_FLAG(flag, message, buff, len)			\
+do {									\
+	if (trace_flag & (flag)) {					\
+		debug_print_prefix(trace_flag, NULL, __func__, __LINE__);\
+		PRINT(KERN_CONT, "%s:", message);			\
+		debug_print_buffer(buff, len);				\
+	}								\
+} while (0)
+
+#define PRINT_LOG_FLAG(log_flag, format, args...)			\
+do {									\
+	debug_print_prefix(trace_flag, __LOG_PREFIX, __func__, __LINE__);\
+	PRINT(KERN_CONT, format, args);					\
+} while (0)
+
+#define PRINT_WARNING(format, args...)					\
+do {									\
+	debug_print_prefix(trace_flag, __LOG_PREFIX, __func__, __LINE__);\
+	PRINT(KERN_CONT, "***WARNING***: " format, args);		\
+} while (0)
+
+#define PRINT_ERROR(format, args...)					\
+do {									\
+	debug_print_prefix(trace_flag, __LOG_PREFIX, __func__, __LINE__);\
+	PRINT(KERN_CONT, "***ERROR***: " format, args);			\
+} while (0)
+
+#define PRINT_CRIT_ERROR(format, args...)				\
+do {									\
+	debug_print_prefix(trace_flag, __LOG_PREFIX, __func__, __LINE__);\
+	PRINT(KERN_CONT, "***CRITICAL ERROR***: " format, args);	\
+} while (0)
+
+#define PRINT_INFO(format, args...)					\
+do {									\
+	debug_print_prefix(trace_flag, __LOG_PREFIX, __func__, __LINE__);\
+	PRINT(KERN_CONT, format, args);					\
+} while (0)
+
+#else  /* CONFIG_SCST_DEBUG */
+
+#define TRACE_MEM(format, args...) do {} while (0)
+#define TRACE_SG(format, args...) do {} while (0)
+#define TRACE_DBG(format, args...) do {} while (0)
+#define TRACE_DBG_FLAG(format, args...) do {} while (0)
+#define TRACE_DBG_SPECIAL(format, args...) do {} while (0)
+#define TRACE_MGMT_DBG(format, args...) do {} while (0)
+#define TRACE_MGMT_DBG_SPECIAL(format, args...) do {} while (0)
+#define TRACE_PR(format, args...) do {} while (0)
+#define TRACE_BUFFER(message, buff, len) do {} while (0)
+#define TRACE_BUFF_FLAG(flag, message, buff, len) do {} while (0)
+
+#ifdef LOG_PREFIX
+
+#define PRINT_INFO(format, args...)				\
+do {								\
+	PRINT(KERN_INFO, "%s: " format, LOG_PREFIX, args);	\
+} while (0)
+
+#define PRINT_WARNING(format, args...)          \
+do {                                            \
+	PRINT(KERN_INFO, "%s: ***WARNING***: "	\
+	      format, LOG_PREFIX, args);	\
+} while (0)
+
+#define PRINT_ERROR(format, args...)            \
+do {                                            \
+	PRINT(KERN_INFO, "%s: ***ERROR***: "	\
+	      format, LOG_PREFIX, args);	\
+} while (0)
+
+#define PRINT_CRIT_ERROR(format, args...)       \
+do {                                            \
+	PRINT(KERN_INFO, "%s: ***CRITICAL ERROR***: "	\
+		format, LOG_PREFIX, args);		\
+} while (0)
+
+#else
+
+#define PRINT_INFO(format, args...)		\
+do {                                            \
+	PRINT(KERN_INFO, format, args);		\
+} while (0)
+
+#define PRINT_WARNING(format, args...)          \
+do {                                            \
+	PRINT(KERN_INFO, "***WARNING***: "	\
+		format, args);			\
+} while (0)
+
+#define PRINT_ERROR(format, args...)		\
+do {                                            \
+	PRINT(KERN_ERR, "***ERROR***: "		\
+		format, args);			\
+} while (0)
+
+#define PRINT_CRIT_ERROR(format, args...)		\
+do {							\
+	PRINT(KERN_CRIT, "***CRITICAL ERROR***: "	\
+		format, args);				\
+} while (0)
+
+#endif /* LOG_PREFIX */
+
+#endif /* CONFIG_SCST_DEBUG */
+
+#if defined(CONFIG_SCST_DEBUG) && defined(CONFIG_DEBUG_SLAB)
+#define SCST_SLAB_FLAGS (SLAB_RED_ZONE | SLAB_POISON)
+#else
+#define SCST_SLAB_FLAGS 0L
+#endif
+
+#endif /* __SCST_DEBUG_H */
diff -uprN orig/linux-2.6.35/drivers/scst/scst_debug.c linux-2.6.35/drivers/scst/scst_debug.c
--- orig/linux-2.6.35/drivers/scst/scst_debug.c
+++ linux-2.6.35/drivers/scst/scst_debug.c
@@ -0,0 +1,223 @@
+/*
+ *  scst_debug.c
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  Contains helper functions for execution tracing and error reporting.
+ *  Intended to be included in main .c file.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <scst/scst.h>
+#include <scst/scst_debug.h>
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+
+#define TRACE_BUF_SIZE    512
+
+static char trace_buf[TRACE_BUF_SIZE];
+static DEFINE_SPINLOCK(trace_buf_lock);
+
+static inline int get_current_tid(void)
+{
+	/* Code should be the same as in sys_gettid() */
+	if (in_interrupt()) {
+		/*
+		 * Unfortunately, task_pid_vnr() isn't IRQ-safe, so otherwise
+		 * it can oops. ToDo.
+		 */
+		return 0;
+	}
+	return task_pid_vnr(current);
+}
+
+/**
+ * debug_print_prefix() - print debug prefix for a log line
+ *
+ * Prints, if requested by trace_flag, debug prefix for each log line
+ */
+int debug_print_prefix(unsigned long trace_flag,
+	const char *prefix, const char *func, int line)
+{
+	int i = 0;
+	unsigned long flags;
+	int pid = get_current_tid();
+
+	spin_lock_irqsave(&trace_buf_lock, flags);
+
+	trace_buf[0] = '\0';
+
+	if (trace_flag & TRACE_PID)
+		i += snprintf(&trace_buf[i], TRACE_BUF_SIZE, "[%d]: ", pid);
+	if (prefix != NULL)
+		i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i, "%s: ",
+			      prefix);
+	if (trace_flag & TRACE_FUNCTION)
+		i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i, "%s:", func);
+	if (trace_flag & TRACE_LINE)
+		i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i, "%i:", line);
+
+	PRINTN(KERN_INFO, "%s", trace_buf);
+
+	spin_unlock_irqrestore(&trace_buf_lock, flags);
+
+	return i;
+}
+EXPORT_SYMBOL(debug_print_prefix);
+
+/**
+ * debug_print_buffer() - print a buffer
+ *
+ * Prints in the log data from the buffer
+ */
+void debug_print_buffer(const void *data, int len)
+{
+	int z, z1, i;
+	const unsigned char *buf = (const unsigned char *) data;
+	unsigned long flags;
+
+	if (buf == NULL)
+		return;
+
+	spin_lock_irqsave(&trace_buf_lock, flags);
+
+	PRINT(KERN_INFO, " (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F");
+	for (z = 0, z1 = 0, i = 0; z < len; z++) {
+		if (z % 16 == 0) {
+			if (z != 0) {
+				i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i,
+					      " ");
+				for (; (z1 < z) && (i < TRACE_BUF_SIZE - 1);
+				     z1++) {
+					if ((buf[z1] >= 0x20) &&
+					    (buf[z1] < 0x80))
+						trace_buf[i++] = buf[z1];
+					else
+						trace_buf[i++] = '.';
+				}
+				trace_buf[i] = '\0';
+				PRINT(KERN_INFO, "%s", trace_buf);
+				i = 0;
+			}
+			i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i,
+				      "%4x: ", z);
+		}
+		i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i, "%02x ",
+			      buf[z]);
+	}
+
+	i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i, "  ");
+	for (; (z1 < z) && (i < TRACE_BUF_SIZE - 1); z1++) {
+		if ((buf[z1] > 0x20) && (buf[z1] < 0x80))
+			trace_buf[i++] = buf[z1];
+		else
+			trace_buf[i++] = '.';
+	}
+	trace_buf[i] = '\0';
+
+	PRINT(KERN_INFO, "%s", trace_buf);
+
+	spin_unlock_irqrestore(&trace_buf_lock, flags);
+	return;
+}
+EXPORT_SYMBOL(debug_print_buffer);
+
+/*
+ * This function converts transport_id in a string form into internal per-CPU
+ * static buffer. This buffer isn't anyhow protected, because it's acceptable
+ * if the name corrupted in the debug logs because of the race for this buffer.
+ *
+ * Note! You can't call this function 2 or more times in a single logging
+ * (printk) statement, because then each new call of this functon will override
+ * data written in this buffer by the previous call. You should instead split
+ * that logging statement on smaller statements each calling
+ * debug_transport_id_to_initiator_name() only once.
+ */
+const char *debug_transport_id_to_initiator_name(const uint8_t *transport_id)
+{
+	/*
+	 * No external protection, because it's acceptable if the name
+	 * corrupted in the debug logs because of the race for this
+	 * buffer.
+	 */
+#define SIZEOF_NAME_BUF 256
+	static char name_bufs[NR_CPUS][SIZEOF_NAME_BUF];
+	char *name_buf;
+	unsigned long flags;
+
+	BUG_ON(transport_id == NULL); /* better to catch it not under lock */
+
+	spin_lock_irqsave(&trace_buf_lock, flags);
+
+	name_buf = name_bufs[smp_processor_id()];
+
+	/*
+	 * To prevent external racing with us users from accidentally
+	 * missing their NULL terminator.
+	 */
+	memset(name_buf, 0, SIZEOF_NAME_BUF);
+	smp_mb();
+
+	switch (transport_id[0] & 0x0f) {
+	case SCSI_TRANSPORTID_PROTOCOLID_ISCSI:
+		scnprintf(name_buf, SIZEOF_NAME_BUF, "%s",
+			&transport_id[4]);
+		break;
+	case SCSI_TRANSPORTID_PROTOCOLID_FCP2:
+		scnprintf(name_buf, SIZEOF_NAME_BUF,
+			"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
+			transport_id[8], transport_id[9],
+			transport_id[10], transport_id[11],
+			transport_id[12], transport_id[13],
+			transport_id[14], transport_id[15]);
+		break;
+	case SCSI_TRANSPORTID_PROTOCOLID_SPI5:
+		scnprintf(name_buf, SIZEOF_NAME_BUF,
+			"%x:%x", be16_to_cpu((__force __be16)transport_id[2]),
+			be16_to_cpu((__force __be16)transport_id[6]));
+		break;
+	case SCSI_TRANSPORTID_PROTOCOLID_SRP:
+		scnprintf(name_buf, SIZEOF_NAME_BUF,
+			"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x"
+			":%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
+			transport_id[8], transport_id[9],
+			transport_id[10], transport_id[11],
+			transport_id[12], transport_id[13],
+			transport_id[14], transport_id[15],
+			transport_id[16], transport_id[17],
+			transport_id[18], transport_id[19],
+			transport_id[20], transport_id[21],
+			transport_id[22], transport_id[23]);
+		break;
+	case SCSI_TRANSPORTID_PROTOCOLID_SAS:
+		scnprintf(name_buf, SIZEOF_NAME_BUF,
+			"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
+			transport_id[4], transport_id[5],
+			transport_id[6], transport_id[7],
+			transport_id[8], transport_id[9],
+			transport_id[10], transport_id[11]);
+		break;
+	default:
+		scnprintf(name_buf, SIZEOF_NAME_BUF,
+			"(Not known protocol ID %x)", transport_id[0] & 0x0f);
+		break;
+	}
+
+	spin_unlock_irqrestore(&trace_buf_lock, flags);
+
+	return name_buf;
+#undef SIZEOF_NAME_BUF
+}
+
+#endif /* CONFIG_SCST_DEBUG || CONFIG_SCST_TRACING */

