From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: [-mm PATCH 29/32] drivers/scsi: fix-up schedule_timeout() usage
Date: Mon, 15 Aug 2005 11:27:51 -0700
Message-ID: <20050815182751.GF2854@us.ibm.com>
References: <20050815180514.GC2854@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:22405 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964892AbVHOS1y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 14:27:54 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7FIRrZb015987
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 14:27:54 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7FIRrPJ219382
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 14:27:53 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7FIRqAA032248
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 14:27:53 -0400
Content-Disposition: inline
In-Reply-To: <20050815180514.GC2854@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, matthew@wil.cx, markus.lidel@shadowconnect.com, osst@riede.org, andrew.vasquez@qlogic.com
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org

Description: Use schedule_timeout_uninterruptible() instead of
set_current_state()/schedule_timeout() to reduce kernel size.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

---

 drivers/scsi/NCR5380.c        |    5 +----
 drivers/scsi/aacraid/rkt.c    |    6 ++----
 drivers/scsi/aacraid/rx.c     |    6 ++----
 drivers/scsi/aacraid/sa.c     |    6 ++----
 drivers/scsi/dpt_i2o.c        |   34 +++++++++++-----------------------
 drivers/scsi/lpfc/lpfc_scsi.c |   12 ++++--------
 drivers/scsi/osst.c           |    9 +++------
 drivers/scsi/qla2xxx/qla_os.c |   11 ++++-------
 8 files changed, 29 insertions(+), 60 deletions(-)

