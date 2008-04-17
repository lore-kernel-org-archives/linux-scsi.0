From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/3 ver3] scsi: varlen extended and vendor-specific cdbs
Date: Thu, 17 Apr 2008 15:25:23 +0300
Message-ID: <480741B3.2080709@panasas.com>
References: <4804A0E7.6050002@panasas.com>
 <20080416110907B.fujita.tomonori@lab.ntt.co.jp> <48059F51.9060401@panasas.com>
 <20080417123224X.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxout4.netvision.net.il ([194.90.9.27]:33058 "EHLO
	mxout4.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbYDQMkk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2008 08:40:40 -0400
Received: from bh-buildlin2.bhalevy.com ([212.235.53.3])
 by mxout4.netvision.net.il
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JZG00MF8YILG680@mxout4.netvision.net.il> for
 linux-scsi@vger.kernel.org; Thu, 17 Apr 2008 15:25:34 +0300 (IDT)
In-reply-to: <20080417123224X.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, bzolnier@gmail.com, agk@redhat.com, Geert.Uytterhoeven@sonycom.com


  Add support for variable-length, extended, and vendor specific
  CDBs to scsi-ml. It is now possible for initiators and ULD's
  to issue these types of commands. LLDs need not change much.
  All they need is to raise the .max_cmd_len to the longest command
  they support (see iscsi patch).

  - clean-up some code paths that did not expect commands to be
    larger than 16, and change cmd_len members' type to short as
    char is not enough.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 block/scsi_ioctl.c       |    5 ++---
 drivers/scsi/constants.c |   10 +++-------
 drivers/scsi/scsi.c      |   15 ++++-----------
 drivers/scsi/scsi_lib.c  |    2 +-
 include/scsi/scsi.h      |   40 +++++++++++++++++++++++++++++++++-------
 include/scsi/scsi_cmnd.h |    2 +-
 include/scsi/scsi_host.h |    8 +++-----
 7 files changed, 47 insertions(+), 35 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a2c3a93..aaf07e4 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -33,13 +33,12 @@
 #include <scsi/scsi_cmnd.h>
 
 /* Command group 3 is reserved and should never be used.  */
-const unsigned char scsi_command_size[8] =
+const unsigned char scsi_command_size_tbl[8] =
 {
 	6, 10, 10, 12,
 	16, 12, 10, 10
 };
-
-EXPORT_SYMBOL(scsi_command_size);
+EXPORT_SYMBOL(scsi_command_size_tbl);
 
 #include <scsi/sg.h>
 
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 403a7f2..9785d73 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -28,7 +28,6 @@
 #define SERVICE_ACTION_OUT_12 0xa9
 #define SERVICE_ACTION_IN_16 0x9e
 #define SERVICE_ACTION_OUT_16 0x9f
-#define VARIABLE_LENGTH_CMD 0x7f
 
 
 
@@ -210,7 +209,7 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 	cdb0 = cdbp[0];
 	switch(cdb0) {
 	case VARIABLE_LENGTH_CMD:
-		len = cdbp[7] + 8;
+		len = scsi_varlen_cdb_length(cdbp);
 		if (len < 10) {
 			printk("short variable length command, "
 			       "len=%d ext_len=%d", len, cdb_len);
@@ -300,7 +299,7 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 	cdb0 = cdbp[0];
 	switch(cdb0) {
 	case VARIABLE_LENGTH_CMD:
-		len = cdbp[7] + 8;
+		len = scsi_varlen_cdb_length(cdbp);
 		if (len < 10) {
 			printk("short opcode=0x%x command, len=%d "
 			       "ext_len=%d", cdb0, len, cdb_len);
@@ -335,10 +334,7 @@ void __scsi_print_command(unsigned char *cdb)
 	int k, len;
 
 	print_opcode_name(cdb, 0);
-	if (VARIABLE_LENGTH_CMD == cdb[0])
-		len = cdb[7] + 8;
-	else
-		len = COMMAND_SIZE(cdb[0]);
+	len = scsi_command_size(cdb);
 	/* print out all bytes in cdb */
 	for (k = 0; k < len; ++k) 
 		printk(" %02x", cdb[k]);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index f6980bd..dd9dd65 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -79,15 +79,6 @@ static void scsi_done(struct scsi_cmnd *cmd);
 #define MIN_RESET_PERIOD (15*HZ)
 
 /*
- * Macro to determine the size of SCSI command. This macro takes vendor
- * unique commands into account. SCSI commands in groups 6 and 7 are
- * vendor unique and we will depend upon the command length being
- * supplied correctly in cmd_len.
- */
-#define CDB_SIZE(cmd)	(((((cmd)->cmnd[0] >> 5) & 7) < 6) ? \
-				COMMAND_SIZE((cmd)->cmnd[0]) : (cmd)->cmd_len)
-
-/*
  * Note - the initial logging level can be set here to log events at boot time.
  * After the system is up, you may enable logging via the /proc interface.
  */
@@ -701,9 +692,11 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	 * Before we queue this command, check if the command
 	 * length exceeds what the host adapter can handle.
 	 */
-	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len) {
+	if (cmd->cmd_len > cmd->device->host->max_cmd_len) {
 		SCSI_LOG_MLQUEUE(3,
-				printk("queuecommand : command too long.\n"));
+			printk("queuecommand : command too long. "
+			       "cdb_size=%d host->max_cmd_len=%d\n",
+			       cmd->cmd_len, cmd->device->host->max_cmd_len));
 		cmd->result = (DID_ABORT << 16);
 
 		scsi_done(cmd);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 325270b..ba7e8ad 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -445,7 +445,7 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	if (cmd->cmd_len == 0)
-		cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);
+		cmd->cmd_len = scsi_command_size(cmd->cmnd);
 }
 
 void scsi_device_unbusy(struct scsi_device *sdev)
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 1f74bcd..32742c4 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -30,13 +30,6 @@
 #endif
 
 /*
- *	SCSI command lengths
- */
-
-extern const unsigned char scsi_command_size[8];
-#define COMMAND_SIZE(opcode) scsi_command_size[((opcode) >> 5) & 7]
-
-/*
  * Special value for scanning to specify scanning or rescanning of all
  * possible channels, (target) ids, or luns on a given shost.
  */
@@ -109,6 +102,7 @@ extern const unsigned char scsi_command_size[8];
 #define MODE_SENSE_10         0x5a
 #define PERSISTENT_RESERVE_IN 0x5e
 #define PERSISTENT_RESERVE_OUT 0x5f
+#define VARIABLE_LENGTH_CMD   0x7f
 #define REPORT_LUNS           0xa0
 #define MAINTENANCE_IN        0xa3
 #define MOVE_MEDIUM           0xa5
@@ -136,6 +130,38 @@ extern const unsigned char scsi_command_size[8];
 #define	ATA_12		      0xa1	/* 12-byte pass-thru */
 
 /*
+ *	SCSI command lengths
+ */
+
+#define SCSI_MAX_VARLEN_CDB_SIZE 260
+
+/* defined in T10 SCSI Primary Commands-2 (SPC2) */
+struct scsi_varlen_cdb_hdr {
+	u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
+	u8 control;
+	u8 misc[5];
+	u8 additional_cdb_length;         /* total cdb length - 8 */
+	__be16 service_action;
+	/* service specific data follows */
+};
+
+static inline unsigned
+scsi_varlen_cdb_length(const void *hdr)
+{
+	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
+}
+
+extern const unsigned char scsi_command_size_tbl[8];
+#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
+
+static inline unsigned
+scsi_command_size(const unsigned char *cmnd)
+{
+	return (cmnd[0] == VARIABLE_LENGTH_CMD) ?
+		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
+}
+
+/*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
  *  T10/1561-D Revision 4 Draft dated 7th November 2002.
  */
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index dea73e5..f4dacb1 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -78,7 +78,7 @@ struct scsi_cmnd {
 	int allowed;
 	int timeout_per_command;
 
-	unsigned char cmd_len;
+	unsigned short cmd_len;
 	enum dma_data_direction sc_data_direction;
 
 	/* These elements define the operation we are about to perform */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 4913286..31f1bfd 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -573,13 +573,11 @@ struct Scsi_Host {
 	/*
 	 * The maximum length of SCSI commands that this host can accept.
 	 * Probably 12 for most host adapters, but could be 16 for others.
+	 * or 260 if the driver supports variable length cdbs.
 	 * For drivers that don't set this field, a value of 12 is
-	 * assumed.  I am leaving this as a number rather than a bit
-	 * because you never know what subsequent SCSI standards might do
-	 * (i.e. could there be a 20 byte or a 24-byte command a few years
-	 * down the road?).  
+	 * assumed.
 	 */
-	unsigned char max_cmd_len;
+	unsigned short max_cmd_len;
 
 	int this_id;
 	int can_queue;
-- 
1.5.3.3

