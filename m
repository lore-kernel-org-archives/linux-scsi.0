From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 10/14] sg_io: whitelist a few obsolete commands
Date: Wed,  6 Feb 2013 16:15:57 +0100
Message-ID: <1360163761-8541-11-git-send-email-pbonzini@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

These are added to their own section of the table, together with SEEK(10)
which has always been permitted.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index e100ee3..4942314 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -144,7 +144,6 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x1A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* MODE SENSE(6) */
 	sgio_bitmap_set(0x1B, D|      W|R|O|  A|  B|K|  F    , read);  /* START STOP UNIT */
 	sgio_bitmap_set(0x1C, D|T|B|O|W|R|O|M|A|E|  K|V|F|C|S, read);  /* RECEIVE DIAGNOSTIC RESULTS */
-	sgio_bitmap_set(0x2B, D|      W|R|O|        K        , read);  /* SEEK(10) */
 	sgio_bitmap_set(0x3C, D|T|B|O|W|R|O|M|A|E|  K|V|F|C|S, read);  /* READ BUFFER */
 	sgio_bitmap_set(0x4D, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* LOG SENSE */
 	sgio_bitmap_set(0x5A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C|S, read);  /* MODE SENSE(10) */
@@ -286,6 +285,27 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x91,   T                            , write); /* SPACE(16) */
 	sgio_bitmap_set(0x93,   T                            , write); /* ERASE(16) */
 
+	/* various obsolete */
+
+	sgio_bitmap_set(0x0B, D|      W|R|O                  , read);  /* SEEK(6) */
+	sgio_bitmap_set(0x2B, D|      W|R|O|        K        , read);  /* SEEK(10) */
+	sgio_bitmap_set(0x30, D|      W|R|O                  , read);  /* SEARCH DATA HIGH(10) */
+	sgio_bitmap_set(0x31, D|      W|R|O                  , read);  /* SEARCH DATA EQUAL(10) */
+	sgio_bitmap_set(0x32, D|      W|R|O                  , read);  /* SEARCH DATA LOW(10) */
+	sgio_bitmap_set(0x39, D|T|L|P|W|R|O|        K        , read);  /* COMPARE */
+	sgio_bitmap_set(0x52, D                              , read);  /* XDREAD(10) */
+	sgio_bitmap_set(0xB0,         W|R|O                  , read);  /* SEARCH DATA HIGH(12) */
+	sgio_bitmap_set(0xB1,         W|R|O                  , read);  /* SEARCH DATA EQUAL(12) */
+	sgio_bitmap_set(0xB2,         W|R|O                  , read);  /* SEARCH DATA LOW(12) */
+	sgio_bitmap_set(0xB4, D|T|    W|R|O                  , read);  /* READ ELEMENT STATUS ATTACHED */
+	sgio_bitmap_set(0xB8,   T|    W|R|O|M                , read);  /* READ ELEMENT STATUS */
+
+	sgio_bitmap_set(0x01, D|      W|R|O|M                , write); /* REZERO UNIT */
+	sgio_bitmap_set(0x18, D|T|L|P|W|R|O|        K        , write); /* COPY */
+	sgio_bitmap_set(0x3A, D|T|L|P|W|R|O|        K        , write); /* COPY AND VERIFY */
+	sgio_bitmap_set(0x50, D                              , write); /* XDWRITE(10) */
+	sgio_bitmap_set(0x80, D                              , write); /* XDWRITE EXTENDED(16) */
+
 	/* communication devices (obsolete) */
 
 	sgio_bitmap_set(0x08,                             C  , write); /* GET MESSAGE(6) */
-- 
1.7.1
