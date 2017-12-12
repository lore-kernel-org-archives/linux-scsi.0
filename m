From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] arcmsr: Fix possible sleep-in-atomic bugs in arcmsr_queue_command
Date: Tue, 12 Dec 2017 21:33:00 +0800
Message-ID: <1513085580-28705-1-git-send-email-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: support@areca.com.tw, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, keescook@chromium.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
List-Id: linux-scsi@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@163.com>

The driver may sleep under a spinlock, and the function call paths are:
arcmsr_queue_command(acquire the spinlock)
  arcmsr_queue_command_lck
    arcmsr_handle_virtual_command
      arcmsr_iop_message_xfer
        arcmsr_iop_parking
          arcmsr_stop_adapter_bgrb
            arcmsr_hbaA_stop_bgrb
              arcmsr_hbaA_wait_msgint_ready
                msleep --> may sleep

arcmsr_queue_command(acquire the spinlock)
  arcmsr_queue_command_lck
    arcmsr_handle_virtual_command
      arcmsr_iop_message_xfer
        arcmsr_iop_parking
          arcmsr_stop_adapter_bgrb
            arcmsr_hbaB_stop_bgrb
              arcmsr_hbaB_wait_msgint_ready
                msleep --> may sleep

arcmsr_queue_command(acquire the spinlock)
  arcmsr_queue_command_lck
    arcmsr_handle_virtual_command
      arcmsr_iop_message_xfer
        arcmsr_iop_parking
          arcmsr_stop_adapter_bgrb
            arcmsr_hbaC_stop_bgrb
              arcmsr_hbaC_wait_msgint_ready
                msleep --> may sleep

arcmsr_queue_command(acquire the spinlock)
  arcmsr_queue_command_lck
    arcmsr_handle_virtual_command
      arcmsr_iop_message_xfer
        arcmsr_iop_parking
          arcmsr_stop_adapter_bgrb
            arcmsr_hbaD_stop_bgrb
              arcmsr_hbaD_wait_msgint_ready
                msleep --> may sleep

To fix them, msleep is replaced with mdelay.
These bugs are found by my static analysis tool and my code review.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index af032c4..31d94bd 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -347,7 +347,7 @@ static uint8_t arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)
 				&reg->outbound_intstatus);
 			return true;
 		}
-		msleep(10);
+		mdelay(10);
 	} /* max 20 seconds */
 
 	return false;
@@ -367,7 +367,7 @@ static uint8_t arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)
 					reg->drv2iop_doorbell);
 			return true;
 		}
-		msleep(10);
+		mdelay(10);
 	} /* max 20 seconds */
 
 	return false;
@@ -385,7 +385,7 @@ static uint8_t arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)
 				&phbcmu->outbound_doorbell_clear); /*clear interrupt*/
 			return true;
 		}
-		msleep(10);
+		mdelay(10);
 	} /* max 20 seconds */
 
 	return false;
@@ -403,7 +403,7 @@ static bool arcmsr_hbaD_wait_msgint_ready(struct AdapterControlBlock *pACB)
 				reg->outbound_doorbell);
 			return true;
 		}
-		msleep(10);
+		mdelay(10);
 	} /* max 20 seconds */
 	return false;
 }
-- 
1.7.9.5
