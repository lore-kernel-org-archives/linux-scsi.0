From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 4/5] scsi_debug: change SCSI command parser to table driven
Date: Mon, 24 Nov 2014 23:05:30 -0500
Message-ID: <5474000A.2030501@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040603090206000906040303"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54392 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaKYEFw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 23:05:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>

This is a multi-part message in MIME format.
--------------040603090206000906040303
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

From: Douglas Gilbert <dgilbert@interlog.com>
Date: Mon, 24 Nov 2014 20:46:29 -0500
Subject: [PATCH 4/5] change SCSI command parser to table driven

The existing 'big switch' parser in queuecommand() is changed to
a table driven parser. The old and new queuecommand() were moved
in the source so diff would not shuffle them. Apart from the new
tables most other changes are refactoring existing response code
to be more easily called out of the table parser. The 'strict'
parameter is added so that cdb_s can be checked for non-zero
values in parts of the cdb that are reserved. Some other changes
include: tweak request sense response when D_SENSE differs; support
NDOB in Write Same(16); and fix crash in Get LBA Status when LBP
was inactive.
---
  drivers/scsi/scsi_debug.c | 1391 +++++++++++++++++++++++++++------------------
  1 file changed, 833 insertions(+), 558 deletions(-)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------040603090206000906040303
Content-Type: text/x-patch;
 name="0004-change-SCSI-command-parser-to-table-driven.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0004-change-SCSI-command-parser-to-table-driven.patch"

>From 040f9c4c79663d2fa37ceeed03cfb19e445e17f1 Mon Sep 17 00:00:00 2001
From: Douglas Gilbert <dgilbert@interlog.com>
Date: Mon, 24 Nov 2014 20:46:29 -0500
Subject: [PATCH 4/5] change SCSI command parser to table driven

The existing 'big switch' parser in queuecommand() is changed to
a table driven parser. The old and new queuecommand() were moved
in the source so diff would not shuffle them. Apart from the new
tables most other changes are refactoring existing response code
to be more easily called out of the table parser. The 'strict'
parameter is added so that cdb_s can be checked for non-zero
values in parts of the cdb that are reserved. Some other changes
include: tweak request sense response when D_SENSE differs; support
NDOB in Write Same(16); and fix crash in Get LBA Status when LBP
was inactive.
---
 drivers/scsi/scsi_debug.c | 1391 +++++++++++++++++++++++++++------------------
 1 file changed, 833 insertions(+), 558 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ee99aca..58e6040 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -71,10 +71,10 @@ static const char *scsi_debug_version_date = "20141022";
 /* Additional Sense Code (ASC) */
 #define NO_ADDITIONAL_SENSE 0x0
 #define LOGICAL_UNIT_NOT_READY 0x4
+#define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
 #define UNRECOVERED_READ_ERR 0x11
 #define PARAMETER_LIST_LENGTH_ERR 0x1a
 #define INVALID_OPCODE 0x20
-#define INVALID_COMMAND_OPCODE 0x20
 #define LBA_OUT_OF_RANGE 0x21
 #define INVALID_FIELD_IN_CDB 0x24
 #define INVALID_FIELD_IN_PARAM_LIST 0x26
@@ -136,6 +136,7 @@ static const char *scsi_debug_version_date = "20141022";
 #define DEF_VIRTUAL_GB   0
 #define DEF_VPD_USE_HOSTNO 1
 #define DEF_WRITESAME_LENGTH 0xFFFF
+#define DEF_STRICT 0
 #define DELAY_OVERRIDDEN -9999
 
 /* bit mask values for scsi_debug_opts */
@@ -183,8 +184,8 @@ static const char *scsi_debug_version_date = "20141022";
 #define SDEBUG_NUM_UAS 4
 
 /* for check_readiness() */
-#define UAS_ONLY 1
-#define UAS_TUR 0
+#define UAS_ONLY 1	/* check for UAs only */
+#define UAS_TUR 0	/* if no UAs then check if media access possible */
 
 /* when 1==SCSI_DEBUG_OPT_MEDIUM_ERR, a medium error is simulated at this
  * sector on read commands: */
@@ -210,6 +211,291 @@ static const char *scsi_debug_version_date = "20141022";
 #warning "Expect DEF_CMD_PER_LUN <= SCSI_DEBUG_CANQUEUE"
 #endif
 
