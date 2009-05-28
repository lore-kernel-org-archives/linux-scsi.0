From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 08/10] ibmvfc: Improve device rediscovery
Date: Thu, 28 May 2009 16:17:32 -0500
Message-ID: <200905282117.n4SLHWP9001561@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40683 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760931AbZE1VRb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 May 2009 17:17:31 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n4SLK5IP023581
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:20:05 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4SLHXPM182070
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:17:33 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4SLHXLN001580
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:17:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


For certain scenarios during device rediscovery, we detect we need
to log back into a target. Currently we do just that - PLOGI/PRLI
back into the target. Change the code to delete and add the target
from the FC transport layer as well, to ensure we handle any cases
where the target may have changed.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_less_need_login drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_less_need_login	2009-04-21 14:27:03.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-04-21 14:27:03.000000000 -0500
@@ -583,7 +583,7 @@ static void ibmvfc_init_host(struct ibmv
 		}
 
 		list_for_each_entry(tgt, &vhost->targets, queue)
-			tgt->need_login = 1;
+			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		scsi_block_requests(vhost->host);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
 		vhost->job_step = ibmvfc_npiv_login;
@@ -3155,13 +3155,13 @@ static void ibmvfc_tgt_adisc_done(struct
 	case IBMVFC_MAD_SUCCESS:
 		tgt_dbg(tgt, "ADISC succeeded\n");
 		if (ibmvfc_adisc_needs_plogi(mad, tgt))
-			tgt->need_login = 1;
+			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		break;
 	case IBMVFC_MAD_DRIVER_FAILED:
 		break;
 	case IBMVFC_MAD_FAILED:
 	default:
-		tgt->need_login = 1;
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		fc_reason = (mad->fc_iu.response[1] & 0x00ff0000) >> 16;
 		fc_explain = (mad->fc_iu.response[1] & 0x0000ff00) >> 8;
 		tgt_info(tgt, "ADISC failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
_
