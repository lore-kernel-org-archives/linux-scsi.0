From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] scsi: ncr5380: constify pnp_device_id
Date: Wed, 16 Aug 2017 10:28:40 +0530
Message-ID: <1125161eb43bc7ee7f748a040ab06b40cc1537dd.1502859040.git.arvind.yadav.cs@gmail.com>
References: <60c34272432b3411cd5d55728c62481e133f32a6.1502859040.git.arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <60c34272432b3411cd5d55728c62481e133f32a6.1502859040.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: fthain@telegraphics.com.au, schmitzmic@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pnp_device_id are not supposed to change at runtime. All functions
working with pnp_device_id provided by <linux/pnp.h> work with
const pnp_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/g_NCR5380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index c34fc91..1968d81 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -703,7 +703,7 @@ static struct isa_driver generic_NCR5380_isa_driver = {
 };
 
 #ifdef CONFIG_PNP
-static struct pnp_device_id generic_NCR5380_pnp_ids[] = {
+static const struct pnp_device_id generic_NCR5380_pnp_ids[] = {
 	{ .id = "DTC436e", .driver_data = BOARD_DTC3181E },
 	{ .id = "" }
 };
-- 
2.7.4
