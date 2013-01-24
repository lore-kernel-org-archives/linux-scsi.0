From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 09/13] sg_io: whitelist a few more commands for disks
Date: Thu, 24 Jan 2013 16:00:45 +0100
Message-ID: <1359039649-17734-10-git-send-email-pbonzini@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

This adds missing commands to the table from SBC and related standards.
Only commands that affect the medium are added.  Commands that affect
other state of the LUN are all privileged, with the sole exception of START
STOP UNIT (which has always been allowed for all file descriptors.  I do not
really agree with that and it's probably an artifact of when /dev/cdrom had
r--r--r-- permissions, but I'm not trying to change that.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 49cd98a..74f3678 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -166,25 +166,44 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x08, D|T|    W|  O                  , read);  // READ(6)
 	sgio_bitmap_set(0x25, D|      W|R|O|      B|K        , read);  // READ CAPACITY(10)
 	sgio_bitmap_set(0x28, D|      W|R|O|      B|K        , read);  // READ(10)
+	sgio_bitmap_set(0x29, D|      W|R|O                  , read);  // READ GENERATION
+	sgio_bitmap_set(0x2D,             O                  , read);  // READ UPDATED BLOCK
 	sgio_bitmap_set(0x2F, D|      W|R|O                  , read);  // VERIFY(10)
+	sgio_bitmap_set(0x34, D|      W|  O|        K        , read);  // PRE-FETCH(10)
 	sgio_bitmap_set(0x37, D|          O                  , read);  // READ DEFECT DATA(10)
 	sgio_bitmap_set(0x3E, D|      W|  O                  , read);  // READ LONG(10)
 	sgio_bitmap_set(0x88, D|T|    W|  O|      B          , read);  // READ(16)
 	sgio_bitmap_set(0x8F, D|T|    W|  O|      B          , read);  // VERIFY(16)
+	sgio_bitmap_set(0x90, D|      W|  O|      B          , read);  // PRE-FETCH(16)
 	sgio_bitmap_set(0xA8, D|      W|R|O                  , read);  // READ(12)
+	sgio_bitmap_set(0xAF, D|      W|  O                  , read);  // VERIFY(12)
+	sgio_bitmap_set(0xB7, D|          O                  , read);  // READ DEFECT DATA(12)
 
 	/* write */
 
 	sgio_bitmap_set(0x04, D|        R|O                  , write); // FORMAT UNIT
+	sgio_bitmap_set(0x07, D|      W|  O                  , write); // REASSIGN BLOCKS
 	sgio_bitmap_set(0x0A, D|T|    W|  O                  , write); // WRITE(6)
 	sgio_bitmap_set(0x2A, D|      W|R|O|      B|K        , write); // WRITE(10)
+	sgio_bitmap_set(0x2C, D|        R|O                  , write); // ERASE(10)
 	sgio_bitmap_set(0x2E, D|      W|R|O|      B|K        , write); // WRITE AND VERIFY(10)
 	sgio_bitmap_set(0x35, D|      W|R|O|      B|K        , write); // SYNCHRONIZE CACHE(10)
+	sgio_bitmap_set(0x38,         W|  O|        K        , write); // MEDIUM SCAN
+	sgio_bitmap_set(0x3D,             O                  , write); // UPDATE BLOCK
 	sgio_bitmap_set(0x3F, D|      W|  O                  , write); // WRITE LONG(10)
+	sgio_bitmap_set(0x41, D                              , write); // WRITE SAME(10)
 	sgio_bitmap_set(0x42, D                              , write); // UNMAP
 	sgio_bitmap_set(0x48, D|                  B          , write); // SANITIZE
 	sgio_bitmap_set(0x51, D                              , write); // XPWRITE(10)
+	sgio_bitmap_set(0x53, D                              , write); // XDWRITEREAD(10)
+	sgio_bitmap_set(0x85, D|                  B          , write); // ATA PASS-THROUGH(16)
+	sgio_bitmap_set(0x89, D                              , write); // COMPARE AND WRITE
+	sgio_bitmap_set(0x8B, D                              , write); // ORWRITE
 	sgio_bitmap_set(0x8A, D|T|    W|  O|      B          , write); // WRITE(16)
+	sgio_bitmap_set(0x8E, D|      W|  O|      B          , write); // WRITE AND VERIFY(16)
+	sgio_bitmap_set(0x91, D|      W|  O|      B          , write); // SYNCHRONIZE CACHE(16)
+	sgio_bitmap_set(0x93, D                              , write); // WRITE SAME(16)
+	sgio_bitmap_set(0xA1, D|                  B          , write); // ATA PASS-THROUGH(12)
 	sgio_bitmap_set(0xAA, D|      W|R|O                  , write); // WRITE(12)
 	sgio_bitmap_set(0xAC,             O                  , write); // ERASE(12)
 	sgio_bitmap_set(0xAE, D|      W|  O                  , write); // WRITE AND VERIFY(12)
@@ -241,12 +260,12 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0xBD,           R                    , read);  // MECHANISM STATUS
 	sgio_bitmap_set(0xBE,           R                    , read);  // READ CD
 
-	sgio_bitmap_set(0x53, D|        R                    , write); // RESERVE TRACK / XDWRITEREAD(10)
+	sgio_bitmap_set(0x53,           R                    , write); // RESERVE TRACK
 	sgio_bitmap_set(0x54,           R                    , write); // SEND OPC INFORMATION
 	sgio_bitmap_set(0x58,           R                    , write); // REPAIR TRACK
 	sgio_bitmap_set(0x5B,           R                    , write); // CLOSE TRACK/SESSION
 	sgio_bitmap_set(0x5D,           R                    , write); // SEND CUE SHEET
-	sgio_bitmap_set(0xA1, D|        R|        B          , write); // BLANK / ATA PASS-THROUGH(12)
+	sgio_bitmap_set(0xA1,           R                    , write); // BLANK
 	sgio_bitmap_set(0xA2,           R                    , write); // SEND EVENT
 	sgio_bitmap_set(0xA3,           R                    , write); // SEND KEY
 	sgio_bitmap_set(0xA6,           R                    , write); // LOAD/UNLOAD C/DVD
-- 
1.7.1
