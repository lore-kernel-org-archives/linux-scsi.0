From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] scsi/fnic: Fix a sleep-in-atomic bug in fnic_handle_event
Date: Tue,  3 Oct 2017 10:53:15 +0800
Message-ID: <1506999195-27236-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: satishkh@cisco.com, kartilak@cisco.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
List-Id: linux-scsi@vger.kernel.org

The driver may sleep under a spinlock, and the function call path is:
fnic_handle_event (acquire the spinlock)
  fnic_fcoe_start_fcf_disc
    fcoe_ctlr_link_up
      mutec_lock --> may sleep

To fix it, the spinlock can be released before fnic_fcoe_start_fcf_disc, 
and acquired again after this function.

This bug is found by my static analysis tool and my code review.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/scsi/fnic/fnic_fcs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 999fc75..4c99c96 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -265,7 +265,9 @@ void fnic_handle_event(struct work_struct *work)
 		case FNIC_EVT_START_FCF_DISC:
 			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
 				  "Start FCF Discovery\n");
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 			fnic_fcoe_start_fcf_disc(fnic);
+			spin_lock_irqsave(&fnic->fnic_lock, flags);
 			break;
 		default:
 			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-- 
1.7.9.5
