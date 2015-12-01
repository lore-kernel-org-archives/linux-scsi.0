From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH 02/10] aacraid: Fix RRQ overload
Date: Tue, 1 Dec 2015 04:39:40 -0800
Message-ID: <1448973589-9216-3-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:55955 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760AbbLATeR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2015 14:34:17 -0500
In-Reply-To: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

The driver utilizes an array of atomic variables to keep track of
IO submissions to each vector. To submit an IO multiple threads
iterate through the array to find a vector which has empty slots
to send an IO. The reading and updating of the variable is not atomic,
causing race conditions when a thread uses a full vector to
submit an IO.

Fixed by mapping each FIB to a vector, the submission path then uses
said vector to submit IO thereby removing the possibly of a race
condition.The vector assignment is started from 1 since vector 0 is
reserved for the use of AIF management FIBS.If the number of MSIx
vectors is 1 (MSI or INTx mode) then all the fibs are allocated to
vector 0.

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h |  1 +
 drivers/scsi/aacraid/commsup.c | 12 ++++++++++++
 drivers/scsi/aacraid/src.c     | 30 +++++++-----------------------
 3 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index da227e8..d133c4a 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -944,6 +944,7 @@ struct fib {
 	 */
 	struct list_head	fiblink;
 	void			*data;
+	u32			vector_no;
 	struct hw_fib		*hw_fib_va;		/* Actual shared object */
 	dma_addr_t		hw_fib_pa;		/* physical address of hw_fib*/
 };
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index b5b653c..b257d3b 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -104,6 +104,7 @@ int aac_fib_setup(struct aac_dev * dev)
 	struct hw_fib *hw_fib;
 	dma_addr_t hw_fib_pa;
 	int i;
+	u32 vector = 1;
 
 	while (((i = fib_map_alloc(dev)) == -ENOMEM)
 	 && (dev->scsi_host_ptr->can_queue > (64 - AAC_NUM_MGT_FIB))) {
@@ -150,6 +151,17 @@ int aac_fib_setup(struct aac_dev * dev)
 			dev->max_fib_size + sizeof(struct aac_fib_xporthdr));
 		hw_fib_pa = hw_fib_pa +
 			dev->max_fib_size + sizeof(struct aac_fib_xporthdr);
+
+		if ((dev->max_msix == 1) ||
+		  (i > ((dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB - 1)
+			- dev->vector_cap))) {
+			fibptr->vector_no = 0;
+		} else {
+			fibptr->vector_no = vector;
+			vector++;
+			if (vector == dev->max_msix)
+				vector = 1;
+		}
 	}
 	/*
 	 *	Add the fib chain to the free list
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 2aa34ea..bc0203f 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -156,8 +156,8 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 				break;
 			if (dev->msi_enabled && dev->max_msix > 1)
 				atomic_dec(&dev->rrq_outstanding[vector_no]);
-			aac_intr_normal(dev, handle-1, 0, isFastResponse, NULL);
 			dev->host_rrq[index++] = 0;
+			aac_intr_normal(dev, handle-1, 0, isFastResponse, NULL);
 			if (index == (vector_no + 1) * dev->vector_cap)
 				index = vector_no * dev->vector_cap;
 			dev->host_rrq_idx[vector_no] = index;
@@ -452,36 +452,20 @@ static int aac_src_deliver_message(struct fib *fib)
 #endif
 
 	u16 hdr_size = le16_to_cpu(fib->hw_fib_va->header.Size);
+	u16 vector_no;
 
 	atomic_inc(&q->numpending);
 
 	if (dev->msi_enabled && fib->hw_fib_va->header.Command != AifRequest &&
 	    dev->max_msix > 1) {
-		u_int16_t vector_no, first_choice = 0xffff;
-
-		vector_no = dev->fibs_pushed_no % dev->max_msix;
-		do {
-			vector_no += 1;
-			if (vector_no == dev->max_msix)
-				vector_no = 1;
-			if (atomic_read(&dev->rrq_outstanding[vector_no]) <
-			    dev->vector_cap)
-				break;
-			if (0xffff == first_choice)
-				first_choice = vector_no;
-			else if (vector_no == first_choice)
-				break;
-		} while (1);
-		if (vector_no == first_choice)
-			vector_no = 0;
-		atomic_inc(&dev->rrq_outstanding[vector_no]);
-		if (dev->fibs_pushed_no == 0xffffffff)
-			dev->fibs_pushed_no = 0;
-		else
-			dev->fibs_pushed_no++;
+		vector_no = fib->vector_no;
 		fib->hw_fib_va->header.Handle += (vector_no << 16);
+	} else {
+		vector_no = 0;
 	}
 
+	atomic_inc(&dev->rrq_outstanding[vector_no]);
+
 	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) {
 		/* Calculate the amount to the fibsize bits */
 		fibsize = (hdr_size + 127) / 128 - 1;
-- 
1.9.1

