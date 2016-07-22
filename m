From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] ibmvscsis: Use list_move_tail instead of list_del/list_add_tail
Date: Fri, 22 Jul 2016 14:03:46 +0000
Message-ID: <1469196226-17333-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35501 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbcGVOD4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2016 10:03:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G . Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Using list_move_tail() instead of list_del() + list_add_tail().

Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index b29fef9..7e873a7 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3697,8 +3697,7 @@ static void ibmvscsis_release_cmd(struct se_cmd *se_cmd)
 
 	spin_lock_bh(&vscsi->intr_lock);
 	/* Remove from active_q */
-	list_del(&cmd->list);
-	list_add_tail(&cmd->list, &vscsi->waiting_rsp);
+	list_move_tail(&cmd->list, &vscsi->waiting_rsp);
 	ibmvscsis_send_messages(vscsi);
 	spin_unlock_bh(&vscsi->intr_lock);
 }



