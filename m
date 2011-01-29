From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/28] libfc: Return a valid return code in fc_fcp_pkt_abort()
Date: Fri, 28 Jan 2011 16:03:21 -0800
Message-ID: <20110129000321.1784.38137.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16347 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1A2ADV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:03:21 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

Here ticks_left is added to record the result of
wait_for_completion_timeout().

[ Patch title and description edited by Robert Love
  to make it more descriptive  ]

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 21a64d4..ba639fa 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1202,6 +1202,7 @@ unlock:
 static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
 {
 	int rc = FAILED;
+	unsigned long ticks_left;
 
 	if (fc_fcp_send_abort(fsp))
 		return FAILED;
@@ -1210,13 +1211,13 @@ static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
 	fsp->wait_for_comp = 1;
 
 	spin_unlock_bh(&fsp->scsi_pkt_lock);
-	rc = wait_for_completion_timeout(&fsp->tm_done, FC_SCSI_TM_TOV);
+	ticks_left = wait_for_completion_timeout(&fsp->tm_done,
+							FC_SCSI_TM_TOV);
 	spin_lock_bh(&fsp->scsi_pkt_lock);
 	fsp->wait_for_comp = 0;
 
-	if (!rc) {
+	if (!ticks_left) {
 		FC_FCP_DBG(fsp, "target abort cmd  failed\n");
-		rc = FAILED;
 	} else if (fsp->state & FC_SRB_ABORTED) {
 		FC_FCP_DBG(fsp, "target abort cmd  passed\n");
 		rc = SUCCESS;

