From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 11/13] sg_io: add list of commands that were in the consulted list but are disabled
Date: Thu, 24 Jan 2013 16:00:47 +0100
Message-ID: <1359039649-17734-12-git-send-email-pbonzini@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

To aid future modifications of the list, add a list of commands
that were in the version of the SCSI commands list I consulted,
but I considered too dangerous to enable by default for unprivileged
users.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index fea0c5d..27b844c 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -336,6 +336,108 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x31,                               S, write); // OBJECT POSITION
 	sgio_bitmap_set(0x34,                               S, write); // GET DATA BUFFER STATUS
 
+#if 0
+	/*
+	 * Starting from here are commands that are always privileged.
+	 * I'm listing them anyway, as a reference to the version of
+	 * the command list that I used.
+	 */
+
+	/* control, privileged, universal except possibly RBC */
+
+	sgio_bitmap_set(0x1D,                    ~B          , write); // SEND DIAGNOSTIC
+	sgio_bitmap_set(0x3B, -1                             , write); // WRITE BUFFER
+
+	/* control, privileged */
+
+	sgio_bitmap_set(0x5E, D|T|L|P|W|  O|M|A|E|      F    , write); // PERSISTENT RESERVE IN
+	sgio_bitmap_set(0x5F, D|T|L|P|W|  O|M|A|E|      F    , write); // PERSISTENT RESERVE OUT
+	sgio_bitmap_set(0x83, D|T|L|P|W|  O|        K|V      , write); // Third-party Copy OUT
+	sgio_bitmap_set(0x84, D|T|L|P|W|  O|        K|V      , write); // Third-party Copy IN
+	sgio_bitmap_set(0x86, D|T|  P|W|  O|M|A|E|B|K|V      , write); // ACCESS CONTROL IN
+	sgio_bitmap_set(0x87, D|T|  P|W|  O|M|A|E|B|K|V      , write); // ACCESS CONTROL OUT
+	sgio_bitmap_set(0x8C, D|T|    W|  O|M|    B|  V      , write); // READ ATTRIBUTE
+	sgio_bitmap_set(0x8D, D|T|    W|  O|M|    B|  V      , write); // WRITE ATTRIBUTE
+	sgio_bitmap_set(0xA2, D|T|      R|            V      , write); // SECURITY PROTOCOL IN
+	sgio_bitmap_set(0xA4, D|T|L|  W|  O|M|A|E|B|K|V      , write); // MAINTENANCE OUT
+	sgio_bitmap_set(0xA9,                         V      , write); // SERVICE ACTION OUT(12)
+	sgio_bitmap_set(0xB5, D|T|      R|            V      , write); // SECURITY PROTOCOL OUT
+	sgio_bitmap_set(0xBA, D|      W|  O|M|A|E            , write); // REDUNDANCY GROUP (IN)
+	sgio_bitmap_set(0xBB, D|      W|  O|M|A|E            , write); // REDUNDANCY GROUP (OUT)
+	sgio_bitmap_set(0xBC, D|      W|  O|M|A|E            , write); // SPARE (IN)
+	sgio_bitmap_set(0xBD, D|      W|  O|M|A|E            , write); // SPARE (OUT)
+	sgio_bitmap_set(0xBE, D|      W|  O|M|A|E            , write); // VOLUME SET (IN)
+	sgio_bitmap_set(0xBF, D|      W|  O|M|A|E            , write); // VOLUME SET (OUT)
+
+	/* control, privileged, obsolete */
+
+	sgio_bitmap_set(0x16, D|T|L|P|W|  O|M|A|E|  K        , write); // RESERVE(6)
+	sgio_bitmap_set(0x16,               M                , write); // RESERVE ELEMENT(6)
+	sgio_bitmap_set(0x17, D|T|L|P|W|  O|M|A|E|  K        , write); // RELEASE(6)
+	sgio_bitmap_set(0x17,               M                , write); // RELEASE ELEMENT(6)
+	sgio_bitmap_set(0x33, D|      W|R|O                  , write); // SET LIMITS(10)
+	sgio_bitmap_set(0x36, D|      W|  O|        K        , write); // LOCK UNLOCK CACHE(10)
+	sgio_bitmap_set(0x40, D|T|L|P|W|R|O|M                , write); // CHANGE DEFINITION
+	sgio_bitmap_set(0x56, D|T|L|P|W|  O|M|A|E            , write); // RESERVE(10)
+	sgio_bitmap_set(0x56,               M                , write); // RESERVE ELEMENT(10)
+	sgio_bitmap_set(0x57, D|T|L|P|W|  O|M|A|E            , write); // RELEASE(10)
+	sgio_bitmap_set(0x57,               M                , write); // RELEASE ELEMENT(10)
+	sgio_bitmap_set(0x81, D                              , write); // REBUILD(16)
+	sgio_bitmap_set(0x82, D                              , write); // REGENERATE(16)
+	sgio_bitmap_set(0x92, D|      W|  O                  , write); // LOCK UNLOCK CACHE(16)
+	sgio_bitmap_set(0xA5,   T|    W|  O|M                , write); // MOVE MEDIUM
+	sgio_bitmap_set(0xA7, D|T|    W|  O                  , write); // MOVE MEDIUM ATTACHED
+	sgio_bitmap_set(0xB3, D|      W|R|O                  , write); // SET LIMITS(12)
+
+	/* others: multiplexed */
+
+	sgio_bitmap_set(0x7E, D|T|      R|  M|A|E|B|  V      , write); // extended CDB
+	sgio_bitmap_set(0x7F, D|                        F    , write); // variable length CDB
+	sgio_bitmap_set(0x9F,                         V      , write); // SERVICE ACTION OUT(16)
+
+	/* others: vendor specific */
+
+	sgio_bitmap_set(0x01,     L                          , write);
+	sgio_bitmap_set(0x02, D|T|L|P|W|R|  M                , write);
+	sgio_bitmap_set(0x05, D|  L|P|W|R|  M                , write);
+	sgio_bitmap_set(0x06, D|T|L|P|W|R|  M                , write);
+	sgio_bitmap_set(0x07,   T|L                          , write);
+	sgio_bitmap_set(0x08,     L|        M                , write);
+	sgio_bitmap_set(0x09, D|T|L|P|W|R|  M                , write);
+	sgio_bitmap_set(0x0A,               M                , write);
+	sgio_bitmap_set(0x0B,               M                , write);
+	sgio_bitmap_set(0x0C, D|T|L|P|W|R|  M                , write);
+	sgio_bitmap_set(0x0D, D|T|L|P|W|R|  M                , write);
+	sgio_bitmap_set(0x0E, D|T|L|P|W|R|  M                , write);
+	sgio_bitmap_set(0x0F, D|  L|P|W|R|  M                , write);
+	sgio_bitmap_set(0x10, D|    P|W|R                    , write);
+	sgio_bitmap_set(0x11, D|  L|P|W|R                    , write);
+	sgio_bitmap_set(0x13, D|  L|P|W|R                    , write);
+	sgio_bitmap_set(0x14, D|    P|W|R                    , write);
+	sgio_bitmap_set(0x19, D|  L|P|W|R                    , write);
+	sgio_bitmap_set(0x20, D|      W|R|O|        K        , write);
+	sgio_bitmap_set(0x21, D|      W|R|O|        K        , write);
+	sgio_bitmap_set(0x22, D|      W|R|O|        K        , write);
+	sgio_bitmap_set(0x23, D|      W|  O|        K        , write);
+	sgio_bitmap_set(0x24, D|      W|R                    , write);
+	sgio_bitmap_set(0x26, D|      W|R                    , write);
+	sgio_bitmap_set(0x27, D|      W|R                    , write);
+	sgio_bitmap_set(0x2D, D                              , write);
+
+	/* others: reserved */
+
+	sgio_bitmap_set(0x1F, 0                              , write);
+	sgio_bitmap_set(0x49, 0                              , write);
+	sgio_bitmap_set(0x4F, 0                              , write);
+	sgio_bitmap_set(0x59, 0                              , write);
+	sgio_bitmap_set(0x98, 0                              , write);
+	sgio_bitmap_set(0x99, 0                              , write);
+	sgio_bitmap_set(0x9A, 0                              , write);
+	sgio_bitmap_set(0x9B, 0                              , write);
+	sgio_bitmap_set(0x9C, 0                              , write);
+	sgio_bitmap_set(0x9D, 0                              , write); //       SERVICE ACTION BIDIRECTIONAL
+#endif
+
 #undef D
 #undef T
 #undef L
-- 
1.7.1
