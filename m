From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 part3 2/7] sg_io: create separate entries for conflicting commands
Date: Thu, 23 May 2013 15:59:30 +0200
Message-ID: <1369317575-4236-3-git-send-email-pbonzini@redhat.com>
References: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Some SCSI commands were special cased at the end of the table because
they overlapped across SCSI device classes, with different meanings for
different classes.

Instead of hacking the bits manually, use separate entries in the table.
The 0xA4 opcode is blocked for non-MMC devices, even when open read-write.
The other four conflicting commands have their bitmap entries split in
two parts, one read-only for MMC and one read-write for the other classes.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c | 40 +++++++++-------------------------------
 1 file changed, 9 insertions(+), 31 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 5d2143f..8f0344f 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -179,29 +179,33 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x2E, D|      W|R|O|      B|K      , write); /* WRITE AND VERIFY(10) */
 	sgio_bitmap_set(0x35, D|      W|R|O|      B|K      , write); /* SYNCHRONIZE CACHE(10) */
 	sgio_bitmap_set(0x3F, D|      W|  O                , write); /* WRITE LONG(10) */
+	sgio_bitmap_set(0x42, D                            , write); /* UNMAP */
+	sgio_bitmap_set(0x48, D|                  B        , write); /* SANITIZE */
+	sgio_bitmap_set(0x51, D                            , write); /* XPWRITE(10) */
 	sgio_bitmap_set(0x8A, D|T|    W|  O|      B        , write); /* WRITE(16) */
 	sgio_bitmap_set(0xAA, D|      W|R|O|              C, write); /* WRITE(12) */
+	sgio_bitmap_set(0xAC,             O                , write); /* ERASE(12) */
 	sgio_bitmap_set(0xAE, D|      W|  O                , write); /* WRITE AND VERIFY(12) */
 	sgio_bitmap_set(0xEA, D|      W|  O                , write); /* WRITE_LONG_2 ?? */
 
 	/* MMC */
 
 	sgio_bitmap_set(0x23,           R                  , read);  /* READ FORMAT CAPACITIES */
-	sgio_bitmap_set(0x42, D|        R                  , read);  /* READ SUB-CHANNEL / UNMAP !! */
+	sgio_bitmap_set(0x42,           R                  , read);  /* READ SUB-CHANNEL */
 	sgio_bitmap_set(0x43,           R                  , read);  /* READ TOC/PMA/ATIP */
 	sgio_bitmap_set(0x44,   T|      R                  , read);  /* READ HEADER */
 	sgio_bitmap_set(0x45,           R                  , read);  /* PLAY AUDIO(10) */
 	sgio_bitmap_set(0x46,           R                  , read);  /* GET CONFIGURATION */
 	sgio_bitmap_set(0x47,           R                  , read);  /* PLAY AUDIO MSF */
-	sgio_bitmap_set(0x48, D|        R|        B        , read);  /* PLAY AUDIO TI / SANITIZE !! */
+	sgio_bitmap_set(0x48,           R                  , read);  /* PLAY AUDIO TI */
 	sgio_bitmap_set(0x4A,           R                  , read);  /* GET EVENT STATUS NOTIFICATION */
 	sgio_bitmap_set(0x4B,           R                  , read);  /* PAUSE/RESUME */
 	sgio_bitmap_set(0x4E,           R                  , read);  /* STOP PLAY/SCAN */
-	sgio_bitmap_set(0x51, D|        R                  , read);  /* READ DISC INFORMATION / XPWRITE(10) !! */
+	sgio_bitmap_set(0x51,           R                  , read);  /* READ DISC INFORMATION */
 	sgio_bitmap_set(0x52,           R                  , read);  /* READ TRACK INFORMATION */
 	sgio_bitmap_set(0x5C,           R                  , read);  /* READ BUFFER CAPACITY */
-	sgio_bitmap_set(0xA4, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* REPORT KEY / 0xA4 service actions !! */
-	sgio_bitmap_set(0xAC,           R|O                , read);  /* GET PERFORMANCE / ERASE !! */
+	sgio_bitmap_set(0xA4,           R                  , read);  /* REPORT KEY */
+	sgio_bitmap_set(0xAC,           R                  , read);  /* GET PERFORMANCE */
 	sgio_bitmap_set(0xAD,           R                  , read);  /* READ DVD STRUCTURE */
 	sgio_bitmap_set(0xB9,           R                  , read);  /* READ CD MSF */
 	sgio_bitmap_set(0xBA,           R                  , read);  /* SCAN */
@@ -242,32 +246,6 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 #undef V
 #undef F
 #undef sgio_bitmap_set
-
-	/*
-	 * Treat specially those commands that have a different meaning
-	 * for disks: READ SUBCHANNEL conflicts with UNMAP.
-	 */
-	filter->read_ok[GPCMD_READ_SUBCHANNEL] &= ~(1 << TYPE_DISK);
-	filter->write_ok[GPCMD_READ_SUBCHANNEL] |= (1 << TYPE_DISK);
-
-	/* PLAY AUDIO TI conflicts with SANITIZE.  */
-	filter->read_ok[GPCMD_PLAY_AUDIO_TI] &= ~((1 << TYPE_DISK) | (1 << TYPE_RBC));
-	filter->write_ok[GPCMD_PLAY_AUDIO_TI] |= (1 << TYPE_DISK) | (1 << TYPE_RBC);
-
-	/* READ DISC INFORMATION conflicts with XPWRITE.  */
-	filter->read_ok[GPCMD_READ_DISC_INFO] &= ~(1 << TYPE_DISK);
-	filter->write_ok[GPCMD_READ_DISC_INFO] |= (1 << TYPE_DISK);
-
-	/* GET PERFORMANCE conflicts with ERASE.  */
-	filter->read_ok[GPCMD_GET_PERFORMANCE] &= ~(1 << TYPE_MOD);
-	filter->write_ok[GPCMD_GET_PERFORMANCE] |= (1 << TYPE_MOD);
-
-	/*
-	 * REPORT KEY conflicts with many management commands under operation
-	 * code 0xA4, enable it only for MMC devices.
-	 */
-	filter->read_ok[GPCMD_REPORT_KEY] = (1 << TYPE_ROM);
-	filter->write_ok[GPCMD_REPORT_KEY] = (1 << TYPE_ROM);
 }
 
 int blk_verify_command(struct request_queue *q,
-- 
1.8.1.4
