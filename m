From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 part3 1/7] sg_io: complete transition to per-class lists of allowed commands
Date: Thu, 23 May 2013 15:59:29 +0200
Message-ID: <1369317575-4236-2-git-send-email-pbonzini@redhat.com>
References: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

After this patch, a few commands are forbidden for devices of type other than
TYPE_ROM, where they are reserved, vendor-specific.  This avoids that
future version of the standards introduce unwanted conficts.

One command (READ CAPACITY) was listed twice in the old table (once
as READ_CAPACITY, once as GPCMD_READ_CDVD_CAPACITY), hence the new table
has one entry less than the old one.  The old table has 72 entries, the
new one has 71.

Note that TYPE_SCANNER is not subject to the whitelist, so it is not
included at all.

Of course, checkpatch hates this table.  It has long lines and
non-standard spacing.  IMO the improved readability trumps the problems
reported by checkpatch.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c  | 207 +++++++++++++++++++++++++++++++---------------------
 include/scsi/scsi.h |   3 +
 2 files changed, 128 insertions(+), 82 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 0af98fe..5d2143f 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -116,88 +116,131 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 
 static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 {
-#define sgio_bitmap_set(cmd, rw) \
-	filter->rw##_ok[(cmd)] = ~0;
-
-	/* Basic read-only commands */
-	sgio_bitmap_set(TEST_UNIT_READY, read);
-	sgio_bitmap_set(REQUEST_SENSE, read);
-	sgio_bitmap_set(READ_6, read);
-	sgio_bitmap_set(READ_10, read);
-	sgio_bitmap_set(READ_12, read);
-	sgio_bitmap_set(READ_16, read);
-	sgio_bitmap_set(READ_BUFFER, read);
-	sgio_bitmap_set(READ_DEFECT_DATA, read);
-	sgio_bitmap_set(READ_CAPACITY, read);
-	sgio_bitmap_set(READ_LONG, read);
-	sgio_bitmap_set(INQUIRY, read);
-	sgio_bitmap_set(MODE_SENSE, read);
-	sgio_bitmap_set(MODE_SENSE_10, read);
-	sgio_bitmap_set(LOG_SENSE, read);
-	sgio_bitmap_set(START_STOP, read);
-	sgio_bitmap_set(GPCMD_VERIFY_10, read);
-	sgio_bitmap_set(VERIFY_16, read);
-	sgio_bitmap_set(REPORT_LUNS, read);
-	sgio_bitmap_set(SERVICE_ACTION_IN, read);
-	sgio_bitmap_set(RECEIVE_DIAGNOSTIC, read);
-	sgio_bitmap_set(MAINTENANCE_IN, read);
-	sgio_bitmap_set(GPCMD_READ_BUFFER_CAPACITY, read);
-
-	/* Audio CD commands */
-	sgio_bitmap_set(GPCMD_PLAY_CD, read);
-	sgio_bitmap_set(GPCMD_PLAY_AUDIO_10, read);
-	sgio_bitmap_set(GPCMD_PLAY_AUDIO_MSF, read);
-	sgio_bitmap_set(GPCMD_PLAY_AUDIO_TI, read);
-	sgio_bitmap_set(GPCMD_PAUSE_RESUME, read);
-
-	/* CD/DVD data reading */
-	sgio_bitmap_set(GPCMD_READ_CD, read);
-	sgio_bitmap_set(GPCMD_READ_CD_MSF, read);
-	sgio_bitmap_set(GPCMD_READ_DISC_INFO, read);
-	sgio_bitmap_set(GPCMD_READ_CDVD_CAPACITY, read);
-	sgio_bitmap_set(GPCMD_READ_DVD_STRUCTURE, read);
-	sgio_bitmap_set(GPCMD_READ_HEADER, read);
-	sgio_bitmap_set(GPCMD_READ_TRACK_RZONE_INFO, read);
-	sgio_bitmap_set(GPCMD_READ_SUBCHANNEL, read);
-	sgio_bitmap_set(GPCMD_READ_TOC_PMA_ATIP, read);
-	sgio_bitmap_set(GPCMD_REPORT_KEY, read);
-	sgio_bitmap_set(GPCMD_SCAN, read);
-	sgio_bitmap_set(GPCMD_GET_CONFIGURATION, read);
-	sgio_bitmap_set(GPCMD_READ_FORMAT_CAPACITIES, read);
-	sgio_bitmap_set(GPCMD_GET_EVENT_STATUS_NOTIFICATION, read);
-	sgio_bitmap_set(GPCMD_GET_PERFORMANCE, read);
-	sgio_bitmap_set(GPCMD_SEEK, read);
-	sgio_bitmap_set(GPCMD_STOP_PLAY_SCAN, read);
-
-	/* Basic writing commands */
-	sgio_bitmap_set(WRITE_6, write);
-	sgio_bitmap_set(WRITE_10, write);
-	sgio_bitmap_set(WRITE_VERIFY, write);
-	sgio_bitmap_set(WRITE_12, write);
-	sgio_bitmap_set(WRITE_VERIFY_12, write);
-	sgio_bitmap_set(WRITE_16, write);
-	sgio_bitmap_set(WRITE_LONG, write);
-	sgio_bitmap_set(WRITE_LONG_2, write);
-	sgio_bitmap_set(ERASE, write);
-	sgio_bitmap_set(GPCMD_MODE_SELECT_10, write);
-	sgio_bitmap_set(MODE_SELECT, write);
-	sgio_bitmap_set(LOG_SELECT, write);
-	sgio_bitmap_set(GPCMD_BLANK, write);
-	sgio_bitmap_set(GPCMD_CLOSE_TRACK, write);
-	sgio_bitmap_set(GPCMD_FLUSH_CACHE, write);
-	sgio_bitmap_set(GPCMD_FORMAT_UNIT, write);
-	sgio_bitmap_set(GPCMD_REPAIR_RZONE_TRACK, write);
-	sgio_bitmap_set(GPCMD_RESERVE_RZONE_TRACK, write);
-	sgio_bitmap_set(GPCMD_SEND_DVD_STRUCTURE, write);
-	sgio_bitmap_set(GPCMD_SEND_EVENT, write);
-	sgio_bitmap_set(GPCMD_SEND_KEY, write);
-	sgio_bitmap_set(GPCMD_SEND_OPC, write);
-	sgio_bitmap_set(GPCMD_SEND_CUE_SHEET, write);
-	sgio_bitmap_set(GPCMD_SET_SPEED, write);
-	sgio_bitmap_set(GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL, write);
-	sgio_bitmap_set(GPCMD_LOAD_UNLOAD, write);
-	sgio_bitmap_set(GPCMD_SET_STREAMING, write);
-	sgio_bitmap_set(GPCMD_SET_READ_AHEAD, write);
+#define sgio_bitmap_set(cmd, mask, rw) \
+	filter->rw##_ok[(cmd)] |= (mask);
+
+#define D (1u << TYPE_DISK)           /* Direct Access Block Device (SBC-3) */
+#define T (1u << TYPE_TAPE)           /* Sequential Access Device (SSC-3) */
+#define L (1u << TYPE_PRINTER)        /* Printer Device (SSC) */
+#define P (1u << TYPE_PROCESSOR)      /* Processor Device (SPC-2) */
+#define W (1u << TYPE_WORM)           /* Write Once Block Device (SBC) */
+#define R (1u << TYPE_ROM)            /* C/DVD Device (MMC-6) */
+#define O (1u << TYPE_MOD)            /* Optical Memory Block Device (SBC) */
+#define M (1u << TYPE_MEDIUM_CHANGER) /* Media Changer Device (SMC-3) */
+#define A (1u << TYPE_RAID)           /* Storage Array Device (SCC-2) */
+#define E (1u << TYPE_ENCLOSURE)      /* SCSI Enclosure Services device (SES-2) */
+#define B (1u << TYPE_RBC)            /* Simplified Direct-Access (Reduced Block) device (RBC) */
+#define K (1u << TYPE_OCRW)           /* Optical Card Reader/Writer device (OCRW) */
+#define V (1u << TYPE_ADC)            /* Automation/Device Interface device (ADC-2) */
+#define F (1u << TYPE_OSD)            /* Object-based Storage Device (OSD-2) */
+
+#define C (1u << TYPE_COMM)           /* Communication devices (obsolete) */
+
+	/* control, read */
+
+	sgio_bitmap_set(0x00, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* TEST UNIT READY */
+	sgio_bitmap_set(0x03, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* REQUEST SENSE */
+	sgio_bitmap_set(0x12, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* INQUIRY */
+	sgio_bitmap_set(0x1A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* MODE SENSE(6) */
+	sgio_bitmap_set(0x1B, D|T|L|  W|R|O|M|A|  B|K|V|F  , read);  /* START STOP UNIT */
+	sgio_bitmap_set(0x1C, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* RECEIVE DIAGNOSTIC RESULTS */
+	sgio_bitmap_set(0x2B, D|T|    W|R|O|M|      K      , read);  /* SEEK(10) */
+	sgio_bitmap_set(0x3C, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* READ BUFFER */
+	sgio_bitmap_set(0x4D, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* LOG SENSE */
+	sgio_bitmap_set(0x5A, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* MODE SENSE(10) */
+	sgio_bitmap_set(0x9E, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* SERVICE ACTION IN(16) */
+	sgio_bitmap_set(0xA0, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* REPORT LUNS */
+	sgio_bitmap_set(0xA3, D|T|L|  W|  O|M|A|E|B|K|V    , read);  /* MAINTENANCE IN */
+
+	/* control, write */
+
+	sgio_bitmap_set(0x15, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, write); /* MODE SELECT(6) */
+	sgio_bitmap_set(0x4C, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, write); /* LOG SELECT */
+	sgio_bitmap_set(0x55, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, write); /* MODE SELECT(10) */
+	sgio_bitmap_set(0x1E, D|T|    W|R|O|M|      K|  F  , write); /* PREVENT ALLOW MEDIUM REMOVAL */
+
+	/* read */
+
+	sgio_bitmap_set(0x08, D|T|  P|W|  O|              C, read);  /* READ(6) */
+	sgio_bitmap_set(0x25, D|      W|R|O|      B|K      , read);  /* READ CAPACITY(10) */
+	sgio_bitmap_set(0x28, D|      W|R|O|      B|K|    C, read);  /* READ(10) */
+	sgio_bitmap_set(0x2F, D|      W|R|O                , read);  /* VERIFY(10) */
+	sgio_bitmap_set(0x37, D|          O|M              , read);  /* READ DEFECT DATA(10) */
+	sgio_bitmap_set(0x3E, D|      W|  O                , read);  /* READ LONG(10) */
+	sgio_bitmap_set(0x88, D|T|    W|  O|      B        , read);  /* READ(16) */
+	sgio_bitmap_set(0x8F, D|T|    W|  O|      B        , read);  /* VERIFY(16) */
+	sgio_bitmap_set(0xA8, D|      W|R|O|              C, read);  /* READ(12) */
+
+	/* write */
+
+	sgio_bitmap_set(0x04, D|T|L|    R|O                , write); /* FORMAT UNIT */
+	sgio_bitmap_set(0x0A, D|T|L|P|W|  O|              C, write); /* WRITE(6) */
+	sgio_bitmap_set(0x2A, D|      W|R|O|      B|K|    C, write); /* WRITE(10) */
+	sgio_bitmap_set(0x2E, D|      W|R|O|      B|K      , write); /* WRITE AND VERIFY(10) */
+	sgio_bitmap_set(0x35, D|      W|R|O|      B|K      , write); /* SYNCHRONIZE CACHE(10) */
+	sgio_bitmap_set(0x3F, D|      W|  O                , write); /* WRITE LONG(10) */
+	sgio_bitmap_set(0x8A, D|T|    W|  O|      B        , write); /* WRITE(16) */
+	sgio_bitmap_set(0xAA, D|      W|R|O|              C, write); /* WRITE(12) */
+	sgio_bitmap_set(0xAE, D|      W|  O                , write); /* WRITE AND VERIFY(12) */
+	sgio_bitmap_set(0xEA, D|      W|  O                , write); /* WRITE_LONG_2 ?? */
+
+	/* MMC */
+
+	sgio_bitmap_set(0x23,           R                  , read);  /* READ FORMAT CAPACITIES */
+	sgio_bitmap_set(0x42, D|        R                  , read);  /* READ SUB-CHANNEL / UNMAP !! */
+	sgio_bitmap_set(0x43,           R                  , read);  /* READ TOC/PMA/ATIP */
+	sgio_bitmap_set(0x44,   T|      R                  , read);  /* READ HEADER */
+	sgio_bitmap_set(0x45,           R                  , read);  /* PLAY AUDIO(10) */
+	sgio_bitmap_set(0x46,           R                  , read);  /* GET CONFIGURATION */
+	sgio_bitmap_set(0x47,           R                  , read);  /* PLAY AUDIO MSF */
+	sgio_bitmap_set(0x48, D|        R|        B        , read);  /* PLAY AUDIO TI / SANITIZE !! */
+	sgio_bitmap_set(0x4A,           R                  , read);  /* GET EVENT STATUS NOTIFICATION */
+	sgio_bitmap_set(0x4B,           R                  , read);  /* PAUSE/RESUME */
+	sgio_bitmap_set(0x4E,           R                  , read);  /* STOP PLAY/SCAN */
+	sgio_bitmap_set(0x51, D|        R                  , read);  /* READ DISC INFORMATION / XPWRITE(10) !! */
+	sgio_bitmap_set(0x52,           R                  , read);  /* READ TRACK INFORMATION */
+	sgio_bitmap_set(0x5C,           R                  , read);  /* READ BUFFER CAPACITY */
+	sgio_bitmap_set(0xA4, D|T|L|P|W|R|O|M|A|E|B|K|V|F|C, read);  /* REPORT KEY / 0xA4 service actions !! */
+	sgio_bitmap_set(0xAC,           R|O                , read);  /* GET PERFORMANCE / ERASE !! */
+	sgio_bitmap_set(0xAD,           R                  , read);  /* READ DVD STRUCTURE */
+	sgio_bitmap_set(0xB9,           R                  , read);  /* READ CD MSF */
+	sgio_bitmap_set(0xBA,           R                  , read);  /* SCAN */
+	sgio_bitmap_set(0xBC,           R                  , read);  /* PLAY CD */
+	sgio_bitmap_set(0xBE,           R                  , read);  /* READ CD */
+
+	sgio_bitmap_set(0x53, D|        R                  , write); /* RESERVE TRACK / XDWRITEREAD(10) */
+	sgio_bitmap_set(0x54,           R                  , write); /* SEND OPC INFORMATION */
+	sgio_bitmap_set(0x58,           R                  , write); /* REPAIR TRACK */
+	sgio_bitmap_set(0x5B,           R                  , write); /* CLOSE TRACK/SESSION */
+	sgio_bitmap_set(0x5D,           R                  , write); /* SEND CUE SHEET */
+	sgio_bitmap_set(0xA1, D|        R|        B        , write); /* BLANK / ATA PASS-THROUGH(12) */
+	sgio_bitmap_set(0xA2,           R                  , write); /* SEND EVENT */
+	sgio_bitmap_set(0xA3,           R                  , write); /* SEND KEY */
+	sgio_bitmap_set(0xA6,           R|  M              , write); /* LOAD/UNLOAD C/DVD */
+	sgio_bitmap_set(0xA7,           R                  , write); /* SET READ AHEAD */
+	sgio_bitmap_set(0xB6,           R|  M              , write); /* SET STREAMING */
+	sgio_bitmap_set(0xBB,           R                  , write); /* SET CD SPEED */
+	sgio_bitmap_set(0xBF,           R                  , write); /* SEND DVD STRUCTURE */
+
+	/* tape */
+
+	sgio_bitmap_set(0x19,   T                          , write); /* ERASE(6) */
+
+#undef D
+#undef T
+#undef L
+#undef P
+#undef W
+#undef R
+#undef O
+#undef M
+#undef C
+#undef A
+#undef E
+#undef B
+#undef K
+#undef V
+#undef F
 #undef sgio_bitmap_set
 
 	/*
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66216c1..06cc93e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -324,7 +324,10 @@ static inline int scsi_status_is_good(int status)
 #define TYPE_RAID           0x0c
 #define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
 #define TYPE_RBC	    0x0e
+#define TYPE_OCRW           0x0f
+#define TYPE_ADC            0x10
 #define TYPE_OSD            0x11
+#define TYPE_MAX            0x1f
 #define TYPE_NO_LUN         0x7f
 
 /* SCSI protocols; these are taken from SPC-3 section 7.5 */
-- 
1.8.1.4
