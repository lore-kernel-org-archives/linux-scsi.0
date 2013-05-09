From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] sd: fix error return code in sd_probe()
Date: Thu, 9 May 2013 10:00:28 +0800
Message-ID: <CAPgLHd9RQWC0zX7nnc0s_u0wQ=fnkr89cVx9AAP7H=B8gUKiCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35203 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3EICA3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 22:00:29 -0400
Received: by mail-bk0-f53.google.com with SMTP id i18so1204494bkv.40
        for <linux-scsi@vger.kernel.org>; Wed, 08 May 2013 19:00:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code in the device add error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 82910cc..99f07e92 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2944,7 +2944,8 @@ static int sd_probe(struct device *dev)
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, dev_name(dev));
 
-	if (device_add(&sdkp->dev))
+	error = device_add(&sdkp->dev);
+	if (error)
 		goto out_free_index;
 
 	get_device(dev);

