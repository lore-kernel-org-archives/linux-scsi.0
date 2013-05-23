From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 part1 2/4] sg_io: prepare to introduce per-class command filters
Date: Thu, 23 May 2013 15:58:21 +0200
Message-ID: <1369317503-4095-3-git-send-email-pbonzini@redhat.com>
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, stable@gnu.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

To prepare for the next patches, abstract setting of an entry in the
command filter behind a macro.

The next patch will change the implementation of the macro.

Cc: stable@gnu.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c | 148 +++++++++++++++++++++++++++--------------------------
 1 file changed, 76 insertions(+), 72 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 96cab50..21ddf17 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -116,85 +116,89 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 
 static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 {
+#define sgio_bitmap_set(cmd, rw) \
+	__set_bit((cmd), filter->rw##_ok)
+
 	/* Basic read-only commands */
-	__set_bit(TEST_UNIT_READY, filter->read_ok);
-	__set_bit(REQUEST_SENSE, filter->read_ok);
-	__set_bit(READ_6, filter->read_ok);
-	__set_bit(READ_10, filter->read_ok);
-	__set_bit(READ_12, filter->read_ok);
-	__set_bit(READ_16, filter->read_ok);
-	__set_bit(READ_BUFFER, filter->read_ok);
-	__set_bit(READ_DEFECT_DATA, filter->read_ok);
-	__set_bit(READ_CAPACITY, filter->read_ok);
-	__set_bit(READ_LONG, filter->read_ok);
-	__set_bit(INQUIRY, filter->read_ok);
-	__set_bit(MODE_SENSE, filter->read_ok);
-	__set_bit(MODE_SENSE_10, filter->read_ok);
-	__set_bit(LOG_SENSE, filter->read_ok);
-	__set_bit(START_STOP, filter->read_ok);
-	__set_bit(GPCMD_VERIFY_10, filter->read_ok);
-	__set_bit(VERIFY_16, filter->read_ok);
-	__set_bit(REPORT_LUNS, filter->read_ok);
-	__set_bit(SERVICE_ACTION_IN, filter->read_ok);
-	__set_bit(RECEIVE_DIAGNOSTIC, filter->read_ok);
-	__set_bit(MAINTENANCE_IN, filter->read_ok);
-	__set_bit(GPCMD_READ_BUFFER_CAPACITY, filter->read_ok);
+	sgio_bitmap_set(TEST_UNIT_READY, read);
+	sgio_bitmap_set(REQUEST_SENSE, read);
+	sgio_bitmap_set(READ_6, read);
+	sgio_bitmap_set(READ_10, read);
+	sgio_bitmap_set(READ_12, read);
+	sgio_bitmap_set(READ_16, read);
+	sgio_bitmap_set(READ_BUFFER, read);
+	sgio_bitmap_set(READ_DEFECT_DATA, read);
+	sgio_bitmap_set(READ_CAPACITY, read);
+	sgio_bitmap_set(READ_LONG, read);
+	sgio_bitmap_set(INQUIRY, read);
+	sgio_bitmap_set(MODE_SENSE, read);
+	sgio_bitmap_set(MODE_SENSE_10, read);
+	sgio_bitmap_set(LOG_SENSE, read);
+	sgio_bitmap_set(START_STOP, read);
+	sgio_bitmap_set(GPCMD_VERIFY_10, read);
+	sgio_bitmap_set(VERIFY_16, read);
+	sgio_bitmap_set(REPORT_LUNS, read);
+	sgio_bitmap_set(SERVICE_ACTION_IN, read);
+	sgio_bitmap_set(RECEIVE_DIAGNOSTIC, read);
+	sgio_bitmap_set(MAINTENANCE_IN, read);
+	sgio_bitmap_set(GPCMD_READ_BUFFER_CAPACITY, read);
 
 	/* Audio CD commands */
-	__set_bit(GPCMD_PLAY_CD, filter->read_ok);
-	__set_bit(GPCMD_PLAY_AUDIO_10, filter->read_ok);
-	__set_bit(GPCMD_PLAY_AUDIO_MSF, filter->read_ok);
-	__set_bit(GPCMD_PLAY_AUDIO_TI, filter->read_ok);
-	__set_bit(GPCMD_PAUSE_RESUME, filter->read_ok);
+	sgio_bitmap_set(GPCMD_PLAY_CD, read);
+	sgio_bitmap_set(GPCMD_PLAY_AUDIO_10, read);
+	sgio_bitmap_set(GPCMD_PLAY_AUDIO_MSF, read);
+	sgio_bitmap_set(GPCMD_PLAY_AUDIO_TI, read);
+	sgio_bitmap_set(GPCMD_PAUSE_RESUME, read);
 
 	/* CD/DVD data reading */
-	__set_bit(GPCMD_READ_CD, filter->read_ok);
-	__set_bit(GPCMD_READ_CD_MSF, filter->read_ok);
-	__set_bit(GPCMD_READ_DISC_INFO, filter->read_ok);
-	__set_bit(GPCMD_READ_CDVD_CAPACITY, filter->read_ok);
-	__set_bit(GPCMD_READ_DVD_STRUCTURE, filter->read_ok);
-	__set_bit(GPCMD_READ_HEADER, filter->read_ok);
-	__set_bit(GPCMD_READ_TRACK_RZONE_INFO, filter->read_ok);
-	__set_bit(GPCMD_READ_SUBCHANNEL, filter->read_ok);
-	__set_bit(GPCMD_READ_TOC_PMA_ATIP, filter->read_ok);
-	__set_bit(GPCMD_REPORT_KEY, filter->read_ok);
-	__set_bit(GPCMD_SCAN, filter->read_ok);
-	__set_bit(GPCMD_GET_CONFIGURATION, filter->read_ok);
-	__set_bit(GPCMD_READ_FORMAT_CAPACITIES, filter->read_ok);
-	__set_bit(GPCMD_GET_EVENT_STATUS_NOTIFICATION, filter->read_ok);
-	__set_bit(GPCMD_GET_PERFORMANCE, filter->read_ok);
-	__set_bit(GPCMD_SEEK, filter->read_ok);
-	__set_bit(GPCMD_STOP_PLAY_SCAN, filter->read_ok);
+	sgio_bitmap_set(GPCMD_READ_CD, read);
+	sgio_bitmap_set(GPCMD_READ_CD_MSF, read);
+	sgio_bitmap_set(GPCMD_READ_DISC_INFO, read);
+	sgio_bitmap_set(GPCMD_READ_CDVD_CAPACITY, read);
+	sgio_bitmap_set(GPCMD_READ_DVD_STRUCTURE, read);
+	sgio_bitmap_set(GPCMD_READ_HEADER, read);
+	sgio_bitmap_set(GPCMD_READ_TRACK_RZONE_INFO, read);
+	sgio_bitmap_set(GPCMD_READ_SUBCHANNEL, read);
+	sgio_bitmap_set(GPCMD_READ_TOC_PMA_ATIP, read);
+	sgio_bitmap_set(GPCMD_REPORT_KEY, read);
+	sgio_bitmap_set(GPCMD_SCAN, read);
+	sgio_bitmap_set(GPCMD_GET_CONFIGURATION, read);
+	sgio_bitmap_set(GPCMD_READ_FORMAT_CAPACITIES, read);
+	sgio_bitmap_set(GPCMD_GET_EVENT_STATUS_NOTIFICATION, read);
+	sgio_bitmap_set(GPCMD_GET_PERFORMANCE, read);
+	sgio_bitmap_set(GPCMD_SEEK, read);
+	sgio_bitmap_set(GPCMD_STOP_PLAY_SCAN, read);
 
 	/* Basic writing commands */
-	__set_bit(WRITE_6, filter->write_ok);
-	__set_bit(WRITE_10, filter->write_ok);
-	__set_bit(WRITE_VERIFY, filter->write_ok);
-	__set_bit(WRITE_12, filter->write_ok);
-	__set_bit(WRITE_VERIFY_12, filter->write_ok);
-	__set_bit(WRITE_16, filter->write_ok);
-	__set_bit(WRITE_LONG, filter->write_ok);
-	__set_bit(WRITE_LONG_2, filter->write_ok);
-	__set_bit(ERASE, filter->write_ok);
-	__set_bit(GPCMD_MODE_SELECT_10, filter->write_ok);
-	__set_bit(MODE_SELECT, filter->write_ok);
-	__set_bit(LOG_SELECT, filter->write_ok);
-	__set_bit(GPCMD_BLANK, filter->write_ok);
-	__set_bit(GPCMD_CLOSE_TRACK, filter->write_ok);
-	__set_bit(GPCMD_FLUSH_CACHE, filter->write_ok);
-	__set_bit(GPCMD_FORMAT_UNIT, filter->write_ok);
-	__set_bit(GPCMD_REPAIR_RZONE_TRACK, filter->write_ok);
-	__set_bit(GPCMD_RESERVE_RZONE_TRACK, filter->write_ok);
-	__set_bit(GPCMD_SEND_DVD_STRUCTURE, filter->write_ok);
-	__set_bit(GPCMD_SEND_EVENT, filter->write_ok);
-	__set_bit(GPCMD_SEND_KEY, filter->write_ok);
-	__set_bit(GPCMD_SEND_OPC, filter->write_ok);
-	__set_bit(GPCMD_SEND_CUE_SHEET, filter->write_ok);
-	__set_bit(GPCMD_SET_SPEED, filter->write_ok);
-	__set_bit(GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL, filter->write_ok);
-	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
-	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
-	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
+	sgio_bitmap_set(WRITE_6, write);
+	sgio_bitmap_set(WRITE_10, write);
+	sgio_bitmap_set(WRITE_VERIFY, write);
+	sgio_bitmap_set(WRITE_12, write);
+	sgio_bitmap_set(WRITE_VERIFY_12, write);
+	sgio_bitmap_set(WRITE_16, write);
+	sgio_bitmap_set(WRITE_LONG, write);
+	sgio_bitmap_set(WRITE_LONG_2, write);
+	sgio_bitmap_set(ERASE, write);
+	sgio_bitmap_set(GPCMD_MODE_SELECT_10, write);
+	sgio_bitmap_set(MODE_SELECT, write);
+	sgio_bitmap_set(LOG_SELECT, write);
+	sgio_bitmap_set(GPCMD_BLANK, write);
+	sgio_bitmap_set(GPCMD_CLOSE_TRACK, write);
+	sgio_bitmap_set(GPCMD_FLUSH_CACHE, write);
+	sgio_bitmap_set(GPCMD_FORMAT_UNIT, write);
+	sgio_bitmap_set(GPCMD_REPAIR_RZONE_TRACK, write);
+	sgio_bitmap_set(GPCMD_RESERVE_RZONE_TRACK, write);
+	sgio_bitmap_set(GPCMD_SEND_DVD_STRUCTURE, write);
+	sgio_bitmap_set(GPCMD_SEND_EVENT, write);
+	sgio_bitmap_set(GPCMD_SEND_KEY, write);
+	sgio_bitmap_set(GPCMD_SEND_OPC, write);
+	sgio_bitmap_set(GPCMD_SEND_CUE_SHEET, write);
+	sgio_bitmap_set(GPCMD_SET_SPEED, write);
+	sgio_bitmap_set(GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL, write);
+	sgio_bitmap_set(GPCMD_LOAD_UNLOAD, write);
+	sgio_bitmap_set(GPCMD_SET_STREAMING, write);
+	sgio_bitmap_set(GPCMD_SET_READ_AHEAD, write);
+#undef sgio_bitmap_set
 }
 
 int blk_verify_command(struct request_queue *q,
-- 
1.8.1.4
