From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 2/4] libfc: Correct check for initiator role
Date: Tue, 21 May 2013 10:44:40 -0700
Message-ID: <20130521174440.3033.53154.stgit@fritz>
References: <20130521174426.3033.16298.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3119 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab3EURol (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 May 2013 13:44:41 -0400
In-Reply-To: <20130521174426.3033.16298.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Morgan <jack.morgan@intel.com>, Mark Rustad <mark.d.rustad@intel.com>

From: Mark Rustad <mark.d.rustad@intel.com>

The service_params field is being checked against the symbol
FC_RPORT_ROLE_FCP_INITIATOR where it really should be checked
against FCP_SPPF_INIT_FCN.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index d518d17..6bbb944 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1962,7 +1962,7 @@ static int fc_rport_fcp_prli(struct fc_rport_priv *rdata, u32 spp_len,
 		rdata->flags |= FC_RP_FLAGS_RETRY;
 	rdata->supported_classes = FC_COS_CLASS3;
 
-	if (!(lport->service_params & FC_RPORT_ROLE_FCP_INITIATOR))
+	if (!(lport->service_params & FCP_SPPF_INIT_FCN))
 		return 0;
 
 	spp->spp_flags |= rspp->spp_flags & FC_SPP_EST_IMG_PAIR;

