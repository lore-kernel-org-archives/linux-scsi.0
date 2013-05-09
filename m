From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] fnic: fix error return code in fnic_probe()
Date: Thu, 9 May 2013 10:01:24 +0800
Message-ID: <CAPgLHd-1miXKWz4_=GmgauPEWq3sDh03zhacqGr30j07=2LUZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:58679 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab3EICBZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 22:01:25 -0400
Received: by mail-bk0-f45.google.com with SMTP id je9so1198683bkc.4
        for <linux-scsi@vger.kernel.org>; Wed, 08 May 2013 19:01:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hiralpat@cisco.com, sramars@cisco.com, buchino@cisco.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the mempool_create_slab_pool() error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/fnic/fnic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 5f09d18..0523322 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -605,6 +605,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < FNIC_IO_LOCKS; i++)
 		spin_lock_init(&fnic->io_req_lock[i]);
 
+	err = -ENOMEM;
 	fnic->io_req_pool = mempool_create_slab_pool(2, fnic_io_req_cache);
 	if (!fnic->io_req_pool)
 		goto err_out_free_resources;

