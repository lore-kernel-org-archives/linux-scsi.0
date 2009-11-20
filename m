From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 5/9] libfcoe: add tracking FIP Virtual Link Failure count
Date: Fri, 20 Nov 2009 14:55:02 -0800
Message-ID: <20091120225502.495.80419.stgit@localhost.localdomain>
References: <20091120225436.495.88600.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:14332 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbZKTWy6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 17:54:58 -0500
In-Reply-To: <20091120225436.495.88600.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Add tracking the Virtual Link Failure count when either we have found
the FCF as "aged" or we are receiving FIP Clear Virtual Link from the
FCF.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 9961fd7..34800af 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -578,6 +578,7 @@ static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 			WARN_ON(!fip->fcf_count);
 			fip->fcf_count--;
 			kfree(fcf);
+			fc_lport_get_stats(fip->lp)->VLinkFailureCount++;
 		} else if (fcoe_ctlr_mtu_valid(fcf) &&
 			   (!sel_time || time_before(sel_time, fcf->time))) {
 			sel_time = fcf->time;
@@ -990,6 +991,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 		LIBFCOE_FIP_DBG(fip, "performing Clear Virtual Link\n");
 
 		spin_lock_bh(&fip->lock);
+		fc_lport_get_stats(lport)->VLinkFailureCount++;
 		fcoe_ctlr_reset(fip);
 		spin_unlock_bh(&fip->lock);
 

