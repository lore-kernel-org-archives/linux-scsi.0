From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 28/35] libfc: Remove unused fc_lport pointer from
	fc_fcp_pkt_abort
Date: Fri, 11 Sep 2009 16:59:24 -0700
Message-ID: <20090911235924.27223.8974.stgit@localhost.localdomain>
References: <20090911235655.27223.69728.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35605 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbZIKX7V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:59:21 -0400
In-Reply-To: <20090911235655.27223.69728.stgit@localhost.localdomain>
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
index a523e4f..fb4b35d 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1055,7 +1055,7 @@ unlock:
  * Scsi abort handler- calls to send an abort
  * and then wait for abort completion
  */
-static int fc_fcp_pkt_abort(struct fc_lport *lp, struct fc_fcp_pkt *fsp)
+static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
 {
 	int rc = FAILED;
 
@@ -1871,7 +1871,7 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		goto release_pkt;
 	}
 
-	rc = fc_fcp_pkt_abort(lp, fsp);
+	rc = fc_fcp_pkt_abort(fsp);
 	fc_fcp_unlock_pkt(fsp);
 
 release_pkt:

