From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 04/18] libosd: OSDv1 preliminary implementation
Date: Tue,  6 Jan 2009 16:13:22 +0200
Message-ID: <1231251202-26885-1-git-send-email-bharrosh@panasas.com>
References: <49636507.8060808@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:26817 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751885AbZAFON0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 09:13:26 -0500
In-Reply-To: <49636507.8060808@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Implementation of the most basic OSD functionality and
infrastructure. Mainly Format, Create/Remove Partition,
Create/Remove Object, and read/write.

- Add Makefile and Kbuild to compile libosd.ko
- osd_initiator.c Implementation file for osd_initiator.h
  and osd_sec.h APIs
- osd_debug.h - Some kprintf macro definitions

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/Kbuild          |   32 +++
 drivers/scsi/osd/Makefile        |   37 +++
 drivers/scsi/osd/osd_debug.h     |   30 +++
 drivers/scsi/osd/osd_initiator.c |  448 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 547 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/osd/Kbuild
 create mode 100755 drivers/scsi/osd/Makefile
 create mode 100644 drivers/scsi/osd/osd_debug.h
 create mode 100644 drivers/scsi/osd/osd_initiator.c

diff --git a/drivers/scsi/osd/Kbuild b/drivers/scsi/osd/Kbuild
new file mode 100644
index 0000000..5672842
--- /dev/null
+++ b/drivers/scsi/osd/Kbuild
@@ -0,0 +1,32 @@
+#
+# Kbuild for the OSD modules
+#
+# Copyright (C) 2008 Panasas Inc.  All rights reserved.
+#
+# Authors:
+#   Boaz Harrosh <bharrosh@panasas.com>
+#   Benny Halevy <bhalevy@panasas.com>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2
+#
+
+ifneq ($(OSD_INC),)
+# we are built out-of-tree Kconfigure everything as on
+
+CONFIG_SCSI_OSD_INITIATOR=m
+ccflags-y += -DCONFIG_SCSI_OSD_INITIATOR -DCONFIG_SCSI_OSD_INITIATOR_MODULE
+
+# Uncomment to turn debug on
+# ccflags-y += -DCONFIG_SCSI_OSD_DEBUG
+
+# if we are built out-of-tree and the hosting kernel has OSD headers
+# then "ccflags-y +=" will not pick the out-off-tree headers. Only by doing
+# this it will work. This might break in future kernels
+KBUILD_CPPFLAGS := -I$(OSD_INC) $(KBUILD_CPPFLAGS)
+
+endif
+
+# libosd.ko - osd-initiator library
+libosd-y := osd_initiator.o
+obj-$(CONFIG_SCSI_OSD_INITIATOR) += libosd.o
diff --git a/drivers/scsi/osd/Makefile b/drivers/scsi/osd/Makefile
new file mode 100755
index 0000000..d905344
--- /dev/null
+++ b/drivers/scsi/osd/Makefile
@@ -0,0 +1,37 @@
+#
+# Makefile for the OSD modules (out of tree)
+#
+# Copyright (C) 2008 Panasas Inc.  All rights reserved.
+#
+# Authors:
+#   Boaz Harrosh <bharrosh@panasas.com>
+#   Benny Halevy <bhalevy@panasas.com>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2
+#
+# This Makefile is used to call the kernel Makefile in case of an out-of-tree
+# build.
+# $KSRC should point to a Kernel source tree otherwise host's default is
+# used. (eg. /lib/modules/`uname -r`/build)
+
+# include path for out-of-tree Headers
+OSD_INC ?= `pwd`/../../../include
+
+# allow users to override these
+# e.g. to compile for a kernel that you aren't currently running
+KSRC ?= /lib/modules/$(shell uname -r)/build
+KBUILD_OUTPUT ?=
+ARCH ?=
+V ?= 0
+
+# this is the basic Kbuild out-of-tree invocation, with the M= option
+KBUILD_BASE = +$(MAKE) -C $(KSRC) M=`pwd` KBUILD_OUTPUT=$(KBUILD_OUTPUT) ARCH=$(ARCH) V=$(V)
+
+all: libosd
+
+libosd: ;
+	$(KBUILD_BASE) OSD_INC=$(OSD_INC) modules
+
+clean:
+	$(KBUILD_BASE) clean
diff --git a/drivers/scsi/osd/osd_debug.h b/drivers/scsi/osd/osd_debug.h
new file mode 100644
index 0000000..579e491
--- /dev/null
+++ b/drivers/scsi/osd/osd_debug.h
@@ -0,0 +1,30 @@
+/*
+ * osd_debug.h - Some kprintf macros
+ *
+ * Copyright (C) 2008 Panasas Inc.  All rights reserved.
+ *
+ * Authors:
+ *   Boaz Harrosh <bharrosh@panasas.com>
+ *   Benny Halevy <bhalevy@panasas.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ *
+ */
+#ifndef __OSD_DEBUG_H__
+#define __OSD_DEBUG_H__
+
+#define OSD_ERR(fmt, a...) printk(KERN_ERR "osd: " fmt, ##a)
+#define OSD_INFO(fmt, a...) printk(KERN_NOTICE "osd: " fmt, ##a)
+
+#ifdef CONFIG_SCSI_OSD_DEBUG
+#define OSD_DEBUG(fmt, a...) \
+	printk(KERN_NOTICE "osd @%s:%d: " fmt, __func__, __LINE__, ##a)
+#else
+#define OSD_DEBUG(fmt, a...) do {} while (0)
+#endif
+
+/* u64 has problems with printk this will cast it to unsigned long long */
+#define _LLU(x) (unsigned long long)(x)
+
+#endif /* ndef __OSD_DEBUG_H__ */
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
new file mode 100644
index 0000000..0e6d906
--- /dev/null
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -0,0 +1,448 @@
+/*
+ * osd_initiator - Main body of the osd initiator library.
+ *
+ * Note: The file does not contain the advanced security functionality which
+ * is only needed by the security_manager's initiators.
+ *
+ * Copyright (C) 2008 Panasas Inc.  All rights reserved.
+ *
+ * Authors:
+ *   Boaz Harrosh <bharrosh@panasas.com>
+ *   Benny Halevy <bhalevy@panasas.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  1. Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *  2. Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *  3. Neither the name of the Panasas company nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
+ * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <scsi/osd_initiator.h>
+#include <scsi/osd_sec.h>
+#include <scsi/scsi_device.h>
+
+#include "osd_debug.h"
+
+enum { OSD_REQ_RETRIES = 1 };
+
+MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
+MODULE_DESCRIPTION("open-osd initiator library libosd.ko");
+MODULE_LICENSE("GPL");
+
+static inline void build_test(void)
+{
+	/* structures were not packed */
+	BUILD_BUG_ON(sizeof(struct osd_capability) != OSD_CAP_LEN);
+	BUILD_BUG_ON(sizeof(struct osdv1_cdb) != OSDv1_TOTAL_CDB_LEN);
+}
+
+static unsigned _osd_req_cdb_len(struct osd_request *or)
+{
+	return OSDv1_TOTAL_CDB_LEN;
+}
+
+void osd_dev_init(struct osd_dev *osdd, struct scsi_device *scsi_device)
+{
+	memset(osdd, 0, sizeof(*osdd));
+	osdd->scsi_device = scsi_device;
+	osdd->def_timeout = BLK_DEFAULT_SG_TIMEOUT;
+	/* TODO: Allocate pools for osd_request attributes ... */
+}
+EXPORT_SYMBOL(osd_dev_init);
+
+void osd_dev_fini(struct osd_dev *osdd)
+{
+	/* TODO: De-allocate pools */
+
+	osdd->scsi_device = NULL;
+}
+EXPORT_SYMBOL(osd_dev_fini);
+
+static struct osd_request *_osd_request_alloc(gfp_t gfp)
+{
+	struct osd_request *or;
+
+	/* TODO: Use mempool with one saved request */
+	or = kzalloc(sizeof(*or), gfp);
+	return or;
+}
+
+static void _osd_request_free(struct osd_request *or)
+{
+	kfree(or);
+}
+
+struct osd_request *osd_start_request(struct osd_dev *dev, gfp_t gfp)
+{
+	struct osd_request *or;
+
+	or = _osd_request_alloc(gfp);
+	if (!or)
+		return NULL;
+
+	or->osd_dev = dev;
+	or->alloc_flags = gfp;
+	or->timeout = dev->def_timeout;
+	or->retries = OSD_REQ_RETRIES;
+
+	return or;
+}
+EXPORT_SYMBOL(osd_start_request);
+
+/*
+ * If osd_finalize_request() was called but the request was not executed through
+ * the block layer, then we must release BIOs.
+ */
+static void _abort_unexecuted_bios(struct request *rq)
+{
+	struct bio *bio;
+
+	while ((bio = rq->bio) != NULL) {
+		rq->bio = bio->bi_next;
+		bio_endio(bio, 0);
+	}
+}
+
+void osd_end_request(struct osd_request *or)
+{
+	struct request *rq = or->request;
+
+	if (rq) {
+		if (rq->next_rq) {
+			_abort_unexecuted_bios(rq->next_rq);
+			blk_put_request(rq->next_rq);
+		}
+
+		_abort_unexecuted_bios(rq);
+		blk_put_request(rq);
+	}
+	_osd_request_free(or);
+}
+EXPORT_SYMBOL(osd_end_request);
+
+int osd_execute_request(struct osd_request *or)
+{
+	return blk_execute_rq(or->request->q, NULL, or->request, 0);
+}
+EXPORT_SYMBOL(osd_execute_request);
+
+static void osd_request_async_done(struct request *req, int error)
+{
+	struct osd_request *or = req->end_io_data;
+
+	or->async_error = error;
+
+	if (error)
+		OSD_DEBUG("osd_request_async_done error recieved %d\n", error);
+
+	if (or->async_done)
+		or->async_done(or, or->async_private);
+	else
+		osd_end_request(or);
+}
+
+int osd_execute_request_async(struct osd_request *or,
+	osd_req_done_fn *done, void *private)
+{
+	or->request->end_io_data = or;
+	or->async_private = private;
+	or->async_done = done;
+
+	blk_execute_rq_nowait(or->request->q, NULL, or->request, 0,
+			      osd_request_async_done);
+	return 0;
+}
+EXPORT_SYMBOL(osd_execute_request_async);
+
+/*
+ * Common to all OSD commands
+ */
+
+static void _osdv1_req_encode_common(struct osd_request *or,
+	__be16 act, const struct osd_obj_id *obj, u64 offset, u64 len)
+{
+	struct osdv1_cdb *ocdb = &or->cdb.v1;
+
+	/*
+	 * For speed, the commands
+	 *	OSD_ACT_PERFORM_SCSI_COMMAND	, V1 0x8F7E, V2 0x8F7C
+	 *	OSD_ACT_SCSI_TASK_MANAGEMENT	, V1 0x8F7F, V2 0x8F7D
+	 * are not supported here. Should pass zero and set after the call
+	 */
+	act &= cpu_to_be16(~0x0080); /* V1 action code */
+
+	OSD_DEBUG("OSDv1 execute opcode 0x%x\n", be16_to_cpu(act));
+
+	ocdb->h.varlen_cdb.opcode = VARIABLE_LENGTH_CMD;
+	ocdb->h.varlen_cdb.additional_cdb_length = OSD_ADDITIONAL_CDB_LENGTH;
+	ocdb->h.varlen_cdb.service_action = act;
+
+	ocdb->h.partition = cpu_to_be64(obj->partition);
+	ocdb->h.object = cpu_to_be64(obj->id);
+	ocdb->h.v1.length = cpu_to_be64(len);
+	ocdb->h.v1.start_address = cpu_to_be64(offset);
+}
+
+static void _osd_req_encode_common(struct osd_request *or,
+	__be16 act, const struct osd_obj_id *obj, u64 offset, u64 len)
+{
+	_osdv1_req_encode_common(or, act, obj, offset, len);
+}
+
+/*
+ * Device commands
+ */
+void osd_req_format(struct osd_request *or, u64 tot_capacity)
+{
+	_osd_req_encode_common(or, OSD_ACT_FORMAT_OSD, &osd_root_object, 0,
+				tot_capacity);
+}
+EXPORT_SYMBOL(osd_req_format);
+
+/*
+ * Partition commands
+ */
+static void _osd_req_encode_partition(struct osd_request *or,
+	__be16 act, osd_id partition)
+{
+	struct osd_obj_id par = {
+		.partition = partition,
+		.id = 0,
+	};
+
+	_osd_req_encode_common(or, act, &par, 0, 0);
+}
+
+void osd_req_create_partition(struct osd_request *or, osd_id partition)
+{
+	_osd_req_encode_partition(or, OSD_ACT_CREATE_PARTITION, partition);
+}
+EXPORT_SYMBOL(osd_req_create_partition);
+
+void osd_req_remove_partition(struct osd_request *or, osd_id partition)
+{
+	_osd_req_encode_partition(or, OSD_ACT_REMOVE_PARTITION, partition);
+}
+EXPORT_SYMBOL(osd_req_remove_partition);
+
+/*
+ * Object commands
+ */
+void osd_req_create_object(struct osd_request *or, struct osd_obj_id *obj)
+{
+	_osd_req_encode_common(or, OSD_ACT_CREATE, obj, 0, 0);
+}
+EXPORT_SYMBOL(osd_req_create_object);
+
+void osd_req_remove_object(struct osd_request *or, struct osd_obj_id *obj)
+{
+	_osd_req_encode_common(or, OSD_ACT_REMOVE, obj, 0, 0);
+}
+EXPORT_SYMBOL(osd_req_remove_object);
+
+void osd_req_write(struct osd_request *or,
+	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
+{
+	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, bio->bi_size);
+	WARN_ON(or->out.bio || or->out.total_bytes);
+	bio->bi_rw |= (1 << BIO_RW);
+	or->out.bio = bio;
+	or->out.total_bytes = bio->bi_size;
+}
+EXPORT_SYMBOL(osd_req_write);
+
+void osd_req_read(struct osd_request *or,
+	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
+{
+	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, bio->bi_size);
+	WARN_ON(or->in.bio || or->in.total_bytes);
+	bio->bi_rw &= ~(1 << BIO_RW);
+	or->in.bio = bio;
+	or->in.total_bytes = bio->bi_size;
+}
+EXPORT_SYMBOL(osd_req_read);
+
+/*
+ * osd_finalize_request and helpers
+ */
+
+static int _init_blk_request(struct osd_request *or,
+	bool has_in, bool has_out)
+{
+	gfp_t flags = or->alloc_flags;
+	struct scsi_device *scsi_device = or->osd_dev->scsi_device;
+	struct request_queue *q = scsi_device->request_queue;
+	struct request *req;
+	int ret = -ENOMEM;
+
+	req = blk_get_request(q, has_out, flags);
+	if (!req)
+		goto out;
+
+	or->request = req;
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->timeout = or->timeout;
+	req->retries = or->retries;
+	req->sense = or->sense;
+	req->sense_len = 0;
+
+	if (has_out) {
+		or->out.req = req;
+		if (has_in) {
+			/* allocate bidi request */
+			req = blk_get_request(q, READ, flags);
+			if (!req) {
+				OSD_DEBUG("blk_get_request for bidi failed\n");
+				goto out;
+			}
+			req->cmd_type = REQ_TYPE_BLOCK_PC;
+			or->in.req = or->request->next_rq = req;
+		}
+	} else if (has_in)
+		or->in.req = req;
+
+	ret = 0;
+out:
+	OSD_DEBUG("or=%p has_in=%d has_out=%d => %d, %p\n",
+			or, has_in, has_out, ret, or->request);
+	return ret;
+}
+
+int osd_finalize_request(struct osd_request *or,
+	u8 options, const void *cap, const u8 *cap_key)
+{
+	struct osd_cdb_head *cdbh = osd_cdb_head(&or->cdb);
+	bool has_in, has_out;
+	int ret;
+
+	if (options & OSD_REQ_FUA)
+		cdbh->options |= OSD_CDB_FUA;
+
+	if (options & OSD_REQ_DPO)
+		cdbh->options |= OSD_CDB_DPO;
+
+	if (options & OSD_REQ_BYPASS_TIMESTAMPS)
+		cdbh->timestamp_control = OSD_CDB_BYPASS_TIMESTAMPS;
+
+	osd_set_caps(&or->cdb, cap);
+
+	has_in = or->in.bio || or->get_attr.total_bytes;
+	has_out = or->out.bio || or->set_attr.total_bytes ||
+		or->enc_get_attr.total_bytes;
+
+	ret = _init_blk_request(or, has_in, has_out);
+	if (ret) {
+		OSD_DEBUG("_init_blk_request failed\n");
+		return ret;
+	}
+
+	if (or->out.bio) {
+		ret = blk_rq_append_bio(or->request->q, or->out.req,
+					or->out.bio);
+		if (ret) {
+			OSD_DEBUG("blk_rq_append_bio out failed\n");
+			return ret;
+		}
+		OSD_DEBUG("out bytes=%llu (bytes_req=%u)\n",
+			_LLU(or->out.total_bytes), or->out.req->data_len);
+	}
+	if (or->in.bio) {
+		ret = blk_rq_append_bio(or->request->q, or->in.req, or->in.bio);
+		if (ret) {
+			OSD_DEBUG("blk_rq_append_bio in failed\n");
+			return ret;
+		}
+		OSD_DEBUG("in bytes=%llu (bytes_req=%u)\n",
+			_LLU(or->in.total_bytes), or->in.req->data_len);
+	}
+
+	if (!or->attributes_mode)
+		or->attributes_mode = OSD_CDB_GET_SET_ATTR_LISTS;
+	cdbh->command_specific_options |= or->attributes_mode;
+
+	or->request->cmd = or->cdb.buff;
+	or->request->cmd_len = _osd_req_cdb_len(or);
+
+	return 0;
+}
+EXPORT_SYMBOL(osd_finalize_request);
+
+/*
+ * Implementation of osd_sec.h API
+ * TODO: Move to a separate osd_sec.c file at a later stage.
+ */
+
+enum { OSD_SEC_CAP_V1_ALL_CAPS =
+	OSD_SEC_CAP_APPEND | OSD_SEC_CAP_OBJ_MGMT | OSD_SEC_CAP_REMOVE   |
+	OSD_SEC_CAP_CREATE | OSD_SEC_CAP_SET_ATTR | OSD_SEC_CAP_GET_ATTR |
+	OSD_SEC_CAP_WRITE  | OSD_SEC_CAP_READ     | OSD_SEC_CAP_POL_SEC  |
+	OSD_SEC_CAP_GLOBAL | OSD_SEC_CAP_DEV_MGMT
+};
+
+void osd_sec_init_nosec_doall_caps(void *caps,
+	const struct osd_obj_id *obj, bool is_collection, const bool is_v1)
+{
+	struct osd_capability *cap = caps;
+	u8 type;
+	u8 descriptor_type;
+
+	if (likely(obj->id)) {
+		if (unlikely(is_collection)) {
+			type = OSD_SEC_OBJ_COLLECTION;
+			descriptor_type = is_v1 ? OSD_SEC_OBJ_DESC_OBJ :
+						  OSD_SEC_OBJ_DESC_COL;
+		} else {
+			type = OSD_SEC_OBJ_USER;
+			descriptor_type = OSD_SEC_OBJ_DESC_OBJ;
+		}
+		WARN_ON(!obj->partition);
+	} else {
+		type = obj->partition ? OSD_SEC_OBJ_PARTITION :
+					OSD_SEC_OBJ_ROOT;
+		descriptor_type = OSD_SEC_OBJ_DESC_PAR;
+	}
+
+	memset(cap, 0, sizeof(*cap));
+
+	cap->h.format = OSD_SEC_CAP_FORMAT_VER1;
+	cap->h.integrity_algorithm__key_version = 0; /* MAKE_BYTE(0, 0); */
+	cap->h.security_method = OSD_SEC_NOSEC;
+/*	cap->expiration_time;
+	cap->AUDIT[30-10];
+	cap->discriminator[42-30];
+	cap->object_created_time; */
+	cap->h.object_type = type;
+	osd_sec_set_caps(&cap->h, OSD_SEC_CAP_V1_ALL_CAPS);
+	cap->h.object_descriptor_type = descriptor_type;
+	cap->od.obj_desc.policy_access_tag = 0;
+	cap->od.obj_desc.allowed_partition_id = cpu_to_be64(obj->partition);
+	cap->od.obj_desc.allowed_object_id = cpu_to_be64(obj->id);
+}
+EXPORT_SYMBOL(osd_sec_init_nosec_doall_caps);
+
+void osd_set_caps(struct osd_cdb *cdb, const void *caps)
+{
+	memcpy(&cdb->v1.caps, caps, OSDv1_CAP_LEN);
+}
-- 
1.6.0.1

