From: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Subject: [PATCH 3/3] arcmsr: Fix bug of updating adapter firmware through ioctl(ARCHTTP) interface
Date: Mon, 26 Aug 2013 12:28:20 +0800
Message-ID: <60A4377E7BEE4B2EA7855F9701B34BF0@chingDT>
Reply-To: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_002F_01CEA257.BFE89BB0"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jejb@kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_002F_01CEA257.BFE89BB0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit

From: Ching <ching2048@areca.com.tw>

Fix bug of updating adapter firmware through ioctl(ARCHTTP) interface.
Signed-off-by: Ching <ching2048@areca.com.tw>
---
------=_NextPart_000_002F_01CEA257.BFE89BB0
Content-Type: application/octet-stream;
	name="patch3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch3"

diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c =
b/drivers/scsi/arcmsr/arcmsr_attr.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_attr.c	2012-11-29 19:35:16.000000000 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c	2013-07-16 02:31:38.000000000 =
+0800=0A=
@@ -86,6 +86,7 @@ arcmsr_sysfs_iop_message_read(struct fil=0A=
 			if ((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) >=3D 1032) {=0A=
 				memcpy(ptmpQbuffer, pQbuffer, 1032);=0A=
 				acb->rqbuf_firstindex +=3D 1032;=0A=
+				acb->rqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
 				allxfer_len =3D 1032;=0A=
 			} else {=0A=
 				if (((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) + =
acb->rqbuf_lastindex) > 1032) {=0A=
@@ -116,36 +117,10 @@ arcmsr_sysfs_iop_message_read(struct fil=0A=
 	}=0A=
 	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 		struct QBUFFER __iomem *prbuffer;=0A=
-		uint8_t __iomem *iop_data, *vaddr, *temp;=0A=
-			int32_t data_len_residual, data_len, rqbuf_lastindex;=0A=
-			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
-		rqbuf_lastindex =3D acb->rqbuf_lastindex;=0A=
+		acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
 		prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
-		iop_data =3D (uint8_t __iomem *)prbuffer->data;=0A=
-		data_len_residual =3D data_len =3D readl(&prbuffer->data_len);=0A=
-		if (data_len > 0) {=0A=
-			temp =3D vaddr =3D kmalloc(data_len, GFP_ATOMIC);=0A=
-			do {=0A=
-				memcpy(temp, iop_data, 4);=0A=
-				temp +=3D 4;=0A=
-				iop_data +=3D 4;=0A=
-				data_len_residual -=3D 4;=0A=
-			} while (data_len_residual > 0);=0A=
-			pQbuffer =3D &acb->rqbuffer[acb->rqbuf_lastindex];=0A=
-			temp =3D vaddr;=0A=
-			if ((rqbuf_lastindex + data_len) > ARCMSR_MAX_QBUFFER) {=0A=
-				memcpy(pQbuffer, temp, ARCMSR_MAX_QBUFFER - rqbuf_lastindex);=0A=
-				temp +=3D (ARCMSR_MAX_QBUFFER - rqbuf_lastindex);=0A=
-				rqbuf_lastindex =3D (rqbuf_lastindex + data_len) % =
ARCMSR_MAX_QBUFFER;=0A=
-				memcpy(&acb->rqbuffer[0], temp, rqbuf_lastindex);=0A=
-			} else {=0A=
-				memcpy(pQbuffer, temp, data_len);=0A=
-				rqbuf_lastindex =3D (rqbuf_lastindex + data_len) % =
ARCMSR_MAX_QBUFFER;=0A=
-			}=0A=
-			kfree(vaddr);=0A=
-		}=0A=
-		acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
-		arcmsr_iop_message_read(acb);=0A=
+		if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) =3D=3D 0)=0A=
+			acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
 	}=0A=
 	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
 	return (allxfer_len);=0A=
@@ -177,7 +152,7 @@ arcmsr_sysfs_iop_message_write(struct fi=0A=
 	wqbuf_lastindex =3D acb->wqbuf_lastindex;=0A=
 	wqbuf_firstindex =3D acb->wqbuf_firstindex;=0A=
 	if (wqbuf_lastindex !=3D wqbuf_firstindex) {=0A=
-		arcmsr_post_ioctldata2iop(acb);=0A=
+		arcmsr_write_ioctldata2iop(acb);=0A=
 		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 		return 0;	/*need retry*/=0A=
 	} else {=0A=
@@ -198,7 +173,7 @@ arcmsr_sysfs_iop_message_write(struct fi=0A=
 				ACB_F_MESSAGE_WQBUFFER_CLEARED) {=0A=
 				acb->acb_flags &=3D=0A=
 					~ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
-				arcmsr_post_ioctldata2iop(acb);=0A=
+				arcmsr_write_ioctldata2iop(acb);=0A=
 			}=0A=
 			spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 			return count;=0A=
@@ -226,10 +201,7 @@ arcmsr_sysfs_iop_message_clear(struct fi=0A=
 	if (!capable(CAP_SYS_ADMIN))=0A=
 		return -EACCES;=0A=
 =0A=
-	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
-		acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
-		arcmsr_iop_message_read(acb);=0A=
-	}=0A=
+	arcmsr_clear_iop2drv_rqueue_buffer(acb);=0A=
 	acb->acb_flags |=3D=0A=
 		(ACB_F_MESSAGE_WQBUFFER_CLEARED=0A=
 		| ACB_F_MESSAGE_RQBUFFER_CLEARED=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h	2013-08-26 19:25:02.000000000 +0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h	2013-08-26 19:23:50.000000000 +0800=0A=
@@ -51,7 +51,7 @@ struct device_attribute;=0A=
 #else=0A=
 	#define ARCMSR_MAX_FREECCB_NUM	320=0A=
 #endif=0A=
-#define ARCMSR_DRIVER_VERSION		"Driver Version 1.30.00.02 2013/05/15"=0A=
+#define ARCMSR_DRIVER_VERSION		"Driver Version 1.30.00.03 2013/08/26"=0A=
 #define ARCMSR_SCSI_INITIATOR_ID		255=0A=
 #define ARCMSR_MAX_XFER_SECTORS		512=0A=
 #define ARCMSR_MAX_XFER_SECTORS_B		4096=0A=
@@ -796,8 +796,10 @@ struct SENSE_DATA=0A=
 #define ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE	0x01=0A=
 #define ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE		0x1F=0A=
 =0A=
-extern void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *);=0A=
-extern void arcmsr_iop_message_read(struct AdapterControlBlock *);=0A=
+extern void arcmsr_write_ioctldata2iop(struct AdapterControlBlock *);=0A=
+extern uint32_t arcmsr_Read_iop_rqbuffer_data(struct =
AdapterControlBlock *,=0A=
+    struct QBUFFER __iomem *);=0A=
+extern void arcmsr_clear_iop2drv_rqueue_buffer(struct =
AdapterControlBlock *);=0A=
 extern struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct =
AdapterControlBlock *);=0A=
 extern struct device_attribute *arcmsr_host_attrs[];=0A=
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2013-05-16 04:20:04.000000000 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2013-08-26 19:01:40.000000000 =
+0800=0A=
@@ -70,7 +70,7 @@=0A=
 #include <scsi/scsi_transport.h>=0A=
 #include <scsi/scsicam.h>=0A=
 #include "arcmsr.h"=0A=
-MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");=0A=
+MODULE_AUTHOR("Nick Cheng, Ching Huang <support@areca.com.tw>");=0A=
 MODULE_DESCRIPTION("Areca SAS,SATA RAID Controller Driver");=0A=
 MODULE_LICENSE("Dual BSD/GPL");=0A=
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);=0A=
@@ -291,6 +291,7 @@ static void arcmsr_unmap_pciregion(struc=0A=
 	}=0A=
 	case ACB_ADAPTER_TYPE_D: {=0A=
 		iounmap(acb->mem_base0);=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 }=0A=
