From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V1] smartpqi: raid bypass lba calculation fix
Date: Fri, 16 Sep 2016 15:01:51 -0500
Message-ID: <147405611157.22243.14980631065860596720.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0083.outbound.protection.outlook.com ([104.47.37.83]:38304
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935545AbcIPUCn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Sep 2016 16:02:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: kevin Barnett <kevin.barnett@microsemi.com>

In the ioaccel path, the calculation of the starting
LBA for READ(6)/WRITE(6) SCSI commands does not take
into account the most significant 5 bits of the
LBA: it only uses the least significant 16 bits of
the starting LBA.

Reported-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 52cfa26..a535b26 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1954,7 +1954,8 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 		is_write = true;
 		/* fall through */
 	case READ_6:
-		first_block = (u64)get_unaligned_be16(&scmd->cmnd[2]);
+		first_block = (u64)(((scmd->cmnd[1] & 0x1f) << 16) |
+			(scmd->cmnd[2] << 8) | scmd->cmnd[3]);
 		block_cnt = (u32)scmd->cmnd[4];
 		if (block_cnt == 0)
 			block_cnt = 256;

