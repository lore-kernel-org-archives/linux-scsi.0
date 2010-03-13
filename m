From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/16] libfcoe: fix debug message entering non-FIP mode
Date: Fri, 12 Mar 2010 16:07:57 -0800
Message-ID: <20100313000757.22251.14455.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42022 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAH6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:07:58 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The debug message that indicated we are using non-FIP mode was
being printed only if we were already in non-FIP mode.
Also changed the message text to make it more clear the mode
is being set, not that the message is indicating how FLOGI
was received.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 511cb6b..b2af53f 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1333,9 +1333,9 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 		if (fip->state == FIP_ST_AUTO || fip->state == FIP_ST_NON_FIP) {
 			memcpy(fip->dest_addr, sa, ETH_ALEN);
 			fip->map_dest = 0;
-			if (fip->state == FIP_ST_NON_FIP)
-				LIBFCOE_FIP_DBG(fip, "received FLOGI REQ, "
-						"using non-FIP mode\n");
+			if (fip->state == FIP_ST_AUTO)
+				LIBFCOE_FIP_DBG(fip, "received non-FIP FLOGI. "
+						"Setting non-FIP mode\n");
 			fip->state = FIP_ST_NON_FIP;
 		}
 		spin_unlock_bh(&fip->lock);

