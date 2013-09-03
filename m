From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH] scsi: ufs: replace the deprecated flush_work_sync
Date: Tue, 03 Sep 2013 16:59:43 +0900
Message-ID: <005501cea87b$8cc5a550$a650eff0$%jun@samsung.com>
References: <60A4377E7BEE4B2EA7855F9701B34BF0@chingDT>
 <1377512423.20958.7.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45158 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab3ICH7p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2013 03:59:45 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSJ00HP0I7J07H0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 03 Sep 2013 16:59:43 +0900 (KST)
In-reply-to: 
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'linux-scsi' <linux-scsi@vger.kernel.org>
Cc: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Tejun Heo' <tj@kernel.org>, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>

flush_work_sync is replaced by flush_work with commit
4382973(workqueue: deprecate flush[_delayed]_work_sync()).

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a0f5ac2..1b99c0a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2737,7 +2737,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 			break;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		dev_dbg(hba->dev, "%s: reset in progress\n", __func__);
-		flush_work_sync(&hba->eh_work);
+		flush_work(&hba->eh_work);
 	} while (1);
 
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
-- 
1.7.0.4


