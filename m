From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 7/7] scsi_dh: Remove hardware handler infrastructure from dm
Date: Thu, 17 Apr 2008 15:23:30 -0700
Message-ID: <20080417222330.26477.88935.sendpatchset@chandra-ubuntu>
References: <20080417222245.26477.49142.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55515 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbYDQWXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2008 18:23:13 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3HMPIgI008882
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2008 18:25:18 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3HMND0d292870
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2008 18:23:13 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3HMNC0p031962
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2008 18:23:12 -0400
In-Reply-To: <20080417222245.26477.49142.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, andmike@us.ibm.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dwysocha@redhat.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>

Subject: scsi_dh: Remove hardware handler infrastructure from dm

From: Chandra Seetharaman <sekharan@us.ibm.com>

This patch just removes infrastructure that provide support to add
a hardware handler to dm.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/md/Makefile        |    2 	1 +	1 -	0 !
 drivers/md/dm-hw-handler.c |  213 	0 +	213 -	0 !
 drivers/md/dm-hw-handler.h |   63 	0 +	63 -	0 !
 drivers/md/dm-mpath.h      |    1 	0 +	1 -	0 !
 4 files changed, 1 insertion(+), 278 deletions(-)

Index: linux-2.6.25-rc8-mm2/drivers/md/dm-hw-handler.c
===================================================================
--- linux-2.6.25-rc8-mm2.orig/drivers/md/dm-hw-handler.c
+++ /dev/null
@@ -1,213 +0,0 @@
-/*
- * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
- *
- * This file is released under the GPL.
- *
- * Multipath hardware handler registration.
- */
-
-#include "dm.h"
-#include "dm-hw-handler.h"
-
-#include <linux/slab.h>
-
-struct hwh_internal {
-	struct hw_handler_type hwht;
-
-	struct list_head list;
-	long use;
-};
-
-#define hwht_to_hwhi(__hwht) container_of((__hwht), struct hwh_internal, hwht)
-
-static LIST_HEAD(_hw_handlers);
-static DECLARE_RWSEM(_hwh_lock);
-
-static struct hwh_internal *__find_hw_handler_type(const char *name)
-{
-	struct hwh_internal *hwhi;
-
-	list_for_each_entry(hwhi, &_hw_handlers, list) {
-		if (!strcmp(name, hwhi->hwht.name))
-			return hwhi;
-	}
-
-	return NULL;
-}
-
-static struct hwh_internal *get_hw_handler(const char *name)
-{
-	struct hwh_internal *hwhi;
-
-	down_read(&_hwh_lock);
-	hwhi = __find_hw_handler_type(name);
-	if (hwhi) {
-		if ((hwhi->use == 0) && !try_module_get(hwhi->hwht.module))
-			hwhi = NULL;
-		else
-			hwhi->use++;
-	}
-	up_read(&_hwh_lock);
-
-	return hwhi;
-}
-
-struct hw_handler_type *dm_get_hw_handler(const char *name)
-{
-	struct hwh_internal *hwhi;
-
-	if (!name)
-		return NULL;
-
-	hwhi = get_hw_handler(name);
-	if (!hwhi) {
-		request_module("dm-%s", name);
-		hwhi = get_hw_handler(name);
-	}
-
-	return hwhi ? &hwhi->hwht : NULL;
-}
-
-void dm_put_hw_handler(struct hw_handler_type *hwht)
-{
-	struct hwh_internal *hwhi;
-
-	if (!hwht)
-		return;
-
-	down_read(&_hwh_lock);
-	hwhi = __find_hw_handler_type(hwht->name);
-	if (!hwhi)
-		goto out;
-
-	if (--hwhi->use == 0)
-		module_put(hwhi->hwht.module);
-
-	BUG_ON(hwhi->use < 0);
-
-      out:
-	up_read(&_hwh_lock);
-}
-
-static struct hwh_internal *_alloc_hw_handler(struct hw_handler_type *hwht)
-{
-	struct hwh_internal *hwhi = kzalloc(sizeof(*hwhi), GFP_KERNEL);
-
-	if (hwhi)
-		hwhi->hwht = *hwht;
-
-	return hwhi;
-}
-
-int dm_register_hw_handler(struct hw_handler_type *hwht)
-{
-	int r = 0;
-	struct hwh_internal *hwhi = _alloc_hw_handler(hwht);
-
-	if (!hwhi)
-		return -ENOMEM;
-
-	down_write(&_hwh_lock);
-
-	if (__find_hw_handler_type(hwht->name)) {
-		kfree(hwhi);
-		r = -EEXIST;
-	} else
-		list_add(&hwhi->list, &_hw_handlers);
-
-	up_write(&_hwh_lock);
-
-	return r;
-}
-
-int dm_unregister_hw_handler(struct hw_handler_type *hwht)
-{
-	struct hwh_internal *hwhi;
-
-	down_write(&_hwh_lock);
-
-	hwhi = __find_hw_handler_type(hwht->name);
-	if (!hwhi) {
-		up_write(&_hwh_lock);
-		return -EINVAL;
-	}
-
-	if (hwhi->use) {
-		up_write(&_hwh_lock);
-		return -ETXTBSY;
-	}
-
-	list_del(&hwhi->list);
-
-	up_write(&_hwh_lock);
-
-	kfree(hwhi);
-
-	return 0;
-}
-
-unsigned dm_scsi_err_handler(struct hw_handler *hwh, struct bio *bio)
-{
-#if 0
-	int sense_key, asc, ascq;
-
-	if (bio->bi_error & BIO_SENSE) {
-		/* FIXME: This is just an initial guess. */
-		/* key / asc / ascq */
-		sense_key = (bio->bi_error >> 16) & 0xff;
-		asc = (bio->bi_error >> 8) & 0xff;
-		ascq = bio->bi_error & 0xff;
-
-		switch (sense_key) {
-			/* This block as a whole comes from the device.
-			 * So no point retrying on another path. */
-		case 0x03:	/* Medium error */
-		case 0x05:	/* Illegal request */
-		case 0x07:	/* Data protect */
-		case 0x08:	/* Blank check */
-		case 0x0a:	/* copy aborted */
-		case 0x0c:	/* obsolete - no clue ;-) */
-		case 0x0d:	/* volume overflow */
-		case 0x0e:	/* data miscompare */
-		case 0x0f:	/* reserved - no idea either. */
-			return MP_ERROR_IO;
-
-			/* For these errors it's unclear whether they
-			 * come from the device or the controller.
-			 * So just lets try a different path, and if
-			 * it eventually succeeds, user-space will clear
-			 * the paths again... */
-		case 0x02:	/* Not ready */
-		case 0x04:	/* Hardware error */
-		case 0x09:	/* vendor specific */
-		case 0x0b:	/* Aborted command */
-			return MP_FAIL_PATH;
-
-		case 0x06:	/* Unit attention - might want to decode */
-			if (asc == 0x04 && ascq == 0x01)
-				/* "Unit in the process of
-				 * becoming ready" */
-				return 0;
-			return MP_FAIL_PATH;
-
-			/* FIXME: For Unit Not Ready we may want
-			 * to have a generic pg activation
-			 * feature (START_UNIT). */
-
-			/* Should these two ever end up in the
-			 * error path? I don't think so. */
-		case 0x00:	/* No sense */
-		case 0x01:	/* Recovered error */
-			return 0;
-		}
-	}
-#endif
-
-	/* We got no idea how to decode the other kinds of errors ->
-	 * assume generic error condition. */
-	return MP_FAIL_PATH;
-}
-
-EXPORT_SYMBOL_GPL(dm_register_hw_handler);
-EXPORT_SYMBOL_GPL(dm_unregister_hw_handler);
-EXPORT_SYMBOL_GPL(dm_scsi_err_handler);
Index: linux-2.6.25-rc8-mm2/drivers/md/dm-hw-handler.h
===================================================================
--- linux-2.6.25-rc8-mm2.orig/drivers/md/dm-hw-handler.h
+++ /dev/null
@@ -1,63 +0,0 @@
-/*
- * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
- *
- * This file is released under the GPL.
- *
- * Multipath hardware handler registration.
- */
-
-#ifndef	DM_HW_HANDLER_H
-#define	DM_HW_HANDLER_H
-
-#include <linux/device-mapper.h>
-
-#include "dm-mpath.h"
-
-struct hw_handler_type;
-struct hw_handler {
-	struct hw_handler_type *type;
-	struct mapped_device *md;
-	void *context;
-};
-
-/*
- * Constructs a hardware handler object, takes custom arguments
- */
-/* Information about a hardware handler type */
-struct hw_handler_type {
-	char *name;
-	struct module *module;
-
-	int (*create) (struct hw_handler *handler, unsigned int argc,
-		       char **argv);
-	void (*destroy) (struct hw_handler *hwh);
-
-	void (*pg_init) (struct hw_handler *hwh, unsigned bypassed,
-			 struct dm_path *path);
-	unsigned (*error) (struct hw_handler *hwh, struct bio *bio);
-	int (*status) (struct hw_handler *hwh, status_type_t type,
-		       char *result, unsigned int maxlen);
-};
-
-/* Register a hardware handler */
-int dm_register_hw_handler(struct hw_handler_type *type);
-
-/* Unregister a hardware handler */
-int dm_unregister_hw_handler(struct hw_handler_type *type);
-
-/* Returns a registered hardware handler type */
-struct hw_handler_type *dm_get_hw_handler(const char *name);
-
-/* Releases a hardware handler  */
-void dm_put_hw_handler(struct hw_handler_type *hwht);
-
-/* Default err function */
-unsigned dm_scsi_err_handler(struct hw_handler *hwh, struct bio *bio);
-
-/* Error flags for err and dm_pg_init_complete */
-#define MP_FAIL_PATH 1
-#define MP_BYPASS_PG 2
-#define MP_ERROR_IO  4	/* Don't retry this I/O */
-#define MP_RETRY 8
-
-#endif
Index: linux-2.6.25-rc8-mm2/drivers/md/Makefile
===================================================================
--- linux-2.6.25-rc8-mm2.orig/drivers/md/Makefile
+++ linux-2.6.25-rc8-mm2/drivers/md/Makefile
@@ -4,7 +4,7 @@
 
 dm-mod-objs	:= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 		   dm-ioctl.o dm-io.o dm-kcopyd.o
-dm-multipath-objs := dm-hw-handler.o dm-path-selector.o dm-mpath.o
+dm-multipath-objs := dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception-store.o
 dm-mirror-objs	:= dm-raid1.o
 dm-rdac-objs	:= dm-mpath-rdac.o
Index: linux-2.6.25-rc8-mm2/drivers/md/dm-mpath.h
===================================================================
--- linux-2.6.25-rc8-mm2.orig/drivers/md/dm-mpath.h
+++ linux-2.6.25-rc8-mm2/drivers/md/dm-mpath.h
@@ -16,7 +16,6 @@ struct dm_path {
 	unsigned is_active;	/* Read-only */
 
 	void *pscontext;	/* For path-selector use */
-	void *hwhcontext;	/* For hw-handler use */
 };
 
 /* Callback for hwh_pg_init_fn to use when complete */
