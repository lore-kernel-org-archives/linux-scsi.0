From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 01/14] libosd: OSDv1 Headers
Date: Thu, 24 Jul 2008 20:40:53 +0300
Message-ID: <4888BEA5.2090104@panasas.com>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11983 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751439AbYGXRm2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 13:42:28 -0400
In-Reply-To: <4888BC3B.1050406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-osd development <osd-dev@open-osd.org>
Cc: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


Headers only patch.

osd_protocol.h
	Contains a C-fied definition of the T10 OSD standard
osd_types.h
	Contains CPU order common used types
osd_initiator.h
	API definition of the osd_initiator library
osd_sec.h
	Contains High level API for the security manager.

[Note that checkpatch spews errors on things that are valid in this con=
text
and will not be fixed]

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 include/scsi/osd_initiator.h |  311 ++++++++++++++++++++++++++
 include/scsi/osd_protocol.h  |  497 ++++++++++++++++++++++++++++++++++=
++++++++
 include/scsi/osd_sec.h       |   45 ++++
 include/scsi/osd_types.h     |   40 ++++
 4 files changed, 893 insertions(+), 0 deletions(-)
 create mode 100644 include/scsi/osd_initiator.h
 create mode 100644 include/scsi/osd_protocol.h
 create mode 100644 include/scsi/osd_sec.h
 create mode 100644 include/scsi/osd_types.h

diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.=
h
new file mode 100644
index 0000000..a647c51
--- /dev/null
+++ b/include/scsi/osd_initiator.h
@@ -0,0 +1,311 @@
+/*
+ * osd_initiator.h - OSD initiator API definition
+ *
+ * Copyright (C) 2008 Panasas Inc.  All rights reserved.
+ *
+ * Authors:
+ *   Boaz Harrosh <bharrosh@panasas.com>
+ *   Benny Halevy <bhalevy@panasas.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2
+ *
+ */
+#ifndef __OSD_INITIATOR_H__
+#define __OSD_INITIATOR_H__
+
+#include <linux/blkdev.h>
+
+#include "osd_protocol.h"
+#include "osd_types.h"
+
+/* Note: "NI" in comments below means "Not Implemented yet" */
+
+/*
+ * Object-based Storage Device.
+ * This object represents an OSD device.
+ * It is not a full linux device in any way. It is only
+ * a place to hang resources associated with a Linux
+ * request Q and some default properties.
+ */
+struct osd_dev {
+	struct scsi_device *scsi_dev;
+	unsigned def_timeout;
+};
+
+void osd_dev_init(struct osd_dev *, struct scsi_device *scsi_dev);
+void osd_dev_fini(struct osd_dev *);
+
+struct osd_request {
+	struct osd_cdb cdb;
+	struct osd_data_out_integrity_info out_data_integ;
+	struct osd_data_in_integrity_info in_data_integ;
+
+	struct osd_dev *osd_dev;
+	struct request *request;
+
+	struct _osd_req_data_segment {
+		void *buff;
+		unsigned alloc_size; /* 0 here means not allocated by us */
+		unsigned total_bytes;
+	} set_attr, enc_get_attr, get_attr;
+
+	struct _osd_io_info {
+		struct bio *bio;
+		u64 total_bytes;
+		struct request *req;
+		struct _osd_req_data_segment *last_seg;
+		u8 *pad_buff;
+	} out, in;
+
+	gfp_t alloc_flags;
+	unsigned timeout;
+	unsigned retries;
+	u8 sense[OSD_MAX_SENSE_LEN];
+	enum osd_attributes_mode attributes_mode;
+};
+
+/**
+ * How to use the osd library:
+ *
+ * osd_start_request
+ *	Allocates a request.
+ *
+ * osd_req_*
+ *	Call one of, to encode the desired operation.
+ *
+ * osd_add_{get,set}_attr
+ *	Optionally add attributes to the CDB, list or page mode.
+ *
+ * osd_finalize_request
+ *	Computes final data out/in offsets and signs the request,
+ *	making it ready for execution.
+ *
+ * osd_execute_request
+ *	May be called to execute it through the block layer. Other wise sub=
mit
+ *	the associated block request in some other way.
+ *
+ * After execution:
+ * osd_req_decode_sense
+ *	Decodes sense information to verify execution results.
+ *
+ * osd_req_decode_get_attr
+ *	Retrieve osd_add_get_attr_list() values if used.
+ *
+ * osd_end_request
+ *	Must be called to deallocate the request.
+ */
+
+/**
+ * osd_start_request - Allocate and initialize an osd_request
+ *
+ * @osd_dev:    OSD device that holds the scsi-device and default valu=
es
+ *              that the request is associated with.
+ * @gfp:        The allocation flags to use for request allocation, an=
d all
+ *              subsequent allocations. This will be stored at
+ *              osd_request->alloc_flags, can be changed by user later
+ *
+ * Allocate osd_request and initialize all members to the
+ * default/initial state.
+ */
+struct osd_request *osd_start_request(struct osd_dev *, gfp_t gfp);
+
+enum osd_req_options {
+	OSD_REQ_FUA =3D 0x08,	/* Force Unit Access */
+	OSD_REQ_DPO =3D 0x10,	/* Disable Page Out */
+
+	OSD_REQ_BYPASS_TIMESTAMPS =3D 0x80,
+};
+
+/**
+ * osd_finalize_request - Sign request and prepare request for executi=
on
+ *
+ * @or:		osd_request to prepare
+ * @options:	combination of osd_req_options bit flags or 0.
+ * @cap	A Pointer to an OSD_CAP_LEN bytes buffer that is received from
+ *              The security manager as capabilities for this cdb.
+ * @cap_key	The cryptographic key used to sign the cdb/data. Can be nu=
ll
+ *              if NOSEC is used.
+ *
+ * The actual request and bios are only allocated here, so are the get=
_attr
+ * buffers that will receive the returned attributes. Copy's @cap to c=
db.
+ * Sign the cdb/data with @cap_key.
+ */
+int osd_finalize_request(struct osd_request *or,
+	u8 options, const void *cap, const u8 *cap_key);
+
+/**
+ * osd_execute_request - Execute the request synchronously through
+ *                       the block-layer
+ * @or:		osd_request to Executed
+ *
+ * Calls blk_execute_rq to q the command and waits for completion.
+ */
+int osd_execute_request(struct osd_request *or);
+
+/**
+ * osd_end_request - return osd_request to free store
+ *
+ * @or:		osd_request to free
+ *
+ * Deallocate all osd_request resources (struct req's, BIOs, buffers, =
etc.)
+ */
+void osd_end_request(struct osd_request *or);
+
+/*
+ * CDB Encoding
+ *
+ * Note: call only one of the following methods.
+ */
+
+/*
+ * Device commands
+ */
+void osd_req_set_master_seed_xchg(struct osd_request *, ...);/* NI */
+void osd_req_set_master_key(struct osd_request *, ...);/* NI */
+
+void osd_req_format(struct osd_request *, u64 tot_capacity);
+
+/* list all partitions
+ * @list header must be initialized to zero on first run.
+ *
+ * Call osd_is_obj_list_done() to find if we got the complete list.
+ */
+int osd_req_list_dev_partitions(struct osd_request *,
+	osd_id initial_id, struct osd_obj_id_list *list, unsigned nelem);
+
+void osd_req_flush_obsd(struct osd_request *,
+	enum osd_options_flush_scope_values);
+
+void osd_req_perform_scsi_command(struct osd_request *,
+	const u8 *cdb, ...);/* NI */
+void osd_req_task_management(struct osd_request *, ...);/* NI */
+
+/*
+ * Partition commands
+ */
+void osd_req_create_partition(struct osd_request *, osd_id partition);
+void osd_req_remove_partition(struct osd_request *, osd_id partition);
+
+void osd_req_set_partition_key(struct osd_request *,
+	osd_id partition, u8 new_key_id[OSD_CRYPTO_KEYID_SIZE],
+	u8 seed[OSD_CRYPTO_SEED_SIZE]);/* NI */
+
+/* list all collections in the partition
+ * @list header must be init to zero on first run.
+ *
+ * Call osd_is_obj_list_done() to find if we got the complete list.
+ */
+int osd_req_list_partition_collections(struct osd_request *,
+	osd_id partition, osd_id initial_id, struct osd_obj_id_list *list,
+	unsigned nelem);
+
+/* list all objects in the partition
+ * @list header must be init to zero on first run.
+ *
+ * Call osd_is_obj_list_done() to find if we got the complete list.
+ */
+int osd_req_list_partition_objects(struct osd_request *,
+	osd_id partition, osd_id initial_id, struct osd_obj_id_list *list,
+	unsigned nelem);
+
+void osd_req_flush_partition(struct osd_request *,
+	osd_id partition, enum osd_options_flush_scope_values);
+
+/*
+ * Collection commands
+ */
+void osd_req_create_collection(struct osd_request *,
+	const struct osd_obj_id *);/* NI */
+void osd_req_remove_collection(struct osd_request *,
+	const struct osd_obj_id *);/* NI */
+
+/* list all objects in the collection */
+int osd_req_list_collection_objects(struct osd_request *,
+	const struct osd_obj_id *, osd_id initial_id,
+	struct osd_obj_id_list *list, unsigned nelem);
+
+/* V2 only filtered list of objects in the collection */
+void osd_req_query(struct osd_request *, ...);/* NI */
+
+void osd_req_flush_collection(struct osd_request *,
+	const struct osd_obj_id *, enum osd_options_flush_scope_values);
+
+void osd_req_get_member_attrs(struct osd_request *, ...);/* V2-only NI=
 */
