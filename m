From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 10/18] libosd: OSD Security processing stubs
Date: Tue,  6 Jan 2009 16:21:45 +0200
Message-ID: <1231251705-25135-1-git-send-email-bharrosh@panasas.com>
References: <49636507.8060808@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:15459 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751879AbZAFOVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 09:21:49 -0500
In-Reply-To: <49636507.8060808@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Layout the signing of OSD's CDB and all-data security modes. The actual
code for signing the data and CDB is missing, but the code flow and the extra
buffer segments are all in place.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   85 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 68cf0ac..367337c 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -107,6 +107,14 @@ static osd_cdb_offset osd_req_encode_offset(struct osd_request *or,
 				  OSDv1_OFFSET_MIN_SHIFT, OSD_OFFSET_MAX_SHIFT);
 }
 
+static struct osd_security_parameters *
+_osd_req_sec_params(struct osd_request *or)
+{
+	struct osd_cdb *ocdb = &or->cdb;
+
+	return &ocdb->v1.sec_params;
+}
+
 void osd_dev_init(struct osd_dev *osdd, struct scsi_device *scsi_device)
 {
 	memset(osdd, 0, sizeof(*osdd));
@@ -794,6 +802,64 @@ static int _osd_req_finalize_attr_page(struct osd_request *or)
 	return ret;
 }
 
+static int _osd_req_finalize_data_integrity(struct osd_request *or,
+	bool has_in, bool has_out, const u8 *cap_key)
+{
+	struct osd_security_parameters *sec_parms = _osd_req_sec_params(or);
+	int ret;
+
+	if (!osd_is_sec_alldata(sec_parms))
+		return 0;
+
+	if (has_out) {
+		struct _osd_req_data_segment seg = {
+			.buff = &or->out_data_integ,
+			.total_bytes = sizeof(or->out_data_integ),
+		};
+		int pad;
+
+		or->out_data_integ.data_bytes = cpu_to_be64(
+			or->out.bio ? or->out.bio->bi_size : 0);
+		or->out_data_integ.set_attributes_bytes = cpu_to_be64(
+			or->set_attr.total_bytes);
+		or->out_data_integ.get_attributes_bytes = cpu_to_be64(
+			or->enc_get_attr.total_bytes);
+
+		sec_parms->data_out_integrity_check_offset =
+			osd_req_encode_offset(or, or->out.total_bytes, &pad);
+
+		ret = _req_append_segment(or, pad, &seg, or->out.last_seg,
+					  &or->out);
+		if (ret)
+			return ret;
+		or->out.last_seg = NULL;
+
+		/* they are now all chained to request sign them all together */
+		osd_sec_sign_data(&or->out_data_integ, or->out.req->bio,
+				  cap_key);
+	}
+
+	if (has_in) {
+		struct _osd_req_data_segment seg = {
+			.buff = &or->in_data_integ,
+			.total_bytes = sizeof(or->in_data_integ),
+		};
+		int pad;
+
+		sec_parms->data_in_integrity_check_offset =
+			osd_req_encode_offset(or, or->in.total_bytes, &pad);
+
+		ret = _req_append_segment(or, pad, &seg, or->in.last_seg,
+					  &or->in);
+		if (ret)
+			return ret;
+
+		or->in.last_seg = NULL;
+	}
+
+	return 0;
+}
+
 /*
  * osd_finalize_request and helpers
  */
@@ -914,6 +980,12 @@ int osd_finalize_request(struct osd_request *or,
 		}
 	}
 
+	ret = _osd_req_finalize_data_integrity(or, has_in, has_out, cap_key);
+	if (ret)
+		return ret;
+
+	osd_sec_sign_cdb(&or->cdb, cap_key);
+
 	or->request->cmd = or->cdb.buff;
 	or->request->cmd_len = _osd_req_cdb_len(or);
 
@@ -979,6 +1051,19 @@ void osd_set_caps(struct osd_cdb *cdb, const void *caps)
 	memcpy(&cdb->v1.caps, caps, OSDv1_CAP_LEN);
 }
 
+bool osd_is_sec_alldata(struct osd_security_parameters *sec_parms)
+{
+	return false;
+}
+
+void osd_sec_sign_cdb(struct osd_cdb *ocdb, const u8 *cap_key)
+{
+}
+
+void osd_sec_sign_data(void *data_integ, struct bio *bio, const u8 *cap_key)
+{
+}
+
 /*
  * Declared in osd_protocol.h
  * 4.12.5 Data-In and Data-Out buffer offsets
-- 
1.6.0.1

