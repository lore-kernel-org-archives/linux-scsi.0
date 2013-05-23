From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 part3 6/7] sg_io: cleanup and complete whitelist for tapes
Date: Thu, 23 May 2013 15:59:34 +0200
Message-ID: <1369317575-4236-7-git-send-email-pbonzini@redhat.com>
References: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Tapes have no problematic overlap, but quite a few commands are missing
that are useful when operating tapes with /dev/sg.

This patch adds commands from the SSC standards to the list.  I added
everything because the current whitelist is totally inapplicable to
those devices; the command set is almost completely different from that
of disks.  The SSC standard is relatively small and does not really have
the kitchen sink in them.

Commands with similar meanings often have different names or slightly
different characteristics for tapes vs. block devices; for example, tapes
have no 10- or 12-byte CDBs for READ and WRITE.  For this reason I'm
separating block devices for tapes entirely.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index f9e719e..0bf0820 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -142,9 +142,9 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x03, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* REQUEST SENSE */
 	sgio_bitmap_set(0x12, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* INQUIRY */
 	sgio_bitmap_set(0x1A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* MODE SENSE(6) */
-	sgio_bitmap_set(0x1B, D|T|    W|R|O|  A|  B|K|V|F  , read);  /* START STOP UNIT */
+	sgio_bitmap_set(0x1B, D|      W|R|O|  A|  B|K|V|F  , read);  /* START STOP UNIT */
 	sgio_bitmap_set(0x1C, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* RECEIVE DIAGNOSTIC RESULTS */
-	sgio_bitmap_set(0x2B, D|T|    W|R|O|        K      , read);  /* SEEK(10) */
+	sgio_bitmap_set(0x2B, D|      W|R|O|        K      , read);  /* SEEK(10) */
 	sgio_bitmap_set(0x3C, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* READ BUFFER */
 	sgio_bitmap_set(0x4D, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* LOG SENSE */
 	sgio_bitmap_set(0x5A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* MODE SENSE(10) */
@@ -159,22 +159,22 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x55, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, write); /* MODE SELECT(10) */
 	sgio_bitmap_set(0x1E, D|T|    W|R|O|M|      K|  F  , write); /* PREVENT ALLOW MEDIUM REMOVAL */
 
-	/* read */
+	/* block devices, read */
 
-	sgio_bitmap_set(0x08, D|T|    W|  O                , read);  /* READ(6) */
+	sgio_bitmap_set(0x08, D|      W|  O                , read);  /* READ(6) */
 	sgio_bitmap_set(0x25, D|      W|R|O|      B|K      , read);  /* READ CAPACITY(10) */
 	sgio_bitmap_set(0x28, D|      W|R|O|      B|K      , read);  /* READ(10) */
 	sgio_bitmap_set(0x2F, D|      W|R|O                , read);  /* VERIFY(10) */
 	sgio_bitmap_set(0x37, D|          O                , read);  /* READ DEFECT DATA(10) */
 	sgio_bitmap_set(0x3E, D|      W|  O                , read);  /* READ LONG(10) */
-	sgio_bitmap_set(0x88, D|T|    W|  O|      B        , read);  /* READ(16) */
-	sgio_bitmap_set(0x8F, D|T|    W|  O|      B        , read);  /* VERIFY(16) */
+	sgio_bitmap_set(0x88, D|      W|  O|      B        , read);  /* READ(16) */
+	sgio_bitmap_set(0x8F, D|      W|  O|      B        , read);  /* VERIFY(16) */
 	sgio_bitmap_set(0xA8, D|      W|R|O                , read);  /* READ(12) */
 
-	/* write */
+	/* block devices, write */
 
-	sgio_bitmap_set(0x04, D|T|      R|O                , write); /* FORMAT UNIT */
-	sgio_bitmap_set(0x0A, D|T|    W|  O                , write); /* WRITE(6) */
+	sgio_bitmap_set(0x04, D|        R|O                , write); /* FORMAT UNIT */
+	sgio_bitmap_set(0x0A, D|      W|  O                , write); /* WRITE(6) */
 	sgio_bitmap_set(0x2A, D|      W|R|O|      B|K      , write); /* WRITE(10) */
 	sgio_bitmap_set(0x2E, D|      W|R|O|      B|K      , write); /* WRITE AND VERIFY(10) */
 	sgio_bitmap_set(0x35, D|      W|R|O|      B|K      , write); /* SYNCHRONIZE CACHE(10) */
@@ -182,7 +182,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x42, D                            , write); /* UNMAP */
 	sgio_bitmap_set(0x48, D|                  B        , write); /* SANITIZE */
 	sgio_bitmap_set(0x51, D                            , write); /* XPWRITE(10) */
-	sgio_bitmap_set(0x8A, D|T|    W|  O|      B        , write); /* WRITE(16) */
+	sgio_bitmap_set(0x8A, D|      W|  O|      B        , write); /* WRITE(16) */
 	sgio_bitmap_set(0xAA, D|      W|R|O                , write); /* WRITE(12) */
 	sgio_bitmap_set(0xAC,             O                , write); /* ERASE(12) */
 	sgio_bitmap_set(0xAE, D|      W|  O                , write); /* WRITE AND VERIFY(12) */
@@ -219,7 +219,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x23,           R                  , read);  /* READ FORMAT CAPACITIES */
 	sgio_bitmap_set(0x42,           R                  , read);  /* READ SUB-CHANNEL */
 	sgio_bitmap_set(0x43,           R                  , read);  /* READ TOC/PMA/ATIP */
-	sgio_bitmap_set(0x44,   T|      R                  , read);  /* READ HEADER */
+	sgio_bitmap_set(0x44,           R                  , read);  /* READ HEADER */
 	sgio_bitmap_set(0x45,           R                  , read);  /* PLAY AUDIO(10) */
 	sgio_bitmap_set(0x46,           R                  , read);  /* GET CONFIGURATION */
 	sgio_bitmap_set(0x47,           R                  , read);  /* PLAY AUDIO MSF */
@@ -255,7 +255,32 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 
 	/* tape */
 
+	sgio_bitmap_set(0x01,   T                          , read);  /* REWIND */
+	sgio_bitmap_set(0x05,   T                          , read);  /* READ BLOCK LIMITS */
+	sgio_bitmap_set(0x08,   T                          , read);  /* READ(6) */
+	sgio_bitmap_set(0x0F,   T                          , read);  /* READ REVERSE(6) */
+	sgio_bitmap_set(0x13,   T                          , read);  /* VERIFY(6) */
+	sgio_bitmap_set(0x1B,   T                          , read);  /* LOAD UNLOAD */
+	sgio_bitmap_set(0x2B,   T                          , read);  /* LOCATE(10) */
+	sgio_bitmap_set(0x34,   T                          , read);  /* READ POSITION */
+	sgio_bitmap_set(0x44,   T                          , read);  /* REPORT DENSITY SUPPORT */
+	sgio_bitmap_set(0x81,   T                          , read);  /* READ REVERSE(16) */
+	sgio_bitmap_set(0x88,   T                          , read);  /* READ(16) */
+	sgio_bitmap_set(0x8F,   T                          , read);  /* VERIFY(16) */
+	sgio_bitmap_set(0x92,   T                          , read);  /* LOCATE(16) */
+
+	sgio_bitmap_set(0x04,   T                          , write); /* FORMAT MEDIUM */
+	sgio_bitmap_set(0x0A,   T                          , write); /* WRITE(6) */
+	sgio_bitmap_set(0x0B,   T                          , write); /* SET CAPACITY */
+	sgio_bitmap_set(0x10,   T                          , write); /* WRITE FILEMARKS(6) */
+	sgio_bitmap_set(0x11,   T                          , write); /* SPACE(6) */
+	sgio_bitmap_set(0x14,   T                          , write); /* RECOVER BUFFERED DATA */
 	sgio_bitmap_set(0x19,   T                          , write); /* ERASE(6) */
+	sgio_bitmap_set(0x80,   T                          , write); /* WRITE FILEMARKS(16) */
+	sgio_bitmap_set(0x82,   T                          , write); /* ALLOW OVERWRITE */
+	sgio_bitmap_set(0x8A,   T                          , write); /* WRITE(16) */
+	sgio_bitmap_set(0x91,   T                          , write); /* SPACE(16) */
+	sgio_bitmap_set(0x93,   T                          , write); /* ERASE(16) */
 
 	/* communication devices (obsolete) */
 
-- 
1.8.1.4
