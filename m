From: ravi.anand@qlogic.com
Subject: [PATCH 01/11] Use msleep() rather than schedule_timeout().
Date: Tue, 7 Mar 2006 16:35:17 -0800
Message-ID: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:7151 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964844AbWCHAfV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:35:21 -0500
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, arjan@infradead.org
Cc: ravi.anand@qlogic.com

For process-context sleeping.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>


---

 drivers/scsi/qla4xxx/ql4_def.h   |    1 +
 drivers/scsi/qla4xxx/ql4_fw.h    |    3 +--
 drivers/scsi/qla4xxx/ql4_init.c  |   15 ++++-----------
 drivers/scsi/qla4xxx/ql4_mbx.c   |   18 ++----------------
 drivers/scsi/qla4xxx/ql4_nvram.c |    3 +--
 drivers/scsi/qla4xxx/ql4_os.c    |   23 +++++++----------------
 6 files changed, 16 insertions(+), 47 deletions(-)

a6d44211b9f2687a1114d02e7cce15e63ae4b6d3
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 2b26ff0..8c75929 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -21,6 +21,7 @@
 #include <linux/mempool.h>
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
+#include <linux/delay.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 6d0fb59..032e845 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -380,8 +380,7 @@ typedef struct isp_reg_t {
 	int i = 0; \
 	while (1) { \
 		if (QL4XXX_LOCK_DRVR(a) == 0) { \
-			set_current_state(TASK_UNINTERRUPTIBLE); \
-			schedule_timeout(10); \
+			msleep(10); \
 			if (!i) { \
 				DEBUG2(printk("scsi%ld: %s: Waiting for " \
 				    "Global Init Semaphore...n", a->host_no, \
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index d879f93..5ad55ec 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -317,8 +317,7 @@ qla4xxx_fw_ready(scsi_qla_host_t * ha)
 		DEBUG2(printk("scsi%ld: %s: waiting on fw, state=%x:%x - "
 		    "seconds expired= %d\n", ha->host_no, __func__,
 		    ha->firmware_state, ha->addl_fw_state, timeout_count));
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1 * HZ);
+		msleep(1000);
 	}			/* end of for */
 
 	if (timeout_count <= 0)
@@ -760,9 +759,7 @@ qla4xxx_devices_ready(scsi_qla_host_t * 
 			return QLA_SUCCESS;
 		}
 
-		/* delay */
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ * 2);
+		msleep(2000);
 	} while (!time_after_eq(jiffies, discovery_wtime));
 
 	DEBUG3(qla4xxx_get_conn_event_log(ha));
@@ -791,10 +788,7 @@ qla4xxx_flush_AENS(scsi_qla_host_t *ha)
 		if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
 			qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
 
-		/* delay */
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ * 1);
-
+		msleep(1000);
 	} while (!time_after_eq(jiffies, wtime));
 
 }
@@ -1057,8 +1051,7 @@ qla4xxx_start_firmware_from_flash(scsi_q
 		    "complete... ctrl_sts=0x%x, remaining=%d\n", ha->host_no,
 		    __func__, ctrl_status, max_wait_time));
 
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ / 4);
+		msleep(250);
 	} while ((max_wait_time--));
 
 	if (mbox_status == MBOX_STS_COMMAND_COMPLETE) {
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 8720357..6959adc 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -95,7 +95,6 @@ qla4xxx_mailbox_command(scsi_qla_host_t 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Wait for completion */
-	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(&ha->mailbox_wait_queue, &wait);
 
 	/*
@@ -105,7 +104,6 @@ qla4xxx_mailbox_command(scsi_qla_host_t 
 	 */
 	if (outCount == 0) {
 		status = QLA_SUCCESS;
-		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&ha->mailbox_wait_queue, &wait);
 		goto mbox_exit;
 	}
@@ -130,20 +128,8 @@ qla4xxx_mailbox_command(scsi_qla_host_t 
 		}
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		/*
-		 * Delay for 10 microseconds
-		 * NOTE: Interrupt_handler may be called here,
-		 *       if interrupts are enabled
-		 */
-#if 0
-		udelay(10);
-
-#else				/*  */
-		schedule_timeout(10);
-
-#endif				/*  */
-	}			/* wait loop */
-	set_current_state(TASK_RUNNING);
+		mdelay(10);
+	}
 	remove_wait_queue(&ha->mailbox_wait_queue, &wait);
 
 	/* Check for mailbox timeout. */
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
index b4c5080..e28678d 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.c
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -181,8 +181,7 @@ ql4xxx_sem_spinlock(scsi_qla_host_t * ha
 			    "code = 0x%x\n", ha->host_no, sem_mask, sem_bits));
 			break;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE); 
-		schedule_timeout(10); 
+		msleep(100);
 	}
 	return 1;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 801196d..1578aa0 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1078,9 +1078,7 @@ static int qla4xxx_do_dpc(void *data)
 						spin_unlock_irqrestore(
 						    &ha->hardware_lock, flags);
 
-						set_current_state(
-						    TASK_UNINTERRUPTIBLE);
-						schedule_timeout(1 * HZ);
+						msleep(1000);
 
 						spin_lock_irqsave(
 						    &ha->hardware_lock, flags);
@@ -1188,8 +1186,7 @@ qla4010_soft_reset(scsi_qla_host_t * ha)
 		if ((ctrl_status & CSR_NET_RESET_INTR) == 0)
 			break;
 
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1 * HZ);
+		msleep(1000);
 	} while ((--max_wait_time));
 
 	if ((ctrl_status & CSR_NET_RESET_INTR) != 0) {
@@ -1215,8 +1212,7 @@ qla4010_soft_reset(scsi_qla_host_t * ha)
 			break;
 		}
 
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1 * HZ);
+		msleep(1000);
 	} while ((--max_wait_time));
 
 	/*
@@ -1257,8 +1253,7 @@ qla4010_soft_reset(scsi_qla_host_t * ha)
 				break;
 			}
 
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(1 * HZ);
+			msleep(1000);
 		} while ((--max_wait_time));
 	}
 
@@ -1421,9 +1416,7 @@ qla4xxx_cmd_wait(scsi_qla_host_t * ha)
 		if (wait_cnt == 0)
 			stat = QLA_ERROR;
 		else {
-			/* sleep a second */
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(1 * HZ);
+			msleep(1000);
 		}
 	}			/* End of While (wait_cnt) */
 
@@ -1585,8 +1578,7 @@ qla4xxx_eh_wait_on_command(scsi_qla_host
 			break;
 		}
 
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(2 * HZ);
+		msleep(2000);
 	} while (max_wait_time--);
 
 	return done;
@@ -1620,8 +1612,7 @@ int qla4xxx_wait_for_hba_online(scsi_qla
 		if (!ADAPTER_UP(ha) && (ha->retry_reset_ha_cnt == 0)) {
 			return QLA_ERROR;
 		}
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(2 * HZ);
+		msleep(2000);
 	}
 
 	return QLA_ERROR;
-- 
1.2.4.g9201-dirty


