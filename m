From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 10/19] lpfc: Fix soft lockup in lpfc worker thread during LIP testing
Date: Tue, 30 Jan 2018 15:58:54 -0800
Message-ID: <20180130235903.5316-11-jsmart2021@gmail.com>
References: <20180130235903.5316-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38740 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753842AbeA3X70 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2018 18:59:26 -0500
Received: by mail-qt0-f193.google.com with SMTP id z10so19672675qti.5
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2018 15:59:26 -0800 (PST)
In-Reply-To: <20180130235903.5316-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

During link bounce testing in a point-to-point topology, the
host may enter a soft lockup on the lpfc_worker thread:
    Call Trace:
     lpfc_work_done+0x1f3/0x1390 [lpfc]
     lpfc_do_work+0x16f/0x180 [lpfc]
     kthread+0xc7/0xe0
     ret_from_fork+0x3f/0x70

The driver was simultaneously setting a combination of flags
that caused lpfc_do_work()to effectively spin between slow path
work and new event data, causing the lockup.

Ensure in the typical wq completions, that new event data flags
are set if the slow path flag is running. The slow path will
eventually reschedule the wq handling.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b159a5c4e388..9265906d956e 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -696,8 +696,9 @@ lpfc_work_done(struct lpfc_hba *phba)
 		      phba->hba_flag & HBA_SP_QUEUE_EVT)) {
 		if (pring->flag & LPFC_STOP_IOCB_EVENT) {
 			pring->flag |= LPFC_DEFERRED_RING_EVENT;
-			/* Set the lpfc data pending flag */
-			set_bit(LPFC_DATA_READY, &phba->data_flags);
+			/* Preserve legacy behavior. */
+			if (!(phba->hba_flag & HBA_SP_QUEUE_EVT))
+				set_bit(LPFC_DATA_READY, &phba->data_flags);
 		} else {
 			if (phba->link_state >= LPFC_LINK_UP ||
 			    phba->link_flag & LS_MDS_LOOPBACK) {
-- 
2.13.1
