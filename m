From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 09/18] osd_ktests: Test Attribute lists
Date: Tue,  6 Jan 2009 16:20:24 +0200
Message-ID: <1231251624-20284-1-git-send-email-bharrosh@panasas.com>
References: <49636507.8060808@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:18222 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751643AbZAFOU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 09:20:27 -0500
In-Reply-To: <49636507.8060808@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Add tests for setting/getting Attribute lists. All combinations
of read/write with set/get attributes are tested.
(6 possibilities), So all but data integrity request structure
layouts are attempted.

This test passes against the IBM-OSD-SIM OSDv1 target.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/osd_ktests.c |  110 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_ktests.c b/drivers/scsi/osd/osd_ktests.c
index fba4934..d098323 100644
--- a/drivers/scsi/osd/osd_ktests.c
+++ b/drivers/scsi/osd/osd_ktests.c
@@ -43,6 +43,7 @@
 
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
+#include <scsi/osd_attributes.h>
 
 #include "osd_ktests.h"
 #include "osd_debug.h"
@@ -260,6 +261,91 @@ int ktest_remove_par(struct osd_dev *osd_dev)
 	return 0;
 }
 
+int ktest_write_read_attr(struct osd_dev *osd_dev, void *buff,
+	bool doread, bool doset, bool doget)
+{
+	struct request_queue *req_q = osd_dev->scsi_device->request_queue;
+	struct osd_request *or;
+	char g_caps[OSD_CAP_LEN];
+	int ret;
+	struct bio *bio;
+	char *domsg;
+	/* set attrs */
+	static char name[] = "ktest_write_read_attr";
+	__be64 max_len = cpu_to_be64(0x80000000L);
+	struct osd_obj_id obj = {
+		.partition = first_par_id,
+		.id = first_obj_id,
+	};
+	struct osd_attr set_attrs[] = {
+		ATTR_SET(OSD_APAGE_OBJECT_QUOTAS, OSD_ATTR_OQ_MAXIMUM_LENGTH,
+			sizeof(max_len), &max_len),
+		ATTR_SET(OSD_APAGE_OBJECT_INFORMATION, OSD_ATTR_OI_USERNAME,
+			sizeof(name), name),
+	};
+	struct osd_attr get_attrs[] = {
+		ATTR_DEF(OSD_APAGE_OBJECT_INFORMATION,
+			OSD_ATTR_OI_USED_CAPACITY, sizeof(__be64)),
+		ATTR_DEF(OSD_APAGE_OBJECT_INFORMATION,
+			OSD_ATTR_OI_LOGICAL_LENGTH, sizeof(__be64)),
+	};
+
+	KTEST_START_REQ(osd_dev, or);
+	bio = bio_map_kern(req_q, buff, BUFF_SIZE, GFP_KERNEL);
+	if (!bio) {
+		OSD_ERR("!!! Failed to allocate BIO\n");
+		return -ENOMEM;
+	}
+
+	if (doread) {
+		osd_req_read(or, &obj, bio, 0);
+		domsg = "Read-with-attr";
+	} else {
+		osd_req_write(or, &obj, bio, 0);
+		domsg = "Write-with-attr";
+	}
+
+	if (doset)
+		osd_req_add_set_attr_list(or, set_attrs, 2);
+	if (doget)
+		osd_req_add_get_attr_list(or, get_attrs, 2);
+
+/*	KTEST_EXEC_END(or, &obj, "");*/
+	ret = test_exec(or, g_caps, &obj);
+	if (!ret && doget) {
+		void *iter = NULL, *pFirst, *pSec;
+		int nelem = 2;
+		u64 capacity_len = ~0;
+		u64 logical_len = ~0;
+
+		osd_req_decode_get_attr_list(or, get_attrs, &nelem, &iter);
+
+		/*FIXME: Std does not guaranty order of return attrs */
+		pFirst = get_attrs[0].val_ptr;
+		if (pFirst)
+			capacity_len = get_unaligned_be64(pFirst);
+		else
+			OSD_ERR("failed to read capacity_used\n");
+		pSec = get_attrs[1].val_ptr;
+		if (pSec)
+			logical_len = get_unaligned_be64(pSec);
+		else
+			OSD_ERR("failed to read logical_length\n");
+		OSD_INFO("%s capacity=%llu len=%llu\n",
+			domsg, _LLU(capacity_len), _LLU(logical_len));
+	}
+
+	osd_end_request(or);
+	if (ret) {
+		OSD_ERR("!!! Error executing %s => %d doset=%d doget=%d\n",
+			domsg, ret, doset, doget);
+		return ret;
+	}
+	OSD_DEBUG("%s\n", domsg);
+
+	return 0;
+}
+
 int do_test_17(struct osd_dev *od)
 {
 	void *write_buff = NULL;
@@ -304,11 +390,35 @@ int do_test_17(struct osd_dev *od)
 /* List all objects */
 
 /* Write with get_attr */
+	ret = ktest_write_read_attr(od, write_buff, false, false, true);
+	if (ret)
+		goto dev_fini;
+
 /* Write with set_attr */
+	ret = ktest_write_read_attr(od, write_buff, false, true, false);
+	if (ret)
+		goto dev_fini;
+
 /* Write with set_attr + get_attr */
+	ret = ktest_write_read_attr(od, write_buff, false, true, true);
+	if (ret)
+		goto dev_fini;
+
 /* Read with set_attr */
+	ret = ktest_write_read_attr(od, write_buff, true, true, false);
+	if (ret)
+		goto dev_fini;
+
 /* Read with get_attr */
+	ret = ktest_write_read_attr(od, write_buff, true, false, true);
+	if (ret)
+		goto dev_fini;
+
 /* Read with get_attr + set_attr */
+	ret = ktest_write_read_attr(od, write_buff, true, true, true);
+	if (ret)
+		goto dev_fini;
+
 /* remove objects */
 	ret = ktest_remove_obj(od);
 	if (ret)
-- 
1.6.0.1

