From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Subject: [PATCH 2/3] drivers/scsi/arcmsr: Remove dead
 CONFIG_SCSI_ARCMSR_RESET
Date: Wed, 21 Jul 2010 15:57:47 +0200
Message-ID: <b76b9b20e633f5eea0bad22fb1bc71e7e05e8c66.1279719754.git.qy03fugy__12694.2490962849$1279720719$gmane$org@stud.informatik.uni-erlangen.de>
References: <cover.1279719754.git.qy03fugy@stud.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:62028 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758397Ab0GUN5u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 09:57:50 -0400
Content-Disposition: inline
In-Reply-To: <cover.1279719754.git.qy03fugy@stud.informatik.uni-erlangen.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, Vasu Dev <vasu.dev@intel.com>, Nick Cheng <nick.cheng@areca.com.tw>, Tejun Heo <tj@kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
Cc: vamos-dev@i4.informatik.uni-erlangen.de

CONFIG_SCSI_ARCMSR_RESET doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |   80 --------------------------------------
 1 files changed, 0 insertions(+), 80 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index ffa5479..fb7866e 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -72,14 +72,6 @@
 #include <scsi/scsicam.h>
 #include "arcmsr.h"
 
-#ifdef CONFIG_SCSI_ARCMSR_RESET
-	static int sleeptime = 20;
-	static int retrycount = 12;
-	module_param(sleeptime, int, S_IRUGO|S_IWUSR);
-	MODULE_PARM_DESC(sleeptime, "The waiting period for FW ready while bus reset");
-	module_param(retrycount, int, S_IRUGO|S_IWUSR);
-	MODULE_PARM_DESC(retrycount, "The retry count for FW ready while bus reset");
-#endif
 MODULE_AUTHOR("Erich Chen <support@areca.com.tw>");
 MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID Host Bus Adapter");
 MODULE_LICENSE("Dual BSD/GPL");
@@ -2446,37 +2438,6 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 ****************************************************************************
 ****************************************************************************
 */
-#ifdef CONFIG_SCSI_ARCMSR_RESET
-	int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)
-	{
-			struct Scsi_Host *shost = NULL;
-			spinlock_t *host_lock = NULL;
-			int i, isleep;
-
-			shost = cmd->device->host;
-			host_lock = shost->host_lock;
-
-			printk(KERN_NOTICE "Host %d bus reset over, sleep %d seconds (busy %d, can queue %d) ...........\n",
-					shost->host_no, sleeptime, shost->host_busy, shost->can_queue);
-			isleep = sleeptime / 10;
-			spin_unlock_irq(host_lock);
-			if (isleep > 0) {
-				for (i = 0; i < isleep; i++) {
-					msleep(10000);
-					printk(KERN_NOTICE "^%d^\n", i);
-				}
-			}
-
-			isleep = sleeptime % 10;
-			if (isleep > 0) {
-				msleep(isleep * 1000);
-				printk(KERN_NOTICE "^v^\n");
-			}
-			spin_lock_irq(host_lock);
-			printk(KERN_NOTICE "***** wake up *****\n");
-			return 0;
-	}
-#endif
 static void arcmsr_iop_init(struct AdapterControlBlock *acb)
 {
 	uint32_t intmask_org;
@@ -2551,47 +2512,6 @@ static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
 			arcmsr_hardware_reset(acb);
 			acb->acb_flags |= ACB_F_FIRMWARE_TRAP;
 			acb->acb_flags &= ~ACB_F_IOP_INITED;
-			#ifdef CONFIG_SCSI_ARCMSR_RESET
-			struct MessageUnit_A __iomem *reg = acb->pmuA;
-			uint32_t intmask_org, outbound_doorbell;
-			int retry_count = 0;
-sleep_again:
-			arcmsr_sleep_for_bus_reset(cmd);
-			if ((readl(&reg->outbound_msgaddr1) &
-			ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0) {
-			printk(KERN_NOTICE "arcmsr%d: hardware bus reset and return busy, retry=%d \n",
-			acb->host->host_no, retry_count);
-			if (retry_count > retrycount) {
-				printk(KERN_NOTICE "arcmsr%d: hardware bus reset and return busy, retry aborted \n",
-				acb->host->host_no);
-			return SUCCESS;
-			}
-			retry_count++;
-			goto sleep_again;
-			}
-			acb->acb_flags &= ~ACB_F_FIRMWARE_TRAP;
-			acb->acb_flags |= ACB_F_IOP_INITED;
-			acb->acb_flags &= ~ACB_F_BUS_RESET;
-			printk(KERN_NOTICE "arcmsr%d: hardware bus reset and reset ok \n",
-				acb->host->host_no);
-			/* disable all outbound interrupt */
-			intmask_org = arcmsr_disable_outbound_ints(acb);
-			arcmsr_get_firmware_spec(acb, 1);
-			/*start	background rebuild*/
-			arcmsr_start_adapter_bgrb(acb);
-			/* clear Qbuffer if door bell ringed */
-			outbound_doorbell = readl(&reg->outbound_doorbell);
-			writel(outbound_doorbell, &reg->outbound_doorbell); /*clear interrupt */
-			writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
-			/* enable outbound Post Queue,outbound doorbell Interrupt */
-			arcmsr_enable_outbound_ints(acb, intmask_org);
-			atomic_set(&acb->rq_map_token, 16);
-			init_timer(&acb->eternal_timer);
-			acb->eternal_timer.expires = jiffies + msecs_to_jiffies(20*HZ);
-			acb->eternal_timer.data = (unsigned long) acb;
-			acb->eternal_timer.function = &arcmsr_request_device_map;
-			add_timer(&acb->eternal_timer);
-			#endif
 		}
 			break;
 		case ACB_ADAPTER_TYPE_B: {
-- 
1.7.0.4

