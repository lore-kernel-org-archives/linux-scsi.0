From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 00/16] open-osd: OSD Initiator library for 2.6.30
Date: Sun, 25 Jan 2009 16:46:11 +0200
Message-ID: <497C7B33.4080105@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080507080300070400060808"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:29691 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753713AbZAYOqR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jan 2009 09:46:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

This is a multi-part message in MIME format.
--------------080507080300070400060808
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

James hi.

Since we missed the 2.6.29 merge window, sigh, I'm taking the opportunity to
refresh the patchset. It's basically the same, but for a few changes listed
below:
- Exact same submitted code is now compilable as a user-mode library so
  utilities like exofs.mkfs can be compiled as regular application.
  When compiling in user-mode using my preferred -W switches to gcc I've
  unearthed little warnings, which are now fixed. Mainly:
  * signed/unsigned comparison
  * char * pointing to a const string (This one is grave in my opinion)
  * more missing statics.
  * ...
- I have added an API to the osd_uld for test modules to register an ioctl
  test vector. In the last patchset, as requested, I have removed the tests
  code from upstream submission. This meant that the out-of-tree git was
  patching the osd_uld.c and Kbuild kernel files in-order to add the tests.
  This is an administrative night-mare both for developers and users alike.
  Since they must patch their running kernel and install/replace distro modules.
  So I put the osd_ktests.c code in its own module and enable it to register
  at run-time into the running osd_uld, though injecting tests into running code.

Please take these patches off my hands this time ASAP, and let them rot in
scsi-misc until 2.6.30 merge-window ;)

[A patch is attached that showed what was changed from last time.]
---
here is the usual stuff for first-time viewers

OSD (Object-Based Storage Device) is a T10 SCSI command set that is designed
to provide efficient operation of input/output logical units that manage the
allocation, placement, and accessing of variable-size data-storage containers,
called objects. Objects are intended to contain operating system and application
constructs. Each object has associated attributes attached to it, which are
integral part of the object and provide metadata about the object. The standard
defines some common obligatory attributes, but user attributes can be added as
needed.

The patches are cut over scsi-misc-2.6-7e106029 but apply cleanly over
Linus git.

To try out and run the library please visit
http://open-osd.org and follow the instructions there.

The submitted patchset is also available via git at:
   git://git.open-osd.org/linux-open-osd.git osd
   http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=osd

here is the list of patches:

[PATCH 01/16] major.h: char-major number for OSD device driver
  Request for a new char-device major number

[PATCH 02/16] scsi: OSD_TYPE
  The OSD scsi type constant definition.

[PATCH 03/16] libosd: OSDv1 Headers
[PATCH 04/16] libosd: OSDv1 preliminary implementation
  Most basic, but usable library module (libosd.ko) including
  Kbuild file.

[PATCH 05/16] osd_uld: OSD scsi ULD
[PATCH 06/16] osd_uld: API for retrieving osd devices from Kernel
  These patches add a scsi ULD for OSD type devices. Please see
  commit logs for details.

[PATCH 07/16] libosd: attributes Support
[PATCH 08/16] libosd: OSD Security processing stubs
[PATCH 09/16] libosd: Add Flush and List-objects support
[PATCH 10/16] libosd: Not implemented commands
[PATCH 11/16] libosd: OSD version 2 Support
[PATCH 12/16] libosd: OSDv2 auto detection
[PATCH 13/16] libosd: SCSI/OSD Sense decoding support
  Up to here this is a fairly complete body of work, to support
  both OSD1 and OSD2 targets. Main pieces that are still missing
  from the library at this point are: The OSD2 capabilities structure,
  do to lack of an OSD target that supports it. And the absence of any
  OSD-security methods other then NO_SECURITY. These will come in future
  versions.

[PATCH 14/16] osd: Documentation for OSD library
  Some reading about OSD in general and further usability instructions.
  Please comment on anything missing from this document.

[PATCH 15/16] osd: Kconfig file for in-tree builds
[PATCH 16/16] scsi: Add osd library to build system
  The in-tree compilation is only enabled at the end of the patchset.
  Run your favorite configure-tool to enable the library and osd_uld
  compilation. Default is off.
  The patchset is however fully bisectable, and compilable from the beginning,
  (by applying these 2 patches first).

