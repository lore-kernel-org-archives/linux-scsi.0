From: Zang Leigang <zangleigang@hisilicon.com>
Subject: [PATCH] scsi: ufs: remove unnecessary UFSHCD_STATE_ERROR set
Date: Tue, 15 Nov 2016 20:25:33 +0800
Message-ID: <20161115122533.75266-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:32721 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932643AbcKOM0J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 07:26:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

We set ufshcd_state to UFSHCD_STATE_ERROR when an err handler
fails. So I think UFSHCD_STATE_ERROR means host not works any more.
Set it before schedule eh_work is not correct.

Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 05c7456..a7724ad 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4158,7 +4158,6 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 			/* block commands from scsi mid-layer */
 			scsi_block_requests(hba->host);
 
-			hba->ufshcd_state = UFSHCD_STATE_ERROR;
 			schedule_work(&hba->eh_work);
 		}
 	}
-- 
2.9.3

