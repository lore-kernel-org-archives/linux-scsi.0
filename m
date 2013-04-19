From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] scsi_transport_iscsi: fix error return code in iscsi_transport_init()
Date: Fri, 19 Apr 2013 09:23:28 +0800
Message-ID: <CAPgLHd_o7fK8G8_T7Q=S0=XWkgR=g7qWE5uGhHv=bz4BxhB0zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:55325 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967641Ab3DSB3g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Apr 2013 21:29:36 -0400
Received: by mail-bk0-f45.google.com with SMTP id j10so1514794bkw.32
        for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2013 18:29:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the create workqueue error case
instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 47799a3..475265a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3985,8 +3985,10 @@ static __init int iscsi_transport_init(void)
 	}
 
 	iscsi_eh_timer_workq = create_singlethread_workqueue("iscsi_eh");
-	if (!iscsi_eh_timer_workq)
+	if (!iscsi_eh_timer_workq) {
+		err = -ENOMEM;
 		goto release_nls;
+	}
 
 	return 0;
 

