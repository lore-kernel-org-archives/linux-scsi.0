From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] mpt fusion: fix error return code in mptfc_probe()
Date: Sun, 14 Apr 2013 09:47:20 +0800
Message-ID: <CAPgLHd_cdqrLSeQLrbGT3703V644UtRE4_sAuGMfnEWQEs+avg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:34335 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab3DNBrW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Apr 2013 21:47:22 -0400
Received: by mail-bk0-f49.google.com with SMTP id w12so1867365bku.22
        for <linux-scsi@vger.kernel.org>; Sat, 13 Apr 2013 18:47:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com
Cc: yongjun_wei@trendmicro.com.cn, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/message/fusion/mptfc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index fd75108..b1b3ea3 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1328,8 +1328,10 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		 "mptfc_wq_%d", sh->host_no);
 	ioc->fc_rescan_work_q =
 		create_singlethread_workqueue(ioc->fc_rescan_work_q_name);
-	if (!ioc->fc_rescan_work_q)
+	if (!ioc->fc_rescan_work_q) {
+		error = -ENOMEM;
 		goto out_mptfc_probe;
+	}
 
 	/*
 	 *  Pre-fetch FC port WWN and stuff...

