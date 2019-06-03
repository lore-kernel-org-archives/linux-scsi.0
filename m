From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] scsi: fcoe: Fix possible memleak in fcoe_if_init
Date: Mon, 3 Jun 2019 17:22:18 +0800
Message-ID: <20190603092218.15064-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.ibm.com, hare@suse.de, sedat.dilek@gmail.com, jth@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

If it fails to alloc fcoe_vport_scsi_transport in fcoe_if_init,
we should check the err and free allocted fcoe_nport_scsi_transport.
Also return ENOMEM instead of ENODEV.

Fixes: 8ca86f84dd5f ("[SCSI] fcoe: prepare fcoe for using fcoe transport")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/fcoe/fcoe.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 8ba8862..12ca0b7 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1262,12 +1262,17 @@ static int __init fcoe_if_init(void)
 	/* attach to scsi transport */
 	fcoe_nport_scsi_transport =
 		fc_attach_transport(&fcoe_nport_fc_functions);
+	if (!fcoe_nport_scsi_transport)
+		return -ENOMEM;
+
 	fcoe_vport_scsi_transport =
 		fc_attach_transport(&fcoe_vport_fc_functions);
 
-	if (!fcoe_nport_scsi_transport) {
-		printk(KERN_ERR "fcoe: Failed to attach to the FC transport\n");
-		return -ENODEV;
+	if (!fcoe_vport_scsi_transport) {
+		pr_err("fcoe: Failed to attach to the FC transport\n");
+		fc_release_transport(fcoe_nport_scsi_transport);
+		fcoe_nport_scsi_transport = NULL;
+		return -ENOMEM;
 	}
 
 	return 0;
-- 
1.8.3.1
