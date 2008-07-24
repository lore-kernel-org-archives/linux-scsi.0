From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 04/14] osd_ktests: Add basic OSD tests
Date: Thu, 24 Jul 2008 20:49:51 +0300
Message-ID: <4888C0BF.3060107@panasas.com>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14405 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751117AbYGXRux (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 13:50:53 -0400
In-Reply-To: <4888BC3B.1050406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@i>


Currently testing what is implemented in the osd_initiator library. That is -
format, create/remove partition, create/remove object, read and write to
objects.

This test passes against the IBM-OSD-SIM OSDv1 target.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/Makefile     |    2 +-
 drivers/scsi/osd/osd_ktests.c |  332 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/osd/osd_uld.c    |    3 +-
 3 files changed, 334 insertions(+), 3 deletions(-)
 create mode 100644 drivers/scsi/osd/osd_ktests.c

diff --git a/drivers/scsi/osd/Makefile b/drivers/scsi/osd/Makefile
index f89135d..9edafc4 100755
--- a/drivers/scsi/osd/Makefile
+++ b/drivers/scsi/osd/Makefile
@@ -26,7 +26,7 @@ obj-$(CONFIG_SCSI_OSD_INITIATOR) += libosd.o
 ifeq ($(in_tree),0)
 CONFIG_SCSI_OSD_ULD=m
 endif
-osd-objs := osd_uld.o
+osd-objs := osd_uld.o osd_ktests.o
 obj-$(CONFIG_SCSI_OSD_ULD) += osd.o
 
 # Everything beyond this point is used to call the kernel Makefile in case of
diff --git a/drivers/scsi/osd/osd_ktests.c b/drivers/scsi/osd/osd_ktests.c
new file mode 100644
index 0000000..98dd67d
--- /dev/null
+++ b/drivers/scsi/osd/osd_ktests.c
@@ -0,0 +1,332 @@
+/*
+ * osd_ktests.c - An osd_initiator library in-kernel test suite
+ *              called by the osd_uld module
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
+ *
+ */
+#include <scsi/osd_initiator.h>
+#include <scsi/osd_sec.h>
+#include "osd_debug.h"
+
+#include <linux/vmalloc.h>
+#include <scsi/scsi_device.h>
+
+enum {
+	K = 1024,
+	M = 1024 * K,
+	G = 1024 * M,
+};
+
+const u64 format_total_capacity = 128 * M;
+const osd_id first_par_id = 0x17171717L;
+const osd_id first_obj_id = 0x18181818L;
+const unsigned BUFF_SIZE = PAGE_SIZE;
+
+const int num_partitions = 1;
+const int num_objects = 2; /* per partition */
+
+int test_exec(struct osd_request *or, void *caps, const struct osd_obj_id *obj)
+{
+	int ret;
+
+	osd_sec_init_nosec_doall_caps(caps, obj, false, true);
+	ret = osd_finalize_request(or, 0, caps, NULL);
+	if (ret)
+		return ret;
+
+	ret = osd_execute_request(or);
+	/* osd_req_decode_sense(or, ret); */
+	return ret;
+}
+
+#define KTEST_START_REQ(osd_dev, or) do { \
+	or = osd_start_request(osd_dev, GFP_KERNEL); \
+	if (!or) { \
+		OSD_ERR("Error @%s:%d: osd_start_request", __func__,\
+			__LINE__); \
+		return -ENOMEM; \
+	} \
+} while (0)
+
+#define KTEST_EXEC_END(or, obj, g_caps, msg) do { \
+	ret = test_exec(or, g_caps, obj); \
+	osd_end_request(or); \
+	if (ret) { \
+		OSD_ERR("Error executing "msg" => %d\n", ret); \
+		return ret; \
+	} \
+	OSD_DEBUG(msg "\n"); \
+} while (0)
+
+int ktest_format(struct osd_dev *osd_dev)
+{
+	struct osd_request *or;
+	u8 g_caps[OSD_CAP_LEN];
+	int ret;
+
+	KTEST_START_REQ(osd_dev, or);
+	osd_req_format(or, format_total_capacity);
+	KTEST_EXEC_END(or, &osd_root_object, g_caps, "format");
+	return 0;
+}
+
+int ktest_creat_par(struct osd_dev *osd_dev)
+{
+	struct osd_request *or;
+	u8 g_caps[OSD_CAP_LEN];
+	int ret;
+	int p;
+
+	for (p = 0; p < num_partitions; p++) {
+		struct osd_obj_id par = {
+			.partition = first_par_id + p,
+			.id = 0
+		};
+
+		KTEST_START_REQ(osd_dev, or);
+		osd_req_create_partition(or, par.partition);
+		KTEST_EXEC_END(or, &par, g_caps, "create_partition");
+	}
+
+	return 0;
+}
+
+int ktest_creat_obj(struct osd_dev *osd_dev)
+{
+	struct osd_request *or;
+	u8 g_caps[OSD_CAP_LEN];
+	int ret;
+	int p, o;
+
+	for (p = 0; p < num_partitions; p++)
+		for (o = 0; o < num_objects; o++) {
+			struct osd_obj_id obj = {
+				.partition = first_par_id + p,
+				.id = first_obj_id + o
+			};
+
+			KTEST_START_REQ(osd_dev, or);
+			osd_req_create_object(or, &obj);
+			KTEST_EXEC_END(or, &obj, g_caps, "create_object");
+		}
+
+	return 0;
+}
+
+int ktest_write_obj(struct osd_dev *osd_dev, void *write_buff)
+{
+	struct request_queue *req_q = osd_dev->scsi_dev->request_queue;
+	struct osd_request *or;
+	u8 g_caps[OSD_CAP_LEN];
+	int ret;
+	int p, o; u64 offset = 0;
+	struct bio *write_bio;
+
+	for (p = 0; p < num_partitions; p++)
+		for (o = 0; o < num_objects; o++) {
+			struct osd_obj_id obj = {
+				.partition = first_par_id + p,
+				.id = first_obj_id + o
+			};
+
+			KTEST_START_REQ(osd_dev, or);
+			write_bio = bio_map_kern(req_q, write_buff,
+						 BUFF_SIZE, GFP_KERNEL);
+			if (!write_bio) {
+				OSD_ERR("!!! Failed to allocate write BIO\n");
+				return -ENOMEM;
+			}
+
+			osd_req_write(or, &obj, write_bio, offset);
+			KTEST_EXEC_END(or, &obj, g_caps, "write");
+			write_bio = NULL; /* released by scsi_midlayer */
+			offset += BUFF_SIZE;
+		}
+
+	return 0;
+}
+
+int ktest_read_obj(struct osd_dev *osd_dev, void *write_buff, void *read_buff)
+{
+	struct request_queue *req_q = osd_dev->scsi_dev->request_queue;
+	struct osd_request *or;
+	u8 g_caps[OSD_CAP_LEN];
+	int ret;
+	int p, o; u64 offset = 0;
+	struct bio *read_bio;
+
+	for (p = 0; p < num_partitions; p++)
+		for (o = 0; o < num_objects; o++) {
+			struct osd_obj_id obj = {
+				.partition = first_par_id + p,
+				.id = first_obj_id + o
+			};
+
+			KTEST_START_REQ(osd_dev, or);
+			read_bio = bio_map_kern(req_q, read_buff,
+						BUFF_SIZE, GFP_KERNEL);
+			if (!read_bio) {
+				OSD_ERR("!!! Failed to allocate read BIO\n");
+				return -ENOMEM;
+			}
+
+			osd_req_read(or, &obj, read_bio, offset);
+			KTEST_EXEC_END(or, &obj, g_caps, "read");
+			read_bio = NULL;
+			if (memcmp(read_buff, write_buff, BUFF_SIZE))
+				OSD_ERR("!!! Read did not compare");
+			offset += BUFF_SIZE;
+		}
+
+	return 0;
+}
+
+int ktest_remove_obj(struct osd_dev *osd_dev)
+{
+	struct osd_request *or;
+	u8 g_caps[OSD_CAP_LEN];
+	int ret;
+	int p, o;
+
+	for (p = 0; p < num_partitions; p++)
+		for (o = 0; o < num_objects; o++) {
+			struct osd_obj_id obj = {
+				.partition = first_par_id + p,
+				.id = first_obj_id + o
+			};
+
+			KTEST_START_REQ(osd_dev, or);
+			osd_req_remove_object(or, &obj);
+			KTEST_EXEC_END(or, &obj, g_caps, "remove_object");
+		}
+
+	return 0;
+}
+
+int ktest_remove_par(struct osd_dev *osd_dev)
+{
+	struct osd_request *or;
+	u8 g_caps[OSD_CAP_LEN];
+	int ret;
+	int p;
+
+	for (p = 0; p < num_partitions; p++) {
+		struct osd_obj_id par = {
+			.partition = first_par_id + p,
+			.id = 0
+		};
+
+		KTEST_START_REQ(osd_dev, or);
+		osd_req_remove_partition(or, par.partition);
+		KTEST_EXEC_END(or, &par, g_caps, "remove_partition");
+	}
+
+	return 0;
+}
+
+int do_test_17(struct scsi_device *scsi_dev)
+{
+	struct osd_dev osd_dev;
+	void *write_buff = NULL;
+	void *read_buff = NULL;
+	int ret = -ENOMEM, i;
+
+	osd_dev_init(&osd_dev, scsi_dev);
+
+/* osd_format */
+	if (ktest_format(&osd_dev))
+		goto dev_fini;
+
+/* create some partition */
+	if (ktest_creat_par(&osd_dev))
+		goto dev_fini;
+/* list partition see if they're all there */
+/* create some objects on some partitions */
+	if (ktest_creat_obj(&osd_dev))
+		goto dev_fini;
+
+/* Alloc some buffers and bios */
+/*	write_buff = kmalloc(BUFF_SIZE, or->alloc_flags);*/
+/*	read_buff = kmalloc(BUFF_SIZE, or->alloc_flags);*/
+	write_buff = (void *)__get_free_page(GFP_KERNEL);
+	read_buff = (void *)__get_free_page(GFP_KERNEL);
+	if (!write_buff || !read_buff) {
+		OSD_ERR("!!! Failed to allocate memory for test\n");
+		goto dev_fini;
+	}
+	for (i = 0; i < BUFF_SIZE / 4; i++)
+		((int *)write_buff)[i] = i;
+	OSD_DEBUG("allocate buffers\n");
+
+/* write to objects */
+	ret = ktest_write_obj(&osd_dev, write_buff);
+	if (ret)
+		goto dev_fini;
+
+/* read from objects and compare to write */
+	ret = ktest_read_obj(&osd_dev, write_buff, read_buff);
+	if (ret)
+		goto dev_fini;
+
+/* List all objects */
+
+/* Write with get_attr */
+/* Write with set_attr */
+/* Write with set_attr + get_attr */
+/* Read with set_attr */
+/* Read with get_attr */
+/* Read with get_attr + set_attr */
+/* remove objects */
+	ret = ktest_remove_obj(&osd_dev);
+	if (ret)
+		goto dev_fini;
+
+/* remove partitions */
+	ret = ktest_remove_par(&osd_dev);
+	if (ret)
+		goto dev_fini;
+
+/* good and done */
+	OSD_INFO("test17: All good and done\n");
+dev_fini:
+	if (read_buff)
+		free_page((ulong)read_buff);
+	if (write_buff)
+		free_page((ulong)write_buff);
+
+	osd_dev_fini(&osd_dev);
+	return ret;
+}
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 37797d4..d7a0ca1 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -114,8 +114,7 @@ static long osd_uld_ioctl(struct file *file, unsigned int cmd,
 	switch (cmd) {
 	case OSD_TEST_ALL:
 		OSD_DEBUG("Kernel test %d: osd_dev=%p\n", cmd, osd_dev);
-		/* TODO: Add some tests code here */
-		ret = 0;
+		ret = do_test_17(osd_dev->scsi_dev);
 		break;
 	default:
 		OSD_ERR("Unknown osd_uld_ioctl %d\n", cmd);
-- 
1.5.6.rc1.5.gadf6