+/* SCSI opcodes (first byte of cdb) mapped onto these indexes */
+enum sdeb_opcode_index {
+	SDEB_I_INVALID_OPCODE =	0,
+	SDEB_I_INQUIRY = 1,
+	SDEB_I_REPORT_LUNS = 2,
+	SDEB_I_REQUEST_SENSE = 3,
+	SDEB_I_TEST_UNIT_READY = 4,
+	SDEB_I_MODE_SENSE = 5,		/* 6, 10 */
+	SDEB_I_MODE_SELECT = 6,		/* 6, 10 */
+	SDEB_I_LOG_SENSE = 7,
+	SDEB_I_READ_CAPACITY = 8,	/* 10; 16 is in SA_IN(16) */
+	SDEB_I_READ = 9,		/* 6, 10, 12, 16 */
+	SDEB_I_WRITE = 10,		/* 6, 10, 12, 16 */
+	SDEB_I_START_STOP = 11,
+	SDEB_I_SERV_ACT_IN = 12,	/* 12, 16 */
+	SDEB_I_SERV_ACT_OUT = 13,	/* 12, 16 */
+	SDEB_I_MAINT_IN = 14,
+	SDEB_I_MAINT_OUT = 15,
+	SDEB_I_VERIFY = 16,		/* 10 only */
+	SDEB_I_VARIABLE_LEN = 17,
+	SDEB_I_RESERVE = 18,		/* 6, 10 */
+	SDEB_I_RELEASE = 19,		/* 6, 10 */
+	SDEB_I_ALLOW_REMOVAL = 20,	/* PREVENT ALLOW MEDIUM REMOVAL */
+	SDEB_I_REZERO_UNIT = 21,	/* REWIND in SSC */
+	SDEB_I_ATA_PT = 22,		/* 12, 16 */
+	SDEB_I_SEND_DIAG = 23,
+	SDEB_I_UNMAP = 24,
+	SDEB_I_XDWRITEREAD = 25,	/* 10 only */
+	SDEB_I_WRITE_BUFFER = 26,
+	SDEB_I_WRITE_SAME = 27,		/* 10, 16 */
+	SDEB_I_SYNC_CACHE = 28,		/* 10 only */
+	SDEB_I_COMP_WRITE = 29,
+	SDEB_I_LAST_ELEMENT = 30,	/* keep this last */
+};
+
+static const unsigned char opcode_ind_arr[256] = {
+/* 0x0; 0x0->0x1f: 6 byte cdbs */
+	SDEB_I_TEST_UNIT_READY, SDEB_I_REZERO_UNIT, 0, SDEB_I_REQUEST_SENSE,
+	    0, 0, 0, 0,
+	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, 0,
+	0, 0, SDEB_I_INQUIRY, 0, 0, SDEB_I_MODE_SELECT, SDEB_I_RESERVE,
+	    SDEB_I_RELEASE,
+	0, 0, SDEB_I_MODE_SENSE, SDEB_I_START_STOP, 0, SDEB_I_SEND_DIAG,
+	    SDEB_I_ALLOW_REMOVAL, 0,
+/* 0x20; 0x20->0x3f: 10 byte cdbs */
+	0, 0, 0, 0, 0, SDEB_I_READ_CAPACITY, 0, 0,
+	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, SDEB_I_VERIFY,
+	0, 0, 0, 0, 0, SDEB_I_SYNC_CACHE, 0, 0,
+	0, 0, 0, SDEB_I_WRITE_BUFFER, 0, 0, 0, 0,
+/* 0x40; 0x40->0x5f: 10 byte cdbs */
+	0, SDEB_I_WRITE_SAME, SDEB_I_UNMAP, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, SDEB_I_LOG_SENSE, 0, 0,
+	0, 0, 0, SDEB_I_XDWRITEREAD, 0, SDEB_I_MODE_SELECT, SDEB_I_RESERVE,
+	    SDEB_I_RELEASE,
+	0, 0, SDEB_I_MODE_SENSE, 0, 0, 0, 0, 0,
+/* 0x60; 0x60->0x7d are reserved */
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, SDEB_I_VARIABLE_LEN,
+/* 0x80; 0x80->0x9f: 16 byte cdbs */
+	0, 0, 0, 0, 0, SDEB_I_ATA_PT, 0, 0,
+	SDEB_I_READ, SDEB_I_COMP_WRITE, SDEB_I_WRITE, 0, 0, 0, 0, 0,
+	0, 0, 0, SDEB_I_WRITE_SAME, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, SDEB_I_SERV_ACT_IN, SDEB_I_SERV_ACT_OUT,
+/* 0xa0; 0xa0->0xbf: 12 byte cdbs */
+	SDEB_I_REPORT_LUNS, SDEB_I_ATA_PT, 0, SDEB_I_MAINT_IN,
+	     SDEB_I_MAINT_OUT, 0, 0, 0,
+	SDEB_I_READ, SDEB_I_SERV_ACT_OUT, SDEB_I_WRITE, SDEB_I_SERV_ACT_IN,
+	     0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+/* 0xc0; 0xc0->0xff: vendor specific */
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+};
+
+#define F_D_IN			1
+#define F_D_OUT			2
+#define F_D_OUT_MAYBE		4	/* WRITE SAME, NDOB bit */
+#define F_D_UNKN		8
+#define F_RL_WLUN_OK		0x10
+#define F_SKIP_UA		0x20
+#define F_DELAY_OVERR		0x40
+#define F_SA_LOW		0x80	/* cdb byte 1, bits 4 to 0 */
+#define F_SA_HIGH		0x100	/* as used by variable length cdbs */
+#define F_INV_OP		0x200
+#define F_FAKE_RW		0x400
+#define F_M_ACCESS		0x800	/* media access */
+
+#define FF_RESPOND (F_RL_WLUN_OK | F_SKIP_UA | F_DELAY_OVERR)
+#define FF_DIRECT_IO (F_M_ACCESS | F_FAKE_RW)
+#define FF_SA (F_SA_HIGH | F_SA_LOW)
+
+struct sdebug_dev_info;
+static int scsi_debug_queuecommand(struct scsi_cmnd *scp);
+static int resp_inquiry(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_report_luns(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_requests(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_mode_sense(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_mode_select(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_log_sense(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_readcap(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_read_dt0(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_write_dt0(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_start_stop(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_readcap16(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_get_lba_status(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_report_tgtpgs(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_unmap(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_write_same_10(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_write_same_16(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_xdwriteread_10(struct scsi_cmnd *, struct sdebug_dev_info *);
+
+struct opcode_info_t {
+	u8 num_attached;	/* 0 if this is it (i.e. a leaf); use 0xff
+				 * for terminating element */
+	u8 opcode;		/* if num_attached > 0, preferred */
+	u16 sa;			/* service action */
+	u32 flags;		/* OR-ed set of SDEB_F_* */
+	int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *);
+	const struct opcode_info_t *arrp;  /* num_attached elements or NULL */
+	u8 len_mask[16];	/* len=len_mask[0], then mask for cdb[1]... */
+				/* ignore cdb bytes after position 15 */
+};
+
+static const struct opcode_info_t msense_iarr[1] = {
+	{0, 0x1a, 0, F_D_IN, NULL, NULL,
+	    {6,  0xe8, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+};
+
+static const struct opcode_info_t mselect_iarr[1] = {
+	{0, 0x15, 0, F_D_OUT, NULL, NULL,
+	    {6,  0xf1, 0, 0, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+};
+
+static const struct opcode_info_t read_iarr[3] = {
+	{0, 0x28, 0, F_D_IN | FF_DIRECT_IO, resp_read_dt0, NULL,/* READ(10) */
+	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7, 0, 0,
+	     0, 0, 0, 0} },
+	{0, 0x8, 0, F_D_IN | FF_DIRECT_IO, resp_read_dt0, NULL, /* READ(6) */
+	    {6,  0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0xa8, 0, F_D_IN | FF_DIRECT_IO, resp_read_dt0, NULL,/* READ(12) */
+	    {12,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x9f,
+	     0xc7, 0, 0, 0, 0} },
+};
+
+static const struct opcode_info_t write_iarr[3] = {
+	{0, 0x2a, 0, F_D_OUT | FF_DIRECT_IO, resp_write_dt0, NULL,   /* 10 */
+	    {10,  0xfb, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7, 0, 0,
+	     0, 0, 0, 0} },
+	{0, 0xa, 0, F_D_OUT | FF_DIRECT_IO, resp_write_dt0, NULL,    /* 6 */
+	    {6,  0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0xaa, 0, F_D_OUT | FF_DIRECT_IO, resp_write_dt0, NULL,   /* 12 */
+	    {12,  0xfb, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x9f,
+	     0xc7, 0, 0, 0, 0} },
+};
+
+static const struct opcode_info_t sa_in_iarr[1] = {
+	{0, 0x9e, 0x12, F_SA_LOW | F_D_IN, resp_get_lba_status, NULL,
+	    {16,  0x12, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0xff, 0xff, 0, 0xc7} },
+};
+
+static const struct opcode_info_t vl_iarr[1] = {	/* VARIABLE LENGTH */
+	{0, 0x7f, 0xb, F_SA_HIGH | F_D_OUT | FF_DIRECT_IO, resp_write_dt0,
+	    NULL, {32,  0xc7, 0, 0, 0, 0, 0x1f, 0x18, 0x0, 0xb, 0xfa,
+		   0, 0xff, 0xff, 0xff, 0xff} },	/* WRITE(32) */
+};
+
+static const struct opcode_info_t maint_in_iarr[2] = {
+	{0, 0xa3, 0xc, F_SA_LOW | F_D_IN, NULL, NULL,
+	    {12,  0xc, 0x87, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0,
+	     0xc7, 0, 0, 0, 0} },
+	{0, 0xa3, 0xd, F_SA_LOW | F_D_IN, NULL, NULL,
+	    {12,  0xd, 0x80, 0, 0, 0, 0xff, 0xff, 0xff, 0xff, 0, 0xc7, 0, 0,
+	     0, 0} },
+};
+
+static const struct opcode_info_t write_same_iarr[1] = {
+	{0, 0x93, 0, F_D_OUT_MAYBE | FF_DIRECT_IO, resp_write_same_16, NULL,
+	    {16,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0xff, 0xff, 0x1f, 0xc7} },
+};
+
+static const struct opcode_info_t reserve_iarr[1] = {
+	{0, 0x16, 0, F_D_OUT, NULL, NULL,	/* RESERVE(6) */
+	    {6,  0x1f, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+};
+
+static const struct opcode_info_t release_iarr[1] = {
+	{0, 0x17, 0, F_D_OUT, NULL, NULL,	/* RELEASE(6) */
+	    {6,  0x1f, 0xff, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+};
+
+
+/* This array is accessed via SDEB_I_* values. Make sure all are mapped,
+ * plus the terminating elements for logic that scans this table such as
+ * REPORT SUPPORTED OPERATION CODES. */
+static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
+/* 0 */
+	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL,
+	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x12, 0, FF_RESPOND | F_D_IN, resp_inquiry, NULL,
+	    {6,  0xe3, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0xa0, 0, FF_RESPOND | F_D_IN, resp_report_luns, NULL,
+	    {12,  0xe3, 0xff, 0, 0, 0, 0xff, 0xff, 0xff, 0xff, 0, 0xc7, 0, 0,
+	     0, 0} },
+	{0, 0x3, 0, FF_RESPOND | F_D_IN, resp_requests, NULL,
+	    {6,  0xe1, 0, 0, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x0, 0, F_M_ACCESS | F_RL_WLUN_OK, NULL, NULL,/* TEST UNIT READY */
+	    {6,  0, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{1, 0x5a, 0, F_D_IN, resp_mode_sense, msense_iarr,
+	    {10,  0xf8, 0xff, 0xff, 0, 0, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0,
+	     0} },
+	{1, 0x55, 0, F_D_OUT, resp_mode_select, mselect_iarr,
+	    {10,  0xf1, 0, 0, 0, 0, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0} },
+	{0, 0x4d, 0, F_D_IN, resp_log_sense, NULL,
+	    {10,  0xe3, 0xff, 0xff, 0, 0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0,
+	     0, 0, 0} },
+	{0, 0x25, 0, F_D_IN, resp_readcap, NULL,
+	    {10,  0xe1, 0xff, 0xff, 0xff, 0xff, 0, 0, 0x1, 0xc7, 0, 0, 0, 0,
+	     0, 0} },
+	{3, 0x88, 0, F_D_IN | FF_DIRECT_IO, resp_read_dt0, read_iarr,
+	    {16,  0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0xff, 0xff, 0x9f, 0xc7} },		/* READ(16) */
+/* 10 */
+	{3, 0x8a, 0, F_D_OUT | FF_DIRECT_IO, resp_write_dt0, write_iarr,
+	    {16,  0xfa, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0xff, 0xff, 0x9f, 0xc7} },		/* WRITE(16) */
+	{0, 0x1b, 0, 0, resp_start_stop, NULL,		/* START STOP UNIT */
+	    {6,  0x1, 0, 0xf, 0xf7, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{1, 0x9e, 0x10, F_SA_LOW | F_D_IN, resp_readcap16, sa_in_iarr,
+	    {16,  0x10, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0xff, 0xff, 0x1, 0xc7} },	/* READ CAPACITY(16) */
+	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* SA OUT */
+	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{2, 0xa3, 0xa, F_SA_LOW | F_D_IN, resp_report_tgtpgs, maint_in_iarr,
+	    {12,  0xea, 0, 0, 0, 0, 0xff, 0xff, 0xff, 0xff, 0, 0xc7, 0, 0, 0,
+	     0} },
+	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* MAINT OUT */
+	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* VERIFY */
+	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{1, 0x7f, 0x9, F_SA_HIGH | F_D_IN | FF_DIRECT_IO, resp_read_dt0,
+	    vl_iarr, {32,  0xc7, 0, 0, 0, 0, 0x1f, 0x18, 0x0, 0x9, 0xfe, 0,
+		      0xff, 0xff, 0xff, 0xff} },/* VARIABLE LENGTH, READ(32) */
+	{1, 0x56, 0, F_D_OUT, NULL, reserve_iarr, /* RESERVE(10) */
+	    {10,  0xff, 0xff, 0xff, 0, 0, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0,
+	     0} },
+	{1, 0x57, 0, F_D_OUT, NULL, release_iarr, /* RELEASE(10) */
+	    {10,  0x13, 0xff, 0xff, 0, 0, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0,
+	     0} },
+/* 20 */
+	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ALLOW REMOVAL */
+	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x1, 0, 0, resp_start_stop, NULL, /* REWIND ?? */
+	    {6,  0x1, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ATA_PT */
+	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x1d, F_D_OUT, 0, NULL, NULL,	/* SEND DIAGNOSTIC */
+	    {6,  0xf7, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x42, 0, F_D_OUT | FF_DIRECT_IO, resp_unmap, NULL, /* UNMAP */
+	    {10,  0x1, 0, 0, 0, 0, 0x1f, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0} },
+	{0, 0x53, 0, F_D_IN | F_D_OUT | FF_DIRECT_IO, resp_xdwriteread_10,
+	    NULL, {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7,
+		   0, 0, 0, 0, 0, 0} },
+	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* WRITE_BUFFER */
+	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{1, 0x41, 0, F_D_OUT_MAYBE | FF_DIRECT_IO, resp_write_same_10,
+	    write_same_iarr, {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff,
+			      0xff, 0xc7, 0, 0, 0, 0, 0, 0} },
+	{0, 0x35, 0, F_DELAY_OVERR | FF_DIRECT_IO, NULL, NULL, /* SYNC_CACHE */
+	    {10,  0x7, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7, 0, 0,
+	     0, 0, 0, 0} },
+	{0, 0x89, 0, F_D_OUT | FF_DIRECT_IO, NULL, NULL,
+	    {16,  0xf8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0, 0,
+	     0, 0xff, 0x1f, 0xc7} },		/* COMPARE AND WRITE */
+
+/* 30 */
+	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
+	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+};
+
 struct sdebug_scmd_extra_t {
 	bool inj_recovered;
 	bool inj_transport;
@@ -257,6 +543,7 @@ static unsigned int scsi_debug_write_same_length = DEF_WRITESAME_LENGTH;
 static bool scsi_debug_removable = DEF_REMOVABLE;
 static bool scsi_debug_clustering;
 static bool scsi_debug_host_lock = DEF_HOST_LOCK;
+static bool scsi_debug_strict = DEF_STRICT;
 static bool sdebug_any_injecting_opt;
 
 static atomic_t sdebug_cmnd_count;
@@ -290,11 +577,10 @@ struct sdebug_dev_info {
 	unsigned int target;
 	u64 lun;
 	struct sdebug_host_info *sdbg_host;
-	u64 wlun;
 	unsigned long uas_bm[1];
 	atomic_t num_in_q;
-	char stopped;
-	char used;
+	char stopped;		/* TODO: should be atomic */
+	bool used;
 };
 
 struct sdebug_host_info {
@@ -477,65 +763,6 @@ mk_sense_invalid_opcode(struct scsi_cmnd *scp)
 	mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_OPCODE, 0);
 }
 
-static void get_data_transfer_info(unsigned char *cmd,
-				   unsigned long long *lba, unsigned int *num,
-				   u32 *ei_lba)
-{
-	*ei_lba = 0;
-
-	switch (*cmd) {
-	case VARIABLE_LENGTH_CMD:
-		*lba = (u64)cmd[19] | (u64)cmd[18] << 8 |
-			(u64)cmd[17] << 16 | (u64)cmd[16] << 24 |
-			(u64)cmd[15] << 32 | (u64)cmd[14] << 40 |
-			(u64)cmd[13] << 48 | (u64)cmd[12] << 56;
-
-		*ei_lba = (u32)cmd[23] | (u32)cmd[22] << 8 |
-			(u32)cmd[21] << 16 | (u32)cmd[20] << 24;
-
-		*num = (u32)cmd[31] | (u32)cmd[30] << 8 | (u32)cmd[29] << 16 |
-			(u32)cmd[28] << 24;
-		break;
-
-	case WRITE_SAME_16:
-	case WRITE_16:
-	case READ_16:
-		*lba = (u64)cmd[9] | (u64)cmd[8] << 8 |
-			(u64)cmd[7] << 16 | (u64)cmd[6] << 24 |
-			(u64)cmd[5] << 32 | (u64)cmd[4] << 40 |
-			(u64)cmd[3] << 48 | (u64)cmd[2] << 56;
-
-		*num = (u32)cmd[13] | (u32)cmd[12] << 8 | (u32)cmd[11] << 16 |
-			(u32)cmd[10] << 24;
-		break;
-	case WRITE_12:
-	case READ_12:
-		*lba = (u32)cmd[5] | (u32)cmd[4] << 8 | (u32)cmd[3] << 16 |
-			(u32)cmd[2] << 24;
-
-		*num = (u32)cmd[9] | (u32)cmd[8] << 8 | (u32)cmd[7] << 16 |
-			(u32)cmd[6] << 24;
-		break;
-	case WRITE_SAME:
-	case WRITE_10:
-	case READ_10:
-	case XDWRITEREAD_10:
-		*lba = (u32)cmd[5] | (u32)cmd[4] << 8 |	(u32)cmd[3] << 16 |
-			(u32)cmd[2] << 24;
-
-		*num = (u32)cmd[8] | (u32)cmd[7] << 8;
-		break;
-	case WRITE_6:
-	case READ_6:
-		*lba = (u32)cmd[3] | (u32)cmd[2] << 8 |
-			(u32)(cmd[1] & 0x1f) << 16;
-		*num = (0 == cmd[4]) ? 256 : cmd[4];
-		break;
-	default:
-		break;
-	}
-}
-
 static int scsi_debug_ioctl(struct scsi_device *dev, int cmd, void __user *arg)
 {
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) {
@@ -992,19 +1219,20 @@ static int inquiry_evpd_b2(unsigned char *arr)
 #define SDEBUG_LONG_INQ_SZ 96
 #define SDEBUG_MAX_INQ_ARR_SZ 584
 
-static int resp_inquiry(struct scsi_cmnd *scp, int target,
-			struct sdebug_dev_info * devip)
+static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	unsigned char pq_pdt;
 	unsigned char * arr;
 	unsigned char *cmd = scp->cmnd;
 	int alloc_len, n, ret;
+	bool have_wlun;
 
 	alloc_len = (cmd[3] << 8) + cmd[4];
 	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
-	if (devip->wlun)
+	have_wlun = (scp->device->lun == SAM2_WLUN_REPORT_LUNS);
+	if (have_wlun)
 		pq_pdt = 0x1e;	/* present, wlun */
 	else if (scsi_debug_no_lun_0 && (0 == devip->lun))
 		pq_pdt = 0x7f;	/* not present, no device type */
@@ -1024,7 +1252,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, int target,
 		    (devip->channel & 0x7f);
 		if (0 == scsi_debug_vpd_use_hostno)
 			host_no = 0;
-		lu_id_num = devip->wlun ? -1 : (((host_no + 1) * 2000) +
+		lu_id_num = have_wlun ? -1 : (((host_no + 1) * 2000) +
 			    (devip->target * 1000) + devip->lun);
 		target_dev_id = ((host_no + 1) * 2000) +
 				 (devip->target * 1000) - 3;
@@ -1142,18 +1370,20 @@ static int resp_requests(struct scsi_cmnd * scp,
 	unsigned char * sbuff;
 	unsigned char *cmd = scp->cmnd;
 	unsigned char arr[SCSI_SENSE_BUFFERSIZE];
-	int want_dsense;
+	bool dsense, want_dsense;
 	int len = 18;
 
 	memset(arr, 0, sizeof(arr));
-	want_dsense = !!(cmd[1] & 1) || scsi_debug_dsense;
+	dsense = !!(cmd[1] & 1);
+	want_dsense = dsense || scsi_debug_dsense;
 	sbuff = scp->sense_buffer;
 	if ((iec_m_pg[2] & 0x4) && (6 == (iec_m_pg[3] & 0xf))) {
-		if (want_dsense) {
+		if (dsense) {
 			arr[0] = 0x72;
 			arr[1] = 0x0;		/* NO_SENSE in sense_key */
 			arr[2] = THRESHOLD_EXCEEDED;
 			arr[3] = 0xff;		/* TEST set and MRIE==6 */
+			len = 8;
 		} else {
 			arr[0] = 0x70;
 			arr[2] = 0x0;		/* NO_SENSE in sense_key */
@@ -1163,15 +1393,34 @@ static int resp_requests(struct scsi_cmnd * scp,
 		}
 	} else {
 		memcpy(arr, sbuff, SCSI_SENSE_BUFFERSIZE);
-		if ((cmd[1] & 1) && (! scsi_debug_dsense)) {
-			/* DESC bit set and sense_buff in fixed format */
-			memset(arr, 0, sizeof(arr));
+		if (arr[0] >= 0x70 && dsense == scsi_debug_dsense)
+			;	/* have sense and formats match */
+		else if (arr[0] <= 0x70) {
+			if (dsense) {
+				memset(arr, 0, 8);
+				arr[0] = 0x72;
+				len = 8;
+			} else {
+				memset(arr, 0, 18);
+				arr[0] = 0x70;
+				arr[7] = 0xa;
+			}
+		} else if (dsense) {
+			memset(arr, 0, 8);
 			arr[0] = 0x72;
 			arr[1] = sbuff[2];     /* sense key */
 			arr[2] = sbuff[12];    /* asc */
 			arr[3] = sbuff[13];    /* ascq */
 			len = 8;
+		} else {
+			memset(arr, 0, 18);
+			arr[0] = 0x70;
+			arr[2] = sbuff[1];
+			arr[7] = 0xa;
+			arr[12] = sbuff[1];
+			arr[13] = sbuff[3];
 		}
+
 	}
 	mk_sense_buffer(scp, 0, NO_ADDITIONAL_SENSE, 0);
 	return fill_from_dev_buffer(scp, arr, len);
@@ -1181,11 +1430,8 @@ static int resp_start_stop(struct scsi_cmnd * scp,
 			   struct sdebug_dev_info * devip)
 {
 	unsigned char *cmd = scp->cmnd;
-	int power_cond, errsts, start;
+	int power_cond, start;
 
-	errsts = check_readiness(scp, UAS_ONLY, devip);
-	if (errsts)
-		return errsts;
 	power_cond = (cmd[4] & 0xf0) >> 4;
 	if (power_cond) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 4, 7);
@@ -1212,11 +1458,7 @@ static int resp_readcap(struct scsi_cmnd * scp,
 {
 	unsigned char arr[SDEBUG_READCAP_ARR_SZ];
 	unsigned int capac;
-	int errsts;
 
-	errsts = check_readiness(scp, UAS_ONLY, devip);
-	if (errsts)
-		return errsts;
 	/* following just in case virtual_gb changed */
 	sdebug_capacity = get_sdebug_capacity();
 	memset(arr, 0, SDEBUG_READCAP_ARR_SZ);
@@ -1244,11 +1486,8 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 	unsigned char *cmd = scp->cmnd;
 	unsigned char arr[SDEBUG_READCAP16_ARR_SZ];
 	unsigned long long capac;
-	int errsts, k, alloc_len;
+	int k, alloc_len;
 
-	errsts = check_readiness(scp, UAS_ONLY, devip);
-	if (errsts)
-		return errsts;
 	alloc_len = ((cmd[10] << 24) + (cmd[11] << 16) + (cmd[12] << 8)
 		     + cmd[13]);
 	/* following just in case virtual_gb changed */
@@ -1523,20 +1762,18 @@ static int resp_sas_sha_m_spg(unsigned char * p, int pcontrol)
 
 #define SDEBUG_MAX_MSENSE_SZ 256
 
-static int resp_mode_sense(struct scsi_cmnd * scp, int target,
-			   struct sdebug_dev_info * devip)
+static int
+resp_mode_sense(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	unsigned char dbd, llbaa;
 	int pcontrol, pcode, subpcode, bd_len;
 	unsigned char dev_spec;
-	int k, alloc_len, msense_6, offset, len, errsts, target_dev_id;
+	int k, alloc_len, msense_6, offset, len, target_dev_id;
+	int target = scp->device->id;
 	unsigned char * ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
 	unsigned char *cmd = scp->cmnd;
 
-	errsts = check_readiness(scp, UAS_ONLY, devip);
-	if (errsts)
-		return errsts;
 	dbd = !!(cmd[1] & 0x8);
 	pcontrol = (cmd[2] & 0xc0) >> 6;
 	pcode = cmd[2] & 0x3f;
@@ -1684,17 +1921,15 @@ static int resp_mode_sense(struct scsi_cmnd * scp, int target,
 
 #define SDEBUG_MAX_MSELECT_SZ 512
 
-static int resp_mode_select(struct scsi_cmnd * scp, int mselect6,
-			    struct sdebug_dev_info * devip)
+static int
+resp_mode_select(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	int pf, sp, ps, md_len, bd_len, off, spf, pg_len;
-	int param_len, res, errsts, mpage;
+	int param_len, res, mpage;
 	unsigned char arr[SDEBUG_MAX_MSELECT_SZ];
 	unsigned char *cmd = scp->cmnd;
+	int mselect6 = (MODE_SELECT == cmd[0]);
 
-	errsts = check_readiness(scp, UAS_ONLY, devip);
-	if (errsts)
-		return errsts;
 	memset(arr, 0, sizeof(arr));
 	pf = cmd[1] & 0x10;
 	sp = cmd[1] & 0x1;
@@ -1793,13 +2028,10 @@ static int resp_ie_l_pg(unsigned char * arr)
 static int resp_log_sense(struct scsi_cmnd * scp,
                           struct sdebug_dev_info * devip)
 {
-	int ppc, sp, pcontrol, pcode, subpcode, alloc_len, errsts, len, n;
+	int ppc, sp, pcontrol, pcode, subpcode, alloc_len, len, n;
 	unsigned char arr[SDEBUG_MAX_LSENSE_SZ];
 	unsigned char *cmd = scp->cmnd;
 
-	errsts = check_readiness(scp, UAS_ONLY, devip);
-	if (errsts)
-		return errsts;
 	memset(arr, 0, sizeof(arr));
 	ppc = cmd[1] & 0x2;
 	sp = cmd[1] & 0x1;
@@ -1889,17 +2121,17 @@ static int check_device_access_params(struct scsi_cmnd *scp,
 }
 
 /* Returns number of bytes copied or -1 if error. */
-static int do_device_access(struct scsi_cmnd *scmd,
-			    unsigned long long lba, unsigned int num, int write)
+static int
+do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num, bool do_write)
 {
 	int ret;
-	unsigned long long block, rest = 0;
+	u64 block, rest = 0;
 	struct scsi_data_buffer *sdb;
 	enum dma_data_direction dir;
 	size_t (*func)(struct scatterlist *, unsigned int, void *, size_t,
 		       off_t);
 
-	if (write) {
+	if (do_write) {
 		sdb = scsi_out(scmd);
 		dir = DMA_TO_DEVICE;
 		func = sg_pcopy_to_buffer;
@@ -2045,55 +2277,143 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 	return 0;
 }
 
-static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
-		     unsigned int num, u32 ei_lba)
+static int
+resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
+	u8 *cmd = scp->cmnd;
+	u64 lba;
+	u32 num;
+	u32 ei_lba;
 	unsigned long iflags;
 	int ret;
+	bool check_prot;
 
-	ret = check_device_access_params(SCpnt, lba, num);
-	if (ret)
-		return ret;
+	switch (cmd[0]) {
+	case READ_16:
+		ei_lba = 0;
+		lba = get_unaligned_be64(cmd + 2);
+		num = get_unaligned_be32(cmd + 10);
+		check_prot = true;
+		break;
+	case READ_10:
+		ei_lba = 0;
+		lba = get_unaligned_be32(cmd + 2);
+		num = get_unaligned_be16(cmd + 7);
+		check_prot = true;
+		break;
+	case READ_6:
+		ei_lba = 0;
+		lba = (u32)cmd[3] | (u32)cmd[2] << 8 |
+		      (u32)(cmd[1] & 0x1f) << 16;
+		num = (0 == cmd[4]) ? 256 : cmd[4];
+		check_prot = true;
+		break;
+	case READ_12:
+		ei_lba = 0;
+		lba = get_unaligned_be32(cmd + 2);
+		num = get_unaligned_be32(cmd + 6);
+		check_prot = true;
+		break;
+	case 0x53:	/* XDWRITEREAD(10) */
+		ei_lba = 0;
+		lba = get_unaligned_be32(cmd + 2);
+		num = get_unaligned_be16(cmd + 7);
+		check_prot = false;
+		break;
+	default:	/* assume READ(32) */
+		lba = get_unaligned_be64(cmd + 12);
+		ei_lba = get_unaligned_be32(cmd + 20);
+		num = get_unaligned_be32(cmd + 28);
+		check_prot = false;
+		break;
+	}
+	if (check_prot) {
+		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+		    (cmd[1] & 0xe0)) {
+			mk_sense_invalid_opcode(scp);
+			return check_condition_result;
+		}
+		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
+		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
+		    (cmd[1] & 0xe0) == 0)
+			sdev_printk(KERN_ERR, scp->device, "Unprotected RD "
+				    "to DIF device\n");
+	}
+	if (sdebug_any_injecting_opt) {
+		struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
+
+		if (ep->inj_short)
+			num /= 2;
+	}
+
+	/* inline check_device_access_params() */
+	if (lba + num > sdebug_capacity) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
+		return check_condition_result;
+	}
+	/* transfer length excessive (tie in to block limits VPD page) */
+	if (num > sdebug_store_sectors) {
+		/* needs work to find which cdb byte 'num' comes from */
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		return check_condition_result;
+	}
 
 	if ((SCSI_DEBUG_OPT_MEDIUM_ERR & scsi_debug_opts) &&
 	    (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
 	    ((lba + num) > OPT_MEDIUM_ERR_ADDR)) {
 		/* claim unrecoverable read error */
-		mk_sense_buffer(SCpnt, MEDIUM_ERROR, UNRECOVERED_READ_ERR, 0);
+		mk_sense_buffer(scp, MEDIUM_ERROR, UNRECOVERED_READ_ERR, 0);
 		/* set info field and valid bit for fixed descriptor */
-		if (0x70 == (SCpnt->sense_buffer[0] & 0x7f)) {
-			SCpnt->sense_buffer[0] |= 0x80;	/* Valid bit */
+		if (0x70 == (scp->sense_buffer[0] & 0x7f)) {
+			scp->sense_buffer[0] |= 0x80;	/* Valid bit */
 			ret = (lba < OPT_MEDIUM_ERR_ADDR)
 			      ? OPT_MEDIUM_ERR_ADDR : (int)lba;
-			SCpnt->sense_buffer[3] = (ret >> 24) & 0xff;
-			SCpnt->sense_buffer[4] = (ret >> 16) & 0xff;
-			SCpnt->sense_buffer[5] = (ret >> 8) & 0xff;
-			SCpnt->sense_buffer[6] = ret & 0xff;
+			put_unaligned_be32(ret, scp->sense_buffer + 3);
 		}
-	        scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
+		scsi_set_resid(scp, scsi_bufflen(scp));
 		return check_condition_result;
 	}
 
 	read_lock_irqsave(&atomic_rw, iflags);
 
 	/* DIX + T10 DIF */
-	if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
-		int prot_ret = prot_verify_read(SCpnt, lba, num, ei_lba);
+	if (scsi_debug_dix && scsi_prot_sg_count(scp)) {
+		int prot_ret = prot_verify_read(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
 			read_unlock_irqrestore(&atomic_rw, iflags);
-			mk_sense_buffer(SCpnt, ABORTED_COMMAND, 0x10, prot_ret);
+			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
-	ret = do_device_access(SCpnt, lba, num, 0);
+	ret = do_device_access(scp, lba, num, false);
 	read_unlock_irqrestore(&atomic_rw, iflags);
 	if (ret == -1)
 		return DID_ERROR << 16;
 
-	scsi_in(SCpnt)->resid = scsi_bufflen(SCpnt) - ret;
+	scsi_in(scp)->resid = scsi_bufflen(scp) - ret;
+
+	if (sdebug_any_injecting_opt) {
+		struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
 
+		if (ep->inj_recovered) {
+			mk_sense_buffer(scp, RECOVERED_ERROR,
+					THRESHOLD_EXCEEDED, 0);
+			return check_condition_result;
+		} else if (ep->inj_transport) {
+			mk_sense_buffer(scp, ABORTED_COMMAND,
+					TRANSPORT_PROBLEM, ACK_NAK_TO);
+			return check_condition_result;
+		} else if (ep->inj_dif) {
+			/* Logical block guard check failed */
+			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
+			return illegal_condition_result;
+		} else if (ep->inj_dix) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
+			return illegal_condition_result;
+		}
+	}
 	return 0;
 }
 
@@ -2276,31 +2596,95 @@ static void unmap_region(sector_t lba, unsigned int len)
 	}
 }
 
-static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
-		      unsigned int num, u32 ei_lba)
+static int
+resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
+	u8 *cmd = scp->cmnd;
+	u64 lba;
+	u32 num;
+	u32 ei_lba;
 	unsigned long iflags;
 	int ret;
+	bool check_prot;
 
-	ret = check_device_access_params(SCpnt, lba, num);
-	if (ret)
-		return ret;
+	switch (cmd[0]) {
+	case WRITE_16:
+		ei_lba = 0;
+		lba = get_unaligned_be64(cmd + 2);
+		num = get_unaligned_be32(cmd + 10);
+		check_prot = true;
+		break;
+	case WRITE_10:
+		ei_lba = 0;
+		lba = get_unaligned_be32(cmd + 2);
+		num = get_unaligned_be16(cmd + 7);
+		check_prot = true;
+		break;
+	case WRITE_6:
+		ei_lba = 0;
+		lba = (u32)cmd[3] | (u32)cmd[2] << 8 |
+		      (u32)(cmd[1] & 0x1f) << 16;
+		num = (0 == cmd[4]) ? 256 : cmd[4];
+		check_prot = true;
+		break;
+	case WRITE_12:
+		ei_lba = 0;
+		lba = get_unaligned_be32(cmd + 2);
+		num = get_unaligned_be32(cmd + 6);
+		check_prot = true;
+		break;
+	case 0x53:	/* XDWRITEREAD(10) */
+		ei_lba = 0;
+		lba = get_unaligned_be32(cmd + 2);
+		num = get_unaligned_be16(cmd + 7);
+		check_prot = false;
+		break;
+	default:	/* assume WRITE(32) */
+		lba = get_unaligned_be64(cmd + 12);
+		ei_lba = get_unaligned_be32(cmd + 20);
+		num = get_unaligned_be32(cmd + 28);
+		check_prot = false;
+		break;
+	}
+	if (check_prot) {
+		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+		    (cmd[1] & 0xe0)) {
+			mk_sense_invalid_opcode(scp);
+			return check_condition_result;
+		}
+		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
+		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
+		    (cmd[1] & 0xe0) == 0)
+			sdev_printk(KERN_ERR, scp->device, "Unprotected WR "
+				    "to DIF device\n");
+	}
+
+	/* inline check_device_access_params() */
+	if (lba + num > sdebug_capacity) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
+		return check_condition_result;
+	}
+	/* transfer length excessive (tie in to block limits VPD page) */
+	if (num > sdebug_store_sectors) {
+		/* needs work to find which cdb byte 'num' comes from */
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		return check_condition_result;
+	}
 
 	write_lock_irqsave(&atomic_rw, iflags);
 
 	/* DIX + T10 DIF */
-	if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
-		int prot_ret = prot_verify_write(SCpnt, lba, num, ei_lba);
+	if (scsi_debug_dix && scsi_prot_sg_count(scp)) {
+		int prot_ret = prot_verify_write(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
 			write_unlock_irqrestore(&atomic_rw, iflags);
-			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST, 0x10,
-					prot_ret);
+			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
-	ret = do_device_access(SCpnt, lba, num, 1);
+	ret = do_device_access(scp, lba, num, true);
 	if (scsi_debug_lbp())
 		map_region(lba, num);
 	write_unlock_irqrestore(&atomic_rw, iflags);
@@ -2308,30 +2692,41 @@ static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
 		return (DID_ERROR << 16);
 	else if ((ret < (num * scsi_debug_sector_size)) &&
 		 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
-		sdev_printk(KERN_INFO, SCpnt->device,
+		sdev_printk(KERN_INFO, scp->device,
 			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
 			    my_name, num * scsi_debug_sector_size, ret);
 
+	if (sdebug_any_injecting_opt) {
+		struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
+
+		if (ep->inj_recovered) {
+			mk_sense_buffer(scp, RECOVERED_ERROR,
+					THRESHOLD_EXCEEDED, 0);
+			return check_condition_result;
+		} else if (ep->inj_dif) {
+			/* Logical block guard check failed */
+			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
+			return illegal_condition_result;
+		} else if (ep->inj_dix) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
+			return illegal_condition_result;
+		}
+	}
 	return 0;
 }
 
-static int resp_write_same(struct scsi_cmnd *scmd, unsigned long long lba,
-		      unsigned int num, u32 ei_lba, unsigned int unmap)
+static int
+resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num, u32 ei_lba,
+		bool unmap, bool ndob)
 {
 	unsigned long iflags;
 	unsigned long long i;
 	int ret;
 
-	ret = check_device_access_params(scmd, lba, num);
+	ret = check_device_access_params(scp, lba, num);
 	if (ret)
 		return ret;
 
-	if (num > scsi_debug_write_same_length) {
-		mk_sense_buffer(scmd, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
-				0);
-		return check_condition_result;
-	}
-
 	write_lock_irqsave(&atomic_rw, iflags);
 
 	if (unmap && scsi_debug_lbp()) {
@@ -2339,17 +2734,22 @@ static int resp_write_same(struct scsi_cmnd *scmd, unsigned long long lba,
 		goto out;
 	}
 
-	/* Else fetch one logical block */
-	ret = fetch_to_dev_buffer(scmd,
-				  fake_storep + (lba * scsi_debug_sector_size),
-				  scsi_debug_sector_size);
+	/* if ndob then zero 1 logical block, else fetch 1 logical block */
+	if (ndob) {
+		memset(fake_storep + (lba * scsi_debug_sector_size), 0,
+		       scsi_debug_sector_size);
+		ret = 0;
+	} else
+		ret = fetch_to_dev_buffer(scp, fake_storep +
+					       (lba * scsi_debug_sector_size),
+					  scsi_debug_sector_size);
 
 	if (-1 == ret) {
 		write_unlock_irqrestore(&atomic_rw, iflags);
 		return (DID_ERROR << 16);
 	} else if ((ret < (num * scsi_debug_sector_size)) &&
 		 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
-		sdev_printk(KERN_INFO, scmd->device,
+		sdev_printk(KERN_INFO, scp->device,
 			    "%s: %s: cdb indicated=%u, IO sent=%d bytes\n",
 			    my_name, "write same",
 			    num * scsi_debug_sector_size, ret);
@@ -2368,13 +2768,67 @@ out:
 	return 0;
 }
 
+static int
+resp_write_same_10(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	u8 *cmd = scp->cmnd;
+	u32 lba;
+	u16 num;
+	u32 ei_lba = 0;
+	bool unmap = false;
+
+	if (cmd[1] & 0x8) {
+		if (scsi_debug_lbpws10 == 0) {
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 3);
+			return check_condition_result;
+		} else
+			unmap = true;
+	}
+	lba = get_unaligned_be32(cmd + 2);
+	num = get_unaligned_be16(cmd + 7);
+	if (num > scsi_debug_write_same_length) {
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 7, -1);
+		return check_condition_result;
+	}
+	return resp_write_same(scp, lba, num, ei_lba, unmap, false);
+}
+
+static int
+resp_write_same_16(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	u8 *cmd = scp->cmnd;
+	u64 lba;
+	u32 num;
+	u32 ei_lba = 0;
+	bool unmap = false;
+	bool ndob = false;
+
+	if (cmd[1] & 0x8) {	/* UNMAP */
+		if (scsi_debug_lbpws == 0) {
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 3);
+			return check_condition_result;
+		} else
+			unmap = true;
+	}
+	if (cmd[1] & 0x1)  /* NDOB (no data-out buffer, assumes zeroes) */
+		ndob = true;
+	lba = get_unaligned_be64(cmd + 2);
+	num = get_unaligned_be32(cmd + 10);
+	if (num > scsi_debug_write_same_length) {
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 10, -1);
+		return check_condition_result;
+	}
+	return resp_write_same(scp, lba, num, ei_lba, unmap, ndob);
+}
+
 struct unmap_block_desc {
 	__be64	lba;
 	__be32	blocks;
 	__be32	__reserved;
 };
 
-static int resp_unmap(struct scsi_cmnd * scmd, struct sdebug_dev_info * devip)
+static int
+resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	unsigned char *buf;
 	struct unmap_block_desc *desc;
@@ -2382,20 +2836,26 @@ static int resp_unmap(struct scsi_cmnd * scmd, struct sdebug_dev_info * devip)
 	int ret;
 	unsigned long iflags;
 
-	ret = check_readiness(scmd, UAS_ONLY, devip);
-	if (ret)
-		return ret;
 
-	payload_len = get_unaligned_be16(&scmd->cmnd[7]);
-	BUG_ON(scsi_bufflen(scmd) != payload_len);
+	if (!scsi_debug_lbp())
+		return 0;	/* fib and say its done */
+	payload_len = get_unaligned_be16(scp->cmnd + 7);
+	BUG_ON(scsi_bufflen(scp) != payload_len);
 
 	descriptors = (payload_len - 8) / 16;
+	if (descriptors > scsi_debug_unmap_max_desc) {
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 7, -1);
+		return check_condition_result;
+	}
 
-	buf = kmalloc(scsi_bufflen(scmd), GFP_ATOMIC);
-	if (!buf)
+	buf = kmalloc(scsi_bufflen(scp), GFP_ATOMIC);
+	if (!buf) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
+				INSUFF_RES_ASCQ);
 		return check_condition_result;
+	}
 
-	scsi_sg_copy_to_buffer(scmd, buf, scsi_bufflen(scmd));
+	scsi_sg_copy_to_buffer(scp, buf, scsi_bufflen(scp));
 
 	BUG_ON(get_unaligned_be16(&buf[0]) != payload_len - 2);
 	BUG_ON(get_unaligned_be16(&buf[2]) != descriptors * 16);
@@ -2408,7 +2868,7 @@ static int resp_unmap(struct scsi_cmnd * scmd, struct sdebug_dev_info * devip)
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
 		unsigned int num = get_unaligned_be32(&desc[i].blocks);
 
-		ret = check_device_access_params(scmd, lba, num);
+		ret = check_device_access_params(scp, lba, num);
 		if (ret)
 			goto out;
 
@@ -2426,37 +2886,44 @@ out:
 
 #define SDEBUG_GET_LBA_STATUS_LEN 32
 
-static int resp_get_lba_status(struct scsi_cmnd * scmd,
-			       struct sdebug_dev_info * devip)
+static int
+resp_get_lba_status(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
-	unsigned long long lba;
-	unsigned int alloc_len, mapped, num;
-	unsigned char arr[SDEBUG_GET_LBA_STATUS_LEN];
+	u8 *cmd = scp->cmnd;
+	u64 lba;
+	u32 alloc_len, mapped, num;
+	u8 arr[SDEBUG_GET_LBA_STATUS_LEN];
 	int ret;
 
-	ret = check_readiness(scmd, UAS_ONLY, devip);
-	if (ret)
-		return ret;
-
-	lba = get_unaligned_be64(&scmd->cmnd[2]);
-	alloc_len = get_unaligned_be32(&scmd->cmnd[10]);
+	lba = get_unaligned_be64(cmd + 2);
+	alloc_len = get_unaligned_be32(cmd + 10);
 
 	if (alloc_len < 24)
 		return 0;
 
-	ret = check_device_access_params(scmd, lba, 1);
+	ret = check_device_access_params(scp, lba, 1);
 	if (ret)
 		return ret;
 
-	mapped = map_state(lba, &num);
+	if (scsi_debug_lbp())
+		mapped = map_state(lba, &num);
+	else {
+		mapped = 1;
+		/* following just in case virtual_gb changed */
+		sdebug_capacity = get_sdebug_capacity();
+		if (sdebug_capacity - lba <= 0xffffffff)
+			num = sdebug_capacity - lba;
+		else
+			num = 0xffffffff;
+	}
 
 	memset(arr, 0, SDEBUG_GET_LBA_STATUS_LEN);
-	put_unaligned_be32(20, &arr[0]);	/* Parameter Data Length */
-	put_unaligned_be64(lba, &arr[8]);	/* LBA */
-	put_unaligned_be32(num, &arr[16]);	/* Number of blocks */
-	arr[20] = !mapped;			/* mapped = 0, unmapped = 1 */
+	put_unaligned_be32(20, arr);		/* Parameter Data Length */
+	put_unaligned_be64(lba, arr + 8);	/* LBA */
+	put_unaligned_be32(num, arr + 16);	/* Number of blocks */
+	arr[20] = !mapped;		/* prov_stat=0: mapped; 1: dealloc */
 
-	return fill_from_dev_buffer(scmd, arr, SDEBUG_GET_LBA_STATUS_LEN);
+	return fill_from_dev_buffer(scp, arr, SDEBUG_GET_LBA_STATUS_LEN);
 }
 
 #define SDEBUG_RLUN_ARR_SZ 256
@@ -2553,6 +3020,32 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	return 0;
 }
 
+static int
+resp_xdwriteread_10(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	u8 *cmd = scp->cmnd;
+	u64 lba;
+	u32 num;
+	int errsts;
+
+	if (!scsi_bidi_cmnd(scp)) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
+				INSUFF_RES_ASCQ);
+		return check_condition_result;
+	}
+	errsts = resp_read_dt0(scp, devip);
+	if (errsts)
+		return errsts;
+	if (!(cmd[1] & 0x4)) {		/* DISABLE_WRITE is not set */
+		errsts = resp_write_dt0(scp, devip);
+		if (errsts)
+			return errsts;
+	}
+	lba = get_unaligned_be32(cmd + 2);
+	num = get_unaligned_be16(cmd + 7);
+	return resp_xdwriteread(scp, lba, num, devip);
+}
+
 /* When timer or tasklet goes off this function is called. */
 static void sdebug_q_cmd_complete(unsigned long indx)
 {
@@ -2725,10 +3218,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 	open_devip->sdbg_host = sdbg_host;
 	atomic_set(&open_devip->num_in_q, 0);
 	set_bit(SDEBUG_UA_POR, open_devip->uas_bm);
-	open_devip->used = 1;
-	if (sdev->lun == SAM2_WLUN_REPORT_LUNS)
-		open_devip->wlun = SAM2_WLUN_REPORT_LUNS & 0xff;
-
+	open_devip->used = true;
 	return open_devip;
 }
 
@@ -2770,7 +3260,7 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (devip) {
 		/* make this slot available for re-use */
-		devip->used = 0;
+		devip->used = false;
 		sdp->hostdata = NULL;
 	}
 }
@@ -3215,6 +3705,7 @@ module_param_named(ptype, scsi_debug_ptype, int, S_IRUGO | S_IWUSR);
 module_param_named(removable, scsi_debug_removable, bool, S_IRUGO | S_IWUSR);
 module_param_named(scsi_level, scsi_debug_scsi_level, int, S_IRUGO);
 module_param_named(sector_size, scsi_debug_sector_size, int, S_IRUGO);
+module_param_named(strict, scsi_debug_strict, bool, S_IRUGO | S_IWUSR);
 module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int, S_IRUGO);
 module_param_named(unmap_granularity, scsi_debug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_max_blocks, scsi_debug_unmap_max_blocks, int, S_IRUGO);
@@ -3234,7 +3725,7 @@ MODULE_PARM_DESC(add_host, "0..127 hosts allowed(def=1)");
 MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
 MODULE_PARM_DESC(clustering, "when set enables larger transfers (def=0)");
 MODULE_PARM_DESC(delay, "response delay (def=1 jiffy); 0:imm, -1,-2:tiny");
-MODULE_PARM_DESC(dev_size_mb, "size in MB of ram shared by devs(def=8)");
+MODULE_PARM_DESC(dev_size_mb, "size in MiB of ram shared by devs(def=8)");
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
 MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
@@ -3261,11 +3752,12 @@ MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=6[SPC-4])");
 MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
+MODULE_PARM_DESC(strict, "stricter checks: reserved field in cdb (def=0)");
 MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
 MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
 MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=256)");
-MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)");
+MODULE_PARM_DESC(virtual_gb, "virtual gigabyte (GiB) size (def=0 -> use dev_size_mb)");
 MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
 MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
 
@@ -3644,11 +4136,10 @@ static ssize_t virtual_gb_show(struct device_driver *ddp, char *buf)
 {
         return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_virtual_gb);
 }
-
 static ssize_t virtual_gb_store(struct device_driver *ddp, const char *buf,
 				size_t count)
 {
-	int n;
+        int n;
 	bool changed;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
@@ -3813,6 +4304,23 @@ static ssize_t host_lock_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(host_lock);
 
+static ssize_t strict_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", !!scsi_debug_strict);
+}
+static ssize_t strict_store(struct device_driver *ddp, const char *buf,
+			    size_t count)
+{
+	int n;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		scsi_debug_strict = (n > 0);
+		return count;
+	}
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(strict);
+
 
 /* Note: The following array creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
@@ -3848,6 +4356,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_removable.attr,
 	&driver_attr_host_lock.attr,
 	&driver_attr_ndelay.attr,
+	&driver_attr_strict.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sdebug_drv);
@@ -4160,377 +4669,6 @@ static void sdebug_remove_adapter(void)
 }
 
 static int
-scsi_debug_queuecommand(struct scsi_cmnd *SCpnt)
-{
-	unsigned char *cmd = SCpnt->cmnd;
-	int len, k;
-	unsigned int num;
-	unsigned long long lba;
-	u32 ei_lba;
-	int errsts = 0;
-	int target = SCpnt->device->id;
-	struct sdebug_dev_info *devip = NULL;
-	int inj_recovered = 0;
-	int inj_transport = 0;
-	int inj_dif = 0;
-	int inj_dix = 0;
-	int inj_short = 0;
-	int delay_override = 0;
-	int unmap = 0;
-
-	scsi_set_resid(SCpnt, 0);
-	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) &&
-	    !(SCSI_DEBUG_OPT_NO_CDB_NOISE & scsi_debug_opts)) {
-		char b[120];
-		int n;
-
-		len = SCpnt->cmd_len;
-		if (len > 32)
-			strcpy(b, "too long, over 32 bytes");
-		else {
-			for (k = 0, n = 0; k < len; ++k)
-				n += scnprintf(b + n, sizeof(b) - n, "%02x ",
-					       (unsigned int)cmd[k]);
-		}
-		sdev_printk(KERN_INFO, SCpnt->device, "%s: cmd %s\n", my_name,
-			    b);
-	}
-
-	if ((SCpnt->device->lun >= scsi_debug_max_luns) &&
-	    (SCpnt->device->lun != SAM2_WLUN_REPORT_LUNS))
-		return schedule_resp(SCpnt, NULL, DID_NO_CONNECT << 16, 0);
-	devip = devInfoReg(SCpnt->device);
-	if (NULL == devip)
-		return schedule_resp(SCpnt, NULL, DID_NO_CONNECT << 16, 0);
-
-	if ((scsi_debug_every_nth != 0) &&
-	    (atomic_inc_return(&sdebug_cmnd_count) >=
-	     abs(scsi_debug_every_nth))) {
-		atomic_set(&sdebug_cmnd_count, 0);
-		if (scsi_debug_every_nth < -1)
-			scsi_debug_every_nth = -1;
-		if (SCSI_DEBUG_OPT_TIMEOUT & scsi_debug_opts)
-			return 0; /* ignore command causing timeout */
-		else if (SCSI_DEBUG_OPT_MAC_TIMEOUT & scsi_debug_opts &&
-			 scsi_medium_access_command(SCpnt))
-			return 0; /* time out reads and writes */
-		else if (SCSI_DEBUG_OPT_RECOVERED_ERR & scsi_debug_opts)
-			inj_recovered = 1; /* to reads and writes below */
-		else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & scsi_debug_opts)
-			inj_transport = 1; /* to reads and writes below */
-		else if (SCSI_DEBUG_OPT_DIF_ERR & scsi_debug_opts)
-			inj_dif = 1; /* to reads and writes below */
-		else if (SCSI_DEBUG_OPT_DIX_ERR & scsi_debug_opts)
-			inj_dix = 1; /* to reads and writes below */
-		else if (SCSI_DEBUG_OPT_SHORT_TRANSFER & scsi_debug_opts)
-			inj_short = 1;
-	}
-
-	if (devip->wlun) {
-		switch (*cmd) {
-		case INQUIRY:
-		case REQUEST_SENSE:
-		case TEST_UNIT_READY:
-		case REPORT_LUNS:
-			break;  /* only allowable wlun commands */
-		default:
-			if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-				printk(KERN_INFO "scsi_debug: Opcode: 0x%x "
-				       "not supported for wlun\n", *cmd);
-			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
-					INVALID_OPCODE, 0);
-			errsts = check_condition_result;
-			return schedule_resp(SCpnt, devip, errsts, 0);
-		}
-	}
-
-	switch (*cmd) {
-	case INQUIRY:     /* mandatory, ignore unit attention */
-		delay_override = 1;
-		errsts = resp_inquiry(SCpnt, target, devip);
-		break;
-	case REQUEST_SENSE:	/* mandatory, ignore unit attention */
-		delay_override = 1;
-		errsts = resp_requests(SCpnt, devip);
-		break;
-	case REZERO_UNIT:	/* actually this is REWIND for SSC */
-	case START_STOP:
-		errsts = resp_start_stop(SCpnt, devip);
-		break;
-	case ALLOW_MEDIUM_REMOVAL:
-		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
-		if (errsts)
-			break;
-		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-			printk(KERN_INFO "scsi_debug: Medium removal %s\n",
-			       cmd[4] ? "inhibited" : "enabled");
-		break;
-	case SEND_DIAGNOSTIC:     /* mandatory */
-		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
-		break;
-	case TEST_UNIT_READY:     /* mandatory */
-		/* delay_override = 1; */
-		errsts = check_readiness(SCpnt, UAS_TUR, devip);
-		break;
-	case RESERVE:
-		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
-		break;
-	case RESERVE_10:
-		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
-		break;
-	case RELEASE:
-		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
-		break;
-	case RELEASE_10:
-		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
-		break;
-	case READ_CAPACITY:
-		errsts = resp_readcap(SCpnt, devip);
-		break;
-	case SERVICE_ACTION_IN:
-		if (cmd[1] == SAI_READ_CAPACITY_16)
-			errsts = resp_readcap16(SCpnt, devip);
-		else if (cmd[1] == SAI_GET_LBA_STATUS) {
-
-			if (scsi_debug_lbp() == 0) {
-				mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
-						INVALID_COMMAND_OPCODE, 0);
-				errsts = check_condition_result;
-			} else
-				errsts = resp_get_lba_status(SCpnt, devip);
-		} else {
-			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
-					INVALID_OPCODE, 0);
-			errsts = check_condition_result;
-		}
-		break;
-	case MAINTENANCE_IN:
-		if (MI_REPORT_TARGET_PGS != cmd[1]) {
-			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
-					INVALID_OPCODE, 0);
-			errsts = check_condition_result;
-			break;
-		}
-		errsts = resp_report_tgtpgs(SCpnt, devip);
-		break;
-	case READ_16:
-	case READ_12:
-	case READ_10:
-		/* READ{10,12,16} and DIF Type 2 are natural enemies */
-		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
-		    cmd[1] & 0xe0) {
-			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
-					INVALID_COMMAND_OPCODE, 0);
-			errsts = check_condition_result;
-			break;
-		}
-
-		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
-		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
-		    (cmd[1] & 0xe0) == 0)
-			printk(KERN_ERR "Unprotected RD/WR to DIF device\n");
-
-		/* fall through */
-	case READ_6:
-read:
-		errsts = check_readiness(SCpnt, UAS_TUR, devip);
-		if (errsts)
-			break;
-		if (scsi_debug_fake_rw)
-			break;
-		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
-
-		if (inj_short)
-			num /= 2;
-
-		errsts = resp_read(SCpnt, lba, num, ei_lba);
-		if (inj_recovered && (0 == errsts)) {
-			mk_sense_buffer(SCpnt, RECOVERED_ERROR,
-					THRESHOLD_EXCEEDED, 0);
-			errsts = check_condition_result;
-		} else if (inj_transport && (0 == errsts)) {
-			mk_sense_buffer(SCpnt, ABORTED_COMMAND,
-					TRANSPORT_PROBLEM, ACK_NAK_TO);
-			errsts = check_condition_result;
-		} else if (inj_dif && (0 == errsts)) {
-			/* Logical block guard check failed */
-			mk_sense_buffer(SCpnt, ABORTED_COMMAND, 0x10, 1);
-			errsts = illegal_condition_result;
-		} else if (inj_dix && (0 == errsts)) {
-			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST, 0x10, 1);
-			errsts = illegal_condition_result;
-		}
-		break;
-	case REPORT_LUNS:	/* mandatory, ignore unit attention */
-		delay_override = 1;
-		errsts = resp_report_luns(SCpnt, devip);
-		break;
-	case VERIFY:		/* 10 byte SBC-2 command */
-		errsts = check_readiness(SCpnt, UAS_TUR, devip);
-		break;
-	case WRITE_16:
-	case WRITE_12:
-	case WRITE_10:
-		/* WRITE{10,12,16} and DIF Type 2 are natural enemies */
-		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
-		    cmd[1] & 0xe0) {
-			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
-					INVALID_COMMAND_OPCODE, 0);
-			errsts = check_condition_result;
-			break;
-		}
-
-		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
-		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
-		    (cmd[1] & 0xe0) == 0)
-			printk(KERN_ERR "Unprotected RD/WR to DIF device\n");
-
-		/* fall through */
-	case WRITE_6:
-write:
-		errsts = check_readiness(SCpnt, UAS_TUR, devip);
-		if (errsts)
-			break;
-		if (scsi_debug_fake_rw)
-			break;
-		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
-		errsts = resp_write(SCpnt, lba, num, ei_lba);
-		if (inj_recovered && (0 == errsts)) {
-			mk_sense_buffer(SCpnt, RECOVERED_ERROR,
-					THRESHOLD_EXCEEDED, 0);
-			errsts = check_condition_result;
-		} else if (inj_dif && (0 == errsts)) {
-			mk_sense_buffer(SCpnt, ABORTED_COMMAND, 0x10, 1);
-			errsts = illegal_condition_result;
-		} else if (inj_dix && (0 == errsts)) {
-			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST, 0x10, 1);
-			errsts = illegal_condition_result;
-		}
-		break;
-	case WRITE_SAME_16:
-	case WRITE_SAME:
-		if (cmd[1] & 0x8) {
-			if ((*cmd == WRITE_SAME_16 && scsi_debug_lbpws == 0) ||
-			    (*cmd == WRITE_SAME && scsi_debug_lbpws10 == 0)) {
-				mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
-						INVALID_FIELD_IN_CDB, 0);
-				errsts = check_condition_result;
-			} else
-				unmap = 1;
-		}
-		if (errsts)
-			break;
-		errsts = check_readiness(SCpnt, UAS_TUR, devip);
-		if (errsts)
-			break;
-		if (scsi_debug_fake_rw)
-			break;
-		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
-		errsts = resp_write_same(SCpnt, lba, num, ei_lba, unmap);
-		break;
-	case UNMAP:
-		errsts = check_readiness(SCpnt, UAS_TUR, devip);
-		if (errsts)
-			break;
-		if (scsi_debug_fake_rw)
-			break;
-
-		if (scsi_debug_unmap_max_desc == 0 || scsi_debug_lbpu == 0) {
-			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
-					INVALID_COMMAND_OPCODE, 0);
-			errsts = check_condition_result;
-		} else
-			errsts = resp_unmap(SCpnt, devip);
-		break;
-	case MODE_SENSE:
-	case MODE_SENSE_10:
-		errsts = resp_mode_sense(SCpnt, target, devip);
-		break;
-	case MODE_SELECT:
-		errsts = resp_mode_select(SCpnt, 1, devip);
-		break;
-	case MODE_SELECT_10:
-		errsts = resp_mode_select(SCpnt, 0, devip);
-		break;
-	case LOG_SENSE:
-		errsts = resp_log_sense(SCpnt, devip);
-		break;
-	case SYNCHRONIZE_CACHE:
-		delay_override = 1;
-		errsts = check_readiness(SCpnt, UAS_TUR, devip);
-		break;
-	case WRITE_BUFFER:
-		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
-		break;
-	case XDWRITEREAD_10:
-		if (!scsi_bidi_cmnd(SCpnt)) {
-			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
-					INVALID_FIELD_IN_CDB, 0);
-			errsts = check_condition_result;
-			break;
-		}
-
-		errsts = check_readiness(SCpnt, UAS_TUR, devip);
-		if (errsts)
-			break;
-		if (scsi_debug_fake_rw)
-			break;
-		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
-		errsts = resp_read(SCpnt, lba, num, ei_lba);
-		if (errsts)
-			break;
-		errsts = resp_write(SCpnt, lba, num, ei_lba);
-		if (errsts)
-			break;
-		errsts = resp_xdwriteread(SCpnt, lba, num, devip);
-		break;
-	case VARIABLE_LENGTH_CMD:
-		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION) {
-
-			if ((cmd[10] & 0xe0) == 0)
-				printk(KERN_ERR
-				       "Unprotected RD/WR to DIF device\n");
-
-			if (cmd[9] == READ_32) {
-				BUG_ON(SCpnt->cmd_len < 32);
-				goto read;
-			}
-
-			if (cmd[9] == WRITE_32) {
-				BUG_ON(SCpnt->cmd_len < 32);
-				goto write;
-			}
-		}
-
-		mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
-				INVALID_FIELD_IN_CDB, 0);
-		errsts = check_condition_result;
-		break;
-	case 0x85:
-		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-			sdev_printk(KERN_INFO, SCpnt->device,
-			"%s: ATA PASS-THROUGH(16) not supported\n", my_name);
-		mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
-				INVALID_OPCODE, 0);
-		errsts = check_condition_result;
-		break;
-	default:
-		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-			sdev_printk(KERN_INFO, SCpnt->device,
-				    "%s: Opcode: 0x%x not supported\n",
-				    my_name, *cmd);
-		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
-		if (errsts)
-			break;	/* Unit attention takes precedence */
-		mk_sense_buffer(SCpnt, ILLEGAL_REQUEST, INVALID_OPCODE, 0);
-		errsts = check_condition_result;
-		break;
-	}
-	return schedule_resp(SCpnt, devip, errsts,
-			     (delay_override ? 0 : scsi_debug_delay));
-}
-
-static int
 sdebug_queuecommand_lock_or_not(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
 	if (scsi_debug_host_lock) {
@@ -4637,6 +4775,143 @@ check_inject(struct scsi_cmnd *scp)
 	return 0;
 }
 
+static int
+scsi_debug_queuecommand(struct scsi_cmnd *scp)
+{
+	u8 sdeb_i;
+	struct scsi_device *sdp = scp->device;
+	const struct opcode_info_t *oip;
+	const struct opcode_info_t *r_oip;
+	struct sdebug_dev_info *devip;
+	u8 *cmd = scp->cmnd;
+	int (*r_pfp)(struct scsi_cmnd *, struct sdebug_dev_info *);
+	int k, na;
+	int errsts = 0;
+	int errsts_no_connect = DID_NO_CONNECT << 16;
+	u32 flags;
+	u16 sa;
+	u8 opcode = cmd[0];
+	bool has_wlun_rl;
+	bool debug = !!(SCSI_DEBUG_OPT_NOISE & scsi_debug_opts);
+
+	scsi_set_resid(scp, 0);
+	if (debug && !(SCSI_DEBUG_OPT_NO_CDB_NOISE & scsi_debug_opts)) {
+		char b[120];
+		int n, len, sb;
+
+		len = scp->cmd_len;
+		sb = (int)sizeof(b);
+		if (len > 32)
+			strcpy(b, "too long, over 32 bytes");
+		else {
+			for (k = 0, n = 0; k < len && n < sb; ++k)
+				n += scnprintf(b + n, sb - n, "%02x ",
+					       (u32)cmd[k]);
+		}
+		sdev_printk(KERN_INFO, sdp, "%s: cmd %s\n", my_name, b);
+	}
+	has_wlun_rl = (sdp->lun == SAM2_WLUN_REPORT_LUNS);
+	if ((sdp->lun >= scsi_debug_max_luns) && !has_wlun_rl)
+		return schedule_resp(scp, NULL, errsts_no_connect, 0);
+
+	sdeb_i = opcode_ind_arr[opcode];	/* fully mapped */
+	oip = &opcode_info_arr[sdeb_i];		/* safe if table consistent */
+	devip = (struct sdebug_dev_info *)sdp->hostdata;
+	if (!devip) {
+		devip = devInfoReg(sdp);
+		if (NULL == devip)
+			return schedule_resp(scp, NULL, errsts_no_connect, 0);
+	}
+	na = oip->num_attached;
+	r_pfp = oip->pfp;
+	if (na) {	/* multiple commands with this opcode */
+		r_oip = oip;
+		if (FF_SA & r_oip->flags) {
+			if (F_SA_LOW & oip->flags)
+				sa = 0x1f & cmd[1];
+			else
+				sa = get_unaligned_be16(cmd + 8);
+			for (k = 0; k <= na; oip = r_oip->arrp + k++) {
+				if (opcode == oip->opcode && sa == oip->sa)
+					break;
+			}
+		} else {   /* since no service action only check opcode */
+			for (k = 0; k <= na; oip = r_oip->arrp + k++) {
+				if (opcode == oip->opcode)
+					break;
+			}
+		}
+		if (k > na) {
+			if (F_SA_LOW & r_oip->flags)
+				mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 4);
+			else if (F_SA_HIGH & r_oip->flags)
+				mk_sense_invalid_fld(scp, SDEB_IN_CDB, 8, 7);
+			else
+				mk_sense_invalid_opcode(scp);
+			goto check_cond;
+		}
+	}	/* else (when na==0) we assume the oip is a match */
+	flags = oip->flags;
+	if (F_INV_OP & flags) {
+		mk_sense_invalid_opcode(scp);
+		goto check_cond;
+	}
+	if (has_wlun_rl && !(F_RL_WLUN_OK & flags)) {
+		if (debug)
+			sdev_printk(KERN_INFO, sdp, "scsi_debug: Opcode: "
+				    "0x%x not supported for wlun\n", opcode);
+		mk_sense_invalid_opcode(scp);
+		goto check_cond;
+	}
+	if (scsi_debug_strict) {	/* check cdb against mask */
+		u8 rem;
+		int j;
+
+		for (k = 1; k < oip->len_mask[0] && k < 16; ++k) {
+			rem = ~oip->len_mask[k] & cmd[k];
+			if (rem) {
+				for (j = 7; j >= 0; --j, rem <<= 1) {
+					if (0x80 & rem)
+						break;
+				}
+				mk_sense_invalid_fld(scp, SDEB_IN_CDB, k, j);
+				goto check_cond;
+			}
+		}
+	}
+	if (!(F_SKIP_UA & flags) &&
+	    SDEBUG_NUM_UAS != find_first_bit(devip->uas_bm, SDEBUG_NUM_UAS)) {
+		errsts = check_readiness(scp, UAS_ONLY, devip);
+		if (errsts)
+			goto check_cond;
+	}
+	if ((F_M_ACCESS & flags) && devip->stopped) {
+		mk_sense_buffer(scp, NOT_READY, LOGICAL_UNIT_NOT_READY, 0x2);
+		if (debug)
+			sdev_printk(KERN_INFO, sdp, "%s reports: Not ready: "
+				    "%s\n", my_name, "initializing command "
+				    "required");
+		errsts = check_condition_result;
+		goto fini;
+	}
+	if (scsi_debug_fake_rw && (F_FAKE_RW & flags))
+		goto fini;
+	if (scsi_debug_every_nth) {
+		if (check_inject(scp))
+			return 0;	/* ignore command: make trouble */
+	}
+	if (oip->pfp)	/* if this command has a resp_* function, call it */
+		errsts = oip->pfp(scp, devip);
+	else if (r_pfp)	/* if leaf function ptr NULL, try the root's */
+		errsts = r_pfp(scp, devip);
+
+fini:
+	return schedule_resp(scp, devip, errsts,
+			     ((F_DELAY_OVERR & flags) ? 0 : scsi_debug_delay));
+check_cond:
+	return schedule_resp(scp, devip, check_condition_result, 0);
+}
+
 static struct scsi_host_template sdebug_driver_template = {
 	.show_info =		scsi_debug_show_info,
 	.write_info =		scsi_debug_write_info,
-- 
1.9.1


--------------040603090206000906040303--
