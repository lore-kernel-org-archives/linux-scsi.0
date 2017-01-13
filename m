From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] scsi: bfa: Remove redundant memset before memcpy
Date: Fri, 13 Jan 2017 16:06:57 +0530
Message-ID: <1484303817-948-1-git-send-email-mayhs11saini@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36158 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbdAMKhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2017 05:37:12 -0500
Received: by mail-pf0-f195.google.com with SMTP id b22so7885090pfd.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 02:37:12 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil.gurumurthy@qlogic.com
Cc: sudarsana.kalluru@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>

The region set by the call to memset, immediately overwritten by the
subsequent call to memcpy and thus makes the  memset redundant

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/scsi/bfa/bfa_ioc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index a1ada4a..a3aa8d3 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2763,7 +2763,6 @@ bfa_ioc_get_type(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num)
 {
-	memset((void *)serial_num, 0, BFA_ADAPTER_SERIAL_NUM_LEN);
 	memcpy((void *)serial_num,
 			(void *)ioc->attr->brcd_serialnum,
 			BFA_ADAPTER_SERIAL_NUM_LEN);
-- 
2.7.4

