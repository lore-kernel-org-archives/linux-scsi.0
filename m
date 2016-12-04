From: Pan Bian <bianpan201604@163.com>
Subject: [PATCH 1/1] scsi: fnic: fix improper return value
Date: Sun,  4 Dec 2016 13:58:28 +0800
Message-ID: <1480831108-5140-1-git-send-email-bianpan201604@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-scsi@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

When the calls to mempool_create_slab_pool() return unexpected values,
the value of return variable err is 0. 0 means no error. Thus, the
caller of fnic_probe() cannot detect the error, and may be misled. This
patch fixes the bug, assigning "-ENOMEM" to err before calling
mempool_create_slab_pool().

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=189051

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/fnic/fnic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 58ce902..389c13e 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -735,6 +735,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < FNIC_IO_LOCKS; i++)
 		spin_lock_init(&fnic->io_req_lock[i]);
 
+	err = -ENOMEM;
 	fnic->io_req_pool = mempool_create_slab_pool(2, fnic_io_req_cache);
 	if (!fnic->io_req_pool)
 		goto err_out_free_resources;
-- 
1.9.1
