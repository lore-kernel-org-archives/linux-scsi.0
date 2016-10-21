From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] sd: fix uninitialized variable access in error handling
Date: Fri, 21 Oct 2016 17:32:24 +0200
Message-ID: <20161021153246.3456962-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Jens Axboe <axboe@fb.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If sd_zbc_report_zones fails, the check for 'zone_blocks == 0'
later in the function accesses uninitialized data:

drivers/scsi/sd_zbc.c: In function ‘sd_zbc_read_zones’:
drivers/scsi/sd_zbc.c:520:7: error: ‘zone_blocks’ may be used uninitialized in this function [-Werror=maybe-uninitialized]

This sets it to zero, which has the desired effect of leaving
the sd_zbc_read_zones successfully with sdkp->zone_blocks = 0.

Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/sd_zbc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 16d3fa62d8ac..d5b3bd915d9e 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -455,8 +455,10 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 
 	/* Do a report zone to get the same field */
 	ret = sd_zbc_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, 0);
-	if (ret)
+	if (ret) {
+		zone_blocks = 0;
 		goto out;
+	}
 
 	same = buf[4] & 0x0f;
 	if (same > 0) {
-- 
2.9.0
