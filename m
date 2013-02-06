From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 08/14] sg_io: whitelist a few more commands for tapes
Date: Wed,  6 Feb 2013 16:15:55 +0100
Message-ID: <1360163761-8541-9-git-send-email-pbonzini@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Tapes have no problematic overlap, but quite a few commands
are missing that are useful when operating tapes with /dev/sg.
This patch adds them.

START STOP UNIT, FORMAT UNIT and SEEK(10) have similar meanings
but different names for tapes, so move them to the tape section
of the whitelist.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 8cda426..a9c2caf 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -142,9 +142,9 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x03, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* REQUEST SENSE */
 	sgio_bitmap_set(0x12, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* INQUIRY */
 	sgio_bitmap_set(0x1A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* MODE SENSE(6) */
-	sgio_bitmap_set(0x1B, D|T|    W|R|O|  A|  B|K|V|F    , read);  /* START STOP UNIT */
+	sgio_bitmap_set(0x1B, D|      W|R|O|  A|  B|K|  F    , read);  /* START STOP UNIT */
 	sgio_bitmap_set(0x1C, D|T|B|O|W|R|O|M|A|E|  K|V|F|C|S, read);  /* RECEIVE DIAGNOSTIC RESULTS */
-	sgio_bitmap_set(0x2B, D|T|    W|R|O|        K        , read);  /* SEEK(10) */
+	sgio_bitmap_set(0x2B, D|      W|R|O|        K        , read);  /* SEEK(10) */
 	sgio_bitmap_set(0x3C, D|T|B|O|W|R|O|M|A|E|  K|V|F|C|S, read);  /* READ BUFFER */
 	sgio_bitmap_set(0x4D, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* LOG SENSE */
 	sgio_bitmap_set(0x5A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* MODE SENSE(10) */
@@ -176,8 +176,8 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 
 	/* write */
 
-	sgio_bitmap_set(0x04, D|T|L|    R|O                  , write); /* FORMAT UNIT */
-	sgio_bitmap_set(0x0A, D|T|L|  W|  O                  , write); /* WRITE(6) */
+	sgio_bitmap_set(0x04, D|        R|O                  , write); /* FORMAT UNIT */
+	sgio_bitmap_set(0x0A, D|T|    W|  O                  , write); /* WRITE(6) */
 	sgio_bitmap_set(0x2A, D|      W|R|O|      B|K        , write); /* WRITE(10) */
 	sgio_bitmap_set(0x2E, D|      W|R|O|      B|K        , write); /* WRITE AND VERIFY(10) */
 	sgio_bitmap_set(0x35, D|      W|R|O|      B|K        , write); /* SYNCHRONIZE CACHE(10) */
@@ -215,7 +215,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x23,           R                    , read);  /* READ FORMAT CAPACITIES */
 	sgio_bitmap_set(0x42,           R                    , read);  /* READ SUB-CHANNEL */
 	sgio_bitmap_set(0x43,           R                    , read);  /* READ TOC/PMA/ATIP */
-	sgio_bitmap_set(0x44,   T|      R|            V      , read);  /* READ HEADER */
+	sgio_bitmap_set(0x44,           R                    , read);  /* READ HEADER */
 	sgio_bitmap_set(0x45,           R                    , read);  /* PLAY AUDIO(10) */
 	sgio_bitmap_set(0x46,           R                    , read);  /* GET CONFIGURATION */
 	sgio_bitmap_set(0x47,           R                    , read);  /* PLAY AUDIO MSF */
@@ -251,7 +251,27 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 
 	/* (mostly) tape */
 
+	sgio_bitmap_set(0x01,   T                            , read);  /* REWIND */
+	sgio_bitmap_set(0x05,   T                            , read);  /* READ BLOCK LIMITS */
+	sgio_bitmap_set(0x0F,   T                            , read);  /* READ REVERSE(6) */
+	sgio_bitmap_set(0x13,   T                            , read);  /* VERIFY(6) */
+	sgio_bitmap_set(0x1B,   T|                    V      , read);  /* LOAD UNLOAD */
+	sgio_bitmap_set(0x2B,   T                            , read);  /* LOCATE(10) */
+	sgio_bitmap_set(0x34,   T                            , read);  /* READ POSITION */
+	sgio_bitmap_set(0x44,   T|                    V      , read);  /* REPORT DENSITY SUPPORT */
+	sgio_bitmap_set(0x81,   T                            , read);  /* READ REVERSE(16) */
+	sgio_bitmap_set(0x92,   T                            , read);  /* LOCATE(16) */
+
+	sgio_bitmap_set(0x04,   T                            , write); /* FORMAT MEDIUM */
+	sgio_bitmap_set(0x0B,   T                            , write); /* SET CAPACITY */
+	sgio_bitmap_set(0x10,   T                            , write); /* WRITE FILEMARKS(6) */
+	sgio_bitmap_set(0x11,   T                            , write); /* SPACE(6) */
+	sgio_bitmap_set(0x14,   T|L                          , write); /* RECOVER BUFFERED DATA */
 	sgio_bitmap_set(0x19,   T                            , write); /* ERASE(6) */
+	sgio_bitmap_set(0x80,   T                            , write); /* WRITE FILEMARKS(16) */
+	sgio_bitmap_set(0x82,   T                            , write); /* ALLOW OVERWRITE */
+	sgio_bitmap_set(0x91,   T                            , write); /* SPACE(16) */
+	sgio_bitmap_set(0x93,   T                            , write); /* ERASE(16) */
 
 	/* communication devices (obsolete) */
 
-- 
1.7.1
