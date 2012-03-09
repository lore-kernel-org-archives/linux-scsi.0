From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/10] libfcoe: Do not sends FDISCs before FLOGI during CVL
Date: Fri, 09 Mar 2012 14:49:53 -0800
Message-ID: <20120309224953.6515.45655.stgit@localhost6.localdomain6>
References: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55949 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab2CIWty (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2012 17:49:54 -0500
In-Reply-To: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

When handling CVL with no Vx port descriptors, lports for NPIV ports are reset
before issuing the ctlr_reset. This causes FDISCs to be issued before
successful FLOGI. Fix it by resetting the controller before resetting the
lports.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index e7522dc..a43dad2 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1273,11 +1273,6 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 		 * No Vx_Port description. Clear all NPIV ports,
 		 * followed by physical port
 		 */
-		mutex_lock(&lport->lp_mutex);
-		list_for_each_entry(vn_port, &lport->vports, list)
-			fc_lport_reset(vn_port);
-		mutex_unlock(&lport->lp_mutex);
-
 		mutex_lock(&fip->ctlr_mutex);
 		per_cpu_ptr(lport->dev_stats,
 			    get_cpu())->VLinkFailureCount++;
@@ -1285,6 +1280,11 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 		fcoe_ctlr_reset(fip);
 		mutex_unlock(&fip->ctlr_mutex);
 
+		mutex_lock(&lport->lp_mutex);
+		list_for_each_entry(vn_port, &lport->vports, list)
+			fc_lport_reset(vn_port);
+		mutex_unlock(&lport->lp_mutex);
+
 		fc_lport_reset(fip->lp);
 		fcoe_ctlr_solicit(fip, NULL);
 	} else {

