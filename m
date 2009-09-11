From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/35] libfc: fix typo in retry check on received PRLI
Date: Fri, 11 Sep 2009 16:57:01 -0700
Message-ID: <20090911235700.27223.93022.stgit@localhost.localdomain>
References: <20090911235655.27223.69728.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10079 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175AbZIKX45 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:56:57 -0400
In-Reply-To: <20090911235655.27223.69728.stgit@localhost.localdomain>
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

