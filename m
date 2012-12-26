From: vinholikatti@gmail.com
Subject: [PATCH V5 4/4] [SCSI] ufs: Correct the expected data transfer size
Date: Thu, 27 Dec 2012 01:45:55 +0530
Message-ID: <50db5b15.644e420a.0ead.ffffbbae@mx.google.com>
References: <1356552955-18027-1-git-send-email-y>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45127 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2LZUQW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Dec 2012 15:16:22 -0500
Received: by mail-pb0-f50.google.com with SMTP id wz7so4976999pbc.23
        for <linux-scsi@vger.kernel.org>; Wed, 26 Dec 2012 12:16:22 -0800 (PST)
In-Reply-To: <1356552955-18027-1-git-send-email-y>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, Vinayak Holikatti <vinholikatti@gmail.com>

From: Vinayak Holikatti <vinholikatti@gmail.com>

This patch corrects the expected data transfer size of the
command UPIU. The current implementation of cmd->transfersize
is wrong as it probably equal to sector size. With this
implementation the transfer size is updated correctly

Reported-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5d2d9e6..933338e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -478,7 +478,7 @@ static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
 		ucd_cmd_ptr->header.dword_2 = 0;
 
 		ucd_cmd_ptr->exp_data_transfer_len =
-			cpu_to_be32(lrbp->cmd->transfersize);
+			cpu_to_be32(lrbp->cmd->sdb.length);
 
 		memcpy(ucd_cmd_ptr->cdb,
 		       lrbp->cmd->cmnd,
-- 
1.7.5.4