@@ -543,19 +544,19 @@ arcmsr_flush_adapter_cache(struct Adapte=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		arcmsr_hbaA_flush_cache(acb);=0A=
-		}=0A=
 		break;=0A=
-=0A=
+		}=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		arcmsr_hbaB_flush_cache(acb);=0A=
-		}=0A=
 		break;=0A=
+		}=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		arcmsr_hbaC_flush_cache(acb);=0A=
-		}=0A=
 		break;=0A=
+		}=0A=
 	case ACB_ADAPTER_TYPE_D: {=0A=
 		arcmsr_hbaD_flush_cache(acb);=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 }=0A=
@@ -728,6 +729,7 @@ arcmsr_alloc_ccb_pool(struct AdapterCont=0A=
 			dma_coherent_handle =3D dma_coherent_handle=0A=
 				+ roundup_ccbsize;=0A=
 		}=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 	for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
@@ -1267,21 +1269,23 @@ arcmsr_abort_allcmd(struct AdapterContro=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		rtnval =3D arcmsr_hbaA_abort_allcmd(acb);=0A=
-		}=0A=
 		break;=0A=
+		}=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		rtnval =3D arcmsr_hbaB_abort_allcmd(acb);=0A=
-		}=0A=
 		break;=0A=
+		}=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		rtnval =3D arcmsr_hbaC_abort_allcmd(acb);=0A=
-		}=0A=
 		break;=0A=
+		}=0A=
+=0A=
 	case ACB_ADAPTER_TYPE_D: {=0A=
 		rtnval =3D arcmsr_hbaD_abort_allcmd(acb);=0A=
-	}=0A=
+		break;=0A=
+		}=0A=
 	}=0A=
 	return rtnval;=0A=
 }=0A=
@@ -1696,9 +1700,8 @@ arcmsr_enable_outbound_ints(struct Adapt=0A=
 		writel(mask, &reg->outbound_intmask);=0A=
 		acb->outbound_int_enable =3D ~(intmask_org & mask) &=0A=
 			0x000000ff;=0A=
-		}=0A=
 		break;=0A=
-=0A=
+		}=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 		mask =3D intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK |=0A=
@@ -1708,8 +1711,8 @@ arcmsr_enable_outbound_ints(struct Adapt=0A=
 		writel(mask, reg->iop2drv_doorbell_mask);=0A=
 		acb->outbound_int_enable =3D (intmask_org | mask) &=0A=
 			0x0000000f;=0A=
-		}=0A=
 		break;=0A=
+		}=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
 		mask =3D ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |=0A=
@@ -1718,12 +1721,13 @@ arcmsr_enable_outbound_ints(struct Adapt=0A=
 		writel(intmask_org & mask, &reg->host_int_mask);=0A=
 		acb->outbound_int_enable =3D ~(intmask_org & mask) &=0A=
 			0x0000000f;=0A=
-		}=0A=
 		break;=0A=
+		}=0A=
 	case ACB_ADAPTER_TYPE_D: {=0A=
 		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
 		mask =3D ARCMSR_ARC1214_ALL_INT_ENABLE;=0A=
 		writel(intmask_org | mask, reg->pcief0_int_enable);=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 }=0A=
@@ -1863,7 +1867,7 @@ arcmsr_post_ccb(struct AdapterControlBlo=0A=
 		pinbound_srb =3D (struct InBound_SRB *)&pmu->post_qbuffer[postq_index =
& 0xFF];=0A=
 		pinbound_srb->addressHigh =3D dma_addr_hi32(cdb_phyaddr);=0A=
 		pinbound_srb->addressLow =3D dma_addr_lo32(cdb_phyaddr);=0A=
-		pinbound_srb->length =3D arccdbsize / 4;=0A=
+		pinbound_srb->length =3D arccdbsize >> 2;=0A=
 		arcmsr_cdb->msgContext =3D dma_addr_lo32(cdb_phyaddr);=0A=
 		if (postq_index & 0x4000) {=0A=
 			index_stripped =3D postq_index & 0xFF;=0A=
@@ -1878,6 +1882,7 @@ arcmsr_post_ccb(struct AdapterControlBlo=0A=
 		}=0A=
 		writel(postq_index, pmu->inboundlist_write_pointer);=0A=
 		spin_unlock_irqrestore(&acb->postq_lock, flags);=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 }=0A=
@@ -1921,7 +1926,6 @@ arcmsr_hbaC_stop_bgrb(struct AdapterCont=0A=
 		"background rebulid' timeout\n"=0A=
 		, pACB->host->host_no);=0A=
 	}=0A=
-	return;=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -1938,7 +1942,6 @@ arcmsr_hbaD_stop_bgrb(struct AdapterCont=0A=
 		"rebulid' timeout\n"=0A=
 		, pACB->host->host_no);=0A=
 	}=0A=
