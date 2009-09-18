From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 18/24] libfc: fix fc_els_resp_type to correct display of CT
	responses
Date: Fri, 18 Sep 2009 15:50:37 -0700
Message-ID: <20090918225037.5928.5122.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50452 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835AbZIRWue (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:50:34 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Local port debug messages were using fc_els_resp_type() which showed
all CT responses as rejects.

Handle CT responses correctly based by inspecting fh_type.

I decided not to rename the function to keep the patch smaller.
We could call it just fc_resp_type() or fc_elsct_resp_type().

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_elsct.c |   41 +++++++++++++++++++++++++++++++++++------
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index 59183fb..9999719 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -88,6 +88,9 @@ EXPORT_SYMBOL(fc_elsct_init);
 const char *fc_els_resp_type(struct fc_frame *fp)
 {
 	const char *msg;
+	struct fc_frame_header *fh;
+	struct fc_ct_hdr *ct;
+
 	if (IS_ERR(fp)) {
 		switch (-PTR_ERR(fp)) {
 		case FC_NO_ERR:
@@ -104,15 +107,41 @@ const char *fc_els_resp_type(struct fc_frame *fp)
 			break;
 		}
 	} else {
-		switch (fc_frame_payload_op(fp)) {
-		case ELS_LS_ACC:
-			msg = "accept";
+		fh = fc_frame_header_get(fp);
+		switch (fh->fh_type) {
+		case FC_TYPE_ELS:
+			switch (fc_frame_payload_op(fp)) {
+			case ELS_LS_ACC:
+				msg = "accept";
+				break;
+			case ELS_LS_RJT:
+				msg = "reject";
+				break;
+			default:
+				msg = "response unknown ELS";
+				break;
+			}
 			break;
-		case ELS_LS_RJT:
-			msg = "reject";
+		case FC_TYPE_CT:
+			ct = fc_frame_payload_get(fp, sizeof(*ct));
+			if (ct) {
+				switch (ntohs(ct->ct_cmd)) {
+				case FC_FS_ACC:
+					msg = "CT accept";
+					break;
+				case FC_FS_RJT:
+					msg = "CT reject";
+					break;
+				default:
+					msg = "response unknown CT";
+					break;
+				}
+			} else {
+				msg = "short CT response";
+			}
 			break;
 		default:
-			msg = "response unknown ELS";
+			msg = "response not ELS or CT";
 			break;
 		}
 	}