+void osd_req_set_member_attrs(struct osd_request *, ...);/* V2-only NI=
 */
+
+/*
+ * Object commands
+ */
+void osd_req_create_object(struct osd_request *, struct osd_obj_id *);
+void osd_req_remove_object(struct osd_request *, struct osd_obj_id *);
+
+void osd_req_write(struct osd_request *,
+	const struct osd_obj_id *, struct bio *data_out, u64 offset);
+void osd_req_append(struct osd_request *,
+	const struct osd_obj_id *, struct bio *data_out);/* NI */
+void osd_req_create_write(struct osd_request *,
+	const struct osd_obj_id *, struct bio *data_out, u64 offset);/* NI */
+void osd_req_clear(struct osd_request *,
+	const struct osd_obj_id *, u64 offset, u64 len);/* NI */
+void osd_req_punch(struct osd_request *,
+	const struct osd_obj_id *, u64 offset, u64 len);/* V2-only NI */
+
+void osd_req_flush_object(struct osd_request *,
+	const struct osd_obj_id *, enum osd_options_flush_scope_values,
+	/*V2*/ u64 offset, /*V2*/ u64 len);
+
+void osd_req_read(struct osd_request *,
+	const struct osd_obj_id *, struct bio *data_in, u64 offset);
+
+/*
+ * Root/Partition/Collection/Object Attributes commands
+ */
+
+/* get before set */
+void osd_req_get_attributes(struct osd_request *, const struct osd_obj=
_id *);
+
+/* set before get */
+void osd_req_set_attributes(struct osd_request *, const struct osd_obj=
_id *);
+
+/*
+ * Attributes appended to most commands
+ */
+
+/* Attributes List mode (or V2 CDB) */
+  /*
+   * TODO: In ver2 if at finalize time only one attr was set and no ge=
ts,
+   * then the Attributes CDB mode is used automatically to save IO.
+   */
+
+/* set a list of attributes. */
+int osd_req_add_set_attr_list(struct osd_request *,
+	const struct osd_attr *, unsigned nelem);
+
+/* get a list of attributes */
+int osd_req_add_get_attr_list(struct osd_request *,
+	const struct osd_attr *, unsigned nelem);
+
+/*
+ * Attributes list decoding
+ * Must be called after osd_request.request was executed
+ * It is called in a loop to decode the returned get_attr
+ * (see osd_add_get_attr)
+ */
+int osd_req_decode_get_attr_list(struct osd_request *,
+	struct osd_attr *, int *nelem, void **iterator);
+
+/* Attributes Page mode */
+
+/*
+ * Read an attribute page and optionally set one attribute
+ *
+ * Retrieves the attribute page directly to a user buffer.
+ * @attr_page_data shall stay valid until end of execution.
+ * See osd_attributes.h for common page structures
+ */
+int osd_req_add_get_attr_page(struct osd_request *,
+	u32 page_id, void *attr_page_data, unsigned max_page_len,
+	const struct osd_attr *set_one);
+
+#endif /* __OSD_LIB_H__ */
diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
new file mode 100644
index 0000000..77a74a3
--- /dev/null
+++ b/include/scsi/osd_protocol.h
@@ -0,0 +1,497 @@
+/*
+ * osd_protocol.h - OSD T10 standard C definitions.
+ *
+ * Copyright (C) 2008 Panasas Inc.  All rights reserved.
+ *
+ * Authors:
+ *   Boaz Harrosh <bharrosh@panasas.com>
+ *   Benny Halevy <bhalevy@panasas.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2
+ *
+ * This file contains types and constants that are defined by the prot=
ocol
+ * Note: All names and symbols are taken from the OSD standard's text.
+ */
+#ifndef __OSD_PROTOCOL_H__
+#define __OSD_PROTOCOL_H__
+
+#include <linux/types.h>
+#include <asm/unaligned.h>
+#include <scsi/scsi.h>
+
+enum {
+	OSDv1_ADDITIONAL_CDB_LENGTH =3D 192,
+	OSDv1_TOTAL_CDB_LEN =3D OSDv1_ADDITIONAL_CDB_LENGTH + 8,
+	OSDv1_CAP_LEN =3D 80,
+	/* Latest supported version */
+	OSD_ADDITIONAL_CDB_LENGTH =3D OSDv1_ADDITIONAL_CDB_LENGTH,
+	OSD_TOTAL_CDB_LEN =3D OSDv1_TOTAL_CDB_LEN,
+	OSD_CAP_LEN =3D OSDv1_CAP_LEN,
+
+	OSD_SYSTEMID_LEN =3D 20,
+	OSD_CRYPTO_KEYID_SIZE =3D 20,
+	OSD_CRYPTO_SEED_SIZE =3D 4,
+	OSD_CRYPTO_NONCE_SIZE =3D 12,
+	OSD_MAX_SENSE_LEN =3D 252, /* from SPC-3 */
+
+	OSD_PARTITION_FIRST_ID =3D 0x10000,
+	OSD_OBJECT_FIRST_ID =3D 0x10000,
+};
+
+/* (osd-r10 5.2.4)
+ * osd2r03: 5.2.3 Caching control bits
+ */
+enum osd_options_byte {
+	OSD_CDB_FUA =3D 0x08,	/* Force Unit Access */
+	OSD_CDB_DPO =3D 0x10,	/* Disable Page Out */
+};
+
+/*
+ * osd2r03: 5.2.5 Isolation.
+ * First 3 bits, V2-only.
+ * Also for attr 110h "default isolation method" at Root Information p=
age
+ */
+enum osd_options_byte_isolation {
+	OSD_ISOLATION_DEFAULT =3D 0,
+	OSD_ISOLATION_NONE =3D 1,
+	OSD_ISOLATION_STRICT =3D 2,
+	OSD_ISOLATION_RANGE =3D 4,
+	OSD_ISOLATION_FUNCTIONAL =3D 5,
+	OSD_ISOLATION_VENDOR =3D 7,
+};
+
+/* (osd-r10: 6.7)
+ * osd2r03: 6.8 FLUSH, FLUSH COLLECTION, FLUSH OSD, FLUSH PARTITION
+ */
+enum osd_options_flush_scope_values {
+	OSD_CDB_FLUSH_ALL =3D 0,
+	OSD_CDB_FLUSH_ATTR_ONLY =3D 1,
+
+	OSD_CDB_FLUSH_ALL_RECURSIVE =3D 2,
+	/* V2-only */
+	OSD_CDB_FLUSH_ALL_RANGE =3D 2,
+};
+
+/* osd2r03: 5.2.10 Timestamps control */
+enum {
+	OSD_CDB_NORMAL_TIMESTAMPS =3D 0,
+	OSD_CDB_BYPASS_TIMESTAMPS =3D 0x7f,
+};
+
+/* (osd-r10: 5.2.2.1)
+ * osd2r03: 5.2.4.1 Get and set attributes CDB format selection
+ *	2 bits at second nibble of command_specific_options byte
+ */
+enum osd_attributes_mode {
+	/* V2-only */
+	OSD_CDB_SET_ONE_ATTR =3D 0x10,
+
+	OSD_CDB_GET_ATTR_PAGE_SET_ONE =3D 0x20,
+	OSD_CDB_GET_SET_ATTR_LISTS =3D 0x30,
+
+	OSD_CDB_GET_SET_ATTR_MASK =3D 0x30,
+};
+
+/* (osd-r10: 4.12.5)
+ * osd2r03: 4.14.5 Data-In and Data-Out buffer offsets
+ *	byte offset =3D mantissa * (2^(exponent+8))
+ *	struct {
+ *		unsigned mantissa: 28;
+ *		int exponent: 04;
+ *	}
+ */
+typedef __be32 __bitwise osd_cdb_offset;
+
+enum {
+	OSD_OFFSET_UNUSED =3D 0xFFFFFFFF,
+	OSD_OFFSET_MAX_BITS =3D 28,
+
+	OSDv1_OFFSET_MIN_SHIFT =3D 8,
+	OSD_OFFSET_MAX_SHIFT =3D 16,
+};
+
+/* Return the smallest allowed encoded offset that contains @offset.
+ *
+ * The actual encoded offset returned is @offset + *padding.
+ * (up to max_shift, non-inclusive)
+ */
+osd_cdb_offset __osd_encode_offset(u64 offset, unsigned *padding,
+	int min_shift, int max_shift);
+
+/* Minimum alignment is 256 bytes
+ * Note: Seems from std v1 that exponent can be from 0+8 to 0xE+8 (inc=
lusive)
+ * which is 8 to 23 but IBM code restricts it to 16, so be it.
+ */
+static inline osd_cdb_offset osd_encode_offset_v1(u64 offset, unsigned=
 *padding)
