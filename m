From: janitor@sternwelten.at
Subject: [patch 4/7]  scsi/qla_os: replace schedule_timeout() 	with msleep()
Date: Wed, 01 Sep 2004 21:54:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2bC7-0005rY-Rt@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:29354 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267521AbUIATzB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 15:55:01 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at







I would appreciate any comments from the janitor@sternweltens list. 



Description: Use msleep() instead of schedule_timeout() to 
guarantee the task delays for the desired time.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

incremental patch adds missing include.

Signed-off-by: Domen Puncer <domen@coderock.org>
Signed-off-by: Max Attems <janitor@sternwelten.at>




---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/qla2xxx/qla_os.c |   37 ++++++------------
 1 files changed, 13 insertions(+), 24 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~msleep-drivers_scsi_qla2xxx_qla_os drivers/scsi/qla2xxx/qla_os.c
--- linux-2.6.9-rc1-bk7/drivers/scsi/qla2xxx/qla_os.c~msleep-drivers_scsi_qla2xxx_qla_os	2004-09-01 19:35:47.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/qla2xxx/qla_os.c	2004-09-01 19:35:47.000000000 +0200
@@ -21,6 +21,7 @@
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
 #include <linux/smp_lock.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -969,8 +970,7 @@ qla2x00_wait_for_hba_online(scsi_qla_hos
 	    test_bit(ISP_ABORT_RETRY, &ha->dpc_flags) ||
 	    ha->dpc_active) && time_before(jiffies, wait_online)) {
 
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ);
+		msleep(1000);
 	}
 	if (ha->flags.online) 
 		return_status = QLA_SUCCESS; 
@@ -1011,8 +1011,7 @@ qla2x00_wait_for_loop_ready(scsi_qla_hos
 	    atomic_read(&ha->loop_state) == LOOP_DOWN) ||
 	    test_bit(CFG_ACTIVE, &ha->cfg_flags) ||
 	    atomic_read(&ha->loop_state) != LOOP_READY) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ);
+		msleep(1000);
 		if (time_after_eq(jiffies, loop_timeout)) {
 			return_status = QLA_FUNCTION_FAILED;
 			break;
@@ -2120,8 +2119,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 
 		qla2x00_check_fabric_devices(ha);
 
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ/100);
+		msleep(10);
 	}
 
 	pci_set_drvdata(pdev, ha);
@@ -2833,8 +2831,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			    "Memory Allocation failed - request_ring\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(HZ/10);
+			msleep(100);
 
 			continue;
 		}
@@ -2847,8 +2844,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			    "Memory Allocation failed - response_ring\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(HZ/10);
+			msleep(100);
 
 			continue;
 		}
@@ -2861,8 +2857,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			    "Memory Allocation failed - init_cb\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(HZ/10);
+			msleep(100);
 
 			continue;
 		}
@@ -2874,8 +2869,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			    "Memory Allocation failed - ioctl_mem\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(HZ/10);
+			msleep(100);
 
 			continue;
 		}
@@ -2886,8 +2880,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			    "qla2x00_allocate_sp_pool()\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(HZ/10);
+			msleep(100);
 
 			continue;
 		}
@@ -2903,8 +2896,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 				    "Memory Allocation failed - sns_cmd\n");
 
 				qla2x00_mem_free(ha);
-				set_current_state(TASK_UNINTERRUPTIBLE);
-				schedule_timeout(HZ/10);
+				msleep(100);
 
 				continue;
 			}
@@ -2919,8 +2911,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 				    "Memory Allocation failed - ms_iocb\n");
 
 				qla2x00_mem_free(ha);
-				set_current_state(TASK_UNINTERRUPTIBLE);
-				schedule_timeout(HZ/10);
+				msleep(100);
 
 				continue;
 			}
@@ -2938,8 +2929,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 				    "Memory Allocation failed - ct_sns\n");
 
 				qla2x00_mem_free(ha);
-				set_current_state(TASK_UNINTERRUPTIBLE);
-				schedule_timeout(HZ/10);
+				msleep(100);
 
 				continue;
 			}
@@ -2955,8 +2945,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			    "Memory Allocation failed - iodesc_pd\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(HZ/10);
+			msleep(100);
 
 			continue;
 		}

_
