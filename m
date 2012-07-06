From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 6/6] libfc: fix sending REC after FCP_RESP is received
Date: Fri, 06 Jul 2012 10:40:31 -0700
Message-ID: <20120706174031.4102.91244.stgit@fritz>
References: <20120706173959.4102.12091.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40525 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758040Ab2GFRkb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jul 2012 13:40:31 -0400
In-Reply-To: <20120706173959.4102.12091.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

This is exposed in the case the FCP_DATA frames somehow got lost and fc_fcp got
the FCP_RSP, in fc_fcp_recv_resp(), since xfer_len is less than the expected_len
it resets the the timer to wait to 2 more jiffies in case the data frames are
already queued locally. However, for target does not support REC, it would just
send RJT w/ ELS_RJT_UNSUP. The rec response handler thus only clears the rport
flag for not doing REC later, but does not do fcp_io_complete() on the
associated fsp.

The fix is just check status of FCP_RSP being received already, i.e. using the
FC_SRB_RCV_STATUS flag, in fc_fcp_timeout before start sending REC. We should
have waited long enough if there is truely data frames queued locally.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index f735730..5c8074b 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1372,10 +1372,10 @@ static void fc_fcp_timeout(unsigned long data)
 
 	fsp->state |= FC_SRB_FCP_PROCESSING_TMO;
 
-	if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
-		fc_fcp_rec(fsp);
-	else if (fsp->state & FC_SRB_RCV_STATUS)
+	if (fsp->state & FC_SRB_RCV_STATUS)
 		fc_fcp_complete_locked(fsp);
+	else if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
+		fc_fcp_rec(fsp);
 	else
 		fc_fcp_recovery(fsp, FC_TIMED_OUT);
 	fsp->state &= ~FC_SRB_FCP_PROCESSING_TMO;

