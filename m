From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH][RFC 9/12/1/5] SCST debugging support
Date: Tue, 13 Apr 2010 17:06:42 +0400
Message-ID: <4BC46C62.7050400@vlnb.net>
References: <4BC44A49.7070307@vlnb.net> <4BC44D08.4060907@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BC44D08.4060907@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, linux-driver@qlogic.com
List-Id: linux-scsi@vger.kernel.org

This patch contains SCST debugging support routines.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 drivers/scst/scst_debug.c |  136 ++++++++++++++++++++++
 include/scst/scst_debug.h |  276 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 412 insertions(+)

diff -uprN orig/linux-2.6.33/include/scst/scst_debug.h linux-2.6.33/include/scst/scst_debug.h
--- orig/linux-2.6.33/include/scst/scst_debug.h
+++ linux-2.6.33/include/scst/scst_debug.h
@@ -0,0 +1,276 @@
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
+extern int debug_print_prefix(unsigned long trace_flag,
+	const char *prefix, const char *func, int line);
+extern void debug_print_buffer(const void *data, int len);
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
+#define PRINT_INFO(format, args...)           	\
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
+#define PRINT_ERROR(format, args...)          	\
+do {                                            \
+	PRINT(KERN_ERR, "***ERROR***: "	\
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
diff -uprN orig/linux-2.6.33/drivers/scst/scst_debug.c linux-2.6.33/drivers/scst/scst_debug.c
--- orig/linux-2.6.33/drivers/scst/scst_debug.c
+++ linux-2.6.33/drivers/scst/scst_debug.c
@@ -0,0 +1,136 @@
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
+#include "scst.h"
+#include "scst_debug.h"
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
+#endif /* CONFIG_SCST_DEBUG || CONFIG_SCST_TRACING */
