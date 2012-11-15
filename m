From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 5/5]  arcmsr: Modify ARC-1214 IO Behavior
Date: Thu, 15 Nov 2012 15:33:00 +0800
Message-ID: <FD8DEE8B2A7541878C07E36B950DB79D@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000F_01CDC346.87846420"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46003 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992535Ab2KOHdF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2012 02:33:05 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so891954pad.19
        for <linux-scsi@vger.kernel.org>; Wed, 14 Nov 2012 23:33:04 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_000F_01CDC346.87846420
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Modify ARC-1214 IO behavior to make up for HW seldom malfunction.
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_000F_01CDC346.87846420
Content-Type: application/octet-stream;
	name="patch5"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch5"

diff -uprN a//drivers/scsi/arcmsr/arcmsr.h =
b//drivers/scsi/arcmsr/arcmsr.h=0A=
--- a//drivers/scsi/arcmsr/arcmsr.h	2012-11-15 12:12:19.035557259 +0800=0A=
+++ b//drivers/scsi/arcmsr/arcmsr.h	2012-11-15 15:04:34.291456858 +0800=0A=
@@ -63,6 +63,7 @@ struct device_attribute;=0A=
 #define ARCMSR_DEFAULT_SG_ENTRIES		38=0A=
 #define ARCMSR_MAX_HBB_POSTQUEUE		264=0A=
 #define ARCMSR_MAX_ARC1214_POSTQUEUE		256=0A=
+#define ARCMSR_MAX_ARC1214_DONEQUEUE		257=0A=
 #define ARCMSR_MAX_XFER_LEN			0x26000=0A=
 #define ARCMSR_CDB_SG_PAGE_LENGTH		256=0A=
 #define ARCMST_NUM_MSIX_VECTORS		4=0A=
@@ -175,8 +176,8 @@ struct  SG64ENTRY=0A=
 */=0A=
 struct QBUFFER=0A=
 {=0A=
-	uint32_t data_len;=0A=
-	uint8_t data[124];=0A=
+	uint32_t __iomem data_len;=0A=
+	uint8_t __iomem data[124];=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -565,7 +566,7 @@ struct OutBound_SRB {=0A=
 =0A=
 struct MessageUnit_D {=0A=
  	struct InBound_SRB post_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];=0A=
-   	struct OutBound_SRB done_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];=0A=
+   	struct OutBound_SRB done_qbuffer[ARCMSR_MAX_ARC1214_DONEQUEUE];=0A=
 	u16 postq_index;=0A=
 	u16 doneq_index;=0A=
 	u32 __iomem *chip_id;			//0x00004=0A=
@@ -618,6 +619,7 @@ struct AdapterControlBlock=0A=
 	spinlock_t eh_lock;=0A=
 	spinlock_t ccblist_lock;=0A=
 	spinlock_t postq_lock;=0A=
+	spinlock_t doneq_lock;=0A=
 	spinlock_t rqbuffer_lock;=0A=
 	spinlock_t wqbuffer_lock;=0A=
 	union {=0A=
@@ -671,15 +673,15 @@ struct AdapterControlBlock=0A=
 	unsigned int uncache_size;=0A=
 	uint8_t rqbuffer[ARCMSR_MAX_QBUFFER];=0A=
 	/* data collection buffer for read from 80331 */=0A=
-	int32_t rqbuf_firstindex;=0A=
+	uint32_t rqbuf_firstindex;=0A=
 	/* first of read buffer  */=0A=
-	int32_t rqbuf_lastindex;=0A=
+	uint32_t rqbuf_lastindex;=0A=
 	/* last of read buffer   */=0A=
 	uint8_t wqbuffer[ARCMSR_MAX_QBUFFER];=0A=
 	/* data collection buffer for write to 80331  */=0A=
-	int32_t wqbuf_firstindex;=0A=
+	uint32_t wqbuf_firstindex;=0A=
 	/* first of write buffer */=0A=
-	int32_t wqbuf_lastindex;=0A=
+	uint32_t wqbuf_lastindex;=0A=
 	/* last of write buffer  */=0A=
 	uint8_t devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];=0A=
 	/* id0 ..... id15, lun0...lun7 */=0A=
diff -uprN a//drivers/scsi/arcmsr/arcmsr_hba.c =
b//drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a//drivers/scsi/arcmsr/arcmsr_hba.c	2012-11-15 12:12:40.851557048 =
+0800=0A=
+++ b//drivers/scsi/arcmsr/arcmsr_hba.c	2012-11-15 15:04:34.319456858 =
+0800=0A=
@@ -1106,6 +1106,7 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	spin_lock_init(&acb->eh_lock);=0A=
 	spin_lock_init(&acb->ccblist_lock);=0A=
 	spin_lock_init(&acb->postq_lock);=0A=
+	spin_lock_init(&acb->doneq_lock);=0A=
 	spin_lock_init(&acb->rqbuffer_lock);=0A=
 	spin_lock_init(&acb->wqbuffer_lock);=0A=
 	acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
@@ -1247,6 +1248,7 @@ arcmsr_hbaB_abort_allcmd(struct AdapterC=0A=
 	}=0A=
 	return true;=0A=
 }=0A=
