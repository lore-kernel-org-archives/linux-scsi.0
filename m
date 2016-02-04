From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v1 08/12] be2iscsi: Fix MCC WRB leak in open_connection
Date: Thu,  4 Feb 2016 15:49:16 +0530
Message-ID: <1454581160-31869-9-git-send-email-jitendra.bhivare@broadcom.com>
References: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:62101 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933439AbcBDKhg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 05:37:36 -0500
In-Reply-To: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

In open with IP of unknown address family, only tag is freed and error
returned. MCC WRB allocated for the operation is not freed.

Added check for supported family of IP in the beginning before
allocating the tag and WRB.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/be2iscsi/be_mgmt.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 85044b8..ccac1d7 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -829,6 +829,13 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	unsigned short cid = beiscsi_ep->ep_cid;
 	struct be_sge *sge;
 
+	if (dst_addr->sa_family != PF_INET && dst_addr->sa_family != PF_INET6) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
+			    "BG_%d : unknown addr family %d\n",
+			    dst_addr->sa_family);
+		return -EINVAL;
+	}
+
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 
@@ -868,7 +875,8 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 		beiscsi_ep->dst_addr = daddr_in->sin_addr.s_addr;
 		beiscsi_ep->dst_tcpport = ntohs(daddr_in->sin_port);
 		beiscsi_ep->ip_type = BE2_IPV4;
-	} else if (dst_addr->sa_family == PF_INET6) {
+	} else {
+		/* else its PF_INET6 family */
 		req->ip_address.ip_type = BE2_IPV6;
 		memcpy(&req->ip_address.addr,
 		       &daddr_in6->sin6_addr.in6_u.u6_addr8, 16);
@@ -877,14 +885,6 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 		memcpy(&beiscsi_ep->dst6_addr,
 		       &daddr_in6->sin6_addr.in6_u.u6_addr8, 16);
 		beiscsi_ep->ip_type = BE2_IPV6;
-	} else{
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BG_%d : unknown addr family %d\n",
-			    dst_addr->sa_family);
-		mutex_unlock(&ctrl->mbox_lock);
-		free_mcc_tag(&phba->ctrl, tag);
-		return -EINVAL;
-
 	}
 	req->cid = cid;
 	i = phba->nxt_cqid++;
-- 
2.5.0

