From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] mpt fusion: fix error return code in mptfc_probe()
Date: Sat, 10 Sep 2016 16:06:36 +0000
Message-ID: <1473523596-6768-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35085 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755145AbcIJQGp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Sep 2016 12:06:45 -0400
Received: by mail-pa0-f65.google.com with SMTP id pp5so5365477pac.2
        for <linux-scsi@vger.kernel.org>; Sat, 10 Sep 2016 09:06:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENOMEM from the workqueue alloc error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/message/fusion/mptfc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 129e132..add6a3a 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1326,8 +1326,10 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->fc_rescan_work_q =
 		alloc_ordered_workqueue(ioc->fc_rescan_work_q_name,
 					WQ_MEM_RECLAIM);
-	if (!ioc->fc_rescan_work_q)
+	if (!ioc->fc_rescan_work_q) {
+		error = -ENOMEM;
 		goto out_mptfc_probe;
+	}
 
 	/*
 	 *  Pre-fetch FC port WWN and stuff...

