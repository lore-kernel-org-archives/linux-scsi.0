From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 07/14] sg_io: whitelist a few more commands for media changers
Date: Wed,  6 Feb 2013 16:15:54 +0100
Message-ID: <1360163761-8541-8-git-send-email-pbonzini@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Besides CD-ROMs, three more device types are interesting for SG_IO:
media changers, tapes and of course disks.

Starting with this patch, we will whitelist a few more commands for
these devices.  For media changers, enable "INITIALIZE ELEMENT STATUS"
and "REQUEST VOLUME ELEMENT ADDRESS".  A few changer-specific commands
were already enabled by chance because they overlapped commands that
are valid for other classes: "EXCHANGE MEDIUM" and "SEND VOLUME TAG",
"INITIALIZE ELEMENT STATUS WITH RANGE".

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index fa2a1fc..8cda426 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -142,9 +142,9 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x03, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* REQUEST SENSE */
 	sgio_bitmap_set(0x12, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* INQUIRY */
 	sgio_bitmap_set(0x1A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* MODE SENSE(6) */
-	sgio_bitmap_set(0x1B, D|T|    W|R|O|M|A|  B|K|V|F    , read);  /* START STOP UNIT */
+	sgio_bitmap_set(0x1B, D|T|    W|R|O|  A|  B|K|V|F    , read);  /* START STOP UNIT */
 	sgio_bitmap_set(0x1C, D|T|B|O|W|R|O|M|A|E|  K|V|F|C|S, read);  /* RECEIVE DIAGNOSTIC RESULTS */
-	sgio_bitmap_set(0x2B, D|T|    W|R|O|M|      K        , read);  /* SEEK(10) */
+	sgio_bitmap_set(0x2B, D|T|    W|R|O|        K        , read);  /* SEEK(10) */
 	sgio_bitmap_set(0x3C, D|T|B|O|W|R|O|M|A|E|  K|V|F|C|S, read);  /* READ BUFFER */
 	sgio_bitmap_set(0x4D, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* LOG SENSE */
 	sgio_bitmap_set(0x5A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* MODE SENSE(10) */
@@ -168,7 +168,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x25, D|      W|R|O|      B|K        , read);  /* READ CAPACITY(10) */
 	sgio_bitmap_set(0x28, D|      W|R|O|      B|K        , read);  /* READ(10) */
 	sgio_bitmap_set(0x2F, D|      W|R|O                  , read);  /* VERIFY(10) */
-	sgio_bitmap_set(0x37, D|          O|M                , read);  /* READ DEFECT DATA(10) */
+	sgio_bitmap_set(0x37, D|          O                  , read);  /* READ DEFECT DATA(10) */
 	sgio_bitmap_set(0x3E, D|      W|  O                  , read);  /* READ LONG(10) */
 	sgio_bitmap_set(0x88, D|T|    W|  O|      B          , read);  /* READ(16) */
 	sgio_bitmap_set(0x8F, D|T|    W|  O|      B          , read);  /* VERIFY(16) */
@@ -199,6 +199,17 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x10,     L                          , write); /* SYNCHRONIZE BUFFER */
 	sgio_bitmap_set(0x1B,     L                          , write); /* STOP PRINT */
 
+	/* media changer */
+
+	sgio_bitmap_set(0x07,               M                , read);  /* INITIALIZE ELEMENT STATUS */
+	sgio_bitmap_set(0x1B,               M                , read);  /* OPEN/CLOSE IMPORT/EXPORT ELEMENT */
+	sgio_bitmap_set(0x2B,               M                , read);  /* POSITION TO ELEMENT */
+	sgio_bitmap_set(0x37,               M                , read);  /* INITIALIZE ELEMENT STATUS WITH RANGE */
+	sgio_bitmap_set(0xB5,               M                , read);  /* REQUEST VOLUME ELEMENT ADDRESS */
+
+	sgio_bitmap_set(0xA6,               M                , write); /* EXCHANGE MEDIUM */
+	sgio_bitmap_set(0xB6,               M                , write); /* SEND VOLUME TAG */
+
 	/* (mostly) MMC */
 
 	sgio_bitmap_set(0x23,           R                    , read);  /* READ FORMAT CAPACITIES */
@@ -232,9 +243,9 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0xA1, D|        R|        B          , write); /* BLANK / ATA PASS-THROUGH(12) */
 	sgio_bitmap_set(0xA2,           R                    , write); /* SEND EVENT */
 	sgio_bitmap_set(0xA3,           R                    , write); /* SEND KEY */
-	sgio_bitmap_set(0xA6,           R|  M                , write); /* LOAD/UNLOAD C/DVD */
+	sgio_bitmap_set(0xA6,           R                    , write); /* LOAD/UNLOAD C/DVD */
 	sgio_bitmap_set(0xA7,           R                    , write); /* SET READ AHEAD */
-	sgio_bitmap_set(0xB6,           R|  M                , write); /* SET STREAMING */
+	sgio_bitmap_set(0xB6,           R                    , write); /* SET STREAMING */
 	sgio_bitmap_set(0xBB,           R                    , write); /* SET CD SPEED */
 	sgio_bitmap_set(0xBF,           R                    , write); /* SEND DVD STRUCTURE */
 
-- 
1.7.1