The open-osd team
Boaz Harrosh


--------------080507080300070400060808
Content-Type: text/x-patch;
 name="diff_osd-for-29_to_osd-for-30.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff_osd-for-29_to_osd-for-30.patch"

git diff --stat -p -R 2abc3b5d42d4c16e57d8fdd2e3475402f10d468b 95256f25df7dc7e18f0e8652b6a0309913d4dabe
 drivers/scsi/osd/Kbuild          |    8 +++-
 drivers/scsi/osd/osd_initiator.c |   48 ++++++++++++++----------
 drivers/scsi/osd/osd_ktests.c    |   75 +++++++++++++++++++++++++++++---------
 drivers/scsi/osd/osd_ktests.h    |    4 +--
 drivers/scsi/osd/osd_uld.c       |   44 +++++++++++++++++++----
 include/scsi/osd_initiator.h     |    5 +++
 6 files changed, 134 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/osd/Kbuild b/drivers/scsi/osd/Kbuild
index 29f7ddd..c35fe80 100644
--- a/drivers/scsi/osd/Kbuild
+++ b/drivers/scsi/osd/Kbuild
@@ -32,7 +32,11 @@ ccflags-y += -DCONFIG_SCSI_OSD_DPRINT_SENSE=1
 # if we are built out-of-tree and the hosting kernel has OSD headers
 # then "ccflags-y +=" will not pick the out-off-tree headers. Only by doing
 # this it will work. This might break in future kernels
-KBUILD_CPPFLAGS := -I$(OSD_INC) $(KBUILD_CPPFLAGS)
+LINUXINCLUDE := -I$(OSD_INC) $(LINUXINCLUDE)
+
+# osd_ktests.ko is only built out of tree
+#   see git://git.open-osd.org open-osd for latest code
+obj-m += osd_ktests.o
 
 endif
 
@@ -41,5 +45,5 @@ libosd-y := osd_initiator.o
 obj-$(CONFIG_SCSI_OSD_INITIATOR) += libosd.o
 
 # osd.ko - SCSI ULD and char-device
-osd-y := osd_uld.o osd_ktests.o
+osd-y := osd_uld.o
 obj-$(CONFIG_SCSI_OSD_ULD) += osd.o
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 11bf42b..0bbbf27 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -48,6 +48,10 @@
 
 #include "osd_debug.h"
 
+#ifndef __unused
+#    define __unused			__attribute__((unused))
+#endif
+
 enum { OSD_REQ_RETRIES = 1 };
 
 MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
@@ -62,7 +66,7 @@ static inline void build_test(void)
 	BUILD_BUG_ON(sizeof(struct osdv1_cdb) != OSDv1_TOTAL_CDB_LEN);
 }
 
-static char *_osd_ver_desc(struct osd_request *or)
+static const char *_osd_ver_desc(struct osd_request *or)
 {
 	return osd_req_is_ver1(or) ? "OSD1" : "OSD2";
 }
@@ -157,8 +161,8 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
 		((char *)pFirst)[4], ((char *)pFirst)[5]);
 
 	if (a < nelem) { /* IBM-OSD-SIM bug, Might not have it */
-		int len = get_attrs[a].len;
-		u8 sid_dump[32*4 + 2]; /* 2nibbles+space+ASCII */
+		unsigned len = get_attrs[a].len;
+		char sid_dump[32*4 + 2]; /* 2nibbles+space+ASCII */
 
 		hex_dump_to_buffer(get_attrs[a].val_ptr, len, 32, 1,
 				   sid_dump, sizeof(sid_dump), true);
@@ -345,7 +349,7 @@ static void _abort_unexecuted_bios(struct request *rq)
 	}
 }
 
