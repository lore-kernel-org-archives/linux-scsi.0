From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 2/2] bnx2i : Fix "cid #n not valid" issue
Date: Wed, 29 Jul 2009 21:50:11 -0700
Message-ID: <1248929411.26650.350.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4780 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZG3EuP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2009 00:50:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, mchan@broadcom.com


    * when bnx2i_adapter_ready() fails, connection handle(cid) = 0 is
      wrongly freed because 'cid' is not yet allocated for the endpoint
    * Fix is to initialize bnx2i_ep->ep_iscsi_cid to '-1' in bnx2i_alloc_ep()
      and not in bnx2i_ep_connect() to avoid releasing invalid 'cid'
    * There is already a check in bnx2i_free_iscsi_cid() not to free
      invalid iscsi connection handle (-1)

Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 9535bb6..08d0bfc 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -387,6 +387,7 @@ static struct iscsi_endpoint *bnx2i_alloc_ep(struct bnx2i_hba *hba)
 	bnx2i_ep = ep->dd_data;
 	INIT_LIST_HEAD(&bnx2i_ep->link);
 	bnx2i_ep->state = EP_STATE_IDLE;
+	bnx2i_ep->ep_iscsi_cid = (u16) -1;
 	bnx2i_ep->hba = hba;
 	bnx2i_ep->hba_age = hba->age;
 	hba->ofld_conns_active++;
@@ -1678,8 +1679,6 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 		goto net_if_down;
 	}
 
-	bnx2i_ep->state = EP_STATE_IDLE;
-	bnx2i_ep->ep_iscsi_cid = (u16) -1;
 	bnx2i_ep->num_active_cmds = 0;
 	iscsi_cid = bnx2i_alloc_iscsi_cid(hba);
 	if (iscsi_cid == -1) {
-- 
1.5.4.3




