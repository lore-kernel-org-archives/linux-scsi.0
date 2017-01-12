From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] scsi: be2iscsi: Use GFP_ATOMIC under spin lock
Date: Thu, 12 Jan 2017 14:21:32 +0000
Message-ID: <20170112142132.14552-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33595 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdALOVm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2017 09:21:42 -0500
Received: by mail-pf0-f196.google.com with SMTP id 127so3777302pfg.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2017 06:21:41 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

A spin lock is taken here so we should use GFP_ATOMIC.

Fixes: 987132167f4b ("scsi: be2iscsi: Fix for crash in beiscsi_eh_device_reset")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 6372613..c9b9daa 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -294,7 +294,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	beiscsi_conn = conn->dd_data;
 	phba = beiscsi_conn->phba;
 
-	inv_tbl = kzalloc(sizeof(*inv_tbl), GFP_KERNEL);
+	inv_tbl = kzalloc(sizeof(*inv_tbl), GFP_ATOMIC);
 	if (!inv_tbl) {
 		spin_unlock_bh(&session->frwd_lock);
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,

