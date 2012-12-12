From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/16] libfc: fix REC handling
Date: Wed, 12 Dec 2012 15:22:09 -0800
Message-ID: <20121212232209.13084.12509.stgit@fritz>
References: <20121212232203.13084.3630.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab2LLXWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 18:22:10 -0500
In-Reply-To: <20121212232203.13084.3630.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Currently fc_fcp_timeout doesn't check FC_RP_FLAGS_REC_SUPPORTED
flag first, this prevents REC request ever going out at all
to the target having REC support. So this patches fixes the
fc_fcp_timeout by checking FC_RP_FLAGS_REC_SUPPORTED flag first.

The changed order won't cause any issue during clearing
FC_RP_FLAGS_REC_SUPPORTED on failed IO with target not supporting
FC_RP_FLAGS_REC_SUPPORTED, since retry on failed IO would succeed.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index fcb9d0b..09c81b2 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1381,10 +1381,10 @@ static void fc_fcp_timeout(unsigned long data)
 
 	fsp->state |= FC_SRB_FCP_PROCESSING_TMO;
 
-	if (fsp->state & FC_SRB_RCV_STATUS)
-		fc_fcp_complete_locked(fsp);
-	else if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
+	if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
 		fc_fcp_rec(fsp);
+	else if (fsp->state & FC_SRB_RCV_STATUS)
+		fc_fcp_complete_locked(fsp);
 	else
 		fc_fcp_recovery(fsp, FC_TIMED_OUT);
 	fsp->state &= ~FC_SRB_FCP_PROCESSING_TMO;

