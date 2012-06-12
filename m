From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] scsi: allow persistent reservations without CAP_SYS_RAWIO
Date: Tue, 12 Jun 2012 18:08:32 +0200
Message-ID: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, jbottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

Persistent reservations commands cannot be issued right now without
giving CAP_SYS_RAWIO to the process who wishes to send them.  This
is a bit heavy-handed, allow these two commands.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
        Ok for 3.5 as well?

 block/scsi_ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 260fa80..5d6c9c1 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -137,6 +137,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(SERVICE_ACTION_IN, filter->read_ok);
 	__set_bit(RECEIVE_DIAGNOSTIC, filter->read_ok);
 	__set_bit(MAINTENANCE_IN, filter->read_ok);
+	__set_bit(PERSISTENT_RESERVE_IN, filter->read_ok);
 	__set_bit(GPCMD_READ_BUFFER_CAPACITY, filter->read_ok);
 
 	/* Audio CD commands */
@@ -178,6 +179,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(GPCMD_MODE_SELECT_10, filter->write_ok);
 	__set_bit(MODE_SELECT, filter->write_ok);
 	__set_bit(LOG_SELECT, filter->write_ok);
+	__set_bit(PERSISTENT_RESERVE_OUT, filter->write_ok);
 	__set_bit(GPCMD_BLANK, filter->write_ok);
 	__set_bit(GPCMD_CLOSE_TRACK, filter->write_ok);
 	__set_bit(GPCMD_FLUSH_CACHE, filter->write_ok);
-- 
1.7.1
