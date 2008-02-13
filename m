From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 4/4] [FCoE] remove sa_hash_kern.c/sa_hash.h
Date: Wed, 13 Feb 2008 11:10:08 -0800
Message-ID: <20080213191008.23885.14297.stgit@localhost.localdomain>
References: <20080213190608.23885.66646.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYBMTZw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 14:25:52 -0500
In-Reply-To: <20080213190608.23885.66646.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: devel@open-fcoe.org

This patch removes using sa_hash_kern.c and sa_hash.h files. All references
to the sa_hash.h are also removed.

1. Removed libsa/sa_hash_kern.c
2. Removed include/sa_hash.h
3. Removed all references to sa_hash_xxx
4. Updated Makefile accordingly in libsa

Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/ofc/include/sa_hash.h    |   65 ---------------
 drivers/scsi/ofc/libfc/fc_exch.c      |    1 
 drivers/scsi/ofc/libsa/Makefile       |    4 -
 drivers/scsi/ofc/libsa/sa_hash_kern.c |  141 ---------------------------------
 4 files changed, 1 insertions(+), 210 deletions(-)
 delete mode 100644 drivers/scsi/ofc/include/sa_hash.h
 delete mode 100644 drivers/scsi/ofc/libsa/sa_hash_kern.c


diff --git a/drivers/scsi/ofc/include/sa_hash.h b/drivers/scsi/ofc/include/sa_hash.h
deleted file mode 100644
index d4ee6be..0000000
--- a/drivers/scsi/ofc/include/sa_hash.h
+++ /dev/null
@@ -1,65 +0,0 @@
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
-#ifndef _LIBSA_HASH_H_
-#define _LIBSA_HASH_H_
-
-#include <linux/list.h>
-
-/*
- * Hash table facility.
- */
-struct sa_hash;
-
-/*
- * Hash key value.
- */
-typedef void *		sa_hash_key_t;		/* pointer hash key */
-typedef u_int32_t	sa_hash_key32_t;	/* fixed-size 32-bit hash key */
-
-struct sa_hash_type {
-	u_int16_t	st_link_offset;	/* offset of linkage in the element */
-	int		(*st_match)(const sa_hash_key_t, void *elem);
-	u_int32_t	(*st_hash)(const sa_hash_key_t);
-};
-
-/*
- * Element linkage on the hash.
- * The collision list is circular.
- */
-#define sa_hash_link    hlist_node
-
-struct sa_hash *sa_hash_create(const struct sa_hash_type *, u_int32_t size);
-
-void sa_hash_destroy(struct sa_hash *);
-
-void *sa_hash_lookup(struct sa_hash *, const sa_hash_key_t);
-
-void sa_hash_insert(struct sa_hash *, const sa_hash_key_t, void *elem);
-
-void sa_hash_insert_next(struct sa_hash *, sa_hash_key32_t *,
-			 sa_hash_key32_t min_key, sa_hash_key32_t max_key,
-			 void *elem);
-
-void *sa_hash_lookup_delete(struct sa_hash *, const sa_hash_key_t);
-
-void sa_hash_iterate(struct sa_hash *,
-			void (*callback)(void *entry, void *arg), void *arg);
-
-#endif /* _LIBSA_HASH_H_ */
diff --git a/drivers/scsi/ofc/libfc/fc_exch.c b/drivers/scsi/ofc/libfc/fc_exch.c
index db67d98..1ceab9c 100644
--- a/drivers/scsi/ofc/libfc/fc_exch.c
+++ b/drivers/scsi/ofc/libfc/fc_exch.c
@@ -27,7 +27,6 @@
 #include "sa_kernel.h"
 #include "net_types.h"
 #include "ofc_dbg.h"
-#include "sa_hash.h"
 
 #include "fc_fcip.h"
 #include "fc_fc2.h"
diff --git a/drivers/scsi/ofc/libsa/Makefile b/drivers/scsi/ofc/libsa/Makefile
index 3453608..fa6da75 100644
--- a/drivers/scsi/ofc/libsa/Makefile
+++ b/drivers/scsi/ofc/libsa/Makefile
@@ -4,6 +4,4 @@ EXTRA_CFLAGS += -I$(OFC_DIR)/include
 
 obj-y += libsa.o
 
