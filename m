From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/15] libfc: Change state to NONE in fc_lport_destroy
Date: Fri, 03 Apr 2009 14:58:24 -0700
Message-ID: <20090403215824.10856.66466.stgit@fritz>
References: <20090403215758.10856.6946.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:53705 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759045AbZDCV61 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 17:58:27 -0400
In-Reply-To: <20090403215758.10856.6946.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

From: Abhijeet Joglekar <abjoglek@cisco.com>

After lport_destroy, the local port should not be used again. Transition
to state NONE, any incoming frames or link up should not transition out
of this state since we are deleting exchange table and cleaning up the
local port. Also, mark link as down.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 4cd9533..e0c2477 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -644,7 +644,12 @@ EXPORT_SYMBOL(fc_fabric_logoff);
  */
 int fc_lport_destroy(struct fc_lport *lport)
 {
+	mutex_lock(&lport->lp_mutex);
+	lport->state = LPORT_ST_NONE;
+	lport->link_up = 0;
 	lport->tt.frame_send = fc_frame_drop;
+	mutex_unlock(&lport->lp_mutex);
+
 	lport->tt.fcp_abort_io(lport);
 	lport->tt.exch_mgr_reset(lport, 0, 0);
 	return 0;