-	return;=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -2124,193 +2127,174 @@ struct QBUFFER __iomem=0A=
 	return pqbuffer;=0A=
 }=0A=
 =0A=
+static uint32_t=0A=
+arcmsr_Read_iop_rqbuffer_in_DWORD(struct AdapterControlBlock *acb,=0A=
+	struct QBUFFER __iomem *prbuffer) {=0A=
+=0A=
+	uint8_t *pQbuffer;=0A=
+	uint8_t *buf1 =3D 0;=0A=
+	uint32_t __iomem *iop_data;=0A=
+	uint32_t iop_len, data_len, *buf2 =3D 0;=0A=
+=0A=
+	iop_data =3D (uint32_t *)prbuffer->data;=0A=
+	iop_len =3D readl(&prbuffer->data_len);=0A=
+	if ( iop_len > 0 ) {=0A=
+		buf1 =3D kmalloc(128, GFP_ATOMIC);=0A=
+		buf2 =3D (uint32_t *)buf1;=0A=
+		if( buf1 =3D=3D NULL)=0A=
+			return (0);=0A=
+		data_len =3D iop_len;=0A=
+		while (data_len >=3D 4) {=0A=
+			*buf2++ =3D *iop_data++;=0A=
+			data_len -=3D 4;=0A=
+		}=0A=
+		if(data_len)=0A=
+			*buf2 =3D *iop_data;=0A=
+		buf2 =3D (uint32_t *)buf1;=0A=
+	}=0A=
+	while (iop_len > 0) {=0A=
+		pQbuffer =3D &acb->rqbuffer[acb->rqbuf_lastindex];=0A=
+		*pQbuffer =3D *buf1;=0A=
+		acb->rqbuf_lastindex++;=0A=
+		/* if last, index number set it to 0 */=0A=
+		acb->rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+		buf1++;=0A=
+		iop_len--;=0A=
+	}=0A=
+	if (buf2)=0A=
+		kfree( (uint8_t *)buf2);=0A=
+	/* let IOP know data has been read */=0A=
+	arcmsr_iop_message_read(acb);=0A=
+	return (1);=0A=
+}=0A=
+=0A=
+uint32_t=0A=
+arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *acb,=0A=
+    struct QBUFFER __iomem *prbuffer) {=0A=
+=0A=
+	uint8_t *pQbuffer;=0A=
+	uint8_t __iomem *iop_data;=0A=
+	uint32_t iop_len;=0A=
+=0A=
+	if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D)) {=0A=
+		return(arcmsr_Read_iop_rqbuffer_in_DWORD(acb, prbuffer));=0A=
+	}=0A=
+	iop_data =3D (uint8_t *)prbuffer->data;=0A=
+	iop_len =3D readl(&prbuffer->data_len);=0A=
+	while (iop_len > 0) {=0A=
+		pQbuffer =3D &acb->rqbuffer[acb->rqbuf_lastindex];=0A=
+		*pQbuffer =3D *iop_data;=0A=
+		acb->rqbuf_lastindex++;=0A=
+		acb->rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+		iop_data++;=0A=
+		iop_len--;=0A=
+	}=0A=
+	arcmsr_iop_message_read(acb);=0A=
+	return (1);=0A=
+}=0A=
+=0A=
 void=0A=
 arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	uint8_t __iomem *iop_data, *pQbuffer, *vaddr, *temp;=0A=
-	int32_t buf_empty_len, data_len, data_len_residual;=0A=
-	uint32_t rqbuf_firstindex, rqbuf_lastindex;=0A=
 	unsigned long flags;=0A=
 	struct QBUFFER __iomem  *prbuffer;=0A=
+	int32_t buf_empty_len;=0A=
+=0A=
 	spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
-	rqbuf_lastindex =3D acb->rqbuf_lastindex;=0A=
-	rqbuf_firstindex =3D acb->rqbuf_firstindex;=0A=
 	prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
-	iop_data =3D (uint8_t __iomem *)prbuffer->data;=0A=
-	data_len_residual =3D data_len =3D readl(&prbuffer->data_len);=0A=
-	buf_empty_len =3D (rqbuf_firstindex - rqbuf_lastindex - 1) &=0A=
-		(ARCMSR_MAX_QBUFFER - 1);=0A=
-	if (buf_empty_len >=3D data_len) {=0A=
-		if (data_len > 0) {=0A=
-			temp =3D vaddr =3D kmalloc(data_len, GFP_ATOMIC);=0A=
-			if (!vaddr) {=0A=
-				goto leave;=0A=
-			}=0A=
-			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
-			while (data_len_residual >=3D 4) {=0A=
-				memcpy(temp, iop_data, 4);=0A=
-				temp +=3D 4;=0A=
-				iop_data +=3D 4;=0A=
-				data_len_residual -=3D 4;=0A=
-			}=0A=
-			if ((data_len_residual > 0) &&=0A=
-			(data_len_residual < 4)) {=0A=
-				memcpy(temp, iop_data, data_len_residual);=0A=
-			}=0A=
-			pQbuffer =3D &acb->rqbuffer[rqbuf_lastindex];=0A=
-			temp =3D vaddr;=0A=
-			if ((rqbuf_lastindex + data_len) >=0A=
-			ARCMSR_MAX_QBUFFER) {=0A=
-				memcpy(pQbuffer, temp,=0A=
-				ARCMSR_MAX_QBUFFER - rqbuf_lastindex);=0A=
-				temp +=3D (ARCMSR_MAX_QBUFFER -=0A=
-				rqbuf_lastindex);=0A=
-				rqbuf_lastindex =3D (rqbuf_lastindex + data_len)=0A=
-				% ARCMSR_MAX_QBUFFER;=0A=
-				memcpy(&acb->rqbuffer[0], temp,=0A=
-				rqbuf_lastindex);=0A=
-			} else {=0A=
-				memcpy(pQbuffer, temp, data_len);=0A=
-				rqbuf_lastindex =3D (rqbuf_lastindex + data_len)=0A=
-				% ARCMSR_MAX_QBUFFER;=0A=
-			}=0A=
-			kfree(vaddr);=0A=
-			acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
-			arcmsr_iop_message_read(acb);=0A=
-		}=0A=
+	buf_empty_len =3D (acb->rqbuf_lastindex - acb->rqbuf_firstindex -1) &=0A=
+		(ARCMSR_MAX_QBUFFER -1);=0A=
+	if (buf_empty_len >=3D prbuffer->data_len) {=0A=
+		if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) =3D=3D 0)=0A=
+			acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
 	} else {=0A=
 		acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
 	}=0A=
