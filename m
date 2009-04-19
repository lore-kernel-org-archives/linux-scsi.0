From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/4] libosd: OSD2r05: Prepare for rev5 attribute list changes
Date: Sun, 19 Apr 2009 19:11:42 +0300
Message-ID: <49EB4D3E.1010608@panasas.com>
References: <49EB4A42.9030502@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61437 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758388AbZDSQLu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Apr 2009 12:11:50 -0400
Received: by fxm2 with SMTP id 2so1582456fxm.37
        for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2009 09:11:48 -0700 (PDT)
In-Reply-To: <49EB4A42.9030502@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: Dan Carpenter <error27@gmail.com>


In OSD2r05 draft each attribute list element header was changed
so attribute-value would be 8 bytes aligned. In OSD2r01-r04
it was aligned on 2 bytes. (This is because in OSD2r01 the complete
element was 8 bytes padded at end but the header was not adjusted
and caused permanent miss-alignment.)

OSD1 elements are not padded and might be or might not be aligned.
OSD1 is still supported.

In this code we do all the code re-factoring to separate OSD1/OSD2
differences but do not change actual wire format. All wire format
changes will happen in one patch later, for bisect-ability.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   86 ++++++++++++++++++++++++++++++--------
 include/scsi/osd_protocol.h      |   20 +++++++--
 2 files changed, 83 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 76de889..e266f80 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -205,6 +205,69 @@ static unsigned _osd_req_alist_elem_size(struct osd_request *or, unsigned len)
 		osdv2_attr_list_elem_size(len);
 }
 
