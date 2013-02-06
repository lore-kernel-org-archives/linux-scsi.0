From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 5/5]  arcmsr: Modify ARC-1214 Inband Messages Behavior
Date: Wed, 6 Feb 2013 16:38:12 +0800
Message-ID: <44D762422A6E4E8FAF3AB1AC57751182@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000C_01CE0488.600903F0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62696 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab3BFIix (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2013 03:38:53 -0500
Received: by mail-ie0-f180.google.com with SMTP id bn7so1521839ieb.39
        for <linux-scsi@vger.kernel.org>; Wed, 06 Feb 2013 00:38:52 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org, =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>

This is a multi-part message in MIME format.

------=_NextPart_000_000C_01CE0488.600903F0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Modify ARC-1214 inband messages behavior to make up for HW seldom malfunction.
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_000C_01CE0488.600903F0
Content-Type: application/octet-stream;
	name="patch5"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch5"

diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c =
b/drivers/scsi/arcmsr/arcmsr_attr.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_attr.c	2013-02-06 16:29:11.434076347 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c	2013-02-06 16:29:25.566410389 =
+0800=0A=
@@ -72,40 +72,82 @@ arcmsr_sysfs_iop_message_read(struct fil=0A=
 		(struct AdapterControlBlock *)host->hostdata;=0A=
 	uint8_t *pQbuffer,*ptmpQbuffer;=0A=
 	int32_t allxfer_len =3D 0;=0A=
+	unsigned long flags;=0A=
 =0A=
 	if (!capable(CAP_SYS_ADMIN))=0A=
 		return -EACCES;=0A=
 =0A=
 	/* do message unit read. */=0A=
 	ptmpQbuffer =3D (uint8_t *)buf;=0A=
-	while ((acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex)=0A=
-		&& (allxfer_len < 1031)) {=0A=
+	spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
+	if (acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex) {=0A=
 		pQbuffer =3D &acb->rqbuffer[acb->rqbuf_firstindex];=0A=
-		memcpy(ptmpQbuffer, pQbuffer, 1);=0A=
-		acb->rqbuf_firstindex++;=0A=
-		acb->rqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-		ptmpQbuffer++;=0A=
-		allxfer_len++;=0A=
+		if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {=0A=
+			if ((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) >=3D 1032) {=0A=
+				memcpy(ptmpQbuffer, pQbuffer, 1032);=0A=
+				acb->rqbuf_firstindex +=3D 1032;=0A=
+				allxfer_len =3D 1032;=0A=
+			} else {=0A=
+				if (((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) + =
acb->rqbuf_lastindex) > 1032) {=0A=
+					memcpy(ptmpQbuffer, pQbuffer, ARCMSR_MAX_QBUFFER - =
acb->rqbuf_firstindex);=0A=
+					ptmpQbuffer +=3D ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex;=0A=
+					memcpy(ptmpQbuffer, acb->rqbuffer, 1032 - (ARCMSR_MAX_QBUFFER - =
acb->rqbuf_firstindex));=0A=
+					acb->rqbuf_firstindex =3D 1032 - (ARCMSR_MAX_QBUFFER - =
acb->rqbuf_firstindex);=0A=
+					allxfer_len =3D 1032;=0A=
+				} else {=0A=
+					memcpy(ptmpQbuffer, pQbuffer, ARCMSR_MAX_QBUFFER - =
acb->rqbuf_firstindex);=0A=
+					ptmpQbuffer +=3D ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex;=0A=
+					memcpy(ptmpQbuffer, acb->rqbuffer, acb->rqbuf_lastindex);=0A=
+					allxfer_len =3D ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex + =
acb->rqbuf_lastindex;=0A=
+					acb->rqbuf_firstindex =3D acb->rqbuf_lastindex;=0A=
+				}=0A=
+			}=0A=
+		} else {=0A=
+			if ((acb->rqbuf_lastindex - acb->rqbuf_firstindex) > 1032) {=0A=
+				memcpy(ptmpQbuffer, pQbuffer, 1032);=0A=
+				acb->rqbuf_firstindex +=3D 1032;=0A=
+				allxfer_len =3D 1032;=0A=
+			} else {=0A=
+				memcpy(ptmpQbuffer, pQbuffer, acb->rqbuf_lastindex - =
acb->rqbuf_firstindex);=0A=
+				allxfer_len =3D acb->rqbuf_lastindex - acb->rqbuf_firstindex;=0A=
+				acb->rqbuf_firstindex =3D acb->rqbuf_lastindex;=0A=
+			}=0A=
+		}=0A=
 	}=0A=
 	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 		struct QBUFFER __iomem *prbuffer;=0A=
-		uint8_t __iomem *iop_data;=0A=
-		int32_t iop_len;=0A=
-=0A=
-		acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
+		uint8_t __iomem *iop_data, *vaddr, *temp;=0A=
+			int32_t data_len_residual, data_len, rqbuf_lastindex;=0A=
+			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
+		rqbuf_lastindex =3D acb->rqbuf_lastindex;=0A=
 		prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
-		iop_data =3D prbuffer->data;=0A=
-		iop_len =3D readl(&prbuffer->data_len);=0A=
-		while (iop_len > 0) {=0A=
-			acb->rqbuffer[acb->rqbuf_lastindex] =3D=0A=
-				readb(iop_data);=0A=
-			acb->rqbuf_lastindex++;=0A=
-			acb->rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-			iop_data++;=0A=
-			iop_len--;=0A=
+		iop_data =3D (uint8_t __iomem *)prbuffer->data;=0A=
+		data_len_residual =3D data_len =3D readl(&prbuffer->data_len);=0A=
+		if (data_len > 0) {=0A=
+			temp =3D vaddr =3D kmalloc(data_len, GFP_ATOMIC);=0A=
+			do {=0A=
+				memcpy(temp, iop_data, 4);=0A=
+				temp +=3D 4;=0A=
+				iop_data +=3D 4;=0A=
+				data_len_residual -=3D 4;=0A=
+			} while (data_len_residual > 0);=0A=
+			pQbuffer =3D &acb->rqbuffer[acb->rqbuf_lastindex];=0A=
+			temp =3D vaddr;=0A=
+			if ((rqbuf_lastindex + data_len) > ARCMSR_MAX_QBUFFER) {=0A=
+				memcpy(pQbuffer, temp, ARCMSR_MAX_QBUFFER - rqbuf_lastindex);=0A=
+				temp +=3D (ARCMSR_MAX_QBUFFER - rqbuf_lastindex);=0A=
+				rqbuf_lastindex =3D (rqbuf_lastindex + data_len) % =
ARCMSR_MAX_QBUFFER;=0A=
+				memcpy(&acb->rqbuffer[0], temp, rqbuf_lastindex);=0A=
+			} else {=0A=
+				memcpy(pQbuffer, temp, data_len);=0A=
+				rqbuf_lastindex =3D (rqbuf_lastindex + data_len) % =
ARCMSR_MAX_QBUFFER;=0A=
+			}=0A=
+			kfree(vaddr);=0A=
 		}=0A=
+		acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
 		arcmsr_iop_message_read(acb);=0A=
 	}=0A=
+	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
 	return (allxfer_len);=0A=
 }=0A=
 =0A=
@@ -122,6 +164,7 @@ arcmsr_sysfs_iop_message_write(struct fi=0A=
 		(struct AdapterControlBlock *)host->hostdata;=0A=
 	int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;=0A=
 	uint8_t *pQbuffer, *ptmpuserbuffer;=0A=
+	unsigned long flags;=0A=
 =0A=
 	if (!capable(CAP_SYS_ADMIN))=0A=
 		return -EACCES;=0A=
@@ -130,10 +173,12 @@ arcmsr_sysfs_iop_message_write(struct fi=0A=
 	/* do message unit write. */=0A=
 	ptmpuserbuffer =3D (uint8_t *)buf;=0A=
 	user_len =3D (int32_t)count;=0A=
+	spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
 	wqbuf_lastindex =3D acb->wqbuf_lastindex;=0A=
 	wqbuf_firstindex =3D acb->wqbuf_firstindex;=0A=
 	if (wqbuf_lastindex !=3D wqbuf_firstindex) {=0A=
 		arcmsr_post_ioctldata2iop(acb);=0A=
+		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 		return 0;	/*need retry*/=0A=
 	} else {=0A=
 		my_empty_len =3D (wqbuf_firstindex-wqbuf_lastindex - 1)=0A=
@@ -155,8 +200,10 @@ arcmsr_sysfs_iop_message_write(struct fi=0A=
 					~ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
 				arcmsr_post_ioctldata2iop(acb);=0A=
 			}=0A=
+			spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 			return count;=0A=
 		} else {=0A=
+			spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 			return 0;	/*need retry*/=0A=
 		}=0A=
 	}=0A=
@@ -174,6 +221,7 @@ arcmsr_sysfs_iop_message_clear(struct fi=0A=
 	struct AdapterControlBlock *acb =3D=0A=
 		(struct AdapterControlBlock *)host->hostdata;=0A=
 	uint8_t *pQbuffer;=0A=
+	unsigned long flags;=0A=
 =0A=
 	if (!capable(CAP_SYS_ADMIN))=0A=
 		return -EACCES;=0A=
@@ -186,10 +234,14 @@ arcmsr_sysfs_iop_message_clear(struct fi=0A=
 		(ACB_F_MESSAGE_WQBUFFER_CLEARED=0A=
 		| ACB_F_MESSAGE_RQBUFFER_CLEARED=0A=
 		| ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+	spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
 	acb->rqbuf_firstindex =3D 0;=0A=
 	acb->rqbuf_lastindex =3D 0;=0A=
+	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
+	spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
 	acb->wqbuf_firstindex =3D 0;=0A=
 	acb->wqbuf_lastindex =3D 0;=0A=
+	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 	pQbuffer =3D acb->rqbuffer;=0A=
 	memset(pQbuffer, 0, sizeof (struct QBUFFER));=0A=
 	pQbuffer =3D acb->wqbuffer;=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h	2013-02-06 16:29:12.026093684 +0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h	2013-02-06 16:29:25.869417446 +0800=0A=
@@ -63,6 +63,7 @@ struct device_attribute;=0A=
 #define ARCMSR_DEFAULT_SG_ENTRIES		38=0A=
 #define ARCMSR_MAX_HBB_POSTQUEUE		264=0A=
 #define ARCMSR_MAX_ARC1214_POSTQUEUE		256=0A=
+#define ARCMSR_MAX_ARC1214_DONEQUEUE		257=0A=
 #define ARCMSR_MAX_XFER_LEN			0x26000=0A=
 #define ARCMSR_CDB_SG_PAGE_LENGTH		256=0A=
 #define ARCMST_NUM_MSIX_VECTORS		4=0A=
@@ -564,7 +565,7 @@ struct OutBound_SRB {=0A=
 =0A=
 struct MessageUnit_D {=0A=
 	struct InBound_SRB post_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];=0A=
-	struct OutBound_SRB done_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];=0A=
+	struct OutBound_SRB done_qbuffer[ARCMSR_MAX_ARC1214_DONEQUEUE];=0A=
 	u16 postq_index;=0A=
 	u16 doneq_index;=0A=
 	u32 __iomem *chip_id;			/*0x00004*/=0A=
@@ -617,6 +618,7 @@ struct AdapterControlBlock=0A=
 	spinlock_t eh_lock;=0A=
 	spinlock_t ccblist_lock;=0A=
 	spinlock_t postq_lock;=0A=
+	spinlock_t doneq_lock;=0A=
 	spinlock_t rqbuffer_lock;=0A=
 	spinlock_t wqbuffer_lock;=0A=
 	union {=0A=
@@ -670,15 +672,15 @@ struct AdapterControlBlock=0A=
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
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2013-02-06 16:29:12.453104788 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2013-02-06 16:29:26.195427363 =
+0800=0A=
@@ -768,18 +768,18 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 						(diff & 0x01) =3D=3D 1) {=0A=
 							scsi_add_device(acb->host,=0A=
 							0, target, lun);=0A=
-					} else if ((temp & 0x01) =3D=3D 0=0A=
-					&& (diff & 0x01) =3D=3D 1) {=0A=
-						psdev =3D=0A=
-						scsi_device_lookup(acb->host,=0A=
-						0, target, lun);=0A=
-						if (psdev !=3D NULL) {=0A=
-							scsi_remove_device(psdev);=0A=
-							scsi_device_put(psdev);=0A=
+						} else if ((temp & 0x01) =3D=3D 0=0A=
+						&& (diff & 0x01) =3D=3D 1) {=0A=
+							psdev =3D=0A=
+							scsi_device_lookup(acb->host,=0A=
+							0, target, lun);=0A=
+							if (psdev !=3D NULL) {=0A=
+								scsi_remove_device(psdev);=0A=
+								scsi_device_put(psdev);=0A=
+							}=0A=
 						}=0A=
-					}=0A=
-					temp >>=3D 1;=0A=
-					diff >>=3D 1;=0A=
+						temp >>=3D 1;=0A=
+						diff >>=3D 1;=0A=
 					}=0A=
 				}=0A=
 				devicemap++;=0A=
@@ -813,20 +813,20 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 					lun < ARCMSR_MAX_TARGETLUN;=0A=
 					lun++) {=0A=
 						if ((temp & 0x01) =3D=3D 1 &&=0A=
-							(diff & 0x01) =3D=3D 1) {=0A=
+						(diff & 0x01) =3D=3D 1) {=0A=
 							scsi_add_device(acb->host,=0A=
 							0, target, lun);=0A=
 						} else if ((temp & 0x01) =3D=3D 0=0A=
-							&& (diff & 0x01) =3D=3D 1) {=0A=
+						&& (diff & 0x01) =3D=3D 1) {=0A=
 							psdev =3D scsi_device_lookup(acb->host,=0A=
 							0, target, lun);=0A=
 							if (psdev !=3D NULL) {=0A=
 								scsi_remove_device(psdev);=0A=
 								scsi_device_put(psdev);=0A=
 							}=0A=
-					}=0A=
-					temp >>=3D 1;=0A=
-					diff >>=3D 1;=0A=
+						}=0A=
+						temp >>=3D 1;=0A=
+						diff >>=3D 1;=0A=
 					}=0A=
 				}=0A=
 				devicemap++;=0A=
@@ -869,10 +869,10 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 							if (psdev !=3D NULL) {=0A=
 								scsi_remove_device(psdev);=0A=
 								scsi_device_put(psdev);=0A=
+							}=0A=
 						}=0A=
