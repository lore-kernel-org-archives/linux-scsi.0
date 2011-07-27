From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/10] libfc: cleanup sending SRR request
Date: Wed, 27 Jul 2011 15:10:49 -0700
Message-ID: <20110727221049.23675.73918.stgit@localhost6.localdomain6>
References: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56632 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab1G0WKu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 18:10:50 -0400
In-Reply-To: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

The variable on stack, namely cdb_op, is not used but removed.

[ Patch reworked by Robert Love due to invalid patch format ]

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 57311d0..14dd121 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1645,12 +1645,10 @@ static void fc_fcp_srr(struct fc_fcp_pkt *fsp, enum fc_rctl r_ctl, u32 offset)
 	struct fc_seq *seq;
 	struct fcp_srr *srr;
 	struct fc_frame *fp;
-	u8 cdb_op;
 	unsigned int rec_tov;
 
 	rport = fsp->rport;
 	rpriv = rport->dd_data;
-	cdb_op = fsp->cdb_cmd.fc_cdb[0];
 
 	if (!(rpriv->flags & FC_RP_FLAGS_RETRY) ||
 	    rpriv->rp_state != RPORT_ST_READY)

