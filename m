From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI tape: remove remaining typedefs
Date: Mon, 25 Oct 2004 23:02:13 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.61.0410252301120.4438@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:24977 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261279AbUJYUCS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 16:02:18 -0400
Received: from kai.makisara.local ([80.186.86.22]) by fep01-app.kolumbus.fi
          with ESMTP
          id <20041025200213.PCWM1098.fep01-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2004 23:02:13 +0300
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch augments Christoph Hellwig's earlier patch by converting the local
typedefs to struct definitions. One debugging printk format is also fixed. The
patch is against 2.6.10-rc1, compiles and has been tested.

Diffstat:
 drivers/scsi/st.c |  221 +++++++++++++++++++++++++++---------------------------
 drivers/scsi/st.h |   20 ++--
 2 files changed, 122 insertions(+), 119 deletions(-)

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

------------------------------8<-----------------------------------------------
--- linux-2.6.10-rc1/drivers/scsi/st.c	2004-10-23 12:42:04.000000000 +0300
+++ linux-2.6.10-rc1-k1/drivers/scsi/st.c	2004-10-25 21:33:16.000000000 +0300
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20040403";
+static char *verstr = "20041025";
 
 #include <linux/module.h>
 
@@ -172,17 +172,17 @@
 static int st_fixed_buffer_size = ST_FIXED_BUFFER_SIZE;
 static int st_max_sg_segs = ST_MAX_SG;
 
-static Scsi_Tape **scsi_tapes = NULL;
+static struct scsi_tape **scsi_tapes = NULL;
 
 static int modes_defined;
 
-static ST_buffer *new_tape_buffer(int, int, int);
-static int enlarge_buffer(ST_buffer *, int, int);
-static void normalize_buffer(ST_buffer *);
-static int append_to_buffer(const char __user *, ST_buffer *, int);
-static int from_buffer(ST_buffer *, char __user *, int);
-static void move_buffer_data(ST_buffer *, int);
-static void buf_to_sg(ST_buffer *, unsigned int);
+static struct st_buffer *new_tape_buffer(int, int, int);
+static int enlarge_buffer(struct st_buffer *, int, int);
+static void normalize_buffer(struct st_buffer *);
+static int append_to_buffer(const char __user *, struct st_buffer *, int);
+static int from_buffer(struct st_buffer *, char __user *, int);
+static void move_buffer_data(struct st_buffer *, int);
+static void buf_to_sg(struct st_buffer *, unsigned int);
 
 static int st_map_user_pages(struct scatterlist *, const unsigned int, 
 			     unsigned long, size_t, int, unsigned long);
@@ -196,7 +196,7 @@
 
 static void do_create_driverfs_files(void);
 static void do_remove_driverfs_files(void);
-static void do_create_class_files(Scsi_Tape *, int, int);
+static void do_create_class_files(struct scsi_tape *, int, int);
 
 static struct scsi_driver st_template = {
 	.owner			= THIS_MODULE,
@@ -208,12 +208,12 @@
 	.init_command		= st_init_command,
 };
 
-static int st_compression(Scsi_Tape *, int);
+static int st_compression(struct scsi_tape *, int);
 
-static int find_partition(Scsi_Tape *);
-static int switch_partition(Scsi_Tape *);
+static int find_partition(struct scsi_tape *);
+static int switch_partition(struct scsi_tape *);
 
-static int st_int_ioctl(Scsi_Tape *, unsigned int, unsigned long);
+static int st_int_ioctl(struct scsi_tape *, unsigned int, unsigned long);
 
 

 #include "osst_detect.h"
@@ -257,13 +257,13 @@
 }
 

 
-static inline char *tape_name(Scsi_Tape *tape)
+static inline char *tape_name(struct scsi_tape *tape)
 {
 	return tape->disk->disk_name;
 }
 
 /* Convert the result to success code */
