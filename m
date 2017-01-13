From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] scsi: qla4xxx: Remove redundant memset before memcpy
Date: Fri, 13 Jan 2017 15:51:25 +0530
Message-ID: <1484302885-26747-1-git-send-email-mayhs11saini@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34222 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdAMKVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2017 05:21:47 -0500
Received: by mail-pf0-f196.google.com with SMTP id y143so7873066pfb.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 02:21:47 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>

The region set by the call to memset, immediately overwritten by the
subsequent call to memcpy and thus makes the  memset redundant

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9fbb33f..21c1c78 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -619,7 +619,6 @@ static void qla4xxx_create_chap_list(struct scsi_qla_host *ha)
 		goto exit_chap_list;
 	}
 
-	memset(ha->chap_list, 0, chap_size);
 	memcpy(ha->chap_list, chap_flash_data, chap_size);
 
 exit_chap_list:
-- 
2.7.4

