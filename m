From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 20/21] libfcoe: Handle CVL while waiting to select an FCF
Date: Tue, 19 Feb 2013 11:32:21 -0800
Message-ID: <20130219193221.10192.36778.stgit@fritz>
References: <20130219193031.10192.33777.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933341Ab3BSTcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 14:32:23 -0500
In-Reply-To: <20130219193031.10192.33777.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

When a CVL is received while we wait to select best FCF, we drop it
without handling it. This causes initiator and the switch to go
out-of-sync. Initiator proceeds selecting one of the FCFs and tries to
send FIP FLOGI. However the switch may reject the FLOGI, as it has
cleared its internal state, and expects the initiator to start FIP
discovery protocol. Fix this condition by resetting the fcoe
controller.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Reviewed-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 7583425..aff3c44 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1291,8 +1291,16 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 
 	LIBFCOE_FIP_DBG(fip, "Clear Virtual Link received\n");
 
-	if (!fcf || !lport->port_id)
+	if (!fcf || !lport->port_id) {
+		/*
+		 * We are yet to select best FCF, but we got CVL in the
+		 * meantime. reset the ctlr and let it rediscover the FCF
+		 */
+		mutex_lock(&fip->ctlr_mutex);
+		fcoe_ctlr_reset(fip);
+		mutex_unlock(&fip->ctlr_mutex);
 		return;
+	}
 
 	/*
 	 * mask of required descriptors.  Validating each one clears its bit.