-					}=0A=
-					temp >>=3D 1;=0A=
-					diff >>=3D 1;=0A=
+						temp >>=3D 1;=0A=
+						diff >>=3D 1;=0A=
 					}=0A=
 				}=0A=
 				devicemap++;=0A=
@@ -915,10 +915,10 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 							if (psdev !=3D NULL) {=0A=
 								scsi_remove_device(psdev);=0A=
 								scsi_device_put(psdev);=0A=
+							}=0A=
 						}=0A=
-					}=0A=
-					temp >>=3D 1;=0A=
-					diff >>=3D 1;=0A=
+						temp >>=3D 1;=0A=
+						diff >>=3D 1;=0A=
 					}=0A=
 				}=0A=
 				devicemap++;=0A=
@@ -981,8 +981,8 @@ arcmsr_resume(struct pci_dev *pdev)=0A=
 		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
 		if (error) {=0A=
 				pr_warn("scsi%d: No suitable DMA mask available\n",=0A=
-				host->host_no);=0A=
-				goto controller_unregister;=0A=
+			       host->host_no);=0A=
+			goto controller_unregister;=0A=
 		}=0A=
 	}=0A=
 	pci_set_master(pdev);=0A=
@@ -1097,6 +1097,7 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	spin_lock_init(&acb->eh_lock);=0A=
 	spin_lock_init(&acb->ccblist_lock);=0A=
 	spin_lock_init(&acb->postq_lock);=0A=
