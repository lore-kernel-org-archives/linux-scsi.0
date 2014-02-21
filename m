From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: [PATCH v1.3 6/11] arcmsr: Rewrite arcmsr_message_isr_bh_fn function
Date: Fri, 21 Feb 2014 12:07:48 +0800
Message-ID: <CAKiknE-wOrHvWfD+ET1rnmnmgFgxAaTi6cDK7-_DaxrJn05mgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:60832 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaBUEHt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 23:07:49 -0500
Received: by mail-vc0-f175.google.com with SMTP id ij19so2791857vcb.34
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2014 20:07:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>

From: Ching <ching2048@areca.com.tw>

Rewrite arcmsr_message_isr_bh_fn function

Singed-off-by: Ching <ching2048@areca.com.tw>
---


diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:02:34.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:03:28.000000000 +0800
@@ -489,121 +489,68 @@ static int arcmsr_alloc_ccb_pool(struct
        return 0;
 }

-static void arcmsr_message_isr_bh_fn(struct work_struct *work)
+static void
+arcmsr_message_isr_bh_fn(struct work_struct *work)
 {
-       struct AdapterControlBlock *acb = container_of(work,struct
AdapterControlBlock, arcmsr_do_message_isr_bh);
-       switch (acb->adapter_type) {
-               case ACB_ADAPTER_TYPE_A: {
-
-                       struct MessageUnit_A __iomem *reg  = acb->pmuA;
-                       char *acb_dev_map = (char *)acb->device_map;
-                       uint32_t __iomem *signature = (uint32_t
__iomem*) (&reg->message_rwbuffer[0]);
-                       char __iomem *devicemap = (char __iomem*)
(&reg->message_rwbuffer[21]);
-                       int target, lun;
-                       struct scsi_device *psdev;
-                       char diff;
+       struct AdapterControlBlock *acb = container_of(work,
+               struct AdapterControlBlock, arcmsr_do_message_isr_bh);
+       char *acb_dev_map = (char *)acb->device_map;
+       uint32_t __iomem *signature = NULL;
+       char __iomem *devicemap = NULL;
+       int target, lun;
+       struct scsi_device *psdev;
+       char diff, temp;

-                       atomic_inc(&acb->rq_map_token);
-                       if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
-                               for(target = 0; target <
ARCMSR_MAX_TARGETID -1; target++) {
-                                       diff = (*acb_dev_map)^readb(devicemap);
-                                       if (diff != 0) {
-                                               char temp;
-                                               *acb_dev_map = readb(devicemap);
-                                               temp =*acb_dev_map;
-                                               for(lun = 0; lun <
ARCMSR_MAX_TARGETLUN; lun++) {
-                                                       if((temp &
0x01)==1 && (diff & 0x01) == 1) {
-
scsi_add_device(acb->host, 0, target, lun);
-                                                       }else if((temp
& 0x01) == 0 && (diff & 0x01) == 1) {
-                                                               psdev
= scsi_device_lookup(acb->host, 0, target, lun);
-                                                               if
(psdev != NULL ) {
-
 scsi_remove_device(psdev);
-
 scsi_device_put(psdev);
-                                                               }
-                                                       }
-                                                       temp >>= 1;
-                                                       diff >>= 1;
-                                               }
-                                       }
-                                       devicemap++;
-                                       acb_dev_map++;
-                               }
-                       }
-                       break;
+       switch (acb->adapter_type) {
+       case ACB_ADAPTER_TYPE_A: {
+               struct MessageUnit_A __iomem *reg  = acb->pmuA;
+               signature = (uint32_t __iomem *)(&reg->message_rwbuffer[0]);
+               devicemap = (char __iomem *)(&reg->message_rwbuffer[21]);
+               break;
                }
-
-               case ACB_ADAPTER_TYPE_B: {
-                       struct MessageUnit_B *reg  = acb->pmuB;
-                       char *acb_dev_map = (char *)acb->device_map;
-                       uint32_t __iomem *signature = (uint32_t
__iomem*)(&reg->message_rwbuffer[0]);
-                       char __iomem *devicemap = (char
__iomem*)(&reg->message_rwbuffer[21]);
-                       int target, lun;
-                       struct scsi_device *psdev;
-                       char diff;
-
-                       atomic_inc(&acb->rq_map_token);
-                       if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
-                               for(target = 0; target <
ARCMSR_MAX_TARGETID -1; target++) {
-                                       diff = (*acb_dev_map)^readb(devicemap);
-                                       if (diff != 0) {
-                                               char temp;
-                                               *acb_dev_map = readb(devicemap);
-                                               temp =*acb_dev_map;
-                                               for(lun = 0; lun <
ARCMSR_MAX_TARGETLUN; lun++) {
-                                                       if((temp &
0x01)==1 && (diff & 0x01) == 1) {
-
scsi_add_device(acb->host, 0, target, lun);
-                                                       }else if((temp
& 0x01) == 0 && (diff & 0x01) == 1) {
-                                                               psdev
= scsi_device_lookup(acb->host, 0, target, lun);
-                                                               if
(psdev != NULL ) {
-
 scsi_remove_device(psdev);
-
 scsi_device_put(psdev);
-                                                               }
-                                                       }
-                                                       temp >>= 1;
-                                                       diff >>= 1;
-                                               }
-                                       }
-                                       devicemap++;
-                                       acb_dev_map++;
-                               }
-                       }
+       case ACB_ADAPTER_TYPE_B: {
+               struct MessageUnit_B *reg  = acb->pmuB;
+               signature = (uint32_t __iomem *)(&reg->message_rwbuffer[0]);
+               devicemap = (char __iomem *)(&reg->message_rwbuffer[21]);
+               break;
                }
+       case ACB_ADAPTER_TYPE_C: {
+               struct MessageUnit_C __iomem *reg  = acb->pmuC;
+               signature = (uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);
+               devicemap = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
                break;
-               case ACB_ADAPTER_TYPE_C: {
-                       struct MessageUnit_C *reg  = acb->pmuC;
-                       char *acb_dev_map = (char *)acb->device_map;
-                       uint32_t __iomem *signature = (uint32_t
__iomem *)(&reg->msgcode_rwbuffer[0]);
-                       char __iomem *devicemap = (char __iomem
*)(&reg->msgcode_rwbuffer[21]);
-                       int target, lun;
-                       struct scsi_device *psdev;
-                       char diff;
-
-                       atomic_inc(&acb->rq_map_token);
-                       if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
-                               for (target = 0; target <
ARCMSR_MAX_TARGETID - 1; target++) {
-                                       diff = (*acb_dev_map)^readb(devicemap);
-                                       if (diff != 0) {
-                                               char temp;
-                                               *acb_dev_map = readb(devicemap);
-                                               temp = *acb_dev_map;
-                                               for (lun = 0; lun <
ARCMSR_MAX_TARGETLUN; lun++) {
-                                                       if ((temp &
0x01) == 1 && (diff & 0x01) == 1) {
-
scsi_add_device(acb->host, 0, target, lun);
-                                                       } else if
((temp & 0x01) == 0 && (diff & 0x01) == 1) {
-                                                               psdev
= scsi_device_lookup(acb->host, 0, target, lun);
-                                                               if
(psdev != NULL) {
-
 scsi_remove_device(psdev);
-
 scsi_device_put(psdev);
-                                                               }
-                                                       }
-                                                       temp >>= 1;
-                                                       diff >>= 1;
+               }
+       }
+       atomic_inc(&acb->rq_map_token);
+       if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
+               for (target = 0; target < ARCMSR_MAX_TARGETID - 1;
+                       target++) {
+                       temp = readb(devicemap);
+                       diff = (*acb_dev_map) ^ temp;
+                       if (diff != 0) {
+                               *acb_dev_map = temp;
+                               for (lun = 0; lun < ARCMSR_MAX_TARGETLUN;
+                                       lun++) {
+                                       if ((diff & 0x01) == 1 &&
+                                               (temp & 0x01) == 1) {
+                                               scsi_add_device(acb->host,
+                                                       0, target, lun);
+                                       } else if ((diff & 0x01) == 1
+                                               && (temp & 0x01) == 0) {
+                                               psdev =
+
scsi_device_lookup(acb->host,
+                                                       0, target, lun);
+                                               if (psdev != NULL) {
+
scsi_remove_device(psdev);
+                                                       scsi_device_put(psdev);
                                                }
                                        }
-                                       devicemap++;
-                                       acb_dev_map++;
+                                       temp >>= 1;
+                                       diff >>= 1;
                                }
                        }
+                       devicemap++;
+                       acb_dev_map++;
                }
        }
 }
