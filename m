From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] tgt: fix rdma transfer bugs
Date: Sat, 7 Apr 2007 18:10:00 +0900 (JST)
Message-ID: <20070407181030M.fujita.tomonori@lab.ntt.co.jp>
References: <20070407172701S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:49623 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965641AbXDGJKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Apr 2007 05:10:07 -0400
In-Reply-To: <20070407172701S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] tgt: fix rdma transfer bugs
Date: Sat, 7 Apr 2007 17:26:56 +0900 (JST)

> From: Bastian Blank <bastian@waldi.eu.org>
> 
> - ibmstgt hits the max rdma transfer size (128k).
> - libsrp returns rdma transfer errors properly.
> 
> Signed-off-by: Bastian Blank <bastian@waldi.eu.org>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/ibmvscsi/ibmvstgt.c |   18 +++++++++---------
>  drivers/scsi/libsrp.c            |   12 ++++++------
>  2 files changed, 15 insertions(+), 15 deletions(-)

Sorry, I sent a wrong patch. Here's a proper one.

---
From: Bastian Blank <bastian@waldi.eu.org>

- ibmstgt hits the max rdma transfer size (128k).
- libsrp returns a rdma transfer error properly.

Signed-off-by: Bastian Blank <bastian@waldi.eu.org>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |   18 +++++++++---------
 drivers/scsi/libsrp.c            |   12 ++++++------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index a7fbd10..84363c1 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -35,7 +35,7 @@
 #include "ibmvscsi.h"
 
 #define	INITIAL_SRP_LIMIT	16
-#define	DEFAULT_MAX_SECTORS	512
+#define	DEFAULT_MAX_SECTORS	256
 
 #define	TGT_NAME	"ibmvstgt"
 
@@ -248,8 +248,8 @@ static int ibmvstgt_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 						  md[i].va + mdone);
 
 			if (err != H_SUCCESS) {
-				eprintk("rdma error %d %d\n", dir, slen);
-				goto out;
+				eprintk("rdma error %d %d %ld\n", dir, slen, err);
+				return -EIO;
 			}
 
 			mlen -= slen;
@@ -265,14 +265,13 @@ static int ibmvstgt_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 				if (sidx > nsg) {
 					eprintk("out of sg %p %d %d\n",
 						iue, sidx, nsg);
-					goto out;
+					return -EIO;
 				}
 			}
 		};
 
 		rest -= mlen;
 	}
-out:
 	return 0;
 }
 
@@ -282,18 +281,19 @@ static int ibmvstgt_cmd_done(struct scsi_cmnd *sc,
 	unsigned long flags;
 	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
 	struct srp_target *target = iue->target;
+	int err = 0;
 
 	dprintk("%p %p %x %u\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0],
 		cmd->usg_sg);
 
 	if (sc->use_sg)
-		srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvstgt_rdma, 1, 1);
+		err = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvstgt_rdma, 1, 1);
 
 	spin_lock_irqsave(&target->lock, flags);
 	list_del(&iue->ilist);
 	spin_unlock_irqrestore(&target->lock, flags);
 
-	if (sc->result != SAM_STAT_GOOD) {
+	if (err|| sc->result != SAM_STAT_GOOD) {
 		eprintk("operation failed %p %d %x\n",
 			iue, sc->result, vio_iu(iue)->srp.cmd.cdb[0]);
 		send_rsp(iue, sc, HARDWARE_ERROR, 0x00);
@@ -493,7 +493,8 @@ static void process_iu(struct viosrp_crq *crq, struct srp_target *target)
 {
 	struct vio_port *vport = target_to_port(target);
 	struct iu_entry *iue;
-	long err, done;
+	long err;
+	int done = 1;
 
 	iue = srp_iu_get(target);
 	if (!iue) {
@@ -508,7 +509,6 @@ static void process_iu(struct viosrp_crq *crq, struct srp_target *target)
 
 	if (err != H_SUCCESS) {
 		eprintk("%ld transferring data error %p\n", err, iue);
-		done = 1;
 		goto out;
 	}
 
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 89403b0..37a0f4d 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -225,8 +225,7 @@ static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 	struct srp_direct_buf *md = NULL;
 	struct scatterlist dummy, *sg = NULL;
 	dma_addr_t token = 0;
-	long err;
-	unsigned int done = 0;
+	int err = 0;
 	int nmd, nsg = 0, len;
 
 	if (dma_map || ext_desc) {
@@ -258,8 +257,8 @@ static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 		sg_dma_address(&dummy) = token;
 		err = rdma_io(sc, &dummy, 1, &id->table_desc, 1, DMA_TO_DEVICE,
 			      id->table_desc.len);
-		if (err < 0) {
-			eprintk("Error copying indirect table %ld\n", err);
+		if (err) {
+			eprintk("Error copying indirect table %d\n", err);
 			goto free_mem;
 		}
 	} else {
@@ -272,6 +271,7 @@ rdma:
 		nsg = dma_map_sg(iue->target->dev, sg, sc->use_sg, DMA_BIDIRECTIONAL);
 		if (!nsg) {
 			eprintk("fail to map %p %d\n", iue, sc->use_sg);
+			err = -EIO;
 			goto free_mem;
 		}
 		len = min(sc->request_bufflen, id->len);
@@ -287,7 +287,7 @@ free_mem:
 	if (token && dma_map)
 		dma_free_coherent(iue->target->dev, id->table_desc.len, md, token);
 
-	return done;
+	return err;
 }
 
 static int data_out_desc_size(struct srp_cmd *cmd)
@@ -352,7 +352,7 @@ int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 		break;
 	default:
 		eprintk("Unknown format %d %x\n", dir, format);
-		break;
+		err = -EINVAL;
 	}
 
 	return err;
-- 
1.4.4.3

