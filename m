From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 04/13] sg_io: resolve conflicts between commands assigned to multiple classes (CVE-2012-4542)
Date: Thu, 24 Jan 2013 16:00:40 +0100
Message-ID: <1359039649-17734-5-git-send-email-pbonzini@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Some SCSI commands can be sent to disks via SG_IO even by unprivileged
users.  Unfortunately, some opcodes overlap across SCSI device classes
and have different meanings for different classes.  Four of them can
be used for read-only file descriptors on MMC, but should be limited to
descriptors opened for read-write on SBC:

The current bitmap of allowed commands is designed for MMC devices
(roughly, "play/burn CDs without requiring root").

- READ SUBCHANNEL <-> UNMAP (destructive, but no control on written
  data)

- GET PERFORMANCE <-> ERASE (not really a problem, no one supports
  ERASE anyway)

- READ DISC INFORMATION <-> XPWRITE (not commonly implemented but
  most dangerous)

- PLAY AUDIO TI <-> SANITIZE (a very new command)

To fix this, the series splits the bitmap entries for these four
commands into two entries, one read-only for MMC and one read-write
for the other device classes.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index e68add2..c266546 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -181,29 +181,33 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x2E, D|      W|R|O|      B|K        , write); // WRITE AND VERIFY(10)
 	sgio_bitmap_set(0x35, D|      W|R|O|      B|K        , write); // SYNCHRONIZE CACHE(10)
 	sgio_bitmap_set(0x3F, D|      W|  O                  , write); // WRITE LONG(10)
+	sgio_bitmap_set(0x42, D                              , write); // UNMAP
+	sgio_bitmap_set(0x48, D|                  B          , write); // SANITIZE
+	sgio_bitmap_set(0x51, D                              , write); // XPWRITE(10)
 	sgio_bitmap_set(0x8A, D|T|    W|  O|      B          , write); // WRITE(16)
 	sgio_bitmap_set(0xAA, D|      W|R|O|              C  , write); // WRITE(12)
+	sgio_bitmap_set(0xAC,             O                  , write); // ERASE(12)
 	sgio_bitmap_set(0xAE, D|      W|  O                  , write); // WRITE AND VERIFY(12)
 	sgio_bitmap_set(0xEA, D|      W|  O                  , write); // WRITE_LONG_2 ??
 
 	/* (mostly) MMC */
 
 	sgio_bitmap_set(0x23,           R                    , read);  // READ FORMAT CAPACITIES
-	sgio_bitmap_set(0x42, D|        R                    , read);  // READ SUB-CHANNEL / UNMAP !!
+	sgio_bitmap_set(0x42,           R                    , read);  // READ SUB-CHANNEL
 	sgio_bitmap_set(0x43,           R                    , read);  // READ TOC/PMA/ATIP
 	sgio_bitmap_set(0x44,   T|      R|            V      , read);  // READ HEADER
 	sgio_bitmap_set(0x45,           R                    , read);  // PLAY AUDIO(10)
 	sgio_bitmap_set(0x46,           R                    , read);  // GET CONFIGURATION
 	sgio_bitmap_set(0x47,           R                    , read);  // PLAY AUDIO MSF
-	sgio_bitmap_set(0x48, D|        R|        B          , read);  // PLAY AUDIO TI / SANITIZE !!
+	sgio_bitmap_set(0x48,           R                    , read);  // PLAY AUDIO TI
 	sgio_bitmap_set(0x4A,           R                    , read);  // GET EVENT STATUS NOTIFICATION
 	sgio_bitmap_set(0x4B,           R                    , read);  // PAUSE/RESUME
 	sgio_bitmap_set(0x4E,           R                    , read);  // STOP PLAY/SCAN
-	sgio_bitmap_set(0x51, D|        R                    , read);  // READ DISC INFORMATION / XPWRITE(10) !!
+	sgio_bitmap_set(0x51,           R                    , read);  // READ DISC INFORMATION
 	sgio_bitmap_set(0x52,           R                    , read);  // READ TRACK INFORMATION
 	sgio_bitmap_set(0x5C,           R                    , read);  // READ BUFFER CAPACITY
 	sgio_bitmap_set(0xA4,           R                    , read);  // REPORT KEY
-	sgio_bitmap_set(0xAC,           R|O                  , read);  // GET PERFORMANCE / ERASE !!
+	sgio_bitmap_set(0xAC,           R                    , read);  // GET PERFORMANCE
 	sgio_bitmap_set(0xAD,           R                    , read);  // READ DVD STRUCTURE
 	sgio_bitmap_set(0xB9,           R                    , read);  // READ CD MSF
 	sgio_bitmap_set(0xBA,           R                    , read);  // SCAN
-- 
1.7.1