-	leave:=0A=
 	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
 }=0A=
 =0A=
-void=0A=
-arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_write_ioctldata2iop_in_DWORD(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	unsigned long flags;=0A=
-	spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
-	acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_READED;=0A=
-	if (acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) {=0A=
-		uint8_t *pQbuffer;=0A=
-		struct QBUFFER __iomem *pwbuffer;=0A=
-		uint8_t __iomem *iop_data;=0A=
-		int32_t allxfer_len =3D 0;=0A=
+	uint8_t *pQbuffer;=0A=
+	struct QBUFFER __iomem *pwbuffer;=0A=
+	uint8_t *buf1 =3D 0;=0A=
+	uint32_t __iomem *iop_data;=0A=
+	uint32_t allxfer_len =3D 0, data_len, *buf2 =3D 0;=0A=
+	=0A=
+	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {=0A=
+		buf1 =3D kmalloc(128, GFP_ATOMIC);=0A=
+		buf2 =3D (uint32_t *)buf1;=0A=
+		if( buf1 =3D=3D NULL)=0A=
+			return;=0A=
 =0A=
 		acb->acb_flags &=3D (~ACB_F_MESSAGE_WQBUFFER_READED);=0A=
 		pwbuffer =3D arcmsr_get_iop_wqbuffer(acb);=0A=
-		iop_data =3D (uint8_t __iomem *)pwbuffer->data;=0A=
-		if (acb->wqbuf_firstindex > acb->wqbuf_lastindex) {=0A=
-			if ((ARCMSR_MAX_QBUFFER - acb->wqbuf_firstindex) >=3D 4) {=0A=
-				do {=0A=
-					pQbuffer =3D=0A=
-					&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
-					if (acb->wqbuf_firstindex + 4=0A=
-					> ARCMSR_MAX_QBUFFER) {=0A=
-						memcpy(iop_data, pQbuffer,=0A=
-						ARCMSR_MAX_QBUFFER=0A=
-						- acb->wqbuf_firstindex);=0A=
-						iop_data +=3D ARCMSR_MAX_QBUFFER=0A=
-						- acb->wqbuf_firstindex;=0A=
-						acb->wqbuf_firstindex +=3D 4;=0A=
-						acb->wqbuf_firstindex %=3D=0A=
-						ARCMSR_MAX_QBUFFER;=0A=
-						memcpy(iop_data,=0A=
-						&acb->wqbuffer[0],=0A=
-						acb->wqbuf_firstindex);=0A=
-						iop_data +=3D=0A=
-						acb->wqbuf_firstindex;=0A=
-					} else {=0A=
-						if ((acb->wqbuf_lastindex=0A=
-						- acb->wqbuf_firstindex) > 4) {=0A=
-							memcpy(iop_data,=0A=
-							pQbuffer, 4);=0A=
-							acb->wqbuf_firstindex=0A=
-							+=3D 4;=0A=
-							acb->wqbuf_firstindex=0A=
-							%=3D ARCMSR_MAX_QBUFFER;=0A=
-							iop_data +=3D 4;=0A=
-						} else {=0A=
-							memcpy(iop_data, pQbuffer,=0A=
-							acb->wqbuf_lastindex=0A=
-							- acb->wqbuf_firstindex);=0A=
-							allxfer_len +=3D=0A=
-							acb->wqbuf_lastindex -=0A=
-							acb->wqbuf_firstindex;=0A=
-							acb->wqbuf_firstindex =3D=0A=
-							acb->wqbuf_lastindex;=0A=
-							break;=0A=
-						}=0A=
-					}=0A=
-					allxfer_len +=3D 4;=0A=
-				} while ((acb->wqbuf_firstindex !=3D=0A=
-				acb->wqbuf_lastindex) && (allxfer_len < 124));=0A=
-			} else {=0A=
-				pQbuffer =3D=0A=
-				&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
-				memcpy(iop_data, pQbuffer, ARCMSR_MAX_QBUFFER=0A=
-				- acb->wqbuf_firstindex);=0A=
-				iop_data +=3D ARCMSR_MAX_QBUFFER=0A=
-				- acb->wqbuf_firstindex;=0A=
-				allxfer_len =3D ARCMSR_MAX_QBUFFER=0A=
-				- acb->wqbuf_firstindex;=0A=
-				acb->wqbuf_firstindex =3D 0;=0A=
-				do {=0A=
-					pQbuffer =3D=0A=
-					&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
-					if ((acb->wqbuf_lastindex -=0A=
-					acb->wqbuf_firstindex) > 4) {=0A=
-						memcpy(iop_data, pQbuffer, 4);=0A=
-						acb->wqbuf_firstindex +=3D 4;=0A=
-						acb->wqbuf_firstindex %=3D=0A=
-						ARCMSR_MAX_QBUFFER;=0A=
-						iop_data +=3D 4;=0A=
-					} else {=0A=
-						memcpy(iop_data, pQbuffer,=0A=
-						acb->wqbuf_lastindex -=0A=
-						acb->wqbuf_firstindex);=0A=
-						allxfer_len +=3D=0A=
-						acb->wqbuf_lastindex=0A=
-						- acb->wqbuf_firstindex;=0A=
-						acb->wqbuf_firstindex =3D=0A=
-						acb->wqbuf_lastindex;=0A=
-						break;=0A=
-					}=0A=
-					allxfer_len +=3D 4;=0A=
-				} while ((acb->wqbuf_firstindex !=3D=0A=
-				acb->wqbuf_lastindex) && (allxfer_len < 124));=0A=
-			}=0A=
-		} else {=0A=
-			do {=0A=
-				pQbuffer =3D=0A=
-				&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
-				if ((acb->wqbuf_lastindex -=0A=
-				acb->wqbuf_firstindex) > 4) {=0A=
-					memcpy(iop_data, pQbuffer, 4);=0A=
-					acb->wqbuf_firstindex +=3D 4;=0A=
-					acb->wqbuf_firstindex %=3D=0A=
-					ARCMSR_MAX_QBUFFER;=0A=
-					iop_data +=3D 4;=0A=
-				} else {=0A=
-					memcpy(iop_data, pQbuffer,=0A=
-					acb->wqbuf_lastindex -=0A=
-					acb->wqbuf_firstindex);=0A=
-					allxfer_len +=3D acb->wqbuf_lastindex=0A=
-					- acb->wqbuf_firstindex;=0A=
-					acb->wqbuf_firstindex =3D=0A=
-					acb->wqbuf_lastindex;=0A=
-					break;=0A=
-				}=0A=
-				allxfer_len +=3D 4;=0A=
-			} while ((acb->wqbuf_firstindex !=3D=0A=
-			acb->wqbuf_lastindex) && (allxfer_len < 124));=0A=
+		iop_data =3D (uint32_t *)pwbuffer->data;=0A=
+		while ((acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex)=0A=
+			&& (allxfer_len < 124)) {=0A=
+			pQbuffer =3D &acb->wqbuffer[acb->wqbuf_firstindex];=0A=
+			*buf1 =3D *pQbuffer;=0A=
+			acb->wqbuf_firstindex++;=0A=
+			acb->wqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+			buf1++;=0A=
+			allxfer_len++;=0A=
+		}=0A=
+		data_len =3D allxfer_len;=0A=
+		buf1 =3D (uint8_t *)buf2;=0A=
+		while (data_len >=3D 4) {=0A=
+			*iop_data++ =3D *buf2++;=0A=
+			data_len -=3D 4;=0A=
 		}=0A=
+		if (data_len)=0A=
+			*iop_data =3D *buf2;=0A=
 		writel(allxfer_len, &pwbuffer->data_len);=0A=
-		arcmsr_iop_message_wrote(acb);/*notice IOP the message has been =
written*/=0A=
+		kfree( buf1);=0A=
+		arcmsr_iop_message_wrote(acb);=0A=
 	}=0A=
-	if (acb->wqbuf_firstindex =3D=3D acb->wqbuf_lastindex) {=0A=
-		acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
+}=0A=
+=0A=
+void=0A=
+arcmsr_write_ioctldata2iop(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	uint8_t *pQbuffer;=0A=
+	struct QBUFFER __iomem *pwbuffer;=0A=
+	uint8_t __iomem *iop_data;=0A=
+	int32_t allxfer_len=3D0;=0A=
+	=0A=
+	if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D)) {=0A=
+		arcmsr_write_ioctldata2iop_in_DWORD(acb);=0A=
+		return;=0A=
 	}=0A=
+	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {=0A=
+		acb->acb_flags &=3D (~ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+		pwbuffer =3D arcmsr_get_iop_wqbuffer(acb);=0A=
+		iop_data =3D (uint8_t *)pwbuffer->data;=0A=
+		while ((acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) =0A=
+			&& (allxfer_len < 124)) {=0A=
+			pQbuffer =3D &acb->wqbuffer[acb->wqbuf_firstindex];=0A=
+			*iop_data =3D *pQbuffer;=0A=
+			acb->wqbuf_firstindex++;=0A=
+			acb->wqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+			iop_data++;=0A=
+			allxfer_len++;=0A=
+		}=0A=
+		writel(allxfer_len, &pwbuffer->data_len);=0A=
+		arcmsr_iop_message_wrote(acb);=0A=
+	}=0A=
+}=0A=
+=0A=
+void=0A=
+arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	unsigned long flags;=0A=
+=0A=
+	spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
+	acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_READED;=0A=
+	if (acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex)=0A=
+		arcmsr_write_ioctldata2iop(acb);=0A=
+	if (acb->wqbuf_firstindex =3D=3D acb->wqbuf_lastindex)=0A=
+		acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
 	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 }=0A=
 =0A=
@@ -2361,7 +2345,6 @@ arcmsr_hbaC_doorbell_isr(struct AdapterC=0A=
 	} while (outbound_doorbell & (ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK=0A=
 	| ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK=0A=
 	| ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE));=0A=
-	return;=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -2390,7 +2373,6 @@ arcmsr_hbaD_doorbell_isr(struct AdapterC=0A=
 	} while (outbound_doorbell & (ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK=0A=
 	| ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK=0A=
 	| ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE));=0A=
-	return;=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -2710,132 +2692,24 @@ arcmsr_iop_parking(struct AdapterControl=0A=
 }=0A=
 =0A=
 void=0A=
-arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)=0A=
+arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {=0A=
-		if (acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) {=0A=
-			uint8_t *pQbuffer;=0A=
-			uint8_t __iomem *iop_data;=0A=
-			int32_t allxfer_len =3D 0;=0A=
-			struct QBUFFER __iomem *pwbuffer;=0A=
-			acb->acb_flags &=3D (~ACB_F_MESSAGE_WQBUFFER_READED);=0A=
-			pwbuffer =3D arcmsr_get_iop_wqbuffer(acb);=0A=
-			iop_data =3D (uint8_t __iomem *)pwbuffer->data;=0A=
-			if (acb->wqbuf_firstindex > acb->wqbuf_lastindex) {=0A=
-				if ((ARCMSR_MAX_QBUFFER -=0A=
-					acb->wqbuf_firstindex) >=3D 4) {=0A=
-					do {=0A=
-						pQbuffer =3D=0A=
-						&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
-						if (acb->wqbuf_firstindex + 4 >=0A=
-						ARCMSR_MAX_QBUFFER) {=0A=
-							memcpy(iop_data, pQbuffer,=0A=
-							ARCMSR_MAX_QBUFFER - acb->wqbuf_firstindex);=0A=
-							iop_data +=3D ARCMSR_MAX_QBUFFER=0A=
-							- acb->wqbuf_firstindex;=0A=
-							acb->wqbuf_firstindex +=3D 4;=0A=
-							acb->wqbuf_firstindex %=3D=0A=
-							ARCMSR_MAX_QBUFFER;=0A=
-							memcpy(iop_data,=0A=
-							&acb->wqbuffer[0],=0A=
-							acb->wqbuf_firstindex);=0A=
-							iop_data +=3D=0A=
-							acb->wqbuf_firstindex;=0A=
-						} else {=0A=
-							if ((acb->wqbuf_lastindex -=0A=
-							acb->wqbuf_firstindex) > 4) {=0A=
-								memcpy(iop_data,=0A=
-								pQbuffer, 4);=0A=
-								acb->wqbuf_firstindex=0A=
-								+=3D 4;=0A=
-								acb->wqbuf_firstindex=0A=
-								%=3D ARCMSR_MAX_QBUFFER;=0A=
-								iop_data +=3D 4;=0A=
-							} else {=0A=
-								memcpy(iop_data,=0A=
-								pQbuffer,=0A=
-								acb->wqbuf_lastindex=0A=
-								- acb->wqbuf_firstindex);=0A=
-								allxfer_len +=3D=0A=
-								acb->wqbuf_lastindex=0A=
-								- acb->wqbuf_firstindex;=0A=
-								acb->wqbuf_firstindex=0A=
-								=3D acb->wqbuf_lastindex;=0A=
-								break;=0A=
-							}=0A=
-						}=0A=
-						allxfer_len +=3D 4;=0A=
-					} while ((acb->wqbuf_firstindex !=3D=0A=
-					acb->wqbuf_lastindex) &&=0A=
-					(allxfer_len < 124));=0A=
-				} else {=0A=
-					pQbuffer =3D=0A=
-					&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
-					memcpy(iop_data, pQbuffer,=0A=
-					ARCMSR_MAX_QBUFFER -=0A=
-					acb->wqbuf_firstindex);=0A=
-					iop_data +=3D ARCMSR_MAX_QBUFFER=0A=
-					- acb->wqbuf_firstindex;=0A=
-					allxfer_len =3D ARCMSR_MAX_QBUFFER=0A=
-					- acb->wqbuf_firstindex;=0A=
-					acb->wqbuf_firstindex =3D 0;=0A=
-					do {=0A=
-						pQbuffer =3D=0A=
-						&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
-						if ((acb->wqbuf_lastindex -=0A=
-						acb->wqbuf_firstindex) > 4) {=0A=
-							memcpy(iop_data,=0A=
-							pQbuffer, 4);=0A=
-							acb->wqbuf_firstindex=0A=
-							+=3D 4;=0A=
-							acb->wqbuf_firstindex=0A=
-							%=3D ARCMSR_MAX_QBUFFER;=0A=
-							iop_data +=3D 4;=0A=
-						} else {=0A=
-							memcpy(iop_data, pQbuffer,=0A=
-							acb->wqbuf_lastindex=0A=
-							- acb->wqbuf_firstindex);=0A=
-							allxfer_len +=3D=0A=
-							acb->wqbuf_lastindex=0A=
-							- acb->wqbuf_firstindex;=0A=
-							acb->wqbuf_firstindex =3D=0A=
-							acb->wqbuf_lastindex;=0A=
-							break;=0A=
-						}=0A=
-						allxfer_len +=3D 4;=0A=
-					} while ((acb->wqbuf_firstindex=0A=
-					!=3D acb->wqbuf_lastindex) &&=0A=
-					(allxfer_len < 124));=0A=
-				}=0A=
-			} else {=0A=
-				do {=0A=
-					pQbuffer =3D=0A=
-					&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
-					if ((acb->wqbuf_lastindex -=0A=
-					acb->wqbuf_firstindex) > 4) {=0A=
-						memcpy(iop_data,=0A=
-						pQbuffer, 4);=0A=
-						acb->wqbuf_firstindex=0A=
-						+=3D 4;=0A=
-						acb->wqbuf_firstindex=0A=
-						%=3D ARCMSR_MAX_QBUFFER;=0A=
-						iop_data +=3D 4;=0A=
-					} else {=0A=
-						memcpy(iop_data, pQbuffer,=0A=
-						acb->wqbuf_lastindex -=0A=
-						acb->wqbuf_firstindex);=0A=
-						allxfer_len +=3D acb->wqbuf_lastindex=0A=
-						- acb->wqbuf_firstindex;=0A=
-						acb->wqbuf_firstindex =3D=0A=
-						acb->wqbuf_lastindex;=0A=
-						break;=0A=
-					}=0A=
-					allxfer_len +=3D 4;=0A=
-				} while ((acb->wqbuf_firstindex !=3D=0A=
-				acb->wqbuf_lastindex) && (allxfer_len < 124));=0A=
-			}=0A=
-			writel(allxfer_len, &pwbuffer->data_len);=0A=
-			arcmsr_iop_message_wrote(acb);=0A=
+	uint32_t	i;=0A=
+=0A=
+	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
+		for (i=3D0; i < 15; i++) {=0A=
+			if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
+				acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
+				acb->rqbuf_firstindex =3D 0;=0A=
+				acb->rqbuf_lastindex =3D 0;=0A=
+				arcmsr_iop_message_read(acb);=0A=
+				mdelay(30);=0A=
+			} else if (acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex) {=0A=
+				acb->rqbuf_firstindex =3D 0;=0A=
+				acb->rqbuf_lastindex =3D 0;=0A=
+				mdelay(30);=0A=
+			} else =0A=
+				break;=0A=
 		}=0A=
 	}=0A=
 }=0A=
