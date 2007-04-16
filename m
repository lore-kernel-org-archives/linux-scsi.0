From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [KJ][PATCH]dpt_i2o.c-kzalloc
Date: Mon, 16 Apr 2007 10:38:04 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0181671A@otce2k301.adaptec.com>
References: <1176703538.13066.11.camel@wriver-t81fb058.linuxcoe>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:51226 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030686AbXDPOiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2007 10:38:07 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1176703538.13066.11.camel@wriver-t81fb058.linuxcoe>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vignesh.babu@wipro.com
Cc: linux-scsi@vger.kernel.org, kernel-janitors@lists.osdl.org, Markus Lidel <Markus.Lidel@shadowconnect.com>

Thanks Vignesh. Looks fine to me except I would prefer to drop the first
fragment and update it another day, another cleanup. The 64 bit updates
may need to be pushed now that the i2o_block driver appears to have no
maintainer (Markus pulled, I have not checked with him why).

The Adaptec version of these dpt_i2o.c sources, uses
pci_alloc_consistent for the first fragment:

 	u8* status;
+	dma_addr_t addr;
+	u64 addr64;
 	u32 m = EMPTY_QUEUE
. . .
 
-	status = kmalloc(4, GFP_KERNEL|ADDR32);
+	status = pci_alloc_consistent(pHba->pDev, 4, &addr);
 	if(status == NULL) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_ERR"IOP reset failed - no free memory.\n");
 		return -ENOMEM;
 	}
 	memset(status,0,4);
 
 	msg[0]=cpu_to_le32(EIGHT_WORD_MSG_SIZE|SGL_OFFSET_0);
 
msg[1]=cpu_to_le32(I2O_CMD_ADAPTER_RESET<<24|HOST_TID<<12|ADAPTER_TID);
 	msg[2]=0;
 	msg[3]=0;
 	msg[4]=0;
 	msg[5]=0;
-	msg[6]=virt_to_bus(status);
-	msg[7]=0;
+	addr64 = cpu_to_le64(addr);
+	msg[6]=(u32)addr64;
+	msg[7]=(u32)(addr64 >> 32);
 

Sincerely -- Mark Salyzyn
-----Original Message-----
From: vignesh.babu@wipro.com [mailto:vignesh.babu@wipro.com] 
Sent: Monday, April 16, 2007 2:06 AM
To: AACRAID
Cc: linux-scsi@vger.kernel.org; kernel-janitors@lists.osdl.org
Subject: [KJ][PATCH]dpt_i2o.c-kzalloc

Replacing kmalloc/memset combination with kzalloc.

Signed-off-by: vignesh babu <vignesh.babu@xxxxxxxxx>
---
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index cd36e81..2184fcb 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1311,13 +1311,12 @@ static s32 adpt_i2o_reset_hba(adpt_hba* pHba)
 		schedule_timeout_uninterruptible(1);
 	} while (m == EMPTY_QUEUE);
 
-	status = kmalloc(4, GFP_KERNEL|ADDR32);
+	status = kzalloc(4, GFP_KERNEL|ADDR32);
 	if(status == NULL) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_ERR"IOP reset failed - no free memory.\n");
 		return -ENOMEM;
 	}
-	memset(status,0,4);
 
 	msg[0]=EIGHT_WORD_MSG_SIZE|SGL_OFFSET_0;
 	msg[1]=I2O_CMD_ADAPTER_RESET<<24|HOST_TID<<12|ADAPTER_TID;
@@ -1507,21 +1506,19 @@ static int adpt_i2o_parse_lct(adpt_hba* pHba)
 					continue;
 				}
 				if(
pHba->channel[bus_no].device[scsi_id] == NULL){
-					pDev =  kmalloc(sizeof(struct
adpt_device),GFP_KERNEL);
+					pDev =  kzalloc(sizeof(struct
adpt_device),GFP_KERNEL);
 					if(pDev == NULL) {
 						return -ENOMEM;
 					}
 
pHba->channel[bus_no].device[scsi_id] = pDev;
-					memset(pDev,0,sizeof(struct
adpt_device));
 				} else {
 					for( pDev =
pHba->channel[bus_no].device[scsi_id];	
 							pDev->next_lun;
pDev = pDev->next_lun){
 					}
-					pDev->next_lun =
kmalloc(sizeof(struct adpt_device),GFP_KERNEL);
+					pDev->next_lun =
kzalloc(sizeof(struct adpt_device),GFP_KERNEL);
 					if(pDev->next_lun == NULL) {
 						return -ENOMEM;
 					}
-
memset(pDev->next_lun,0,sizeof(struct adpt_device));
 					pDev = pDev->next_lun;
 				}
 				pDev->tid = tid;
@@ -1670,12 +1667,11 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32
__user *arg)
 		reply_size = REPLY_FRAME_SIZE;
 	}
 	reply_size *= 4;
-	reply = kmalloc(REPLY_FRAME_SIZE*4, GFP_KERNEL);
+	reply = kzalloc(REPLY_FRAME_SIZE*4, GFP_KERNEL);
 	if(reply == NULL) {
 		printk(KERN_WARNING"%s: Could not allocate reply
buffer\n",pHba->name);
 		return -ENOMEM;
 	}
-	memset(reply,0,REPLY_FRAME_SIZE*4);
 	sg_offset = (msg[0]>>4)&0xf;
 	msg[2] = 0x40000000; // IOCTL context
 	msg[3] = (u32)reply;
@@ -2447,7 +2443,7 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 				}
 				pDev =
pHba->channel[bus_no].device[scsi_id];	
 				if( pDev == NULL){
-					pDev =  kmalloc(sizeof(struct
adpt_device),GFP_KERNEL);
+					pDev =  kzalloc(sizeof(struct
adpt_device),GFP_KERNEL);
 					if(pDev == NULL) {
 						return -ENOMEM;
 					}
@@ -2456,12 +2452,11 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 					while (pDev->next_lun) {
 						pDev = pDev->next_lun;
 					}
-					pDev = pDev->next_lun =
kmalloc(sizeof(struct adpt_device),GFP_KERNEL);
+					pDev = pDev->next_lun =
kzalloc(sizeof(struct adpt_device),GFP_KERNEL);
 					if(pDev == NULL) {
 						return -ENOMEM;
 					}
 				}
-				memset(pDev,0,sizeof(struct
adpt_device));
 				pDev->tid = d->lct_data.tid;
 				pDev->scsi_channel = bus_no;
 				pDev->scsi_id = scsi_id;

-- 
Regards,  
Vignesh Babu BM  
