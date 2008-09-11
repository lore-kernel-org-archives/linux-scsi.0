From: Chris Leech <christopher.leech@intel.com>
Subject: [PATCH 3/4] 24-bit types: Convert jfs to use the common 24-bit types
Date: Wed, 10 Sep 2008 19:15:00 -0700
Message-ID: <20080911021500.23621.87074.stgit@localhost.localdomain>
References: <20080911021448.23621.42553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12298 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbYIKCPD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 22:15:03 -0400
In-Reply-To: <20080911021448.23621.42553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: jfs-discussion@lists.sourceforge.net, Boaz Harrosh <bharrosh@panasas.com>, Harvey Harrison <harvey.harrison@gmail.com>, Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Chris Leech <christopher.leech@intel.com>

From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

This patch cleans up some of the ugliness in the jfs headers and
uses the common 24-bit types instead of its private definitions.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Chris Leech <christopher.leech@intel.com>
---

 fs/jfs/endian24.h  |   54 ----------------------------------------------------
 fs/jfs/jfs_types.h |   22 ++++++++++-----------
 fs/jfs/jfs_xtree.h |   16 ++++++++-------
 3 files changed, 18 insertions(+), 74 deletions(-)
 delete mode 100644 fs/jfs/endian24.h


diff --git a/fs/jfs/endian24.h b/fs/jfs/endian24.h
deleted file mode 100644
index 45b6397..0000000
--- a/fs/jfs/endian24.h
+++ /dev/null
@@ -1,54 +0,0 @@
-/*
- *   Copyright (C) International Business Machines Corp., 2001
- *
- *   This program is free software;  you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License as published by
- *   the Free Software Foundation; either version 2 of the License, or
- *   (at your option) any later version.
- *
- *   This program is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- *   the GNU General Public License for more details.
- *
- *   You should have received a copy of the GNU General Public License
- *   along with this program;  if not, write to the Free Software
- *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-#ifndef _H_ENDIAN24
-#define	_H_ENDIAN24
-
-/*
- *	endian24.h:
- *
- * Endian conversion for 24-byte data
- *
- */
-#define __swab24(x) \
-({ \
-	__u32 __x = (x); \
-	((__u32)( \
-		((__x & (__u32)0x000000ffUL) << 16) | \
-		 (__x & (__u32)0x0000ff00UL)	    | \
-		((__x & (__u32)0x00ff0000UL) >> 16) )); \
-})
-
-#undef __cpu_to_le24
-#undef __le24_to_cpu
-
-#if (defined(__KERNEL__) && defined(__LITTLE_ENDIAN)) || (defined(__BYTE_ORDER) && (__BYTE_ORDER == __LITTLE_ENDIAN))
-	#define __cpu_to_le24(x) ((__u32)(x))
-	#define __le24_to_cpu(x) ((__u32)(x))
-#else
-	#define __cpu_to_le24(x) __swab24(x)
-	#define __le24_to_cpu(x) __swab24(x)
-#endif
-
-#ifdef __KERNEL__
-	#undef cpu_to_le24
-	#undef le24_to_cpu
-	#define cpu_to_le24 __cpu_to_le24
-	#define le24_to_cpu __le24_to_cpu
-#endif
-
-#endif				/* !_H_ENDIAN24 */
diff --git a/fs/jfs/jfs_types.h b/fs/jfs/jfs_types.h
index 649f981..6c49b93 100644
--- a/fs/jfs/jfs_types.h
+++ b/fs/jfs/jfs_types.h
@@ -30,8 +30,6 @@
 #include <linux/types.h>
 #include <linux/nls.h>
 
-#include "endian24.h"
-
 /*
  * transaction and lock id's
  *
@@ -62,7 +60,7 @@ struct timestruc_t {
  */
 typedef struct {
 	unsigned len:24;
-	unsigned off1:8;
+	u8 off1;
 	u32 off2;
 } lxd_t;
 
@@ -90,8 +88,8 @@ struct lxdlist {
  *	physical xd (pxd)
  */
 typedef struct {
-	unsigned len:24;
-	unsigned addr1:8;
+	__le24 len;
+	u8 addr1;
 	__le32 addr2;
 } pxd_t;
 
@@ -122,13 +120,13 @@ struct pxdlist {
  *	data extent descriptor (dxd)
  */
 typedef struct {
-	unsigned flag:8;	/* 1: flags */
-	unsigned rsrvd:24;
-	__le32 size;		/* 4: size in byte */
-	unsigned len:24;	/* 3: length in unit of fsblksize */
-	unsigned addr1:8;	/* 1: address in unit of fsblksize */
-	__le32 addr2;		/* 4: address in unit of fsblksize */
-} dxd_t;			/* - 16 - */
+	u8 flag;	/* 1: flags */
+	u8 rsrvd[3];
+	__le32 size;	/* 4: size in byte */
+	__le24 len;	/* 3: length in unit of fsblksize */
+	u8 addr1;	/* 1: address in unit of fsblksize */
+	__le32 addr2;	/* 4: address in unit of fsblksize */
+} dxd_t;		/* - 16 - */
 
 /* dxd_t flags */
 #define	DXD_INDEX	0x80	/* B+-tree index */
diff --git a/fs/jfs/jfs_xtree.h b/fs/jfs/jfs_xtree.h
index 70815c8..92beff3 100644
--- a/fs/jfs/jfs_xtree.h
+++ b/fs/jfs/jfs_xtree.h
@@ -29,14 +29,14 @@
  *	extent allocation descriptor (xad)
  */
 typedef struct xad {
-	unsigned flag:8;	/* 1: flag */
-	unsigned rsvrd:16;	/* 2: reserved */
-	unsigned off1:8;	/* 1: offset in unit of fsblksize */
-	__le32 off2;		/* 4: offset in unit of fsblksize */
-	unsigned len:24;	/* 3: length in unit of fsblksize */
-	unsigned addr1:8;	/* 1: address in unit of fsblksize */
-	__le32 addr2;		/* 4: address in unit of fsblksize */
-} xad_t;			/* (16) */
+	u8 flag;	/* 1: flag */
+	u8 rsvrd[2];	/* 2: reserved */
+	u8 off1;	/* 1: offset in unit of fsblksize */
+	__le32 off2;	/* 4: offset in unit of fsblksize */
+	__le24 len;	/* 3: length in unit of fsblksize */
+	u8 addr1;	/* 1: address in unit of fsblksize */
+	__le32 addr2;	/* 4: address in unit of fsblksize */
+} xad_t;		/* (16) */
 
 #define MAXXLEN		((1 << 24) - 1)
 

