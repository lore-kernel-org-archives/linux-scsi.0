From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 07/14] libosd: OSD Security processing stubs
Date: Thu, 24 Jul 2008 20:54:34 +0300
Message-ID: <4888C1DA.9080202@panasas.com>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26704 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751865AbYGXRzR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 13:55:17 -0400
In-Reply-To: <4888BC3B.1050406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-osd development <osd-dev@open-osd.org>
Cc: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


Layout the signing of OSD's CDB and all-data security modes. The actual
code for signing the data and CDB is missing, but the code flow and the extra
buffer segments are all in place.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   85 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index f10f21e..10e3ac0 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -109,6 +109,14 @@ static osd_cdb_offset osd_req_encode_offset(struct osd_request *or,
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
 void osd_dev_init(struct osd_dev *osdd, struct scsi_device *scsi_dev)
 {
 	/* FIXME: Take the device reference */
@@ -771,6 +779,64 @@ int _osd_req_finalize_attr_page(struct osd_request *or)
 	return ret;
 }
 
+int _osd_req_finalize_data_integrity(struct osd_request *or,
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
@@ -881,6 +947,12 @@ int osd_finalize_request(struct osd_request *or,
 			return ret;
 	}
 
+	ret = _osd_req_finalize_data_integrity(or, has_in, has_out, cap_key);
+	if (ret)
+		return ret;
+
+	osd_sec_sign_cdb(&or->cdb, cap_key);
+
 	or->request->cmd = or->cdb.buff;
 	or->request->cmd_len = _osd_req_cdb_len(or);
 
@@ -946,6 +1018,19 @@ void osd_set_caps(struct osd_cdb *cdb, const void *caps)
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
1.5.6.rc1.5.gadf6


