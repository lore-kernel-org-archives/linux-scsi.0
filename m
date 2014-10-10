From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Fri, 10 Oct 2014 21:11:47 +0000
Message-ID: <bug-85151-11613-AtvNNpvD2A@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42245 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaJJVLw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2014 17:11:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E197020125
	for <linux-scsi@vger.kernel.org>; Fri, 10 Oct 2014 21:11:50 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 2C3FD2020E
	for <linux-scsi@vger.kernel.org>; Fri, 10 Oct 2014 21:11:49 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #11 from linux-ide@crashplan.pro ---
Created attachment 153151
  --> https://bugzilla.kernel.org/attachment.cgi?id=153151&action=edit
pm80xx dmesg even more verbose output after patching pm80xx.ko

This is the applied patch:
===
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c
b/drivers/scsi/pm8001/pm80xx_hwi.c
index b06443a..c696fdc 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2613,10 +2613,10 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha,
void *piomb)
         ts->stat = SAM_STAT_GOOD;
         if (pm8001_dev)
             pm8001_dev->running_req--;
+        PM8001_FAIL_DBG(pm8001_ha,
+            pm8001_printk("RESPONSE Length:%d\n",
+                    param));
         if (pm8001_ha->smp_exp_mode == SMP_DIRECT) {
-            PM8001_IO_DBG(pm8001_ha,
-                pm8001_printk("DIRECT RESPONSE Length:%d\n",
-                        param));
             pdma_respaddr = (char *)(phys_to_virt(cpu_to_le64
                         ((u64)sg_dma_address
                         (&t->smp_task.smp_resp))));
@@ -2628,6 +2628,17 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha,
void *piomb)
                     psmpPayload->_r_a[i]));
             }
         }
+        else if (pm8001_ha->smp_exp_mode == SMP_INDIRECT) {
+            pdma_respaddr = (char *)(phys_to_virt(cpu_to_le64
+                        ((u64)sg_dma_address
+                        (&t->smp_task.smp_resp))));
+            for (i = 0; i < param; i++) {
+                PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+                    "SMP Byte%d DMA data 0x%x psmp 0x%x\n",
+                    i, *(pdma_respaddr+i),
+                    psmpPayload->_r_a[i]));
+            }
+        }
         break;
     case IO_ABORTED:
         PM8001_IO_DBG(pm8001_ha,
@@ -2638,12 +2649,21 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha,
void *piomb)
             pm8001_dev->running_req--;
         break;
     case IO_OVERFLOW:
-        PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));
+        PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_OVERFLOW\n"));
         ts->resp = SAS_TASK_COMPLETE;
-        ts->stat = SAS_DATA_OVERRUN;
+        ts->stat = SAM_STAT_GOOD;
         ts->residual = 0;
         if (pm8001_dev)
             pm8001_dev->running_req--;
+        pdma_respaddr = (char *)(phys_to_virt(cpu_to_le64
+                                                ((u64)sg_dma_address
+                                                (&t->smp_task.smp_resp))));
+                for (i = 0; i < param; i++) {
+                            PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+                                    "SMP Byte%d DMA data 0x%x psmp 0x%x\n",
+                                    i, *(pdma_respaddr+i),
+                                    psmpPayload->_r_a[i]));
+        }
         break;
     case IO_NO_DEVICE:
         PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_NO_DEVICE\n"));
@@ -3809,24 +3829,20 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info
*pm8001_ha,
             cpu_to_le32
             ((u32)sg_dma_len(&task->smp_task.smp_resp)-4);
     }
-    if (pm8001_ha->smp_exp_mode == SMP_DIRECT) {
-        PM8001_IO_DBG(pm8001_ha,
-            pm8001_printk("SMP REQUEST DIRECT MODE\n"));
         for (i = 0; i < length; i++)
             if (i < 16) {
                 smp_cmd.smp_req16[i] = *(preq_dma_addr+i);
-                PM8001_IO_DBG(pm8001_ha, pm8001_printk(
+                PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
                     "Byte[%d]:%x (DMA data:%x)\n",
                     i, smp_cmd.smp_req16[i],
                     *(preq_dma_addr)));
             } else {
                 smp_cmd.smp_req[i] = *(preq_dma_addr+i);
-                PM8001_IO_DBG(pm8001_ha, pm8001_printk(
+                PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
                     "Byte[%d]:%x (DMA data:%x)\n",
                     i, smp_cmd.smp_req[i],
                     *(preq_dma_addr)));
             }
-    }

     build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag,
                 &smp_cmd, pm8001_ha->smp_exp_mode, length);

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
