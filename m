From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] csiostor: fix error return code in csio_hw_init()
Date: Fri, 15 Mar 2013 17:25:55 +0800
Message-ID: <CAPgLHd8QYmq+yER87eonRwb=hpGmuzy1oWSMB+RfHxQMVZ2BXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:41428 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3COJZ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Mar 2013 05:25:58 -0400
Received: by mail-bk0-f41.google.com with SMTP id q16so1409661bkw.28
        for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2013 02:25:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, naresh@chelsio.com, davem@davemloft.net, jj@chaosbits.net, arvindb@chelsio.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/csiostor/csio_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index a0b4c89..d10afeb 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -4036,6 +4036,7 @@ csio_hw_init(struct csio_hw *hw)
 		evt_entry = kzalloc(sizeof(struct csio_evt_msg), GFP_KERNEL);
 		if (!evt_entry) {
 			csio_err(hw, "Failed to initialize eventq");
+			rv = -ENOMEM;
 			goto err_evtq_cleanup;
 		}
 

