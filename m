From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 2/3] libfc: fix lun reset failure bugs in fc_fcp_resp handling
 of FCP_RSP_INFO
Date: Mon, 24 Sep 2012 11:52:50 -0700
Message-ID: <20120924185250.521.92611.stgit@fritz>
References: <20120924185240.521.22975.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45781 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757620Ab2IXSwv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Sep 2012 14:52:51 -0400
In-Reply-To: <20120924185240.521.22975.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Frank Zhang <frank_1.zhang@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

In LUN RESET testing involving NetApp targets, it is observed that LUN
RESET is failing. The fc_fcp_resp() is not completing the completiong
for the LUN RESET task since fc_fcp_resp assumes that the FCP_RSP_INFO
is 8 bytes with the 4 byte reserved field, where in case of NetApp targets
the FCP_RSP to LUN RESET only has 4 bytes of FCP_RSP_INFO. This leads
fc_fcp_resp to error out w/o completing the task completion, eventually
causing LUN RESET to be escalated to host reset, which is not very nice.

Per FCP-3 r04, clause 9.5.15 and Table 23, the FCP_RSP_INFO field can be either
4 bytes or 8 bytes, with the last 4 bytes as "Reserved (if any)". Therefore it
is valid to have 4 bytes FCP_RSP_INFO like some of the NetApp targets behave.
Fixing this by validating the FCP_RSP_INFO against both the two spec allowed
length.

Reported-by: Frank Zhang <frank_1.zhang@intel.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    3 ++-
 include/scsi/fc/fc_fcp.h    |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 14243fa..fcb9d0b 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -851,7 +851,8 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 			fc_rp_info = (struct fcp_resp_rsp_info *)(rp_ex + 1);
 			if (flags & FCP_RSP_LEN_VAL) {
 				respl = ntohl(rp_ex->fr_rsp_len);
-				if (respl != sizeof(*fc_rp_info))
+				if ((respl != FCP_RESP_RSP_INFO_LEN4) &&
+				    (respl != FCP_RESP_RSP_INFO_LEN8))
 					goto len_err;
 				if (fsp->wait_for_comp) {
 					/* Abuse cdb_status for rsp code */
diff --git a/include/scsi/fc/fc_fcp.h b/include/scsi/fc/fc_fcp.h
index 0d7d67e..9c87029 100644
--- a/include/scsi/fc/fc_fcp.h
+++ b/include/scsi/fc/fc_fcp.h
@@ -127,6 +127,9 @@ struct fcp_txrdy {
  *
  * All response frames will always contain the fcp_resp template.  Some
  * will also include the fcp_resp_len template.
+ *
+ * From Table 23, the FCP_RSP_INFO can either be 4 bytes or 8 bytes, both
+ * are valid length.
  */
 struct fcp_resp {
 	__u8		_fr_resvd[8];	/* reserved */
@@ -156,6 +159,9 @@ struct fcp_resp_rsp_info {
     __u8      _fr_resvd2[4];      /* reserved */
 };
 
+#define FCP_RESP_RSP_INFO_LEN4    4 /* without reserved field */
+#define FCP_RESP_RSP_INFO_LEN8    8 /* with reserved field */
+
 struct fcp_resp_with_ext {
 	struct fcp_resp resp;
 	struct fcp_resp_ext ext;

