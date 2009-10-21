From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/20] libfc: Remove unused fc_lport pointer from
	fc_fcp_pkt_abort
Date: Wed, 21 Oct 2009 16:27:06 -0700
Message-ID: <20091021232706.12986.83741.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2918 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZJUX17 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:27:59 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

This argument isn't used, let's not pass it into the routine.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index e613eb8..ade962d 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1097,7 +1097,7 @@ unlock:
  * Scsi abort handler- calls to send an abort
  * and then wait for abort completion
  */
-static int fc_fcp_pkt_abort(struct fc_lport *lp, struct fc_fcp_pkt *fsp)
+static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
 {
 	int rc = FAILED;
 
@@ -1945,7 +1945,7 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		goto release_pkt;
 	}
 
-	rc = fc_fcp_pkt_abort(lp, fsp);
+	rc = fc_fcp_pkt_abort(fsp);
 	fc_fcp_unlock_pkt(fsp);
 
 release_pkt:

