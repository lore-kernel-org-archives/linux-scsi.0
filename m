From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 10/14] libosd: OSD version 2 Support
Date: Thu, 24 Jul 2008 20:58:24 +0300
Message-ID: <4888C2C0.2080100@panasas.com>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:24602 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751716AbYGXR7N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 13:59:13 -0400
In-Reply-To: <4888BC3B.1050406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-osd development <osd-dev@open-osd.org>
Cc: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


Add support for OSD2 at run time. It is now possible to run with
both OSDv1 and OSDv2 targets at the same time. The actual detection
should be preformed by the security manager, as the version is encoded
in the capability structure. See the osd_ktests patch for how to easily
detect a target version in runtime. (All you need is issue a first comm=
and,
then if it fails call osd_dev_set_ver(OSD_VER1) and issue the command
again)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   94 ++++++++++++++++++++++++++++++=
++------
 include/scsi/osd_initiator.h     |   39 ++++++++++++++++
 include/scsi/osd_protocol.h      |   86 ++++++++++++++++++++++++++++++=
+++--
 3 files changed, 201 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_in=
itiator.c
index e0216e0..3003456 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -57,36 +57,50 @@ static inline void build_test(void)
 {
 	/* structures were not packed */
 	BUILD_BUG_ON(sizeof(struct osd_capability) !=3D OSD_CAP_LEN);
+	BUILD_BUG_ON(sizeof(struct osdv2_cdb) !=3D OSD_TOTAL_CDB_LEN);
 	BUILD_BUG_ON(sizeof(struct osdv1_cdb) !=3D OSDv1_TOTAL_CDB_LEN);
 }
=20
 static unsigned _osd_req_cdb_len(struct osd_request *or)
 {
-	return OSDv1_TOTAL_CDB_LEN;
+	return osd_req_is_ver1(or) ? OSDv1_TOTAL_CDB_LEN : OSD_TOTAL_CDB_LEN;
 }
=20
 static unsigned _osd_req_alist_elem_size(struct osd_request *or, unsig=
ned len)
 {
-	return osdv1_attr_list_elem_size(len);
+	return osd_req_is_ver1(or) ?
+		osdv1_attr_list_elem_size(len) :
+		osdv2_attr_list_elem_size(len);
 }
=20
 static unsigned _osd_req_alist_size(struct osd_request *or, void *list=
_head)
 {
-	return osdv1_list_size(list_head);
+	return osd_req_is_ver1(or) ?
+		osdv1_list_size(list_head) :
+		osdv2_list_size(list_head);
 }
=20
 static unsigned _osd_req_sizeof_alist_header(struct osd_request *or)
 {
-	return sizeof(struct osdv1_attributes_list_header);
+	return osd_req_is_ver1(or) ?
+		sizeof(struct osdv1_attributes_list_header) :
+		sizeof(struct osdv2_attributes_list_header);
 }
=20
 static void _osd_req_set_alist_type(struct osd_request *or,
 	void *list, int list_type)
 {
-	struct osdv1_attributes_list_header *attr_list =3D list;
+	if (osd_req_is_ver1(or)) {
+		struct osdv1_attributes_list_header *attr_list =3D list;
+
+		memset(attr_list, 0, sizeof(*attr_list));
+		attr_list->type =3D list_type;
+	} else {
+		struct osdv2_attributes_list_header *attr_list =3D list;
=20
-	memset(attr_list, 0, sizeof(*attr_list));
-	attr_list->type =3D list_type;
+		memset(attr_list, 0, sizeof(*attr_list));
+		attr_list->type =3D list_type;
+	}
 }
