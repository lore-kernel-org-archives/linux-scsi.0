From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] hpsa: fix return value check in start_controller_lockup_detector()
Date: Tue, 29 Oct 2013 14:43:56 +0800
Message-ID: <CAPgLHd8NoumfDWXN7fqDucWJ7Nr0KppW=24sCJpn9ynGOzLhcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:60571 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3J2Gn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 02:43:57 -0400
Received: by mail-bk0-f47.google.com with SMTP id mx12so2196630bkb.20
        for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2013 23:43:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, iss_storagedev@hp.com, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function kthread_run() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/hpsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 891c86b..f413b14 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4757,7 +4757,8 @@ static void start_controller_lockup_detector(struct ctlr_info *h)
 			kthread_run(detect_controller_lockup_thread,
 						NULL, HPSA);
 	}
-	if (!hpsa_lockup_detector) {
+	if (IS_ERR(hpsa_lockup_detector)) {
+		hpsa_lockup_detector = NULL;
 		dev_warn(&h->pdev->dev,
 			"Could not start lockup detector thread\n");
 		return;

