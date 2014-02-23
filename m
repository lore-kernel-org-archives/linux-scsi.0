From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 11/11] IB/iser: Publish T10-PI support to SCSI midlayer
Date: Sun, 23 Feb 2014 14:19:34 +0200
Message-ID: <1393157974-24931-12-git-send-email-sagig@mellanox.com>
References: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:40926 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751325AbaBWMTm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Feb 2014 07:19:42 -0500
In-Reply-To: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org
Cc: oren@mellanox.com, martin.petersen@oracle.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

After allocating a scsi_host we set protection types
and guard type supported.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index f13d7e9..a0ec2d0 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -435,6 +435,17 @@ static void iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
 	iscsi_host_free(shost);
 }
 
+static inline unsigned int
+iser_dif_prot_caps(int prot_caps)
+{
+	return ((prot_caps & IB_PROT_T10DIF_TYPE_1) ? SHOST_DIF_TYPE1_PROTECTION |
+						      SHOST_DIX_TYPE1_PROTECTION : 0) |
+	       ((prot_caps & IB_PROT_T10DIF_TYPE_2) ? SHOST_DIF_TYPE2_PROTECTION |
+						      SHOST_DIX_TYPE2_PROTECTION : 0) |
+	       ((prot_caps & IB_PROT_T10DIF_TYPE_3) ? SHOST_DIF_TYPE3_PROTECTION |
+						      SHOST_DIX_TYPE3_PROTECTION : 0);
+}
+
 static struct iscsi_cls_session *
 iscsi_iser_session_create(struct iscsi_endpoint *ep,
 			  uint16_t cmds_max, uint16_t qdepth,
@@ -459,8 +470,18 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	 * older userspace tools (before 2.0-870) did not pass us
 	 * the leading conn's ep so this will be NULL;
 	 */
-	if (ep)
+	if (ep) {
 		ib_conn = ep->dd_data;
+		if (ib_conn->pi_support) {
+			u32 sig_caps = ib_conn->device->dev_attr.sig_prot_cap;
+
+			scsi_host_set_prot(shost, iser_dif_prot_caps(sig_caps));
+			if (iser_pi_guard)
+				scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP);
+			else
+				scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+		}
+	}
 
 	if (iscsi_host_add(shost,
 			   ep ? ib_conn->device->ib_device->dma_device : NULL))
-- 
1.7.1

