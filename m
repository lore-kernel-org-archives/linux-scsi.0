From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 2/2] Removed unused sa_log functions
Date: Fri, 21 Dec 2007 16:24:35 -0800
Message-ID: <20071222002435.6543.55682.stgit@vdinit.jf.intel.com>
References: <20071222002255.6543.32102.stgit@vdinit.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:14045 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbXLVAax (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2007 19:30:53 -0500
In-Reply-To: <20071222002255.6543.32102.stgit@vdinit.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/ofc/libsa/Makefile        |    1 
 drivers/scsi/ofc/libsa/sa_cons_linux.c |   37 ----------
 drivers/scsi/ofc/libsa/sa_log.c        |  117 --------------------------------
 3 files changed, 0 insertions(+), 155 deletions(-)

diff --git a/drivers/scsi/ofc/libsa/Makefile b/drivers/scsi/ofc/libsa/Makefile
index 1431906..7f13291 100644
--- a/drivers/scsi/ofc/libsa/Makefile
+++ b/drivers/scsi/ofc/libsa/Makefile
@@ -6,7 +6,6 @@ obj-y += libsa.o
 
 libsa-y := \
 	sa_assert.o \
-	sa_cons_linux.o \
 	sa_event.o \
 	sa_hash_kern.o \
 	sa_state.o \
diff --git a/drivers/scsi/ofc/libsa/sa_cons_linux.c b/drivers/scsi/ofc/libsa/sa_cons_linux.c
deleted file mode 100644
index 037866b..0000000
--- a/drivers/scsi/ofc/libsa/sa_cons_linux.c
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * Copyright(c) 2007 Intel Corporation. All rights reserved.
- * 
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- * 
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- * 
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * 
- * Maintained at www.Open-FCoE.org
- */
-
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include "ofc_dbg.h"
-
-void sa_log_output(const char *buf)
-{
-	printk(KERN_INFO "%s", buf);
-}
-
-void sa_log_abort(const char *buf)
-{
-	panic(buf);
-}
-
-void sa_log_output_exit(const char *buf)
-{
-	panic(buf);
-}
diff --git a/drivers/scsi/ofc/libsa/sa_log.c b/drivers/scsi/ofc/libsa/sa_log.c
deleted file mode 100644
index a3e26cb..0000000
--- a/drivers/scsi/ofc/libsa/sa_log.c
+++ /dev/null
@@ -1,117 +0,0 @@
-/*
- * Copyright(c) 2007 Intel Corporation. All rights reserved.
- * 
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- * 
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- * 
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * 
- * Maintained at www.Open-FCoE.org
- */
-
-#include <linux/autoconf.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-
-#include "sa_kernel.h"
-#include "ofc_dbg.h"
-
-/*
- * Size of on-stack line buffers.
- * These shouldn't be to large for a kernel stack frame.
- */
-#define OFC_DBG_BUF_LEN  200	/* on-stack line buffer size */
-
-/*
- * log with a variable argument list.
- */
-static void sa_log_va(const char *func, const char *format, va_list arg)
-{
-	size_t len;
-	size_t flen;
-	int add_newline;
-	char sa_buf[OFC_DBG_BUF_LEN];
-	char *bp;
-
-	/*
-	 * If the caller didn't provide a newline at the end, we will.
-	 */
-	len = strlen(format);
-	add_newline = 0;
-	if (!len || format[len - 1] != '\n')
-		add_newline = 1;
-	bp = sa_buf;
-	len = sizeof(sa_buf);
-	if (func) {
-		flen = snprintf(bp, len, "%s: ", func);
-		len -= flen;
-		bp += flen;
-	}
-	flen = vsnprintf(bp, len, format, arg);
-	if (add_newline && flen < len) {
-		bp += flen;
-		*bp++ = '\n';
-		*bp = '\0';
-	}
-	sa_log_output(sa_buf);
-}
-
-/*
- * log
- */
-void sa_log(const char *format, ...)
-{
-	va_list arg;
-
-	va_start(arg, format);
-	sa_log_va(NULL, format, arg);
-	va_end(arg);
-}
-
-/*
- * log with function name.
- */
-void sa_log_func(const char *func, const char *format, ...)
-{
-	va_list arg;
-
-	va_start(arg, format);
-	sa_log_va(func, format, arg);
-	va_end(arg);
-}
-
-EXPORT_SYMBOL(sa_log_func);
-
-static char *strerror_r(int err, char *buf, size_t len)
-{
-	return "";
-}
-
-/*
- * log with error number.
- */
-void sa_log_err(int error, const char *func, const char *format, ...)
-{
-	va_list arg;
-	char buf[OFC_DBG_BUF_LEN];
-
-	if (func) {
-		sa_log("%s: error %d %s", func, error,
-		       strerror_r(error, buf, sizeof(buf)));
-	} else {
-		sa_log("error %d %s", error,
-		       strerror_r(error, buf, sizeof(buf)));
-	}
-	va_start(arg, format);
-	sa_log_va(func, format, arg);
-	va_end(arg);
-}

