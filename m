From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2] scsi: sd: don't crash the host on invalid commands
Date: Fri, 21 Sep 2018 09:01:01 +0200
Message-ID: <20180921070101.9260-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

When sd_init_command() get's a with a unknown req_op() it crashes the
system via BUG().

This makes debugging the actual reason for the broken request
cmd_flags pretty hard as the system is down before it's able to write
out debugging data on the serial console or the trace buffer.

Change the BUG() to a WARN_ON() and return BLKPREP_KILL to fail
gracefully and return an I/O error to the producer of the request.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>

---
Changes since v1:
- Use WARN_ON_ONCE() (Bart)
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b79b366a94f7..f2e41f04e40b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1276,7 +1276,8 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 	case REQ_OP_ZONE_RESET:
 		return sd_zbc_setup_reset_cmnd(cmd);
 	default:
-		BUG();
+		WARN_ON_ONCE(1);
+		return BLKPREP_KILL;
 	}
 }
 
-- 
2.16.4