@@ -2889,6 +2763,7 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 					acb->rqbuf_firstindex) >=3D 1032) {=0A=
 					memcpy(ptmpQbuffer, pQbuffer, 1032);=0A=
 					acb->rqbuf_firstindex +=3D 1032;=0A=
+					acb->rqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
 					allxfer_len =3D 1032;=0A=
 				} else {=0A=
 					if (((ARCMSR_MAX_QBUFFER -=0A=
@@ -2941,58 +2816,16 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 				}=0A=
 			}=0A=
 		}=0A=
+		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);=0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 			struct QBUFFER __iomem *prbuffer;=0A=
-			uint8_t __iomem *iop_data, *vaddr, *temp;=0A=
-			uint32_t data_len_residual, data_len, rqbuf_lastindex;=0A=
-			rqbuf_lastindex =3D acb->rqbuf_lastindex;=0A=
+			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
 			prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
-			iop_data =3D (uint8_t __iomem *)prbuffer->data;=0A=
-			data_len_residual =3D data_len =3D readl(&prbuffer->data_len);=0A=
-			if (data_len > 0) {=0A=
-				temp =3D vaddr =3D kmalloc(data_len, GFP_ATOMIC);=0A=
-				if (!vaddr) {=0A=
-					goto leave;=0A=
-				}=0A=
-				acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
-				while (data_len_residual >=3D 4) {=0A=
-					memcpy(temp, iop_data, 4);=0A=
-					temp +=3D 4;=0A=
-					iop_data +=3D 4;=0A=
-					data_len_residual -=3D 4;=0A=
-				}=0A=
-				if ((data_len_residual > 0) &&=0A=
-				(data_len_residual < 4)) {=0A=
-					memcpy(temp, iop_data,=0A=
-					data_len_residual);=0A=
-				}=0A=
-				pQbuffer =3D=0A=
-				&acb->rqbuffer[acb->rqbuf_lastindex];=0A=
-				temp =3D vaddr;=0A=
-				if ((rqbuf_lastindex + data_len) >=0A=
-				ARCMSR_MAX_QBUFFER) {=0A=
-					memcpy(pQbuffer, temp,=0A=
-					ARCMSR_MAX_QBUFFER - rqbuf_lastindex);=0A=
-					temp +=3D (ARCMSR_MAX_QBUFFER -=0A=
-					rqbuf_lastindex);=0A=
-					rqbuf_lastindex =3D (rqbuf_lastindex +=0A=
-					data_len) % ARCMSR_MAX_QBUFFER;=0A=
-					memcpy(&acb->rqbuffer[0],=0A=
-					temp, rqbuf_lastindex);=0A=
-				} else {=0A=
-					memcpy(pQbuffer, temp, data_len);=0A=
-					rqbuf_lastindex =3D=0A=
-					(rqbuf_lastindex + data_len) %=0A=
-					ARCMSR_MAX_QBUFFER;=0A=
-				}=0A=
-				kfree(vaddr);=0A=
-				acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
-				arcmsr_iop_message_read(acb);=0A=
-			}=0A=
+			if(arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) =3D=3D 0)=0A=
+				acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
 		}=0A=
