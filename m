From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Revert "scsi: core: return BLK_STS_OK for DID_OK in __scsi_error_from_host_byte()"
Date: Wed,  4 Apr 2018 09:30:28 -0700
Message-ID: <20180404163028.9826-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Douglas Gilbert <dgilbert@interlog.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The description of commit e39a97353e53 is wrong: it mentions that
commit 2a842acab109 introduced a bug in __scsi_error_from_host_byte()
although that commit did not change the behavior of that function.
Additionally, that commit introduced a severe bug: it causes commands
that fail with hostbyte=DID_OK and driverbyte=DRIVER_SENSE to be
completed with BLK_STS_OK. Although that commit claims to fix a bug
it does not mention which bug it fixes. Hence revert that commit.

Fixes: e39a97353e53 ("scsi: core: return BLK_STS_OK for DID_OK in __scsi_error_from_host_byte()")
Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
---
 drivers/scsi/scsi_lib.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 74a39db57d49..71f5b010684c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -735,8 +735,6 @@ static blk_status_t __scsi_error_from_host_byte(struct scsi_cmnd *cmd,
 		int result)
 {
 	switch (host_byte(result)) {
-	case DID_OK:
-		return BLK_STS_OK;
 	case DID_TRANSPORT_FAILFAST:
 		return BLK_STS_TRANSPORT;
 	case DID_TARGET_FAILURE:
-- 
2.16.2
