From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 3/8] bnx2fc: support software fcoe target
Date: Fri, 21 Dec 2012 19:40:29 -0800
Message-ID: <1356147634-17252-4-git-send-email-bprakash@broadcom.com>
References: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2856 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2LVDkn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2012 22:40:43 -0500
In-Reply-To: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Software FCoE target always advertises RETRY bit even when there are no
tape LUNs behind the target. This causes the driver to enable FW support
for sequence level error recovery and perform REC/SRR. This patch
arrests the behavior by not enabling SLER feature for this target.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index b9d0d9c..4998b69 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -381,7 +381,9 @@ static int bnx2fc_init_tgt(struct bnx2fc_rport *tgt,
 	tgt->rq_cons_idx = 0;
 	atomic_set(&tgt->num_active_ios, 0);
 
-	if (rdata->flags & FC_RP_FLAGS_RETRY) {
+	if (rdata->flags & FC_RP_FLAGS_RETRY &&
+	    rdata->ids.roles | FC_RPORT_ROLE_FCP_TARGET &&
+	    !(rdata->ids.roles | FC_RPORT_ROLE_FCP_INITIATOR)) {
 		tgt->dev_type = TYPE_TAPE;
 		tgt->io_timeout = 0; /* use default ULP timeout */
 	} else {
-- 
1.7.0.6


