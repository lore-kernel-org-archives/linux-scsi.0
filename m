From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 3/5] scsi_debug: do_device_access, add sg offset argument
Date: Wed, 13 Dec 2017 20:40:14 -0500
Message-ID: <20171214014016.13142-4-dgilbert@interlog.com>
References: <20171214014016.13142-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40153 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751091AbdLNBkX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 20:40:23 -0500
In-Reply-To: <20171214014016.13142-1-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, bart.vanassche@sandisk.com, hare@suse.de

WRITE SCATTERED needs to take several "bites" out of the data-out buffer.
Expand the do_device_access() function to take a sg_skip argument.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 428165dbd486..4cd703f0aac0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2353,8 +2353,8 @@ static int check_device_access_params(struct scsi_cmnd *scp,
 }
 
 /* Returns number of bytes copied or -1 if error. */
-static int do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num,
-			    bool do_write)
+static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
+			    u32 num, bool do_write)
 {
 	int ret;
 	u64 block, rest = 0;
@@ -2380,14 +2380,15 @@ static int do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num,
 
 	ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
 		   fake_storep + (block * sdebug_sector_size),
-		   (num - rest) * sdebug_sector_size, 0, do_write);
+		   (num - rest) * sdebug_sector_size, sg_skip, do_write);
 	if (ret != (num - rest) * sdebug_sector_size)
 		return ret;
 
 	if (rest) {
 		ret += sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
 			    fake_storep, rest * sdebug_sector_size,
-			    (num - rest) * sdebug_sector_size, do_write);
+			    sg_skip + ((num - rest) * sdebug_sector_size),
+			    do_write);
 	}
 
 	return ret;
@@ -2648,7 +2649,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		}
 	}
 
-	ret = do_device_access(scp, lba, num, false);
+	ret = do_device_access(scp, 0, lba, num, false);
 	read_unlock_irqrestore(&atomic_rw, iflags);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
@@ -2936,7 +2937,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		}
 	}
 
-	ret = do_device_access(scp, lba, num, true);
+	ret = do_device_access(scp, 0, lba, num, true);
 	if (unlikely(scsi_debug_lbp()))
 		map_region(lba, num);
 	write_unlock_irqrestore(&atomic_rw, iflags);
@@ -3177,7 +3178,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	 * from data-in into arr. Safe (atomic) since write_lock held. */
 	fake_storep_hold = fake_storep;
 	fake_storep = arr;
-	ret = do_device_access(scp, 0, dnum, true);
+	ret = do_device_access(scp, 0, 0, dnum, true);
 	fake_storep = fake_storep_hold;
 	if (ret == -1) {
 		retval = DID_ERROR << 16;
-- 
2.14.1
