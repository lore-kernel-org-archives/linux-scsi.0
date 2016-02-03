From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH V6 02/10] aacraid: Fix RRQ overload
Date: Wed, 3 Feb 2016 15:06:00 -0800
Message-ID: <1454540768-12271-3-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1454540768-12271-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:57302 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754605AbcBCWz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 17:55:58 -0500
In-Reply-To: <1454540768-12271-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, thenzl@redhat.com, shane.seymour@hpe.com, RaghavaAditya.Renukunta@pmcs.com

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

Changes in V2:
Created function aac_fib_vector_assign to assign vector numbers to
fib and to prevent code duplication

Changes in V3:
None

Changes in V4:
None

Changes in V5:
None

Changes in V6:
None

Fixes: 495c0217 "aacraid: MSI-x support"
Cc: stable@vger.kernel.org # v4.1

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/aacraid/aacraid.h |  2 ++
 drivers/scsi/aacraid/commsup.c | 28 ++++++++++++++++++++++++++++
 drivers/scsi/aacraid/src.c     | 30 +++++++-----------------------
 3 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index f51f0a0..fff1306 100644
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
@@ -2113,6 +2114,7 @@ static inline unsigned int cap_to_cyls(sector_t capacity, unsigned divisor)
 int aac_acquire_irq(struct aac_dev *dev);
 void aac_free_irq(struct aac_dev *dev);
 const char *aac_driverinfo(struct Scsi_Host *);
+void aac_fib_vector_assign(struct aac_dev *dev);
 struct fib *aac_fib_alloc(struct aac_dev *dev);
 struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd);
 int aac_fib_setup(struct aac_dev *dev);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 46a2a2f..07a42a3 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -90,6 +90,28 @@ void aac_fib_map_free(struct aac_dev *dev)
 	dev->hw_fib_pa = 0;
 }
 
+void aac_fib_vector_assign(struct aac_dev *dev)
+{
+	u32 i = 0;
+	u32 vector = 1;
+	struct fib *fibptr = NULL;
+
+	for (i = 0, fibptr = &dev->fibs[i];
+		i < (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
+		i++, fibptr++) {
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
+	}
+}
+
 /**
  *	aac_fib_setup	-	setup the fibs
  *	@dev: Adapter to set up
@@ -152,6 +174,12 @@ int aac_fib_setup(struct aac_dev * dev)
 		hw_fib_pa = hw_fib_pa +
 			dev->max_fib_size + sizeof(struct aac_fib_xporthdr);
 	}
+
+	/*
+	 *Assign vector numbers to fibs
+	 */
+	aac_fib_vector_assign(dev);
+
 	/*
 	 *	Add the fib chain to the free list
 	 */
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

