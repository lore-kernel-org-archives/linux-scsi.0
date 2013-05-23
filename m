From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 part3 3/7] sg_io: cleanup and complete whitelist for rare device types
Date: Thu, 23 May 2013 15:59:31 +0200
Message-ID: <1369317575-4236-4-git-send-email-pbonzini@redhat.com>
References: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Start cleaning up the table, moving out of the way four rare & obsolete
device types: printers, communication devices (network cards), and
processor devices.

This patch is included mostly for tidiness, so that flags for obsolete
device types do not clutter the other entries.  However, it adds two
commands for printers: SLEW AND PRINT and SYNCHRONIZE BUFFER.  These are
present even in SCSI-2 (dated 1994).

Processor devices could also do EXTENDED COPY operations, but these
should not be allowed for unprivileged users because they can read/write
to other devices.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 8f0344f..41bbd93 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -142,7 +142,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x03, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* REQUEST SENSE */
 	sgio_bitmap_set(0x12, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* INQUIRY */
 	sgio_bitmap_set(0x1A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* MODE SENSE(6) */
-	sgio_bitmap_set(0x1B, D|T|L|  W|R|O|M|A|  B|K|V|F  , read);  /* START STOP UNIT */
+	sgio_bitmap_set(0x1B, D|T|    W|R|O|M|A|  B|K|V|F  , read);  /* START STOP UNIT */
 	sgio_bitmap_set(0x1C, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* RECEIVE DIAGNOSTIC RESULTS */
 	sgio_bitmap_set(0x2B, D|T|    W|R|O|M|      K      , read);  /* SEEK(10) */
 	sgio_bitmap_set(0x3C, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* READ BUFFER */
@@ -161,21 +161,21 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 
 	/* read */
 
-	sgio_bitmap_set(0x08, D|T|  P|W|  O|              C, read);  /* READ(6) */
+	sgio_bitmap_set(0x08, D|T|    W|  O                , read);  /* READ(6) */
 	sgio_bitmap_set(0x25, D|      W|R|O|      B|K      , read);  /* READ CAPACITY(10) */
-	sgio_bitmap_set(0x28, D|      W|R|O|      B|K|    C, read);  /* READ(10) */
+	sgio_bitmap_set(0x28, D|      W|R|O|      B|K      , read);  /* READ(10) */
 	sgio_bitmap_set(0x2F, D|      W|R|O                , read);  /* VERIFY(10) */
 	sgio_bitmap_set(0x37, D|          O|M              , read);  /* READ DEFECT DATA(10) */
 	sgio_bitmap_set(0x3E, D|      W|  O                , read);  /* READ LONG(10) */
 	sgio_bitmap_set(0x88, D|T|    W|  O|      B        , read);  /* READ(16) */
 	sgio_bitmap_set(0x8F, D|T|    W|  O|      B        , read);  /* VERIFY(16) */
-	sgio_bitmap_set(0xA8, D|      W|R|O|              C, read);  /* READ(12) */
+	sgio_bitmap_set(0xA8, D|      W|R|O                , read);  /* READ(12) */
 
 	/* write */
 
-	sgio_bitmap_set(0x04, D|T|L|    R|O                , write); /* FORMAT UNIT */
-	sgio_bitmap_set(0x0A, D|T|L|P|W|  O|              C, write); /* WRITE(6) */
-	sgio_bitmap_set(0x2A, D|      W|R|O|      B|K|    C, write); /* WRITE(10) */
+	sgio_bitmap_set(0x04, D|T|      R|O                , write); /* FORMAT UNIT */
+	sgio_bitmap_set(0x0A, D|T|    W|  O                , write); /* WRITE(6) */
+	sgio_bitmap_set(0x2A, D|      W|R|O|      B|K      , write); /* WRITE(10) */
 	sgio_bitmap_set(0x2E, D|      W|R|O|      B|K      , write); /* WRITE AND VERIFY(10) */
 	sgio_bitmap_set(0x35, D|      W|R|O|      B|K      , write); /* SYNCHRONIZE CACHE(10) */
 	sgio_bitmap_set(0x3F, D|      W|  O                , write); /* WRITE LONG(10) */
@@ -183,11 +183,20 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x48, D|                  B        , write); /* SANITIZE */
 	sgio_bitmap_set(0x51, D                            , write); /* XPWRITE(10) */
 	sgio_bitmap_set(0x8A, D|T|    W|  O|      B        , write); /* WRITE(16) */
-	sgio_bitmap_set(0xAA, D|      W|R|O|              C, write); /* WRITE(12) */
+	sgio_bitmap_set(0xAA, D|      W|R|O                , write); /* WRITE(12) */
 	sgio_bitmap_set(0xAC,             O                , write); /* ERASE(12) */
 	sgio_bitmap_set(0xAE, D|      W|  O                , write); /* WRITE AND VERIFY(12) */
 	sgio_bitmap_set(0xEA, D|      W|  O                , write); /* WRITE_LONG_2 ?? */
 
+	/* printer */
+
+	sgio_bitmap_set(0x04,     L                        , write); /* FORMAT */
+	sgio_bitmap_set(0x0A,     L                        , write); /* PRINT */
+	sgio_bitmap_set(0x0B,     L                        , write); /* SLEW AND PRINT */
+	sgio_bitmap_set(0x10,     L                        , write); /* SYNCHRONIZE BUFFER */
+	sgio_bitmap_set(0x14,     L                        , write); /* RECOVER BUFFERED DATA */
+	sgio_bitmap_set(0x1B,     L                        , write); /* STOP PRINT */
+
 	/* MMC */
 
 	sgio_bitmap_set(0x23,           R                  , read);  /* READ FORMAT CAPACITIES */
@@ -230,6 +239,20 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 
 	sgio_bitmap_set(0x19,   T                          , write); /* ERASE(6) */
 
+	/* communication devices (obsolete) */
+
+	sgio_bitmap_set(0x08,                             C, read);  /* GET MESSAGE(6) */
+	sgio_bitmap_set(0x28,                             C, read);  /* GET MESSAGE(10) */
+	sgio_bitmap_set(0xA8,                             C, read);  /* GET MESSAGE(12) */
+	sgio_bitmap_set(0x0A,                             C, write); /* SEND MESSAGE(6) */
+	sgio_bitmap_set(0x2A,                             C, write); /* SEND MESSAGE(10) */
+	sgio_bitmap_set(0xAA,                             C, write); /* SEND MESSAGE(12) */
+
+	/* processor devices (mostly obsolete, SPC-2) */
+
+	sgio_bitmap_set(0x08,       P                      , read);  /* RECEIVE(6) */
+	sgio_bitmap_set(0x0A,       P                      , write); /* SEND(6) */
+
 #undef D
 #undef T
 #undef L
-- 
1.8.1.4