=20
 static bool _osd_req_is_alist_type(struct osd_request *or,
@@ -95,10 +109,14 @@ static bool _osd_req_is_alist_type(struct osd_requ=
est *or,
 	if (!list)
 		return false;
=20
-	if (1) {
+	if (osd_req_is_ver1(or)) {
 		struct osdv1_attributes_list_header *attr_list =3D list;
=20
 		return attr_list->type =3D=3D list_type;
+	} else {
+		struct osdv2_attributes_list_header *attr_list =3D list;
+
+		return attr_list->type =3D=3D list_type;
 	}
 }
=20
@@ -108,15 +126,22 @@ static void _osd_req_encode_olist(struct osd_requ=
est *or,
 {
 	struct osd_cdb_head *cdbh =3D osd_cdb_head(&or->cdb);
=20
-	cdbh->v1.list_identifier =3D list->list_identifier;
-	cdbh->v1.start_address =3D list->continuation_id;
+	if (osd_req_is_ver1(or)) {
+		cdbh->v1.list_identifier =3D list->list_identifier;
+		cdbh->v1.start_address =3D list->continuation_id;
+	} else {
+		cdbh->v2.list_identifier =3D list->list_identifier;
+		cdbh->v2.start_address =3D list->continuation_id;
+	}
 }
=20
 static osd_cdb_offset osd_req_encode_offset(struct osd_request *or,
 	u64 offset, unsigned *padding)
 {
 	return __osd_encode_offset(offset, padding,
-				  OSDv1_OFFSET_MIN_SHIFT, OSD_OFFSET_MAX_SHIFT);
+			osd_req_is_ver1(or) ?
+				OSDv1_OFFSET_MIN_SHIFT : OSD_OFFSET_MIN_SHIFT,
+			OSD_OFFSET_MAX_SHIFT);
 }
=20
 static struct osd_security_parameters *
@@ -124,7 +149,10 @@ _osd_req_sec_params(struct osd_request *or)
 {
 	struct osd_cdb *ocdb =3D &or->cdb;
=20
-	return &ocdb->v1.sec_params;
+	if (osd_req_is_ver1(or))
+		return &ocdb->v1.sec_params;
+	else
+		return &ocdb->v2.sec_params;
 }
=20
 void osd_dev_init(struct osd_dev *osdd, struct scsi_device *scsi_dev)
@@ -134,6 +162,9 @@ void osd_dev_init(struct osd_dev *osdd, struct scsi=
_device *scsi_dev)
 	memset(osdd, 0, sizeof(*osdd));
 	osdd->scsi_dev =3D scsi_dev;
 	osdd->def_timeout =3D BLK_DEFAULT_SG_TIMEOUT;
+#ifdef OSD_VER1_SUPPORT
+	osdd->version =3D OSD_VER2;
+#endif
 	/* TODO: Allocate pools for osd_request attributes ... */
 }
 EXPORT_SYMBOL(osd_dev_init);
@@ -307,10 +338,30 @@ static void _osdv1_req_encode_common(struct osd_r=
equest *or,
 	ocdb->h.v1.start_address =3D cpu_to_be64(offset);
 }
=20
+static void _osdv2_req_encode_common(struct osd_request *or,
+	 __be16 act, const struct osd_obj_id *obj, u64 offset, u64 len)
+{
+	struct osdv2_cdb *ocdb =3D &or->cdb.v2;
+
+	OSD_DEBUG("OSDv2 execute opcode 0x%x\n", be16_to_cpu(act));
+
+	ocdb->h.varlen_cdb.opcode =3D VARIABLE_LENGTH_CMD;
+	ocdb->h.varlen_cdb.additional_cdb_length =3D OSD_ADDITIONAL_CDB_LENGT=
H;
+	ocdb->h.varlen_cdb.service_action =3D act;
+
+	ocdb->h.partition =3D cpu_to_be64(obj->partition);
+	ocdb->h.object =3D cpu_to_be64(obj->id);
+	ocdb->h.v2.length =3D cpu_to_be64(len);
+	ocdb->h.v2.start_address =3D cpu_to_be64(offset);
+}
+
 static void _osd_req_encode_common(struct osd_request *or,
 	__be16 act, const struct osd_obj_id *obj, u64 offset, u64 len)
 {
-	_osdv1_req_encode_common(or, act, obj, offset, len);
+	if (osd_req_is_ver1(or))
+		_osdv1_req_encode_common(or, act, obj, offset, len);
+	else
+		_osdv2_req_encode_common(or, act, obj, offset, len);
 }
=20
 /*
@@ -519,6 +570,12 @@ void osd_req_flush_object(struct osd_request *or,
 	const struct osd_obj_id *obj, enum osd_options_flush_scope_values op,
 	/*V2*/ u64 offset, /*V2*/ u64 len)
 {
+	if (unlikely(osd_req_is_ver1(or) && (offset || len))) {
+		OSD_DEBUG("OSD Ver1 flush on specific range ignored\n");
+		offset =3D 0;
+		len =3D 0;
+	}
+
 	_osd_req_encode_common(or, OSD_ACT_FLUSH, obj, offset, len);
 	_osd_req_encode_flush(or, op);
 }
