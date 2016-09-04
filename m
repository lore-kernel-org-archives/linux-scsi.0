From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] [SCSI] aacraid: mark aac_src_select_comm() static
Date: Sun,  4 Sep 2016 14:47:10 +0800
Message-ID: <1472971630-4765-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34701 "EHLO
        mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbcIDGru (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Sep 2016 02:47:50 -0400
Received: by mail-pa0-f41.google.com with SMTP id to9so14220270pac.1
        for <linux-scsi@vger.kernel.org>; Sat, 03 Sep 2016 23:47:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn

We get 1 warning when building kernel with W=1:
drivers/scsi/aacraid/src.c:616:5: warning: no previous prototype for 'aac_src_select_comm' [-Wmissing-prototypes]

In fact, this function is only used in the file in which it is
declared and don't need a declaration, but can be made static.
so this patch marks this function with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/aacraid/src.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 28f8b8a..0c45388 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -613,7 +613,7 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled)
  *	@dev: Adapter
  *	@comm: communications method
  */
-int aac_src_select_comm(struct aac_dev *dev, int comm)
+static int aac_src_select_comm(struct aac_dev *dev, int comm)
 {
 	switch (comm) {
 	case AAC_COMM_MESSAGE:
-- 
2.7.4

