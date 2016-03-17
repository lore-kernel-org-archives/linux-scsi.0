From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH 5/8] snic: Fix for missing interrupts
Date: Thu, 17 Mar 2016 00:51:14 -0700
Message-ID: <1458201077-10211-5-git-send-email-nmusini@cisco.com>
References: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-5.cisco.com ([173.37.142.92]:2629 "EHLO
	alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652AbcCQH5h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2016 03:57:37 -0400
In-Reply-To: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

- On posting an IO to the firmware, adapter generates an interrupt.
  Due to hardware issues, some times the adapter fails to generate
  the interrupt. This behavior skips updating transmit queue-
  counters, which inturn causes the queue full condition. The fix
  addresses the queue full condition.

- The fix also reserves a slot in transmit queue for hba reset.
  when queue full is observed during IO, there will always be room
  to post hba reset command.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/snic/snic_fwint.h |  4 ++-
 drivers/scsi/snic/snic_io.c    | 62 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/snic/snic_fwint.h b/drivers/scsi/snic/snic_fwint.h
index 2cfaf2d..c5f9e19 100644
--- a/drivers/scsi/snic/snic_fwint.h
+++ b/drivers/scsi/snic/snic_fwint.h
@@ -414,7 +414,7 @@ enum snic_ev_type {
 /* Payload 88 bytes = 128 - 24 - 16 */
 #define SNIC_HOST_REQ_PAYLOAD	((int)(SNIC_HOST_REQ_LEN -		\
 					sizeof(struct snic_io_hdr) -	\
-					(2 * sizeof(u64))))
+					(2 * sizeof(u64)) - sizeof(ulong)))
 
 /*
  * snic_host_req: host -> firmware request
@@ -448,6 +448,8 @@ struct snic_host_req {
 		/* hba reset */
 		struct snic_hba_reset		reset;
 	} u;
+
+	ulong req_pa;
 }; /* end of snic_host_req structure */
 
 
diff --git a/drivers/scsi/snic/snic_io.c b/drivers/scsi/snic/snic_io.c
index 993db7d..8e69548 100644
--- a/drivers/scsi/snic/snic_io.c
+++ b/drivers/scsi/snic/snic_io.c
@@ -48,7 +48,7 @@ snic_wq_cmpl_frame_send(struct vnic_wq *wq,
 	SNIC_TRC(snic->shost->host_no, 0, 0,
 		 ((ulong)(buf->os_buf) - sizeof(struct snic_req_info)), 0, 0,
 		 0);
-	pci_unmap_single(snic->pdev, buf->dma_addr, buf->len, PCI_DMA_TODEVICE);
+
 	buf->os_buf = NULL;
 }
 
@@ -137,13 +137,36 @@ snic_select_wq(struct snic *snic)
 	return 0;
 }
 
+static int
+snic_wqdesc_avail(struct snic *snic, int q_num, int req_type)
+{
+	int nr_wqdesc = snic->config.wq_enet_desc_count;
+
+	if (q_num > 0) {
+		/*
+		 * Multi Queue case, additional care is required.
+		 * Per WQ active requests need to be maintained.
+		 */
+		SNIC_HOST_INFO(snic->shost, "desc_avail: Multi Queue case.\n");
+		SNIC_BUG_ON(q_num > 0);
+
+		return -1;
+	}
+
+	nr_wqdesc -= atomic64_read(&snic->s_stats.fw.actv_reqs);
+
+	return ((req_type == SNIC_REQ_HBA_RESET) ? nr_wqdesc : nr_wqdesc - 1);
+}
+
 int
 snic_queue_wq_desc(struct snic *snic, void *os_buf, u16 len)
 {
 	dma_addr_t pa = 0;
 	unsigned long flags;
 	struct snic_fw_stats *fwstats = &snic->s_stats.fw;
+	struct snic_host_req *req = (struct snic_host_req *) os_buf;
 	long act_reqs;
+	long desc_avail = 0;
 	int q_num = 0;
 
 	snic_print_desc(__func__, os_buf, len);
@@ -156,11 +179,15 @@ snic_queue_wq_desc(struct snic *snic, void *os_buf, u16 len)
 		return -ENOMEM;
 	}
 
+	req->req_pa = (ulong)pa;
+
 	q_num = snic_select_wq(snic);
 
 	spin_lock_irqsave(&snic->wq_lock[q_num], flags);
-	if (!svnic_wq_desc_avail(snic->wq)) {
+	desc_avail = snic_wqdesc_avail(snic, q_num, req->hdr.type);
+	if (desc_avail <= 0) {
 		pci_unmap_single(snic->pdev, pa, len, PCI_DMA_TODEVICE);
+		req->req_pa = 0;
 		spin_unlock_irqrestore(&snic->wq_lock[q_num], flags);
 		atomic64_inc(&snic->s_stats.misc.wq_alloc_fail);
 		SNIC_DBG("host = %d, WQ is Full\n", snic->shost->host_no);
@@ -169,10 +196,13 @@ snic_queue_wq_desc(struct snic *snic, void *os_buf, u16 len)
 	}
 
 	snic_queue_wq_eth_desc(&snic->wq[q_num], os_buf, pa, len, 0, 0, 1);
+	/*
+	 * Update stats
+	 * note: when multi queue enabled, fw actv_reqs should be per queue.
+	 */
+	act_reqs = atomic64_inc_return(&fwstats->actv_reqs);
 	spin_unlock_irqrestore(&snic->wq_lock[q_num], flags);
 
-	/* Update stats */
-	act_reqs = atomic64_inc_return(&fwstats->actv_reqs);
 	if (act_reqs > atomic64_read(&fwstats->max_actv_reqs))
 		atomic64_set(&fwstats->max_actv_reqs, act_reqs);
 
@@ -318,11 +348,31 @@ snic_req_free(struct snic *snic, struct snic_req_info *rqi)
 		      "Req_free:rqi %p:ioreq %p:abt %p:dr %p\n",
 		      rqi, rqi->req, rqi->abort_req, rqi->dr_req);
 
-	if (rqi->abort_req)
+	if (rqi->abort_req) {
+		if (rqi->abort_req->req_pa)
+			pci_unmap_single(snic->pdev,
+					 rqi->abort_req->req_pa,
+					 sizeof(struct snic_host_req),
+					 PCI_DMA_TODEVICE);
+
 		mempool_free(rqi->abort_req, snic->req_pool[SNIC_REQ_TM_CACHE]);
+	}
+
+	if (rqi->dr_req) {
+		if (rqi->dr_req->req_pa)
+			pci_unmap_single(snic->pdev,
+					 rqi->dr_req->req_pa,
+					 sizeof(struct snic_host_req),
+					 PCI_DMA_TODEVICE);
 
-	if (rqi->dr_req)
 		mempool_free(rqi->dr_req, snic->req_pool[SNIC_REQ_TM_CACHE]);
+	}
+
+	if (rqi->req->req_pa)
+		pci_unmap_single(snic->pdev,
+				 rqi->req->req_pa,
+				 rqi->req_len,
+				 PCI_DMA_TODEVICE);
 
 	mempool_free(rqi, snic->req_pool[rqi->rq_pool_type]);
 }
-- 
1.8.5.4