-		leave:=0A=
 		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
-		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);=0A=
+		kfree(ver_addr);=0A=
 		pcmdmessagefld->cmdmessage.Length =3D allxfer_len;=0A=
 		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
@@ -3001,7 +2834,6 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
-		kfree(ver_addr);=0A=
 		break;=0A=
 	}=0A=
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {=0A=
@@ -3014,13 +2846,6 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			goto message_out;=0A=
 		}=0A=
-		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
-			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		} else {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
-			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
-		}=0A=
 		ptmpuserbuffer =3D ver_addr;=0A=
 		user_len =3D pcmdmessagefld->cmdmessage.Length;=0A=
 		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer,=0A=
@@ -3031,7 +2856,7 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 		if (wqbuf_lastindex !=3D wqbuf_firstindex) {=0A=
 			struct SENSE_DATA *sensebuffer =3D=0A=
 			(struct SENSE_DATA *)cmd->sense_buffer;=0A=
-			arcmsr_post_ioctldata2iop(acb);=0A=
+			arcmsr_write_ioctldata2iop(acb);=0A=
 			/* has error report sensedata */=0A=
 			sensebuffer->ErrorCode =3D SCSI_SENSE_CURRENT_ERRORS;=0A=
 			sensebuffer->SenseKey =3D ILLEGAL_REQUEST;=0A=
@@ -3068,7 +2893,7 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 				ACB_F_MESSAGE_WQBUFFER_CLEARED) {=0A=
 					acb->acb_flags &=3D=0A=
 					~ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
-					arcmsr_post_ioctldata2iop(acb);=0A=
+					arcmsr_write_ioctldata2iop(acb);=0A=
 				}=0A=
 			} else {=0A=
 				struct SENSE_DATA *sensebuffer =3D=0A=
@@ -3085,16 +2910,20 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 		}=0A=
 		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 		kfree(ver_addr);=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
