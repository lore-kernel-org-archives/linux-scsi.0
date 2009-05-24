From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 05/10 resend] libosd: Let _osd_req_finalize_data_integrity receive number of out_bytes
Date: Sun, 24 May 2009 20:04:00 +0300
Message-ID: <1243184640-17028-1-git-send-email-bharrosh@panasas.com>
References: <4A197CB5.60709@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:1628 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754160AbZEXREB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2009 13:04:01 -0400
In-Reply-To: <4A197CB5.60709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
Cc: Jeff Garzik <jeff@garzik.org>

_osd_req_finalize_data_integrity was trying to deduce the number of
out_bytes from passed osd_request->out.bio. This is wrong when
the bio is chained. The caller of _osd_req_finalize_data_integrity
has more ready available information and should just pass it.

Also in the light of future support for CDB-continuation segment this is
a better solution.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index c98153b..ba2ebae 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1262,7 +1262,7 @@ static inline void osd_sec_parms_set_in_offset(bool is_v1,
 }
 
 static int _osd_req_finalize_data_integrity(struct osd_request *or,
-	bool has_in, bool has_out, const u8 *cap_key)
+	bool has_in, bool has_out, u64 out_data_bytes, const u8 *cap_key)
 {
 	struct osd_security_parameters *sec_parms = _osd_req_sec_params(or);
 	int ret;
@@ -1277,8 +1277,7 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 		};
 		unsigned pad;
 
-		or->out_data_integ.data_bytes = cpu_to_be64(
-			or->out.bio ? or->out.bio->bi_size : 0);
+		or->out_data_integ.data_bytes = cpu_to_be64(out_data_bytes);
 		or->out_data_integ.set_attributes_bytes = cpu_to_be64(
 			or->set_attr.total_bytes);
 		or->out_data_integ.get_attributes_bytes = cpu_to_be64(
@@ -1370,6 +1369,7 @@ int osd_finalize_request(struct osd_request *or,
 {
 	struct osd_cdb_head *cdbh = osd_cdb_head(&or->cdb);
 	bool has_in, has_out;
+	u64 out_data_bytes = or->out.total_bytes;
 	int ret;
 
 	if (options & OSD_REQ_FUA)
@@ -1439,7 +1439,8 @@ int osd_finalize_request(struct osd_request *or,
 		}
 	}
 
-	ret = _osd_req_finalize_data_integrity(or, has_in, has_out, cap_key);
+	ret = _osd_req_finalize_data_integrity(or, has_in, has_out,
+					       out_data_bytes, cap_key);
 	if (ret)
 		return ret;
 
-- 
1.6.2.1

