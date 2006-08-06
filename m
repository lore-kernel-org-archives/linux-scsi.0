From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: ibmvscsi on powerpc allmodconfig
Date: Sun, 06 Aug 2006 11:17:26 +0900
Message-ID: <20060806111726D.fujita.tomonori@lab.ntt.co.jp>
References: <20060805182514.94f43009.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:29368 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1030338AbWHFCSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Aug 2006 22:18:00 -0400
In-Reply-To: <20060805182514.94f43009.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, anton@samba.org, paulus@samba.org

From: Andrew Morton <akpm@osdl.org>
Subject: ibmvscsi on powerpc allmodconfig
Date: Sat, 5 Aug 2006 18:25:14 -0700

> drivers/scsi/ibmvscsi/ibmvstgt.c: In function `ibmvstgt_rdma':
> drivers/scsi/ibmvscsi/ibmvstgt.c:241: error: `H_Success' undeclared (first use in this function)
> drivers/scsi/ibmvscsi/ibmvstgt.c:241: error: (Each undeclared identifier is reported only once
> drivers/scsi/ibmvscsi/ibmvstgt.c:241: error: for each function it appears in.)
> drivers/scsi/ibmvscsi/ibmvstgt.c: In function `send_adapter_info':
> drivers/scsi/ibmvscsi/ibmvstgt.c:328: error: `H_Success' undeclared (first use in this function)
> 
> this has been happening for ages.

That's a target driver. Sorry, it's my fault. The problem is that the
scsi-target git tree on kernel.org doesn't include the latest target
code.

The following patch will update IBM VIO target driver for hvcall.h
changes.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

---

 drivers/scsi/ibmvscsi/ibmvstgt.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

b4caa26ac91778974dcbc4a2427c30de0239253e
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index c2c4244..cf1e851 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -238,7 +238,7 @@ static int ibmvstgt_rdma(struct iu_entry
 						  vport->riobn,
 						  md[i].va + mdone);
 
-			if (err != H_Success) {
+			if (err != H_SUCCESS) {
 				eprintk("rdma error %d %d\n", dir, slen);
 				goto out;
 			}
@@ -325,7 +325,7 @@ int send_adapter_info(struct iu_entry *i
 	/* Get remote info */
 	err = h_copy_rdma(sizeof(*info), vport->riobn, remote_buffer,
 			  vport->liobn, data_token);
-	if (err == H_Success) {
+	if (err == H_SUCCESS) {
 		dprintk("Client connect: %s (%d)\n",
 			info->partition_name, info->partition_number);
 	}
@@ -346,7 +346,7 @@ int send_adapter_info(struct iu_entry *i
 
 	dma_free_coherent(target->dev, sizeof(*info), info, data_token);
 
-	if (err != H_Success) {
+	if (err != H_SUCCESS) {
 		eprintk("Error sending adapter info %d\n", err);
 		return 1;
 	}
@@ -506,7 +506,7 @@ static void process_iu(struct viosrp_crq
 	err = h_copy_rdma(crq->IU_length, vport->riobn,
 			  iue->remote_token, vport->liobn, iue->sbuf->dma);
 
-	if (err != H_Success)
+	if (err != H_SUCCESS)
 		eprintk("%ld transferring data error %p\n", err, iue);
 
 	if (crq->format == VIOSRP_MAD_FORMAT)
@@ -552,16 +552,16 @@ static int crq_queue_create(struct crq_q
 	/* If the adapter was left active for some reason (like kexec)
 	 * try freeing and re-registering
 	 */
-	if (err == H_Resource) {
+	if (err == H_RESOURCE) {
 	    do {
 		err = h_free_crq(vport->dma_dev->unit_address);
-	    } while (err == H_Busy || H_isLongBusy(err));
+	    } while (err == H_BUSY || H_IS_LONG_BUSY(err));
 
 	    err = h_reg_crq(vport->dma_dev->unit_address, queue->msg_token,
 			    PAGE_SIZE);
 	}
 
-	if (err != H_Success && err != 2) {
+	if (err != H_SUCCESS && err != 2) {
 		eprintk("Error 0x%x opening virtual adapter\n", err);
 		goto reg_crq_failed;
 	}
@@ -583,7 +583,7 @@ static int crq_queue_create(struct crq_q
 req_irq_failed:
 	do {
 		err = h_free_crq(vport->dma_dev->unit_address);
-	} while (err == H_Busy || H_isLongBusy(err));
+	} while (err == H_BUSY || H_IS_LONG_BUSY(err));
 
 reg_crq_failed:
 	dma_unmap_single(target->dev, queue->msg_token,
@@ -604,7 +604,7 @@ static void crq_queue_destroy(struct srp
 	free_irq(vport->dma_dev->irq, target);
 	do {
 		err = h_free_crq(vport->dma_dev->unit_address);
-	} while (err == H_Busy || H_isLongBusy(err));
+	} while (err == H_BUSY || H_IS_LONG_BUSY(err));
 
 	dma_unmap_single(target->dev, queue->msg_token,
 			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
-- 
1.1.5
