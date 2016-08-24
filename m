From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 3/3] be2iscsi: Add missing unlock for mbox_lock
Date: Wed, 24 Aug 2016 15:03:15 +0530
Message-ID: <1472031195-14556-4-git-send-email-jitendra.bhivare@broadcom.com>
References: <1472031195-14556-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35958 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754432AbcHXJgN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2016 05:36:13 -0400
Received: by mail-pf0-f173.google.com with SMTP id h186so5200181pfg.3
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2016 02:36:12 -0700 (PDT)
In-Reply-To: <1472031195-14556-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, julia.lawall@lip6.fr, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Julia pointed out beiscsi_boot_get_sinfo does not unlock
mbox_lock on nonemb_cmd memory allocation failure.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_mgmt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index b9ff939..aebc4dd 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1085,8 +1085,10 @@ unsigned int beiscsi_boot_get_sinfo(struct beiscsi_hba *phba)
 	nonemb_cmd->va = pci_alloc_consistent(phba->ctrl.pdev,
 					      sizeof(nonemb_cmd->size),
 					      &nonemb_cmd->dma);
-	if (!nonemb_cmd->va)
+	if (!nonemb_cmd->va) {
+		mutex_unlock(&ctrl->mbox_lock);
 		return 0;
+	}
 
 	req = nonemb_cmd->va;
 	memset(req, 0, sizeof(*req));
-- 
1.9.1

