From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 8/9] libosd: Error handling revamped
Date: Mon, 16 Nov 2009 20:48:38 +0200
Message-ID: <1258397318-328-1-git-send-email-bharrosh@panasas.com>
References: <4B019BEC.3080909@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:35512 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753528AbZKPSww (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2009 13:52:52 -0500
In-Reply-To: <4B019BEC.3080909@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

Administer some love to the osd_req_decode_sense function

* Fix a bad bug with osd_req_decode_sense(). If there was no scsi
  residual, .i.e the request never reached the target, then all the
  osd_sense_info members where garbage.

* Add grossly missing in/out_resid to osd_sense_info and fill them in
  properly.

* Define an osd_err_priority enum which divides the possible errors into
  7 categories in ascending severity. Each category is also assigned a
  Linux return code translation.

  Analyze the different osd/scsi/block returned errors and set the
  proper osd_err_priority and Linux return code accordingly.

* extra check a few situations so not to get stuck with inconsistent
  error view. Example an empty residual with an error code, and other
  places ...

Lots of libosd's osd_req_decode_sense clients had this logic in some
form or another. Consolidate all these into one place that should
actually know about osd returns. Thous translating it to a more
abstract error.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   85 +++++++++++++++++++++++++++++++++-----
 include/scsi/osd_initiator.h     |   26 +++++++++++-
 2 files changed, 99 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index ba25b1e..950202a 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -475,7 +475,8 @@ EXPORT_SYMBOL(osd_end_request);
 
 int osd_execute_request(struct osd_request *or)
 {
-	return blk_execute_rq(or->request->q, NULL, or->request, 0);
+	return or->async_error =
+			blk_execute_rq(or->request->q, NULL, or->request, 0);
 }
 EXPORT_SYMBOL(osd_execute_request);
 
@@ -485,8 +486,12 @@ static void osd_request_async_done(struct request *req, int error)
 
 	or->async_error = error;
 
-	if (error)
-		OSD_DEBUG("osd_request_async_done error recieved %d\n", error);
+	if (unlikely(error)) {
+		OSD_DEBUG("osd_request_async_done error recieved %d "
+			  "errors 0x%x\n", error, req->errors);
+		if (!req->errors) /* don't miss out on this one */
+			req->errors = error;
+	}
 
 	if (or->async_done)
 		or->async_done(or, or->async_private);
@@ -1451,6 +1456,15 @@ int osd_finalize_request(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_finalize_request);
 
+static bool _is_osd_security_code(int code)
+{
+	return	(code == osd_security_audit_value_frozen) ||
+		(code == osd_security_working_key_frozen) ||
+		(code == osd_nonce_not_unique) ||
+		(code == osd_nonce_timestamp_out_of_range) ||
+		(code == osd_invalid_dataout_buffer_integrity_check_value);
+}
+
 #define OSD_SENSE_PRINT1(fmt, a...) \
 	do { \
 		if (__cur_sense_need_output) \
@@ -1473,9 +1487,16 @@ int osd_req_decode_sense_full(struct osd_request *or,
 #else
 	bool __cur_sense_need_output = !silent;
 #endif
+	int ret;
 
-	if (!or->request->errors)
+	if (likely(!or->request->errors)) {
+		osi->out_resid = 0;
+		osi->in_resid = 0;
 		return 0;
+	}
+
+	osi = osi ? : &local_osi;
+	memset(osi, 0, sizeof(*osi));
 
 	ssdb = or->request->sense;
 	sense_len = or->request->sense_len;
@@ -1483,17 +1504,15 @@ int osd_req_decode_sense_full(struct osd_request *or,
 		OSD_ERR("Block-layer returned error(0x%x) but "
 			"sense_len(%u) || key(%d) is empty\n",
 			or->request->errors, sense_len, ssdb->sense_key);
-		return -EIO;
+		goto analyze;
 	}
 
 	if ((ssdb->response_code != 0x72) && (ssdb->response_code != 0x73)) {
 		OSD_ERR("Unrecognized scsi sense: rcode=%x length=%d\n",
 			ssdb->response_code, sense_len);
-		return -EIO;
+		goto analyze;
 	}
 
-	osi = osi ? : &local_osi;
-	memset(osi, 0, sizeof(*osi));
 	osi->key = ssdb->sense_key;
 	osi->additional_code = be16_to_cpu(ssdb->additional_sense_code);
 	original_sense_len = ssdb->additional_sense_length + 8;
@@ -1503,9 +1522,10 @@ int osd_req_decode_sense_full(struct osd_request *or,
 		__cur_sense_need_output = (osi->key > scsi_sk_recovered_error);
 #endif
 	OSD_SENSE_PRINT1("Main Sense information key=0x%x length(%d, %d) "
-			"additional_code=0x%x\n",
+			"additional_code=0x%x async_error=%d errors=0x%x\n",
 			osi->key, original_sense_len, sense_len,
-			osi->additional_code);
+			osi->additional_code, or->async_error,
+			or->request->errors);
 
 	if (original_sense_len < sense_len)
 		sense_len = original_sense_len;
@@ -1637,7 +1657,50 @@ int osd_req_decode_sense_full(struct osd_request *or,
 		cur_descriptor += cur_len;
 	}
 
-	return (osi->key > scsi_sk_recovered_error) ? -EIO : 0;
+analyze:
+	if (!osi->key) {
+		/* scsi sense is Empty, the request was never issued to target
+		 * linux return code might tell us what happened.
+		 */
+		if (or->async_error == -ENOMEM)
+			osi->osd_err_pri = OSD_ERR_PRI_RESOURCE;
+		else
+			osi->osd_err_pri = OSD_ERR_PRI_UNREACHABLE;
+		ret = or->async_error;
+	} else if (osi->key <= scsi_sk_recovered_error) {
+		osi->osd_err_pri = 0;
+		ret = 0;
+	} else if (osi->additional_code == scsi_invalid_field_in_cdb) {
+		if (osi->cdb_field_offset == OSD_CFO_STARTING_BYTE) {
+			osi->osd_err_pri = OSD_ERR_PRI_CLEAR_PAGES;
+			ret = -EFAULT; /* caller should recover from this */
+		} else if (osi->cdb_field_offset == OSD_CFO_OBJECT_ID) {
+			osi->osd_err_pri = OSD_ERR_PRI_NOT_FOUND;
+			ret = -ENOENT;
+		} else if (osi->cdb_field_offset == OSD_CFO_PERMISSIONS) {
+			osi->osd_err_pri = OSD_ERR_PRI_NO_ACCESS;
+			ret = -EACCES;
+		} else {
+			osi->osd_err_pri = OSD_ERR_PRI_BAD_CRED;
+			ret = -EINVAL;
+		}
+	} else if (osi->additional_code == osd_quota_error) {
+		osi->osd_err_pri = OSD_ERR_PRI_NO_SPACE;
+		ret = -ENOSPC;
+	} else if (_is_osd_security_code(osi->additional_code)) {
+		osi->osd_err_pri = OSD_ERR_PRI_BAD_CRED;
+		ret = -EINVAL;
+	} else {
+		osi->osd_err_pri = OSD_ERR_PRI_EIO;
+		ret = -EIO;
+	}
+
+	if (or->out.req)
+		osi->out_resid = or->out.req->resid_len ?: or->out.total_bytes;
+	if (or->in.req)
+		osi->in_resid = or->in.req->resid_len ?: or->in.total_bytes;
+
+	return ret;
 }
 EXPORT_SYMBOL(osd_req_decode_sense_full);
 
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 3ec346e..39d6d10 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -267,7 +267,7 @@ int osd_execute_request_async(struct osd_request *or,
  * @bad_attr_list - List of failing attributes (optional)
  * @max_attr      - Size of @bad_attr_list.
  *
- * After execution, sense + return code can be analyzed using this function. The
+ * After execution, osd_request results are analyzed using this function. The
  * return code is the final disposition on the error. So it is possible that a
  * CHECK_CONDITION was returned from target but this will return NO_ERROR, for
  * example on recovered errors. All parameters are optional if caller does
@@ -276,7 +276,31 @@ int osd_execute_request_async(struct osd_request *or,
  * of the SCSI_OSD_DPRINT_SENSE Kconfig value. Set @silent if you know the
  * command would routinely fail, to not spam the dmsg file.
  */
+
+/**
+ * osd_err_priority - osd categorized return codes in ascending severity.
+ *
+ * The categories are borrowed from the pnfs_osd_errno enum.
+ * See comments for translated Linux codes returned by osd_req_decode_sense.
+ */
+enum osd_err_priority {
+	OSD_ERR_PRI_NO_ERROR	= 0,
+	/* Recoverable, caller should clear_highpage() all pages */
+	OSD_ERR_PRI_CLEAR_PAGES = 1, /* -EFAULT */
+	OSD_ERR_PRI_RESOURCE	= 2, /* -ENOMEM */
+	OSD_ERR_PRI_BAD_CRED	= 3, /* -EINVAL */
+	OSD_ERR_PRI_NO_ACCESS	= 4, /* -EACCES */
+	OSD_ERR_PRI_UNREACHABLE	= 5, /* any other */
+	OSD_ERR_PRI_NOT_FOUND	= 6, /* -ENOENT */
+	OSD_ERR_PRI_NO_SPACE	= 7, /* -ENOSPC */
+	OSD_ERR_PRI_EIO		= 8, /* -EIO    */
+};
+
 struct osd_sense_info {
+	u64 out_resid;		/* Zero on success otherwise out residual */
+	u64 in_resid;		/* Zero on success otherwise in residual */
+	enum osd_err_priority osd_err_pri;
+
 	int key;		/* one of enum scsi_sense_keys */
 	int additional_code ;	/* enum osd_additional_sense_codes */
 	union { /* Sense specific information */
-- 
1.6.5.2

