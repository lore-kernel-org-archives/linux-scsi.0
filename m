From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 05/14] sg_io: whitelist a few more commands for rare & obsolete device types
Date: Wed,  6 Feb 2013 16:15:52 +0100
Message-ID: <1360163761-8541-6-git-send-email-pbonzini@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Start cleaning up the table, moving out of the way four rare & obsolete
device types: printers, communication devices (network cards) and scanners
(both TYPE_PROCESSOR and TYPE_SCANNER).  Add missing commands for these
four device types.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: added more scanner commands, list taken from SANE

 block/scsi_ioctl.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 75 insertions(+), 8 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 7ea3428..e71cd42 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -142,7 +142,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x03, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* REQUEST SENSE */
 	sgio_bitmap_set(0x12, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* INQUIRY */
 	sgio_bitmap_set(0x1A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* MODE SENSE(6) */
-	sgio_bitmap_set(0x1B, D|T|L|  W|R|O|M|A|  B|K|V|F|  S, read);  /* START STOP UNIT */
+	sgio_bitmap_set(0x1B, D|T|    W|R|O|M|A|  B|K|V|F    , read);  /* START STOP UNIT */
 	sgio_bitmap_set(0x1C, D|T|B|O|W|R|O|M|A|E|  K|V|F|C|S, read);  /* RECEIVE DIAGNOSTIC RESULTS */
 	sgio_bitmap_set(0x2B, D|T|    W|R|O|M|      K        , read);  /* SEEK(10) */
 	sgio_bitmap_set(0x3C, D|T|B|O|W|R|O|M|A|E|  K|V|F|C|S, read);  /* READ BUFFER */
@@ -164,21 +164,21 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 
 	/* input */
 
-	sgio_bitmap_set(0x08, D|T|  P|W|  O|              C|S, read);  /* READ(6) */
-	sgio_bitmap_set(0x25, D|      W|R|O|      B|K|      S, read);  /* READ CAPACITY(10) */
-	sgio_bitmap_set(0x28, D|      W|R|O|      B|K|    C|S, read);  /* READ(10) */
+	sgio_bitmap_set(0x08, D|T|    W|  O                  , read);  /* READ(6) */
+	sgio_bitmap_set(0x25, D|      W|R|O|      B|K        , read);  /* READ CAPACITY(10) */
+	sgio_bitmap_set(0x28, D|      W|R|O|      B|K        , read);  /* READ(10) */
 	sgio_bitmap_set(0x2F, D|      W|R|O                  , read);  /* VERIFY(10) */
 	sgio_bitmap_set(0x37, D|          O|M                , read);  /* READ DEFECT DATA(10) */
 	sgio_bitmap_set(0x3E, D|      W|  O                  , read);  /* READ LONG(10) */
 	sgio_bitmap_set(0x88, D|T|    W|  O|      B          , read);  /* READ(16) */
 	sgio_bitmap_set(0x8F, D|T|    W|  O|      B          , read);  /* VERIFY(16) */
-	sgio_bitmap_set(0xA8, D|      W|R|O|              C  , read);  /* READ(12) */
+	sgio_bitmap_set(0xA8, D|      W|R|O                  , read);  /* READ(12) */
 
 	/* write */
 
 	sgio_bitmap_set(0x04, D|T|L|    R|O                  , write); /* FORMAT UNIT */
-	sgio_bitmap_set(0x0A, D|T|L|P|W|  O|              C|S, write); /* WRITE(6) */
-	sgio_bitmap_set(0x2A, D|      W|R|O|      B|K|    C|S, write); /* WRITE(10) */
+	sgio_bitmap_set(0x0A, D|T|L|  W|  O                  , write); /* WRITE(6) */
+	sgio_bitmap_set(0x2A, D|      W|R|O|      B|K        , write); /* WRITE(10) */
 	sgio_bitmap_set(0x2E, D|      W|R|O|      B|K        , write); /* WRITE AND VERIFY(10) */
 	sgio_bitmap_set(0x35, D|      W|R|O|      B|K        , write); /* SYNCHRONIZE CACHE(10) */
 	sgio_bitmap_set(0x3F, D|      W|  O                  , write); /* WRITE LONG(10) */
@@ -186,11 +186,19 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x48, D|                  B          , write); /* SANITIZE */
 	sgio_bitmap_set(0x51, D                              , write); /* XPWRITE(10) */
 	sgio_bitmap_set(0x8A, D|T|    W|  O|      B          , write); /* WRITE(16) */
-	sgio_bitmap_set(0xAA, D|      W|R|O|              C  , write); /* WRITE(12) */
+	sgio_bitmap_set(0xAA, D|      W|R|O                  , write); /* WRITE(12) */
 	sgio_bitmap_set(0xAC,             O                  , write); /* ERASE(12) */
 	sgio_bitmap_set(0xAE, D|      W|  O                  , write); /* WRITE AND VERIFY(12) */
 	sgio_bitmap_set(0xEA, D|      W|  O                  , write); /* WRITE_LONG_2 ?? */
 
+	/* printer */
+
+	sgio_bitmap_set(0x04,     L                          , write); /* FORMAT */
+	sgio_bitmap_set(0x0A,     L                          , write); /* PRINT */
+	sgio_bitmap_set(0x0B,     L                          , write); /* SLEW AND PRINT */
+	sgio_bitmap_set(0x10,     L                          , write); /* SYNCHRONIZE BUFFER */
+	sgio_bitmap_set(0x1B,     L                          , write); /* STOP PRINT */
+
 	/* (mostly) MMC */
 
 	sgio_bitmap_set(0x23,           R                    , read);  /* READ FORMAT CAPACITIES */
@@ -233,6 +241,65 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 
 	sgio_bitmap_set(0x19,   T                            , write); /* ERASE(6) */
 
+	/* communication devices (obsolete) */
+
+	sgio_bitmap_set(0x08,                             C  , write); /* GET MESSAGE(6) */
+	sgio_bitmap_set(0x0A,                             C  , write); /* SEND MESSAGE(6) */
+	sgio_bitmap_set(0x28,                             C  , write); /* GET MESSAGE(10) */
+	sgio_bitmap_set(0x2A,                             C  , write); /* SEND MESSAGE(10) */
+	sgio_bitmap_set(0xA8,                             C  , write); /* GET MESSAGE(12) */
+	sgio_bitmap_set(0xAA,                             C  , write); /* SEND MESSAGE(12) */
+
+	/*
+	 * scanners (obsolete).  Some scanners use TYPE_PROCESSOR,
+	 * allow both flags for all commands.
+	 */
+
+	sgio_bitmap_set(0x08,       P|                      S, read);  /* RECEIVE */
+	sgio_bitmap_set(0x0A,       P|                      S, write); /* SEND(6) */
+	sgio_bitmap_set(0x16,       P|                      S, write); /* RESERVE UNIT */
+	sgio_bitmap_set(0x17,       P|                      S, write); /* RELEASE UNIT */
+	sgio_bitmap_set(0x1B,       P|                      S, write); /* SCAN */
+	sgio_bitmap_set(0x1D,       P|                      S, write); /* SEND DIAGNOSTIC */
+	sgio_bitmap_set(0x24,       P|                      S, write); /* SET WINDOW */
+	sgio_bitmap_set(0x25,       P|                      S, write); /* GET WINDOW */
+	sgio_bitmap_set(0x08,       P|                      S, read);  /* RECEIVE */
+	sgio_bitmap_set(0x0A,       P|                      S, write); /* SEND(6) */
+	sgio_bitmap_set(0x31,       P|                      S, write); /* OBJECT POSITION */
+	sgio_bitmap_set(0x34,       P|                      S, write); /* GET DATA BUFFER STATUS */
+
+	/*
+	 * scanner vendor-specific commands, taken from SANE.
+	 * SG_IO for TYPE_SCANNER actually is not subject to
+	 * the whitelist, but let's be complete.  TYPE_PROCESSOR
+	 * has always been subject to the whitelist, so do not
+	 * include the P flag here.
+	 */
+	sgio_bitmap_set(0x04,                               S, write); /* Mustek AREA AND WINDOWS */
+	sgio_bitmap_set(0x06,                               S, write); /* Xerox ABORT */
+	sgio_bitmap_set(0x09,                               S, write); /* Vendor specific ??? */
+	sgio_bitmap_set(0x0C,                               S, write); /* Vendor specific ??? */
+	sgio_bitmap_set(0x0E,                               S, write); /* Vendor specific ??? */
+	sgio_bitmap_set(0x0F,                               S, write); /* Mustek GET IMAGE STATUS */
+	sgio_bitmap_set(0x10,                               S, write); /* Mustek ADF AND BACKTRACK */
+	sgio_bitmap_set(0x11,                               S, write); /* Mustek CCD DISTANCE */
+	sgio_bitmap_set(0x1C,                               S, write); /* Vendor specific ??? */
+	sgio_bitmap_set(0x29,                               S, write); /* Xerox READ IMAGE */
+	sgio_bitmap_set(0x55,                               S, write); /* Mustek LOOKUP TABLE */
+	sgio_bitmap_set(0x5E,                               S, write); /* Umax GET LAMP STATUS */
+	sgio_bitmap_set(0x5F,                               S, write); /* Umax SET LAMP STATUS */
+	sgio_bitmap_set(0xA2,                               S, write); /* Coolscan AUTO FOCUS */
+	sgio_bitmap_set(0xC0,                               S, write); /* Fujitsu SET SUBWINDOW */
+	sgio_bitmap_set(0xC1,                               S, write); /* Fujitsu ENDORSER */
+	sgio_bitmap_set(0xC2,                               S, write); /* Fujitsu GET HW STATUS */
+	sgio_bitmap_set(0xD5,                               S, write); /* Canon GET SCAN MODE */
+	sgio_bitmap_set(0xD6,                               S, write); /* Canon SET SCAN MODE */
+	sgio_bitmap_set(0xD8,                               S, write); /* Canon CANCEL */
+	sgio_bitmap_set(0xE0,                               S, write); /* Panasonic GET ADJUST DATA */
+	sgio_bitmap_set(0xE1,                               S, write); /* Panasonic SET TIMEOUT */
+	sgio_bitmap_set(0xE5,                               S, write); /* Canon SET SCAN MODE */
+	sgio_bitmap_set(0xF1,                               S, write); /* Fujitsu SCANNER CONTROL */
+
 #undef D
 #undef T
 #undef L
-- 
1.7.1
