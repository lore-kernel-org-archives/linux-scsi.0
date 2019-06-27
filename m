From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 60/87] scsi: megaraid: remove memset after kcalloc
Date: Fri, 28 Jun 2019 01:44:20 +0800
Message-ID: <20190627174420.5466-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

kcalloc already zeros the memory.
memset is unneeded.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3dd1df472dc6..342b39bc9210 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4141,8 +4141,6 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 		return -ENOMEM;
 	}
 
-	memset(instance->cmd_list, 0, sizeof(struct megasas_cmd *) *max_cmd);
-
 	for (i = 0; i < max_cmd; i++) {
 		instance->cmd_list[i] = kmalloc(sizeof(struct megasas_cmd),
 						GFP_KERNEL);
-- 
2.11.0
