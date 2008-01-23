From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/10] [FCoE] Remove sa_assert files
Date: Tue, 22 Jan 2008 16:37:41 -0800
Message-ID: <20080123003741.8469.30213.stgit@fritz>
References: <20080123003523.8469.62236.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:13048 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758277AbYAWAvd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 19:51:33 -0500
In-Reply-To: <20080123003523.8469.62236.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/ofc/include/sa_assert.h |   85 ----------------------------------
 drivers/scsi/ofc/libsa/Makefile      |    1 
 drivers/scsi/ofc/libsa/sa_assert.c   |   50 --------------------
 3 files changed, 0 insertions(+), 136 deletions(-)
 delete mode 100644 drivers/scsi/ofc/include/sa_assert.h
 delete mode 100644 drivers/scsi/ofc/libsa/sa_assert.c


diff --git a/drivers/scsi/ofc/include/sa_assert.h b/drivers/scsi/ofc/include/sa_assert.h
deleted file mode 100644
index 16224d7..0000000
--- a/drivers/scsi/ofc/include/sa_assert.h
+++ /dev/null
@@ -1,85 +0,0 @@
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
-#ifndef _LIBSA_ASSERT_H_
-#define _LIBSA_ASSERT_H_
-
-extern void assert_failed(const char *s, ...)
-    __attribute__ ((format(printf, 1, 2)));
-
-#ifndef UNLIKELY
-#define UNLIKELY(_x) (_x)
-#endif /* UNLIKELY */
-
-/*
- * ASSERT macros
- *
- * ASSERT(expr) - this calls assert_failed() if expr is false.  This variant
- * is not present in production code or if DEBUG_ASSERTS is not defined.
- * Be careful not to rely on expr being evaluated.
- */
-#if defined(DEBUG_ASSERTS)
-#define ASSERT(_x) do {                                                 \
-                if (UNLIKELY(!(_x))) {                                  \
-                        assert_failed("ASSERT FAILED (%s) @ %s:%d\n",   \
-                          "" #_x, __FILE__, __LINE__);                  \
-                }                                                       \
-        } while (0)
-#else
-#define ASSERT(_x)
-#endif /* DEBUG_ASSERTS */
-
-/*
- * ASSERT_NOTIMPL(expr) - this calls assert_failed() if expr is false.
- * The implication is that the condition is not handled by the current
- * implementation, and work should be done eventually to handle this.
- */
-#define ASSERT_NOTIMPL(_x) do {                                         \
-                if (UNLIKELY(!(_x))) {                                  \
-                        assert_failed("ASSERT (NOT IMPL) (%s) @ %s:%d\n", \
-                          "" #_x, __FILE__, __LINE__);                  \
-                }                                                       \
-        } while (0)
-
-/*
- * ASSERT_NOTREACHED - this is the same as ASSERT_NOTIMPL(0).
- */
-#define ASSERT_NOTREACHED do {                                          \
-                assert_failed("ASSERT (NOT REACHED) @ %s:%d\n",         \
-                    __FILE__, __LINE__);                                \
-        } while (0)
-
-/*
- * ASSERT_BUG(bugno, expr).  This variant is used when a bug number has
- * been assigned to any one of the other assertion failures.  It is always
- * present in code.  It gives the bug number which helps locate
- * documentation and helps prevent duplicate bug filings.
- */
-#define ASSERT_BUG(_bugNr, _x) do {                                     \
-                if (UNLIKELY(!(_x))) {                                  \
-                        assert_failed("ASSERT (BUG %d) (%s) @ %s:%d\n", \
-                            (_bugNr), #_x, __FILE__, __LINE__);         \
-                }                                                       \
-        } while (0)
-
-#ifndef LIBSA_USE_DANGEROUS_ROUTINES
-#define gets   DONT_USE_gets
-#endif /* LIBSA_USE_DANGEROUS_ROUTINES */
-
-#endif /* _LIBSA_ASSERT_H_ */
diff --git a/drivers/scsi/ofc/libsa/Makefile b/drivers/scsi/ofc/libsa/Makefile
index 42b8733..6206b78 100644
--- a/drivers/scsi/ofc/libsa/Makefile
+++ b/drivers/scsi/ofc/libsa/Makefile
@@ -5,7 +5,6 @@ EXTRA_CFLAGS += -I$(OFC_DIR)/include
 obj-y += libsa.o
 
 libsa-y := \
-	sa_assert.o \
 	sa_event.o \
 	sa_hash_kern.o \
 	sa_timer.o
diff --git a/drivers/scsi/ofc/libsa/sa_assert.c b/drivers/scsi/ofc/libsa/sa_assert.c
deleted file mode 100644
index 0824bb6..0000000
--- a/drivers/scsi/ofc/libsa/sa_assert.c
+++ /dev/null
@@ -1,50 +0,0 @@
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
-
-#include "ofc_dbg.h"
-#include "sa_assert.h"
-
-/*
- * Size of on-stack line buffers.
- * These shouldn't be to large for a kernel stack frame.
- */
-#define OFC_DBG_BUF_LEN  200	/* on-stack line buffer size */
-
-/*
- * Assert failures.
- */
-void assert_failed(const char *format, ...)
-{
-	va_list arg;
-	char buf[OFC_DBG_BUF_LEN];
-
-	va_start(arg, format);
-	vsnprintf(buf, sizeof(buf), format, arg);
-	va_end(arg);
-	panic(buf);
-}
-
-EXPORT_SYMBOL(assert_failed);

