From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/20] libfc: fix typo in retry check on received PRLI
Date: Wed, 21 Oct 2009 16:26:45 -0700
Message-ID: <20091021232645.12986.98692.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18756 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZJUX1A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:27:00 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

A received Fibre Channel ELS PRLI request contains a bit that
indicates whether the remote port supports certain retry processing
sequences.  The test for this bit was somehow coded to use multiply
instead of AND!

This case would apply only for target mode operation, and it is
unlikely to be noticed as an initiator.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 03ea674..bdc9732 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1402,7 +1402,7 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 				break;
 			case FC_TYPE_FCP:
 				fcp_parm = ntohl(rspp->spp_params);
-				if (fcp_parm * FCP_SPPF_RETRY)
+				if (fcp_parm & FCP_SPPF_RETRY)
 					rdata->flags |= FC_RP_FLAGS_RETRY;
 				rdata->supported_classes = FC_COS_CLASS3;
 				if (fcp_parm & FCP_SPPF_INIT_FCN)

