From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/16] fcoe: call fcoe_ctlr_els_send even for ELS responses
Date: Fri, 12 Mar 2010 16:07:52 -0800
Message-ID: <20100313000752.22251.56121.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23556 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934747Ab0CMAHw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:07:52 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

In point-to-point mode, the destination MAC address for
the FLOGI response was zero because the LS_ACC for the FLOGI
wasn't getting intercepted by FIP.

Change to call fcoe_ctlr_els_send when sending any ELS,
not just requests.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 2f47ae7..2f3b73c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1443,7 +1443,7 @@ int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 		return 0;
 	}
 
-	if (unlikely(fh->fh_r_ctl == FC_RCTL_ELS_REQ) &&
+	if (unlikely(fh->fh_type == FC_TYPE_ELS) &&
 	    fcoe_ctlr_els_send(&fcoe->ctlr, lport, skb))
 		return 0;
 