-static int st_chk_result(Scsi_Tape *STp, struct scsi_request * SRpnt)
+static int st_chk_result(struct scsi_tape *STp, struct scsi_request * SRpnt)
 {
 	int result = SRpnt->sr_result;
 	unsigned char *sense = SRpnt->sr_sense_buffer, scode;
@@ -357,8 +357,8 @@
 static void st_sleep_done(struct scsi_cmnd * SCpnt)
 {
 	int remainder;
-	Scsi_Tape *STp = container_of(SCpnt->request->rq_disk->private_data,
-				    Scsi_Tape, driver);
+	struct scsi_tape *STp = container_of(SCpnt->request->rq_disk->private_data,
+					     struct scsi_tape, driver);
 
 	if ((STp->buffer)->writing &&
 	    (SCpnt->sense_buffer[0] & 0x70) == 0x70 &&
@@ -389,7 +389,7 @@
    Otherwise write_behind_check() is used to check that the command
    has finished. */
 static struct scsi_request *
-st_do_scsi(struct scsi_request * SRpnt, Scsi_Tape * STp, unsigned char *cmd,
+st_do_scsi(struct scsi_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd,
 	   int bytes, int direction, int timeout, int retries, int do_wait)
 {
 	unsigned char *bp;
@@ -435,10 +435,10 @@
 
 
 /* Handle the write-behind checking (downs the semaphore) */
-static void write_behind_check(Scsi_Tape * STp)
+static void write_behind_check(struct scsi_tape * STp)
 {
-	ST_buffer *STbuffer;
-	ST_partstat *STps;
+	struct st_buffer *STbuffer;
+	struct st_partstat *STps;
 
 	STbuffer = STp->buffer;
 
@@ -471,7 +471,7 @@
 
 /* Step over EOF if it has been inadvertently crossed (ioctl not used because
    it messes up the block number). */
-static int cross_eof(Scsi_Tape * STp, int forward)
+static int cross_eof(struct scsi_tape * STp, int forward)
 {
 	struct scsi_request *SRpnt;
 	unsigned char cmd[MAX_COMMAND_SIZE];
@@ -505,13 +505,13 @@
 
 
 /* Flush the write buffer (never need to write if variable blocksize). */
-static int flush_write_buffer(Scsi_Tape * STp)
+static int flush_write_buffer(struct scsi_tape * STp)
 {
 	int offset, transfer, blks;
 	int result;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct scsi_request *SRpnt;
-	ST_partstat *STps;
+	struct st_partstat *STps;
 
 	if ((STp->buffer)->writing) {
 		write_behind_check(STp);
@@ -580,11 +580,11 @@
 
 /* Flush the tape buffer. The tape will be positioned correctly unless
    seek_next is true. */
-static int flush_buffer(Scsi_Tape *STp, int seek_next)
+static int flush_buffer(struct scsi_tape *STp, int seek_next)
 {
 	int backspace, result;
-	ST_buffer *STbuffer;
-	ST_partstat *STps;
+	struct st_buffer *STbuffer;
+	struct st_partstat *STps;
 
 	STbuffer = STp->buffer;
 
@@ -635,7 +635,7 @@
 }
 

 /* Set the mode parameters */
-static int set_mode_densblk(Scsi_Tape * STp, ST_mode * STm)
+static int set_mode_densblk(struct scsi_tape * STp, struct st_modedef * STm)
 {
 	int set_it = 0;
 	unsigned long arg;
@@ -669,7 +669,7 @@
 
 
 /* Lock or unlock the drive door. Don't use when scsi_request allocated. */
-static int do_door_lock(Scsi_Tape * STp, int do_lock)
+static int do_door_lock(struct scsi_tape * STp, int do_lock)
 {
 	int retval, cmd;
 	DEB(char *name = tape_name(STp);)
@@ -690,10 +690,10 @@
 
 
 /* Set the internal state after reset */
-static void reset_state(Scsi_Tape *STp)
+static void reset_state(struct scsi_tape *STp)
 {
 	int i;
-	ST_partstat *STps;
+	struct st_partstat *STps;
 
 	STp->pos_unknown = 0;
 	for (i = 0; i < ST_NBR_PARTITIONS; i++) {
@@ -722,7 +722,7 @@
 
 #define MAX_ATTENTIONS    10
 
-static int test_ready(Scsi_Tape *STp, int do_wait)
+static int test_ready(struct scsi_tape *STp, int do_wait)
 {
 	int attentions, waits, max_wait, scode;
 	int retval = CHKRES_READY, new_session = 0;
@@ -797,14 +797,14 @@
    0     drive ready
    1     drive not ready (possibly no tape)
 */
-static int check_tape(Scsi_Tape *STp, struct file *filp)
+static int check_tape(struct scsi_tape *STp, struct file *filp)
 {
 	int i, retval, new_session = 0, do_wait;
 	unsigned char cmd[MAX_COMMAND_SIZE], saved_cleaning;
 	unsigned short st_flags = filp->f_flags;
 	struct scsi_request *SRpnt = NULL;
-	ST_mode *STm;
-	ST_partstat *STps;
+	struct st_modedef *STm;
+	struct st_partstat *STps;
 	char *name = tape_name(STp);
 	struct inode *inode = filp->f_dentry->d_inode;
 	int mode = TAPE_MODE(inode);
@@ -999,8 +999,8 @@
 static int st_open(struct inode *inode, struct file *filp)
 {
 	int i, retval = (-EIO);
-	Scsi_Tape *STp;
-	ST_partstat *STps;
+	struct scsi_tape *STp;
+	struct st_partstat *STps;
 	int dev = TAPE_NR(inode);
 	char *name;
 
@@ -1080,9 +1080,9 @@
 	int result = 0, result2;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct scsi_request *SRpnt;
-	Scsi_Tape *STp = filp->private_data;
-	ST_mode *STm = &(STp->modes[STp->current_mode]);
-	ST_partstat *STps = &(STp->ps[STp->partition]);
+	struct scsi_tape *STp = filp->private_data;
+	struct st_modedef *STm = &(STp->modes[STp->current_mode]);
+	struct st_partstat *STps = &(STp->ps[STp->partition]);
 	char *name = tape_name(STp);
 
 	if (file_count(filp) > 1)
@@ -1109,8 +1109,8 @@
 
 	if (STps->rw == ST_WRITING && !STp->pos_unknown) {
 
-                DEBC(printk(ST_DEB_MSG "%s: File length %ld bytes.\n",
-                            name, (long) (filp->f_pos));
+                DEBC(printk(ST_DEB_MSG "%s: File length %lld bytes.\n",
+                            name, (long long)filp->f_pos);
                      printk(ST_DEB_MSG "%s: Async write waits %d, finished %d.\n",
                             name, STp->nbr_waits, STp->nbr_finished);
 		)
@@ -1192,7 +1192,7 @@
 static int st_release(struct inode *inode, struct file *filp)
 {
 	int result = 0;
-	Scsi_Tape *STp = filp->private_data;
+	struct scsi_tape *STp = filp->private_data;
 
 	if (STp->door_locked == ST_LOCKED_AUTO)
 		do_door_lock(STp, 0);
@@ -1207,7 +1207,7 @@
 }
 

 /* The checks common to both reading and writing */
-static ssize_t rw_checks(Scsi_Tape *STp, struct file *filp, size_t count)
+static ssize_t rw_checks(struct scsi_tape *STp, struct file *filp, size_t count)
 {
 	ssize_t retval = 0;
 
@@ -1274,10 +1274,11 @@
 }
 
 
-static int setup_buffering(Scsi_Tape *STp, const char __user *buf, size_t count, int is_read)
+static int setup_buffering(struct scsi_tape *STp, const char __user *buf,
+			   size_t count, int is_read)
 {
 	int i, bufsize, retval = 0;
-	ST_buffer *STbp = STp->buffer;
+	struct st_buffer *STbp = STp->buffer;
 
 	if (is_read)
 		i = STp->try_dio && try_rdio;
@@ -1332,9 +1333,9 @@
 
 
 /* Can be called more than once after each setup_buffer() */
-static void release_buffering(Scsi_Tape *STp)
+static void release_buffering(struct scsi_tape *STp)
 {
-	ST_buffer *STbp;
+	struct st_buffer *STbp;
 
 	STbp = STp->buffer;
 	if (STbp->do_dio) {
@@ -1356,10 +1357,10 @@
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	const char __user *b_point;
 	struct scsi_request *SRpnt = NULL;
-	Scsi_Tape *STp = filp->private_data;
-	ST_mode *STm;
-	ST_partstat *STps;
-	ST_buffer *STbp;
+	struct scsi_tape *STp = filp->private_data;
+	struct st_modedef *STm;
+	struct st_partstat *STps;
+	struct st_buffer *STbp;
 	char *name = tape_name(STp);
 
 	if (down_interruptible(&STp->lock))
@@ -1633,14 +1634,15 @@
 
    Does release user buffer mapping if it is set.
 */
-static long read_tape(Scsi_Tape *STp, long count, struct scsi_request ** aSRpnt)
+static long read_tape(struct scsi_tape *STp, long count,
+		      struct scsi_request ** aSRpnt)
 {
 	int transfer, blks, bytes;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct scsi_request *SRpnt;
-	ST_mode *STm;
-	ST_partstat *STps;
-	ST_buffer *STbp;
+	struct st_modedef *STm;
+	struct st_partstat *STps;
+	struct st_buffer *STbp;
 	int retval = 0;
 	char *name = tape_name(STp);
 
@@ -1822,10 +1824,10 @@
 	ssize_t i, transfer;
 	int special, do_dio = 0;
 	struct scsi_request *SRpnt = NULL;
-	Scsi_Tape *STp = filp->private_data;
-	ST_mode *STm;
-	ST_partstat *STps;
-	ST_buffer *STbp = STp->buffer;
+	struct scsi_tape *STp = filp->private_data;
+	struct st_modedef *STm;
+	struct st_partstat *STps;
+	struct st_buffer *STbp = STp->buffer;
 	DEB( char *name = tape_name(STp); )
 
 	if (down_interruptible(&STp->lock))
@@ -1963,7 +1965,7 @@
 
 DEB(
 /* Set the driver options */
-static void st_log_options(Scsi_Tape * STp, ST_mode * STm, char *name)
+static void st_log_options(struct scsi_tape * STp, struct st_modedef * STm, char *name)
 {
 	if (debugging) {
 		printk(KERN_INFO
@@ -1986,18 +1988,18 @@
 	)
 
 
-static int st_set_options(Scsi_Tape *STp, long options)
+static int st_set_options(struct scsi_tape *STp, long options)
 {
 	int value;
 	long code;
-	ST_mode *STm;
+	struct st_modedef *STm;
 	char *name = tape_name(STp);
 	struct cdev *cd0, *cd1;
 
 	STm = &(STp->modes[STp->current_mode]);
 	if (!STm->defined) {
 		cd0 = STm->cdevs[0]; cd1 = STm->cdevs[1];
-		memcpy(STm, &(STp->modes[0]), sizeof(ST_mode));
+		memcpy(STm, &(STp->modes[0]), sizeof(struct st_modedef));
 		STm->cdevs[0] = cd0; STm->cdevs[1] = cd1;
 		modes_defined = 1;
                 DEBC(printk(ST_DEB_MSG
@@ -2174,7 +2176,7 @@
 /* Read a mode page into the tape buffer. The block descriptors are included
    if incl_block_descs is true. The page control is ored to the page number
    parameter, if necessary. */
-static int read_mode_page(Scsi_Tape *STp, int page, int omit_block_descs)
+static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 {
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct scsi_request *SRpnt = NULL;
@@ -2199,7 +2201,7 @@
 
 /* Send the mode page in the tape buffer to the drive. Assumes that the mode data
    in the buffer is correctly formatted. The long timeout is used if slow is non-zero. */
-static int write_mode_page(Scsi_Tape *STp, int page, int slow)
+static int write_mode_page(struct scsi_tape *STp, int page, int slow)
 {
 	int pgo;
 	unsigned char cmd[MAX_COMMAND_SIZE];
@@ -2245,7 +2247,7 @@
    work without this (suggestion from Michael Schaefer <Michael.Schaefer@dlr.de>).
    Including block descriptors should not cause any harm to other drives. */
 
-static int st_compression(Scsi_Tape * STp, int state)
+static int st_compression(struct scsi_tape * STp, int state)
 {
 	int retval;
 	int mpoffs;  /* Offset to mode page start */
@@ -2299,12 +2301,12 @@
 
 
 /* Process the load and unload commands (does unload if the load code is zero) */
-static int do_load_unload(Scsi_Tape *STp, struct file *filp, int load_code)
+static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_code)
 {
 	int retval = (-EIO), timeout;
 	DEB( char *name = tape_name(STp); )
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	ST_partstat *STps;
+	struct st_partstat *STps;
 	struct scsi_request *SRpnt;
 
 	if (STp->ready != ST_READY && !load_code) {
@@ -2373,7 +2375,7 @@
 

 
 /* Internal ioctl function */
-static int st_int_ioctl(Scsi_Tape *STp, unsigned int cmd_in, unsigned long arg)
+static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned long arg)
 {
 	int timeout;
 	long ltmp;
@@ -2381,7 +2383,7 @@
 	int chg_eof = 1;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct scsi_request *SRpnt;
-	ST_partstat *STps;
+	struct st_partstat *STps;
 	int fileno, blkno, at_sm, undone;
 	int datalen = 0, direction = DMA_NONE;
 	char *name = tape_name(STp);
@@ -2787,7 +2789,7 @@
 /* Get the tape position. If bt == 2, arg points into a kernel space mt_loc
    structure. */
 
-static int get_location(Scsi_Tape *STp, unsigned int *block, int *partition,
+static int get_location(struct scsi_tape *STp, unsigned int *block, int *partition,
 			int logical)
 {
 	int result;
@@ -2847,10 +2849,10 @@
 
 /* Set the tape block and partition. Negative partition means that only the
    block should be set in vendor specific way. */
-static int set_location(Scsi_Tape *STp, unsigned int block, int partition,
+static int set_location(struct scsi_tape *STp, unsigned int block, int partition,
 			int logical)
 {
-	ST_partstat *STps;
+	struct st_partstat *STps;
 	int result, p;
 	unsigned int blk;
 	int timeout;
@@ -2950,7 +2952,7 @@
 
 /* Find the current partition number for the drive status. Called from open and
    returns either partition number of negative error code. */
-static int find_partition(Scsi_Tape *STp)
+static int find_partition(struct scsi_tape *STp)
 {
 	int i, partition;
 	unsigned int block;
@@ -2964,9 +2966,9 @@
 
 
 /* Change the partition if necessary */
-static int switch_partition(Scsi_Tape *STp)
+static int switch_partition(struct scsi_tape *STp)
 {
-	ST_partstat *STps;
+	struct st_partstat *STps;
 
 	if (STp->partition == STp->new_partition)
 		return 0;
@@ -2992,7 +2994,7 @@
 
 /* Get the number of partitions on the tape. As a side effect reads the
    mode page into the tape buffer. */
-static int nbr_partitions(Scsi_Tape *STp)
+static int nbr_partitions(struct scsi_tape *STp)
 {
 	int result;
 	DEB( char *name = tape_name(STp); )
@@ -3035,7 +3037,7 @@
    is acceptable also to some other old drives and enforced if the first partition
    size field is used for the first additional partition size.
  */
-static int partition_tape(Scsi_Tape *STp, int size)
+static int partition_tape(struct scsi_tape *STp, int size)
 {
 	char *name = tape_name(STp);
 	int result;
@@ -3103,9 +3105,9 @@
 	int i, cmd_nr, cmd_type, bt;
 	int retval = 0;
 	unsigned int blk;
-	Scsi_Tape *STp = file->private_data;
-	ST_mode *STm;
-	ST_partstat *STps;
+	struct scsi_tape *STp = file->private_data;
+	struct st_modedef *STm;
+	struct st_partstat *STps;
 	char *name = tape_name(STp);
 	void __user *p = (void __user *)arg;
 
@@ -3426,18 +3428,18 @@
 
 /* Try to allocate a new tape buffer. Calling function must not hold
    dev_arr_lock. */
-static ST_buffer *
+static struct st_buffer *
  new_tape_buffer(int from_initialization, int need_dma, int max_sg)
 {
 	int i, priority, got = 0, segs = 0;
-	ST_buffer *tb;
+	struct st_buffer *tb;
 
 	if (from_initialization)
 		priority = GFP_ATOMIC;
 	else
 		priority = GFP_KERNEL;
 
-	i = sizeof(ST_buffer) + (max_sg - 1) * sizeof(struct scatterlist) +
+	i = sizeof(struct st_buffer) + (max_sg - 1) * sizeof(struct scatterlist) +
 		max_sg * sizeof(struct st_buf_fragment);
 	tb = kmalloc(i, priority);
 	if (!tb) {
@@ -3460,7 +3462,7 @@
 
 
 /* Try to allocate enough space in the tape buffer */
-static int enlarge_buffer(ST_buffer * STbuffer, int new_size, int need_dma)
+static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dma)
 {
 	int segs, nbr, max_segs, b_size, priority, order, got;
 
@@ -3509,7 +3511,7 @@
 
 
 /* Release the extra buffer */
-static void normalize_buffer(ST_buffer * STbuffer)
+static void normalize_buffer(struct st_buffer * STbuffer)
 {
 	int i, order;
 
@@ -3525,7 +3527,7 @@
 
 /* Move data from the user buffer to the tape buffer. Returns zero (success) or
    negative error code. */
-static int append_to_buffer(const char __user *ubp, ST_buffer * st_bp, int do_count)
+static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, int do_count)
 {
 	int i, cnt, res, offset;
 
@@ -3556,7 +3558,7 @@
 
 /* Move data from the tape buffer to the user buffer. Returns zero (success) or
    negative error code. */
-static int from_buffer(ST_buffer * st_bp, char __user *ubp, int do_count)
+static int from_buffer(struct st_buffer * st_bp, char __user *ubp, int do_count)
 {
 	int i, cnt, res, offset;
 
@@ -3587,7 +3589,7 @@
 
 
 /* Move data towards start of buffer */
-static void move_buffer_data(ST_buffer * st_bp, int offset)
+static void move_buffer_data(struct st_buffer * st_bp, int offset)
 {
 	int src_seg, dst_seg, src_offset = 0, dst_offset;
 	int count, total;
@@ -3625,7 +3627,7 @@
 
 
 /* Fill the s/g list up to the length required for this transfer */
-static void buf_to_sg(ST_buffer *STbp, unsigned int length)
+static void buf_to_sg(struct st_buffer *STbp, unsigned int length)
 {
 	int i;
 	unsigned int count;
@@ -3723,10 +3725,10 @@
 	struct scsi_device *SDp = to_scsi_device(dev);
 	struct gendisk *disk = NULL;
 	struct cdev *cdev = NULL;
-	Scsi_Tape *tpnt = NULL;
-	ST_mode *STm;
-	ST_partstat *STps;
-	ST_buffer *buffer;
+	struct scsi_tape *tpnt = NULL;
+	struct st_modedef *STm;
+	struct st_partstat *STps;
+	struct st_buffer *buffer;
 	int i, j, mode, dev_num, error;
 	char *stp;
 	u64 bounce_limit;
@@ -3746,7 +3748,8 @@
 		i = st_max_sg_segs;
 	buffer = new_tape_buffer(1, (SDp->host)->unchecked_isa_dma, i);
 	if (buffer == NULL) {
-		printk(KERN_ERR "st: Can't allocate new tape buffer. Device not attached.\n");
+		printk(KERN_ERR
+		       "st: Can't allocate new tape buffer. Device not attached.\n");
 		goto out;
 	}
 
@@ -3758,7 +3761,7 @@
 
 	write_lock(&st_dev_arr_lock);
 	if (st_nr_dev >= st_dev_max) {
-		Scsi_Tape **tmp_da;
+		struct scsi_tape **tmp_da;
 		int tmp_dev_max;
 
 		tmp_dev_max = max(st_nr_dev * 2, 8);
@@ -3771,17 +3774,17 @@
 			goto out_put_disk;
 		}
 
-		tmp_da = kmalloc(tmp_dev_max * sizeof(Scsi_Tape *), GFP_ATOMIC);
+		tmp_da = kmalloc(tmp_dev_max * sizeof(struct scsi_tape *), GFP_ATOMIC);
 		if (tmp_da == NULL) {
 			write_unlock(&st_dev_arr_lock);
 			printk(KERN_ERR "st: Can't extend device array.\n");
 			goto out_put_disk;
 		}
 
-		memset(tmp_da, 0, tmp_dev_max * sizeof(Scsi_Tape *));
+		memset(tmp_da, 0, tmp_dev_max * sizeof(struct scsi_tape *));
 		if (scsi_tapes != NULL) {
 			memcpy(tmp_da, scsi_tapes,
-			       st_dev_max * sizeof(Scsi_Tape *));
+			       st_dev_max * sizeof(struct scsi_tape *));
 			kfree(scsi_tapes);
 		}
 		scsi_tapes = tmp_da;
@@ -3795,13 +3798,13 @@
 	if (i >= st_dev_max)
 		panic("scsi_devices corrupt (st)");
 
-	tpnt = kmalloc(sizeof(Scsi_Tape), GFP_ATOMIC);
+	tpnt = kmalloc(sizeof(struct scsi_tape), GFP_ATOMIC);
 	if (tpnt == NULL) {
 		write_unlock(&st_dev_arr_lock);
 		printk(KERN_ERR "st: Can't allocate device descriptor.\n");
 		goto out_put_disk;
 	}
-	memset(tpnt, 0, sizeof(Scsi_Tape));
+	memset(tpnt, 0, sizeof(struct scsi_tape));
 	tpnt->disk = disk;
 	sprintf(disk->disk_name, "st%d", i);
 	disk->private_data = &tpnt->driver;
@@ -3965,7 +3968,7 @@
 static int st_remove(struct device *dev)
 {
 	struct scsi_device *SDp = to_scsi_device(dev);
-	Scsi_Tape *tpnt;
+	struct scsi_tape *tpnt;
 	int i, j, mode;
 
 	write_lock(&st_dev_arr_lock);
@@ -4139,7 +4142,7 @@
 /* The sysfs simple class interface */
 static ssize_t st_defined_show(struct class_device *class_dev, char *buf)
 {
-	ST_mode *STm = (ST_mode *)class_get_devdata(class_dev);
+	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
 	ssize_t l = 0;
 
 	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->defined);
@@ -4150,7 +4153,7 @@
 
 static ssize_t st_defblk_show(struct class_device *class_dev, char *buf)
 {
-	ST_mode *STm = (ST_mode *)class_get_devdata(class_dev);
+	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
 	ssize_t l = 0;
 
 	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->default_blksize);
@@ -4161,7 +4164,7 @@
 
 static ssize_t st_defdensity_show(struct class_device *class_dev, char *buf)
 {
-	ST_mode *STm = (ST_mode *)class_get_devdata(class_dev);
+	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
 	ssize_t l = 0;
 	char *fmt;
 
@@ -4174,7 +4177,7 @@
 
 static ssize_t st_defcompression_show(struct class_device *class_dev, char *buf)
 {
-	ST_mode *STm = (ST_mode *)class_get_devdata(class_dev);
+	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
 	ssize_t l = 0;
 
 	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->default_compression - 1);
@@ -4183,7 +4186,7 @@
 
 CLASS_DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show, NULL);
 
-static void do_create_class_files(Scsi_Tape *STp, int dev_num, int mode)
+static void do_create_class_files(struct scsi_tape *STp, int dev_num, int mode)
 {
 	int i, rew, error;
 	char name[10];
--- linux-2.6.10-rc1/drivers/scsi/st.h	2004-10-23 12:42:04.000000000 +0300
+++ linux-2.6.10-rc1-k1/drivers/scsi/st.h	2004-10-25 21:32:30.000000000 +0300
@@ -6,7 +6,7 @@
 
 
 /* The tape buffer descriptor. */
-typedef struct {
+struct st_buffer {
 	unsigned char in_use;
 	unsigned char dma;	/* DMA-able buffer */
 	unsigned char do_dio;   /* direct i/o set up? */
@@ -26,7 +26,7 @@
 	unsigned int frp_sg_current;	/* driver buffer length currently in s/g list */
 	struct st_buf_fragment *frp;	/* the allocated buffer fragment list */
 	struct scatterlist sg[1];	/* MUST BE last item */
-} ST_buffer;
+};
 
 /* The tape buffer fragment descriptor */
 struct st_buf_fragment {
@@ -35,7 +35,7 @@
 };
 
 /* The tape mode definition */
-typedef struct {
+struct st_modedef {
 	unsigned char defined;
 	unsigned char sysv;	/* SYS V semantics? */
 	unsigned char do_async_writes;
@@ -46,7 +46,7 @@
 	short default_density;	/* Forced density, -1 = no value */
 	int default_blksize;	/* Forced blocksize, -1 = no value */
 	struct cdev *cdevs[2];  /* Auto-rewind and non-rewind devices */
-} ST_mode;
+};
 
 /* Number of modes can be changed by changing ST_NBR_MODE_BITS. The maximum
    number of modes is 16 (ST_NBR_MODE_BITS 4) */
@@ -59,7 +59,7 @@
 #define ST_MAX_TAPE_ENTRIES  (ST_MAX_TAPES << (ST_NBR_MODE_BITS + 1))
 
 /* The status related to each partition */
-typedef struct {
+struct st_partstat {
 	unsigned char rw;
 	unsigned char eof;
 	unsigned char at_sm;
@@ -72,12 +72,12 @@
 #define ST_NBR_PARTITIONS 4
 
 /* The tape drive descriptor */
-typedef struct {
+struct scsi_tape {
 	struct scsi_driver *driver;
 	struct scsi_device *device;
 	struct semaphore lock;	/* For serialization */
 	struct completion wait;	/* For SCSI commands */
-	ST_buffer *buffer;
+	struct st_buffer *buffer;
 
 	/* Drive characteristics */
 	unsigned char omit_blklims;
@@ -103,14 +103,14 @@
 	unsigned long max_pfn;	/* the maximum page number reachable by the HBA */
 
 	/* Mode characteristics */
-	ST_mode modes[ST_NBR_MODES];
+	struct st_modedef modes[ST_NBR_MODES];
 	int current_mode;
 
 	/* Status variables */
 	int partition;
 	int new_partition;
 	int nbr_partitions;	/* zero until partition support enabled */
-	ST_partstat ps[ST_NBR_PARTITIONS];
+	struct st_partstat ps[ST_NBR_PARTITIONS];
 	unsigned char dirty;
 	unsigned char ready;
 	unsigned char write_prot;
@@ -144,7 +144,7 @@
 	unsigned char last_sense[16];
 #endif
 	struct gendisk *disk;
-} Scsi_Tape;
+};
 
 /* Bit masks for use_pf */
 #define USE_PF      1