diff -urpN 2.6.13-rc5-mm1/drivers/scsi/aacraid/rkt.c 2.6.13-rc5-mm1-dev/drivers/scsi/aacraid/rkt.c
--- 2.6.13-rc5-mm1/drivers/scsi/aacraid/rkt.c	2005-08-07 10:05:21.000000000 -0700
+++ 2.6.13-rc5-mm1-dev/drivers/scsi/aacraid/rkt.c	2005-08-10 14:21:10.000000000 -0700
@@ -166,8 +166,7 @@ static int rkt_sync_cmd(struct aac_dev *
 		/*
 		 *	Yield the processor in case we are slow 
 		 */
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 	if (ok != 1) {
 		/*
@@ -410,8 +409,7 @@ int aac_rkt_init(struct aac_dev *dev)
 					dev->name, instance, status);
 			goto error_iounmap;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 	if (request_irq(dev->scsi_host_ptr->irq, aac_rkt_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev)<0) 
 	{
diff -urpN 2.6.13-rc5-mm1/drivers/scsi/aacraid/rx.c 2.6.13-rc5-mm1-dev/drivers/scsi/aacraid/rx.c
--- 2.6.13-rc5-mm1/drivers/scsi/aacraid/rx.c	2005-08-07 10:05:21.000000000 -0700
+++ 2.6.13-rc5-mm1-dev/drivers/scsi/aacraid/rx.c	2005-08-10 14:21:23.000000000 -0700
@@ -166,8 +166,7 @@ static int rx_sync_cmd(struct aac_dev *d
 		/*
 		 *	Yield the processor in case we are slow 
 		 */
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 	if (ok != 1) {
 		/*
@@ -410,8 +409,7 @@ int aac_rx_init(struct aac_dev *dev)
 					dev->name, instance, status);
 			goto error_iounmap;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 	if (request_irq(dev->scsi_host_ptr->irq, aac_rx_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev)<0) 
 	{
diff -urpN 2.6.13-rc5-mm1/drivers/scsi/aacraid/sa.c 2.6.13-rc5-mm1-dev/drivers/scsi/aacraid/sa.c
--- 2.6.13-rc5-mm1/drivers/scsi/aacraid/sa.c	2005-08-07 10:05:21.000000000 -0700
+++ 2.6.13-rc5-mm1-dev/drivers/scsi/aacraid/sa.c	2005-08-10 14:21:35.000000000 -0700
@@ -189,8 +189,7 @@ static int sa_sync_cmd(struct aac_dev *d
 			ok = 1;
 			break;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 
 	if (ok != 1)
@@ -347,8 +346,7 @@ int aac_sa_init(struct aac_dev *dev)
 					name, instance, status);
 			goto error_iounmap;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 
 	if (request_irq(dev->scsi_host_ptr->irq, aac_sa_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev ) < 0) {
diff -urpN 2.6.13-rc5-mm1/drivers/scsi/dpt_i2o.c 2.6.13-rc5-mm1-dev/drivers/scsi/dpt_i2o.c
--- 2.6.13-rc5-mm1/drivers/scsi/dpt_i2o.c	2005-08-07 09:58:08.000000000 -0700
+++ 2.6.13-rc5-mm1-dev/drivers/scsi/dpt_i2o.c	2005-08-10 14:23:16.000000000 -0700
@@ -1211,8 +1211,7 @@ static s32 adpt_i2o_post_this(adpt_hba* 
 			printk(KERN_WARNING"dpti%d: Timeout waiting for message frame!\n", pHba->unit);
 			return -ETIMEDOUT;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	} while(m == EMPTY_QUEUE);
 		
 	msg = pHba->msg_addr_virt + m;
@@ -1287,8 +1286,7 @@ static s32 adpt_i2o_reset_hba(adpt_hba* 
 			printk(KERN_WARNING"Timeout waiting for message!\n");
 			return -ETIMEDOUT;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	} while (m == EMPTY_QUEUE);
 
 	status = (u8*)kmalloc(4, GFP_KERNEL|ADDR32);
@@ -1320,8 +1318,7 @@ static s32 adpt_i2o_reset_hba(adpt_hba* 
 			return -ETIMEDOUT;
 		}
 		rmb();
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 
 	if(*status == 0x01 /*I2O_EXEC_IOP_RESET_IN_PROGRESS*/) {
@@ -1338,8 +1335,7 @@ static s32 adpt_i2o_reset_hba(adpt_hba* 
 				printk(KERN_ERR "%s:Timeout waiting for IOP Reset.\n",pHba->name);
 				return -ETIMEDOUT;
 			}
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(1);
+			schedule_timeout_uninterruptible(1);
 		} while (m == EMPTY_QUEUE);
 		// Flush the offset
 		adpt_send_nop(pHba, m);
@@ -1910,11 +1906,8 @@ static int adpt_ioctl(struct inode *inod
 		return -ENXIO;
 	}
 
-	while((volatile u32) pHba->state & DPTI_STATE_RESET ) {
-		set_task_state(current,TASK_UNINTERRUPTIBLE);
-		schedule_timeout(2);
-
-	}
+	while((volatile u32) pHba->state & DPTI_STATE_RESET )
+		schedule_timeout_uninterruptible(2);
 
 	switch (cmd) {
 	// TODO: handle 3 cases
@@ -2628,8 +2621,7 @@ static s32 adpt_send_nop(adpt_hba*pHba,u
 			printk(KERN_ERR "%s: Timeout waiting for message frame!\n",pHba->name);
 			return 2;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 	msg = (u32 __iomem *)(pHba->msg_addr_virt + m);
 	writel( THREE_WORD_MSG_SIZE | SGL_OFFSET_0,&msg[0]);
@@ -2663,8 +2655,7 @@ static s32 adpt_i2o_init_outbound_q(adpt
 			printk(KERN_WARNING"%s: Timeout waiting for message frame\n",pHba->name);
 			return -ETIMEDOUT;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	} while(m == EMPTY_QUEUE);
 
 	msg=(u32 __iomem *)(pHba->msg_addr_virt+m);
@@ -2702,8 +2693,7 @@ static s32 adpt_i2o_init_outbound_q(adpt
 			printk(KERN_WARNING"%s: Timeout Initializing\n",pHba->name);
 			return -ETIMEDOUT;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	} while (1);
 
 	// If the command was successful, fill the fifo with our reply
@@ -2781,8 +2771,7 @@ static s32 adpt_i2o_status_get(adpt_hba*
 					pHba->name);
 			return -ETIMEDOUT;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	} while(m==EMPTY_QUEUE);
 
 	
@@ -2809,8 +2798,7 @@ static s32 adpt_i2o_status_get(adpt_hba*
 			return -ETIMEDOUT;
 		}
 		rmb();
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 
 	// Set up our number of outbound and inbound messages
diff -urpN 2.6.13-rc5-mm1/drivers/scsi/lpfc/lpfc_scsi.c 2.6.13-rc5-mm1-dev/drivers/scsi/lpfc/lpfc_scsi.c
--- 2.6.13-rc5-mm1/drivers/scsi/lpfc/lpfc_scsi.c	2005-08-07 09:58:09.000000000 -0700
+++ 2.6.13-rc5-mm1-dev/drivers/scsi/lpfc/lpfc_scsi.c	2005-08-12 13:51:18.000000000 -0700
@@ -883,8 +883,7 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 		while (cmnd->host_scribble)
 		{
 			spin_unlock_irq(phba->host->host_lock);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(LPFC_ABORT_WAIT*HZ);
+			schedule_timeout_uninterruptible(LPFC_ABORT_WAIT*HZ);
 			spin_lock_irq(phba->host->host_lock);
 			if (++loop_count
 			    > (2 * phba->cfg_nodev_tmo)/LPFC_ABORT_WAIT)
@@ -950,8 +949,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 
 		if (pnode->nlp_state != NLP_STE_MAPPED_NODE) {
 			spin_unlock_irq(phba->host->host_lock);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout( HZ/2);
+			schedule_timeout_uninterruptible(msecs_to_jiffies(500));
 			spin_lock_irq(phba->host->host_lock);
 		}
 		if ((pnode) && (pnode->nlp_state == NLP_STE_MAPPED_NODE))
@@ -1009,8 +1007,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 				       cmnd->device->id, cmnd->device->lun,
 				       LPFC_CTX_LUN))) {
 		spin_unlock_irq(phba->host->host_lock);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(LPFC_RESET_WAIT*HZ);
+		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
 		spin_lock_irq(phba->host->host_lock);
 
 		if (++loopcnt
@@ -1108,8 +1105,7 @@ __lpfc_reset_bus_handler(struct scsi_cmn
 				&phba->sli.ring[phba->sli.fcp_ring],
 				0, 0, LPFC_CTX_HOST))) {
 		spin_unlock_irq(phba->host->host_lock);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(LPFC_RESET_WAIT*HZ);
+		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
 		spin_lock_irq(phba->host->host_lock);
 
 		if (++loopcnt
diff -urpN 2.6.13-rc5-mm1/drivers/scsi/NCR5380.c 2.6.13-rc5-mm1-dev/drivers/scsi/NCR5380.c
--- 2.6.13-rc5-mm1/drivers/scsi/NCR5380.c	2005-08-07 09:58:07.000000000 -0700
+++ 2.6.13-rc5-mm1-dev/drivers/scsi/NCR5380.c	2005-08-10 14:20:50.000000000 -0700
@@ -599,10 +599,7 @@ static int __init NCR5380_probe_irq(stru
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_SEL);
 
 	while (probe_irq == SCSI_IRQ_NONE && time_before(jiffies, timeout))
-	{
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
-	}
+		schedule_timeout_uninterruptible(1);
 	
 	NCR5380_write(SELECT_ENABLE_REG, 0);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
diff -urpN 2.6.13-rc5-mm1/drivers/scsi/osst.c 2.6.13-rc5-mm1-dev/drivers/scsi/osst.c
--- 2.6.13-rc5-mm1/drivers/scsi/osst.c	2005-08-07 10:05:21.000000000 -0700
+++ 2.6.13-rc5-mm1-dev/drivers/scsi/osst.c	2005-08-12 13:42:13.000000000 -0700
@@ -862,8 +862,7 @@ static int osst_recover_wait_frame(struc
 				retval = osst_write_error_recovery(STp, aSRpnt, 0);
 				break;
 			}
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout (HZ / OSST_POLL_PER_SEC);
+			schedule_timeout_interruptible(HZ / OSST_POLL_PER_SEC);
 
 			STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
 			memset(cmd, 0, MAX_COMMAND_SIZE);
@@ -1558,8 +1557,7 @@ static int osst_reposition_and_retry(str
 			osst_set_frame_position(STp, aSRpnt, frame + skip, 1);
 			flag = 0;
 			attempts--;
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(HZ / 10);
+			schedule_timeout_interruptible(msecs_to_jiffies(100));
 		}
 		if (osst_get_frame_position(STp, aSRpnt) < 0) {		/* additional write error */
 #if DEBUG
@@ -1620,8 +1618,7 @@ static int osst_reposition_and_retry(str
 			debugging = 0;
 		}
 #endif
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(HZ / 10);
+		schedule_timeout_interruptible(msecs_to_jiffies(100));
 	}
 	printk(KERN_ERR "%s:E: Failed to find valid tape media\n", name);
 #if DEBUG
diff -urpN 2.6.13-rc5-mm1/drivers/scsi/qla2xxx/qla_os.c 2.6.13-rc5-mm1-dev/drivers/scsi/qla2xxx/qla_os.c
--- 2.6.13-rc5-mm1/drivers/scsi/qla2xxx/qla_os.c	2005-08-07 09:58:14.000000000 -0700
+++ 2.6.13-rc5-mm1-dev/drivers/scsi/qla2xxx/qla_os.c	2005-08-12 13:42:28.000000000 -0700
@@ -1944,10 +1944,8 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 
 	/* Make sure all other threads are stopped. */
 	wtime = 60 * HZ;
-	while (ha->dpc_wait && wtime) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		wtime = schedule_timeout(wtime);
-	}
+	while (ha->dpc_wait && wtime)
+		wtime = schedule_timeout_interruptible(wtime);
 
 	/* free ioctl memory */
 	qla2x00_free_ioctl_mem(ha);
@@ -2478,13 +2476,12 @@ qla2x00_timer(scsi_qla_host_t *ha)
 int
 qla2x00_down_timeout(struct semaphore *sema, unsigned long timeout)
 {
-	const unsigned int step = HZ/10;
+	const unsigned int step = msecs_to_jiffies(100);
 
 	do {
 		if (!down_trylock(sema))
 			return 0;
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (schedule_timeout(step))
+		if (schedule_timeout_interruptible(step))
 			break;
 	} while ((timeout -= step) > 0);
 
