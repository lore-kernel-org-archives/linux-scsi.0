From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] mvsas: fix command_active typo
Date: Wed, 16 Nov 2016 16:08:34 +0100
Message-ID: <20161116150855.3083872-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>, Arnd Bergmann <arnd@arndb.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

gcc-7 notices that the condition in mvs_94xx_command_active looks
suspicious:

drivers/scsi/mvsas/mv_94xx.c: In function 'mvs_94xx_command_active':
drivers/scsi/mvsas/mv_94xx.c:671:15: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]

This was introduced when the mv_printk() statement got added,
and leads to the condition being ignored. This is probably harmless.

Changing '&&' to '&' makes the code look reasonable, as we check the
command bit before setting and printing it.

Fixes: a4632aae8b66 ("[SCSI] mvsas: Add new macros and functions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/mvsas/mv_94xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 4c57d9abce7b..7de5d8d75480 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -668,7 +668,7 @@ static void mvs_94xx_command_active(struct mvs_info *mvi, u32 slot_idx)
 {
 	u32 tmp;
 	tmp = mvs_cr32(mvi, MVS_COMMAND_ACTIVE+(slot_idx >> 3));
-	if (tmp && 1 << (slot_idx % 32)) {
+	if (tmp & 1 << (slot_idx % 32)) {
 		mv_printk("command active %08X,  slot [%x].\n", tmp, slot_idx);
 		mvs_cw32(mvi, MVS_COMMAND_ACTIVE + (slot_idx >> 3),
 			1 << (slot_idx % 32));
-- 
2.9.0
