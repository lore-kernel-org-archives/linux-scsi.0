From: Willem Riede <wrlk@riede.org>
Subject: [PATCH] One more update for osst in 2.5.53
Date: Thu, 26 Dec 2002 17:47:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021226224730.GX7990@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="hoZxPH4CaxYzWscb"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id gBQMlUC07021
	for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2002 17:47:30 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--hoZxPH4CaxYzWscb
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Below is a patch for osst, against 2.5.53, which fixes a couple of bugs,
among which a pretty likely oops, and includes some cleanup. 
At this point I'm pretty satisfied that it works properly.

Thanks, Willem Riede.


--hoZxPH4CaxYzWscb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="osst-l2553-0.99.0.patch"

--- drivers/scsi/osst.c.l2553	Tue Dec 24 09:59:30 2002
+++ drivers/scsi/osst.c	Thu Dec 26 17:34:29 2002
@@ -16,15 +16,15 @@
   Copyright 1992 - 2002 Kai Makisara / Willem Riede
 	 email Kai.Makisara@metla.fi / osst@riede.org
 
-  $Header: /home/cvsroot/Driver/osst.c,v 1.65 2001/11/11 20:38:56 riede Exp $
+  $Header: /home/cvsroot/Driver/osst.c,v 1.68 2002/12/23 16:33:36 riede Exp $
 
   Microscopic alterations - Rik Ling, 2000/12/21
   Last st.c sync: Tue Oct 15 22:01:04 2002 by makisara
   Some small formal changes - aeb, 950809
 */
 
-static const char * cvsid = "$Id: osst.c,v 1.65 2001/11/11 20:38:56 riede Exp $";
-const char * osst_version = "0.99.0p5";
+static const char * cvsid = "$Id: osst.c,v 1.68 2002/12/23 16:33:36 riede Exp $";
+const char * osst_version = "0.99.0";
 
 /* The "failure to reconnect" firmware bug */
 #define OSST_FW_NEED_POLL_MIN 10601 /*(107A)*/
