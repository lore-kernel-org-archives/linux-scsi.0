From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/2] libosd: osd_dev_info: Unique Identification of an OSD
 device
Date: Tue, 30 Jun 2009 20:10:01 +0300
Message-ID: <4A4A46E9.9060804@panasas.com>
References: <4A4A467A.7020600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:21186
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752124AbZF3RJ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2009 13:09:59 -0400
In-Reply-To: <4A4A467A.7020600@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>, open-osd mailing-list <osd-dev@open-osd.org>, pNFS Mailing List <pnfs@linux-nfs.org>, linux-scsi <linux-scsi@vger.kernel.org>


Define an osd_dev_info structure that Uniquely identifies an OSD
device lun on the network. The identification is built from unique
target attributes and is the same for all network/SAN machines.

osduld_info_lookup() - NEW
    New API that will lookup an osd_dev by its osd_dev_info.
    This is used by pNFS-objects for cross network global device
    identification.

osduld_device_info() - NEW
    Given an osd_dev handle returns its associated osd_dev_info.
    This is used by exofs to encode the device information for
    network clients. (Get-device-info). The ULD fetches this
    information at startup and hangs it on each OSD device. (This is
    a fast operation that can be called at any condition)

osd_auto_detect_ver() - REVISED
    Now returns an osd_dev_info structure. Is only called once
    by ULD as before. See added comments for how to use.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   19 ++++++++++----
 drivers/scsi/osd/osd_uld.c       |   50 +++++++++++++++++++++++++++++++++++++-
 include/scsi/osd_initiator.h     |   37 +++++++++++++++++++++++++---
 3 files changed, 95 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 7a117c1..c36697e 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -73,7 +73,8 @@ static const char *_osd_ver_desc(struct osd_request *or)
 
 #define ATTR_DEF_RI(id, len) ATTR_DEF(OSD_APAGE_ROOT_INFORMATION, id, len)
 
-static int _osd_print_system_info(struct osd_dev *od, void *caps)
+static int _osd_print_system_info(struct osd_dev *od,
+	void *caps, struct osd_dev_info *odi)
 {
 	struct osd_request *or;
 	struct osd_attr get_attrs[] = {
@@ -137,8 +138,10 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
 	OSD_INFO("PRODUCT_SERIAL_NUMBER  [%s]\n",
 		(char *)pFirst);
 
-	pFirst = get_attrs[a].val_ptr;
-	OSD_INFO("OSD_NAME               [%s]\n", (char *)pFirst);
+	odi->osdname_len = get_attrs[a].len;
+	odi->osdname = kzalloc(odi->osdname_len + 1, GFP_KERNEL);
+	memcpy(odi->osdname, get_attrs[a].val_ptr, odi->osdname_len);
+	OSD_INFO("OSD_NAME               [%s]\n", odi->osdname);
 	a++;
 
 	pFirst = get_attrs[a++].val_ptr;
@@ -171,6 +174,9 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
 				   sid_dump, sizeof(sid_dump), true);
 		OSD_INFO("OSD_SYSTEM_ID(%d)\n"
 			 "        [%s]\n", len, sid_dump);
+
+		odi->systemid_len = len;
+		memcpy(odi->systemid, get_attrs[a].val_ptr, len);
 		a++;
 	}
 out:
@@ -178,16 +184,17 @@ out:
 	return ret;
 }
 
-int osd_auto_detect_ver(struct osd_dev *od, void *caps)
+int osd_auto_detect_ver(struct osd_dev *od,
+	void *caps, struct osd_dev_info *odi)
 {
 	int ret;
 
 	/* Auto-detect the osd version */
-	ret = _osd_print_system_info(od, caps);
+	ret = _osd_print_system_info(od, caps, odi);
 	if (ret) {
 		osd_dev_set_ver(od, OSD_VER1);
 		OSD_DEBUG("converting to OSD1\n");
-		ret = _osd_print_system_info(od, caps);
+		ret = _osd_print_system_info(od, caps, odi);
 	}
 
 	return ret;
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 0bdef33..77e63f1 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -87,6 +87,7 @@ struct osd_uld_device {
 	struct osd_dev od;
 	struct gendisk *disk;
 	struct device *class_member;
+	struct osd_dev_info odi;
 };
 
 static void __uld_get(struct osd_uld_device *oud);
@@ -216,6 +217,45 @@ free_od:
 }
 EXPORT_SYMBOL(osduld_path_lookup);
 
