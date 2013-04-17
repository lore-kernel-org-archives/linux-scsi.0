From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] mvumi: fix error return code in mvumi_io_attach()
Date: Thu, 18 Apr 2013 07:44:29 +0800
Message-ID: <CAPgLHd9JmcRFfYYb-1Es3zshWAXtKm0kNuaJrFku5XCD9n8AbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42742 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab3DQXob (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 19:44:31 -0400
Received: by mail-bk0-f52.google.com with SMTP id it16so1002385bkc.11
        for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2013 16:44:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/mvumi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 4594cca..c347374 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2480,6 +2480,7 @@ static int mvumi_io_attach(struct mvumi_hba *mhba)
 		dev_err(&mhba->pdev->dev,
 			"failed to create device scan thread\n");
 		mutex_unlock(&mhba->sas_discovery_mutex);
+		ret = PTR_ERR(mhba->dm_thread);
 		goto fail_create_thread;
 	}
 	atomic_set(&mhba->pnp_count, 1);

