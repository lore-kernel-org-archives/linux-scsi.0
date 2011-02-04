From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH] libfc: introduce __fc_fill_fc_hdr that accepts fc_hdr
 as an argument
Date: Thu, 3 Feb 2011 18:47:18 -0800
Message-ID: <1296787638.268.788.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1026 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab1BDCre (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2011 21:47:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>

fc_fill_fc_hdr() expects fc_frame as an argument. Introduce __fc_fill_fc_hdr to
accept fc_frame_header as an argument.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 include/scsi/fc_encode.h |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index 6d293c8..be418d8 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -46,16 +46,11 @@ struct fc_ct_req {
 	} payload;
 };
 
-/**
- * fill FC header fields in specified fc_frame
- */
-static inline void fc_fill_fc_hdr(struct fc_frame *fp, enum fc_rctl r_ctl,
-				  u32 did, u32 sid, enum fc_fh_type type,
-				  u32 f_ctl, u32 parm_offset)
+static inline void __fc_fill_fc_hdr(struct fc_frame_header *fh,
+				    enum fc_rctl r_ctl,
+				    u32 did, u32 sid, enum fc_fh_type type,
+				    u32 f_ctl, u32 parm_offset)
 {
-	struct fc_frame_header *fh;
-
-	fh = fc_frame_header_get(fp);
 	WARN_ON(r_ctl == 0);
 	fh->fh_r_ctl = r_ctl;
 	hton24(fh->fh_d_id, did);
@@ -68,6 +63,19 @@ static inline void fc_fill_fc_hdr(struct fc_frame *fp, enum fc_rctl r_ctl,
 }
 
 /**
+ * fill FC header fields in specified fc_frame
+ */
+static inline void fc_fill_fc_hdr(struct fc_frame *fp, enum fc_rctl r_ctl,
+				  u32 did, u32 sid, enum fc_fh_type type,
+				  u32 f_ctl, u32 parm_offset)
+{
+	struct fc_frame_header *fh;
+
+	fh = fc_frame_header_get(fp);
+	__fc_fill_fc_hdr(fh, r_ctl, did, sid, type, f_ctl, parm_offset);
+}
+
+/**
  * fc_adisc_fill() - Fill in adisc request frame
  * @lport: local port.
  * @fp: fc frame where payload will be placed.
-- 
1.7.0.6




