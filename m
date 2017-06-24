From: Zang Leigang <zangleigang@hisilicon.com>
Subject: [PATCH] scsi: ufs: check link active or not after switch to HS mode
Date: Sat, 24 Jun 2017 19:44:05 +0800
Message-ID: <20170624114405.18475-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:8794 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdFXLov (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jun 2017 07:44:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

Some device can successfully link and switch to HS mode. But failed
to do more. ufshcd_verify_dev_init can help to find this earlier.

Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ffe8d8608818..eb03388fc4bd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6373,6 +6373,14 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 					__func__, ret);
 			goto out;
 		}
+
+		/*
+		 * Some device lost link after switch to HS mode. Check if
+		 * connect is established here.
+		 */
+		ret = ufshcd_verify_dev_init(hba);
+		if (ret)
+			goto out;
 	}
 
 	/* set the state as operational after switching to desired gear */
-- 
2.13.0
