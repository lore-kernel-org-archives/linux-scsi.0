From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 38/54] libfc: fix symbolic name registrations smashing skb data
Date: Tue, 03 Nov 2009 11:48:55 -0800
Message-ID: <20091103194855.4085.41789.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9638 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbZKCTs5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:48:57 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The strncpy for RSPN_ID and RSNN_NN requests was padding
past the allocated frame size.

Get the string length before filling in the ct header.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/fc_encode.h |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index c8968d3..ab2260c 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -111,6 +111,7 @@ static inline int fc_ct_fill(struct fc_lport *lport,
 		      enum fc_fh_type *fh_type)
 {
 	struct fc_ct_req *ct;
+	size_t len;
 
 	switch (op) {
 	case FC_NS_GPN_FT:
@@ -138,22 +139,22 @@ static inline int fc_ct_fill(struct fc_lport *lport,
 		break;
 
 	case FC_NS_RSPN_ID:
-		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rspn));
+		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rspn) + len);
 		hton24(ct->payload.spn.fr_fid.fp_fid,
 		       fc_host_port_id(lport->host));
 		strncpy(ct->payload.spn.fr_name,
-			fc_host_symbolic_name(lport->host), 255);
-		ct->payload.spn.fr_name_len =
-			strnlen(ct->payload.spn.fr_name, 255);
+			fc_host_symbolic_name(lport->host), len);
+		ct->payload.spn.fr_name_len = len;
 		break;
 
 	case FC_NS_RSNN_NN:
-		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rsnn));
+		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rsnn) + len);
 		put_unaligned_be64(lport->wwnn, &ct->payload.snn.fr_wwn);
 		strncpy(ct->payload.snn.fr_name,
-			fc_host_symbolic_name(lport->host), 255);
-		ct->payload.snn.fr_name_len =
-			strnlen(ct->payload.snn.fr_name, 255);
+			fc_host_symbolic_name(lport->host), len);
+		ct->payload.snn.fr_name_len = len;
 		break;
 
 	default:

