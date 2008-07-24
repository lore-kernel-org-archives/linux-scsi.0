From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 06/14] osd_ktests: Test Attribute lists
Date: Thu, 24 Jul 2008 20:53:15 +0300
Message-ID: <4888C18B.1080701@panasas.com>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11349 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752126AbYGXRyC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 13:54:02 -0400
In-Reply-To: <4888BC3B.1050406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-osd development <osd-dev@open-osd.org>
Cc: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


Add tests for setting/getting Attribute lists. All combinations of read/write
with set/get attributes are tested. (6 possibilities), So all but data integrity
request structure layouts are attempted.

This test passes against the IBM-OSD-SIM OSDv1 target.
(Except retrival of SYSTEM_ID attribute, which is a bug of the IBM target)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/osd_ktests.c |  220 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 220 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_ktests.c b/drivers/scsi/osd/osd_ktests.c
index 98dd67d..3186fc8 100644
--- a/drivers/scsi/osd/osd_ktests.c
+++ b/drivers/scsi/osd/osd_ktests.c
@@ -39,8 +39,11 @@
  */
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
+#include "scsi/osd_attributes.h"
+
 #include "osd_debug.h"
 
+#include <asm/unaligned.h>
 #include <linux/vmalloc.h>
 #include <scsi/scsi_device.h>
 
@@ -91,6 +94,111 @@ int test_exec(struct osd_request *or, void *caps, const struct osd_obj_id *obj)
 	OSD_DEBUG(msg "\n"); \
 } while (0)
 
+#define ATTR_SDEF(pg, id, l, ptr) \
+	{ .page = pg, .attr_id = id, .len = l, .val_ptr = ptr }
+
+#define ATTR_DEF(pg, id, l) ATTR_SDEF(pg, id, l, NULL)
+
+#define ATTR_DEF_RI(id, len) ATTR_DEF(OSD_APAGE_ROOT_INFORMATION, id, len)
+
+int ktest_read_system_info(struct osd_dev *osd_dev)
+{
+	struct osd_request *or;
+	char g_caps[OSD_CAP_LEN];
+	struct osd_attr get_attrs[] = {
+		ATTR_DEF_RI(OSD_ATTR_RI_VENDOR_IDENTIFICATION, 8),
+		ATTR_DEF_RI(OSD_ATTR_RI_PRODUCT_IDENTIFICATION, 16),
+		ATTR_DEF_RI(OSD_ATTR_RI_PRODUCT_MODEL, 32),
+		ATTR_DEF_RI(OSD_ATTR_RI_PRODUCT_REVISION_LEVEL, 4),
+		ATTR_DEF_RI(OSD_ATTR_RI_PRODUCT_SERIAL_NUMBER, 64 /*variable*/),
+		ATTR_DEF_RI(OSD_ATTR_RI_OSD_NAME, 64 /*variable*/),
+		ATTR_DEF_RI(OSD_ATTR_RI_TOTAL_CAPACITY, 8),
+		ATTR_DEF_RI(OSD_ATTR_RI_USED_CAPACITY, 8),
+		ATTR_DEF_RI(OSD_ATTR_RI_NUMBER_OF_PARTITIONS, 8),
+		ATTR_DEF_RI(OSD_ATTR_RI_CLOCK, 6),
+		/* IBM-OSD-SIM Has a bug with this one put it last */
+		ATTR_DEF_RI(OSD_ATTR_RI_OSD_SYSTEM_ID, 20),
+	};
+	void *iter = NULL, *pFirst;
+	int nelem = ARRAY_SIZE(get_attrs), a = 0;
+	int ret;
+
+	KTEST_START_REQ(osd_dev, or);
+
+	/* get attrs */
+	osd_req_get_attributes(or, &osd_root_object);
+	osd_req_add_get_attr_list(or, get_attrs, ARRAY_SIZE(get_attrs));
+
+	ret = test_exec(or, g_caps, &osd_root_object);
+	if (ret) {
+		OSD_ERR("Failed to detect %s => %d\n", "OSD1", ret);
+		goto out;
+	}
+
+	osd_req_decode_get_attr_list(or, get_attrs, &nelem, &iter);
+
+	OSD_INFO("Detected %s device\n",
+		"OSD1");
+
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_VENDOR_IDENTIFICATION [%s]\n",
+		(char *)pFirst);
+
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_PRODUCT_IDENTIFICATION [%s]\n",
+		(char *)pFirst);
+
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_PRODUCT_MODEL [%s]\n",
+		(char *)pFirst);
+
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_PRODUCT_REVISION_LEVEL [%u]\n",
+		get_unaligned_be32(pFirst));
+
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_PRODUCT_SERIAL_NUMBER [%s]\n",
+		(char *)pFirst);
+
+	pFirst = get_attrs[a].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_OSD_NAME(%d) [%x,%x,%x,%x,%x,%x,%x,%x]\n",
+		get_attrs[a].len,
+		((char *)pFirst)[0], ((char *)pFirst)[1],
+		((char *)pFirst)[2], ((char *)pFirst)[3],
+		((char *)pFirst)[4], ((char *)pFirst)[5],
+		((char *)pFirst)[6], ((char *)pFirst)[7]
+	);
+	a++;
+
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_TOTAL_CAPACITY [0x%llx]\n",
+		get_unaligned_be64(pFirst));
+
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_USED_CAPACITY [0x%llx]\n",
+		get_unaligned_be64(pFirst));
+
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_NUMBER_OF_PARTITIONS [%lld]\n",
+		get_unaligned_be64(pFirst));
+
+	/* FIXME: Where are the time utilities */
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_CLOCK [HEX%x%x%x%x%x%x]\n",
+		((char *)pFirst)[0], ((char *)pFirst)[1],
+		((char *)pFirst)[2], ((char *)pFirst)[3],
+		((char *)pFirst)[4], ((char *)pFirst)[5]);
+
+	if (a < nelem) { /* Might not have it */
+		pFirst = get_attrs[a++].val_ptr;
+		OSD_INFO("OSD_ATTR_RI_OSD_SYSTEM_ID [%s]\n",
+			(char *)pFirst);
+	}
+out:
+	osd_end_request(or);
+	return ret;
+}
+
 int ktest_format(struct osd_dev *osd_dev)
 {
 	struct osd_request *or;
@@ -257,6 +365,91 @@ int ktest_remove_par(struct osd_dev *osd_dev)
 	return 0;
 }
 
