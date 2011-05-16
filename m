From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 7/8] libfc: do not immediately retry the cmd when seq_send
	fails in fc_fcp_send_data
Date: Mon, 16 May 2011 16:45:57 -0700
Message-ID: <20110516234557.24502.54586.stgit@localhost6.localdomain6>
References: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41494 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1EPXp5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 19:45:57 -0400
In-Reply-To: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Currently, when seq_send() fails in fc_fcp_send_data(), fc_fcp_retry_cmd()
would complete this failed I/O directly and let scsi-ml retry. However, target side
is not notified which may hang the target. Instead, we should just bail out from
from fc_fcp_send_data and let scsi-ml times it out and aborts this I/O instead.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 57704e8..9cd2149 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -681,8 +681,7 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 		error = lport->tt.seq_send(lport, seq, fp);
 		if (error) {
 			WARN_ON(1);		/* send error should be rare */
-			fc_fcp_retry_cmd(fsp);
-			return 0;
+			return error;
 		}
 		fp = NULL;
 	}