+=0A=
 static uint8_t=0A=
 arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)=0A=
 {=0A=
@@ -1261,6 +1263,7 @@ arcmsr_hbaC_abort_allcmd(struct AdapterC=0A=
 	}=0A=
 	return true;=0A=
 }=0A=
+=0A=
 static uint8_t=0A=
 arcmsr_hbaD_abort_allcmd(struct AdapterControlBlock *pACB)=0A=
 {=0A=
@@ -1274,6 +1277,7 @@ arcmsr_hbaD_abort_allcmd(struct AdapterC=0A=
 	}=0A=
 	return true;=0A=
 }=0A=
+=0A=
 static uint8_t=0A=
 arcmsr_abort_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
@@ -1554,29 +1558,29 @@ arcmsr_done4abort_postqueue(struct Adapt=0A=
 		uint32_t doneq_index, index_stripped, addressLow, residual;=0A=
 		bool error;=0A=
 		struct CommandControlBlock *pCCB;=0A=
-		outbound_write_pointer =3D ioread32(pmu->outboundlist_copy_pointer);=0A=
+		outbound_write_pointer =3D pmu->done_qbuffer[0].addressLow + 1;=0A=
 		doneq_index =3D pmu->doneq_index;=0A=
 		residual =3D atomic_read(&acb->ccboutstandingcount);=0A=
 		for (i =3D 0; i < residual; i++) {=0A=
-			while ((doneq_index & 0xFF) !=3D (outbound_write_pointer & 0xFF)) {=0A=
+			while ((doneq_index & 0xFFF) !=3D (outbound_write_pointer & 0xFFF)) {=0A=
 				if (doneq_index & 0x4000) {=0A=
-					index_stripped =3D doneq_index & 0xFF;=0A=
+					index_stripped =3D doneq_index & 0xFFF;=0A=
 					index_stripped +=3D 1;=0A=
 					index_stripped %=3D=0A=
-					ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+					ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
 					pmu->doneq_index =3D index_stripped ?=0A=
-					(index_stripped | 0x4000) : index_stripped;=0A=
+					(index_stripped | 0x4000) : (index_stripped + 1);=0A=
 				} else {=0A=
 					index_stripped =3D doneq_index;=0A=
 					index_stripped +=3D 1;=0A=
 					index_stripped %=3D=0A=
-					ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+					ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
 					pmu->doneq_index =3D=0A=
-					index_stripped ? index_stripped : (index_stripped | 0x4000);=0A=
+					index_stripped ? index_stripped : ((index_stripped | 0x4000) + 1);=0A=
 				}=0A=
 				doneq_index =3D pmu->doneq_index;=0A=
 				addressLow =3D=0A=
-				pmu->done_qbuffer[doneq_index & 0xFF].addressLow;=0A=
+				pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;=0A=
 				ccb_cdb_phy =3D (addressLow & 0xFFFFFFF0);=0A=
 				pARCMSR_CDB =3D (struct  ARCMSR_CDB *)=0A=
 				(acb->vir2phy_offset + ccb_cdb_phy);=0A=
@@ -1591,7 +1595,7 @@ arcmsr_done4abort_postqueue(struct Adapt=0A=
 			}=0A=
 			mdelay(10);=0A=
 			outbound_write_pointer =3D=0A=
-				ioread32(pmu->outboundlist_copy_pointer);=0A=
+				pmu->done_qbuffer[0].addressLow + 1;=0A=
 			doneq_index =3D pmu->doneq_index;=0A=
 		}=0A=
 		pmu->postq_index =3D 0;=0A=
@@ -2148,10 +2152,9 @@ struct QBUFFER __iomem=0A=
 void=0A=
 arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	uint8_t __iomem *iop_data;=0A=
+	uint8_t __iomem *iop_data, *pQbuffer, *vaddr, *temp;=0A=
 	struct QBUFFER __iomem *prbuffer;=0A=
-	struct QBUFFER *pQbuffer;=0A=
-	int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;=0A=
+	int32_t my_empty_len, data_len, rqbuf_firstindex, rqbuf_lastindex;=0A=
 	unsigned long flags;=0A=
 =0A=
 	spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
@@ -2159,22 +2162,33 @@ arcmsr_iop2drv_data_wrote_handle(struct=0A=
 	rqbuf_firstindex =3D acb->rqbuf_firstindex;=0A=
 	prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
 	iop_data =3D (uint8_t __iomem *)prbuffer->data;=0A=
-	iop_len =3D prbuffer->data_len;=0A=
+	data_len =3D prbuffer->data_len;=0A=
 	my_empty_len =3D (rqbuf_firstindex - rqbuf_lastindex - 1) &=0A=
 	(ARCMSR_MAX_QBUFFER - 1);=0A=
 =0A=
-	if (my_empty_len >=3D iop_len) {=0A=
-		while (iop_len > 0) {=0A=
-			pQbuffer =3D (struct QBUFFER *)=0A=
-			&acb->rqbuffer[rqbuf_lastindex];=0A=
-			memcpy(pQbuffer, iop_data, 1);=0A=
-			rqbuf_lastindex++;=0A=
-			rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-			iop_data++;=0A=
-			iop_len--;=0A=
+	if (my_empty_len >=3D data_len) {=0A=
+		if (data_len > 0) {=0A=
+			temp =3D vaddr =3D kmalloc(data_len, GFP_ATOMIC);=0A=
+			memcpy(vaddr, iop_data, data_len);=0A=
+			smp_mb();=0A=
+			pQbuffer =3D &acb->rqbuffer[rqbuf_lastindex];=0A=
+			if ((rqbuf_lastindex + data_len)=0A=
+			> ARCMSR_MAX_QBUFFER) {=0A=
+				memcpy(pQbuffer, temp, ARCMSR_MAX_QBUFFER=0A=
+				- rqbuf_lastindex);=0A=
+				temp +=3D (ARCMSR_MAX_QBUFFER - rqbuf_lastindex);=0A=
+				rqbuf_lastindex =3D (rqbuf_lastindex + data_len)=0A=
+				% ARCMSR_MAX_QBUFFER;=0A=
+				memcpy(&acb->rqbuffer[0], temp, rqbuf_lastindex);=0A=
+			} else {=0A=
+				memcpy(pQbuffer, temp, data_len);=0A=
+				rqbuf_lastindex =3D (rqbuf_lastindex + data_len)=0A=
+				% ARCMSR_MAX_QBUFFER;=0A=
+			}=0A=
+			kfree(vaddr);=0A=
 		}=0A=
-		acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
-		arcmsr_iop_message_read(acb);=0A=
+        		acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
+		arcmsr_iop_message_read(acb);/*notice IOP the message is read*/=0A=
 	} else {=0A=
 		acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
 	}=0A=
@@ -2238,6 +2252,7 @@ arcmsr_hbaA_doorbell_isr(struct AdapterC=0A=
 	(ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK=0A=
 	| ARCMSR_OUTBOUND_IOP331_DATA_READ_OK));=0A=
 }=0A=
+=0A=
 static void=0A=
 arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB)=0A=
 {=0A=
@@ -2392,28 +2407,30 @@ arcmsr_hbaD_postqueue_isr(struct Adapter=0A=
 	struct MessageUnit_D __iomem *pmu;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb;=0A=
 	struct CommandControlBlock *ccb;=0A=
+	unsigned long flags;=0A=
 =0A=
+	spin_lock_irqsave(&acb->doneq_lock, flags);=0A=
 	pmu =3D (struct MessageUnit_D *)acb->pmuD;=0A=
-	outbound_write_pointer =3D ioread32(pmu->outboundlist_copy_pointer);=0A=
+	outbound_write_pointer =3D pmu->done_qbuffer[0].addressLow + 1;=0A=
 	doneq_index =3D pmu->doneq_index;=0A=
-	if ((doneq_index & 0xFF) !=3D (outbound_write_pointer & 0xFF)) {=0A=
+	if ((doneq_index & 0xFFF) !=3D (outbound_write_pointer & 0xFFF)) {=0A=
 		do {=0A=
 			if (doneq_index & 0x4000) {=0A=
-				index_stripped =3D doneq_index & 0xFF;=0A=
+				index_stripped =3D doneq_index & 0xFFF;=0A=
 				index_stripped +=3D 1;=0A=
-				index_stripped %=3D ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+				index_stripped %=3D ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
 				pmu->doneq_index =3D index_stripped=0A=
-				? (index_stripped | 0x4000) : index_stripped;=0A=
+				? (index_stripped | 0x4000) : (index_stripped + 1);=0A=
 			} else {=0A=
 				index_stripped =3D doneq_index;=0A=
 				index_stripped +=3D 1;=0A=
-				index_stripped %=3D ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+				index_stripped %=3D ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
 				pmu->doneq_index =3D index_stripped=0A=
-				? index_stripped : (index_stripped | 0x4000);=0A=
+				? index_stripped : ((index_stripped | 0x4000) + 1);=0A=
 			}=0A=
 			doneq_index =3D pmu->doneq_index;=0A=
 			addressLow =3D=0A=
-			pmu->done_qbuffer[doneq_index & 0xFF].addressLow;=0A=
+			pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;=0A=
 			ccb_cdb_phy =3D (addressLow & 0xFFFFFFF0);=0A=
 			arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset=0A=
 				+ ccb_cdb_phy);=0A=
@@ -2424,12 +2441,13 @@ arcmsr_hbaD_postqueue_isr(struct Adapter=0A=
 			arcmsr_drain_donequeue(acb, ccb, error);=0A=
 			iowrite32(doneq_index,=0A=
 				pmu->outboundlist_read_pointer);=0A=
-		} while ((doneq_index & 0xFF) !=3D=0A=
-		(outbound_write_pointer & 0xFF));=0A=
+		} while ((doneq_index & 0xFFF) !=3D=0A=
+		(outbound_write_pointer & 0xFFF));=0A=
 	}=0A=
 	iowrite32(ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR,=0A=
 		pmu->outboundlist_interrupt_cause);=0A=
 	ioread32(pmu->outboundlist_interrupt_cause);=0A=
+	spin_unlock_irqrestore(&acb->doneq_lock, flags);=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -2440,6 +2458,7 @@ arcmsr_hbaA_message_isr(struct AdapterCo=0A=
 	iowrite32(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);=0A=
 	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
 }=0A=
+=0A=
 static void=0A=
 arcmsr_hbaB_message_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
@@ -2694,33 +2713,96 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 		}=0A=
 		ptmpQbuffer =3D ver_addr;=0A=
 		spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
-		while ((acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex)=0A=
-			&& (allxfer_len < 1031)) {=0A=
+		if (acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex) {=0A=
 			pQbuffer =3D &acb->rqbuffer[acb->rqbuf_firstindex];=0A=
-			memcpy(ptmpQbuffer, pQbuffer, 1);=0A=
-			acb->rqbuf_firstindex++;=0A=
-			acb->rqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-			ptmpQbuffer++;=0A=
-			allxfer_len++;=0A=
+			if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {=0A=
+				if ((ARCMSR_MAX_QBUFFER -=0A=
+					acb->rqbuf_firstindex) >=3D 1032) {=0A=
+					memcpy(ptmpQbuffer, pQbuffer, 1032);=0A=
+					acb->rqbuf_firstindex +=3D 1032;=0A=
+					allxfer_len =3D 1032;=0A=
+				} else {=0A=
+					if (((ARCMSR_MAX_QBUFFER -=0A=
+						acb->rqbuf_firstindex)=0A=
+						+ acb->rqbuf_lastindex) > 1032) {=0A=
+						memcpy(ptmpQbuffer, pQbuffer,=0A=
+						ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex);=0A=
+						ptmpQbuffer +=3D ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex;=0A=
+						memcpy(ptmpQbuffer, acb->rqbuffer,=0A=
+						1032 - (ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex));=0A=
+						acb->rqbuf_firstindex =3D 1032 -=0A=
+						(ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex);=0A=
+						allxfer_len =3D 1032;=0A=
+					} else {=0A=
+						memcpy(ptmpQbuffer, pQbuffer,=0A=
+						ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex);=0A=
+						ptmpQbuffer +=3D ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex;=0A=
+						memcpy(ptmpQbuffer, acb->rqbuffer,=0A=
+						acb->rqbuf_lastindex);=0A=
+						allxfer_len =3D ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex=0A=
+						+ acb->rqbuf_lastindex;=0A=
+						acb->rqbuf_firstindex =3D=0A=
+						acb->rqbuf_lastindex;=0A=
+					}=0A=
+				}=0A=
+			} else {=0A=
+				if ((acb->rqbuf_lastindex=0A=
+				- acb->rqbuf_firstindex) > 1032) {=0A=
+					memcpy(ptmpQbuffer,=0A=
+					pQbuffer, 1032);=0A=
+					acb->rqbuf_firstindex +=3D 1032;=0A=
+					allxfer_len =3D 1032;=0A=
+				} else {=0A=
+					memcpy(ptmpQbuffer,=0A=
+					pQbuffer,=0A=
+					acb->rqbuf_lastindex=0A=
+					- acb->rqbuf_firstindex);=0A=
+					allxfer_len =3D acb->rqbuf_lastindex=0A=
+					- acb->rqbuf_firstindex;=0A=
+					acb->rqbuf_firstindex=0A=
+					=3D acb->rqbuf_lastindex;=0A=
+				}=0A=
+			}=0A=
 		}=0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
-=0A=
 			struct QBUFFER __iomem *prbuffer;=0A=
-			uint8_t __iomem *iop_data;=0A=
-			int32_t iop_len;=0A=
-=0A=
-			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
+			uint8_t __iomem *iop_data, *vaddr, *temp;=0A=
+        			uint32_t data_len, rqbuf_lastindex;=0A=
+        			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
+			rqbuf_lastindex =3D acb->rqbuf_lastindex;=0A=
 			prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
-			iop_data =3D prbuffer->data;=0A=
-			iop_len =3D ioread32(&prbuffer->data_len);=0A=
-			while (iop_len > 0) {=0A=
-				acb->rqbuffer[acb->rqbuf_lastindex] =3D=0A=
-				ioread8(iop_data);=0A=
-				acb->rqbuf_lastindex++;=0A=
-				acb->rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-				iop_data++;=0A=
-				iop_len--;=0A=
+			iop_data =3D (uint8_t __iomem *)prbuffer->data;=0A=
+			data_len =3D ioread32(&prbuffer->data_len);=0A=
+			if (data_len > 0) {=0A=
+				temp =3D vaddr =3D kmalloc(data_len, GFP_ATOMIC);=0A=
+				memcpy(vaddr, iop_data, data_len);=0A=
+				smp_mb();=0A=
+				pQbuffer =3D &acb->rqbuffer[acb->rqbuf_lastindex];=0A=
+				if ((rqbuf_lastindex + data_len) >=0A=
+					ARCMSR_MAX_QBUFFER) {=0A=
+					memcpy(pQbuffer, temp,=0A=
+					ARCMSR_MAX_QBUFFER - rqbuf_lastindex);=0A=
+					temp +=3D (ARCMSR_MAX_QBUFFER=0A=
+					- rqbuf_lastindex);=0A=
+					rqbuf_lastindex =3D (rqbuf_lastindex=0A=
+					+ data_len) % ARCMSR_MAX_QBUFFER;=0A=
+					memcpy(&acb->rqbuffer[0],=0A=
+					temp, rqbuf_lastindex);=0A=
+				} else {=0A=
+					memcpy(pQbuffer, temp, data_len);=0A=
+					rqbuf_lastindex =3D (rqbuf_lastindex +=0A=
+					data_len) % ARCMSR_MAX_QBUFFER;=0A=
+				}=0A=
+				kfree(vaddr);=0A=
 			}=0A=
+			acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
 			arcmsr_iop_message_read(acb);=0A=
 		}=0A=
 		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
@@ -3641,19 +3723,21 @@ arcmsr_hbaD_polling_ccbdone(struct Adapt=0A=
 {=0A=
 	bool error;=0A=
 	uint32_t poll_ccb_done =3D 0, poll_count =3D 0, flag_ccb, ccb_cdb_phy;=0A=
-	int rtn, index, outbound_write_pointer;=0A=
+	int rtn, doneq_index, index_stripped, outbound_write_pointer;=0A=
+	unsigned long flags;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb;=0A=
 	struct CommandControlBlock *pCCB;=0A=
-	struct MessageUnit_D __iomem *reg =3D=0A=
+	struct MessageUnit_D __iomem *pmu =3D=0A=
 		(struct MessageUnit_D *)acb->pmuD;=0A=
 =0A=
+	spin_lock_irqsave(&acb->doneq_lock, flags);=0A=
 	polling_hbaD_ccb_retry:=0A=
 	poll_count++;=0A=
 	while (1) {=0A=
 		outbound_write_pointer =3D=0A=
-			ioread32(reg->outboundlist_copy_pointer);=0A=
-		index =3D reg->doneq_index;=0A=
-		if ((outbound_write_pointer & 0xFF) =3D=3D index) {=0A=
+		pmu->done_qbuffer[0].addressLow + 1;=0A=
+		doneq_index =3D pmu->doneq_index;=0A=
+		if ((outbound_write_pointer & 0xFFF) =3D=3D (doneq_index & 0xFFF)) {=0A=
 			if (poll_ccb_done) {=0A=
 				rtn =3D SUCCESS;=0A=
 				break;=0A=
@@ -3666,17 +3750,27 @@ arcmsr_hbaD_polling_ccbdone(struct Adapt=0A=
 				goto polling_hbaD_ccb_retry;=0A=
 			}=0A=
 		}=0A=
-		flag_ccb =3D reg->done_qbuffer[index].addressLow;=0A=
+		if (doneq_index & 0x4000) {=0A=
+			index_stripped =3D doneq_index & 0xFFF;=0A=
+			index_stripped +=3D 1;=0A=
+			index_stripped %=3D ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
+			pmu->doneq_index =3D index_stripped ? (index_stripped | 0x4000)=0A=
+				: (index_stripped + 1);=0A=
+		} else {=0A=
+			index_stripped =3D doneq_index;=0A=
+			index_stripped +=3D 1;=0A=
+			index_stripped %=3D ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
+			pmu->doneq_index =3D index_stripped ? index_stripped :=0A=
+				((index_stripped | 0x4000) + 1);=0A=
+		}=0A=
+		doneq_index =3D pmu->doneq_index;=0A=
+		flag_ccb =3D pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;=0A=
 		ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
 		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset +=0A=
 			ccb_cdb_phy);=0A=
 		pCCB =3D container_of(arcmsr_cdb,=0A=
 			struct CommandControlBlock, arcmsr_cdb);=0A=
 		poll_ccb_done =3D (pCCB =3D=3D poll_ccb) ? 1 : 0;=0A=
-		index++;=0A=
-		index %=3D ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
-		reg->doneq_index =3D index;=0A=
-		/* check if command done with no error*/=0A=
 		if ((pCCB->acb !=3D acb) ||=0A=
 		(pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
 			if (pCCB->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
@@ -3703,6 +3797,7 @@ arcmsr_hbaD_polling_ccbdone(struct Adapt=0A=
 		? true : false;=0A=
 		arcmsr_report_ccb_state(acb, pCCB, error);=0A=
 	}=0A=
+	spin_unlock_irqrestore(&acb->doneq_lock, flags);=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
@@ -3838,7 +3933,7 @@ arcmsr_iop_confirm(struct AdapterControl=0A=
 		struct MessageUnit_D *reg =3D=0A=
 			(struct MessageUnit_D *)acb->pmuD;=0A=
 		reg->postq_index =3D 0;=0A=
-		reg->doneq_index =3D 0x40FF;=0A=
+		reg->doneq_index =3D 0;=0A=
 		rwbuffer =3D reg->msgcode_rwbuffer;=0A=
 		iowrite32(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);=0A=
 		iowrite32(cdb_phyaddr_hi32, rwbuffer++);=0A=

------=_NextPart_000_000F_01CDC346.87846420--

