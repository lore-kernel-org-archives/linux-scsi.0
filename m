From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Fri, 20 Jul 2012 18:30:01 +0200
Message-ID: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

These commands cannot be issued right now without giving CAP_SYS_RAWIO to
the process who wishes to send them.  These commands can be useful also to
non-privileged programs who have access to the block devices.  For example
a virtual machine monitor needs them to forward trim/discard to host disks.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |    3 ++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 260fa80..dd71f18 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -168,13 +168,16 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	/* Basic writing commands */
 	__set_bit(WRITE_6, filter->write_ok);
 	__set_bit(WRITE_10, filter->write_ok);
+	__set_bit(WRITE_SAME, filter->write_ok);
 	__set_bit(WRITE_VERIFY, filter->write_ok);
 	__set_bit(WRITE_12, filter->write_ok);
 	__set_bit(WRITE_VERIFY_12, filter->write_ok);
 	__set_bit(WRITE_16, filter->write_ok);
+	__set_bit(WRITE_SAME_16, filter->write_ok);
 	__set_bit(WRITE_LONG, filter->write_ok);
 	__set_bit(WRITE_LONG_2, filter->write_ok);
 	__set_bit(ERASE, filter->write_ok);
+	__set_bit(UNMAP, filter->write_ok);
 	__set_bit(GPCMD_MODE_SELECT_10, filter->write_ok);
 	__set_bit(MODE_SELECT, filter->write_ok);
 	__set_bit(LOG_SELECT, filter->write_ok);
