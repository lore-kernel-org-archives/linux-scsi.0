From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 part3 4/7] sg_io: whitelist another command for multimedia devices
Date: Thu, 23 May 2013 15:59:32 +0200
Message-ID: <1369317575-4236-5-git-send-email-pbonzini@redhat.com>
References: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Three MMC commands were never included: PLAY AUDIO(12), SERVICE ACTION
IN(12), MECHANISM STATUS.  Add MECHANISM STATUS, the only one that has
not been obsoleted in recent versions of the standard.  QEMU implements
it, so it is reasonable to assume that someone is using it.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 41bbd93..b11ad49 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -219,6 +219,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0xB9,           R                  , read);  /* READ CD MSF */
 	sgio_bitmap_set(0xBA,           R                  , read);  /* SCAN */
 	sgio_bitmap_set(0xBC,           R                  , read);  /* PLAY CD */
+	sgio_bitmap_set(0xBD,           R                  , read);  /* MECHANISM STATUS */
 	sgio_bitmap_set(0xBE,           R                  , read);  /* READ CD */
 
 	sgio_bitmap_set(0x53, D|        R                  , write); /* RESERVE TRACK / XDWRITEREAD(10) */
-- 
1.8.1.4
