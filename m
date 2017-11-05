From: Pan Bian <bianpan2016@163.com>
Subject: [PATCH] scsi: advansys: fix improper function call to kfree
Date: Sun,  5 Nov 2017 22:30:12 +0800
Message-ID: <1509892212-10489-1-git-send-email-bianpan2016@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-scsi@vger.kernel.org

In function advansys_eisa_probe(), data->host[i] holds the return value
of scsi_host_alloc(). The memory allocated by scsi_host_alloc() should
be deallocated with scsi_host_put(), not kfree().

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/advansys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 24e57e7..1f56a6d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11678,8 +11678,8 @@ static int advansys_eisa_probe(struct device *dev)
 	return 0;
 
  free_data:
-	kfree(data->host[0]);
-	kfree(data->host[1]);
+	scsi_host_put(data->host[0]);
+	scsi_host_put(data->host[1]);
 	kfree(data);
  fail:
 	return err;
-- 
1.9.1
