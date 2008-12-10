From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 4/23]: SCST debug support
Date: Wed, 10 Dec 2008 21:36:22 +0300
Message-ID: <49400C26.3090604@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:60849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474AbYLJSgS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:36:18 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains definitions and functions for tracing various 
internal events. It can be fully compiled out and have no runtime overhead.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/scst_debug.c |  128 ++++++++++++++++
  include/scst/scst_debug.h |  361 ++++++++++++++++++++++++++++++++++++++++++++++
  2 files changed, 489 insertions(+)

diff -uprN orig/linux-2.6.27/include/scst/scst_debug.h linux-2.6.27/include/scst/scst_debug.h
--- orig/linux-2.6.27/include/scst/scst_debug.h
+++ linux-2.6.27/include/scst/scst_debug.h
@@ -0,0 +1,361 @@
+/*
+ *  include/scst_debug.h
+ *
+ *  Copyright (C) 2004 - 2008 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2008 CMS Distribution Limited
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
+#include <linux/autoconf.h>	/* for CONFIG_* */
+
+#include <linux/bug.h>		/* for WARN_ON_ONCE */
+
+
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+#define EXTRACHECKS_BUG_ON(a)		BUG_ON(a)
+#define EXTRACHECKS_WARN_ON(a)		WARN_ON(a)
+#define EXTRACHECKS_WARN_ON_ONCE(a)	WARN_ON_ONCE(a)
+#else
+#define EXTRACHECKS_BUG_ON(a)
+#define EXTRACHECKS_WARN_ON(a)
+#define EXTRACHECKS_WARN_ON_ONCE(a)
+#endif
+
+#ifdef CONFIG_SCST_DEBUG
+/*#  define LOG_FLAG KERN_DEBUG*/
+#  define LOG_FLAG KERN_INFO
+#  define INFO_FLAG KERN_INFO
+#  define ERROR_FLAG KERN_INFO
+#else
+# define LOG_FLAG KERN_INFO
+# define INFO_FLAG KERN_INFO
+# define ERROR_FLAG KERN_ERR
+#endif
+
+#define CRIT_FLAG KERN_CRIT
+
+#define NO_FLAG ""
+
+#define TRACE_NULL           0x00000000
+#define TRACE_DEBUG          0x00000001
+#define TRACE_FUNCTION       0x00000002
+#define TRACE_LINE           0x00000004
+#define TRACE_PID            0x00000008
+#define TRACE_ENTRYEXIT      0x00000010
+#define TRACE_BUFF           0x00000020
+#define TRACE_MEMORY         0x00000040
+#define TRACE_SG_OP          0x00000080
+#define TRACE_OUT_OF_MEM     0x00000100
+#define TRACE_MINOR          0x00000200 /* less important events */
+#define TRACE_MGMT           0x00000400
+#define TRACE_MGMT_MINOR     0x00000800
+#define TRACE_MGMT_DEBUG     0x00001000
+#define TRACE_SCSI           0x00002000
+#define TRACE_SPECIAL        0x00004000 /* filtering debug, etc */
+#define TRACE_ALL            0xffffffff
+/* Flags 0xXXXX0000 are local for users */
+
+/*
+ * Note: in the next two printk() statements the KERN_CONT macro is only
+ * present to suppress a checkpatch warning (KERN_CONT is defined as "").
+ */
+#define PRINT(log_flag, format, args...)  \
+		printk(KERN_CONT "%s" format "\n", log_flag, ## args)
+#define PRINTN(log_flag, format, args...) \
+		printk(KERN_CONT "%s" format, log_flag, ## args)
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
+extern int debug_print_prefix(unsigned long trace_flag, const char *log_level,
+	const char *prefix, const char *func, int line);
+extern void debug_print_buffer(const char *log_level, const void *data,
+	int len);
+
+#define TRACE(trace, format, args...)					  \
+do {									  \
+	if (___unlikely(trace_flag & (trace))) {			  \
+		char *__tflag = LOG_FLAG;				  \
+		if (debug_print_prefix(trace_flag, __tflag, __LOG_PREFIX, \
+				       __func__, __LINE__) > 0) {	  \
+			__tflag = NO_FLAG;				  \
+		}							  \
+		PRINT(NO_FLAG, "%s" format, __tflag, args);		  \
+	}								  \
+} while (0)
+
+#define PRINT_BUFFER(message, buff, len)                            \
+do {                                                                \
+	PRINT(NO_FLAG, "%s:", message);				    \
+	debug_print_buffer(INFO_FLAG, buff, len);		    \
+} while (0)
+
+#define PRINT_BUFF_FLAG(flag, message, buff, len)			\
+do {									\
+	if (___unlikely(trace_flag & (flag))) {				\
+		char *__tflag = INFO_FLAG;				\
+		if (debug_print_prefix(trace_flag, __tflag, NULL, __func__,\
+				       __LINE__) > 0) {			\
+			__tflag = NO_FLAG;				\
+		}							\
+		PRINT(NO_FLAG, "%s%s:", __tflag, message);		\
+		debug_print_buffer(INFO_FLAG, buff, len);		\
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
+#define __TRACE(trace, format, args...)					\
+do {									\
+	if (trace_flag & (trace)) {					\
+		char *__tflag = LOG_FLAG;				\
+		if (debug_print_prefix(trace_flag, __tflag, NULL, __func__,\
+				       __LINE__) > 0) {			\
+			__tflag = NO_FLAG;				\
+		}							\
+		PRINT(NO_FLAG, "%s" format, __tflag, args);		\
+	}								\
+} while (0)
+
+#define TRACE_MEM(args...)		__TRACE(TRACE_MEMORY, args)
+#define TRACE_SG(args...)		__TRACE(TRACE_SG_OP, args)
+#define TRACE_DBG(args...)		__TRACE(TRACE_DEBUG, args)
+#define TRACE_DBG_SPECIAL(args...)	__TRACE(TRACE_DEBUG|TRACE_SPECIAL, args)
+#define TRACE_MGMT_DBG(args...)		__TRACE(TRACE_MGMT_DEBUG, args)
+#define TRACE_MGMT_DBG_SPECIAL(args...)	\
+		__TRACE(TRACE_MGMT_DEBUG|TRACE_SPECIAL, args)
+
+#define TRACE_BUFFER(message, buff, len)				\
+do {									\
+	if (trace_flag & TRACE_BUFF) {					\
+		char *__tflag = LOG_FLAG;				\
+		if (debug_print_prefix(trace_flag, __tflag, NULL, __func__, \
+				       __LINE__) > 0) {			\
+			__tflag = NO_FLAG;				\
+		}							\
+		PRINT(NO_FLAG, "%s%s:", __tflag, message);		\
+		debug_print_buffer(LOG_FLAG, buff, len);		\
+	}								\
+} while (0)
+
+#define TRACE_BUFF_FLAG(flag, message, buff, len)			\
+do {									\
+	if (trace_flag & (flag)) {					\
+		char *__tflag = LOG_FLAG;				\
+		if (debug_print_prefix(trace_flag, __tflag, NULL, __func__, \
+				       __LINE__) > 0) {			\
+			__tflag = NO_FLAG;				\
+		}							\
+		PRINT(NO_FLAG, "%s%s:", __tflag, message);		\
+		debug_print_buffer(LOG_FLAG, buff, len);		\
+	}								\
+} while (0)
+
+#define PRINT_LOG_FLAG(log_flag, format, args...)			\
+do {									\
+	char *__tflag = log_flag;					\
+	if (debug_print_prefix(trace_flag, __tflag, __LOG_PREFIX,	\
+			       __func__, __LINE__) > 0) {		\
+		__tflag = NO_FLAG;					\
+	}								\
+	PRINT(NO_FLAG, "%s" format, __tflag, args);			\
+} while (0)
+
+#define PRINT_WARNING(format, args...)					\
+do {									\
+	if (strcmp(INFO_FLAG, LOG_FLAG)) {				\
+		PRINT_LOG_FLAG(LOG_FLAG, "***WARNING*** " format, args); \
+	}								\
+	PRINT_LOG_FLAG(INFO_FLAG, "***WARNING*** " format, args);	\
+} while (0)
+
+#define PRINT_ERROR(format, args...)					\
+do {									\
+	if (strcmp(ERROR_FLAG, LOG_FLAG)) {				\
+		PRINT_LOG_FLAG(LOG_FLAG, "***ERROR*** " format, args);	\
+	}								\
+	PRINT_LOG_FLAG(ERROR_FLAG, "***ERROR*** " format, args);	\
+} while (0)
+
+#define PRINT_CRIT_ERROR(format, args...)				\
+do {									\
+	/*  if (strcmp(CRIT_FLAG, LOG_FLAG))				\
+	    {								\
+	    PRINT_LOG_FLAG(LOG_FLAG, "***CRITICAL ERROR*** " format, args); \
+	    }*/								\
+	PRINT_LOG_FLAG(CRIT_FLAG, "***CRITICAL ERROR*** " format, args); \
+} while (0)
+
+#define PRINT_INFO(format, args...)			\
+do {							\
+	if (strcmp(INFO_FLAG, LOG_FLAG)) {		\
+		PRINT_LOG_FLAG(LOG_FLAG, format, args);	\
+	}						\
+	PRINT_LOG_FLAG(INFO_FLAG, format, args);	\
+} while (0)
+
+#define TRACE_ENTRY()							\
+do {									\
+	if (trace_flag & TRACE_ENTRYEXIT) {				\
+		if (trace_flag & TRACE_PID) {				\
+			PRINT(LOG_FLAG, "[%d]: ENTRY %s", current->pid, \
+				__func__);				\
+		}							\
+		else {							\
+			PRINT(LOG_FLAG, "ENTRY %s", __func__);		\
+		}							\
+	}								\
+} while (0)
+
+#define TRACE_EXIT()							\
+do {									\
+	if (trace_flag & TRACE_ENTRYEXIT) {				\
+		if (trace_flag & TRACE_PID) {				\
+			PRINT(LOG_FLAG, "[%d]: EXIT %s", current->pid,	\
+				__func__);				\
+		}							\
+		else {							\
+			PRINT(LOG_FLAG, "EXIT %s", __func__);		\
+		}							\
+	}								\
+} while (0)
+
+#define TRACE_EXIT_RES(res)						\
+do {									\
+	if (trace_flag & TRACE_ENTRYEXIT) {				\
+		if (trace_flag & TRACE_PID) {				\
+			PRINT(LOG_FLAG, "[%d]: EXIT %s: %ld", current->pid, \
+			      __func__, (long)(res));			\
+		}							\
+		else {							\
+			PRINT(LOG_FLAG, "EXIT %s: %ld",			\
+				__func__, (long)(res));			\
+		}							\
+	}                                                               \
+} while (0)
+
+#define TRACE_EXIT_HRES(res)						\
+do {									\
+	if (trace_flag & TRACE_ENTRYEXIT) {				\
+		if (trace_flag & TRACE_PID) {				\
+			PRINT(LOG_FLAG, "[%d]: EXIT %s: 0x%lx", current->pid, \
+			      __func__, (long)(res));			\
+		}							\
+		else {							\
+			PRINT(LOG_FLAG, "EXIT %s: %lx",			\
+					__func__, (long)(res));		\
+		}							\
+	}                                                               \
+} while (0)
+
+#else  /* CONFIG_SCST_DEBUG */
+
+#define TRACE_MEM(format, args...) do {} while (0)
+#define TRACE_SG(format, args...) do {} while (0)
+#define TRACE_DBG(format, args...) do {} while (0)
+#define TRACE_DBG_SPECIAL(format, args...) do {} while (0)
+#define TRACE_MGMT_DBG(format, args...) do {} while (0)
+#define TRACE_MGMT_DBG_SPECIAL(format, args...) do {} while (0)
+#define TRACE_BUFFER(message, buff, len) do {} while (0)
+#define TRACE_BUFF_FLAG(flag, message, buff, len) do {} while (0)
+#define TRACE_ENTRY() do {} while (0)
+#define TRACE_EXIT() do {} while (0)
+#define TRACE_EXIT_RES(res) do {} while (0)
+#define TRACE_EXIT_HRES(res) do {} while (0)
+
+#ifdef LOG_PREFIX
+
+#define PRINT_INFO(format, args...)				\
+do {								\
+	PRINT(INFO_FLAG, "%s: " format, LOG_PREFIX, args);	\
+} while (0)
+
+#define PRINT_WARNING(format, args...)          \
+do {                                            \
+	PRINT(INFO_FLAG, "%s: ***WARNING*** "	\
+	      format, LOG_PREFIX, args);	\
+} while (0)
+
+#define PRINT_ERROR(format, args...)            \
+do {                                            \
+	PRINT(ERROR_FLAG, "%s: ***ERROR*** "	\
+	      format, LOG_PREFIX, args);	\
+} while (0)
+
+#define PRINT_CRIT_ERROR(format, args...)       \
+do {                                            \
+	PRINT(CRIT_FLAG, "%s: ***CRITICAL ERROR*** "	\
+		format, LOG_PREFIX, args);		\
+} while (0)
+
+#else
+
+#define PRINT_INFO(format, args...)           	\
+do {                                            \
+	PRINT(INFO_FLAG, format, args);		\
+} while (0)
+
+#define PRINT_WARNING(format, args...)          \
+do {                                            \
+	PRINT(INFO_FLAG, "***WARNING*** "	\
+		format, args);			\
+} while (0)
+
+#define PRINT_ERROR(format, args...)          	\
+do {                                            \
+	PRINT(ERROR_FLAG, "***ERROR*** "	\
+		format, args);			\
+} while (0)
+
+#define PRINT_CRIT_ERROR(format, args...)		\
+do {							\
+	PRINT(CRIT_FLAG, "***CRITICAL ERROR*** "	\
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
diff -uprN orig/linux-2.6.27/drivers/scst/scst_debug.c linux-2.6.27/drivers/scst/scst_debug.c
--- orig/linux-2.6.27/drivers/scst/scst_debug.c
+++ linux-2.6.27/drivers/scst/scst_debug.c
@@ -0,0 +1,128 @@
+/*
+ *  scst_debug.c
+ *
+ *  Copyright (C) 2004 - 2008 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2008 CMS Distribution Limited
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
+int debug_print_prefix(unsigned long trace_flag, const char *log_level,
+	const char *prefix, const char *func, int line)
+{
+	int i = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&trace_buf_lock, flags);
+
+	if (trace_flag & TRACE_PID)
+		i += snprintf(&trace_buf[i], TRACE_BUF_SIZE, "[%d]: ",
+			      get_current_tid());
+	if (prefix != NULL)
+		i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i, "%s: ",
+			      prefix);
+	if (trace_flag & TRACE_FUNCTION)
+		i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i, "%s:", func);
+	if (trace_flag & TRACE_LINE)
+		i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i, "%i:", line);
+
+	if (i > 0)
+		PRINTN(log_level, "%s", trace_buf);
+
+	spin_unlock_irqrestore(&trace_buf_lock, flags);
+
+	return i;
+}
+EXPORT_SYMBOL(debug_print_prefix);
+
+void debug_print_buffer(const char *log_level, const void *data, int len)
+{
+	int z, z1, i;
+	const unsigned char *buf = (const unsigned char *) data;
+	int f = 0;
+	unsigned long flags;
+
+	if (buf == NULL)
+		return;
+
+	spin_lock_irqsave(&trace_buf_lock, flags);
+
+	PRINT(NO_FLAG, " (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F");
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
+				PRINT(NO_FLAG, "%s", trace_buf);
+				i = 0;
+				f = 1;
+			}
+			i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i,
+				      "%4x: ", z);
+		}
+		i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i, "%02x ",
+			      buf[z]);
+	}
+	i += snprintf(&trace_buf[i], TRACE_BUF_SIZE - i, "  ");
+	for (; (z1 < z) && (i < TRACE_BUF_SIZE - 1); z1++) {
+		if ((buf[z1] > 0x20) && (buf[z1] < 0x80))
+			trace_buf[i++] = buf[z1];
+		else
+			trace_buf[i++] = '.';
+	}
+	trace_buf[i] = '\0';
+	if (f)
+		PRINT(log_level, "%s", trace_buf);
+	else
+		PRINT(NO_FLAG, "%s", trace_buf);
+
+	spin_unlock_irqrestore(&trace_buf_lock, flags);
+	return;
+}
+EXPORT_SYMBOL(debug_print_buffer);
+
+#endif /* CONFIG_SCST_DEBUG || CONFIG_SCST_TRACING */