+int ktest_write_read_attr(struct osd_dev *osd_dev, void *buff,
+	bool doread, bool doset, bool doget)
+{
+	struct request_queue *req_q = osd_dev->scsi_dev->request_queue;
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
+		ATTR_SDEF(OSD_APAGE_OBJECT_QUOTAS, OSD_ATTR_OQ_MAXIMUM_LENGTH,
+			sizeof(max_len), &max_len),
+		ATTR_SDEF(OSD_APAGE_OBJECT_INFORMATION, OSD_ATTR_OI_USERNAME,
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
+			domsg, capacity_len, logical_len);
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
 int do_test_17(struct scsi_device *scsi_dev)
 {
 	struct osd_dev osd_dev;
@@ -266,6 +459,9 @@ int do_test_17(struct scsi_device *scsi_dev)
 
 	osd_dev_init(&osd_dev, scsi_dev);
 
+	if (ktest_read_system_info(&osd_dev))
+		goto dev_fini;
+
 /* osd_format */
 	if (ktest_format(&osd_dev))
 		goto dev_fini;
@@ -304,11 +500,35 @@ int do_test_17(struct scsi_device *scsi_dev)
 /* List all objects */
 
 /* Write with get_attr */
+	ret = ktest_write_read_attr(&osd_dev, write_buff, false, false, true);
+	if (ret)
+		goto dev_fini;
+
 /* Write with set_attr */
+	ret = ktest_write_read_attr(&osd_dev, write_buff, false, true, false);
+	if (ret)
+		goto dev_fini;
+
 /* Write with set_attr + get_attr */
+	ret = ktest_write_read_attr(&osd_dev, write_buff, false, true, true);
+	if (ret)
+		goto dev_fini;
+
 /* Read with set_attr */
+	ret = ktest_write_read_attr(&osd_dev, write_buff, true, true, false);
+	if (ret)
+		goto dev_fini;
+
 /* Read with get_attr */
+	ret = ktest_write_read_attr(&osd_dev, write_buff, true, false, true);
+	if (ret)
+		goto dev_fini;
+
 /* Read with get_attr + set_attr */
+	ret = ktest_write_read_attr(&osd_dev, write_buff, true, true, true);
+	if (ret)
+		goto dev_fini;
+
 /* remove objects */
 	ret = ktest_remove_obj(&osd_dev);
 	if (ret)
-- 
1.5.6.rc1.5.gadf6


