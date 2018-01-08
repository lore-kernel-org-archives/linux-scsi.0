From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: [PATCH] scsi: mptfusion: use strlcpy() instead of strncpy()
Date: Mon, 8 Jan 2018 20:49:13 +0800
Message-ID: <1515415753-10534-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:3701 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757235AbeAHMoB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jan 2018 07:44:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: suganath-prabu.subramani@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com, arnd@arndb.de

From: Xiongfeng Wang <xiongfeng.wang@linaro.org>

gcc-8 reports

drivers/message/fusion/mptbase.c: In function 'mpt_display_event_info':
./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
bound 100 equals destination size [-Wstringop-truncation]

We need to use strlcpy() to make sure the dest string is
nul-terminated.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 drivers/message/fusion/mptbase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 7a93400..3c47888 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -7697,7 +7697,7 @@ static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int
 		break;
 	}
 	if (ds)
-		strncpy(evStr, ds, EVENT_DESCR_STR_SZ);
+		strlcpy(evStr, ds, EVENT_DESCR_STR_SZ);
 
 
 	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-- 
1.8.3.1