+{
+	return __osd_encode_offset(offset, padding,
+				OSDv1_OFFSET_MIN_SHIFT, OSD_OFFSET_MAX_SHIFT);
+}
+
+/* osd2r03: 5.2.1 Overview */
+struct osd_cdb_head {
+	struct scsi_varlen_cdb_hdr varlen_cdb;
+/*10*/	u8		options;
+	u8		command_specific_options;
+	u8		timestamp_control;
+/*13*/	u8		reserved1[3];
+/*16*/	__be64		partition;
+/*24*/	__be64		object;
+/*32*/	union { /* V1 vs V2 alignment differences */
+		struct __osdv1_cdb_addr_len {
+/*32*/			__be32 		list_identifier;/* Rarely used */
+/*36*/			__be64		length;
+/*44*/			__be64		start_address;
+		} __packed v1;
+	};
+/*52*/	union { /* selected attributes mode Page/List/Single */
+		struct osd_attributes_page_mode {
+/*52*/			__be32		get_attr_page;
+/*56*/			__be32		get_attr_alloc_length;
+/*60*/			osd_cdb_offset	get_attr_offset;
+
+/*64*/			__be32		set_attr_page;
+/*68*/			__be32		set_attr_id;
+/*72*/			__be32		set_attr_length;
+/*76*/			osd_cdb_offset	set_attr_offset;
+		} __packed attrs_page;
+
+		struct osd_attributes_list_mode {
+/*52*/			__be32		get_attr_desc_bytes;
+/*56*/			osd_cdb_offset	get_attr_desc_offset;
+
+/*60*/			__be32		get_attr_alloc_length;
+/*64*/			osd_cdb_offset	get_attr_offset;
+
+/*68*/			__be32		set_attr_bytes;
+/*72*/			osd_cdb_offset	set_attr_offset;
+			__be32 not_used;
+		} __packed attrs_list;
+
+		/* osd2r03:5.2.4.2 Set one attribute value using CDB fields */
+		struct osd_attributes_cdb_mode {
+/*52*/			__be32		set_attr_page;
+/*56*/			__be32		set_attr_id;
+/*60*/			__be16		set_attr_len;
+/*62*/			u8		set_attr_val[80-62];
+		} __packed attrs_cdb;
+/*52*/		u8 get_set_attributes_parameters[80-52];
+	};
+} __packed;
+/*80*/
+
+/*160 v1*/
+struct osd_security_parameters {
+/*160*/u8	integrity_check_value[OSD_CRYPTO_KEYID_SIZE];
+/*180*/u8	request_nonce[OSD_CRYPTO_NONCE_SIZE];
+/*192*/osd_cdb_offset	data_in_integrity_check_offset;
+/*196*/osd_cdb_offset	data_out_integrity_check_offset;
+} __packed;
+/*200 v1*/
+
+struct osdv1_cdb {
+	struct osd_cdb_head h;
+	u8 caps[OSDv1_CAP_LEN];
+	struct osd_security_parameters sec_params;
+} __packed;
+
+struct osd_cdb {
+	union {
+		struct osdv1_cdb v1;
+		u8 buff[OSD_TOTAL_CDB_LEN];
+	};
+} __packed;
+
+static inline struct osd_cdb_head *osd_cdb_head(struct osd_cdb *ocdb)
+{
+	return (struct osd_cdb_head *)ocdb->buff;
+}
+
+/* define both version actions
+ * Ex name =3D FORMAT_OSD we have OSD_ACT_FORMAT_OSD && OSDv1_ACT_FORM=
AT_OSD
+ */
+#define OSD_ACT___(Name, Num) \
+	OSD_ACT_##Name =3D __constant_cpu_to_be16(0x8880 + Num), \
+	OSDv1_ACT_##Name =3D __constant_cpu_to_be16(0x8800 + Num),
+
+/* V2 only actions */
+#define OSD_ACT_V2(Name, Num) \
+	OSD_ACT_##Name =3D __constant_cpu_to_be16(0x8880 + Num),
+
+#define OSD_ACT_V1_V2(Name, Num1, Num2) \
+	OSD_ACT_##Name =3D __constant_cpu_to_be16(Num2), \
+	OSDv1_ACT_##Name =3D __constant_cpu_to_be16(Num1),
+
+enum osd_service_actions {
+	OSD_ACT_V2(OBJECT_STRUCTURE_CHECK,	0x00)
+	OSD_ACT___(FORMAT_OSD,			0x01)
+	OSD_ACT___(CREATE,			0x02)
+	OSD_ACT___(LIST,			0x03)
+	OSD_ACT_V2(PUNCH,			0x04)
+	OSD_ACT___(READ,			0x05)
+	OSD_ACT___(WRITE,			0x06)
+	OSD_ACT___(APPEND,			0x07)
+	OSD_ACT___(FLUSH,			0x08)
+	OSD_ACT_V2(CLEAR,			0x09)
+	OSD_ACT___(REMOVE,			0x0A)
+	OSD_ACT___(CREATE_PARTITION,		0x0B)
+	OSD_ACT___(REMOVE_PARTITION,		0x0C)
+	OSD_ACT___(GET_ATTRIBUTES,		0x0E)
+	OSD_ACT___(SET_ATTRIBUTES,		0x0F)
+	OSD_ACT___(CREATE_AND_WRITE,		0x12)
+	OSD_ACT___(CREATE_COLLECTION,		0x15)
+	OSD_ACT___(REMOVE_COLLECTION,		0x16)
+	OSD_ACT___(LIST_COLLECTION,		0x17)
+	OSD_ACT___(SET_KEY,			0x18)
+	OSD_ACT___(SET_MASTER_KEY,		0x19)
+	OSD_ACT___(FLUSH_COLLECTION,		0x1A)
+	OSD_ACT___(FLUSH_PARTITION,		0x1B)
+	OSD_ACT___(FLUSH_OSD,			0x1C)
+
+	OSD_ACT_V2(QUERY,			0x20)
+	OSD_ACT_V2(REMOVE_MEMBER_OBJECTS,	0x21)
+	OSD_ACT_V2(GET_MEMBER_ATTRIBUTES,	0x22)
+	OSD_ACT_V2(SET_MEMBER_ATTRIBUTES,	0x23)
+	OSD_ACT_V2(READ_MAP,			0x31)
+
+	OSD_ACT_V1_V2(PERFORM_SCSI_COMMAND,	0x8F7E, 0x8F7C)
+	OSD_ACT_V1_V2(SCSI_TASK_MANAGEMENT,	0x8F7F, 0x8F7D)
+	/* 0x8F80 to 0x8FFF are Vendor specific */
+};
+
+/* osd2r03: 7.1.3.2 List entry format for retrieving attributes */
+struct osd_attributes_list_attrid {
+	__be32 page;
+	__be32 attr_id;
+} __packed;
+
+/*
+ * osd2r03: 7.1.3.3 List entry format for retrieved attributes and
+ *                  for setting attributes
+ */
+struct osd_attributes_list_element {
+	__be32 page;
+	__be32 attr_id;
+	__be16 attr_bytes;
+	u8 attr_val[0];
+} __packed;
+
+enum {
+	OSDv1_ATTRIBUTES_ELEM_ALIGN =3D 1,
+};
+
+enum {
+	OSD_ATTR_LIST_ALL_PAGES =3D 0xFFFFFFFF,
+	OSD_ATTR_LIST_ALL_IN_PAGE =3D 0xFFFFFFFF,
+};
+
+static inline unsigned osdv1_attr_list_elem_size(unsigned len)
+{
+	return ALIGN(len + sizeof(struct osd_attributes_list_element),
+		     OSDv1_ATTRIBUTES_ELEM_ALIGN);
+}
+
+/*
+ * osd2r03: 7.1.3 OSD attributes lists (Table 184) =E2=80=94 List type=
 values
+ */
+enum osd_attr_list_types {
+	OSD_ATTR_LIST_GET =3D 0x1, 	/* descriptors only */
+	OSD_ATTR_LIST_SET_RETRIEVE =3D 0x9, /*descriptors/values variable-len=
gth*/
+	OSD_V2_ATTR_LIST_MULTIPLE =3D 0xE,  /* ver2, Multiple Objects lists*/
+	OSD_V1_ATTR_LIST_CREATE_MULTIPLE =3D 0xF,/*ver1, used by create_multp=
le*/
+};
+
+/* osd2r03: 7.1.3.4 Multi-object retrieved attributes format */
+struct osd_attributes_list_multi_header {
+	__be64 object_id;
+	u8 object_type; /* object_type enum below */
+	u8 reserved[5];
+	__be16 list_bytes;
+	/* followed by struct osd_attributes_list_element's */
+};
+
+struct osdv1_attributes_list_header {
+	u8 type;	/* low 4-bit only */
+	u8 pad;
+	__be16 list_bytes; /* Initiator shall set to Zero. Only set by target=
 */
+	/*
+	 * type=3D9 followed by struct osd_attributes_list_element's
+	 * type=3DE followed by struct osd_attributes_list_multi_header's
+	 */
+} __packed;
+
+static inline unsigned osdv1_list_size(struct osdv1_attributes_list_he=
ader *h)
+{
+	return be16_to_cpu(h->list_bytes);
+}
+
+/* (osd-r10 6.13)
+ * osd2r03: 6.15 LIST (Table 79) LIST command parameter data.
+ *	for root_lstchg below
+ */
+enum {
+	OSD_OBJ_ID_LIST_PAR =3D 0x1, /* V1-only. Not used in V2 */
+	OSD_OBJ_ID_LIST_LSTCHG =3D 0x2,
+};
+
+/*
+ * osd2r03: 6.15.2 LIST command parameter data
+ * (Also for LIST COLLECTION)
+ */
+struct osd_obj_id_list {
+	__be64 list_bytes; /* bytes in list excluding list_bytes (-8) */
+	__be64 continuation_id;
+	__be32 list_identifier;
+	u8 pad[3];
+	u8 root_lstchg;
+	__be64 object_ids[0];
+} __packed;
+
+static inline bool osd_is_obj_list_done(struct osd_obj_id_list *list,
+	bool *is_changed)
+{
+	*is_changed =3D (0 !=3D (list->root_lstchg & OSD_OBJ_ID_LIST_LSTCHG))=
;
+	return 0 !=3D list->continuation_id;
+}
+
+/*
+ * osd2r03: 4.12.4.5 The ALLDATA security method
+ */
+struct osd_data_out_integrity_info {
+	__be64 data_bytes;
+	__be64 set_attributes_bytes;
+	__be64 get_attributes_bytes;
+	__be64 integrity_check_value;
+} __packed;
+
+struct osd_data_in_integrity_info {
+	__be64 data_bytes;
+	__be64 retrieved_attributes_bytes;
+	__be64 integrity_check_value;
+} __packed;
+
+struct osd_timestamp {
+	u8 time[6]; /* number of milliseconds since 1/1/1970 UT (big endian) =
*/
+} __packed;
+/* FIXME: define helper functions to convert to/from osd time format *=
/
+
+/*
+ * Capability & Security definitions
+ * osd2r03: 4.11.2.2 Capability format
+ * osd2r03: 5.2.8 Security parameters
+ */
+
+struct osd_key_identifier {
+	u8 id[7]; /* if you know why 7 please email bharrosh@panasas.com */
+} __packed;
+
+/* for osd_capability.format */
+enum {
+	OSD_SEC_CAP_FORMAT_NO_CAPS =3D 0,
+	OSD_SEC_CAP_FORMAT_VER1 =3D 1,
+	OSD_SEC_CAP_FORMAT_VER2 =3D 2,
+};
+
+/* security_method */
+enum {
+	OSD_SEC_NOSEC =3D 0,
+	OSD_SEC_CAPKEY =3D 1,
+	OSD_SEC_CMDRSP =3D 2,
+	OSD_SEC_ALLDATA =3D 3,
+};
+
+enum object_type {
+	OSD_SEC_OBJ_ROOT =3D 0x1,
+	OSD_SEC_OBJ_PARTITION =3D 0x2,
+	OSD_SEC_OBJ_COLLECTION =3D 0x40,
+	OSD_SEC_OBJ_USER =3D 0x80,
+};
+
+enum osd_capability_bit_masks {
+	OSD_SEC_CAP_APPEND	=3D (1 << 0),
+	OSD_SEC_CAP_OBJ_MGMT	=3D (1 << 1),
+	OSD_SEC_CAP_REMOVE	=3D (1 << 2),
+	OSD_SEC_CAP_CREATE	=3D (1 << 3),
+	OSD_SEC_CAP_SET_ATTR	=3D (1 << 4),
+	OSD_SEC_CAP_GET_ATTR	=3D (1 << 5),
+	OSD_SEC_CAP_WRITE	=3D (1 << 6),
+	OSD_SEC_CAP_READ	=3D (1 << 7),
+
+	OSD_SEC_CAP_NONE1	=3D (1 << 8),
+	OSD_SEC_CAP_NONE2	=3D (1 << 9),
+	OSD_SEC_CAP_NONE3	=3D (1 << 10),
+	OSD_SEC_CAP_QUERY	=3D (1 << 11), /*v2 only*/
+	OSD_SEC_CAP_M_OBJECT	=3D (1 << 12), /*v2 only*/
+	OSD_SEC_CAP_POL_SEC	=3D (1 << 13),
+	OSD_SEC_CAP_GLOBAL	=3D (1 << 14),
+	OSD_SEC_CAP_DEV_MGMT	=3D (1 << 15),
+};
+
+/* for object_descriptor_type (hi nibble used) */
+enum {
+	OSD_SEC_OBJ_DESC_NONE =3D 0,     /* Not allowed */
+	OSD_SEC_OBJ_DESC_OBJ =3D 1 << 4, /* v1: also collection */
+	OSD_SEC_OBJ_DESC_PAR =3D 2 << 4, /* also root */
+	OSD_SEC_OBJ_DESC_COL =3D 3 << 4, /* v2 only */
+};
+
+/* (osd-r10:4.9.2.2)
+ * osd2r03:4.11.2.2 Capability format
+ */
+struct osd_capability_head {
+	u8 format; /* low nibble */
+	u8 integrity_algorithm__key_version; /* MAKE_BYTE(integ_alg, key_ver)=
 */
+	u8 security_method;
+	u8 reserved1;
+/*04*/	struct osd_timestamp expiration_time;
+/*10*/	u8 audit[30-10];
+/*30*/	u8 discriminator[42-30];
+/*42*/	struct osd_timestamp object_created_time;
+/*48*/	u8 object_type;
+	u8 permissions_bit_mask[54-49];
+/*54*/	u8 reserved2;
+/*55*/	u8 object_descriptor_type; /* high nibble */
+} __packed;
+
+/*56 v1*/
+struct osdv1_cap_object_descriptor {
+	union {
+		struct {
+/*56*/			__be32 policy_access_tag;
+/*60*/			__be64 allowed_partition_id;
+/*68*/			__be64 allowed_object_id;
+/*76*/			__be32 reserved;
+		} __packed obj_desc;
+
+		u8 object_descriptor[80-56];/*24*/
+	};
+} __packed;
+/*80 v1*/
+
+struct osd_capability {
+	struct osd_capability_head h;
+	struct osdv1_cap_object_descriptor od;
+} __packed;
+
+/**
+ * osd_sec_set_caps - set cap-bits into the capabilities header
+ *
+ * @cap:	The osd_capability_head to set cap bits to.
+ * @bit_mask: 	Use an ORed list of enum osd_capability_bit_masks value=
s
+ *
+ * permissions_bit_mask is unaligned use below to set into caps
+ * in a version independent way
+ */
+static inline void osd_sec_set_caps(struct osd_capability_head *cap,
+	u16 bit_mask)
+{
+	/*
+	 *Note: The bits above are defined LE order this is because this way
+	 *      they can grow in the future to more then 16, and still retain
+	 *      there constant values.
+	 */
+	put_unaligned_le16(bit_mask, &cap->permissions_bit_mask);
+}
+
+#endif /* ndef __OSD_PROTOCOL_H__ */
diff --git a/include/scsi/osd_sec.h b/include/scsi/osd_sec.h
new file mode 100644
index 0000000..4c09fee
--- /dev/null
+++ b/include/scsi/osd_sec.h
@@ -0,0 +1,45 @@
+/*
+ * osd_sec.h - OSD security manager API
+ *
+ * Copyright (C) 2008 Panasas Inc.  All rights reserved.
+ *
+ * Authors:
+ *   Boaz Harrosh <bharrosh@panasas.com>
+ *   Benny Halevy <bhalevy@panasas.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2
+ *
+ */
+#ifndef __OSD_SEC_H__
+#define __OSD_SEC_H__
+
+#include "osd_protocol.h"
+#include "osd_types.h"
+
+/*
+ * Contains types and constants of osd capabilities and security
+ * encoding/decoding.
+ * API is trying to keep security abstract so initiator of an object
+ * based pNFS client knows as little as possible about security and
+ * capabilities. It is the Server's osd-initiator place to know more.
+ * Also can be used by osd-target.
+ */
+void osd_sec_encode_caps(void *caps, ...);/* NI */
+void osd_sec_init_nosec_doall_caps(void *caps,
+	const struct osd_obj_id *obj, bool is_collection, const bool is_v1);
+
+bool osd_is_sec_alldata(struct osd_security_parameters *sec_params);
+
+/* Conditionally sign the CDB according to security setting in ocdb
+ * with cap_key */
+void osd_sec_sign_cdb(struct osd_cdb *ocdb, const u8 *cap_key);
+
+/* Unconditionally sign the BIO data with cap_key.
+ * Check for osd_is_sec_alldata() was done prior to calling this. */
+void osd_sec_sign_data(void *data_integ, struct bio *bio, const u8 *ca=
p_key);
+
+/* Version independent copy of caps into the cdb */
+void osd_set_caps(struct osd_cdb *cdb, const void *caps);
+
+#endif /* ndef __OSD_SEC_H__ */
diff --git a/include/scsi/osd_types.h b/include/scsi/osd_types.h
new file mode 100644
index 0000000..ea5372d
--- /dev/null
+++ b/include/scsi/osd_types.h
@@ -0,0 +1,40 @@
+/*
+ * osd_types.h - Types and constants which are not part of the protoco=
l.
+ *
+ * Copyright (C) 2008 Panasas Inc.  All rights reserved.
+ *
+ * Authors:
+ *   Boaz Harrosh <bharrosh@panasas.com>
+ *   Benny Halevy <bhalevy@panasas.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2
+ *
+ * Contains types and constants that are implementation specific and a=
re
+ * used by more than one part of the osd library.
+ *     (Eg initiator/target/security_manager/...)
+ */
+#ifndef __OSD_TYPES_H__
+#define __OSD_TYPES_H__
+
+struct osd_systemid {
+	u8 data[OSD_SYSTEMID_LEN];
+};
+
+typedef u64 __bitwise osd_id;
+
+struct osd_obj_id {
+	osd_id partition;
+	osd_id id;
+};
+
+static const struct __weak osd_obj_id osd_root_object =3D {0, 0};
+
+struct osd_attr {
+	u32 page;
+	u32 attr_id;
+	u16 len;		/* byte count of operand */
+	void *val_ptr;		/* in network order */
+};
+
+#endif /* ndef __OSD_TYPES_H__ */
--=20
1.5.6.rc1.5.gadf6


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
