From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 2/5] bnx2fc: Release the reference to hba only after the
 interface is destroyed
Date: Mon, 25 Apr 2011 12:30:07 -0700
Message-ID: <1303759810-22570-2-git-send-email-bprakash@broadcom.com>
References: <1303759810-22570-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2569 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab1DYTaX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2011 15:30:23 -0400
In-Reply-To: <1303759810-22570-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Nithin Nayak Sujir <nsujir@broadcom.com>

Prematurely decrementing the reference may lead to cmd_mgr becoming NULL with
the cmds are still active.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 8fb9b6e..734d8c1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1370,8 +1370,6 @@ static void bnx2fc_if_destroy(struct fc_lport *lport)
 	/* Free existing transmit skbs */
 	fcoe_clean_pending_queue(lport);
 
-	bnx2fc_interface_put(hba);
-
 	/* Free queued packets for the receive thread */
 	bnx2fc_clean_rx_queue(lport);
 
@@ -1399,6 +1397,8 @@ static void bnx2fc_if_destroy(struct fc_lport *lport)
 
 	/* Release Scsi_Host */
 	scsi_host_put(lport->host);
+
+	bnx2fc_interface_put(hba);
 }
 
 /**
-- 
1.7.0.6


