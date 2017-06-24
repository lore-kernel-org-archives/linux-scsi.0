From: Zang Leigang <zangleigang@hisilicon.com>
Subject: [PATCH] scsi: ufs: set host_byte to DID_REQUEUE when ocs = OCS_ABORTED
Date: Sat, 24 Jun 2017 18:27:22 +0800
Message-ID: <20170624102722.4050-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:8836 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbdFXK2I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jun 2017 06:28:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

Host set ocs to OCS_ABORTED when clear a doorbell in err handler.
Then scsi_decide_disposition return SUCCESS. This may cause some
filesystem panic because a FAILED REQUESET. Requeue and complete is
better.

Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ffe8d8608818..e050dcea1bea 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4545,8 +4545,6 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		}
 		break;
 	case OCS_ABORTED:
-		result |= DID_ABORT << 16;
-		break;
 	case OCS_INVALID_COMMAND_STATUS:
 		result |= DID_REQUEUE << 16;
 		break;
-- 
2.13.0
