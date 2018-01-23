From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH] qla2xxx: Fix memory corruption during hba reset test
Date: Tue, 23 Jan 2018 11:05:21 -0800
Message-ID: <20180123190521.11382-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0061.outbound.protection.outlook.com ([104.47.37.61]:47520
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751530AbeAWTF3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jan 2018 14:05:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

This patch fixes memory corrpution while performing
HBA Reset test.

Following stack trace is seen

[  466.397219] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
[  466.433669] IP: [<ffffffffc06f5dd0>] qlt_free_session_done+0x260/0x5f0 [qla2xxx]
[  466.467731] PGD 0
[  466.476718] Oops: 0000 [#1] SMP

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
Hi Martin, 

This patch fixes the crash for HBA reset test. From core dump analysis,
memory corruption was discoverd during session cleanup. To prevent this
memory corruption, driver needs to wait for session to be deleted and 
all memory associated with the session released before it can relogin and 
create new session.

Please apply this patch to 4.16/scsi-queue at your earliest convenience.

Thanks,
Himanshu
---
 drivers/scsi/qla2xxx/qla_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 12ee6e02d146..afcb5567998a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3625,6 +3625,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	}
 	qla2x00_wait_for_hba_ready(base_vha);
 
+	qla2x00_wait_for_sess_deletion(base_vha);
+
 	/*
 	 * if UNLOAD flag is already set, then continue unload,
 	 * where it was set first.
-- 
2.12.0
