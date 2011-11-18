From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] scsi_dh_rdac: Fix error path
Date: Fri, 18 Nov 2011 01:44:27 +0100
Message-ID: <1321577067-26332-1-git-send-email-richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: Babu.moger@netapp.com, Somasundaram.Krishnasamy@lsi.com, yanling.qi@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
List-Id: linux-scsi@vger.kernel.org

If create_singlethread_workqueue() failes, rdac_init should fail too.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 1d31279..2802394 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -934,6 +934,8 @@ static int __init rdac_init(void)
 	if (!kmpath_rdacd) {
 		scsi_unregister_device_handler(&rdac_dh);
 		printk(KERN_ERR "kmpath_rdacd creation failed.\n");
+
+		r = -EINVAL;
 	}
 done:
 	return r;
-- 
1.7.7.3
