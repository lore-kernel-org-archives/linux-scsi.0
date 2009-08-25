From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 46/64] libfc: fix: empty zone causes endless discovery retries.
Date: Tue, 25 Aug 2009 14:02:33 -0700
Message-ID: <20090825210233.1553.82529.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19045 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbZHYVCb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:02:31 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

On some switches, an empty zone causes GPN_FT to be rejected
with reason 9 (unable) explanation 7 (FC-4 types not registered),
which causes discovery to be retried endlessly.  Treat this as
just an empty response and consider discovery complete.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |    3 +++
 include/scsi/fc/fc_gs.h      |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 844376c..9b8043b 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -617,6 +617,9 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 				    "(check zoning)\n", cp->ct_reason,
 				    cp->ct_explan);
 			event = DISC_EV_FAILED;
+			if (cp->ct_reason == FC_FS_RJT_UNABL &&
+			    cp->ct_explan == FC_FS_EXP_FTNR)
+				event = DISC_EV_SUCCESS;
 		} else {
 			FC_DISC_DBG(disc, "GPN_FT unexpected response code "
 				    "%x\n", ntohs(cp->ct_cmd));
diff --git a/include/scsi/fc/fc_gs.h b/include/scsi/fc/fc_gs.h
index ffab027..324dd0e 100644
--- a/include/scsi/fc/fc_gs.h
+++ b/include/scsi/fc/fc_gs.h
@@ -87,6 +87,7 @@ enum fc_ct_explan {
 	FC_FS_EXP_PNAM =	0x02,	/* port name not registered */
 	FC_FS_EXP_NNAM =	0x03,	/* node name not registered */
 	FC_FS_EXP_COS =		0x04,	/* class of service not registered */
+	FC_FS_EXP_FTNR =	0x07,	/* FC-4 types not registered */
 	/* definitions not complete */
 };
 

