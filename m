From: Rob Love <robert.w.love@intel.com>
Subject: [PATCH] [FCoE] Don't create a duplicate port on reset
Date: Mon, 31 Dec 2007 11:17:31 -0800
Message-ID: <20071231191731.28996.95097.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42494 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXLaT0m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Dec 2007 14:26:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

P2P mode was failing due to a duplicate remote port being created when a reset occured.

Signed-off-by: Rob Love <robert.w.love@intel.com>
---

 drivers/scsi/ofc/libfc/fc_local_port.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index 95380f9..1911405 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -275,11 +275,9 @@ static void fc_local_port_ptp_setup(struct fc_local_port *lp,
 {
 	struct fc_remote_port *rp;
 
-	rp = fc_remote_port_lookup_create(lp->fl_vf, 0, remote_wwpn,
+	rp = fc_remote_port_lookup_create(lp->fl_vf, remote_fid, remote_wwpn,
 					  remote_wwnn);
 	if (rp) {
-		if (rp->rp_fid != remote_fid)
-			fc_remote_port_set_fid(rp, remote_fid);
 		if (lp->fl_ptp_rp)
 			fc_remote_port_release(lp->fl_ptp_rp);
 		lp->fl_ptp_rp = rp;

