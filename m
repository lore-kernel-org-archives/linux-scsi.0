From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 11/14] osd_ktests: OSDv2 auto detection
Date: Thu, 24 Jul 2008 20:59:33 +0300
Message-ID: <4888C305.9070005@panasas.com>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4144 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752464AbYGXSAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 14:00:18 -0400
In-Reply-To: <4888BC3B.1050406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-osd development <osd-dev@open-osd.org>
Cc: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


Auto detect an OSDv2 or OSDv1 target at run time. Note how none of the OSD
calls change, apart from the added detection code.

This test passes against both the IBM-OSD-SIM OSD1 target as well as Pete's
OSC's OSD2 target.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/osd_ktests.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/osd/osd_ktests.c b/drivers/scsi/osd/osd_ktests.c
index 3186fc8..45a0dcc 100644
--- a/drivers/scsi/osd/osd_ktests.c
+++ b/drivers/scsi/osd/osd_ktests.c
@@ -101,6 +101,11 @@ int test_exec(struct osd_request *or, void *caps, const struct osd_obj_id *obj)
 
 #define ATTR_DEF_RI(id, len) ATTR_DEF(OSD_APAGE_ROOT_INFORMATION, id, len)
 
+static char *osd_ver_desc(struct osd_request *or)
+{
+	return osd_req_is_ver1(or) ? "OSD1" : "OSD2";
+}
+
 int ktest_read_system_info(struct osd_dev *osd_dev)
 {
 	struct osd_request *or;
@@ -131,14 +136,14 @@ int ktest_read_system_info(struct osd_dev *osd_dev)
 
 	ret = test_exec(or, g_caps, &osd_root_object);
 	if (ret) {
-		OSD_ERR("Failed to detect %s => %d\n", "OSD1", ret);
+		OSD_ERR("Failed to detect %s => %d\n", osd_ver_desc(or), ret);
 		goto out;
 	}
 
 	osd_req_decode_get_attr_list(or, get_attrs, &nelem, &iter);
 
 	OSD_INFO("Detected %s device\n",
-		"OSD1");
+		osd_ver_desc(or));
 
 	pFirst = get_attrs[a++].val_ptr;
 	OSD_INFO("OSD_ATTR_RI_VENDOR_IDENTIFICATION [%s]\n",
@@ -459,8 +464,13 @@ int do_test_17(struct scsi_device *scsi_dev)
 
 	osd_dev_init(&osd_dev, scsi_dev);
 
-	if (ktest_read_system_info(&osd_dev))
-		goto dev_fini;
+	/* Auto-detect the osd version */
+	if (ktest_read_system_info(&osd_dev)) {
+		osd_dev_set_ver(&osd_dev, OSD_VER1);
+		OSD_DEBUG("converting to OSD1\n");
+		if (ktest_read_system_info(&osd_dev))
+			goto dev_fini;
+	}
 
 /* osd_format */
 	if (ktest_format(&osd_dev))
-- 
1.5.6.rc1.5.gadf6