+	spin_lock_init(&acb->doneq_lock);=0A=
 	spin_lock_init(&acb->rqbuffer_lock);=0A=
 	spin_lock_init(&acb->wqbuffer_lock);=0A=
 	acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
@@ -1541,33 +1542,29 @@ arcmsr_done4abort_postqueue(struct Adapt=0A=
 		uint32_t doneq_index, index_stripped, addressLow, residual;=0A=
 		bool error;=0A=
 		struct CommandControlBlock *pCCB;=0A=
-		outbound_write_pointer =3D=0A=
-			readl(pmu->outboundlist_copy_pointer);=0A=
+		outbound_write_pointer =3D pmu->done_qbuffer[0].addressLow + 1;=0A=
 		doneq_index =3D pmu->doneq_index;=0A=
 		residual =3D atomic_read(&acb->ccboutstandingcount);=0A=
 		for (i =3D 0; i < residual; i++) {=0A=
-			while ((doneq_index & 0xFF) !=3D=0A=
-				(outbound_write_pointer & 0xFF)) {=0A=
+			while ((doneq_index & 0xFFF) !=3D (outbound_write_pointer & 0xFFF)) {=0A=
 				if (doneq_index & 0x4000) {=0A=
-					index_stripped =3D doneq_index & 0xFF;=0A=
+					index_stripped =3D doneq_index & 0xFFF;=0A=
 					index_stripped +=3D 1;=0A=
 					index_stripped %=3D=0A=
-					ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+					ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
 					pmu->doneq_index =3D index_stripped ?=0A=
-					(index_stripped | 0x4000) :=0A=
-					index_stripped;=0A=
+					(index_stripped | 0x4000) : (index_stripped + 1);=0A=
 				} else {=0A=
 					index_stripped =3D doneq_index;=0A=
 					index_stripped +=3D 1;=0A=
 					index_stripped %=3D=0A=
-					ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+					ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
 					pmu->doneq_index =3D=0A=
-					index_stripped ? index_stripped :=0A=
-					(index_stripped | 0x4000);=0A=
+					index_stripped ? index_stripped : ((index_stripped | 0x4000) + 1);=0A=
 				}=0A=
 				doneq_index =3D pmu->doneq_index;=0A=
 				addressLow =3D=0A=
-				pmu->done_qbuffer[doneq_index & 0xFF].addressLow;=0A=
+				pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;=0A=
 				ccb_cdb_phy =3D (addressLow & 0xFFFFFFF0);=0A=
 				pARCMSR_CDB =3D (struct  ARCMSR_CDB *)=0A=
 				(acb->vir2phy_offset + ccb_cdb_phy);=0A=
@@ -1582,7 +1579,7 @@ arcmsr_done4abort_postqueue(struct Adapt=0A=
 			}=0A=
 			mdelay(10);=0A=
 			outbound_write_pointer =3D=0A=
-				readl(pmu->outboundlist_copy_pointer);=0A=
+				pmu->done_qbuffer[0].addressLow + 1;=0A=
 			doneq_index =3D pmu->doneq_index;=0A=
 		}=0A=
 		pmu->postq_index =3D 0;=0A=
@@ -2004,12 +2001,14 @@ arcmsr_iop_message_read(struct AdapterCo=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
 		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+		/*readl(&reg->inbound_doorbell);*/=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_D: {=0A=
 		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
 		writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,=0A=
 		reg->inbound_doorbell);=0A=
+		/*readl(reg->inbound_doorbell);*/=0A=
 		break;=0A=
 	}=0A=
 	}=0A=
@@ -2127,36 +2126,61 @@ struct QBUFFER __iomem=0A=
 void=0A=
 arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	uint8_t __iomem *iop_data;=0A=
-	struct QBUFFER __iomem *prbuffer;=0A=
-	struct QBUFFER *pQbuffer;=0A=
-	int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;=0A=
+	uint8_t __iomem *iop_data, *pQbuffer, *vaddr, *temp;=0A=
+	int32_t buf_empty_len, data_len, data_len_residual;=0A=
+	uint32_t rqbuf_firstindex, rqbuf_lastindex;=0A=
 	unsigned long flags;=0A=
-=0A=
+	struct QBUFFER __iomem  *prbuffer;=0A=
 	spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
 	rqbuf_lastindex =3D acb->rqbuf_lastindex;=0A=
 	rqbuf_firstindex =3D acb->rqbuf_firstindex;=0A=
 	prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
 	iop_data =3D (uint8_t __iomem *)prbuffer->data;=0A=
-	iop_len =3D prbuffer->data_len;=0A=
-	my_empty_len =3D (rqbuf_firstindex - rqbuf_lastindex - 1) &=0A=
-	(ARCMSR_MAX_QBUFFER - 1);=0A=
-=0A=
-	if (my_empty_len >=3D iop_len) {=0A=
-		while (iop_len > 0) {=0A=
-			pQbuffer =3D (struct QBUFFER *)=0A=
-			&acb->rqbuffer[rqbuf_lastindex];=0A=
-			memcpy(pQbuffer, iop_data, 1);=0A=
-			rqbuf_lastindex++;=0A=
-			rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-			iop_data++;=0A=
-			iop_len--;=0A=
+	data_len_residual =3D data_len =3D readl(&prbuffer->data_len);=0A=
+	buf_empty_len =3D (rqbuf_firstindex - rqbuf_lastindex - 1) &=0A=
+		(ARCMSR_MAX_QBUFFER - 1);=0A=
+	if (buf_empty_len >=3D data_len) {=0A=
+		if (data_len > 0) {=0A=
+			temp =3D vaddr =3D kmalloc(data_len, GFP_ATOMIC);=0A=
+			if (!vaddr) {=0A=
+				goto leave;=0A=
+			}=0A=
+			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
+			while (data_len_residual >=3D 4) {=0A=
+				memcpy(temp, iop_data, 4);=0A=
+				temp +=3D 4;=0A=
+				iop_data +=3D 4;=0A=
+				data_len_residual -=3D 4;=0A=
+			}=0A=
+			if ((data_len_residual > 0) &&=0A=
+			(data_len_residual < 4)) {=0A=
+				memcpy(temp, iop_data, data_len_residual);=0A=
+			}=0A=
+			pQbuffer =3D &acb->rqbuffer[rqbuf_lastindex];=0A=
+			temp =3D vaddr;=0A=
+			if ((rqbuf_lastindex + data_len) >=0A=
+			ARCMSR_MAX_QBUFFER) {=0A=
+				memcpy(pQbuffer, temp,=0A=
+				ARCMSR_MAX_QBUFFER - rqbuf_lastindex);=0A=
+				temp +=3D (ARCMSR_MAX_QBUFFER -=0A=
+				rqbuf_lastindex);=0A=
+				rqbuf_lastindex =3D (rqbuf_lastindex + data_len)=0A=
+				% ARCMSR_MAX_QBUFFER;=0A=
+				memcpy(&acb->rqbuffer[0], temp,=0A=
+				rqbuf_lastindex);=0A=
+			} else {=0A=
+				memcpy(pQbuffer, temp, data_len);=0A=
+				rqbuf_lastindex =3D (rqbuf_lastindex + data_len)=0A=
+				% ARCMSR_MAX_QBUFFER;=0A=
+			}=0A=
+			kfree(vaddr);=0A=
+			acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
+			arcmsr_iop_message_read(acb);=0A=
 		}=0A=
-		acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
-		arcmsr_iop_message_read(acb);=0A=
 	} else {=0A=
 		acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
 	}=0A=
+	leave:=0A=
 	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
 }=0A=
 =0A=
@@ -2164,7 +2188,6 @@ void=0A=
 arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	unsigned long flags;=0A=
-=0A=
 	spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
 	acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_READED;=0A=
 	if (acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) {=0A=
@@ -2176,18 +2199,113 @@ arcmsr_iop2drv_data_read_handle(struct A=0A=
 		acb->acb_flags &=3D (~ACB_F_MESSAGE_WQBUFFER_READED);=0A=
 		pwbuffer =3D arcmsr_get_iop_wqbuffer(acb);=0A=
 		iop_data =3D (uint8_t __iomem *)pwbuffer->data;=0A=
-=0A=
-		while ((acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) &&=0A=
-		(allxfer_len < 124)) {=0A=
-			pQbuffer =3D &acb->wqbuffer[acb->wqbuf_firstindex];=0A=
-			memcpy(iop_data, pQbuffer, 1);=0A=
-			acb->wqbuf_firstindex++;=0A=
-			acb->wqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-			iop_data++;=0A=
-			allxfer_len++;=0A=
+		if (acb->wqbuf_firstindex > acb->wqbuf_lastindex) {=0A=
+			if ((ARCMSR_MAX_QBUFFER - acb->wqbuf_firstindex) >=3D 4) {=0A=
+				do {=0A=
+					pQbuffer =3D=0A=
+					&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
+					if (acb->wqbuf_firstindex + 4=0A=
+					> ARCMSR_MAX_QBUFFER) {=0A=
+						memcpy(iop_data, pQbuffer,=0A=
+						ARCMSR_MAX_QBUFFER=0A=
+						- acb->wqbuf_firstindex);=0A=
+						iop_data +=3D ARCMSR_MAX_QBUFFER=0A=
+						- acb->wqbuf_firstindex;=0A=
+						acb->wqbuf_firstindex +=3D 4;=0A=
+						acb->wqbuf_firstindex %=3D=0A=
+						ARCMSR_MAX_QBUFFER;=0A=
+						memcpy(iop_data,=0A=
+						&acb->wqbuffer[0],=0A=
+						acb->wqbuf_firstindex);=0A=
+						iop_data +=3D=0A=
+						acb->wqbuf_firstindex;=0A=
+					} else {=0A=
+						if ((acb->wqbuf_lastindex=0A=
+						- acb->wqbuf_firstindex) > 4) {=0A=
+							memcpy(iop_data,=0A=
+							pQbuffer, 4);=0A=
+							acb->wqbuf_firstindex=0A=
+							+=3D 4;=0A=
+							acb->wqbuf_firstindex=0A=
+							%=3D ARCMSR_MAX_QBUFFER;=0A=
+							iop_data +=3D 4;=0A=
+						} else {=0A=
+							memcpy(iop_data, pQbuffer,=0A=
+							acb->wqbuf_lastindex=0A=
+							- acb->wqbuf_firstindex);=0A=
+							allxfer_len +=3D=0A=
+							acb->wqbuf_lastindex -=0A=
+							acb->wqbuf_firstindex;=0A=
+							acb->wqbuf_firstindex =3D=0A=
+							acb->wqbuf_lastindex;=0A=
+							break;=0A=
+						}=0A=
+					}=0A=
+					allxfer_len +=3D 4;=0A=
+				} while ((acb->wqbuf_firstindex !=3D=0A=
+				acb->wqbuf_lastindex) && (allxfer_len < 124));=0A=
+			} else {=0A=
+				pQbuffer =3D=0A=
+				&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
+				memcpy(iop_data, pQbuffer, ARCMSR_MAX_QBUFFER=0A=
+				- acb->wqbuf_firstindex);=0A=
+				iop_data +=3D ARCMSR_MAX_QBUFFER=0A=
+				- acb->wqbuf_firstindex;=0A=
+				allxfer_len =3D ARCMSR_MAX_QBUFFER=0A=
+				- acb->wqbuf_firstindex;=0A=
+				acb->wqbuf_firstindex =3D 0;=0A=
+				do {=0A=
+					pQbuffer =3D=0A=
+					&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
+					if ((acb->wqbuf_lastindex -=0A=
+					acb->wqbuf_firstindex) > 4) {=0A=
+						memcpy(iop_data, pQbuffer, 4);=0A=
+						acb->wqbuf_firstindex +=3D 4;=0A=
+						acb->wqbuf_firstindex %=3D=0A=
+						ARCMSR_MAX_QBUFFER;=0A=
+						iop_data +=3D 4;=0A=
+					} else {=0A=
+						memcpy(iop_data, pQbuffer,=0A=
+						acb->wqbuf_lastindex -=0A=
+						acb->wqbuf_firstindex);=0A=
+						allxfer_len +=3D=0A=
+						acb->wqbuf_lastindex=0A=
+						- acb->wqbuf_firstindex;=0A=
+						acb->wqbuf_firstindex =3D=0A=
+						acb->wqbuf_lastindex;=0A=
+						break;=0A=
+					}=0A=
+					allxfer_len +=3D 4;=0A=
+				} while ((acb->wqbuf_firstindex !=3D=0A=
+				acb->wqbuf_lastindex) && (allxfer_len < 124));=0A=
+			}=0A=
+		} else {=0A=
+			do {=0A=
+				pQbuffer =3D=0A=
+				&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
+				if ((acb->wqbuf_lastindex -=0A=
+				acb->wqbuf_firstindex) > 4) {=0A=
+					memcpy(iop_data, pQbuffer, 4);=0A=
+					acb->wqbuf_firstindex +=3D 4;=0A=
+					acb->wqbuf_firstindex %=3D=0A=
+					ARCMSR_MAX_QBUFFER;=0A=
+					iop_data +=3D 4;=0A=
+				} else {=0A=
+					memcpy(iop_data, pQbuffer,=0A=
+					acb->wqbuf_lastindex -=0A=
+					acb->wqbuf_firstindex);=0A=
+					allxfer_len +=3D acb->wqbuf_lastindex=0A=
+					- acb->wqbuf_firstindex;=0A=
+					acb->wqbuf_firstindex =3D=0A=
+					acb->wqbuf_lastindex;=0A=
+					break;=0A=
+				}=0A=
+				allxfer_len +=3D 4;=0A=
+			} while ((acb->wqbuf_firstindex !=3D=0A=
+			acb->wqbuf_lastindex) && (allxfer_len < 124));=0A=
 		}=0A=
-		pwbuffer->data_len =3D allxfer_len;=0A=
-		arcmsr_iop_message_wrote(acb);=0A=
+		writel(allxfer_len, &pwbuffer->data_len);=0A=
+		arcmsr_iop_message_wrote(acb);/*notice IOP the message has been =
written*/=0A=
 	}=0A=
 	if (acb->wqbuf_firstindex =3D=3D acb->wqbuf_lastindex) {=0A=
 		acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
@@ -2200,7 +2318,6 @@ arcmsr_hbaA_doorbell_isr(struct AdapterC=0A=
 {=0A=
 	uint32_t outbound_doorbell;=0A=
 	struct MessageUnit_A __iomem *reg  =3D acb->pmuA;=0A=
-=0A=
 	outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
 	do {=0A=
 		writel(outbound_doorbell, &reg->outbound_doorbell);=0A=
@@ -2223,7 +2340,6 @@ arcmsr_hbaC_doorbell_isr(struct AdapterC=0A=
 	uint32_t outbound_doorbell;=0A=
 	struct MessageUnit_C __iomem *reg =3D=0A=
 		(struct MessageUnit_C *)pACB->pmuC;=0A=
-=0A=
 	outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
 	do {=0A=
 		if (outbound_doorbell &=0A=
@@ -2255,10 +2371,6 @@ arcmsr_hbaD_doorbell_isr(struct AdapterC=0A=
 		(struct MessageUnit_D *)pACB->pmuD;=0A=
 =0A=
 	outbound_doorbell =3D readl(pmu->outbound_doorbell);=0A=
-	if (unlikely(!outbound_doorbell)) {=0A=
-		arcmsr_iop2drv_data_wrote_handle(pACB);=0A=
-		arcmsr_iop2drv_data_read_handle(pACB);=0A=
-	}=0A=
 	do {=0A=
 		writel(outbound_doorbell, pmu->outbound_doorbell);=0A=
 		if (outbound_doorbell &=0A=
@@ -2367,28 +2479,30 @@ arcmsr_hbaD_postqueue_isr(struct Adapter=0A=
 	struct MessageUnit_D __iomem *pmu;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb;=0A=
 	struct CommandControlBlock *ccb;=0A=
+	unsigned long flags;=0A=
 =0A=
+	spin_lock_irqsave(&acb->doneq_lock, flags);=0A=
 	pmu =3D (struct MessageUnit_D *)acb->pmuD;=0A=
-	outbound_write_pointer =3D readl(pmu->outboundlist_copy_pointer);=0A=
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
@@ -2399,12 +2513,13 @@ arcmsr_hbaD_postqueue_isr(struct Adapter=0A=
 			arcmsr_drain_donequeue(acb, ccb, error);=0A=
 			writel(doneq_index,=0A=
 				pmu->outboundlist_read_pointer);=0A=
-		} while ((doneq_index & 0xFF) !=3D=0A=
-		(outbound_write_pointer & 0xFF));=0A=
+		} while ((doneq_index & 0xFFF) !=3D=0A=
+		(outbound_write_pointer & 0xFFF));=0A=
 	}=0A=
 	writel(ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR,=0A=
 		pmu->outboundlist_interrupt_cause);=0A=
 	readl(pmu->outboundlist_interrupt_cause);=0A=
+	spin_unlock_irqrestore(&acb->doneq_lock, flags);=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -2457,7 +2572,6 @@ arcmsr_hbaA_handle_isr(struct AdapterCon=0A=
 	}=0A=
 	do {=0A=
 		writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
-		readl(&reg->outbound_intstatus);=0A=
 		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)=0A=
 			arcmsr_hbaA_doorbell_isr(acb);=0A=
 		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT)=0A=
@@ -2597,29 +2711,131 @@ arcmsr_iop_parking(struct AdapterControl=0A=
 void=0A=
 arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	uint8_t __iomem *iop_data;=0A=
-	uint8_t *pQbuffer;=0A=
-	int32_t wqbuf_firstindex, wqbuf_lastindex;=0A=
-	int32_t allxfer_len =3D 0;=0A=
-	struct QBUFFER __iomem *pwbuffer;=0A=
-	pwbuffer =3D arcmsr_get_iop_wqbuffer(acb);=0A=
-	iop_data =3D (uint8_t __iomem *)pwbuffer->data;=0A=
 	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {=0A=
-		acb->acb_flags &=3D (~ACB_F_MESSAGE_WQBUFFER_READED);=0A=
-		wqbuf_firstindex =3D acb->wqbuf_firstindex;=0A=
-		wqbuf_lastindex =3D acb->wqbuf_lastindex;=0A=
-		while ((wqbuf_firstindex !=3D wqbuf_lastindex)=0A=
-			&& (allxfer_len < 124)) {=0A=
-			pQbuffer =3D &acb->wqbuffer[wqbuf_firstindex];=0A=
-			memcpy(iop_data, pQbuffer, 1);=0A=
-			wqbuf_firstindex++;=0A=
-			wqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-			iop_data++;=0A=
-			allxfer_len++;=0A=
-		}=0A=
-		acb->wqbuf_firstindex =3D wqbuf_firstindex;=0A=
-		pwbuffer->data_len =3D allxfer_len;=0A=
-		arcmsr_iop_message_wrote(acb);=0A=
+		if (acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) {=0A=
+			uint8_t *pQbuffer;=0A=
+			uint8_t __iomem *iop_data;=0A=
+			int32_t allxfer_len =3D 0;=0A=
+			struct QBUFFER __iomem *pwbuffer;=0A=
+			acb->acb_flags &=3D (~ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+			pwbuffer =3D arcmsr_get_iop_wqbuffer(acb);=0A=
+			iop_data =3D (uint8_t __iomem *)pwbuffer->data;=0A=
+			if (acb->wqbuf_firstindex > acb->wqbuf_lastindex) {=0A=
+				if ((ARCMSR_MAX_QBUFFER -=0A=
+					acb->wqbuf_firstindex) >=3D 4) {=0A=
+					do {=0A=
+						pQbuffer =3D=0A=
+						&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
+						if (acb->wqbuf_firstindex + 4 >=0A=
+						ARCMSR_MAX_QBUFFER) {=0A=
+							memcpy(iop_data, pQbuffer,=0A=
+							ARCMSR_MAX_QBUFFER - acb->wqbuf_firstindex);=0A=
+							iop_data +=3D ARCMSR_MAX_QBUFFER=0A=
+							- acb->wqbuf_firstindex;=0A=
+							acb->wqbuf_firstindex +=3D 4;=0A=
+							acb->wqbuf_firstindex %=3D=0A=
+							ARCMSR_MAX_QBUFFER;=0A=
+							memcpy(iop_data,=0A=
+							&acb->wqbuffer[0],=0A=
+							acb->wqbuf_firstindex);=0A=
+							iop_data +=3D=0A=
+							acb->wqbuf_firstindex;=0A=
+						} else {=0A=
+							if ((acb->wqbuf_lastindex -=0A=
+							acb->wqbuf_firstindex) > 4) {=0A=
+								memcpy(iop_data,=0A=
+								pQbuffer, 4);=0A=
+								acb->wqbuf_firstindex=0A=
+								+=3D 4;=0A=
+								acb->wqbuf_firstindex=0A=
+								%=3D ARCMSR_MAX_QBUFFER;=0A=
+								iop_data +=3D 4;=0A=
+							} else {=0A=
+								memcpy(iop_data,=0A=
+								pQbuffer,=0A=
+								acb->wqbuf_lastindex=0A=
+								- acb->wqbuf_firstindex);=0A=
+								allxfer_len +=3D=0A=
+								acb->wqbuf_lastindex=0A=
+								- acb->wqbuf_firstindex;=0A=
+								acb->wqbuf_firstindex=0A=
+								=3D acb->wqbuf_lastindex;=0A=
+								break;=0A=
+							}=0A=
+						}=0A=
+						allxfer_len +=3D 4;=0A=
+					} while ((acb->wqbuf_firstindex !=3D=0A=
+					acb->wqbuf_lastindex) &&=0A=
+					(allxfer_len < 124));=0A=
+				} else {=0A=
+					pQbuffer =3D=0A=
+					&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
+					memcpy(iop_data, pQbuffer,=0A=
+					ARCMSR_MAX_QBUFFER -=0A=
+					acb->wqbuf_firstindex);=0A=
+					iop_data +=3D ARCMSR_MAX_QBUFFER=0A=
+					- acb->wqbuf_firstindex;=0A=
+					allxfer_len =3D ARCMSR_MAX_QBUFFER=0A=
+					- acb->wqbuf_firstindex;=0A=
+					acb->wqbuf_firstindex =3D 0;=0A=
+					do {=0A=
+						pQbuffer =3D=0A=
+						&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
+						if ((acb->wqbuf_lastindex -=0A=
+						acb->wqbuf_firstindex) > 4) {=0A=
+							memcpy(iop_data,=0A=
+							pQbuffer, 4);=0A=
+							acb->wqbuf_firstindex=0A=
+							+=3D 4;=0A=
+							acb->wqbuf_firstindex=0A=
+							%=3D ARCMSR_MAX_QBUFFER;=0A=
+							iop_data +=3D 4;=0A=
+						} else {=0A=
+							memcpy(iop_data, pQbuffer,=0A=
+							acb->wqbuf_lastindex=0A=
+							- acb->wqbuf_firstindex);=0A=
+							allxfer_len +=3D=0A=
+							acb->wqbuf_lastindex=0A=
+							- acb->wqbuf_firstindex;=0A=
+							acb->wqbuf_firstindex =3D=0A=
+							acb->wqbuf_lastindex;=0A=
+							break;=0A=
+						}=0A=
+						allxfer_len +=3D 4;=0A=
+					} while ((acb->wqbuf_firstindex=0A=
+					!=3D acb->wqbuf_lastindex) &&=0A=
+					(allxfer_len < 124));=0A=
+				}=0A=
+			} else {=0A=
+				do {=0A=
+					pQbuffer =3D=0A=
+					&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
+					if ((acb->wqbuf_lastindex -=0A=
+					acb->wqbuf_firstindex) > 4) {=0A=
+						memcpy(iop_data,=0A=
+						pQbuffer, 4);=0A=
+						acb->wqbuf_firstindex=0A=
+						+=3D 4;=0A=
+						acb->wqbuf_firstindex=0A=
+						%=3D ARCMSR_MAX_QBUFFER;=0A=
+						iop_data +=3D 4;=0A=
+					} else {=0A=
+						memcpy(iop_data, pQbuffer,=0A=
+						acb->wqbuf_lastindex -=0A=
+						acb->wqbuf_firstindex);=0A=
+						allxfer_len +=3D acb->wqbuf_lastindex=0A=
+						- acb->wqbuf_firstindex;=0A=
+						acb->wqbuf_firstindex =3D=0A=
+						acb->wqbuf_lastindex;=0A=
+						break;=0A=
+					}=0A=
+					allxfer_len +=3D 4;=0A=
+				} while ((acb->wqbuf_firstindex !=3D=0A=
+				acb->wqbuf_lastindex) && (allxfer_len < 124));=0A=
+			}=0A=
+			writel(allxfer_len, &pwbuffer->data_len);=0A=
+			arcmsr_iop_message_wrote(acb);=0A=
+		}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -2627,74 +2843,155 @@ static int=0A=
 arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,=0A=
 					struct scsi_cmnd *cmd)=0A=
 {=0A=
-	struct CMD_MESSAGE_FIELD *pcmdmessagefld;=0A=
-	int retvalue =3D 0, transfer_len =3D 0;=0A=
 	char *buffer;=0A=
+	unsigned short use_sg;=0A=
+	int retvalue =3D 0, transfer_len =3D 0;=0A=
+	unsigned long flags;=0A=
+	struct CMD_MESSAGE_FIELD *pcmdmessagefld;=0A=
+	uint32_t	controlcode =3D (uint32_t)cmd->cmnd[5] << 24 |=0A=
+		(uint32_t)cmd->cmnd[6] << 16 |=0A=
+		(uint32_t)cmd->cmnd[7] << 8 |=0A=
+		(uint32_t)cmd->cmnd[8];=0A=
 	struct scatterlist *sg;=0A=
-	uint32_t controlcode =3D (uint32_t)cmd->cmnd[5] << 24=0A=
-	|(uint32_t)cmd->cmnd[6] << 16=0A=
-	|(uint32_t)cmd->cmnd[7] << 8=0A=
-	| (uint32_t)cmd->cmnd[8];=0A=
+=0A=
+	use_sg =3D scsi_sg_count(cmd);=0A=
 	sg =3D scsi_sglist(cmd);=0A=
 	buffer =3D kmap_atomic(sg_page(sg)) + sg->offset;=0A=
-	if (scsi_sg_count(cmd) > 1) {=0A=
+	if (use_sg > 1) {=0A=
 		retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 		goto message_out;=0A=
 	}=0A=
 	transfer_len +=3D sg->length;=0A=
-=0A=
 	if (transfer_len > sizeof(struct CMD_MESSAGE_FIELD)) {=0A=
 		retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
+		printk("%s: ARCMSR_MESSAGE_FAIL!\n", __func__);=0A=
 		goto message_out;=0A=
 	}=0A=
 	pcmdmessagefld =3D (struct CMD_MESSAGE_FIELD *)buffer;=0A=
 	switch (controlcode) {=0A=
-=0A=
 	case ARCMSR_MESSAGE_READ_RQBUFFER: {=0A=
 		unsigned char *ver_addr;=0A=
 		uint8_t *pQbuffer, *ptmpQbuffer;=0A=
-		int32_t allxfer_len =3D 0;=0A=
-		unsigned long flags;=0A=
-=0A=
+		uint32_t allxfer_len =3D 0;=0A=
 		ver_addr =3D kmalloc(1032, GFP_ATOMIC);=0A=
 		if (!ver_addr) {=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
+			printk("%s: memory not enough!\n", __func__);=0A=
 			goto message_out;=0A=
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
+						acb->rqbuf_firstindex) +=0A=
+						acb->rqbuf_lastindex) > 1032) {=0A=
+						memcpy(ptmpQbuffer,=0A=
+						pQbuffer, ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex);=0A=
+						ptmpQbuffer +=3D=0A=
+						ARCMSR_MAX_QBUFFER -=0A=
+						acb->rqbuf_firstindex;=0A=
+						memcpy(ptmpQbuffer,=0A=
+						acb->rqbuffer, 1032 -=0A=
+						(ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex));=0A=
+						acb->rqbuf_firstindex =3D=0A=
+						1032 - (ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex);=0A=
+						allxfer_len =3D 1032;=0A=
+					} else {=0A=
+						memcpy(ptmpQbuffer,=0A=
+						pQbuffer, ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex);=0A=
+						ptmpQbuffer +=3D=0A=
+						ARCMSR_MAX_QBUFFER -=0A=
+						acb->rqbuf_firstindex;=0A=
+						memcpy(ptmpQbuffer,=0A=
+						acb->rqbuffer,=0A=
+						acb->rqbuf_lastindex);=0A=
+						allxfer_len =3D ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex +=0A=
+						acb->rqbuf_lastindex;=0A=
+						acb->rqbuf_firstindex =3D=0A=
+						acb->rqbuf_lastindex;=0A=
+					}=0A=
+				}=0A=
+			} else {=0A=
+				if ((acb->rqbuf_lastindex -=0A=
+				acb->rqbuf_firstindex) > 1032) {=0A=
+					memcpy(ptmpQbuffer, pQbuffer, 1032);=0A=
+					acb->rqbuf_firstindex +=3D 1032;=0A=
+					allxfer_len =3D 1032;=0A=
+				} else {=0A=
+					memcpy(ptmpQbuffer, pQbuffer,=0A=
+					acb->rqbuf_lastindex - acb->rqbuf_firstindex);=0A=
+					allxfer_len =3D acb->rqbuf_lastindex=0A=
+					- acb->rqbuf_firstindex;=0A=
+					acb->rqbuf_firstindex =3D=0A=
+					acb->rqbuf_lastindex;=0A=
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
+			uint32_t data_len_residual, data_len, rqbuf_lastindex;=0A=
+			rqbuf_lastindex =3D acb->rqbuf_lastindex;=0A=
 			prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
-			iop_data =3D prbuffer->data;=0A=
-			iop_len =3D readl(&prbuffer->data_len);=0A=
-			while (iop_len > 0) {=0A=
-				acb->rqbuffer[acb->rqbuf_lastindex] =3D=0A=
-				readb(iop_data);=0A=
-				acb->rqbuf_lastindex++;=0A=
-				acb->rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-				iop_data++;=0A=
-				iop_len--;=0A=
+			iop_data =3D (uint8_t __iomem *)prbuffer->data;=0A=
+			data_len_residual =3D data_len =3D readl(&prbuffer->data_len);=0A=
+			if (data_len > 0) {=0A=
+				temp =3D vaddr =3D kmalloc(data_len, GFP_ATOMIC);=0A=
+				if (!vaddr) {=0A=
+					goto leave;=0A=
+				}=0A=
+				acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
+				while (data_len_residual >=3D 4) {=0A=
+					memcpy(temp, iop_data, 4);=0A=
+					temp +=3D 4;=0A=
+					iop_data +=3D 4;=0A=
+					data_len_residual -=3D 4;=0A=
+				}=0A=
+				if ((data_len_residual > 0) &&=0A=
+				(data_len_residual < 4)) {=0A=
+					memcpy(temp, iop_data,=0A=
+					data_len_residual);=0A=
+				}=0A=
+				pQbuffer =3D=0A=
+				&acb->rqbuffer[acb->rqbuf_lastindex];=0A=
+				temp =3D vaddr;=0A=
+				if ((rqbuf_lastindex + data_len) >=0A=
+				ARCMSR_MAX_QBUFFER) {=0A=
+					memcpy(pQbuffer, temp,=0A=
+					ARCMSR_MAX_QBUFFER - rqbuf_lastindex);=0A=
+					temp +=3D (ARCMSR_MAX_QBUFFER -=0A=
+					rqbuf_lastindex);=0A=
+					rqbuf_lastindex =3D (rqbuf_lastindex +=0A=
+					data_len) % ARCMSR_MAX_QBUFFER;=0A=
+					memcpy(&acb->rqbuffer[0],=0A=
+					temp, rqbuf_lastindex);=0A=
+				} else {=0A=
+					memcpy(pQbuffer, temp, data_len);=0A=
+					rqbuf_lastindex =3D=0A=
+					(rqbuf_lastindex + data_len) %=0A=
+					ARCMSR_MAX_QBUFFER;=0A=
+				}=0A=
+				kfree(vaddr);=0A=
+				acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
+				arcmsr_iop_message_read(acb);=0A=
 			}=0A=
-			arcmsr_iop_message_read(acb);=0A=
 		}=0A=
+		leave:=0A=
 		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
-		memcpy(pcmdmessagefld->messagedatabuffer,=0A=
-		ver_addr, allxfer_len);=0A=
+		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);=0A=
 		pcmdmessagefld->cmdmessage.Length =3D allxfer_len;=0A=
 		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
@@ -2704,26 +3001,23 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		kfree(ver_addr);=0A=
-		}=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {=0A=
 		unsigned char *ver_addr;=0A=
 		int32_t my_empty_len, user_len, wqbuf_firstindex,=0A=
 		wqbuf_lastindex;=0A=
 		uint8_t *pQbuffer, *ptmpuserbuffer;=0A=
-		unsigned long flags;=0A=
-=0A=
 		ver_addr =3D kmalloc(1032, GFP_ATOMIC);=0A=
 		if (!ver_addr) {=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			goto message_out;=0A=
 		}=0A=
 		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D =0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
 		} else {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D =0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		ptmpuserbuffer =3D ver_addr;=0A=
@@ -2735,28 +3029,39 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 		wqbuf_firstindex =3D acb->wqbuf_firstindex;=0A=
 		if (wqbuf_lastindex !=3D wqbuf_firstindex) {=0A=
 			struct SENSE_DATA *sensebuffer =3D=0A=
-				(struct SENSE_DATA *)cmd->sense_buffer;=0A=
+			(struct SENSE_DATA *)cmd->sense_buffer;=0A=
 			arcmsr_post_ioctldata2iop(acb);=0A=
 			/* has error report sensedata */=0A=
-			sensebuffer->ErrorCode =3D 0x70;=0A=
+			sensebuffer->ErrorCode =3D SCSI_SENSE_CURRENT_ERRORS;=0A=
 			sensebuffer->SenseKey =3D ILLEGAL_REQUEST;=0A=
 			sensebuffer->AdditionalSenseLength =3D 0x0A;=0A=
 			sensebuffer->AdditionalSenseCode =3D 0x20;=0A=
 			sensebuffer->Valid =3D 1;=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 		} else {=0A=
-			my_empty_len =3D (wqbuf_firstindex-wqbuf_lastindex - 1)=0A=
-				&(ARCMSR_MAX_QBUFFER - 1);=0A=
+			my_empty_len =3D (wqbuf_firstindex - wqbuf_lastindex - 1)=0A=
+			& (ARCMSR_MAX_QBUFFER - 1);=0A=
 			if (my_empty_len >=3D user_len) {=0A=
 				while (user_len > 0) {=0A=
-					pQbuffer =3D=0A=
-					&acb->wqbuffer[acb->wqbuf_lastindex];=0A=
-					memcpy(pQbuffer, ptmpuserbuffer, 1);=0A=
-					acb->wqbuf_lastindex++;=0A=
-					acb->wqbuf_lastindex %=3D=0A=
-					ARCMSR_MAX_QBUFFER;=0A=
-					ptmpuserbuffer++;=0A=
-					user_len--;=0A=
+					pQbuffer =3D &acb->wqbuffer[acb->wqbuf_lastindex];=0A=
+					if ((acb->wqbuf_lastindex + user_len)=0A=
+						> ARCMSR_MAX_QBUFFER) {=0A=
+						memcpy(pQbuffer, ptmpuserbuffer,=0A=
+						ARCMSR_MAX_QBUFFER -=0A=
+						acb->wqbuf_lastindex);=0A=
+						ptmpuserbuffer +=3D (ARCMSR_MAX_QBUFFER=0A=
+						- acb->wqbuf_lastindex);=0A=
+						user_len -=3D (ARCMSR_MAX_QBUFFER=0A=
+						- acb->wqbuf_lastindex);=0A=
+						acb->wqbuf_lastindex =3D 0;=0A=
+					} else {=0A=
+						memcpy(pQbuffer, ptmpuserbuffer,=0A=
+						user_len);=0A=
+						acb->wqbuf_lastindex +=3D user_len;=0A=
+						acb->wqbuf_lastindex %=3D=0A=
+						ARCMSR_MAX_QBUFFER;=0A=
+						user_len =3D 0;=0A=
+					}=0A=
 				}=0A=
 				if (acb->acb_flags &=0A=
 				ACB_F_MESSAGE_WQBUFFER_CLEARED) {=0A=
@@ -2765,24 +3070,26 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 					arcmsr_post_ioctldata2iop(acb);=0A=
 				}=0A=
 			} else {=0A=
-				/* has error report sensedata */=0A=
 				struct SENSE_DATA *sensebuffer =3D=0A=
-					(struct SENSE_DATA *)cmd->sense_buffer;=0A=
-				sensebuffer->ErrorCode =3D 0x70;=0A=
+				(struct SENSE_DATA *)cmd->sense_buffer;=0A=
+				/* has error report sensedata */=0A=
+				sensebuffer->ErrorCode =3D=0A=
+				SCSI_SENSE_CURRENT_ERRORS;=0A=
 				sensebuffer->SenseKey =3D ILLEGAL_REQUEST;=0A=
 				sensebuffer->AdditionalSenseLength =3D 0x0A;=0A=
 				sensebuffer->AdditionalSenseCode =3D 0x20;=0A=
 				sensebuffer->Valid =3D 1;=0A=
 				retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			}=0A=
-			}=0A=
-			spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
-			kfree(ver_addr);=0A=
 		}=0A=
+		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
+		kfree(ver_addr);=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {=0A=
 		uint8_t *pQbuffer =3D acb->rqbuffer;=0A=
+=0A=
+		spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
 			arcmsr_iop_message_read(acb);=0A=
@@ -2791,6 +3098,7 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 		acb->rqbuf_firstindex =3D 0;=0A=
 		acb->rqbuf_lastindex =3D 0;=0A=
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);=0A=
+		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
 		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
@@ -2798,9 +3106,8 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
-		}=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {=0A=
 		uint8_t *pQbuffer =3D acb->wqbuffer;=0A=
 		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
@@ -2810,39 +3117,40 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
-=0A=
+		spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
 			arcmsr_iop_message_read(acb);=0A=
 		}=0A=
-		acb->acb_flags |=3D=0A=
-			(ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
-				ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+		acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
+		ACB_F_MESSAGE_WQBUFFER_READED);=0A=
 		acb->wqbuf_firstindex =3D 0;=0A=
 		acb->wqbuf_lastindex =3D 0;=0A=
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);=0A=
-		}=0A=
+		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {=0A=
 		uint8_t *pQbuffer;=0A=
-=0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
 			arcmsr_iop_message_read(acb);=0A=
 		}=0A=
-		acb->acb_flags |=3D=0A=
-			(ACB_F_MESSAGE_WQBUFFER_CLEARED=0A=
-			| ACB_F_MESSAGE_RQBUFFER_CLEARED=0A=
-			| ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+		spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
+		acb->acb_flags |=3D ACB_F_MESSAGE_RQBUFFER_CLEARED;=0A=
 		acb->rqbuf_firstindex =3D 0;=0A=
 		acb->rqbuf_lastindex =3D 0;=0A=
-		acb->wqbuf_firstindex =3D 0;=0A=
-		acb->wqbuf_lastindex =3D 0;=0A=
 		pQbuffer =3D acb->rqbuffer;=0A=
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));=0A=
+		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
+		spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
+		acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
+		ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+		acb->wqbuf_firstindex =3D 0;=0A=
+		acb->wqbuf_lastindex =3D 0;=0A=
 		pQbuffer =3D acb->wqbuffer;=0A=
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));=0A=
+		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
@@ -2850,9 +3158,8 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
-		}=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_RETURN_CODE_3F: {=0A=
 		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
@@ -2862,7 +3169,7 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 			ARCMSR_MESSAGE_RETURNCODE_3F;=0A=
 		}=0A=
 		break;=0A=
-		}=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_SAY_HELLO: {=0A=
 		int8_t *hello_string =3D "Hello! I am ARCMSR";=0A=
 		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
@@ -2872,33 +3179,42 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
-		memcpy(pcmdmessagefld->messagedatabuffer, hello_string=0A=
-			, (int16_t)strlen(hello_string));=0A=
-		}=0A=
+		memcpy(pcmdmessagefld->messagedatabuffer,=0A=
+		hello_string, (int16_t)strlen(hello_string));=0A=
 		break;=0A=
-=0A=
-	case ARCMSR_MESSAGE_SAY_GOODBYE:=0A=
+	}=0A=
+	case ARCMSR_MESSAGE_SAY_GOODBYE: {=0A=
 		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		arcmsr_iop_parking(acb);=0A=
 		break;=0A=
-=0A=
-	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:=0A=
+	}=0A=
+	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE: {=0A=
 		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		arcmsr_flush_adapter_cache(acb);=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	default:=0A=
 		retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
+		printk("unknown controlcode(%d)\n", __LINE__);=0A=
 	}=0A=
 	message_out:=0A=
-	sg =3D scsi_sglist(cmd);=0A=
-	kunmap_atomic(buffer - sg->offset);=0A=
+	if (use_sg) {=0A=
+		struct scatterlist *sg;=0A=
+		sg =3D scsi_sglist(cmd);=0A=
+		kunmap_atomic(buffer - sg->offset);=0A=
+	}=0A=
 	return retvalue;=0A=
 }=0A=
 =0A=
@@ -2930,7 +3246,6 @@ arcmsr_handle_virtual_command(struct Ada=0A=
 		unsigned char inqdata[36];=0A=
 		char *buffer;=0A=
 		struct scatterlist *sg;=0A=
-=0A=
 		if (cmd->device->lun) {=0A=
 			cmd->result =3D (DID_TIME_OUT << 16);=0A=
 			cmd->scsi_done(cmd);=0A=
@@ -2949,14 +3264,11 @@ arcmsr_handle_virtual_command(struct Ada=0A=
 		strncpy(&inqdata[16], "RAID controller ", 16);=0A=
 		/* Product Identification */=0A=
 		strncpy(&inqdata[32], "R001", 4); /* Product Revision */=0A=
-=0A=
 		sg =3D scsi_sglist(cmd);=0A=
 		buffer =3D kmap_atomic(sg_page(sg)) + sg->offset;=0A=
-=0A=
 		memcpy(buffer, inqdata, sizeof(inqdata));=0A=
 		sg =3D scsi_sglist(cmd);=0A=
 		kunmap_atomic(buffer - sg->offset);=0A=
-=0A=
 		cmd->scsi_done(cmd);=0A=
 	}=0A=
 	break;=0A=
@@ -3611,19 +3923,21 @@ arcmsr_hbaD_polling_ccbdone(struct Adapt=0A=
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
-			readl(reg->outboundlist_copy_pointer);=0A=
-		index =3D reg->doneq_index;=0A=
-		if ((outbound_write_pointer & 0xFF) =3D=3D index) {=0A=
+		pmu->done_qbuffer[0].addressLow + 1;=0A=
+		doneq_index =3D pmu->doneq_index;=0A=
+		if ((outbound_write_pointer & 0xFFF) =3D=3D (doneq_index & 0xFFF)) {=0A=
 			if (poll_ccb_done) {=0A=
 				rtn =3D SUCCESS;=0A=
 				break;=0A=
@@ -3636,17 +3950,27 @@ arcmsr_hbaD_polling_ccbdone(struct Adapt=0A=
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
@@ -3673,6 +3997,7 @@ arcmsr_hbaD_polling_ccbdone(struct Adapt=0A=
 		? true : false;=0A=
 		arcmsr_report_ccb_state(acb, pCCB, error);=0A=
 	}=0A=
+	spin_unlock_irqrestore(&acb->doneq_lock, flags);=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
@@ -3805,7 +4130,7 @@ arcmsr_iop_confirm(struct AdapterControl=0A=
 		struct MessageUnit_D *reg =3D=0A=
 			(struct MessageUnit_D *)acb->pmuD;=0A=
 		reg->postq_index =3D 0;=0A=
-		reg->doneq_index =3D 0x40FF;=0A=
+		reg->doneq_index =3D 0;=0A=
 		rwbuffer =3D reg->msgcode_rwbuffer;=0A=
 		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);=0A=
 		writel(cdb_phyaddr_hi32, rwbuffer++);=0A=
@@ -3849,7 +4174,8 @@ arcmsr_wait_firmware_ready(struct Adapte=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		struct MessageUnit_C *reg =3D=0A=
+			(struct MessageUnit_C *)acb->pmuC;=0A=
 		do {=0A=
 			firmware_state =3D readl(&reg->outbound_msgaddr1);=0A=
 		} while ((firmware_state &=0A=

------=_NextPart_000_000C_01CE0488.600903F0--

