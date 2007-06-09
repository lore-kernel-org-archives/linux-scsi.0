From: michaelc@cs.wisc.edu
Subject: [PATCH 6/7] scsi-hw-handler: rm dm-hw-handler code
Date: Sat, 09 Jun 2007 14:08:03 -0500
Message-ID: <118141608864-git-send-email-michaelc@cs.wisc.edu>
References: <11814160842916-git-send-email-michaelc@cs.wisc.edu>
	<11814160853812-git-send-email-michaelc@cs.wisc.edu>
	<1181416085774-git-send-email-michaelc@cs.wisc.edu>
	<11814160863051-git-send-email-michaelc@cs.wisc.edu>
	<11814160871580-git-send-email-michaelc@cs.wisc.edu>
	<11814160881707-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu,
	device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11814160881707-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

dm-hw-handler is no longer used.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/Makefile        |    2 
 drivers/md/dm-hw-handler.c |  215 --------------------------------------------
 drivers/md/dm-hw-handler.h |   62 -------------
 3 files changed, 1 insertions(+), 278 deletions(-)

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 3875408..d2ccc48 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -4,7 +4,7 @@ #
 
 dm-mod-objs	:= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 		   dm-ioctl.o dm-io.o kcopyd.o
-dm-multipath-objs := dm-hw-handler.o dm-path-selector.o dm-mpath.o
+dm-multipath-objs := dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception-store.o
 dm-mirror-objs	:= dm-log.o dm-raid1.o
 md-mod-objs     := md.o bitmap.o
diff --git a/drivers/md/dm-hw-handler.c b/drivers/md/dm-hw-handler.c
deleted file mode 100644
index baafaab..0000000
--- a/drivers/md/dm-hw-handler.c
+++ /dev/null
@@ -1,215 +0,0 @@
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
-	struct hwh_internal *hwhi = kmalloc(sizeof(*hwhi), GFP_KERNEL);
-
-	if (hwhi) {
-		memset(hwhi, 0, sizeof(*hwhi));
-		hwhi->hwht = *hwht;
-	}
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
diff --git a/drivers/md/dm-hw-handler.h b/drivers/md/dm-hw-handler.h
deleted file mode 100644
index e0832e6..0000000
--- a/drivers/md/dm-hw-handler.h
+++ /dev/null
@@ -1,62 +0,0 @@
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
-
-#endif
-- 
1.4.1.1