@@ -1131,6 +1188,10 @@ enum { OSD_SEC_CAP_V1_ALL_CAPS =3D
 	OSD_SEC_CAP_GLOBAL | OSD_SEC_CAP_DEV_MGMT
 };
=20
+enum { OSD_SEC_CAP_V2_ALL_CAPS =3D
+	OSD_SEC_CAP_V1_ALL_CAPS | OSD_SEC_CAP_QUERY | OSD_SEC_CAP_M_OBJECT
+};
+
 void osd_sec_init_nosec_doall_caps(void *caps,
 	const struct osd_obj_id *obj, bool is_collection, const bool is_v1)
 {
@@ -1172,9 +1233,14 @@ void osd_sec_init_nosec_doall_caps(void *caps,
 }
 EXPORT_SYMBOL(osd_sec_init_nosec_doall_caps);
=20
+/* FIXME: Extract version from caps pointer.
+ *        Also Pete's target only supports caps from OSDv1 for now
+ */
 void osd_set_caps(struct osd_cdb *cdb, const void *caps)
 {
-	memcpy(&cdb->v1.caps, caps, OSDv1_CAP_LEN);
+	bool is_ver1 =3D true;
+	/* NOTE: They start at same address */
+	memcpy(&cdb->v1.caps, caps, is_ver1 ? OSDv1_CAP_LEN : OSD_CAP_LEN);
 }
=20
 bool osd_is_sec_alldata(struct osd_security_parameters *sec_parms)
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.=
h
index a647c51..8779f66 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -21,6 +21,23 @@
=20
 /* Note: "NI" in comments below means "Not Implemented yet" */
=20
+/* Configure of code:
+ * #undef if you *don't* want OSD v1 support in runtime.
+ * If #defined the initiator will dynamically configure to encode OSD =
v1
+ * CDB's if the target is detected to be OSD v1 only.
+ * OSD v2 only commands, options, and attributes will be ignored if ta=
rget
+ * is v1 only.
+ * If #defined will result in bigger/slower code (OK Slower maybe not)
+ * Q: Should this be CONFIG_SCSI_OSD_VER1_SUPPORT and set from Kconfig=
?
+ */
+#define OSD_VER1_SUPPORT y
+
+enum osd_std_version {
+	OSD_VER_NONE =3D 0,
+	OSD_VER1 =3D 1,
+	OSD_VER2 =3D 2,
+};
+
 /*
  * Object-based Storage Device.
  * This object represents an OSD device.
@@ -31,11 +48,23 @@
 struct osd_dev {
 	struct scsi_device *scsi_dev;
 	unsigned def_timeout;
+
+#ifdef OSD_VER1_SUPPORT
+	enum osd_std_version version;
+#endif
 };
=20
 void osd_dev_init(struct osd_dev *, struct scsi_device *scsi_dev);
 void osd_dev_fini(struct osd_dev *);
=20
+/* we might want to use function vector in the future */
+static inline void osd_dev_set_ver(struct osd_dev *dev, enum osd_std_v=
ersion v)
+{
+#ifdef OSD_VER1_SUPPORT
+	dev->version =3D v;
+#endif
+}
+
 struct osd_request {
 	struct osd_cdb cdb;
 	struct osd_data_out_integrity_info out_data_integ;
@@ -65,6 +94,16 @@ struct osd_request {
 	enum osd_attributes_mode attributes_mode;
 };
=20
+/* OSD Version control */
+static inline bool osd_req_is_ver1(struct osd_request *or)
+{
+#ifdef OSD_VER1_SUPPORT
+	return or->osd_dev->version =3D=3D OSD_VER1;
+#else
+	return false;
+#endif
+}
+
 /**
  * How to use the osd library:
  *
diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
index 77a74a3..ef7505e 100644
--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -25,9 +25,12 @@ enum {
 	OSDv1_TOTAL_CDB_LEN =3D OSDv1_ADDITIONAL_CDB_LENGTH + 8,
 	OSDv1_CAP_LEN =3D 80,
 	/* Latest supported version */
-	OSD_ADDITIONAL_CDB_LENGTH =3D OSDv1_ADDITIONAL_CDB_LENGTH,
-	OSD_TOTAL_CDB_LEN =3D OSDv1_TOTAL_CDB_LEN,
-	OSD_CAP_LEN =3D OSDv1_CAP_LEN,
+/* 	OSD_ADDITIONAL_CDB_LENGTH =3D 216,*/
+	OSD_ADDITIONAL_CDB_LENGTH =3D
+		OSDv1_ADDITIONAL_CDB_LENGTH, /* FIXME: Pete rev-001 sup */
+	OSD_TOTAL_CDB_LEN =3D OSD_ADDITIONAL_CDB_LENGTH + 8,
+/* 	OSD_CAP_LEN =3D 104,*/
+	OSD_CAP_LEN =3D OSDv1_CAP_LEN,/* FIXME: Pete rev-001 sup */
=20
 	OSD_SYSTEMID_LEN =3D 20,
 	OSD_CRYPTO_KEYID_SIZE =3D 20,
@@ -108,6 +111,7 @@ enum {
 	OSD_OFFSET_MAX_BITS =3D 28,
=20
 	OSDv1_OFFSET_MIN_SHIFT =3D 8,
+	OSD_OFFSET_MIN_SHIFT =3D 3,
 	OSD_OFFSET_MAX_SHIFT =3D 16,
 };
=20
@@ -129,6 +133,16 @@ static inline osd_cdb_offset osd_encode_offset_v1(=
u64 offset, unsigned *padding)
 				OSDv1_OFFSET_MIN_SHIFT, OSD_OFFSET_MAX_SHIFT);
 }