@@ -470,7 +470,7 @@
  */
 static int osst_verify_frame(OS_Scsi_Tape * STp, int frame_seq_number, int quiet)
 {
-	char *name = tape_name(STp);
+	char           * name = tape_name(STp);
 	os_aux_t       * aux  = STp->buffer->aux;
 	os_partition_t * par  = &(aux->partition);
 	ST_partstat    * STps = &(STp->ps[STp->partition]);
@@ -676,7 +676,7 @@
 	long		startwait = jiffies;
 #if DEBUG
 	int		dbg = debugging;
-	char *name = tape_name(STp);
+	char          * name = tape_name(STp);
 
 	printk(OSST_DEB_MSG "%s:D: Reached onstream wait for medium\n", name);
 #endif
@@ -748,7 +748,7 @@
 	int             result = 0;
 	int		delay  = OSST_WAIT_WRITE_COMPLETE;
 #if DEBUG
-	char *name = tape_name(STp);
+	char          * name = tape_name(STp);
 
 	printk(OSST_DEB_MSG "%s:D: Reached onstream flush drive buffer (write filemark)\n", name);
 #endif
@@ -778,7 +778,7 @@
 static int osst_wait_frame(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int curr, int minlast, int to)
 {
 	long	startwait     = jiffies;
-	char *name = tape_name(STp);
+	char  * name          = tape_name(STp);
 #if DEBUG
 	char	notyetprinted = 1;
 #endif
@@ -841,7 +841,7 @@
 	int		retval = 0;
 #if DEBUG
 	os_aux_t      * aux    = STp->buffer->aux;
-	char *name = tape_name(STp);
+	char          * name = tape_name(STp);
 #endif
 
 	/* TODO: Error handling */
@@ -888,10 +888,12 @@
 	    STp->first_frame_position++;
 #if DEBUG
 	if (debugging) {
+	   char sig[8]; int i;
+	   for (i=0;i<4;i++)
+		   sig[i] = aux->application_sig[i]<32?'^':aux->application_sig[i];
+	   sig[4] = '\0';
 	   printk(OSST_DEB_MSG 
-		"%s:D: AUX: %c%c%c%c UpdFrCt#%d Wpass#%d %s FrSeq#%d LogBlk#%d Qty=%d Sz=%d\n", name,
-			aux->application_sig[0], aux->application_sig[1],
-			aux->application_sig[2], aux->application_sig[3], 
+		"%s:D: AUX: %s UpdFrCt#%d Wpass#%d %s FrSeq#%d LogBlk#%d Qty=%d Sz=%d\n", name, sig,
 			ntohl(aux->update_frame_cntr), ntohs(aux->partition.wrt_pass_cntr),
 			aux->frame_type==1?"EOD":aux->frame_type==2?"MARK":
 			aux->frame_type==8?"HEADR":aux->frame_type==0x80?"DATA":"FILL", 
@@ -913,7 +915,7 @@
 	unsigned char	cmd[MAX_COMMAND_SIZE];
 	int		retval = 0;
 #if DEBUG
-	char *name = tape_name(STp);
+	char          * name = tape_name(STp);
 #endif
 
 	if (STps->rw != ST_READING) {         /* Initialize read operation */
@@ -947,7 +949,7 @@
 static int osst_get_logical_frame(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int frame_seq_number, int quiet)
 {
 	ST_partstat * STps  = &(STp->ps[STp->partition]);
-	char *name = tape_name(STp);
+	char        * name  = tape_name(STp);
 	int           cnt   = 0,
 		      bad   = 0,
 		      past  = 0,
@@ -1073,7 +1075,7 @@
 static int osst_seek_logical_blk(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int logical_blk_num)
 {
         ST_partstat * STps = &(STp->ps[STp->partition]);
-	char *name = tape_name(STp);
+	char        * name = tape_name(STp);
 	int	retries    = 0;
 	int	frame_seq_estimate, ppos_estimate, move;
 	
@@ -1183,7 +1185,7 @@
 {
 	int	sector;
 #if DEBUG
-	char *name = tape_name(STp);
+	char  * name = tape_name(STp);
 	
 	printk(OSST_DEB_MSG 
 		"%s:D: Positioned at ppos %d, frame %d, lbn %d, file %d, blk %d, %cptr %d, eof %d\n",
@@ -1216,7 +1218,7 @@
 			offset = (sector & OSST_SECTOR_MASK) << OSST_SECTOR_SHIFT, 
 			r;
 #if DEBUG
-	char *name = tape_name(STp);
+	char          * name = tape_name(STp);
 
 	printk(OSST_DEB_MSG "%s:D: Seeking sector %d in frame %d at offset %d\n",
 				name, sector, frame, offset);
@@ -1285,7 +1287,7 @@
 						- (nframes + pending - 1);
 	int             logical_blk_num  = ntohl(STp->buffer->aux->logical_blk_num) 
 						- (nframes + pending - 1) * blks_per_frame;
-	char *name = tape_name(STp);
+	char          * name             = tape_name(STp);
 	long		startwait        = jiffies;
 #if DEBUG
 	int		dbg              = debugging;
@@ -1471,7 +1473,7 @@
 {
 	unsigned char	cmd[MAX_COMMAND_SIZE];
 	Scsi_Request  * SRpnt;
-	char *name = tape_name(STp);
+	char          * name      = tape_name(STp);
 	int		expected  = 0;
 	int		attempts  = 1000 / skip;
 	int		flag      = 1;
@@ -1574,7 +1576,7 @@
 {
 	Scsi_Request * SRpnt  = * aSRpnt;
 	ST_partstat  * STps   = & STp->ps[STp->partition];
-	char *name = tape_name(STp);
+	char         * name   = tape_name(STp);
 	int            retval = 0;
 	int            rw_state;
 	unsigned int  frame, skip;
@@ -1650,7 +1652,7 @@
 static int osst_space_over_filemarks_backward(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt,
 								 int mt_op, int mt_count)
 {
-	char *name = tape_name(STp);
+	char  * name = tape_name(STp);
 	int     cnt;
 	int     last_mark_ppos = -1;
 
@@ -1751,7 +1753,7 @@
 {
 	int	cnt = 0;
 #if DEBUG
-	char *name = tape_name(STp);
+	char  * name = tape_name(STp);
 
 	printk(OSST_DEB_MSG "%s:D: Reached space_over_filemarks_forward_slow %d %d\n", name, mt_op, mt_count);
 #endif
@@ -1803,8 +1805,8 @@
 static int osst_space_over_filemarks_forward_fast(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt,
 								     int mt_op, int mt_count)
 {
-	char *name = tape_name(STp);
-	int	cnt = 0,
+	char  * name = tape_name(STp);
+	int	cnt  = 0,
 		next_mark_ppos = -1;
 
 #if DEBUG
@@ -1954,8 +1956,8 @@
 static void osst_set_retries(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int retries)
 {
 	unsigned char	cmd[MAX_COMMAND_SIZE];
-	Scsi_Request     * SRpnt  = * aSRpnt;
-	char *name = tape_name(STp);
+	Scsi_Request  * SRpnt  = * aSRpnt;
+	char          * name   = tape_name(STp);
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SELECT;
@@ -1989,7 +1991,7 @@
 	int	this_mark_ppos = STp->first_frame_position;
 	int	this_mark_lbn  = STp->logical_blk_num;
 #if DEBUG
-	char *name = tape_name(STp);
+	char  * name = tape_name(STp);
 #endif
 
 	if (STp->raw) return 0;
@@ -2015,7 +2017,7 @@
 {
 	int	result;
 #if DEBUG
-	char *name = tape_name(STp);
+	char  * name = tape_name(STp);
 #endif
 
 	if (STp->raw) return 0;
@@ -2036,7 +2038,7 @@
 
 static int osst_write_filler(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int where, int count)
 {
-	char *name = tape_name(STp);
+	char * name = tape_name(STp);
 
 #if DEBUG
 	printk(OSST_DEB_MSG "%s:D: Reached onstream write filler group %d\n", name, where);
@@ -2061,7 +2063,7 @@
 
 static int __osst_write_header(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int where, int count)
 {
-	char *name = tape_name(STp);
+	char * name = tape_name(STp);
 	int     result;
 
 #if DEBUG
@@ -2090,7 +2092,7 @@
 {
 	os_header_t * header;
 	int	      result;
-	char *name = tape_name(STp);
+	char        * name = tape_name(STp);
 
 #if DEBUG
 	printk(OSST_DEB_MSG "%s:D: Writing tape header\n", name);
@@ -2175,7 +2177,7 @@
 
 static int __osst_analyze_headers(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int ppos)
 {
-	char *name = tape_name(STp);
+	char        * name = tape_name(STp);
 	os_header_t * header;
 	os_aux_t    * aux;
 	char          id_string[8];
@@ -2352,10 +2354,10 @@
 
 static int osst_analyze_headers(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt)
 {
-	int position, ppos;
+	int	position, ppos;
 	int	first, last;
 	int	valid = 0;
-	char *name = tape_name(STp);
+	char  * name  = tape_name(STp);
 
 	position = osst_get_frame_position(STp, aSRpnt);
 
@@ -2408,14 +2410,14 @@
 static int osst_verify_position(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt)
 {
 	int	frame_position  = STp->first_frame_position;
-	int frame_seq_numbr = STp->frame_seq_number;
+	int	frame_seq_numbr = STp->frame_seq_number;
 	int	logical_blk_num = STp->logical_blk_num;
-       	int halfway_frame   = STp->frame_in_buffer;
-	int read_pointer    = STp->buffer->read_pointer;
+       	int	halfway_frame   = STp->frame_in_buffer;
+	int	read_pointer    = STp->buffer->read_pointer;
 	int	prev_mark_ppos  = -1;
 	int	actual_mark_ppos, i, n;
 #if DEBUG
-	char *name = tape_name(STp);
+	char  * name = tape_name(STp);
 
 	printk(OSST_DEB_MSG "%s:D: Verify that the tape is really the one we think before writing\n", name);
 #endif
@@ -2484,8 +2486,8 @@
 static int osst_configure_onstream(OS_Scsi_Tape *STp, Scsi_Request ** aSRpnt)
 {
 	unsigned char                  cmd[MAX_COMMAND_SIZE];
-	char *name = tape_name(STp);
-	Scsi_Request                    * SRpnt = * aSRpnt;
+	char                         * name = tape_name(STp);
+	Scsi_Request                 * SRpnt = * aSRpnt;
 	osst_mode_parameter_header_t * header;
 	osst_block_size_page_t       * bs;
 	osst_capabilities_page_t     * cp;
@@ -2655,7 +2657,7 @@
 static int cross_eof(OS_Scsi_Tape *STp, Scsi_Request ** aSRpnt, int forward)
 {
 	int	result;
-	char *name = tape_name(STp);
+	char  * name = tape_name(STp);
 
 #if DEBUG
 	if (debugging)
@@ -2692,7 +2694,7 @@
 	char		mybuf[24];
 	char	      * olddata = STp->buffer->b_data;
 	int		oldsize = STp->buffer->buffer_size;
-	char *name = tape_name(STp);
+	char          * name    = tape_name(STp);
 
 	if (STp->ready != ST_READY) return (-EIO);
 
@@ -2765,8 +2767,8 @@
 	Scsi_Request  * SRpnt;
 	ST_partstat   * STps;
 	int		result = 0;
-	int		pp  = (ppos == 3000 && !skip)? 0 : ppos;
-	char *name = tape_name(STp);
+	int		pp     = (ppos == 3000 && !skip)? 0 : ppos;
+	char          * name   = tape_name(STp);
 
 	if (STp->ready != ST_READY) return (-EIO);
 
@@ -2824,12 +2826,12 @@
 /* Flush the write buffer (never need to write if variable blocksize). */
 static int osst_flush_write_buffer(OS_Scsi_Tape *STp, Scsi_Request ** aSRpnt)
 {
-	int offset, transfer, blks = 0;
-	int result = 0;
-	unsigned char cmd[MAX_COMMAND_SIZE];
+	int            offset, transfer, blks = 0;
+	int            result = 0;
+	unsigned char  cmd[MAX_COMMAND_SIZE];
 	Scsi_Request * SRpnt = *aSRpnt;
-	ST_partstat * STps;
-	char *name = tape_name(STp);
+	ST_partstat  * STps;
+	char         * name = tape_name(STp);
 
 	if ((STp->buffer)->writing) {
 		if (SRpnt == (STp->buffer)->last_SRpnt)
@@ -2954,10 +2956,10 @@
    seek_next is true. */
 static int osst_flush_buffer(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int seek_next)
 {
-	ST_partstat   * STps;
-	int backspace = 0, result = 0;
+	ST_partstat * STps;
+	int           backspace = 0, result = 0;
 #if DEBUG
-	char *name = tape_name(STp);
+	char        * name = tape_name(STp);
 #endif
 
 	/*
@@ -3017,10 +3019,10 @@
 static int osst_write_frame(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int synchronous)
 {
 	unsigned char	cmd[MAX_COMMAND_SIZE];
-	Scsi_Request     * SRpnt;
+	Scsi_Request  * SRpnt;
 	int		blks;
 #if DEBUG
-	char *name = tape_name(STp);
+	char          * name = tape_name(STp);
 #endif
 
 	if ((!STp-> raw) && (STp->first_frame_position == 0xbae)) { /* _must_ preserve buffer! */
@@ -3139,16 +3141,16 @@
 /* Write command */
 static ssize_t osst_write(struct file * filp, const char * buf, size_t count, loff_t *ppos)
 {
-	ssize_t total, retval = 0;
-	ssize_t i, do_count, blks, transfer;
-	int write_threshold;
-	int doing_write = 0;
-	const char *b_point;
+	ssize_t        total, retval = 0;
+	ssize_t        i, do_count, blks, transfer;
+	int            write_threshold;
+	int            doing_write = 0;
+	const char   * b_point;
 	Scsi_Request * SRpnt = NULL;
-	ST_mode * STm;
-	ST_partstat * STps;
-	OS_Scsi_Tape * STp = filp->private_data;
-	char *name = tape_name(STp);
+	ST_mode      * STm;
+	ST_partstat  * STps;
+	OS_Scsi_Tape * STp  = filp->private_data;
+	char         * name = tape_name(STp);
 
 
 	if (down_interruptible(&STp->lock))
@@ -3468,14 +3470,14 @@
 /* Read command */
 static ssize_t osst_read(struct file * filp, char * buf, size_t count, loff_t *ppos)
 {
-	ssize_t total, retval = 0;
-	ssize_t i, transfer;
-	int special;
-	ST_mode * STm;
-	ST_partstat * STps;
-	Scsi_Request *SRpnt = NULL;
-	OS_Scsi_Tape * STp = filp->private_data;
-	char *name = tape_name(STp);
+	ssize_t        total, retval = 0;
+	ssize_t        i, transfer;
+	int            special;
+	ST_mode      * STm;
+	ST_partstat  * STps;
+	Scsi_Request * SRpnt = NULL;
+	OS_Scsi_Tape * STp   = filp->private_data;
+	char         * name  = tape_name(STp);
 
 
 	if (down_interruptible(&STp->lock))
@@ -3523,8 +3525,7 @@
 		goto out;
 	}
 
-	if (STp->do_auto_lock && STp->door_locked == ST_UNLOCKED &&
-	!osst_int_ioctl(STp, &SRpnt, MTLOCK, 0))
+	if (STp->do_auto_lock && STp->door_locked == ST_UNLOCKED && !do_door_lock(STp, 1))
 		STp->door_locked = ST_LOCKED_AUTO;
 
 	STps = &(STp->ps[STp->partition]);
@@ -3683,10 +3684,10 @@
 
 static int osst_set_options(OS_Scsi_Tape *STp, long options)
 {
-	int value;
-	long code;
-	ST_mode *STm;
-	char *name = tape_name(STp);
+	int       value;
+	long      code;
+	ST_mode * STm;
+	char    * name = tape_name(STp);
 
 	STm = &(STp->modes[STp->current_mode]);
 	if (!STm->defined) {
@@ -3839,16 +3840,16 @@
 /* Internal ioctl function */
 static int osst_int_ioctl(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, unsigned int cmd_in, unsigned long arg)
 {
-	int timeout;
-	long ltmp;
-	int i, ioctl_result;
-	int chg_eof = TRUE;
-	unsigned char cmd[MAX_COMMAND_SIZE];
+	int            timeout;
+	long           ltmp;
+	int            i, ioctl_result;
+	int            chg_eof = TRUE;
+	unsigned char  cmd[MAX_COMMAND_SIZE];
 	Scsi_Request * SRpnt = * aSRpnt;
-	ST_partstat * STps;
-	int fileno, blkno, at_sm, frame_seq_numbr, logical_blk_num;
-	int datalen = 0, direction = SCSI_DATA_NONE;
-	char *name = tape_name(STp);
+	ST_partstat  * STps;
+	int            fileno, blkno, at_sm, frame_seq_numbr, logical_blk_num;
+	int            datalen = 0, direction = SCSI_DATA_NONE;
+	char         * name = tape_name(STp);
 
 	if (STp->ready != ST_READY && cmd_in != MTLOAD) {
 		if (STp->ready == ST_NO_TAPE)
@@ -4208,15 +4209,15 @@
 static int os_scsi_tape_open(struct inode * inode, struct file * filp)
 {
 	unsigned short flags;
-	int i, b_size, new_session = FALSE, retval = 0;
-	unsigned char cmd[MAX_COMMAND_SIZE];
+	int            i, b_size, new_session = FALSE, retval = 0;
+	unsigned char  cmd[MAX_COMMAND_SIZE];
 	Scsi_Request * SRpnt;
 	OS_Scsi_Tape * STp;
-	ST_mode * STm;
-	ST_partstat * STps;
-	char *name;
-	int dev = TAPE_NR(inode->i_rdev);
-	int mode = TAPE_MODE(inode->i_rdev);
+	ST_mode      * STm;
+	ST_partstat  * STps;
+	char         * name;
+	int            dev  = TAPE_NR(inode->i_rdev);
+	int            mode = TAPE_MODE(inode->i_rdev);
 
 	write_lock(&os_scsi_tapes_lock);
 	if (dev >= osst_max_dev || os_scsi_tapes == NULL ||
@@ -4267,44 +4268,32 @@
 	STp->raw = TAPE_IS_RAW(inode->i_rdev);
 	if (STp->raw)
 		STp->header_ok = 0;
-#if 0
-	/* Allocate a buffer for this user */
-	need_dma_buffer = STp->restr_dma;
-	for (i=0; i < osst_nbr_buffers; i++)
-		if (!osst_buffers[i]->in_use &&
-		   (!need_dma_buffer || osst_buffers[i]->dma))
-			break;
-	if (i >= osst_nbr_buffers) {
-		STp->buffer = new_tape_buffer(FALSE, need_dma_buffer);
-		if (STp->buffer == NULL) {
-			printk(KERN_WARNING "%s:W: Can't allocate tape buffer.\n", name);
-			retval = (-EBUSY);
-			goto err_out;
-		}
-	}
-	else
-		STp->buffer = osst_buffers[i];
-#endif  /*     	now pre_allocated */
+
 	/* Allocate data segments for this device's tape buffer */
 	if (!enlarge_buffer(STp->buffer, STp->restr_dma)) {
 		printk(KERN_ERR "%s:E: Unable to allocate memory segments for tape buffer.\n", name);
 		retval = (-EOVERFLOW);
 		goto err_out;
 	}
-	(STp->buffer)->writing = 0;
-	(STp->buffer)->syscall_result = 0;
-#if 0
-	(STp->buffer)->use_sg = STp->device->host->sg_tablesize;
-
-	/* Compute the usable buffer size for this SCSI adapter */
-	if (!(STp->buffer)->use_sg)
-	(STp->buffer)->buffer_size = (STp->buffer)->sg[0].length;
-	else {
-		for (i=0, (STp->buffer)->buffer_size = 0; i < (STp->buffer)->use_sg &&
-		     i < (STp->buffer)->sg_segs; i++)
-			(STp->buffer)->buffer_size += (STp->buffer)->sg[i].length;
-	}
+	if (STp->buffer->buffer_size >= OS_FRAME_SIZE) {
+		for (i = 0, b_size = 0; 
+		     (i < STp->buffer->sg_segs) && ((b_size + STp->buffer->sg[i].length) <= OS_DATA_SIZE); 
+		     b_size += STp->buffer->sg[i++].length);
+		STp->buffer->aux = (os_aux_t *) (page_address(STp->buffer->sg[i].page) + OS_DATA_SIZE - b_size);
+#if DEBUG
+		printk(OSST_DEB_MSG "%s:D: b_data points to %p in segment 0 at %p\n", name,
+			STp->buffer->b_data, page_address(STp->buffer->sg[0].page));
+		printk(OSST_DEB_MSG "%s:D: AUX points to %p in segment %d at %p\n", name,
+			 STp->buffer->aux, i, page_address(STp->buffer->sg[i].page));
 #endif
+	} else {
+		STp->buffer->aux = NULL; /* this had better never happen! */
+		printk(KERN_NOTICE "%s:A: Framesize %d too large for buffer.\n", name, OS_FRAME_SIZE);
+		retval = (-EIO);
+		goto err_out;
+	}
+	STp->buffer->writing = 0;
+	STp->buffer->syscall_result = 0;
 	STp->dirty = 0;
 	for (i=0; i < ST_NBR_PARTITIONS; i++) {
 		STps = &(STp->ps[i]);
@@ -4410,7 +4399,7 @@
 		i = STp->first_frame_position;
 		if (STp->header_ok && i == osst_get_frame_position(STp, &SRpnt)) {
 			if (STp->door_locked == ST_UNLOCKED) {
-				if (osst_int_ioctl(STp, &SRpnt, MTLOCK, 0))
+				if (do_door_lock(STp, 1))
 					printk(KERN_INFO "%s:I: Can't lock drive door\n", name);
 				else
 					STp->door_locked = ST_LOCKED_AUTO;
@@ -4512,24 +4501,6 @@
 
 	osst_configure_onstream(STp, &SRpnt);
 
-	if (STp->buffer->buffer_size >= OS_FRAME_SIZE) {
-		for (i = 0, b_size = 0; 
-		     (i < STp->buffer->sg_segs) && ((b_size + STp->buffer->sg[i].length) <= OS_DATA_SIZE); 
-		     b_size += STp->buffer->sg[i++].length);
-		STp->buffer->aux = (os_aux_t *) (page_address(STp->buffer->sg[i].page) + OS_DATA_SIZE - b_size);
-#if DEBUG
-		printk(OSST_DEB_MSG "%s:D: b_data points to %p in segment 0 at %p\n", name,
-			STp->buffer->b_data, page_address(STp->buffer->sg[0].page));
-		printk(OSST_DEB_MSG "%s:D: AUX points to %p in segment %d at %p\n", name,
-			 STp->buffer->aux, i, page_address(STp->buffer->sg[i].page));
-#endif
-	} else {
-		STp->buffer->aux = NULL; /* this had better never happen! */
-		printk(KERN_NOTICE "%s:A: Framesize %d too large for buffer.\n", name, OS_FRAME_SIZE);
-		retval = (-EIO);
-		goto err_out;
-	}
-
 	STp->block_size = STp->raw ? OS_FRAME_SIZE : (
 			     (STm->default_blksize > 0) ? STm->default_blksize : OS_DATA_SIZE);
 	STp->buffer->buffer_blocks = STp->raw ? 1 : OS_DATA_SIZE / STp->block_size;
@@ -4569,7 +4540,7 @@
 	 * properly position the tape and check the ADR headers
 	 */
 	if (STp->door_locked == ST_UNLOCKED) {
-		 if (osst_int_ioctl(STp, &SRpnt, MTLOCK, 0))
+		 if (do_door_lock(STp, 1))
 			printk(KERN_INFO "%s:I: Can't lock drive door\n", name);
 		 else
 			STp->door_locked = ST_LOCKED_AUTO;
@@ -4597,12 +4568,12 @@
 /* Flush the tape buffer before close */
 static int os_scsi_tape_flush(struct file * filp)
 {
-	int result = 0, result2;
-	OS_Scsi_Tape * STp = filp->private_data;
-	ST_mode * STm = &(STp->modes[STp->current_mode]);
-	ST_partstat * STps = &(STp->ps[STp->partition]);
-	Scsi_Request *SRpnt = NULL;
-	char *name = tape_name(STp);
+	int            result = 0, result2;
+	OS_Scsi_Tape * STp  = filp->private_data;
+	ST_mode      * STm  = &(STp->modes[STp->current_mode]);
+	ST_partstat  * STps = &(STp->ps[STp->partition]);
+	Scsi_Request * SRpnt = NULL;
+	char         * name = tape_name(STp);
 
 	if (file_count(filp) > 1)
 		return 0;
@@ -4727,13 +4698,13 @@
 static int osst_ioctl(struct inode * inode,struct file * file,
 	 unsigned int cmd_in, unsigned long arg)
 {
-	int i, cmd_nr, cmd_type, retval = 0;
-	unsigned int blk;
-	ST_mode *STm;
-	ST_partstat *STps;
-	Scsi_Request *SRpnt = NULL;
-	OS_Scsi_Tape *STp = file->private_data;
-	char *name = tape_name(STp);
+	int            i, cmd_nr, cmd_type, retval = 0;
+	unsigned int   blk;
+	ST_mode      * STm;
+	ST_partstat  * STps;
+	Scsi_Request * SRpnt = NULL;
+	OS_Scsi_Tape * STp   = file->private_data;
+	char         * name  = tape_name(STp);
 
 	if (down_interruptible(&STp->lock))
 		return -ERESTARTSYS;
@@ -4813,6 +4784,8 @@
 				i = mtc.mt_op == MTREW   || mtc.mt_op == MTOFFL ||
 				    mtc.mt_op == MTRETEN || mtc.mt_op == MTEOM  ||
 				    mtc.mt_op == MTLOCK  || mtc.mt_op == MTLOAD ||
+				    mtc.mt_op == MTFSF   || mtc.mt_op == MTFSFM ||
+				    mtc.mt_op == MTBSF   || mtc.mt_op == MTBSFM ||
 				    mtc.mt_op == MTCOMPRESSION;
 			}
 			i = osst_flush_buffer(STp, &SRpnt, i);
@@ -5123,8 +5096,9 @@
 			   "osst :D: Expanded tape buffer (%d bytes, %d->%d segments, dma: %d, at: %p).\n",
 			   got, STbuffer->orig_sg_segs, STbuffer->sg_segs, need_dma, STbuffer->b_data);
 		printk(OSST_DEB_MSG
-			   "osst :D: segment sizes: first %d, last %d bytes.\n",
-			   STbuffer->sg[0].length, STbuffer->sg[segs-1].length);
+			   "osst :D: segment sizes: first %d at %p, last %d bytes at %p.\n",
+			   STbuffer->sg[0].length, page_address(STbuffer->sg[0].page),
+			   STbuffer->sg[segs-1].length, page_address(STbuffer->sg[segs-1].page));
 	}
 #endif
 
@@ -5410,12 +5384,12 @@
 
 static int osst_attach(Scsi_Device * SDp)
 {
-	OS_Scsi_Tape * tpnt;
-	ST_mode * STm;
-	ST_partstat * STps;
-	OSST_buffer *buffer;
-	struct gendisk *drive;
-	int i, mode, dev_num;
+	OS_Scsi_Tape   * tpnt;
+	ST_mode        * STm;
+	ST_partstat    * STps;
+	OSST_buffer    * buffer;
+	struct gendisk * drive;
+	int              i, mode, dev_num;
 
 	if (SDp->type != TYPE_TAPE || !osst_supports(SDp))
 		return 1;

--hoZxPH4CaxYzWscb--
