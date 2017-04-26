From: Heloise <os@iscas.ac.cn>
Subject: [PATCH] mpt3sas_base:fix memory leak in _base_request_irq
Date: Tue, 25 Apr 2017 20:11:43 -0700
Message-ID: <1493176303-9491-1-git-send-email-os@iscas.ac.cn>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:42166 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1434766AbdDZDUO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 23:20:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Heloise <os@iscas.ac.cn>

Signed-off-by: Heloise <os@iscas.ac.cn>

In function _base_request_irq, variable reply_q applies for memory
space 'reply_q=kzalloc()', but does not release it before the function
returns, fix it.
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 5b7aec5..801dfab 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1884,6 +1884,7 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
 
 	INIT_LIST_HEAD(&reply_q->list);
 	list_add_tail(&reply_q->list, &ioc->reply_queue_list);
+	kfree(reply_q);
 	return 0;
 }
 
-- 
2.1.0