=20
+/* Minimum 8 bytes alignment
+ * Same as v1 but since exponent can be signed than a less than
+ * 256 alignment can be reached with small offsets (<2GB)
+ */
+static inline osd_cdb_offset osd_encode_offset_v2(u64 offset, unsigned=
 *padding)
+{
+	return __osd_encode_offset(offset, padding,
+				   OSD_OFFSET_MIN_SHIFT, OSD_OFFSET_MAX_SHIFT);
+}
+
 /* osd2r03: 5.2.1 Overview */
 struct osd_cdb_head {
 	struct scsi_varlen_cdb_hdr varlen_cdb;
@@ -144,6 +158,13 @@ struct osd_cdb_head {
 /*36*/			__be64		length;
 /*44*/			__be64		start_address;
 		} __packed v1;
+
+		struct __osdv2_cdb_addr_len {
+			/* called allocation_length in some commands */
+/*32*/			__be64	length;
+/*40*/			__be64	start_address;
+/*48*/			__be32 list_identifier;/* Rarely used */
+		} __packed v2;
 	};
 /*52*/	union { /* selected attributes mode Page/List/Single */
 		struct osd_attributes_page_mode {
@@ -182,6 +203,7 @@ struct osd_cdb_head {
 /*80*/
=20
 /*160 v1*/
+/*184 v2*/
 struct osd_security_parameters {
 /*160*/u8	integrity_check_value[OSD_CRYPTO_KEYID_SIZE];
 /*180*/u8	request_nonce[OSD_CRYPTO_NONCE_SIZE];
@@ -189,6 +211,7 @@ struct osd_security_parameters {
 /*196*/osd_cdb_offset	data_out_integrity_check_offset;
 } __packed;
 /*200 v1*/
+/*224 v2*/
=20
 struct osdv1_cdb {
 	struct osd_cdb_head h;
@@ -196,9 +219,16 @@ struct osdv1_cdb {
 	struct osd_security_parameters sec_params;
 } __packed;
=20
+struct osdv2_cdb {
+	struct osd_cdb_head h;
+	u8 caps[OSD_CAP_LEN];
+	struct osd_security_parameters sec_params;
+} __packed;
+
 struct osd_cdb {
 	union {
 		struct osdv1_cdb v1;
+		struct osdv2_cdb v2;
 		u8 buff[OSD_TOTAL_CDB_LEN];
 	};
 } __packed;
@@ -269,6 +299,7 @@ struct osd_attributes_list_attrid {
 /*
  * osd2r03: 7.1.3.3 List entry format for retrieved attributes and
  *                  for setting attributes
+ * NOTE: v2 is 8-bytes aligned, v1 is not aligned.
  */
 struct osd_attributes_list_element {
 	__be32 page;
@@ -279,6 +310,7 @@ struct osd_attributes_list_element {
=20
 enum {
 	OSDv1_ATTRIBUTES_ELEM_ALIGN =3D 1,
+	OSD_ATTRIBUTES_ELEM_ALIGN =3D 8,
 };
=20
 enum {
@@ -292,6 +324,12 @@ static inline unsigned osdv1_attr_list_elem_size(u=
nsigned len)
 		     OSDv1_ATTRIBUTES_ELEM_ALIGN);
 }
=20
+static inline unsigned osdv2_attr_list_elem_size(unsigned len)
+{
+	return ALIGN(len + sizeof(struct osd_attributes_list_element),
+		     OSD_ATTRIBUTES_ELEM_ALIGN);
+}
+
 /*
  * osd2r03: 7.1.3 OSD attributes lists (Table 184) =E2=80=94 List type=
 values
  */
@@ -326,6 +364,21 @@ static inline unsigned osdv1_list_size(struct osdv=
1_attributes_list_header *h)
 	return be16_to_cpu(h->list_bytes);
 }
=20
+struct osdv2_attributes_list_header {
+	u8 type;	/* lower 4-bits only */
+	u8 pad[3];
+/*4*/	__be32 list_bytes; /* Initiator shall set to zero. Only set by t=
arget */
+	/*
+	 * type=3D9 followed by struct osd_attributes_list_element's
+	 * type=3DE followed by struct osd_attributes_list_multi_header's
+	 */
+} __packed;
+
+static inline unsigned osdv2_list_size(struct osdv2_attributes_list_he=
ader *h)
+{
+	return be32_to_cpu(h->list_bytes);
+}
+
 /* (osd-r10 6.13)
  * osd2r03: 6.15 LIST (Table 79) LIST command parameter data.
  *	for root_lstchg below
@@ -469,11 +522,36 @@ struct osdv1_cap_object_descriptor {
 } __packed;
 /*80 v1*/
=20
-struct osd_capability {
+/*56 v2*/
+struct osd_cap_object_descriptor {
+	union {
+		struct {
+			__be32 allowed_attributes_access;
+/*60*/			__be32 policy_access_tag;
+/*64*/			__be16 boot_epoch;
+/*66*/			u8 reserved[72-66];
+/*72*/			__be64 allowed_partition_id;
+/*80*/			__be64 allowed_object_id;
+/*88*/			__be64 allowed_range_length;
+/*96*/			__be64 allowed_range_start;
+		} __packed obj_desc;
+
+		u8 object_descriptor[104-56]; /*48*/
+	};
+} __packed;
+/*104 v2*/
+
+struct osdv1_capability {
 	struct osd_capability_head h;
 	struct osdv1_cap_object_descriptor od;
 } __packed;
=20
+struct osd_capability {
+	struct osd_capability_head h;
+/* 	struct osd_cap_object_descriptor od;*/
+	struct osdv1_cap_object_descriptor od; /* FIXME: Pete rev-001 sup */
+} __packed;
+
 /**
  * osd_sec_set_caps - set cap-bits into the capabilities header
  *
--=20
1.5.6.rc1.5.gadf6


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
