From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 06/13] sg_io: whitelist a few more commands for multimedia devices
Date: Thu, 24 Jan 2013 16:00:42 +0100
Message-ID: <1359039649-17734-7-git-send-email-pbonzini@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Strangely, a couple of MMC commands were never included.  Add them too.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 084b943..ec930f0 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -220,11 +220,14 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x52,           R                    , read);  // READ TRACK INFORMATION
 	sgio_bitmap_set(0x5C,           R                    , read);  // READ BUFFER CAPACITY
 	sgio_bitmap_set(0xA4,           R                    , read);  // REPORT KEY
+	sgio_bitmap_set(0xA5,           R                    , read);  // PLAY AUDIO(12)
+	sgio_bitmap_set(0xAB,           R|            V      , read);  // SERVICE ACTION IN(12)
 	sgio_bitmap_set(0xAC,           R                    , read);  // GET PERFORMANCE
 	sgio_bitmap_set(0xAD,           R                    , read);  // READ DVD STRUCTURE
 	sgio_bitmap_set(0xB9,           R                    , read);  // READ CD MSF
 	sgio_bitmap_set(0xBA,           R                    , read);  // SCAN
 	sgio_bitmap_set(0xBC,           R                    , read);  // PLAY CD
+	sgio_bitmap_set(0xBD,           R                    , read);  // MECHANISM STATUS
 	sgio_bitmap_set(0xBE,           R                    , read);  // READ CD
 
 	sgio_bitmap_set(0x53, D|        R                    , write); // RESERVE TRACK / XDWRITEREAD(10)
-- 
1.7.1
