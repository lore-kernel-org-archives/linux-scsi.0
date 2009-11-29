From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/2] libosd: osd_dev_info: Unique Identification of an OSD
 device
Date: Sun, 29 Nov 2009 16:26:45 +0200
Message-ID: <4B1284A5.7000101@panasas.com>
References: <20091127143229.108298c6.sfr@canb.auug.org.au>		<4B123A82.10104@panasas.com> <4B127202.1010900@panasas.com>	<1259502399.2827.14.camel@mulgrave.site> <4B1283C9.1030002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:1893 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752202AbZK2O0l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2009 09:26:41 -0500
In-Reply-To: <4B1283C9.1030002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>


Define an osd_dev_info structure that Uniquely identifies an OSD
device lun on the network. The identification is built from unique
target attributes and is the same for all network/SAN machines.

osduld_info_lookup() - NEW
    New API that will lookup an osd_dev by its osd_dev_info.
    This is used by pNFS-objects for cross network global device
    identification. And by exofs multy-device support, the device
    info is specified in the on-disk exofs device table.

osduld_device_info() - NEW
    Given an osd_dev handle returns its associated osd_dev_info.
    The ULD fetches this information at startup and hangs it on
    each OSD device. (This is a fast operation that can be called
    at any condition)

osduld_device_same() - NEW
    With a given osd_dev at one hand and an osd_dev_info
    at another, we would like to know if they are the same
    device.
    Two osd_dev handles can be checked by:
        osduld_device_same(od1, osduld_device_info(od2));

osd_auto_detect_ver() - REVISED
    Now returns an osd_dev_info structure. Is only called once
    by ULD as before. See added comments for how to use.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   26 ++++++++--
 drivers/scsi/osd/osd_uld.c       |  100 ++++++++++++++++++++++++++++++++++++-
 include/scsi/osd_initiator.h     |   38 +++++++++++++--
 3 files changed, 151 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 7a117c1..60b7ca1 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -73,7 +73,8 @@ static const char *_osd_ver_desc(struct osd_request *or)
 
 #define ATTR_DEF_RI(id, len) ATTR_DEF(OSD_APAGE_ROOT_INFORMATION, id, len)
 
-static int _osd_print_system_info(struct osd_dev *od, void *caps)
+static int _osd_get_print_system_info(struct osd_dev *od,
+	void *caps, struct osd_dev_info *odi)
 {
 	struct osd_request *or;
 	struct osd_attr get_attrs[] = {
@@ -137,8 +138,12 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
 	OSD_INFO("PRODUCT_SERIAL_NUMBER  [%s]\n",
 		(char *)pFirst);
 
-	pFirst = get_attrs[a].val_ptr;
-	OSD_INFO("OSD_NAME               [%s]\n", (char *)pFirst);
+	odi->osdname_len = get_attrs[a].len;
+	/* Avoid NULL for memcmp optimization 0-length is good enough */
+	odi->osdname = kzalloc(odi->osdname_len + 1, GFP_KERNEL);
+	if (odi->osdname_len)
+		memcpy(odi->osdname, get_attrs[a].val_ptr, odi->osdname_len);
+	OSD_INFO("OSD_NAME               [%s]\n", odi->osdname);
 	a++;
 
 	pFirst = get_attrs[a++].val_ptr;
@@ -171,6 +176,14 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
 				   sid_dump, sizeof(sid_dump), true);
 		OSD_INFO("OSD_SYSTEM_ID(%d)\n"
 			 "        [%s]\n", len, sid_dump);
+
+		if (unlikely(len > sizeof(odi->systemid))) {
+			OSD_ERR("OSD Target error: OSD_SYSTEM_ID too long(%d). "
+				"device idetification might not work\n", len);
+			len = sizeof(odi->systemid);
+		}
+		odi->systemid_len = len;
+		memcpy(odi->systemid, get_attrs[a].val_ptr, len);
 		a++;
 	}
 out:
@@ -178,16 +191,17 @@ out:
 	return ret;
 }
 
-int osd_auto_detect_ver(struct osd_dev *od, void *caps)
+int osd_auto_detect_ver(struct osd_dev *od,
+	void *caps, struct osd_dev_info *odi)
 {
 	int ret;
 
 	/* Auto-detect the osd version */
-	ret = _osd_print_system_info(od, caps);
+	ret = _osd_get_print_system_info(od, caps, odi);
 	if (ret) {
 		osd_dev_set_ver(od, OSD_VER1);
 		OSD_DEBUG("converting to OSD1\n");
-		ret = _osd_print_system_info(od, caps);
+		ret = _osd_get_print_system_info(od, caps, odi);
 	}
 
 	return ret;
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index fc6fc1c..0a90702 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -84,6 +84,7 @@ struct osd_uld_device {
 	struct device class_dev;
 	struct cdev cdev;
 	struct osd_dev od;
+	struct osd_dev_info odi;
 	struct gendisk *disk;
 };
 
@@ -225,6 +226,72 @@ free_od:
 }
 EXPORT_SYMBOL(osduld_path_lookup);
 
