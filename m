From: <iari@itu.dk>
Subject: [PATCH] Fix: scsi: megaraid: reduce the scope of pending-list lock to avoid double lock
Date: Mon, 17 Oct 2016 09:30:06 +0200
Message-ID: <1476689406-31316-1-git-send-email-iari@itu.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db5eur01on0099.outbound.protection.outlook.com ([104.47.2.99]:64160
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757617AbcJQRE5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 13:04:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, Iago Abal <mail@iagoabal.eu>

From: Iago Abal <mail@iagoabal.eu>

The EBA code analyzer (https://github.com/models-team/eba) reported
the following double lock:

    1. In function `megaraid_reset_handler' at 2571;
    2. take `&adapter->pend_list_lock' for the first time at 2602:

           // FIRST
           spin_lock_irqsave(PENDING_LIST_LOCK(adapter), flags);

    3. enter the `list_for_each_entry_safe' loop at 2603;
    4. call `megaraid_mbox_mm_done' at 2616;
    5. call `megaraid_mbox_runpendq' at 3782;
    6. take `&adapter->pend_list_lock' for the second time at 1892:

           // SECOND: DOUBLE LOCK !!!
           spin_lock_irqsave(PENDING_LIST_LOCK(adapter), flags);

>From my shallow understanding of the code (so please review carefully), I think
that it is not necessary to hold `PENDING_LIST_LOCK(adapter)' while executing
the body of the `list_for_each_entry_safe' loop. I assume this because both
`megaraid_mbox_mm_done' and `megaraid_dealloc_scb' are called from several
places where, as far as I can tell, this lock is not hold. In fact, as reported
by EBA, at some point `megaraid_mbox_mm_done' will acquire this lock again.

Fixes: c005fb4fb2d2 ("[SCSI] megaraid_{mm,mbox}: fix a bug in reset handler")
Signed-off-by: Iago Abal <mail@iagoabal.eu>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index f0987f2..7f11898 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2603,6 +2603,7 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 	list_for_each_entry_safe(scb, tmp, &adapter->pend_list, list) {
 		list_del_init(&scb->list);	// from pending list
 
+		spin_unlock_irqrestore(PENDING_LIST_LOCK(adapter), flags);
 		if (scb->sno >= MBOX_MAX_SCSI_CMDS) {
 			con_log(CL_ANN, (KERN_WARNING
 			"megaraid: IOCTL packet with %d[%d:%d] being reset\n",
@@ -2630,6 +2631,7 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 
 			megaraid_dealloc_scb(adapter, scb);
 		}
+		spin_lock_irqsave(PENDING_LIST_LOCK(adapter), flags);
 	}
 	spin_unlock_irqrestore(PENDING_LIST_LOCK(adapter), flags);
 
-- 
1.9.1

