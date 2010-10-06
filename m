From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Subject: [PATCH 2/3] be2iscsi: Remove premature free of cid
Date: Wed, 6 Oct 2010 23:46:03 +0530
Message-ID: <20101006181603.GA25785@emulex.com>
Reply-To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:45187 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752114Ab0JFSR2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 14:17:28 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

          Removing unnecessary beiscsi_put_cid that
was freeing up the cid while in use

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com> 
---
 drivers/scsi/be2iscsi/be_iscsi.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 7f11f3e..eaaa881 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -522,7 +522,6 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	if (beiscsi_ep->ep_cid > (phba->fw_config.iscsi_cid_start +
 				  phba->params.cxns_per_ctrl * 2)) {
 		SE_DEBUG(DBG_LVL_1, "Failed in allocate iscsi cid\n");
-		beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
 		goto free_ep;
 	}
 
@@ -559,7 +558,6 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		SE_DEBUG(DBG_LVL_1, "mgmt_open_connection Failed"
 				    " status = %d extd_status = %d\n",
 				    status, extd_status);
-		beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
 		free_mcc_tag(&phba->ctrl, tag);
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 			    nonemb_cmd.va, nonemb_cmd.dma);
@@ -574,7 +572,6 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		beiscsi_ep->cid_vld = 1;
 		SE_DEBUG(DBG_LVL_8, "mgmt_open_connection Success\n");
 	}
-	beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
 	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 			    nonemb_cmd.va, nonemb_cmd.dma);
 	return 0;
-- 
1.7.1

