From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 1/3] scsi: ibmvfc: constify vio_device_id
Date: Thu, 17 Aug 2017 19:15:05 +0530
Message-ID: <1502977507-2954-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tyreld@linux.vnet.ibm.com, paulus@samba.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mpe@ellerman.id.au
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

vio_device_id are not supposed to change at runtime. All functions
working with vio_device_id provided by <asm/vio.h> work with
const vio_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index cc4e05b..87d83b1 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4929,7 +4929,7 @@ static unsigned long ibmvfc_get_desired_dma(struct vio_dev *vdev)
 	return pool_dma + ((512 * 1024) * driver_template.cmd_per_lun);
 }
 
-static struct vio_device_id ibmvfc_device_table[] = {
+static const struct vio_device_id ibmvfc_device_table[] = {
 	{"fcp", "IBM,vfc-client"},
 	{ "", "" }
 };
-- 
2.7.4
