From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] fcoe: add missing destroy_workqueue() on error in fcoe_init()
Date: Fri, 20 Dec 2013 10:53:17 +0800
Message-ID: <CAPgLHd_z4NKyt2tw1rv6EmKDY9JWHt7mK2pOpH_N8RWv9psPiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:54997 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab3LTCxS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2013 21:53:18 -0500
Received: by mail-bk0-f43.google.com with SMTP id mz12so1006752bkb.30
        for <linux-scsi@vger.kernel.org>; Thu, 19 Dec 2013 18:53:17 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: robert.w.love@intel.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing destroy_workqueue() before return from
fcoe_init() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/fcoe/fcoe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index f317000..0f2e497 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2623,7 +2623,7 @@ static int __init fcoe_init(void)
 	if (rc) {
 		printk(KERN_ERR "failed to register an fcoe transport, check "
 			"if libfcoe is loaded\n");
-		return rc;
+		goto out_destroy_wq;
 	}
 
 	mutex_lock(&fcoe_config_mutex);
@@ -2656,6 +2656,7 @@ out_free:
 		fcoe_percpu_thread_destroy(cpu);
 	}
 	mutex_unlock(&fcoe_config_mutex);
+out_destroy_wq:
 	destroy_workqueue(fcoe_wq);
 	return rc;
 }

