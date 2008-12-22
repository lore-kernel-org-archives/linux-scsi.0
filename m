From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 14/18] libosd: OSDv2 auto detection
Date: Mon, 22 Dec 2008 15:09:35 +0200
Message-ID: <1229951375-16103-1-git-send-email-bharrosh@panasas.com>
References: <494F88C0.4070507@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:4653 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753967AbYLVNJk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Dec 2008 08:09:40 -0500
In-Reply-To: <494F88C0.4070507@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-s
Cc: linux-kernel <linux-kernel@vger.kernel.org>

Auto detect an OSDv2 or OSDv1 target at run time. Note how none
of the OSD API calls change. The tests do not know what device
version it is.

This test now passes against both the IBM-OSD-SIM OSD1 target
as well as OSC's OSD2 target.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |  125 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/osd/osd_uld.c       |    5 ++
 include/scsi/osd_initiator.h     |    3 +
 3 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 9d2ec73..977d595 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -41,6 +41,7 @@
 
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
+#include <scsi/osd_attributes.h>
 #include <scsi/scsi_device.h>
 
 #include "osd_debug.h"
@@ -59,6 +60,130 @@ static inline void build_test(void)
 	BUILD_BUG_ON(sizeof(struct osdv1_cdb) != OSDv1_TOTAL_CDB_LEN);
 }
 
+static char *_osd_ver_desc(struct osd_request *or)
+{
+	return osd_req_is_ver1(or) ? "OSD1" : "OSD2";
+}
+
+#define ATTR_DEF_RI(id, len) ATTR_DEF(OSD_APAGE_ROOT_INFORMATION, id, len)
+
+static int _osd_print_system_info(struct osd_dev *od, void *caps)
+{
+	struct osd_request *or;
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
+	or = osd_start_request(od, GFP_KERNEL);
+	if (!or)
+		return -ENOMEM;
+
+	/* get attrs */
+	osd_req_get_attributes(or, &osd_root_object);
+	osd_req_add_get_attr_list(or, get_attrs, ARRAY_SIZE(get_attrs));
+
+	ret = osd_finalize_request(or, 0, caps, NULL);
+	if (ret)
+		goto out;
+
+	ret = osd_execute_request(or);
+	if (ret) {
+		OSD_ERR("Failed to detect %s => %d\n", _osd_ver_desc(or), ret);
+		goto out;
+	}
+
+	osd_req_decode_get_attr_list(or, get_attrs, &nelem, &iter);
+
+	OSD_INFO("Detected %s device\n",
+		_osd_ver_desc(or));
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
+	OSD_INFO("OSD_ATTR_RI_OSD_NAME [%s]\n", (char *)pFirst);
+	a++;
+
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_TOTAL_CAPACITY [0x%llx]\n",
+		_LLU(get_unaligned_be64(pFirst)));
+
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_USED_CAPACITY [0x%llx]\n",
+		_LLU(get_unaligned_be64(pFirst)));
+
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_NUMBER_OF_PARTITIONS [%llu]\n",
+		_LLU(get_unaligned_be64(pFirst)));
+
+	/* FIXME: Where are the time utilities */
+	pFirst = get_attrs[a++].val_ptr;
+	OSD_INFO("OSD_ATTR_RI_CLOCK [0x%02x%02x%02x%02x%02x%02x]\n",
+		((char *)pFirst)[0], ((char *)pFirst)[1],
+		((char *)pFirst)[2], ((char *)pFirst)[3],
+		((char *)pFirst)[4], ((char *)pFirst)[5]);
+
+	if (a < nelem) { /* IBM-OSD-SIM bug, Might not have it */
+		int len = get_attrs[a].len;
+		u8 sid_dump[32*4 + 2]; /* 2nibbles+space+ASCII */
+
+		hex_dump_to_buffer(get_attrs[a].val_ptr, len, 32, 1,
+				   sid_dump, sizeof(sid_dump), true);
+		OSD_INFO("OSD_ATTR_RI_OSD_SYSTEM_ID(%d) [%s]\n", len, sid_dump);
+		a++;
+	}
+out:
+	osd_end_request(or);
+	return ret;
+}
+
+int osd_auto_detect_ver(struct osd_dev *od, void *caps)
+{
+	int ret;
+
+	/* Auto-detect the osd version */
+	ret = _osd_print_system_info(od, caps);
+	if (ret) {
+		osd_dev_set_ver(od, OSD_VER1);
+		OSD_DEBUG("converting to OSD1\n");
+		ret = _osd_print_system_info(od, caps);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(osd_auto_detect_ver);
+
 static unsigned _osd_req_cdb_len(struct osd_request *or)
 {
 	return osd_req_is_ver1(or) ? OSDv1_TOTAL_CDB_LEN : OSD_TOTAL_CDB_LEN;
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 5ba7654..fa69e09 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -213,6 +213,7 @@ EXPORT_SYMBOL(osduld_put_device);
 static int __detect_osd(struct osd_uld_device *oud)
 {
 	struct scsi_device *scsi_device = oud->od.scsi_device;
+	char caps[OSD_CAP_LEN];
 	int error;
 
 	/* sending a test_unit_ready as first command seems to be needed
@@ -224,6 +225,10 @@ static int __detect_osd(struct osd_uld_device *oud)
 	if (error)
 		OSD_ERR("warning: scsi_test_unit_ready failed\n");
 
+	osd_sec_init_nosec_doall_caps(caps, &osd_root_object, false, true);
+	if (osd_auto_detect_ver(&oud->od, caps))
+		return -ENODEV;
+
 	return 0;
 }
 
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 778a624..8a0fd35 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -62,6 +62,9 @@ void osduld_put_device(struct osd_dev *od);
 void osd_dev_init(struct osd_dev *od, struct scsi_device *scsi_device);
 void osd_dev_fini(struct osd_dev *od);
 
+/* some hi level device operations */
+int osd_auto_detect_ver(struct osd_dev *od, void *caps);    /* GFP_KERNEL */
+
 /* we might want to use function vector in the future */
 static inline void osd_dev_set_ver(struct osd_dev *od, enum osd_std_version v)
 {
-- 
1.6.0.1

