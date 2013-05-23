From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 part3 5/7] sg_io: cleanup and complete whitelist for media changers
Date: Thu, 23 May 2013 15:59:33 +0200
Message-ID: <1369317575-4236-6-git-send-email-pbonzini@redhat.com>
References: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Besides CD-ROMs, three more device types are interesting for SG_IO:
media changers, tapes and of course disks.

Starting with this patch, we will whitelist a few more commands for
these devices.  For media changers, enable "INITIALIZE ELEMENT STATUS"
and "REQUEST VOLUME ELEMENT ADDRESS".  A few changer-specific commands
were already enabled by chance because they overlapped commands that
are valid for other classes: "EXCHANGE MEDIUM", "SEND VOLUME TAG",
"INITIALIZE ELEMENT STATUS WITH RANGE".

In addition, some changers are still using an old pre-standard command
for "INITIALIZE ELEMENT STATUS WITH RANGE", which is enabled as well.

This makes media changers usable by unprivileged users that have access
to the device node.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index b11ad49..f9e719e 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -142,9 +142,9 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x03, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* REQUEST SENSE */
 	sgio_bitmap_set(0x12, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* INQUIRY */
 	sgio_bitmap_set(0x1A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* MODE SENSE(6) */
-	sgio_bitmap_set(0x1B, D|T|    W|R|O|M|A|  B|K|V|F  , read);  /* START STOP UNIT */
+	sgio_bitmap_set(0x1B, D|T|    W|R|O|  A|  B|K|V|F  , read);  /* START STOP UNIT */
 	sgio_bitmap_set(0x1C, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* RECEIVE DIAGNOSTIC RESULTS */
-	sgio_bitmap_set(0x2B, D|T|    W|R|O|M|      K      , read);  /* SEEK(10) */
+	sgio_bitmap_set(0x2B, D|T|    W|R|O|        K      , read);  /* SEEK(10) */
 	sgio_bitmap_set(0x3C, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* READ BUFFER */
 	sgio_bitmap_set(0x4D, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* LOG SENSE */
 	sgio_bitmap_set(0x5A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* MODE SENSE(10) */
@@ -165,7 +165,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x25, D|      W|R|O|      B|K      , read);  /* READ CAPACITY(10) */
 	sgio_bitmap_set(0x28, D|      W|R|O|      B|K      , read);  /* READ(10) */
 	sgio_bitmap_set(0x2F, D|      W|R|O                , read);  /* VERIFY(10) */
-	sgio_bitmap_set(0x37, D|          O|M              , read);  /* READ DEFECT DATA(10) */
+	sgio_bitmap_set(0x37, D|          O                , read);  /* READ DEFECT DATA(10) */
 	sgio_bitmap_set(0x3E, D|      W|  O                , read);  /* READ LONG(10) */
 	sgio_bitmap_set(0x88, D|T|    W|  O|      B        , read);  /* READ(16) */
 	sgio_bitmap_set(0x8F, D|T|    W|  O|      B        , read);  /* VERIFY(16) */
@@ -197,6 +197,23 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x14,     L                        , write); /* RECOVER BUFFERED DATA */
 	sgio_bitmap_set(0x1B,     L                        , write); /* STOP PRINT */
 
+	/* media changer */
+
+	sgio_bitmap_set(0x07,               M              , read);  /* INITIALIZE ELEMENT STATUS */
+	sgio_bitmap_set(0x1B,               M              , read);  /* OPEN/CLOSE IMPORT/EXPORT ELEMENT */
+	sgio_bitmap_set(0x2B,               M              , read);  /* POSITION TO ELEMENT */
+	sgio_bitmap_set(0x37,               M              , read);  /* INITIALIZE ELEMENT STATUS WITH RANGE */
+	sgio_bitmap_set(0xB5,               M              , read);  /* REQUEST VOLUME ELEMENT ADDRESS */
+
+	sgio_bitmap_set(0xA6,               M              , write); /* EXCHANGE MEDIUM */
+	sgio_bitmap_set(0xB6,               M              , write); /* SEND VOLUME TAG */
+
+	/*
+	 * The standard says that INITIALIZE ELEMENT STATUS WITH RANGE was
+	 * mapped to 0xE7 (vendor-specific) before being standardized.
+	 */
+	sgio_bitmap_set(0xE7,               M              , read);
+
 	/* MMC */
 
 	sgio_bitmap_set(0x23,           R                  , read);  /* READ FORMAT CAPACITIES */
@@ -230,9 +247,9 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0xA1, D|        R|        B        , write); /* BLANK / ATA PASS-THROUGH(12) */
 	sgio_bitmap_set(0xA2,           R                  , write); /* SEND EVENT */
 	sgio_bitmap_set(0xA3,           R                  , write); /* SEND KEY */
-	sgio_bitmap_set(0xA6,           R|  M              , write); /* LOAD/UNLOAD C/DVD */
+	sgio_bitmap_set(0xA6,           R                  , write); /* LOAD/UNLOAD C/DVD */
 	sgio_bitmap_set(0xA7,           R                  , write); /* SET READ AHEAD */
-	sgio_bitmap_set(0xB6,           R|  M              , write); /* SET STREAMING */
+	sgio_bitmap_set(0xB6,           R                  , write); /* SET STREAMING */
 	sgio_bitmap_set(0xBB,           R                  , write); /* SET CD SPEED */
 	sgio_bitmap_set(0xBF,           R                  , write); /* SEND DVD STRUCTURE */
 
-- 
1.8.1.4
