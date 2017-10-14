From: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] scsi: fnic: Clean up redundant variables
Date: Sat, 14 Oct 2017 13:52:55 +0100
Message-ID: <1507985575-25516-1-git-send-email-chris.gekas@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Remove variables that are set but not used.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 drivers/scsi/fnic/fnic_fcs.c | 9 ---------
 drivers/scsi/fnic/vnic_rq.c  | 3 ---
 drivers/scsi/fnic/vnic_wq.c  | 3 ---
 3 files changed, 15 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 999fc75..bc1fcce 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -293,12 +293,10 @@ static inline int is_fnic_fip_flogi_reject(struct fcoe_ctlr *fip,
 	struct fc_frame_header *fh = NULL;
 	struct fip_desc *desc;
 	struct fip_encaps *els;
-	enum fip_desc_type els_dtype = 0;
 	u16 op;
 	u8 els_op;
 	u8 sub;
 
-	size_t els_len = 0;
 	size_t rlen;
 	size_t dlen = 0;
 
@@ -330,10 +328,8 @@ static inline int is_fnic_fip_flogi_reject(struct fcoe_ctlr *fip,
 		if (dlen < sizeof(*els) + sizeof(*fh) + 1)
 			return 0;
 
-		els_len = dlen - sizeof(*els);
 		els = (struct fip_encaps *)desc;
 		fh = (struct fc_frame_header *)(els + 1);
-		els_dtype = desc->fip_dtype;
 
 		if (!fh)
 			return 0;
@@ -360,7 +356,6 @@ static void fnic_fcoe_send_vlan_req(struct fnic *fnic)
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	struct sk_buff *skb;
 	char *eth_fr;
-	int fr_len;
 	struct fip_vlan *vlan;
 	u64 vlan_tov;
 
@@ -375,7 +370,6 @@ static void fnic_fcoe_send_vlan_req(struct fnic *fnic)
 	if (!skb)
 		return;
 
-	fr_len = sizeof(*vlan);
 	eth_fr = (char *)skb->data;
 	vlan = (struct fip_vlan *)eth_fr;
 
@@ -823,7 +817,6 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 	struct sk_buff *skb;
 	struct fc_frame *fp;
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
-	unsigned int eth_hdrs_stripped;
 	u8 type, color, eop, sop, ingress_port, vlan_stripped;
 	u8 fcoe = 0, fcoe_sof, fcoe_eof;
 	u8 fcoe_fc_crc_ok = 1, fcoe_enc_error = 0;
@@ -853,7 +846,6 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 				   &ingress_port, &packet_error,
 				   &fcoe_enc_error, &fcs_ok, &vlan_stripped,
 				   &vlan);
-		eth_hdrs_stripped = 1;
 		skb_trim(skb, fcp_bytes_written);
 		fr_sof(fp) = sof;
 		fr_eof(fp) = eof;
@@ -870,7 +862,6 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 				    &tcp_udp_csum_ok, &udp, &tcp,
 				    &ipv4_csum_ok, &ipv6, &ipv4,
 				    &ipv4_fragment, &fcs_ok);
-		eth_hdrs_stripped = 0;
 		skb_trim(skb, bytes_written);
 		if (!fcs_ok) {
 			atomic64_inc(&fnic_stats->misc_stats.frame_errors);
diff --git a/drivers/scsi/fnic/vnic_rq.c b/drivers/scsi/fnic/vnic_rq.c
index fd2068f..ae8b78c 100644
--- a/drivers/scsi/fnic/vnic_rq.c
+++ b/drivers/scsi/fnic/vnic_rq.c
@@ -27,12 +27,9 @@
 static int vnic_rq_alloc_bufs(struct vnic_rq *rq)
 {
 	struct vnic_rq_buf *buf;
-	struct vnic_dev *vdev;
 	unsigned int i, j, count = rq->ring.desc_count;
 	unsigned int blks = VNIC_RQ_BUF_BLKS_NEEDED(count);
 
-	vdev = rq->vdev;
-
 	for (i = 0; i < blks; i++) {
 		rq->bufs[i] = kzalloc(VNIC_RQ_BUF_BLK_SZ, GFP_ATOMIC);
 		if (!rq->bufs[i]) {
diff --git a/drivers/scsi/fnic/vnic_wq.c b/drivers/scsi/fnic/vnic_wq.c
index a414135..5f57809 100644
--- a/drivers/scsi/fnic/vnic_wq.c
+++ b/drivers/scsi/fnic/vnic_wq.c
@@ -27,12 +27,9 @@
 static int vnic_wq_alloc_bufs(struct vnic_wq *wq)
 {
 	struct vnic_wq_buf *buf;
-	struct vnic_dev *vdev;
 	unsigned int i, j, count = wq->ring.desc_count;
 	unsigned int blks = VNIC_WQ_BUF_BLKS_NEEDED(count);
 
-	vdev = wq->vdev;
-
 	for (i = 0; i < blks; i++) {
 		wq->bufs[i] = kzalloc(VNIC_WQ_BUF_BLK_SZ, GFP_ATOMIC);
 		if (!wq->bufs[i]) {
-- 
2.7.4
