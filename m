From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 13/13] IB/iser: Publish T10-PI support to SCSI midlayer
Date: Wed,  5 Mar 2014 19:43:51 +0200
Message-ID: <1394041431-28399-14-git-send-email-sagig@mellanox.com>
References: <1394041431-28399-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394041431-28399-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Cc: martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

After allocating a scsi_host we set protection types
and guard type supported.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
