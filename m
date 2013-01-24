From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 02/13] sg_io: reorganize list of allowed commands
Date: Thu, 24 Jan 2013 16:00:38 +0100
Message-ID: <1359039649-17734-3-git-send-email-pbonzini@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

To prepare for the next patches, reorganize the list of commands into
a two-way table of command numbers and device types.

One command (READ CAPACITY) was listed twice in the old table, hence
the new table has one entry less than the old one.

Right now, there is still just one bitmap and the mask is ignored,
so there is no semantic change yet.

Of course, checkpatch hates this table.  It has long lines and
non-standard spacing.  IMO the improved readability trumps the problems
reported by checkpatch.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |  209 ++++++++++++++++++++++++++++++++--------------------
 1 files changed, 130 insertions(+), 79 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a737562..75533bd 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -115,85 +115,136 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 
 static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 {
-	/* Basic read-only commands */
-	__set_bit(TEST_UNIT_READY, filter->read_ok);
-	__set_bit(REQUEST_SENSE, filter->read_ok);
-	__set_bit(READ_6, filter->read_ok);
-	__set_bit(READ_10, filter->read_ok);
-	__set_bit(READ_12, filter->read_ok);
-	__set_bit(READ_16, filter->read_ok);
-	__set_bit(READ_BUFFER, filter->read_ok);
-	__set_bit(READ_DEFECT_DATA, filter->read_ok);
-	__set_bit(READ_CAPACITY, filter->read_ok);
-	__set_bit(READ_LONG, filter->read_ok);
-	__set_bit(INQUIRY, filter->read_ok);
-	__set_bit(MODE_SENSE, filter->read_ok);
-	__set_bit(MODE_SENSE_10, filter->read_ok);
-	__set_bit(LOG_SENSE, filter->read_ok);
-	__set_bit(START_STOP, filter->read_ok);
-	__set_bit(GPCMD_VERIFY_10, filter->read_ok);
-	__set_bit(VERIFY_16, filter->read_ok);
-	__set_bit(REPORT_LUNS, filter->read_ok);
-	__set_bit(SERVICE_ACTION_IN, filter->read_ok);
-	__set_bit(RECEIVE_DIAGNOSTIC, filter->read_ok);
-	__set_bit(MAINTENANCE_IN, filter->read_ok);
-	__set_bit(GPCMD_READ_BUFFER_CAPACITY, filter->read_ok);
-
-	/* Audio CD commands */
-	__set_bit(GPCMD_PLAY_CD, filter->read_ok);
-	__set_bit(GPCMD_PLAY_AUDIO_10, filter->read_ok);
-	__set_bit(GPCMD_PLAY_AUDIO_MSF, filter->read_ok);
-	__set_bit(GPCMD_PLAY_AUDIO_TI, filter->read_ok);
-	__set_bit(GPCMD_PAUSE_RESUME, filter->read_ok);
-
-	/* CD/DVD data reading */
-	__set_bit(GPCMD_READ_CD, filter->read_ok);
-	__set_bit(GPCMD_READ_CD_MSF, filter->read_ok);
-	__set_bit(GPCMD_READ_DISC_INFO, filter->read_ok);
-	__set_bit(GPCMD_READ_CDVD_CAPACITY, filter->read_ok);
-	__set_bit(GPCMD_READ_DVD_STRUCTURE, filter->read_ok);
-	__set_bit(GPCMD_READ_HEADER, filter->read_ok);
-	__set_bit(GPCMD_READ_TRACK_RZONE_INFO, filter->read_ok);
-	__set_bit(GPCMD_READ_SUBCHANNEL, filter->read_ok);
-	__set_bit(GPCMD_READ_TOC_PMA_ATIP, filter->read_ok);
-	__set_bit(GPCMD_REPORT_KEY, filter->read_ok);
-	__set_bit(GPCMD_SCAN, filter->read_ok);
-	__set_bit(GPCMD_GET_CONFIGURATION, filter->read_ok);
-	__set_bit(GPCMD_READ_FORMAT_CAPACITIES, filter->read_ok);
-	__set_bit(GPCMD_GET_EVENT_STATUS_NOTIFICATION, filter->read_ok);
-	__set_bit(GPCMD_GET_PERFORMANCE, filter->read_ok);
-	__set_bit(GPCMD_SEEK, filter->read_ok);
-	__set_bit(GPCMD_STOP_PLAY_SCAN, filter->read_ok);
-
-	/* Basic writing commands */
-	__set_bit(WRITE_6, filter->write_ok);
-	__set_bit(WRITE_10, filter->write_ok);
-	__set_bit(WRITE_VERIFY, filter->write_ok);
-	__set_bit(WRITE_12, filter->write_ok);
-	__set_bit(WRITE_VERIFY_12, filter->write_ok);
-	__set_bit(WRITE_16, filter->write_ok);
-	__set_bit(WRITE_LONG, filter->write_ok);
-	__set_bit(WRITE_LONG_2, filter->write_ok);
-	__set_bit(ERASE, filter->write_ok);
-	__set_bit(GPCMD_MODE_SELECT_10, filter->write_ok);
-	__set_bit(MODE_SELECT, filter->write_ok);
-	__set_bit(LOG_SELECT, filter->write_ok);
-	__set_bit(GPCMD_BLANK, filter->write_ok);
-	__set_bit(GPCMD_CLOSE_TRACK, filter->write_ok);
-	__set_bit(GPCMD_FLUSH_CACHE, filter->write_ok);
-	__set_bit(GPCMD_FORMAT_UNIT, filter->write_ok);
-	__set_bit(GPCMD_REPAIR_RZONE_TRACK, filter->write_ok);
-	__set_bit(GPCMD_RESERVE_RZONE_TRACK, filter->write_ok);
-	__set_bit(GPCMD_SEND_DVD_STRUCTURE, filter->write_ok);
-	__set_bit(GPCMD_SEND_EVENT, filter->write_ok);
-	__set_bit(GPCMD_SEND_KEY, filter->write_ok);
-	__set_bit(GPCMD_SEND_OPC, filter->write_ok);
-	__set_bit(GPCMD_SEND_CUE_SHEET, filter->write_ok);
-	__set_bit(GPCMD_SET_SPEED, filter->write_ok);
-	__set_bit(GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL, filter->write_ok);
-	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
-	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
-	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
+#define sgio_bitmap_set(cmd, mask, rw) \
+	if ((mask) != 0) __set_bit((cmd), filter->rw##_ok)
+
+#define D (1u << TYPE_DISK)           /* Direct Access Block Device (SBC-3) */
+#define T (1u << TYPE_TAPE)           /* Sequential Access Device (SSC-3) */
+#define L (1u << TYPE_PRINTER)        /* Printer Device (SSC) */
+#define P (1u << TYPE_PROCESSOR)      /* Processor Device (SPC-2) */
+#define W (1u << TYPE_WORM)           /* Write Once Block Device (SBC) */
+#define R (1u << TYPE_ROM)            /* C/DVD Device (MMC-6) */
+#define S (1u << TYPE_SCANNER)        /* Scanner device (obsolete) */
+#define O (1u << TYPE_MOD)            /* Optical Memory Block Device (SBC) */
+#define M (1u << TYPE_MEDIUM_CHANGER) /* Media Changer Device (SMC-3) */
+#define C (1u << TYPE_COMM)           /* Communication devices (obsolete) */
+#define A (1u << TYPE_RAID)           /* Storage Array Device (SCC-2) */
+#define E (1u << TYPE_ENCLOSURE)      /* SCSI Enclosure Services device (SES-2) */
+#define B (1u << TYPE_RBC)            /* Simplified Direct-Access (Reduced Block) device (RBC) */
+#define K (1u << 0x0f)                /* Optical Card Reader/Writer device (OCRW) */
+#define V (1u << 0x10)                /* Automation/Device Interface device (ADC-2) */
+#define F (1u << TYPE_OSD)            /* Object-based Storage Device (OSD-2) */
+
+	/* control, universal except possibly RBC, read */
+
+	sgio_bitmap_set(0x00, -1                             , read);  // TEST UNIT READY
+	sgio_bitmap_set(0x03, -1                             , read);  // REQUEST SENSE
+	sgio_bitmap_set(0x12, -1                             , read);  // INQUIRY
+	sgio_bitmap_set(0x1A, -1                             , read);  // MODE SENSE(6)
+	sgio_bitmap_set(0x1B, D|T|L|  W|R|O|M|A|  B|K|V|F|  S, read);  // START STOP UNIT
+	sgio_bitmap_set(0x1C,                    ~B          , read);  // RECEIVE DIAGNOSTIC RESULTS
+	sgio_bitmap_set(0x2B, D|T|    W|R|O|M|      K        , read);  // SEEK(10)
+	sgio_bitmap_set(0x3C,                    ~B          , read);  // READ BUFFER
+	sgio_bitmap_set(0x4D, -1                             , read);  // LOG SENSE
+	sgio_bitmap_set(0x5A, -1                             , read);  // MODE SENSE(10)
+	sgio_bitmap_set(0x9E, -1                             , read);  // SERVICE ACTION IN(16)
+	sgio_bitmap_set(0xA0, -1                             , read);  // REPORT LUNS
+	sgio_bitmap_set(0xA3, D|T|L|  W|  O|M|A|E|B|K|V      , read);  // MAINTENANCE IN
+
+	/* control, universal, write */
+
+	sgio_bitmap_set(0x15, -1                             , write); // MODE SELECT(6)
+	sgio_bitmap_set(0x4C, -1                             , write); // LOG SELECT
+	sgio_bitmap_set(0x55, -1                             , write); // MODE SELECT(10)
+
+	/* control, write */
+
+	sgio_bitmap_set(0x1E, D|T|    W|R|O|M|      K|  F    , write); // PREVENT ALLOW MEDIUM REMOVAL
+
+	/* input */
+
+	sgio_bitmap_set(0x08, D|T|  P|W|  O|              C  , read);  // READ(6)
+	sgio_bitmap_set(0x25, D|      W|R|O|      B|K|      S, read);  // READ CAPACITY(10)
+	sgio_bitmap_set(0x28, D|      W|R|O|      B|K|    C  , read);  // READ(10)
+	sgio_bitmap_set(0x2F, D|      W|R|O                  , read);  // VERIFY(10)
+	sgio_bitmap_set(0x37, D|          O|M                , read);  // READ DEFECT DATA(10)
+	sgio_bitmap_set(0x3E, D|      W|  O                  , read);  // READ LONG(10)
+	sgio_bitmap_set(0x88, D|T|    W|  O|      B          , read);  // READ(16)
+	sgio_bitmap_set(0x8F, D|T|    W|  O|      B          , read);  // VERIFY(16)
+	sgio_bitmap_set(0xA8, D|      W|R|O|              C  , read);  // READ(12)
+
+	/* write */
+
+	sgio_bitmap_set(0x04, D|T|L|    R|O                  , write); // FORMAT UNIT
+	sgio_bitmap_set(0x0A, D|T|L|P|W|  O|              C  , write); // WRITE(6)
+	sgio_bitmap_set(0x2A, D|      W|R|O|      B|K|    C|S, write); // WRITE(10)
+	sgio_bitmap_set(0x2E, D|      W|R|O|      B|K        , write); // WRITE AND VERIFY(10)
+	sgio_bitmap_set(0x35, D|      W|R|O|      B|K        , write); // SYNCHRONIZE CACHE(10)
+	sgio_bitmap_set(0x3F, D|      W|  O                  , write); // WRITE LONG(10)
+	sgio_bitmap_set(0x8A, D|T|    W|  O|      B          , write); // WRITE(16)
+	sgio_bitmap_set(0xAA, D|      W|R|O|              C  , write); // WRITE(12)
+	sgio_bitmap_set(0xAE, D|      W|  O                  , write); // WRITE AND VERIFY(12)
+	sgio_bitmap_set(0xEA, D|      W|  O                  , write); // WRITE_LONG_2 ??
+
+	/* (mostly) MMC */
+
+	sgio_bitmap_set(0x23,           R                    , read);  // READ FORMAT CAPACITIES
+	sgio_bitmap_set(0x42, D|        R                    , read);  // READ SUB-CHANNEL / UNMAP !!
+	sgio_bitmap_set(0x43,           R                    , read);  // READ TOC/PMA/ATIP
+	sgio_bitmap_set(0x44,   T|      R|            V      , read);  // READ HEADER
+	sgio_bitmap_set(0x45,           R                    , read);  // PLAY AUDIO(10)
+	sgio_bitmap_set(0x46,           R                    , read);  // GET CONFIGURATION
+	sgio_bitmap_set(0x47,           R                    , read);  // PLAY AUDIO MSF
+	sgio_bitmap_set(0x48, D|        R|        B          , read);  // PLAY AUDIO TI / SANITIZE !!
+	sgio_bitmap_set(0x4A,           R                    , read);  // GET EVENT STATUS NOTIFICATION
+	sgio_bitmap_set(0x4B,           R                    , read);  // PAUSE/RESUME
+	sgio_bitmap_set(0x4E,           R                    , read);  // STOP PLAY/SCAN
+	sgio_bitmap_set(0x51, D|        R                    , read);  // READ DISC INFORMATION / XPWRITE(10) !!
+	sgio_bitmap_set(0x52,           R                    , read);  // READ TRACK INFORMATION
+	sgio_bitmap_set(0x5C,           R                    , read);  // READ BUFFER CAPACITY
+	sgio_bitmap_set(0xA4,           R                    , read);  // REPORT KEY
+	sgio_bitmap_set(0xAC,           R|O                  , read);  // GET PERFORMANCE / ERASE !!
+	sgio_bitmap_set(0xAD,           R                    , read);  // READ DVD STRUCTURE
+	sgio_bitmap_set(0xB9,           R                    , read);  // READ CD MSF
+	sgio_bitmap_set(0xBA,           R                    , read);  // SCAN
+	sgio_bitmap_set(0xBC,           R                    , read);  // PLAY CD
+	sgio_bitmap_set(0xBE,           R                    , read);  // READ CD
+
+	sgio_bitmap_set(0x53, D|        R                    , write); // RESERVE TRACK / XDWRITEREAD(10)
+	sgio_bitmap_set(0x54,           R                    , write); // SEND OPC INFORMATION
+	sgio_bitmap_set(0x58,           R                    , write); // REPAIR TRACK
+	sgio_bitmap_set(0x5B,           R                    , write); // CLOSE TRACK/SESSION
+	sgio_bitmap_set(0x5D,           R                    , write); // SEND CUE SHEET
+	sgio_bitmap_set(0xA1, D|        R|        B          , write); // BLANK / ATA PASS-THROUGH(12)
+	sgio_bitmap_set(0xA2,           R                    , write); // SEND EVENT
+	sgio_bitmap_set(0xA3,           R                    , write); // SEND KEY
+	sgio_bitmap_set(0xA6,           R|  M                , write); // LOAD/UNLOAD C/DVD
+	sgio_bitmap_set(0xA7,           R                    , write); // SET READ AHEAD
+	sgio_bitmap_set(0xB6,           R|  M                , write); // SET STREAMING
+	sgio_bitmap_set(0xBB,           R                    , write); // SET CD SPEED
+	sgio_bitmap_set(0xBF,           R                    , write); // SEND DVD STRUCTURE
+
+	/* (mostly) tape */
+
+	sgio_bitmap_set(0x19,   T                            , write); // ERASE(6)
+
+#undef D
+#undef T
+#undef L
+#undef P
+#undef W
+#undef R
+#undef S
+#undef O
+#undef M
+#undef C
+#undef A
+#undef E
+#undef B
+#undef K
+#undef V
+#undef F
+#undef sgio_bitmap_set
 }
 
 int blk_verify_command(struct request_queue *q,
-- 
1.7.1