-static void _osd_free_seg(struct osd_request *or,
+static void _osd_free_seg(struct osd_request *or __unused,
 	struct _osd_req_data_segment *seg)
 {
 	if (!seg->buff || !seg->alloc_size)
@@ -834,7 +838,7 @@ static int _append_map_kern(struct request *req,
 }
 
 static int _req_append_segment(struct osd_request *or,
-	int padding, struct _osd_req_data_segment *seg,
+	unsigned padding, struct _osd_req_data_segment *seg,
 	struct _osd_req_data_segment *last_seg, struct _osd_io_info *io)
 {
 	void *pad_buff;
@@ -869,7 +873,7 @@ static int _req_append_segment(struct osd_request *or,
 static int _osd_req_finalize_set_attr_list(struct osd_request *or)
 {
 	struct osd_cdb_head *cdbh = osd_cdb_head(&or->cdb);
-	int padding;
+	unsigned padding;
 	int ret;
 
 	if (!or->set_attr.total_bytes) {
@@ -1016,7 +1020,8 @@ static int _osd_req_finalize_get_attr_list(struct osd_request *or)
 int osd_req_decode_get_attr_list(struct osd_request *or,
 	struct osd_attr *oa, int *nelem, void **iterator)
 {
-	unsigned cur_bytes, returned_bytes, n;
+	unsigned cur_bytes, returned_bytes;
+	int n;
 	const unsigned sizeof_attr_list = _osd_req_sizeof_alist_header(or);
 	void *cur_p;
 
@@ -1124,7 +1129,7 @@ EXPORT_SYMBOL(osd_req_add_get_attr_page);
 static int _osd_req_finalize_attr_page(struct osd_request *or)
 {
 	struct osd_cdb_head *cdbh = osd_cdb_head(&or->cdb);
-	int in_padding, out_padding;
+	unsigned in_padding, out_padding;
 	int ret;
 
 	/* returned page */
@@ -1159,7 +1164,7 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 			.buff = &or->out_data_integ,
 			.total_bytes = sizeof(or->out_data_integ),
 		};
-		int pad;
+		unsigned pad;
 
 		or->out_data_integ.data_bytes = cpu_to_be64(
 			or->out.bio ? or->out.bio->bi_size : 0);
@@ -1187,7 +1192,7 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 			.buff = &or->in_data_integ,
 			.total_bytes = sizeof(or->in_data_integ),
 		};
-		int pad;
+		unsigned pad;
 
 		sec_parms->data_in_integrity_check_offset =
 			osd_req_encode_offset(or, or->in.total_bytes, &pad);
@@ -1346,7 +1351,7 @@ EXPORT_SYMBOL(osd_finalize_request);
 
 int osd_req_decode_sense_full(struct osd_request *or,
 	struct osd_sense_info *osi, bool silent,
-	struct osd_obj_id *bad_obj_list, int max_obj,
+	struct osd_obj_id *bad_obj_list __unused, int max_obj __unused,
 	struct osd_attr *bad_attr_list, int max_attr)
 {
 	int sense_len, original_sense_len;
@@ -1364,10 +1369,11 @@ int osd_req_decode_sense_full(struct osd_request *or,
 
 	ssdb = or->request->sense;
 	sense_len = or->request->sense_len;
-	if ((sense_len < sizeof(*ssdb) || !ssdb->sense_key)) {
-		OSD_ERR("Block-layer returned error(%x) but sense is empty\n",
-			or->request->errors);
-		return 0;
+	if ((sense_len < (int)sizeof(*ssdb) || !ssdb->sense_key)) {
+		OSD_ERR("Block-layer returned error(0x%x) but "
+			"sense_len(%u) || key(%d) is empty\n",
+			or->request->errors, sense_len, ssdb->sense_key);
+		return -EIO;
 	}
 
 	if ((ssdb->response_code != 0x72) && (ssdb->response_code != 0x73)) {
@@ -1456,8 +1462,9 @@ int osd_req_decode_sense_full(struct osd_request *or,
 		{
 			struct osd_sense_response_integrity_check_descriptor
 				*osricd = cur_descriptor;
-			const int len = sizeof(osricd->integrity_check_value);
-			u8 key_dump[len*4 + 2]; /* 2nibbles+space+ASCII */
+			const unsigned len =
+					  sizeof(osricd->integrity_check_value);
+			char key_dump[len*4 + 2]; /* 2nibbles+space+ASCII */
 
 			hex_dump_to_buffer(osricd->integrity_check_value, len,
 				       32, 1, key_dump, sizeof(key_dump), true);
@@ -1590,16 +1597,17 @@ void osd_set_caps(struct osd_cdb *cdb, const void *caps)
 	memcpy(&cdb->v1.caps, caps, is_ver1 ? OSDv1_CAP_LEN : OSD_CAP_LEN);
 }
 
-bool osd_is_sec_alldata(struct osd_security_parameters *sec_parms)
+bool osd_is_sec_alldata(struct osd_security_parameters *sec_parms __unused)
 {
 	return false;
 }
 
-void osd_sec_sign_cdb(struct osd_cdb *ocdb, const u8 *cap_key)
+void osd_sec_sign_cdb(struct osd_cdb *ocdb __unused, const u8 *cap_key __unused)
 {
 }
 
-void osd_sec_sign_data(void *data_integ, struct bio *bio, const u8 *cap_key)
+void osd_sec_sign_data(void *data_integ __unused,
+		       struct bio *bio __unused, const u8 *cap_key __unused)
 {
 }
 
diff --git a/drivers/scsi/osd/osd_ktests.c b/drivers/scsi/osd/osd_ktests.c
index d098323..73130a0 100644
--- a/drivers/scsi/osd/osd_ktests.c
+++ b/drivers/scsi/osd/osd_ktests.c
@@ -38,7 +38,6 @@
  *
  */
 #include <asm/unaligned.h>
-#include <linux/vmalloc.h>
 #include <scsi/scsi_device.h>
 
 #include <scsi/osd_initiator.h>
@@ -48,6 +47,10 @@
 #include "osd_ktests.h"
 #include "osd_debug.h"
 
+#ifndef __unused
+#    define __unused			__attribute__((unused))
+#endif
+
 enum {
 	K = 1024,
 	M = 1024 * K,
@@ -57,14 +60,16 @@ enum {
 const u64 format_total_capacity = 128 * M;
 const osd_id first_par_id = 0x17171717L;
 const osd_id first_obj_id = 0x18181818L;
-const unsigned BUFF_SIZE = PAGE_SIZE;
+const unsigned BUFF_SIZE = 4 * K;
 
 const int num_partitions = 1;
 const int num_objects = 2; /* per partition */
 
-int test_exec(struct osd_request *or, void *caps, const struct osd_obj_id *obj)
+static int test_exec(struct osd_request *or, void *caps,
+		     const struct osd_obj_id *obj)
 {
 	int ret;
+	struct osd_sense_info osi;
 
 	osd_sec_init_nosec_doall_caps(caps, obj, false, true);
 	ret = osd_finalize_request(or, 0, caps, NULL);
@@ -72,14 +77,14 @@ int test_exec(struct osd_request *or, void *caps, const struct osd_obj_id *obj)
 		return ret;
 
 	ret = osd_execute_request(or);
-	/* osd_req_decode_sense(or, ret); */
+	osd_req_decode_sense(or, &osi);
 	return ret;
 }
 
 #define KTEST_START_REQ(osd_dev, or) do { \
 	or = osd_start_request(osd_dev, GFP_KERNEL); \
 	if (!or) { \
-		OSD_ERR("Error @%s:%d: osd_start_request", __func__,\
+		OSD_ERR("Error @%s:%d: osd_start_request\n", __func__,\
 			__LINE__); \
 		return -ENOMEM; \
 	} \
@@ -95,7 +100,7 @@ int test_exec(struct osd_request *or, void *caps, const struct osd_obj_id *obj)
 	OSD_DEBUG(msg "\n"); \
 } while (0)
 
-int ktest_format(struct osd_dev *osd_dev)
+static int ktest_format(struct osd_dev *osd_dev)
 {
 	struct osd_request *or;
 	u8 g_caps[OSD_CAP_LEN];
@@ -107,7 +112,7 @@ int ktest_format(struct osd_dev *osd_dev)
 	return 0;
 }
 
-int ktest_creat_par(struct osd_dev *osd_dev)
+static int ktest_creat_par(struct osd_dev *osd_dev)
 {
 	struct osd_request *or;
 	u8 g_caps[OSD_CAP_LEN];
@@ -128,7 +133,7 @@ int ktest_creat_par(struct osd_dev *osd_dev)
 	return 0;
 }
 
-int ktest_creat_obj(struct osd_dev *osd_dev)
+static int ktest_creat_obj(struct osd_dev *osd_dev)
 {
 	struct osd_request *or;
 	u8 g_caps[OSD_CAP_LEN];
@@ -150,7 +155,7 @@ int ktest_creat_obj(struct osd_dev *osd_dev)
 	return 0;
 }
 
-int ktest_write_obj(struct osd_dev *osd_dev, void *write_buff)
+static int ktest_write_obj(struct osd_dev *osd_dev, void *write_buff)
 {
 	struct request_queue *req_q = osd_dev->scsi_device->request_queue;
 	struct osd_request *or;
@@ -183,7 +188,7 @@ int ktest_write_obj(struct osd_dev *osd_dev, void *write_buff)
 	return 0;
 }
 
-int ktest_read_obj(struct osd_dev *osd_dev, void *write_buff, void *read_buff)
+static int ktest_read_obj(struct osd_dev *osd_dev, void *write_buff, void *read_buff)
 {
 	struct request_queue *req_q = osd_dev->scsi_device->request_queue;
 	struct osd_request *or;
@@ -211,14 +216,14 @@ int ktest_read_obj(struct osd_dev *osd_dev, void *write_buff, void *read_buff)
 			KTEST_EXEC_END(or, &obj, g_caps, "read");
 			read_bio = NULL;
 			if (memcmp(read_buff, write_buff, BUFF_SIZE))
-				OSD_ERR("!!! Read did not compare");
+				OSD_ERR("!!! Read did not compare\n");
 			offset += BUFF_SIZE;
 		}
 
 	return 0;
 }
 
-int ktest_remove_obj(struct osd_dev *osd_dev)
+static int ktest_remove_obj(struct osd_dev *osd_dev)
 {
 	struct osd_request *or;
 	u8 g_caps[OSD_CAP_LEN];
@@ -240,7 +245,7 @@ int ktest_remove_obj(struct osd_dev *osd_dev)
 	return 0;
 }
 
-int ktest_remove_par(struct osd_dev *osd_dev)
+static int ktest_remove_par(struct osd_dev *osd_dev)
 {
 	struct osd_request *or;
 	u8 g_caps[OSD_CAP_LEN];
@@ -261,7 +266,7 @@ int ktest_remove_par(struct osd_dev *osd_dev)
 	return 0;
 }
 
-int ktest_write_read_attr(struct osd_dev *osd_dev, void *buff,
+static int ktest_write_read_attr(struct osd_dev *osd_dev, void *buff,
 	bool doread, bool doset, bool doget)
 {
 	struct request_queue *req_q = osd_dev->scsi_device->request_queue;
@@ -269,7 +274,7 @@ int ktest_write_read_attr(struct osd_dev *osd_dev, void *buff,
 	char g_caps[OSD_CAP_LEN];
 	int ret;
 	struct bio *bio;
-	char *domsg;
+	const char *domsg;
 	/* set attrs */
 	static char name[] = "ktest_write_read_attr";
 	__be64 max_len = cpu_to_be64(0x80000000L);
@@ -310,7 +315,6 @@ int ktest_write_read_attr(struct osd_dev *osd_dev, void *buff,
 	if (doget)
 		osd_req_add_get_attr_list(or, get_attrs, 2);
 
-/*	KTEST_EXEC_END(or, &obj, "");*/
 	ret = test_exec(or, g_caps, &obj);
 	if (!ret && doget) {
 		void *iter = NULL, *pFirst, *pSec;
@@ -346,11 +350,13 @@ int ktest_write_read_attr(struct osd_dev *osd_dev, void *buff,
 	return 0;
 }
 
-int do_test_17(struct osd_dev *od)
+int do_test_17(struct osd_dev *od, unsigned cmd __unused,
+		unsigned long arg __unused)
 {
 	void *write_buff = NULL;
 	void *read_buff = NULL;
-	int ret = -ENOMEM, i;
+	int ret = -ENOMEM;
+	unsigned i;
 
 /* osd_format */
 	if (ktest_format(od))
@@ -429,6 +435,14 @@ int do_test_17(struct osd_dev *od)
 	if (ret)
 		goto dev_fini;
 
+/* Error to test sense handling */
+	ret = ktest_write_obj(od, write_buff);
+	if (!ret) {
+		OSD_INFO("Error was expected written to none existing object\n");
+		ret = -EIO;
+	} else
+		ret =  0; /* good this test should fail */
+
 /* good and done */
 	OSD_INFO("test17: All good and done\n");
 dev_fini:
@@ -439,3 +453,28 @@ dev_fini:
 
 	return ret;
 }
+
+#ifdef __KERNEL__
+static const char *osd_ktests_version = "open-osd osd_ktests 0.1.0";
+
+MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
+MODULE_DESCRIPTION("open-osd Kernel tests Driver osd_ktests.ko");
+MODULE_LICENSE("GPL");
+
+static int __init osd_uld_init(void)
+{
+	OSD_INFO("LOADED %s\n", osd_ktests_version);
+	osduld_register_test(OSD_TEST_ALL, do_test_17);
+	return 0;
+}
+
+static void __exit osd_uld_exit(void)
+{
+	osduld_unregister_test(OSD_TEST_ALL);
+	OSD_INFO("UNLOADED %s\n", osd_ktests_version);
+}
+
+module_init(osd_uld_init);
+module_exit(osd_uld_exit);
+
+#endif
diff --git a/drivers/scsi/osd/osd_ktests.h b/drivers/scsi/osd/osd_ktests.h
index b625ee5..cde65ca 100644
--- a/drivers/scsi/osd/osd_ktests.h
+++ b/drivers/scsi/osd/osd_ktests.h
@@ -24,8 +24,6 @@
 
 enum { OSD_TEST_ALL = 17 };
 
-#ifdef __KERNEL__
-extern int do_test_17(struct osd_dev *od);
-#endif /* __KERNEL__ */
+int do_test_17(struct osd_dev *od, unsigned cmd, unsigned long arg);
 
 #endif /*ndef __OSD_KTESTS_H__*/
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index d8f65ad..f8b1a74 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -58,7 +58,6 @@
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
 
-#include "osd_ktests.h"
 #include "osd_debug.h"
 
 #ifndef TYPE_OSD
@@ -118,18 +117,49 @@ static int osd_uld_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+/* FIXME: Only one vector for now */
+unsigned g_test_ioctl;
+do_test_fn *g_do_test;
+
+int osduld_register_test(unsigned ioctl, do_test_fn *do_test)
+{
+	if (g_test_ioctl)
+		return -EINVAL;
+
+	g_test_ioctl = ioctl;
+	g_do_test = do_test;
+	return 0;
+}
+EXPORT_SYMBOL(osduld_register_test);
+
+void osduld_unregister_test(unsigned ioctl)
+{
+	if (ioctl == g_test_ioctl) {
+		g_test_ioctl = 0;
+		g_do_test = NULL;
+	}
+}
+EXPORT_SYMBOL(osduld_unregister_test);
+
+static do_test_fn *_find_ioctl(unsigned cmd)
+{
+	if (g_test_ioctl == cmd)
+		return g_do_test;
+	else
+		return NULL;
+}
+
 static long osd_uld_ioctl(struct file *file, unsigned int cmd,
 	unsigned long arg)
 {
 	struct osd_uld_device *oud = file->private_data;
 	int ret;
+	do_test_fn *do_test;
 
-	switch (cmd) {
-	case OSD_TEST_ALL:
-		OSD_DEBUG("Kernel test %d: osd_uld_device=%p\n", cmd, oud);
-		ret = do_test_17(&oud->od);
-		break;
-	default:
+	do_test = _find_ioctl(cmd);
+	if (do_test)
+		ret = do_test(&oud->od, cmd, arg);
+	else {
 		OSD_ERR("Unknown ioctl %d: osd_uld_device=%p\n", cmd, oud);
 		ret = -ENOIOCTLCMD;
 	}
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 83b6976..b24d961 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -58,6 +58,11 @@ struct osd_dev {
 struct osd_dev *osduld_path_lookup(const char *dev_name); /*Use IS_ERR/ERR_PTR*/
 void osduld_put_device(struct osd_dev *od);
 
+/* Add/remove test ioctls from external modules */
+typedef int (do_test_fn)(struct osd_dev *od, unsigned cmd, unsigned long arg);
+int osduld_register_test(unsigned ioctl, do_test_fn *do_test);
+void osduld_unregister_test(unsigned ioctl);
+
 /* These are called by uld at probe time */
 void osd_dev_init(struct osd_dev *od, struct scsi_device *scsi_device);
 void osd_dev_fini(struct osd_dev *od);

--------------080507080300070400060808--
