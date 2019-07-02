From: Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [RESEND PATCH] scsi: target/iblock: Fix overrun in WRITE SAME emulation
Date: Tue, 2 Jul 2019 22:16:38 +0300
Message-ID: <20190702191636.26481-1-r.bolshakov@yadro.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Roman Bolshakov <r.bolshakov@yadro.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

WRITE SAME corrupts data on the block device behind iblock if the
command is emulated. The emulation code issues (M - 1) * N times more
bios than requested, where M is the number of 512 blocks per real block
size and N is the NUMBER OF LOGICAL BLOCKS specified in WRITE SAME
command. So, for a device with 4k blocks, 7 * N more LBAs gets written
after the requested range.

The issue happens because the number of 512 byte sectors to be written
is decreased one by one while the real bios are typically from 1 to 8
512 byte sectors per bio.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Cc: <stable@vger.kernel.org>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_iblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index f4a075303e9a..6949ea8bc387 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -502,7 +502,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 
 		/* Always in 512 byte units for Linux/Block */
 		block_lba += sg->length >> SECTOR_SHIFT;
-		sectors -= 1;
+		sectors -= sg->length >> SECTOR_SHIFT;
 	}
 
 	iblock_submit_bios(&list);
-- 
2.22.0
