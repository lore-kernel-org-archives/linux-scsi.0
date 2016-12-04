From: Pan Bian <bianpan201604@163.com>
Subject: [PATCH 1/1] scsi: snic: fix improper return value
Date: Sun,  4 Dec 2016 14:02:41 +0800
Message-ID: <1480831361-5234-1-git-send-email-bianpan201604@163.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:58765 "EHLO m50-132.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751110AbcLDGE3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 4 Dec 2016 01:04:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>

From: Pan Bian <bianpan2016@163.com>

When the calls to mempool_create_slab_pool() return unexpected values,
the value of return variable ret is 0. 0 means no error. Thus, the
caller of fnic_probe() cannot detect the error, and may be misled. This
patch fixes the bug, assigning "-ENOMEM" to ret before calling
mempool_create_slab_pool().

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=189061

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/snic/snic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 396b32d..e8907e6 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -586,6 +586,7 @@
 	for (i = 0; i < SNIC_IO_LOCKS; i++)
 		spin_lock_init(&snic->io_req_lock[i]);
 
+	ret = -ENOMEM;
 	pool = mempool_create_slab_pool(2,
 				snic_glob->req_cache[SNIC_REQ_CACHE_DFLT_SGL]);
 	if (!pool) {
-- 
1.9.1