+		}=0A=
 		break;=0A=
 	}=0A=
 	case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {=0A=
 		uint8_t *pQbuffer =3D acb->rqbuffer;=0A=
 =0A=
+		arcmsr_clear_iop2drv_rqueue_buffer(acb);=0A=
 		spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
-		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
-			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
-			arcmsr_iop_message_read(acb);=0A=
-		}=0A=
 		acb->acb_flags |=3D ACB_F_MESSAGE_RQBUFFER_CLEARED;=0A=
 		acb->rqbuf_firstindex =3D 0;=0A=
 		acb->rqbuf_lastindex =3D 0;=0A=
@@ -3111,32 +2940,25 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 	}=0A=
 	case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {=0A=
 		uint8_t *pQbuffer =3D acb->wqbuffer;=0A=
-		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
-			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		} else {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
-			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
-		}=0A=
 		spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
-		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
-			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
-			arcmsr_iop_message_read(acb);=0A=
-		}=0A=
 		acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
 		ACB_F_MESSAGE_WQBUFFER_READED);=0A=
 		acb->wqbuf_firstindex =3D 0;=0A=
 		acb->wqbuf_lastindex =3D 0;=0A=
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);=0A=
 		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
+		}=0A=
 		break;=0A=
 	}=0A=
 	case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {=0A=
 		uint8_t *pQbuffer;=0A=
-		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
-			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
-			arcmsr_iop_message_read(acb);=0A=
-		}=0A=
+		arcmsr_clear_iop2drv_rqueue_buffer(acb);=0A=
 		spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
 		acb->acb_flags |=3D ACB_F_MESSAGE_RQBUFFER_CLEARED;=0A=
 		acb->rqbuf_firstindex =3D 0;=0A=
@@ -3376,11 +3198,10 @@ arcmsr_hbaA_get_config(struct AdapterCon=0A=
 		iop_device_map++;=0A=
 		count--;=0A=
 	}=0A=
-	pr_notice("Areca RAID Controller%d: F/W %s "=0A=
-		"& Model %s\n",=0A=
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",=0A=
 		acb->host->host_no,=0A=
-		acb->firm_version,=0A=
-		acb->firm_model);=0A=
+		acb->firm_model,=0A=
+		acb->firm_version);=0A=
 	acb->signature =3D readl(&reg->message_rwbuffer[0]);=0A=
 	acb->firm_request_len =3D readl(&reg->message_rwbuffer[1]);=0A=
 	acb->firm_numbers_queue =3D readl(&reg->message_rwbuffer[2]);=0A=
@@ -3472,11 +3293,10 @@ arcmsr_hbaB_get_config(struct AdapterCon=0A=
 		count--;=0A=
 	}=0A=
 =0A=
