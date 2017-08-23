From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 10/14] megaraid_sas: Return pended IOCTLs with cmd_status MFI_STAT_WRONG_STATE in case adapter is dead
Date: Wed, 23 Aug 2017 04:47:04 -0700
Message-ID: <1503488828-2242-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:37560 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753929AbdHWLsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 07:48:01 -0400
Received: by mail-pg0-f53.google.com with SMTP id y129so6245699pgy.4
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 04:48:01 -0700 (PDT)
In-Reply-To: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, stable@vger.kernel.org

Fix - After a kill adapter, since the cmd_status is not set the
IOCTLs will be hung in driver resulting in application hang.
Set cmd_status MFI_STAT_WRONG_STATE when completing pended IOCTLs.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6b715bb..a949a21 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1996,9 +1996,12 @@ static void megasas_complete_outstanding_ioctls(struct megasas_instance *instanc
 			if (cmd_fusion->sync_cmd_idx != (u32)ULONG_MAX) {
 				cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
 				if (cmd_mfi->sync_cmd &&
-					cmd_mfi->frame->hdr.cmd != MFI_CMD_ABORT)
+				    (cmd_mfi->frame->hdr.cmd != MFI_CMD_ABORT)) {
+					cmd_mfi->frame->hdr.cmd_status =
+							MFI_STAT_WRONG_STATE;
 					megasas_complete_cmd(instance,
 							     cmd_mfi, DID_OK);
+				}
 			}
 		}
 	} else {
-- 
1.8.3.1
