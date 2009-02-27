From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/24] libfc: correct RPORT_TO_PRIV usage
Date: Fri, 27 Feb 2009 10:55:23 -0800
Message-ID: <20090227185523.25509.67474.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13088 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbZB0SzZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:55:25 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

We only need to use this macro when assigning a value to
rport->dd_data. All other accesses should just use dd_data.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 15e3f84..9f4e408 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -246,7 +246,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 			list_del(&dp->peers);
 			rport = lport->tt.rport_lookup(lport, dp->ids.port_id);
 			if (rport) {
-				rdata = RPORT_TO_PRIV(rport);
+				rdata = rport->dd_data;
 				list_del(&rdata->peers);
 				lport->tt.rport_logoff(rport);
 			}
@@ -453,7 +453,7 @@ static int fc_disc_new_target(struct fc_disc *disc,
 static void fc_disc_del_target(struct fc_disc *disc, struct fc_rport *rport)
 {
 	struct fc_lport *lport = disc->lport;
-	struct fc_rport_libfc_priv *rdata = RPORT_TO_PRIV(rport);
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	list_del(&rdata->peers);
 	lport->tt.rport_logoff(rport);
 }

