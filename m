From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] fnic: check pci_map_single() return value
Date: Wed, 12 Aug 2015 11:20:08 +0200
Message-ID: <1439371208-19841-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbbHLJUL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Aug 2015 05:20:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hiralpat@cisco.com, sramars@cisco.com, buchino@cisco.com, jbottomley@parallels.com

the kernel prints some warnings when compiled with CONFIG_DMA_API_DEBUG.
This is because the fnic driver doesn't check the return value of
pci_map_single().

[   11.942770] scsi host12: fnic
[   11.950811] ------------[ cut here ]------------
[   11.950818] WARNING: at lib/dma-debug.c:937 check_unmap+0x47b/0x920()
[   11.950821] fnic 0000:0c:00.0: DMA-API: device driver failed to check map error[device address=0x0000002020a30040] [size=44 bytes] [mapped as single]

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/fnic/fnic_fcs.c  | 32 +++++++++++++++++++++++++++++---
 drivers/scsi/fnic/fnic_scsi.c | 16 ++++++++++++++++
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index bf0bbd4..4adf9c3 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -939,6 +939,7 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	struct sk_buff *skb;
 	u16 len;
 	dma_addr_t pa;
+	int r;
 
 	len = FC_FRAME_HEADROOM + FC_MAX_FRAME + FC_FRAME_TAILROOM;
 	skb = dev_alloc_skb(len);
@@ -952,8 +953,17 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	skb_reset_network_header(skb);
 	skb_put(skb, len);
 	pa = pci_map_single(fnic->pdev, skb->data, len, PCI_DMA_FROMDEVICE);
+
+	r = pci_dma_mapping_error(fnic->pdev, pa);
+	if (r) {
+		printk(KERN_ERR "PCI mapping failed with error %d\n", r);
+		kfree_skb(skb);
+		goto err;
+	}
+
 	fnic_queue_rq_desc(rq, skb, pa, len);
-	return 0;
+err:
+	return r;
 }
 
 void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf)
@@ -981,6 +991,7 @@ void fnic_eth_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	struct ethhdr *eth_hdr;
 	struct vlan_ethhdr *vlan_hdr;
 	unsigned long flags;
+	int r;
 
 	if (!fnic->vlan_hw_insert) {
 		eth_hdr = (struct ethhdr *)skb_mac_header(skb);
@@ -1003,6 +1014,13 @@ void fnic_eth_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 
 	pa = pci_map_single(fnic->pdev, skb->data, skb->len, PCI_DMA_TODEVICE);
 
+	r = pci_dma_mapping_error(fnic->pdev, pa);
+	if (r) {
+		printk(KERN_ERR "PCI mapping failed with error %d\n", r);
+		kfree_skb(skb);
+		return;
+	}
+
 	spin_lock_irqsave(&fnic->wq_lock[0], flags);
 	if (!vnic_wq_desc_avail(wq)) {
 		pci_unmap_single(fnic->pdev, pa, skb->len, PCI_DMA_TODEVICE);
@@ -1071,6 +1089,12 @@ static int fnic_send_frame(struct fnic *fnic, struct fc_frame *fp)
 
 	pa = pci_map_single(fnic->pdev, eth_hdr, tot_len, PCI_DMA_TODEVICE);
 
+	ret = pci_dma_mapping_error(fnic->pdev, pa);
+	if (ret) {
+		printk(KERN_ERR "DMA map failed with error %d\n", ret);
+		goto err_mapping_error;
+	}
+
 	if ((fnic_fc_trace_set_data(fnic->lport->host->host_no, FNIC_FC_SEND,
 				(char *)eth_hdr, tot_len)) != 0) {
 		printk(KERN_ERR "fnic ctlr frame trace error!!!");
@@ -1082,15 +1106,17 @@ static int fnic_send_frame(struct fnic *fnic, struct fc_frame *fp)
 		pci_unmap_single(fnic->pdev, pa,
 				 tot_len, PCI_DMA_TODEVICE);
 		ret = -1;
-		goto fnic_send_frame_end;
+		goto err_desc_avail;
 	}
 
 	fnic_queue_wq_desc(wq, skb, pa, tot_len, fr_eof(fp),
 			   0 /* hw inserts cos value */,
 			   fnic->vlan_id, 1, 1, 1);
-fnic_send_frame_end:
+
+err_desc_avail:
 	spin_unlock_irqrestore(&fnic->wq_lock[0], flags);
 
+err_mapping_error:
 	if (ret)
 		dev_kfree_skb_any(fp_skb(fp));
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 155b286..2949d17 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -330,6 +330,7 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 	int flags;
 	u8 exch_flags;
 	struct scsi_lun fc_lun;
+	int r;
 
 	if (sg_count) {
 		/* For each SGE, create a device desc entry */
@@ -346,6 +347,12 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 			 io_req->sgl_list,
 			 sizeof(io_req->sgl_list[0]) * sg_count,
 			 PCI_DMA_TODEVICE);
+
+		r = pci_dma_mapping_error(fnic->pdev, io_req->sgl_list_pa);
+		if (r) {
+			printk(KERN_ERR "PCI mapping failed with error %d\n", r);
+			return SCSI_MLQUEUE_HOST_BUSY;
+		}
 	}
 
 	io_req->sense_buf_pa = pci_map_single(fnic->pdev,
@@ -353,6 +360,15 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 					      SCSI_SENSE_BUFFERSIZE,
 					      PCI_DMA_FROMDEVICE);
 
+	r = pci_dma_mapping_error(fnic->pdev, io_req->sense_buf_pa);
+	if (r) {
+		pci_unmap_single(fnic->pdev, io_req->sgl_list_pa,
+				sizeof(io_req->sgl_list[0]) * sg_count,
+				PCI_DMA_TODEVICE);
+		printk(KERN_ERR "PCI mapping failed with error %d\n", r);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
 	int_to_scsilun(sc->device->lun, &fc_lun);
 
 	/* Enqueue the descriptor in the Copy WQ */
-- 
Maurizio Lombardi