-	pr_notice("Areca RAID Controller%d: "=0A=
-		"F/W %s & Model %s\n",=0A=
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",=0A=
 		acb->host->host_no,=0A=
-		acb->firm_version,=0A=
-		acb->firm_model);=0A=
+		acb->firm_model,=0A=
+		acb->firm_version);=0A=
 =0A=
 	acb->signature =3D readl(&reg->message_rwbuffer[1]);=0A=
 	/*firm_signature,1,00-03*/=0A=
@@ -3543,11 +3363,10 @@ arcmsr_hbaC_get_config(struct AdapterCon=0A=
 		iop_firm_version++;=0A=
 		count--;=0A=
 	}=0A=
-	pr_notice("Areca RAID Controller%d: F/W %s & "=0A=
-	"Model %s\n",=0A=
-	pACB->host->host_no,=0A=
-	pACB->firm_version,=0A=
-	pACB->firm_model);=0A=
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",=0A=
+		pACB->host->host_no,=0A=
+		pACB->firm_model,=0A=
+		pACB->firm_version);=0A=
 	pACB->firm_request_len =3D readl(&reg->msgcode_rwbuffer[1]);=0A=
 	pACB->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[2]);=0A=
 	pACB->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[3]);=0A=
@@ -3686,8 +3505,10 @@ arcmsr_hbaD_get_config(struct AdapterCon=0A=
 	acb->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[5]);=0A=
 	/*firm_hd_channels,4,16-19*/=0A=
 	acb->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);=0A=
-	pr_notice("Areca RAID Controller%d: F/W %s & Model %s\n",=0A=
-	acb->host->host_no, acb->firm_version, acb->firm_model);=0A=
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",=0A=
+		acb->host->host_no,=0A=
+		acb->firm_model,=0A=
+		acb->firm_version);=0A=
 	return true;=0A=
 }=0A=
 =0A=
@@ -4026,6 +3847,7 @@ arcmsr_polling_ccbdone(struct AdapterCon=0A=
 	}=0A=
 	case ACB_ADAPTER_TYPE_D: {=0A=
 		rtn =3D arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 	return rtn;=0A=
@@ -4227,7 +4049,6 @@ arcmsr_hbaA_request_device_map(struct Ad=0A=
 		mod_timer(&acb->eternal_timer, jiffies +=0A=
 			msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
-	return;=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -4258,7 +4079,6 @@ arcmsr_hbaB_request_device_map(struct Ad=0A=
 		mod_timer(&acb->eternal_timer, jiffies +=0A=
 			msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
-	return;=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -4291,7 +4111,6 @@ arcmsr_hbaC_request_device_map(struct Ad=0A=
 		mod_timer(&acb->eternal_timer, jiffies +=0A=
 			msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
-	return;=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -4321,7 +4140,6 @@ arcmsr_hbaD_request_device_map(struct Ad=0A=
 		mod_timer(&acb->eternal_timer, jiffies +=0A=
 			msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
-	return;=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -4344,6 +4162,7 @@ arcmsr_request_device_map(unsigned long=0A=
 		}=0A=
 		case ACB_ADAPTER_TYPE_D: {=0A=
 			arcmsr_hbaD_request_device_map(acb);=0A=
+			break;=0A=
 		}=0A=
 	}=0A=
 }=0A=
@@ -4451,23 +4270,45 @@ arcmsr_clear_doorbell_queue_buffer(struc=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		struct MessageUnit_C *reg =3D=0A=
 			(struct MessageUnit_C *)acb->pmuC;=0A=
-		uint32_t outbound_doorbell;=0A=
+		uint32_t outbound_doorbell, i;=0A=
 		/* empty doorbell Qbuffer if door bell ringed */=0A=
 		outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
 		writel(outbound_doorbell, &reg->outbound_doorbell_clear);=0A=
 		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,=0A=
 			&reg->inbound_doorbell);=0A=
+		for (i=3D0; i < 200; i++) {=0A=
+			msleep(10);=0A=
+			outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+			if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {=0A=
+				writel(outbound_doorbell,=0A=
+				&reg->outbound_doorbell_clear);=0A=
+				writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,=0A=
+				&reg->inbound_doorbell);=0A=
+			} else=0A=
+				break;=0A=
+		}=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_D: {=0A=
 		struct MessageUnit_D __iomem *reg =3D=0A=
 			(struct MessageUnit_D *)acb->pmuD;=0A=
-		uint32_t outbound_doorbell;=0A=
+		uint32_t outbound_doorbell, i;=0A=
 		/* empty doorbell Qbuffer if door bell ringed */=0A=
 		outbound_doorbell =3D readl(reg->outbound_doorbell);=0A=
 		writel(outbound_doorbell, reg->outbound_doorbell);=0A=
 		writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,=0A=
 			reg->inbound_doorbell);=0A=
+		for (i=3D0; i < 200; i++) {=0A=
+			msleep(10);=0A=
+			outbound_doorbell =3D readl(reg->outbound_doorbell);=0A=
+			if (outbound_doorbell & ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK) {=0A=
+				writel(outbound_doorbell,=0A=
+				reg->outbound_doorbell);=0A=
+				writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,=0A=
+				reg->inbound_doorbell);=0A=
+			} else=0A=
+				break;=0A=
+		}=0A=
 		break;=0A=
 	}=0A=
 	}=0A=
@@ -4901,12 +4742,13 @@ static const char=0A=
 		type =3D "SAS";=0A=
 		break;=0A=
 	default:=0A=
-		type =3D "X-TYPE";=0A=
+		type =3D "unknown";=0A=
+		raid6 =3D	0;=0A=
 		break;=0A=
 	}=0A=
-	sprintf(buf, "Areca %s Host Adapter RAID Controller%s\n %s",=0A=
-			type, raid6 ? "( RAID6 capable)" : "",=0A=
-			ARCMSR_DRIVER_VERSION);=0A=
+	sprintf(buf, "Areca %s Host Adapter RAID Controller%s\narcmsr "=0A=
+		"version %s\n",type, raid6 ? "( RAID6 capable)" : "",=0A=
+		ARCMSR_DRIVER_VERSION);=0A=
 	return buf;=0A=
 }=0A=
 =0A=

------=_NextPart_000_002F_01CEA257.BFE89BB0--