+static void _osd_req_alist_elem_encode(struct osd_request *or,
+	void *attr_last, const struct osd_attr *oa)
+{
+	if (osd_req_is_ver1(or)) {
+		struct osdv1_attributes_list_element *attr = attr_last;
+
+		attr->attr_page = cpu_to_be32(oa->attr_page);
+		attr->attr_id = cpu_to_be32(oa->attr_id);
+		attr->attr_bytes = cpu_to_be16(oa->len);
+		memcpy(attr->attr_val, oa->val_ptr, oa->len);
+	} else {
+		struct osdv2_attributes_list_element *attr = attr_last;
+
+		attr->attr_page = cpu_to_be32(oa->attr_page);
+		attr->attr_id = cpu_to_be32(oa->attr_id);
+		attr->attr_bytes = cpu_to_be16(oa->len);
+		memcpy(attr->attr_val, oa->val_ptr, oa->len);
+	}
+}
+
+static int _osd_req_alist_elem_decode(struct osd_request *or,
+	void *cur_p, struct osd_attr *oa, unsigned max_bytes)
+{
+	unsigned inc;
+	if (osd_req_is_ver1(or)) {
+		struct osdv1_attributes_list_element *attr = cur_p;
+
+		if (max_bytes < sizeof(*attr))
+			return -1;
+
+		oa->len = be16_to_cpu(attr->attr_bytes);
+		inc = _osd_req_alist_elem_size(or, oa->len);
+		if (inc > max_bytes)
+			return -1;
+
+		oa->attr_page = be32_to_cpu(attr->attr_page);
+		oa->attr_id = be32_to_cpu(attr->attr_id);
+
+		/* OSD1: On empty attributes we return a pointer to 2 bytes
+		 * of zeros. This keeps similar behaviour with OSD2.
+		 * (See below)
+		 */
+		oa->val_ptr = likely(oa->len) ? attr->attr_val :
+						(u8 *)&attr->attr_bytes;
+	} else {
+		struct osdv2_attributes_list_element *attr = cur_p;
+
+		if (max_bytes < sizeof(*attr))
+			return -1;
+
+		oa->len = be16_to_cpu(attr->attr_bytes);
+		inc = _osd_req_alist_elem_size(or, oa->len);
+		if (inc > max_bytes)
+			return -1;
+
+		oa->attr_page = be32_to_cpu(attr->attr_page);
+		oa->attr_id = be32_to_cpu(attr->attr_id);
+
+		oa->val_ptr = attr->attr_val;
+	}
+	return inc;
+}
+
 static unsigned _osd_req_alist_size(struct osd_request *or, void *list_head)
 {
 	return osd_req_is_ver1(or) ?
@@ -798,7 +861,6 @@ int osd_req_add_set_attr_list(struct osd_request *or,
 	attr_last = or->set_attr.buff + total_bytes;
 
 	for (; nelem; --nelem) {
-		struct osd_attributes_list_element *attr;
 		unsigned elem_size = _osd_req_alist_elem_size(or, oa->len);
 
 		total_bytes += elem_size;
@@ -811,11 +873,7 @@ int osd_req_add_set_attr_list(struct osd_request *or,
 				or->set_attr.buff + or->set_attr.total_bytes;
 		}
 
-		attr = attr_last;
-		attr->attr_page = cpu_to_be32(oa->attr_page);
-		attr->attr_id = cpu_to_be32(oa->attr_id);
-		attr->attr_bytes = cpu_to_be16(oa->len);
-		memcpy(attr->attr_val, oa->val_ptr, oa->len);
+		_osd_req_alist_elem_encode(or, attr_last, oa);
 
 		attr_last += elem_size;
 		++oa;
@@ -1070,15 +1128,10 @@ int osd_req_decode_get_attr_list(struct osd_request *or,
 	}
 
 	for (n = 0; (n < *nelem) && (cur_bytes < returned_bytes); ++n) {
-		struct osd_attributes_list_element *attr = cur_p;
-		unsigned inc;
+		int inc = _osd_req_alist_elem_decode(or, cur_p, oa,
+						 returned_bytes - cur_bytes);
 
-		oa->len = be16_to_cpu(attr->attr_bytes);
-		inc = _osd_req_alist_elem_size(or, oa->len);
-		OSD_DEBUG("oa->len=%d inc=%d cur_bytes=%d\n",
-			  oa->len, inc, cur_bytes);
-		cur_bytes += inc;
-		if (cur_bytes > returned_bytes) {
+		if (inc < 0) {
 			OSD_ERR("BAD FOOD from target. list not valid!"
 				"c=%d r=%d n=%d\n",
 				cur_bytes, returned_bytes, n);
@@ -1086,10 +1139,7 @@ int osd_req_decode_get_attr_list(struct osd_request *or,
 			break;
 		}
 
-		oa->attr_page = be32_to_cpu(attr->attr_page);
-		oa->attr_id = be32_to_cpu(attr->attr_id);
-		oa->val_ptr = attr->attr_val;
-
+		cur_bytes += inc;
 		cur_p += inc;
 		++oa;
 	}
diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
index cd3cbf7..fa8343c 100644
--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -301,14 +301,24 @@ struct osd_attributes_list_attrid {
 } __packed;
 
 /*
+ * NOTE: v1: is not aligned.
+ */
+struct osdv1_attributes_list_element {
+	__be32 attr_page;
+	__be32 attr_id;
+	__be16 attr_bytes; /* valid bytes at attr_val without padding */
+	u8 attr_val[0];
+} __packed;
+
+/*
  * osd2r03: 7.1.3.3 List entry format for retrieved attributes and
  *                  for setting attributes
- * NOTE: v2 is 8-bytes aligned, v1 is not aligned.
+ * NOTE: v2 is 8-bytes aligned
  */
-struct osd_attributes_list_element {
+struct osdv2_attributes_list_element {
 	__be32 attr_page;
 	__be32 attr_id;
-	__be16 attr_bytes;
+	__be16 attr_bytes; /* valid bytes at attr_val without padding */
 	u8 attr_val[0];
 } __packed;
 
@@ -324,13 +334,13 @@ enum {
 
 static inline unsigned osdv1_attr_list_elem_size(unsigned len)
 {
-	return ALIGN(len + sizeof(struct osd_attributes_list_element),
+	return ALIGN(len + sizeof(struct osdv1_attributes_list_element),
 		     OSDv1_ATTRIBUTES_ELEM_ALIGN);
 }
 
 static inline unsigned osdv2_attr_list_elem_size(unsigned len)
 {
-	return ALIGN(len + sizeof(struct osd_attributes_list_element),
+	return ALIGN(len + sizeof(struct osdv2_attributes_list_element),
 		     OSD_ATTRIBUTES_ELEM_ALIGN);
 }
 
-- 
1.6.2.1


