From: ching <ching2048@areca.com.tw>
Subject: [PATCH v1.0 7/16] arcmsr: revise message_isr_bh_fn to delete
 duplicate code
Date: Wed, 30 Apr 2014 19:02:37 +0800
Message-ID: <1398855757.6930.25.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:36223 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbaD3LCp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2014 07:02:45 -0400
Received: by mail-ve0-f170.google.com with SMTP id sa20so1900528veb.15
        for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2014 04:02:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

Revise message_isr_bh_fn to remove the duplicate code for each adapter type.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:10:02.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:10:46.000000000 +0800
@@ -511,119 +511,65 @@ static int arcmsr_alloc_ccb_pool(struct 
 
 static void arcmsr_message_isr_bh_fn(struct work_struct *work) 
 {
-	struct AdapterControlBlock *acb = container_of(work,struct AdapterControlBlock, arcmsr_do_message_isr_bh);
-	switch (acb->adapter_type) {
-		case ACB_ADAPTER_TYPE_A: {
+	struct AdapterControlBlock *acb = container_of(work,
+		struct AdapterControlBlock, arcmsr_do_message_isr_bh);
+	char *acb_dev_map = (char *)acb->device_map;
+	uint32_t __iomem *signature = NULL;
+	char __iomem *devicemap = NULL;
+	int target, lun;
+	struct scsi_device *psdev;
+	char diff, temp;
 
-			struct MessageUnit_A __iomem *reg  = acb->pmuA;
-			char *acb_dev_map = (char *)acb->device_map;
-			uint32_t __iomem *signature = (uint32_t __iomem*) (&reg->message_rwbuffer[0]);
-			char __iomem *devicemap = (char __iomem*) (&reg->message_rwbuffer[21]);
-			int target, lun;
-			struct scsi_device *psdev;
-			char diff;
-
-			atomic_inc(&acb->rq_map_token);
-			if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
-				for(target = 0; target < ARCMSR_MAX_TARGETID -1; target++) {
-					diff = (*acb_dev_map)^readb(devicemap);
-					if (diff != 0) {
-						char temp;
-						*acb_dev_map = readb(devicemap);
-						temp =*acb_dev_map;
-						for(lun = 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {
-							if((temp & 0x01)==1 && (diff & 0x01) == 1) {	
-								scsi_add_device(acb->host, 0, target, lun);
-							}else if((temp & 0x01) == 0 && (diff & 0x01) == 1) {
-								psdev = scsi_device_lookup(acb->host, 0, target, lun);
-								if (psdev != NULL ) {
-									scsi_remove_device(psdev);
-									scsi_device_put(psdev);
-								}
-							}
-							temp >>= 1;
-							diff >>= 1;
-						}
-					}
-					devicemap++;
-					acb_dev_map++;
-				}
-			}
-			break;
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		struct MessageUnit_A __iomem *reg  = acb->pmuA;
+		signature = (uint32_t __iomem *)(&reg->message_rwbuffer[0]);
+		devicemap = (char __iomem *)(&reg->message_rwbuffer[21]);
+		break;
 		}
-
-		case ACB_ADAPTER_TYPE_B: {
-			struct MessageUnit_B *reg  = acb->pmuB;
-			char *acb_dev_map = (char *)acb->device_map;
-			uint32_t __iomem *signature = (uint32_t __iomem*)(&reg->message_rwbuffer[0]);
-			char __iomem *devicemap = (char __iomem*)(&reg->message_rwbuffer[21]);
-			int target, lun;
-			struct scsi_device *psdev;
-			char diff;
-
-			atomic_inc(&acb->rq_map_token);
-			if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
-				for(target = 0; target < ARCMSR_MAX_TARGETID -1; target++) {
-					diff = (*acb_dev_map)^readb(devicemap);
-					if (diff != 0) {
-						char temp;
-						*acb_dev_map = readb(devicemap);
-						temp =*acb_dev_map;
-						for(lun = 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {
-							if((temp & 0x01)==1 && (diff & 0x01) == 1) {	
-								scsi_add_device(acb->host, 0, target, lun);
-							}else if((temp & 0x01) == 0 && (diff & 0x01) == 1) {
-								psdev = scsi_device_lookup(acb->host, 0, target, lun);
-								if (psdev != NULL ) {
-									scsi_remove_device(psdev);
-									scsi_device_put(psdev);
-								}
-							}
-							temp >>= 1;
-							diff >>= 1;
-						}
-					}
-					devicemap++;
-					acb_dev_map++;
-				}
-			}
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg  = acb->pmuB;
+		signature = (uint32_t __iomem *)(&reg->message_rwbuffer[0]);
+		devicemap = (char __iomem *)(&reg->message_rwbuffer[21]);
+		break;
 		}
+	case ACB_ADAPTER_TYPE_C: {
+		struct MessageUnit_C __iomem *reg  = acb->pmuC;
+		signature = (uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);
+		devicemap = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
 		break;
-		case ACB_ADAPTER_TYPE_C: {
-			struct MessageUnit_C *reg  = acb->pmuC;
-			char *acb_dev_map = (char *)acb->device_map;
-			uint32_t __iomem *signature = (uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);
-			char __iomem *devicemap = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
-			int target, lun;
-			struct scsi_device *psdev;
-			char diff;
-
-			atomic_inc(&acb->rq_map_token);
-			if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
-				for (target = 0; target < ARCMSR_MAX_TARGETID - 1; target++) {
-					diff = (*acb_dev_map)^readb(devicemap);
-					if (diff != 0) {
-						char temp;
-						*acb_dev_map = readb(devicemap);
-						temp = *acb_dev_map;
-						for (lun = 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {
-							if ((temp & 0x01) == 1 && (diff & 0x01) == 1) {
-								scsi_add_device(acb->host, 0, target, lun);
-							} else if ((temp & 0x01) == 0 && (diff & 0x01) == 1) {
-								psdev = scsi_device_lookup(acb->host, 0, target, lun);
-								if (psdev != NULL) {
-									scsi_remove_device(psdev);
-									scsi_device_put(psdev);
-								}
-							}
-							temp >>= 1;
-							diff >>= 1;
+		}
+	}
+	atomic_inc(&acb->rq_map_token);
+	if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
+		for (target = 0; target < ARCMSR_MAX_TARGETID - 1;
+			target++) {
+			temp = readb(devicemap);
+			diff = (*acb_dev_map) ^ temp;
+			if (diff != 0) {
+				*acb_dev_map = temp;
+				for (lun = 0; lun < ARCMSR_MAX_TARGETLUN;
+					lun++) {
+					if ((diff & 0x01) == 1 &&
+						(temp & 0x01) == 1) {
+						scsi_add_device(acb->host,
+							0, target, lun);
+					} else if ((diff & 0x01) == 1
+						&& (temp & 0x01) == 0) {
+						psdev =
+							scsi_device_lookup(acb->host,
+							0, target, lun);
+						if (psdev != NULL) {
+							scsi_remove_device(psdev);
+							scsi_device_put(psdev);
 						}
 					}
-					devicemap++;
-					acb_dev_map++;
+					temp >>= 1;
+					diff >>= 1;
 				}
 			}
+			devicemap++;
+			acb_dev_map++;
 		}
 	}
 }