+static inline bool _the_same_or_null(const u8 *a1, unsigned a1_len,
+				     const u8 *a2, unsigned a2_len)
+{
+	if (!a2_len) /* User string is Empty means don't care */
+		return true;
+
+	if (a1_len != a2_len)
+		return false;
+
+	return 0 == memcmp(a1, a2, a1_len);
+}
+
+struct find_oud_t {
+	const struct osd_dev_info *odi;
+	struct device *dev;
+	struct osd_uld_device *oud;
+} ;
+
+int _mach_odi(struct device *dev, void *find_data)
+{
+	struct osd_uld_device *oud = container_of(dev, struct osd_uld_device,
+						  class_dev);
+	struct find_oud_t *fot = find_data;
+	const struct osd_dev_info *odi = fot->odi;
+
+	if (_the_same_or_null(oud->odi.systemid, oud->odi.systemid_len,
+			      odi->systemid, odi->systemid_len) &&
+	    _the_same_or_null(oud->odi.osdname, oud->odi.osdname_len,
+			      odi->osdname, odi->osdname_len)) {
+		OSD_DEBUG("found device sysid_len=%d osdname=%d\n",
+			  odi->systemid_len, odi->osdname_len);
+		fot->oud = oud;
+		return 1;
+	} else {
+		return 0;
+	}
+}
+
+/* osduld_info_lookup - Loop through all devices, return the requested osd_dev.
+ *
+ * if @odi->systemid_len and/or @odi->osdname_len are zero, they act as a don't
+ * care. .e.g if they're both zero /dev/osd0 is returned.
+ */
+struct osd_dev *osduld_info_lookup(const struct osd_dev_info *odi)
+{
+	struct find_oud_t find = {.odi = odi};
+
+	find.dev = class_find_device(&osd_uld_class, NULL, &find, _mach_odi);
+	if (likely(find.dev)) {
+		struct osd_dev_handle *odh = kzalloc(sizeof(*odh), GFP_KERNEL);
+
+		if (unlikely(!odh)) {
+			put_device(find.dev);
+			return ERR_PTR(-ENOMEM);
+		}
+
+		odh->od = find.oud->od;
+		odh->oud = find.oud;
+
+		return &odh->od;
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL(osduld_info_lookup);
+
 void osduld_put_device(struct osd_dev *od)
 {
 	if (od && !IS_ERR(od)) {
@@ -240,14 +307,39 @@ void osduld_put_device(struct osd_dev *od)
 		 * is called after the fops->release. A get_/put_ pair makes
 		 * sure we have a cdev for the duration of fput
 		 */
-		get_device(&oud->class_dev);
-		fput(odh->file);
+		if (odh->file) {
+			get_device(&oud->class_dev);
+			fput(odh->file);
+		}
 		put_device(&oud->class_dev);
 		kfree(odh);
 	}
 }
 EXPORT_SYMBOL(osduld_put_device);
 
+const struct osd_dev_info *osduld_device_info(struct osd_dev *od)
+{
+	struct osd_dev_handle *odh =
+				container_of(od, struct osd_dev_handle, od);
+	return &odh->oud->odi;
+}
+EXPORT_SYMBOL(osduld_device_info);
+
+bool osduld_device_same(struct osd_dev *od, const struct osd_dev_info *odi)
+{
+	struct osd_dev_handle *odh =
+				container_of(od, struct osd_dev_handle, od);
+	struct osd_uld_device *oud = odh->oud;
+
+	return (oud->odi.systemid_len == odi->systemid_len) &&
+		_the_same_or_null(oud->odi.systemid, oud->odi.systemid_len,
+				 odi->systemid, odi->systemid_len) &&
+		(oud->odi.osdname_len == odi->osdname_len) &&
+		_the_same_or_null(oud->odi.osdname, oud->odi.osdname_len,
+				  odi->osdname, odi->osdname_len);
+}
+EXPORT_SYMBOL(osduld_device_same);
+
 /*
  * Scsi Device operations
  */
@@ -268,7 +360,7 @@ static int __detect_osd(struct osd_uld_device *oud)
 		OSD_ERR("warning: scsi_test_unit_ready failed\n");
 
 	osd_sec_init_nosec_doall_caps(caps, &osd_root_object, false, true);
-	if (osd_auto_detect_ver(&oud->od, caps))
+	if (osd_auto_detect_ver(&oud->od, caps, &oud->odi))
 		return -ENODEV;
 
 	return 0;
@@ -280,6 +372,8 @@ static void __remove(struct device *dev)
 						  class_dev);
 	struct scsi_device *scsi_device = oud->od.scsi_device;
 
+	kfree(oud->odi.osdname);
+
 	if (oud->cdev.owner)
 		cdev_del(&oud->cdev);
 
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 589e5f0..3ec346e 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -55,10 +55,24 @@ struct osd_dev {
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
+bool osduld_device_same(struct osd_dev *od, const struct osd_dev_info *odi);
+
 /* Add/remove test ioctls from external modules */
 typedef int (do_test_fn)(struct osd_dev *od, unsigned cmd, unsigned long arg);
 int osduld_register_test(unsigned ioctl, do_test_fn *do_test);
@@ -68,8 +82,24 @@ void osduld_unregister_test(unsigned ioctl);
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
1.6.5.2