-libsa-y := \
-	sa_event.o \
-	sa_hash_kern.o
+libsa-y := sa_event.o
diff --git a/drivers/scsi/ofc/libsa/sa_hash_kern.c b/drivers/scsi/ofc/libsa/sa_hash_kern.c
deleted file mode 100644
index f1103a5..0000000
--- a/drivers/scsi/ofc/libsa/sa_hash_kern.c
+++ /dev/null
@@ -1,141 +0,0 @@
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
-#include "sa_kernel.h"
-#include "ofc_dbg.h"
-#include "sa_hash.h"
-
-struct sa_hash {
-	struct sa_hash_type sh_type;
-	u_int32_t sh_mask;	/* mask for the size of the table */
-	u_int32_t sh_entries;	/* number of entries now in the table */
-	struct hlist_head sh_table[0];	/* table (will be allocated bigger) */
-};
-
-struct sa_hash_elem {		/* stand-in for the real client element */
-	struct hlist_node elem_node;
-};
-
-static inline struct hlist_head *sa_hash_bucket(struct sa_hash *hp,
-						sa_hash_key_t key)
-{
-	return &hp->sh_table[(*hp->sh_type.st_hash) (key) & hp->sh_mask];
-}
-
-struct sa_hash *sa_hash_create(const struct sa_hash_type *tp, uint32_t req_size)
-{
-	struct sa_hash *hp;
-	u_int32_t size;
-	size_t len;
-
-	/*
-	 * Pick power of 2 at least as big as size.
-	 */
-	for (size = 4; size < (1UL << 31); size <<= 1)
-		if (size >= req_size)
-			break;
-
-	len = sizeof(*hp) + size * sizeof(struct hlist_head);
-	hp = sa_malloc(len);
-	if (hp) {
-		memset(hp, 0, len);
-		hp->sh_type = *tp;
-		hp->sh_mask = size - 1;
-	}
-	return hp;
-}
-
-void sa_hash_destroy(struct sa_hash *hp)
-{
-	sa_free(hp);
-}
-
-void *sa_hash_lookup(struct sa_hash *hp, const sa_hash_key_t key)
-{
-	struct sa_hash_elem *ep;
-	struct hlist_node *np;
-	struct hlist_head *hhp;
-	void *rp = NULL;
-
-	hhp = sa_hash_bucket(hp, key);
-	hlist_for_each_entry_rcu(ep, np, hhp, elem_node) {
-		rp = (void *)((char *)ep - hp->sh_type.st_link_offset);
-		if ((*hp->sh_type.st_match) (key, rp))
-			break;
-		rp = NULL;
-	}
-	return rp;
-}
-
-void *sa_hash_lookup_delete(struct sa_hash *hp, const sa_hash_key_t key)
-{
-	struct sa_hash_elem *ep;
-	struct hlist_node *np;
-	struct hlist_head *hhp;
-	void *rp = NULL;
-
-	hhp = sa_hash_bucket(hp, key);
-	hlist_for_each_entry_rcu(ep, np, hhp, elem_node) {
-		rp = (void *)((char *)ep - hp->sh_type.st_link_offset);
-		if ((*hp->sh_type.st_match) (key, rp)) {
-			hlist_del_rcu(np);
-			hp->sh_entries--;
-			break;
-		}
-		rp = NULL;
-	}
-	return (rp);
-}
-
-void sa_hash_insert(struct sa_hash *hp, const sa_hash_key_t key, void *ep)
-{
-	struct hlist_head *hhp;
-	struct hlist_node *lp;	/* new link pointer */
-
-	lp = (struct hlist_node *)((char *)ep + hp->sh_type.st_link_offset);
-	hhp = sa_hash_bucket(hp, key);
-	hlist_add_head_rcu(lp, hhp);
-	hp->sh_entries++;
-}
-
-/*
- * Iterate through all hash entries.
- * For debugging.  This can be slow.
- */
-void
-sa_hash_iterate(struct sa_hash *hp,
-		void (*callback) (void *ep, void *arg), void *arg)
-{
-	struct hlist_head *hhp;
-	struct hlist_node *np;
-	struct sa_hash_elem *ep;
-	void *entry;
-	int count = 0;
-
-	for (hhp = hp->sh_table; hhp < &hp->sh_table[hp->sh_mask + 1]; hhp++) {
-		hlist_for_each_entry_rcu(ep, np, hhp, elem_node) {
-			entry = (void *)((char *)ep -
-					 hp->sh_type.st_link_offset);
-			(*callback) (entry, arg);
-			count++;
-		}
-	}
-	if (count != hp->sh_entries)
-		OFC_DBG("sh_entries %d != count %d", hp->sh_entries, count);
-}

