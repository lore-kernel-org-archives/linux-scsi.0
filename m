From: mchristi@redhat.com
Subject: [PATCH 1/2] scsi: fix max discard sectors calculation
Date: Mon, 16 May 2016 13:46:49 -0500
Message-ID: <1463424410-17196-2-git-send-email-mchristi@redhat.com>
References: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, socketpair@gmail.com
Cc: Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

logical_block_size and max_blocks are 32 bits, so we can
overflow when trying to convert SCSI device blocks to linux
block layer sectors.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f52b74c..1668e1d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -690,7 +690,8 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		break;
 	}
 
-	blk_queue_max_discard_sectors(q, max_blocks * (logical_block_size >> 9));
+	blk_queue_max_discard_sectors(q, (u64)max_blocks *
+				      (logical_block_size >> 9));
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 }
 
-- 
2.7.2
