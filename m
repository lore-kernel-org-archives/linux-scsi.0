From: Fam Zheng <famz@redhat.com>
Subject: [PATCH 3/3] sd: Return -EIO if read capacity failed
Date: Tue, 24 Mar 2015 18:16:15 +0800
Message-ID: <1427192175-23802-4-git-send-email-famz@redhat.com>
References: <1427192175-23802-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427192175-23802-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, famz@redhat.com
List-Id: linux-scsi@vger.kernel.org

This improves the error code if BLKRRPART ioctl failed due to connection
issue.

Before:

	$ blockdev --rereadpt /dev/sda
	BLKRRPART: Invalid argument

After:
	$ blockdev --rereadpt /dev/sda
	BLKRRPART: Input/output error

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7e5ca3b..bb0e38d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2019,7 +2019,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
 		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
-		return -EINVAL;
+		return -EIO;
 	}
 
 	sector_size = get_unaligned_be32(&buffer[8]);
@@ -2101,7 +2101,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
 		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
-		return -EINVAL;
+		return -EIO;
 	}
 
 	sector_size = get_unaligned_be32(&buffer[4]);
-- 
1.9.3