+static inline bool _the_same_or_null(const u8 *a1, unsigned a1_len,
+				     const u8 *a2, unsigned a2_len)
+{
+	if (a1_len && a2_len && (a1_len != a2_len))
+		return false;
+
+	return !a1_len || !a2_len || (0 == memcmp(a1, a2, a1_len));
+}
+
+struct osd_dev *osduld_info_lookup(const struct osd_dev_info *odi)
+{
+	unsigned i;
+
+	for (i = 0; i < SCSI_OSD_MAX_MINOR; i++) {
+		char dev_str[16];
+		struct osd_uld_device *oud;
+		struct osd_dev *od;
+
+		sprintf(dev_str, "/dev/osd%d", i);
+		od = osduld_path_lookup(dev_str);
+		if (IS_ERR(od))
+			continue;
+
+		oud = od->file->private_data;
+		if (_the_same_or_null(oud->odi.systemid, oud->odi.systemid_len,
+				      odi->systemid, odi->systemid_len) &&
+		    _the_same_or_null(oud->odi.osdname, oud->odi.osdname_len,
+				      odi->osdname, odi->osdname_len)) {
+			OSD_DEBUG("found device sysid_len=%d osdname=%d\n",
+				  odi->systemid_len, odi->osdname_len);
+			return od;
+		}
+		osduld_put_device(od);
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL(osduld_info_lookup);
+
 void osduld_put_device(struct osd_dev *od)
 {
 
@@ -230,6 +270,13 @@ void osduld_put_device(struct osd_dev *od)
 }
 EXPORT_SYMBOL(osduld_put_device);
 
+const struct osd_dev_info *osduld_device_info(struct osd_dev *od)
+{
+	struct osd_uld_device *oud = od->file->private_data;
+	return &oud->odi;
+}
+EXPORT_SYMBOL(osduld_device_info);
+
 /*
  * Scsi Device operations
  */
@@ -250,7 +297,7 @@ static int __detect_osd(struct osd_uld_device *oud)
 		OSD_ERR("warning: scsi_test_unit_ready failed\n");
 
 	osd_sec_init_nosec_doall_caps(caps, &osd_root_object, false, true);
-	if (osd_auto_detect_ver(&oud->od, caps))
+	if (osd_auto_detect_ver(&oud->od, caps, &oud->odi))
 		return -ENODEV;
 
 	return 0;
@@ -402,6 +449,7 @@ static void __remove(struct kref *kref)
 		put_disk(oud->disk);
 
 	ida_remove(&osd_minor_ida, oud->minor);
+	kfree(oud->odi.osdname);
 	kfree(oud);
 }
 
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 02bd9f7..0d29cc3 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -56,10 +56,23 @@ struct osd_dev {
 #endif
 };
 
-/* Retrieve/return osd_dev(s) for use by Kernel clients */
-struct osd_dev *osduld_path_lookup(const char *dev_name); /*Use IS_ERR/ERR_PTR*/
+/* Unique Identification of an OSD device */
+struct osd_dev_info {
+	unsigned systemid_len;
+	u8 systemid[OSD_SYSTEMID_LEN];
+	unsigned osdname_len;
+	u8 *osdname;
+};
+
+/* Retrieve/return osd_dev(s) for use by Kernel clients
+ * Use IS_ERR/ERR_PTR on returned "osd_dev *".
+ */
+struct osd_dev *osduld_path_lookup(const char *dev_name);
+struct osd_dev *osduld_info_lookup(const struct osd_dev_info *odi);
 void osduld_put_device(struct osd_dev *od);
 
+const struct osd_dev_info *osduld_device_info(struct osd_dev *od);
+
 /* Add/remove test ioctls from external modules */
 typedef int (do_test_fn)(struct osd_dev *od, unsigned cmd, unsigned long arg);
 int osduld_register_test(unsigned ioctl, do_test_fn *do_test);
@@ -69,8 +82,24 @@ void osduld_unregister_test(unsigned ioctl);
 void osd_dev_init(struct osd_dev *od, struct scsi_device *scsi_device);
 void osd_dev_fini(struct osd_dev *od);
 
-/* some hi level device operations */
-int osd_auto_detect_ver(struct osd_dev *od, void *caps);    /* GFP_KERNEL */
+/**
+ * osd_auto_detect_ver - Detect the OSD version, return Unique Identification
+ *
+ * @od:     OSD target lun handle
+ * @caps:   Capabilities authorizing OSD root read attributes access
+ * @odi:    Retrieved information uniquely identifying the osd target lun
+ *          Note: odi->osdname must be kfreed by caller.
+ *
+ * Auto detects the OSD version of the OSD target and sets the @od
+ * accordingly. Meanwhile also returns the "system id" and "osd name" root
+ * attributes which uniquely identify the OSD target. This member is usually
+ * called by the ULD. ULD users should call osduld_device_info().
+ * This rutine allocates osd requests and memory at GFP_KERNEL level and might
+ * sleep.
+ */
+int osd_auto_detect_ver(struct osd_dev *od,
+	void *caps, struct osd_dev_info *odi);
+
 static inline struct request_queue *osd_request_queue(struct osd_dev *od)
 {
 	return od->scsi_device->request_queue;
-- 
1.6.2.1


