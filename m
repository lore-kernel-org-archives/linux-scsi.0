From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] make osst compile again after st structure changes
Date: 14 Nov 2004 14:53:48 -0600
Message-ID: <1100465634.23649.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:53426 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261382AbUKNUyG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 15:54:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

In a recent patch, all the ST_ typedefs were removed from st.h.  One of
the side effects of this makes osst no longer compile.  This patch
replaces all of the typedef uses from st.h with their struct
equivalents.

James

===== drivers/scsi/osst.c 1.61 vs edited =====
--- 1.61/drivers/scsi/osst.c	2004-11-11 02:43:34 -06:00
+++ edited/drivers/scsi/osst.c	2004-11-14 14:46:00 -06:00
@@ -473,7 +473,7 @@
 	char           * name = tape_name(STp);
 	os_aux_t       * aux  = STp->buffer->aux;
 	os_partition_t * par  = &(aux->partition);
-	ST_partstat    * STps = &(STp->ps[STp->partition]);
+	struct st_partstat    * STps = &(STp->ps[STp->partition]);
 	int		 blk_cnt, blk_sz, i;
 
 	if (STp->raw) {
@@ -902,7 +902,7 @@
 
 static int osst_initiate_read(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt)
 {
-	ST_partstat   * STps   = &(STp->ps[STp->partition]);
+	struct st_partstat   * STps   = &(STp->ps[STp->partition]);
 	Scsi_Request  * SRpnt  ;
 	unsigned char	cmd[MAX_COMMAND_SIZE];
 	int		retval = 0;
@@ -940,7 +940,7 @@
 
 static int osst_get_logical_frame(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int frame_seq_number, int quiet)
 {
-	ST_partstat * STps  = &(STp->ps[STp->partition]);
+	struct st_partstat * STps  = &(STp->ps[STp->partition]);
 	char        * name  = tape_name(STp);
 	int           cnt   = 0,
 		      bad   = 0,
@@ -1066,7 +1066,7 @@
 
 static int osst_seek_logical_blk(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int logical_blk_num)
 {
-        ST_partstat * STps = &(STp->ps[STp->partition]);
+        struct st_partstat * STps = &(STp->ps[STp->partition]);
 	char        * name = tape_name(STp);
 	int	retries    = 0;
 	int	frame_seq_estimate, ppos_estimate, move;
@@ -1205,7 +1205,7 @@
 
 static int osst_seek_sector(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int sector)
 {
-        ST_partstat   * STps   = &(STp->ps[STp->partition]);
+        struct st_partstat   * STps   = &(STp->ps[STp->partition]);
 	int		frame  = sector >> OSST_FRAME_SHIFT,
 			offset = (sector & OSST_SECTOR_MASK) << OSST_SECTOR_SHIFT, 
 			r;
@@ -1566,7 +1566,7 @@
 static int osst_write_error_recovery(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int pending)
 {
 	Scsi_Request * SRpnt  = * aSRpnt;
-	ST_partstat  * STps   = & STp->ps[STp->partition];
+	struct st_partstat  * STps   = & STp->ps[STp->partition];
 	char         * name   = tape_name(STp);
 	int            retval = 0;
 	int            rw_state;
@@ -2756,7 +2756,7 @@
 {
 	unsigned char	scmd[MAX_COMMAND_SIZE];
 	Scsi_Request  * SRpnt;
-	ST_partstat   * STps;
+	struct st_partstat   * STps;
 	int		result = 0;
 	int		pp     = (ppos == 3000 && !skip)? 0 : ppos;
 	char          * name   = tape_name(STp);
@@ -2812,7 +2812,7 @@
 
 static int osst_write_trailer(OS_Scsi_Tape *STp, Scsi_Request ** aSRpnt, int leave_at_EOT)
 {
-	ST_partstat * STps = &(STp->ps[STp->partition]);
+	struct st_partstat * STps = &(STp->ps[STp->partition]);
 	int result = 0;
 
 	if (STp->write_type != OS_WRITE_NEW_MARK) {
@@ -2843,7 +2843,7 @@
 	int            result = 0;
 	unsigned char  cmd[MAX_COMMAND_SIZE];
 	Scsi_Request * SRpnt = *aSRpnt;
-	ST_partstat  * STps;
+	struct st_partstat  * STps;
 	char         * name = tape_name(STp);
 
 	if ((STp->buffer)->writing) {
@@ -2969,7 +2969,7 @@
    seek_next is true. */
 static int osst_flush_buffer(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int seek_next)
 {
-	ST_partstat * STps;
+	struct st_partstat * STps;
 	int           backspace = 0, result = 0;
 #if DEBUG
 	char        * name = tape_name(STp);
@@ -3134,7 +3134,7 @@
 static void reset_state(OS_Scsi_Tape *STp)
 {
 	int i;
-	ST_partstat *STps;
+	struct st_partstat *STps;
 
 	STp->pos_unknown = 0;
 	for (i = 0; i < ST_NBR_PARTITIONS; i++) {
@@ -3160,8 +3160,8 @@
 	int            doing_write = 0;
 	const char   __user * b_point;
 	Scsi_Request * SRpnt = NULL;
-	ST_mode      * STm;
-	ST_partstat  * STps;
+	struct st_modedef   * STm;
+	struct st_partstat  * STps;
 	OS_Scsi_Tape * STp  = filp->private_data;
 	char         * name = tape_name(STp);
 
@@ -3480,8 +3480,8 @@
 	ssize_t        total, retval = 0;
 	ssize_t        i, transfer;
 	int            special;
-	ST_mode      * STm;
-	ST_partstat  * STps;
+	struct st_modedef      * STm;
+	struct st_partstat  * STps;
 	Scsi_Request * SRpnt = NULL;
 	OS_Scsi_Tape * STp   = filp->private_data;
 	char         * name  = tape_name(STp);
@@ -3660,7 +3660,8 @@
 

 /* Set the driver options */
-static void osst_log_options(OS_Scsi_Tape *STp, ST_mode *STm, char *name)
+static void osst_log_options(OS_Scsi_Tape *STp, struct st_modedef *STm,
+			     char *name)
 {
   printk(KERN_INFO
 "%s:I: Mode %d options: buffer writes: %d, async writes: %d, read ahead: %d\n",
@@ -3687,12 +3688,12 @@
 {
 	int       value;
 	long      code;
-	ST_mode * STm;
+	struct st_modedef * STm;
 	char    * name = tape_name(STp);
 
 	STm = &(STp->modes[STp->current_mode]);
 	if (!STm->defined) {
-		memcpy(STm, &(STp->modes[0]), sizeof(ST_mode));
+		memcpy(STm, &(STp->modes[0]), sizeof(*STm));
 		modes_defined = TRUE;
 #if DEBUG
 		if (debugging)
@@ -3847,7 +3848,7 @@
 	int            chg_eof = TRUE;
 	unsigned char  cmd[MAX_COMMAND_SIZE];
 	Scsi_Request * SRpnt = * aSRpnt;
-	ST_partstat  * STps;
+	struct st_partstat  * STps;
 	int            fileno, blkno, at_sm, frame_seq_numbr, logical_blk_num;
 	int            datalen = 0, direction = SCSI_DATA_NONE;
 	char         * name = tape_name(STp);
@@ -4231,8 +4232,8 @@
 	unsigned char  cmd[MAX_COMMAND_SIZE];
 	Scsi_Request * SRpnt = NULL;
 	OS_Scsi_Tape * STp;
-	ST_mode      * STm;
-	ST_partstat  * STps;
+	struct st_modedef      * STm;
+	struct st_partstat  * STps;
 	char         * name;
 	int            dev  = TAPE_NR(inode);
 	int            mode = TAPE_MODE(inode);
@@ -4589,8 +4590,8 @@
 {
 	int            result = 0, result2;
 	OS_Scsi_Tape * STp  = filp->private_data;
-	ST_mode      * STm  = &(STp->modes[STp->current_mode]);
-	ST_partstat  * STps = &(STp->ps[STp->partition]);
+	struct st_modedef      * STm  = &(STp->modes[STp->current_mode]);
+	struct st_partstat  * STps = &(STp->ps[STp->partition]);
 	Scsi_Request * SRpnt = NULL;
 	char         * name = tape_name(STp);
 
@@ -4704,8 +4705,8 @@
 {
 	int            i, cmd_nr, cmd_type, retval = 0;
 	unsigned int   blk;
-	ST_mode      * STm;
-	ST_partstat  * STps;
+	struct st_modedef      * STm;
+	struct st_partstat  * STps;
 	Scsi_Request * SRpnt = NULL;
 	OS_Scsi_Tape * STp   = file->private_data;
 	char         * name  = tape_name(STp);
@@ -5412,8 +5413,8 @@
 {
 	Scsi_Device    * SDp = to_scsi_device(dev);
 	OS_Scsi_Tape   * tpnt;
-	ST_mode        * STm;
-	ST_partstat    * STps;
+	struct st_modedef        * STm;
+	struct st_partstat    * STps;
 	OSST_buffer    * buffer;
 	struct gendisk * drive;
 	int              i, mode, dev_num;
===== drivers/scsi/osst.h 1.11 vs edited =====
--- 1.11/drivers/scsi/osst.h	2003-12-30 11:24:20 -06:00
+++ edited/drivers/scsi/osst.h	2004-11-14 14:37:57 -06:00
@@ -552,14 +552,14 @@
   int long_timeout;		/* timeout for commands known to take long time*/
 
   /* Mode characteristics */
-  ST_mode modes[ST_NBR_MODES];
+  struct st_modedef modes[ST_NBR_MODES];
   int current_mode;
 
   /* Status variables */
   int partition;
   int new_partition;
   int nbr_partitions;    /* zero until partition support enabled */
-  ST_partstat ps[ST_NBR_PARTITIONS];
+  struct st_partstat ps[ST_NBR_PARTITIONS];
   unsigned char dirty;
   unsigned char ready;
   unsigned char write_prot;



