From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/8] libfc: introduce __fc_fill_fc_hdr that accepts fc_hdr as
	an argument
Date: Fri, 25 Feb 2011 15:03:07 -0800
Message-ID: <20110225230307.9310.19761.stgit@localhost6.localdomain6>
References: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab1BYXDH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 18:03:07 -0500
In-Reply-To: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

fc_fill_fc_hdr() expects fc_frame as an argument. Introduce __fc_fill_fc_hdr to
accept fc_frame_header as an argument.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
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

