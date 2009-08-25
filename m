From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 52/64] libfc: Always reset remote port roles when receiving
	PRLI
Date: Tue, 25 Aug 2009 14:03:04 -0700
Message-ID: <20090825210304.1553.24007.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:46628 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbZHYVDD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:03 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

Don't trust previous roles, reset them when we receive a PRLI.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index c667be8..cb54115 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -666,6 +666,9 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		goto err;
 	}
 
+	/* reinitialize remote port roles */
+	rdata->ids.roles = FC_RPORT_ROLE_UNKNOWN;
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		pp = fc_frame_payload_get(fp, sizeof(*pp));
@@ -1173,6 +1176,9 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 		pp->prli.prli_len = htons(len);
 		len -= sizeof(struct fc_els_prli);
 
+		/* reinitialize remote port roles */
+		rdata->ids.roles = FC_RPORT_ROLE_UNKNOWN;
+
 		/*
 		 * Go through all the service parameter pages and build
 		 * response.  If plen indicates longer SPP than standard,

