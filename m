From: Willem Riede <wriede@riede.org>
Subject: osst.c update
Date: Wed, 6 Nov 2002 23:40:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107044002.GN3664@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id gA74e2C07474
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 23:40:02 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This synchronizes osst with the changes in st, except for the direct i/o,
which is not feasible in osst.c. The patch is against 2.5.46.
I don't know who controls the repository for this driver, but please
apply this patch so I don't have to keep merging my changes with
everyone else's.

Thanks, Willem Riede, osst maintainer.


--- osst.h.l2546.lk	Wed Nov  6 22:51:53 2002
+++ osst.h	Wed Nov  6 22:14:48 2002
@@ -510,7 +510,7 @@
  #define OS_AUX_SIZE     (512)
  //#define OSST_MAX_SG      2
  -/* The tape buffer descriptor. */
+/* The OnStream tape buffer descriptor. */
  typedef struct {
    unsigned char in_use;
    unsigned char dma;	/* DMA-able buffer */
@@ -523,14 +523,14 @@
    int syscall_result;
    Scsi_Request *last_SRpnt;
    unsigned char *b_data;
-  os_aux_t *aux;               /* onstream AUX structure at end of each block 
*/
-  unsigned short use_sg;       /* zero or number of segments for this adapter 
*/
-  unsigned short sg_segs;      /* total number of allocated segments */
-  unsigned short orig_sg_segs; /* number of segments allocated at first try */
-  struct scatterlist sg[1];    /* MUST BE last item */
+  os_aux_t *aux;               /* onstream AUX structure at end of each 
block     */
+  unsigned short use_sg;       /* zero or number of s/g segments for this 
adapter */
+  unsigned short sg_segs;      /* number of segments in s/g 
list                  */
+  unsigned short orig_sg_segs; /* number of segments allocated at first 
try       */
+  struct scatterlist sg[1];    /* MUST BE last 
item                               */
  } OSST_buffer;
  -/* The tape drive descriptor */
+/* The OnStream tape drive descriptor */
  typedef struct {
    struct Scsi_Device_Template *driver;
    unsigned capacity;
@@ -549,6 +549,7 @@
    unsigned char restr_dma;
    unsigned char scsi2_logical;
    unsigned char default_drvbuffer;  /* 0xff = don't touch, value 3 bits */
+  unsigned char pos_unknown;        /* after reset position unknown */
    int write_threshold;
    int timeout;			/* timeout for normal commands */
    int long_timeout;		/* timeout for commands known to take long 
time*/
@@ -556,10 +557,10 @@
    /* Mode characteristics */
    ST_mode modes[ST_NBR_MODES];
    int current_mode;
-#ifdef CONFIG_DEVFS_FS
    devfs_handle_t de_r[ST_NBR_MODES];  /*  Rewind entries     */
    devfs_handle_t de_n[ST_NBR_MODES];  /*  No-rewind entries  */
-#endif
+  struct device driverfs_dev_r[ST_NBR_MODES];
+  struct device driverfs_dev_n[ST_NBR_MODES];
     /* Status variables */
    int partition;
@@ -628,7 +629,7 @@
    unsigned char last_cmnd[6];
    unsigned char last_sense[16];
  #endif
-  struct gendisk *disk;
+  struct gendisk *drive;
  } OS_Scsi_Tape;
   /* Values of write_type */
--- osst.c.l2546.lk	Wed Nov  6 22:51:41 2002
+++ osst.c	Wed Nov  6 23:35:07 2002
@@ -13,18 +13,18 @@
    order) Klaus Ehrenfried, Wolfgang Denk, Steve Hirsch, Andreas Koppenh"ofer,
    Michael Leodolter, Eyal Lebedinsky, J"org Weule, and Eric Youngdale.
  -  Copyright 1992 - 2000 Kai Makisara
-		 email Kai.Makisara@metla.fi
+  Copyright 1992 - 2002 Kai Makisara / Willem Riede
+	 email Kai.Makisara@metla.fi / osst@riede.org
     $Header: /home/cvsroot/Driver/osst.c,v 1.65 2001/11/11 20:38:56 riede Exp 
$
     Microscopic alterations - Rik Ling, 2000/12/21
-  Last modified: Wed Feb  2 22:04:05 2000 by makisara@kai.makisara.local
+  Last st.c sync: Tue Oct 15 22:01:04 2002 by makisara
    Some small formal changes - aeb, 950809
  */
   static const char * cvsid = "$Id: osst.c,v 1.65 2001/11/11 20:38:56 riede 
Exp $";
-const char * osst_version = "0.9.10";
+const char * osst_version = "0.99.0p2";
   /* The "failure to reconnect" firmware bug */
  #define OSST_FW_NEED_POLL_MIN 10601 /*(107A)*/
@@ -60,7 +60,6 @@
  #define OSST_DEB_MSG  KERN_NOTICE
   #define MAJOR_NR OSST_MAJOR
-#define DEVICE_NR(device) (minor(device) & 0x7f)  #include <linux/blk.h>
   #include "scsi.h"
@@ -74,30 +73,32 @@
  #include "osst_options.h"
  #include "osst_detect.h"
  -static int buffer_kbs = 0;
+static int max_dev = 0;
  static int write_threshold_kbs = 0;
-static int max_buffers = 0;
  static int max_sg_segs = 0;
   #ifdef MODULE
  MODULE_AUTHOR("Willem Riede");
-MODULE_DESCRIPTION("OnStream SCSI Tape Driver");
+MODULE_DESCRIPTION("OnStream {DI-|FW-|SC-|USB}{30|50} Tape Driver");
  MODULE_LICENSE("GPL");
  -MODULE_PARM(buffer_kbs, "i");
+MODULE_PARM(max_dev, "i");
+MODULE_PARM_DESC(max_dev, "Maximum number of OnStream Tape Drives to attach 
(4)");
+
  MODULE_PARM(write_threshold_kbs, "i");
-MODULE_PARM(max_buffers, "i");
+MODULE_PARM_DESC(write_threshold_kbs, "Asynchronous write threshold (KB; 
30)");
+
  MODULE_PARM(max_sg_segs, "i");
+MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather segments to 
use (9)");
  #else
  static struct osst_dev_parm {
         char   *name;
         int    *val;
  } parms[] __initdata = {
-       { "buffer_kbs",          &buffer_kbs          },
+       { "max_dev",             &max_dev           },
         { "write_threshold_kbs", &write_threshold_kbs },
-       { "max_buffers",         &max_buffers         },
         { "max_sg_segs",         &max_sg_segs         }
-       };
+};
  #endif
   /* Some default definitions have been moved to osst_options.h */
@@ -116,34 +117,42 @@
  // #define OSST_INJECT_ERRORS 1  #endif
  -#define MAX_RETRIES 0
+#define MAX_RETRIES 2
+#define MAX_READ_RETRIES 0
  #define MAX_WRITE_RETRIES 0
-#define MAX_READY_RETRIES 5
+#define MAX_READY_RETRIES 0
  #define NO_TAPE  NOT_READY
  +#define OSST_WAIT_POSITION_COMPLETE   (HZ > 200 ? HZ / 200 : 1)
+#define OSST_WAIT_WRITE_COMPLETE      (HZ / 12)
+#define OSST_WAIT_LONG_WRITE_COMPLETE (HZ / 2)
+	 
  #define OSST_TIMEOUT (200 * HZ)
  #define OSST_LONG_TIMEOUT (1800 * HZ)
  -#define TAPE_NR(x) (minor(x) & ~(128 | ST_MODE_MASK))
+#define TAPE_NR(x) (minor(x) & ~(-1 << ST_MODE_SHIFT))
  #define TAPE_MODE(x) ((minor(x) & ST_MODE_MASK) >> ST_MODE_SHIFT)
+#define TAPE_REWIND(x) ((minor(x) & 0x80) == 0)
+#define TAPE_IS_RAW(x) (TAPE_MODE(x) & (ST_NBR_MODES >> 1))
   /* Internal ioctl to set both density (uppermost 8 bits) and blocksize 
(lower
     24 bits) */
  #define SET_DENS_AND_BLK 0x10001
  -static int osst_nbr_buffers;
  static int osst_buffer_size       = OSST_BUFFER_SIZE;
  static int osst_write_threshold   = OSST_WRITE_THRESHOLD;
-static int osst_max_buffers       = OSST_MAX_BUFFERS;
  static int osst_max_sg_segs       = OSST_MAX_SG;
+static int osst_max_dev           = OSST_MAX_TAPES;
+static int osst_dev_noticed;
+static int osst_nr_dev;
   static OS_Scsi_Tape **os_scsi_tapes = NULL;
-static OSST_buffer  **osst_buffers  = NULL;
+static rwlock_t  osst_dev_arr_lock  = RW_LOCK_UNLOCKED;
   static int modes_defined = FALSE;
  -static OSST_buffer *new_tape_buffer(int, int);
-static int enlarge_buffer(OSST_buffer *, int, int);
+static OSST_buffer *new_tape_buffer(int, int, int);
+static int enlarge_buffer(OSST_buffer *, int);
  static void normalize_buffer(OSST_buffer *);
  static int append_to_buffer(const char *, OSST_buffer *, int);
  static int from_buffer(OSST_buffer *, char *, int);
@@ -151,21 +160,19 @@
  static int osst_copy_to_buffer(OSST_buffer *, unsigned char *);
  static int osst_copy_from_buffer(OSST_buffer *, unsigned char *);
  -static int osst_init(void);
  static int osst_attach(Scsi_Device *);
  static int osst_detect(Scsi_Device *);
  static void osst_detach(Scsi_Device *);
   struct Scsi_Device_Template osst_template =
  {
-       module:		THIS_MODULE,
-       name:		"OnStream tape",
-       tag:		"osst",
-       scsi_type:	TYPE_TAPE,
-       detect:		osst_detect,
-       init:		osst_init,
-       attach:		osst_attach,
-       detach:		osst_detach
+	.module =       THIS_MODULE,
+	.name =         "OnStream Tape",
+	.tag =          "osst",
+	.scsi_type =    TYPE_TAPE,
+	.detect =       osst_detect,
+	.attach =       osst_attach,
+	.detach =       osst_detach
  };
   static int osst_int_ioctl(OS_Scsi_Tape *STp, Scsi_Request ** aSRpnt, 
unsigned int cmd_in,unsigned long arg);
@@ -180,9 +187,8 @@
   static inline char *tape_name(OS_Scsi_Tape *tape)
  {
-	return tape->disk->disk_name;
+	return tape->drive->disk_name;
  }
-
  
 
  /* Routines that handle the interaction with mid-layer SCSI routines */
  @@ -200,13 +206,12 @@
  		sense[0] = 0;    /* We don't have sense data if this byte is 
zero */
  		return 0;
  	}
-	if (driver_byte(result) & DRIVER_SENSE)
+	if ((driver_byte(result) & DRIVER_MASK) == DRIVER_SENSE)
  		scode = sense[2] & 0x0f;
  	else {
  		sense[0] = 0;    /* We don't have sense data if this byte is 
zero */
  		scode = 0;
  	}
-
  #if DEBUG
  	if (debugging) {
  		printk(OSST_DEB_MSG "%s:D: Error: %x, cmd: %x %x %x %x %x %x 
Len: %d\n",
@@ -214,10 +219,12 @@
  		   SRpnt->sr_cmnd[0], SRpnt->sr_cmnd[1], SRpnt->sr_cmnd[2],
  		   SRpnt->sr_cmnd[3], SRpnt->sr_cmnd[4], SRpnt->sr_cmnd[5],
  		   SRpnt->sr_bufflen);
+		if (scode) printk(OSST_DEB_MSG "%s:D: Sense: %02x, ASC: %02x, 
ASCQ: %02x\n",
+			       	name, scode, sense[12], sense[13]);
  		if (driver_byte(result) & DRIVER_SENSE)
  			print_req_sense("osst", SRpnt);
  	}
-	else
+//	else
  #endif
  	if (!(driver_byte(result) & DRIVER_SENSE) ||
  		((sense[0] & 0x70) == 0x70 &&
@@ -248,6 +255,8 @@
  			}
  		}
  	}
+	STp->pos_unknown |= STp->device->was_reset;
+
  	if ((sense[0] & 0x70) == 0x70 &&
  	     scode == RECOVERED_ERROR) {
  		STp->recover_count++;
@@ -274,22 +283,21 @@
  /* Wakeup from interrupt */
  static void osst_sleep_done (Scsi_Cmnd * SCpnt)
  {
-	OS_Scsi_Tape * STp = 
container_of(SCpnt->request->rq_disk->private_data,
-					OS_Scsi_Tape, driver);
+	OS_Scsi_Tape * STp = 
container_of(SCpnt->request->rq_disk->private_data, OS_Scsi_Tape, driver);
   	if ((STp->buffer)->writing &&
  	    (SCpnt->sense_buffer[0] & 0x70) == 0x70 &&
  	    (SCpnt->sense_buffer[2] & 0x40)) {
  		/* EOM at write-behind, has all been written? */
  		if ((SCpnt->sense_buffer[2] & 0x0f) == VOLUME_OVERFLOW)
-			(STp->buffer)->midlevel_result = SCpnt->result; /* 
Error */
+			STp->buffer->midlevel_result = SCpnt->result; /* Error 
*/
  		else
-			(STp->buffer)->midlevel_result = INT_MAX;       /* OK 
*/
+			STp->buffer->midlevel_result = INT_MAX;       /* OK */
  	}
  	else
-		(STp->buffer)->midlevel_result = SCpnt->result;
+		STp->buffer->midlevel_result = SCpnt->result;
  	SCpnt->request->rq_status = RQ_SCSI_DONE;
-	(STp->buffer)->last_SRpnt = SCpnt->sc_request;
+	STp->buffer->last_SRpnt = SCpnt->sc_request;
   #if DEBUG
  	STp->write_pending = 0;
@@ -311,7 +319,7 @@
  #endif
  	if (SRpnt == NULL) {
  		if ((SRpnt = scsi_allocate_request(STp->device)) == NULL) {
-			printk(KERN_ERR "%s:E: Can't get SCSI request->\n", 
tape_name(STp));
+			printk(KERN_ERR "%s:E: Can't get SCSI request.\n", 
tape_name(STp));
  			if (signal_pending(current))
  				(STp->buffer)->syscall_result = (-EINTR);
  			else
@@ -334,7 +342,7 @@
  	SRpnt->sr_cmd_len = 0;
  	SRpnt->sr_request->waiting = &(STp->wait);
  	SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;
-	SRpnt->sr_request->rq_disk = STp->disk;
+	SRpnt->sr_request->rq_disk = STp->drive;
   	scsi_do_req(SRpnt, (void *)cmd, bp, bytes, osst_sleep_done, timeout, 
retries);
  @@ -386,7 +394,7 @@
  	scsi_release_request((STp->buffer)->last_SRpnt);
   	if (STbuffer->writing < STbuffer->buffer_bytes)
-		printk(KERN_WARNING "osst:A: write_behind_check: something 
left in buffer!\n");
+		printk(KERN_WARNING "osst :A: write_behind_check: something 
left in buffer!\n");
   	STbuffer->buffer_bytes -= STbuffer->writing;
  	STbuffer->writing = 0;
@@ -536,7 +544,7 @@
  				 STp->first_frame_position);
  		goto err_out;
  	}
-	STp->frame_in_buffer = 1;
+//	STp->frame_in_buffer = 1;
           if (frame_seq_number != -1 && ntohl(aux->frame_seq_num) != 
frame_seq_number) {
  		if (!quiet)
@@ -564,12 +572,14 @@
  	}
  	if (aux->frame_type == OS_FRAME_TYPE_EOD) {
  		STps->eof = ST_EOD_1;
+		STp->frame_in_buffer = 1;
  	}
  	if (aux->frame_type == OS_FRAME_TYPE_DATA) {
                  blk_cnt = ntohs(aux->dat.dat_list[0].blk_cnt);
  		blk_sz  = ntohl(aux->dat.dat_list[0].blk_sz);
  		STp->buffer->buffer_bytes = blk_cnt * blk_sz;
  		STp->buffer->read_pointer = 0;
+		STp->frame_in_buffer = 1;
   		/* See what block size was used to write file */
  		if (STp->block_size != blk_sz && blk_sz > 0) {
@@ -596,18 +606,23 @@
  /*
   * Wait for the unit to become Ready
   */
-static int osst_wait_ready(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, 
unsigned timeout)
+static int osst_wait_ready(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, 
unsigned timeout, int initial_delay)
  {
  	unsigned char	cmd[MAX_COMMAND_SIZE];
  	Scsi_Request  * SRpnt;
  	long		startwait = jiffies;
  #if DEBUG
-	int		dbg = debugging;
-	char *name = tape_name(STp);
+	int		dbg  = debugging;
+	char          * name = tape_name(STp);
   	printk(OSST_DEB_MSG "%s:D: Reached onstream wait ready\n", name);
  #endif
  +	if (initial_delay > 0) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(initial_delay);
+	}
+
  	memset(cmd, 0, MAX_COMMAND_SIZE);
  	cmd[0] = TEST_UNIT_READY;
  @@ -719,10 +734,10 @@
  {
  	int	retval;
  -	osst_wait_ready(STp, aSRpnt, 15 * 60);			/* TODO - can 
this catch a write error? */
+	osst_wait_ready(STp, aSRpnt, 15 * 60, 0);			/* 
TODO - can this catch a write error? */
  	retval = osst_set_frame_position(STp, aSRpnt, frame, 0);
  	if (retval) return (retval);
-	osst_wait_ready(STp, aSRpnt, 15 * 60);
+	osst_wait_ready(STp, aSRpnt, 15 * 60, OSST_WAIT_POSITION_COMPLETE);
  	return (osst_get_frame_position(STp, aSRpnt));
  }
  @@ -735,6 +750,7 @@
  	Scsi_Request  * SRpnt;
   	int             result = 0;
+	int		delay  = OSST_WAIT_LONG_WRITE_COMPLETE;
  #if DEBUG
  	char *name = tape_name(STp);
  @@ -748,12 +764,17 @@
  	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, SCSI_DATA_NONE, 
STp->timeout, MAX_WRITE_RETRIES, TRUE);
  	*aSRpnt = SRpnt;
  	if (!SRpnt) return (-EBUSY);
-
-	if ((STp->buffer)->syscall_result)
-		result = osst_write_error_recovery(STp, aSRpnt, 0);
-
-	result |= osst_wait_ready(STp, aSRpnt, 5 * 60);
+	if (STp->buffer->syscall_result) {
+		if ((SRpnt->sr_sense_buffer[2] & 0x0f) == 2 && 
SRpnt->sr_sense_buffer[12] == 4) {
+			if (SRpnt->sr_sense_buffer[13] == 8) {
+				delay = OSST_WAIT_LONG_WRITE_COMPLETE;
+			}
+		} else
+			result = osst_write_error_recovery(STp, aSRpnt, 0);
+	}
+	result |= osst_wait_ready(STp, aSRpnt, 5 * 60, delay);
  	STp->ps[STp->partition].rw = OS_WRITING_COMPLETE;
+
  	return (result);
  }
  @@ -844,7 +865,7 @@
  	    printk(OSST_DEB_MSG "%s:D: Reading frame from OnStream tape\n", 
name);
  #endif
  	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, SCSI_DATA_READ,
-				      STp->timeout, MAX_RETRIES, TRUE);
+				      STp->timeout, MAX_READ_RETRIES, TRUE);
  	*aSRpnt = SRpnt;
  	if (!SRpnt)
  	    return (-EBUSY);
@@ -900,7 +921,8 @@
  #endif
   	if (STps->rw != ST_READING) {         /* Initialize read operation */
-		if (STps->rw == ST_WRITING) {
+		if (STps->rw == ST_WRITING || STp->dirty) {
+			STp->write_type = OS_WRITE_DATA;
                          osst_flush_write_buffer(STp, aSRpnt);
  			osst_flush_drive_buffer(STp, aSRpnt);
  		}
@@ -918,7 +940,7 @@
  #if DEBUG
  		printk(OSST_DEB_MSG "%s:D: Start Read Ahead on OnStream 
tape\n", name);
  #endif
-		SRpnt   = osst_do_scsi(*aSRpnt, STp, cmd, 0, SCSI_DATA_NONE, 
STp->timeout, MAX_RETRIES, TRUE);
+		SRpnt   = osst_do_scsi(*aSRpnt, STp, cmd, 0, SCSI_DATA_NONE, 
STp->timeout, MAX_READ_RETRIES, TRUE);
  		*aSRpnt = SRpnt;
  		retval  = STp->buffer->syscall_result;
  	}
@@ -937,6 +959,15 @@
  		      position;
   	/*
+	 * If we want just any frame (-1) and there is a frame in the buffer, 
return it
+	 */
+	if (frame_seq_number == -1 && STp->frame_in_buffer) {
+#if DEBUG
+		printk(OSST_DEB_MSG "%s:D: Frame %d still in buffer\n", name, 
STp->frame_seq_number);
+#endif
+		return (STps->eof);
+	}
+	/*
           * Search and wait for the next logical tape frame
  	 */
  	while (1) {
@@ -1089,6 +1120,7 @@
  		    if (move < 0) move -= (OS_DATA_SIZE / STp->block_size) - 1;
  		    move               /= (OS_DATA_SIZE / STp->block_size);
  		 }
+		 if (!move) move = logical_blk_num > STp->logical_blk_num ? 1 
: -1;
  #if DEBUG
  		 printk(OSST_DEB_MSG
  			"%s:D: Seek retry %d at ppos %d fsq %d (est %d) lbn %d 
(need %d) move %d\n",
@@ -1286,7 +1318,7 @@
  		cmd[8] = 32768 & 0xff;
   		SRpnt = osst_do_scsi(SRpnt, STp, cmd, OS_FRAME_SIZE, 
SCSI_DATA_READ,
-					    STp->timeout, MAX_RETRIES, TRUE);
+					    STp->timeout, MAX_READ_RETRIES, 
TRUE);
  	 
  		if ((STp->buffer)->syscall_result || !SRpnt) {
  			printk(KERN_ERR "%s:E: Failed to read frame back from 
OnStream buffer\n", name);
@@ -1326,7 +1358,7 @@
  						name, new_frame+i, 
frame_seq_number+i);
  #endif
  			osst_set_frame_position(STp, aSRpnt, new_frame + i, 0);
-			osst_wait_ready(STp, aSRpnt, 60);
+			osst_wait_ready(STp, aSRpnt, 60, 
OSST_WAIT_POSITION_COMPLETE);
  			osst_get_frame_position(STp, aSRpnt);
  			SRpnt = * aSRpnt;
  @@ -1394,6 +1426,7 @@
  					if (SRpnt->sr_sense_buffer[2] == 2 && 
SRpnt->sr_sense_buffer[12] == 4 &&
  					    (SRpnt->sr_sense_buffer[13] == 1 
|| SRpnt->sr_sense_buffer[13] == 8)) {
  						/* in the process of becoming 
ready */
+						 
set_current_state(TASK_INTERRUPTIBLE);
  						schedule_timeout(HZ / 10);
  						continue;
  					}
@@ -1466,6 +1499,8 @@
  			osst_set_frame_position(STp, aSRpnt, frame + skip, 1);
  			flag = 0;
  			attempts--;
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(HZ / 10);
  		}
  		if (osst_get_frame_position(STp, aSRpnt) < 0) {		/* 
additional write error */
  #if DEBUG
@@ -1908,6 +1943,7 @@
  	if (mt_op == MTFSF) {
  		STp->frame_seq_number++;
  		STp->frame_in_buffer  = 0;
+		STp->buffer->read_pointer = 0;
  		STp->logical_blk_num += 
ntohs(STp->buffer->aux->dat.dat_list[0].blk_cnt);
  	}
  	return 0;
@@ -2008,7 +2044,7 @@
  #if DEBUG
  	printk(OSST_DEB_MSG "%s:D: Reached onstream write filler group %d\n", 
name, where);
  #endif
-	osst_wait_ready(STp, aSRpnt, 60 * 5);
+	osst_wait_ready(STp, aSRpnt, 60 * 5, 0);
  	osst_set_frame_position(STp, aSRpnt, where, 0);
  	STp->write_type = OS_WRITE_FILLER;
  	while (count--) {
@@ -2034,7 +2070,7 @@
  #if DEBUG
  	printk(OSST_DEB_MSG "%s:D: Reached onstream write header group %d\n", 
name, where);
  #endif
-	osst_wait_ready(STp, aSRpnt, 60 * 5);
+	osst_wait_ready(STp, aSRpnt, 60 * 5, 0);
  	osst_set_frame_position(STp, aSRpnt, where, 0);
  	STp->write_type = OS_WRITE_HEADER;
  	while (count--) {
@@ -2668,7 +2704,7 @@
   	STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
  	SRpnt = osst_do_scsi(*aSRpnt, STp, scmd, 20, SCSI_DATA_READ,
-				      STp->timeout, MAX_READY_RETRIES, TRUE);
+				      STp->timeout, MAX_RETRIES, TRUE);
  	if (!SRpnt) {
  		STp->buffer->b_data = olddata; STp->buffer->buffer_size = 
oldsize;
  		return (-EBUSY);
@@ -2689,7 +2725,7 @@
  			scmd[0] = READ_POSITION;
  			STp->buffer->b_data = mybuf; STp->buffer->buffer_size 
= 24;
  			SRpnt = osst_do_scsi(SRpnt, STp, scmd, 20, 
SCSI_DATA_READ,
-						    STp->timeout, 
MAX_READY_RETRIES, TRUE);
+						    STp->timeout, MAX_RETRIES, 
TRUE);
  			if (!STp->buffer->syscall_result)
  				memcpy (SRpnt->sr_sense_buffer, mysense, 16);
  		}
@@ -2761,7 +2797,7 @@
  			scmd[9] = 0x80;
   		SRpnt = osst_do_scsi(*aSRpnt, STp, scmd, 0, SCSI_DATA_NONE, 
STp->long_timeout,
-								 
MAX_READY_RETRIES, TRUE);
+								MAX_RETRIES, 
TRUE);
  		if (!SRpnt)
  			return (-EBUSY);
  		*aSRpnt  = SRpnt;
@@ -2774,7 +2810,7 @@
  			result = (-EIO);
  		}
  		if (pp != ppos)
-			osst_wait_ready(STp, aSRpnt, 5 * 60);
+			osst_wait_ready(STp, aSRpnt, 5 * 60, 
OSST_WAIT_POSITION_COMPLETE);
  	} while ((pp != ppos) && (pp = ppos));
  	STp->first_frame_position = STp->last_frame_position = ppos;
  	STps->eof = ST_NOEOF;
@@ -2931,16 +2967,17 @@
  	 * If there was a bus reset, block further access
  	 * to this device.
  	 */
-	if( STp->device->was_reset )
+	if( STp->pos_unknown)
  		return (-EIO);
   	if (STp->ready != ST_READY)
  		return 0;
   	STps = &(STp->ps[STp->partition]);
-	if (STps->rw == ST_WRITING)  /* Writing */
+	if (STps->rw == ST_WRITING || STp->dirty) {	/* Writing */
+		STp->write_type = OS_WRITE_DATA;
  		return osst_flush_write_buffer(STp, aSRpnt);
-
+	}
  	if (STp->block_size == 0)
  		return 0;
  @@ -3062,6 +3099,43 @@
  	return 0;
  }
  +/* Lock or unlock the drive door. Don't use when Scsi_Request allocated. */
+static int do_door_lock(OS_Scsi_Tape * STp, int do_lock)
+{
+	int retval, cmd;
+
+	cmd = do_lock ? SCSI_IOCTL_DOORLOCK : SCSI_IOCTL_DOORUNLOCK;
+#if DEBUG
+	printk(OSST_DEB_MSG "%s:D: %socking drive door.\n", tape_name(STp), 
do_lock ? "L" : "Unl");
+#endif
+	retval = scsi_ioctl(STp->device, cmd, NULL);
+	if (!retval) {
+		STp->door_locked = do_lock ? ST_LOCKED_EXPLICIT : ST_UNLOCKED;
+	}
+	else {
+		STp->door_locked = ST_LOCK_FAILS;
+	}
+	return retval;
+}
+
+/* Set the internal state after reset */
+static void reset_state(OS_Scsi_Tape *STp)
+{
+	int i;
+	ST_partstat *STps;
+
+	STp->pos_unknown = 0;
+	for (i = 0; i < ST_NBR_PARTITIONS; i++) {
+		STps = &(STp->ps[i]);
+		STps->rw = ST_IDLE;
+		STps->eof = ST_NOEOF;
+		STps->at_sm = 0;
+		STps->last_block_valid = FALSE;
+		STps->drv_block = -1;
+		STps->drv_file = -1;
+	}
+}
+				 
  
 
  /* Entry points to osst */
  @@ -3119,7 +3193,7 @@
  	 * If there was a bus reset, block further access
  	 * to this device.
  	 */
-	if (STp->device->was_reset) {
+	if (STp->pos_unknown) {
  		retval = (-EIO);
  		goto out;
  	}
@@ -3153,20 +3227,22 @@
  		goto out;
  	}
  -	STps = &(STp->ps[STp->partition]);
-
-	if (STp->do_auto_lock && STp->door_locked == ST_UNLOCKED &&
-	    !osst_int_ioctl(STp, &SRpnt, MTLOCK, 0))
+	if (STp->do_auto_lock && STp->door_locked == ST_UNLOCKED && 
!do_door_lock(STp, 1))
  		STp->door_locked = ST_LOCKED_AUTO;
  +	STps = &(STp->ps[STp->partition]);
   	if (STps->rw == ST_READING) {
+#if DEBUG
+		printk(OSST_DEB_MSG "%s:D: Switching from read to write at 
file %d, block %d\n", name, +					 
STps->drv_file, STps->drv_block);
+#endif
  		retval = osst_flush_buffer(STp, &SRpnt, 0);
  		if (retval)
  			goto out;
  		STps->rw = ST_IDLE;
  	}
-	else if (STps->rw != ST_WRITING) {
+	if (STps->rw != ST_WRITING) {
  		/* Are we totally rewriting this tape? */
  		if (!STp->header_ok ||
  		    (STp->first_frame_position == STp->first_data_ppos && 
STps->drv_block < 0) ||
@@ -3517,9 +3593,19 @@
  			    printk(OSST_DEB_MSG "%s:D: EOF up (%d). Left %d, 
needed %d.\n", name,
  						 STps->eof, 
(STp->buffer)->buffer_bytes, count - total);
  #endif
+		       	/* force multiple of block size, note block_size may 
have been adjusted */
  			transfer = (((STp->buffer)->buffer_bytes < count - 
total ?
  				     (STp->buffer)->buffer_bytes : count - 
total)/
-					STp->block_size) * STp->block_size; /* 
force multiple of block size */
+					STp->block_size) * STp->block_size;
+
+			if (transfer == 0) {
+				printk(KERN_WARNING
+				  "%s:W: Nothing can be transfered, requested 
%d, tape block size (%d%c).\n",
+			   		name, count, STp->block_size < 1024?
+					STp->block_size:STp->block_size/1024,
+				       	STp->block_size<1024?'b':'k');
+				break;
+			}
  			i = from_buffer(STp->buffer, buf, transfer);
  			if (i)  {
  				retval = i;
@@ -3869,9 +3955,10 @@
  		 }
  		 break;
  	 case MTWEOF:
-		 if ( STps->rw == ST_WRITING && !(STp->device)->was_reset)
+		 if ((STps->rw == ST_WRITING || STp->dirty) && 
!STp->pos_unknown) {
+			STp->write_type = OS_WRITE_DATA;
  			ioctl_result = osst_flush_write_buffer(STp, &SRpnt);
-		 else
+		 } else
  			ioctl_result = 0;
  #if DEBUG
  		 if (debugging) @@ -3992,26 +4079,6 @@
  		fileno = blkno = at_sm = frame_seq_numbr = logical_blk_num = 0 
;
  		break;
  -	 case MTLOCK:
-		chg_eof = FALSE;
-		cmd[0] = ALLOW_MEDIUM_REMOVAL;
-		cmd[4] = SCSI_REMOVAL_PREVENT;
-#if DEBUG
-		if (debugging)
-		    printk(OSST_DEB_MSG "%s:D: Locking drive door.\n", name);
-#endif
-		break;
-
-	 case MTUNLOCK:
-		chg_eof = FALSE;
-		cmd[0] = ALLOW_MEDIUM_REMOVAL;
-		cmd[4] = SCSI_REMOVAL_ALLOW;
-#if DEBUG
-		if (debugging)
-		   printk(OSST_DEB_MSG "%s:D: Unlocking drive door.\n", name);
-#endif
-	break;
-
  	 case MTSETBLK:           /* Set block length */
  	 case MTSETDENSITY:       /* Set tape density */
  	 case MTSETDRVBUFFER:     /* Set drive buffering */
@@ -4069,13 +4136,10 @@
  		STps->drv_file = fileno;
  		STps->at_sm = at_sm;
  -		if (cmd_in == MTLOCK)
-			 STp->door_locked = ST_LOCKED_EXPLICIT;
-		else if (cmd_in == MTUNLOCK)
-			STp->door_locked = ST_UNLOCKED;
-
  		if (cmd_in == MTEOM)
  			STps->eof = ST_EOD;
+		else if ((cmd_in == MTFSFM || cmd_in == MTBSF) && STps->eof == 
ST_FM_HIT)
+			ioctl_result = osst_seek_logical_blk(STp, &SRpnt, 
STp->logical_blk_num - 1);
  		else if (cmd_in == MTFSF)
  			STps->eof = (STp->first_frame_position >= 
STp->eod_frame_ppos)?ST_EOD:ST_FM;
  		else if (chg_eof)
@@ -4084,7 +4148,6 @@
  		if (cmd_in == MTOFFL || cmd_in == MTUNLOAD)
  			STp->rew_at_close = 0;
  		else if (cmd_in == MTLOAD) {
-/*      		STp->rew_at_close = (minor(inode->i_rdev) & 0x80) == 
0;  FIXME */
  			for (i=0; i < ST_NBR_PARTITIONS; i++) {
  			    STp->ps[i].rw = ST_IDLE;
  			    STp->ps[i].last_block_valid = FALSE;/* FIXME - 
where else is this field maintained? */
@@ -4129,11 +4192,8 @@
  		if ((SRpnt->sr_sense_buffer[2] & 0x0f) == BLANK_CHECK)
  			STps->eof = ST_EOD;
  -		if (cmd_in == MTLOCK)
-			STp->door_locked = ST_LOCK_FAILS;
-
  		if (cmd_in == MTLOAD && osst_wait_for_medium(STp, &SRpnt, 60))
-			ioctl_result = osst_wait_ready(STp, &SRpnt, 5 * 60);
+			ioctl_result = osst_wait_ready(STp, &SRpnt, 5 * 60, 
OSST_WAIT_POSITION_COMPLETE);
  	}
  	*aSRpnt = SRpnt;
  @@ -4145,34 +4205,40 @@
  static int os_scsi_tape_open(struct inode * inode, struct file * filp)
  {
  	unsigned short flags;
-	int i, b_size, need_dma_buffer, new_session = FALSE, retval = 0;
+	int i, b_size, new_session = FALSE, retval = 0;
  	unsigned char cmd[MAX_COMMAND_SIZE];
  	Scsi_Request * SRpnt;
  	OS_Scsi_Tape * STp;
  	ST_mode * STm;
  	ST_partstat * STps;
-	int dev = TAPE_NR(inode->i_rdev);
  	char *name;
+	int dev = TAPE_NR(inode->i_rdev);
  	int mode = TAPE_MODE(inode->i_rdev);
  -	if (dev >= osst_template.dev_max || (STp = os_scsi_tapes[dev]) == NULL 
|| !STp->device)
+	write_lock(&osst_dev_arr_lock);
+	if (dev >= osst_max_dev || os_scsi_tapes == NULL ||
+	    (STp = os_scsi_tapes[dev]) == NULL || !STp->device) {
+		write_unlock(&osst_dev_arr_lock);
  		return (-ENXIO);
+	}
  -	filp->private_data = STp;
  	name = tape_name(STp);
  -	if( !scsi_block_when_processing_errors(STp->device) ) {
-		return -ENXIO;
-	}
-
  	if (STp->in_use) {
+		write_unlock(&osst_dev_arr_lock);
  #if DEBUG
  		printk(OSST_DEB_MSG "%s:D: Device already in use.\n", name);
  #endif
  		return (-EBUSY);
  	}
-	STp->in_use       = 1;
-	STp->rew_at_close = (minor(inode->i_rdev) & 0x80) == 0;
+	filp->private_data = STp;
+	STp->in_use = 1;
+	write_unlock(&osst_dev_arr_lock);
+	STp->rew_at_close = TAPE_REWIND(inode->i_rdev);
+
+	if( !scsi_block_when_processing_errors(STp->device) ) {
+		return -ENXIO;
+	}
   	if (STp->device->host->hostt->module)
  		 __MOD_INC_USE_COUNT(STp->device->host->hostt->module);
@@ -4194,10 +4260,10 @@
  	flags = filp->f_flags;
  	STp->write_prot = ((flags & O_ACCMODE) == O_RDONLY);
  -	STp->raw = (minor(inode->i_rdev) & 0x40) != 0;
+	STp->raw = TAPE_IS_RAW(inode->i_rdev);
  	if (STp->raw)
  		STp->header_ok = 0;
-
+#if 0
  	/* Allocate a buffer for this user */
  	need_dma_buffer = STp->restr_dma;
  	for (i=0; i < osst_nbr_buffers; i++)
@@ -4214,9 +4280,16 @@
  	}
  	else
  		STp->buffer = osst_buffers[i];
-	(STp->buffer)->in_use = 1;
+#endif  /*     	now pre_allocated */
+	/* Allocate data segments for this device's tape buffer */
+	if (!enlarge_buffer(STp->buffer, STp->restr_dma)) {
+		printk(KERN_ERR "%s:E: Unable to allocate memory segments for 
tape buffer.\n", name);
+		retval = (-EOVERFLOW);
+		goto err_out;
+	}
  	(STp->buffer)->writing = 0;
  	(STp->buffer)->syscall_result = 0;
+#if 0
  	(STp->buffer)->use_sg = STp->device->host->sg_tablesize;
   	/* Compute the usable buffer size for this SCSI adapter */
@@ -4227,7 +4300,7 @@
  		     i < (STp->buffer)->sg_segs; i++)
  			(STp->buffer)->buffer_size += 
(STp->buffer)->sg[i].length;
  	}
-
+#endif
  	STp->dirty = 0;
  	for (i=0; i < ST_NBR_PARTITIONS; i++) {
  		STps = &(STp->ps[i]);
@@ -4252,6 +4325,10 @@
  #if DEBUG
  		printk(OSST_DEB_MSG "%s:D: Unit not ready, cause %x\n", name, 
SRpnt->sr_sense_buffer[13]);
  #endif
+		if (filp->f_flags & O_NONBLOCK) {
+			retval = -EAGAIN;
+			goto err_out;
+		}
  		if (SRpnt->sr_sense_buffer[13] == 2) {	/* initialize command 
required (LOAD) */
  			memset (cmd, 0, MAX_COMMAND_SIZE);
          		cmd[0] = START_STOP;
@@ -4260,7 +4337,7 @@
  			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, 
SCSI_DATA_NONE,
  					     STp->timeout, MAX_READY_RETRIES, 
TRUE);
  		}
-		osst_wait_ready(STp, &SRpnt, 
(SRpnt->sr_sense_buffer[13]==1?15:3) * 60);
+		osst_wait_ready(STp, &SRpnt, 
(SRpnt->sr_sense_buffer[13]==1?15:3) * 60, 0);
  	}
  	if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70 &&
  	    (SRpnt->sr_sense_buffer[2] & 0x0f) == UNIT_ATTENTION) { /* New 
media? */
@@ -4281,7 +4358,7 @@
  				break;
  		}
  -		STp->device->was_reset = 0;
+		STp->pos_unknown = 0;
  		STp->partition = STp->new_partition = 0;
  		if (STp->can_partitions)
  			STp->nbr_partitions = 1;  /* This guess will be 
updated later if necessary */
@@ -4389,7 +4466,7 @@
  			break;
   			if ((SRpnt->sr_sense_buffer[2] & 0x0f) == 
UNIT_ATTENTION) {
-				STp->device->was_reset = 0;
+				STp->pos_unknown = 0;
  				STp->partition = STp->new_partition = 0;
  				if (STp->can_partitions)
  					STp->nbr_partitions = 1;  /* This 
guess will be updated later if necessary */
@@ -4407,8 +4484,8 @@
  		}
  	}
  -	if (osst_wait_ready(STp, &SRpnt, 15 * 60))		/* FIXME - not 
allowed with NOBLOCK */
-		 printk(KERN_INFO "%s:I: Device did not become Ready in 
open\n",name);
+	if (osst_wait_ready(STp, &SRpnt, 15 * 60, 0))		/* FIXME - not 
allowed with NOBLOCK */
+		 printk(KERN_INFO "%s:I: Device did not become Ready in 
open\n", name);
   	if ((STp->buffer)->syscall_result != 0) {
  		if ((STp->device)->scsi_level >= SCSI_2 &&
@@ -4431,19 +4508,9 @@
   	osst_configure_onstream(STp, &SRpnt);
  -/*	STp->drv_write_prot = ((STp->buffer)->b_data[2] & 0x80) != 0; FIXME */
-
-	if (OS_FRAME_SIZE > (STp->buffer)->buffer_size &&
-	    !enlarge_buffer(STp->buffer, OS_FRAME_SIZE, STp->restr_dma)) {
-		printk(KERN_NOTICE "%s:A: Framesize %d too large for 
buffer.\n", name,
-				     OS_FRAME_SIZE);
-		retval = (-EIO);
-		goto err_out;
-	}
-
-	if ((STp->buffer)->buffer_size >= OS_FRAME_SIZE) {
+	if (STp->buffer->buffer_size >= OS_FRAME_SIZE) {
  		for (i = 0, b_size = 0; -		     i < 
STp->buffer->sg_segs && (b_size + STp->buffer->sg[i].length) <= OS_DATA_SIZE; 
+		     (i < STp->buffer->sg_segs) && ((b_size + 
STp->buffer->sg[i].length) <= OS_DATA_SIZE);  		     b_size += 
STp->buffer->sg[i++].length);
  		STp->buffer->aux = (os_aux_t *) 
(page_address(STp->buffer->sg[i].page) + OS_DATA_SIZE - b_size);
  #if DEBUG
@@ -4452,8 +4519,12 @@
  		printk(OSST_DEB_MSG "%s:D: AUX points to %p in segment %d at 
%p\n", name,
  			 STp->buffer->aux, i, 
page_address(STp->buffer->sg[i].page));
  #endif
-	} else
+	} else {
  		STp->buffer->aux = NULL; /* this had better never happen! */
+		printk(KERN_NOTICE "%s:A: Framesize %d too large for 
buffer.\n", name, OS_FRAME_SIZE);
+		retval = (-EIO);
+		goto err_out;
+	}
   	STp->block_size = STp->raw ? OS_FRAME_SIZE : (
  			     (STm->default_blksize > 0) ? STm->default_blksize 
: OS_DATA_SIZE);
@@ -4510,12 +4581,9 @@
  err_out:
  	if (SRpnt != NULL)
  		scsi_release_request(SRpnt);
-	if (STp->buffer != NULL) {
-		STp->buffer->in_use = 0;
-		STp->buffer = NULL;
-	}
-	STp->in_use = 0;
+	normalize_buffer(STp->buffer);
  	STp->header_ok = 0;
+	STp->in_use = 0;
  	STp->device->access_count--;
   	if (STp->device->host->hostt->module)
@@ -4540,12 +4608,13 @@
  	if (file_count(filp) > 1)
  		return 0;
  -	if ( STps->rw == ST_WRITING && !(STp->device)->was_reset) {
+	if ((STps->rw == ST_WRITING || STp->dirty) && !STp->pos_unknown) {
+		STp->write_type = OS_WRITE_DATA;
  		result = osst_flush_write_buffer(STp, &SRpnt);
  		if (result != 0 && result != (-ENOSPC))
  			goto out;
  	}
-	if ( STps->rw >= ST_WRITING && !(STp->device)->was_reset) {
+	if ( STps->rw >= ST_WRITING && !STp->pos_unknown) {
   #if DEBUG
  		if (debugging) {
@@ -4636,17 +4705,18 @@
  	OS_Scsi_Tape * STp = filp->private_data;
  	Scsi_Request * SRpnt = NULL;
  -	if (STp->door_locked == ST_LOCKED_AUTO)
-		osst_int_ioctl(STp, &SRpnt, MTUNLOCK, 0);
  	if (SRpnt) scsi_release_request(SRpnt);
  -	if (STp->buffer != NULL)
-		STp->buffer->in_use = 0;
+	if (STp->door_locked == ST_LOCKED_AUTO)
+		do_door_lock(STp, 0);
   	if (STp->raw)
  		STp->header_ok = 0;
-
+	 
+	normalize_buffer(STp->buffer);
+	write_lock(&osst_dev_arr_lock);
  	STp->in_use = 0;
+	write_unlock(&osst_dev_arr_lock);
  	STp->device->access_count--;
   	if (STp->device->host->hostt->module)
@@ -4725,7 +4795,7 @@
  			goto out;
  		}
  -		if (!(STp->device)->was_reset) {
+		if (!STp->pos_unknown) {
   			if (STps->eof == ST_FM_HIT) {
  				if (mtc.mt_op == MTFSF || mtc.mt_op == 
MTFSFM|| mtc.mt_op == MTEOM) {
@@ -4771,15 +4841,9 @@
  				retval = (-EIO);
  				goto out;
  			}
+			reset_state(STp);
+			/* remove this when the midlevel properly clears 
was_reset */
  			STp->device->was_reset = 0;
-			if (STp->door_locked != ST_UNLOCKED &&
-			    STp->door_locked != ST_LOCK_FAILS) {
-				if (osst_int_ioctl(STp, &SRpnt, MTLOCK, 0)) {
-					printk(KERN_NOTICE "%s:I: Could not 
relock door after bus reset.\n",
-								  name);
-					STp->door_locked = ST_UNLOCKED;
-				}
-			}
  		}
   		if (mtc.mt_op != MTNOP && mtc.mt_op != MTWEOF && mtc.mt_op != 
MTWSM &&
@@ -4788,7 +4852,7 @@
  			STps->rw = ST_IDLE;  /* Prevent automatic WEOF and fsf 
*/
   		if (mtc.mt_op == MTOFFL && STp->door_locked != ST_UNLOCKED)
-			osst_int_ioctl(STp, &SRpnt, MTUNLOCK, 0);  /* Ignore 
result! */
+			do_door_lock(STp, 0);  /* Ignore result! */
   		if (mtc.mt_op == MTSETDRVBUFFER &&
  		   (mtc.mt_count & MT_ST_OPTIONS) != 0) {
@@ -4844,7 +4908,12 @@
  			retval = i;
  			goto out;
  		}
-
+ +		if (mtc.mt_op == MTLOCK || mtc.mt_op == MTUNLOCK) {
+			retval = do_door_lock(STp, (mtc.mt_op == MTLOCK));
+			goto out;
+		}
+			 
  /*   if (STp->can_partitions && STp->ready == ST_READY &&
  	 (i = update_partition(inode)) < 0)
  		 {retval=i;goto out;}*/
@@ -4974,15 +5043,12 @@
  
 
  /* Memory handling routines */
  -/* Try to allocate a new tape buffer */
-static OSST_buffer * new_tape_buffer( int from_initialization, int need_dma )
+/* Try to allocate a new tape buffer skeleton. Caller must not hold 
dev_arr_lock */
+static OSST_buffer * new_tape_buffer( int from_initialization, int need_dma, 
int max_sg )
  {
-	int i, priority, b_size, order, got = 0, segs = 0;
+	int i, priority;
  	OSST_buffer *tb;
  -	if (osst_nbr_buffers >= osst_template.dev_max)
-		return NULL;  /* Should never happen */
-
  	if (from_initialization)
  		priority = GFP_ATOMIC;
  	else
@@ -4990,144 +5056,94 @@
   	i = sizeof(OSST_buffer) + (osst_max_sg_segs - 1) * sizeof(struct 
scatterlist);
  	tb = (OSST_buffer *)kmalloc(i, priority);
-	if (tb) {
-//    tb->this_size = i;
-		if (need_dma)
-			priority |= GFP_DMA;
-
-		/* Try to allocate the first segment up to OSST_FIRST_ORDER 
and the
-		 others big enough to reach the goal */
-		for (b_size = PAGE_SIZE,          order = 0;
-		     b_size < osst_buffer_size && order < OSST_FIRST_ORDER;
-		     b_size *= 2,                 order++ );
-
-		for ( ; b_size >= PAGE_SIZE; order--, b_size /= 2) {
-			tb->sg[0].page = alloc_pages(priority, order);
-			tb->sg[0].offset = 0;
-			if (tb->sg[0].page != NULL) {
-			    tb->sg[0].length = b_size;
-			    break;
-			}
-		}
-		if (tb->sg[segs].page == NULL) {
-			kfree(tb);
-			tb = NULL;
-		}
-		else {  /* Got something, continue */
-
-			for (b_size = PAGE_SIZE, order = 0;
-			     osst_buffer_size > tb->sg[0].length + 
(OSST_FIRST_SG - 1) * b_size;
-			     b_size *= 2, order++ );
-
-			for (segs=1, got=tb->sg[0].length;
-			     got < osst_buffer_size && segs < OSST_FIRST_SG; ) 
{
-			    tb->sg[segs].page = alloc_pages(priority, order);
-			    tb->sg[segs].offset = 0;
-			    if (tb->sg[segs].page == NULL) {
-				if (osst_buffer_size - got <=
-				    (OSST_FIRST_SG - segs) * b_size / 2) {
-				    b_size /= 2; /* Large enough for the rest 
of the buffers */
-				    order--;
-				    continue;
-				}
-				tb->sg_segs = segs;
-				tb->orig_sg_segs = 0;
-#if DEBUG
-				tb->buffer_size = got;
-#endif
-				normalize_buffer(tb);
-				kfree(tb);
-				tb = NULL;
-				break;
-			    }
-                            tb->sg[segs].page = NULL;
-			    tb->sg[segs].length = b_size;
-			    got += b_size;
-			    segs++;
-			}
-		}
-	}
  	if (!tb) {
-		printk(KERN_NOTICE "osst :I: Can't allocate new tape buffer 
(nbr %d).\n",
-				   osst_nbr_buffers);
+		printk(KERN_NOTICE "osst :I: Can't allocate new tape 
buffer.\n");
  		return NULL;
  	}
-	tb->sg_segs = tb->orig_sg_segs = segs;
-	tb->b_data = page_address(tb->sg[0].page);
-
+	memset(tb, 0, i);
+	tb->sg_segs = tb->orig_sg_segs = 0;
+	tb->use_sg = max_sg;
+	tb->in_use = TRUE;
+	tb->dma = need_dma;
+	tb->buffer_size = 0;
  #if DEBUG
-	if (debugging) {
-		printk(OSST_DEB_MSG
-			"osst :D: Allocated tape buffer %d (%d bytes, %d 
segments, dma: %d, a: %p).\n",
-			   osst_nbr_buffers, got, tb->sg_segs, need_dma, 
tb->b_data);
+	if (debugging)  		printk(OSST_DEB_MSG
-			"osst :D: segment sizes: first %d, last %d bytes.\n",
-			   tb->sg[0].length, tb->sg[segs-1].length);
-	}
+			"osst :D: Allocated tape buffer skeleton (%d bytes, %d 
segments, dma: %d).\n",
+			   i, max_sg, need_dma);
  #endif
-	tb->in_use = 0;
-	tb->dma = need_dma;
-	tb->buffer_size = got;
-	tb->writing = 0;
-	osst_buffers[osst_nbr_buffers++] = tb;
-
  	return tb;
  }
  -
-/* Try to allocate a temporary enlarged tape buffer */
-static int enlarge_buffer(OSST_buffer *STbuffer, int new_size, int need_dma)
+/* Try to allocate a temporary (while a user has the device open) enlarged 
tape buffer */
+static int enlarge_buffer(OSST_buffer *STbuffer, int need_dma)
  {
  	int segs, nbr, max_segs, b_size, priority, order, got;
  -	normalize_buffer(STbuffer);
+	if (STbuffer->buffer_size >= OS_FRAME_SIZE)
+		return TRUE;
  -	max_segs = STbuffer->use_sg;
-	if (max_segs > osst_max_sg_segs)
-		max_segs = osst_max_sg_segs;
-	nbr = max_segs - STbuffer->sg_segs;
-	if (nbr <= 0)
+	if (STbuffer->sg_segs) {
+		printk(KERN_WARNING "osst :A: Buffer not previously 
normalized.\n");
+		normalize_buffer(STbuffer);
+	}
+	/* See how many segments we can use -- need at least two */
+	nbr = max_segs = STbuffer->use_sg;
+	if (nbr <= 2)
  		return FALSE;
   	priority = GFP_KERNEL;
  	if (need_dma)
  		priority |= GFP_DMA;
-	for (b_size = PAGE_SIZE, order = 0;
-		 b_size * nbr < new_size - STbuffer->buffer_size;
-		 b_size *= 2, order++);
-
-	for (segs=STbuffer->sg_segs, got=STbuffer->buffer_size;
-	     segs < max_segs && got < new_size; ) {
-		STbuffer->sg[segs].page = alloc_pages(priority, order);
+
+	/* Try to allocate the first segment up to OS_DATA_SIZE and the others
+	   big enough to reach the goal (code assumes no segments in place) */
+	for (b_size = OS_DATA_SIZE, order = OSST_FIRST_ORDER; b_size >= 
PAGE_SIZE; order--, b_size /= 2) {
+		STbuffer->sg[0].page = alloc_pages(priority, order);
+		STbuffer->sg[0].offset = 0;
+		if (STbuffer->sg[0].page != NULL) {
+		    STbuffer->sg[0].length = b_size;
+		    STbuffer->b_data = page_address(STbuffer->sg[0].page);
+		    break;
+		}
+	}
+	if (STbuffer->sg[0].page == NULL) {
+		printk(KERN_NOTICE "osst :I: Can't allocate tape buffer main 
segment.\n");
+		return FALSE;
+	}
+	/* Got initial segment of 'bsize,order', continue with same size if 
possible, except for AUX */
+	for (segs=STbuffer->sg_segs=1, got=b_size;
+	     segs < max_segs && got < OS_FRAME_SIZE; ) {
+		STbuffer->sg[segs].page =
+			(OS_FRAME_SIZE - got <= PAGE_SIZE / 2) ?
+				kmalloc(OS_FRAME_SIZE - got, priority):
+				alloc_pages(priority, order);
  		STbuffer->sg[segs].offset = 0;
  		if (STbuffer->sg[segs].page == NULL) {
-			if (new_size - got <= (max_segs - segs) * b_size / 2) {
+			if (OS_FRAME_SIZE - got <= (max_segs - segs) * b_size 
/ 2 && order) {
  				b_size /= 2;  /* Large enough for the rest of 
the buffers */
  				order--;
  				continue;
  			}
  			printk(KERN_WARNING "osst :W: Failed to enlarge buffer 
to %d bytes.\n",
-						new_size);
+						OS_FRAME_SIZE);
  #if DEBUG
  			STbuffer->buffer_size = got;
  #endif
  			normalize_buffer(STbuffer);
  			return FALSE;
  		}
-		STbuffer->sg[segs].page = NULL;
-		STbuffer->sg[segs].length = b_size;
-		STbuffer->sg_segs += 1;
-		got += b_size;
+		STbuffer->sg[segs].length = (OS_FRAME_SIZE - got <= PAGE_SIZE 
/ 2) ? (OS_FRAME_SIZE - got) : b_size;
+		got += STbuffer->sg[segs].length;
  		STbuffer->buffer_size = got;
-		segs++;
+		STbuffer->sg_segs = ++segs;
  	}
  #if DEBUG
  	if (debugging) {
-		for (nbr=0; osst_buffers[nbr] != STbuffer && nbr < 
osst_nbr_buffers; nbr++);
-			printk(OSST_DEB_MSG
-			   "osst :D: Expanded tape buffer %d (%d bytes, %d->%d 
segments, dma: %d, a: %p).\n",
-			   nbr, got, STbuffer->orig_sg_segs, 
STbuffer->sg_segs, need_dma, STbuffer->b_data);
-			printk(OSST_DEB_MSG
+		printk(OSST_DEB_MSG
+			   "osst :D: Expanded tape buffer (%d bytes, %d->%d 
segments, dma: %d, at: %p).\n",
+			   got, STbuffer->orig_sg_segs, STbuffer->sg_segs, 
need_dma, STbuffer->b_data);
+		printk(OSST_DEB_MSG
  			   "osst :D: segment sizes: first %d, last %d 
bytes.\n",
  			   STbuffer->sg[0].length, 
STbuffer->sg[segs-1].length);
  	}
@@ -5137,12 +5153,12 @@
  }
   -/* Release the extra buffer */
+/* Release the segments */
  static void normalize_buffer(OSST_buffer *STbuffer)
  {
    int i, order, b_size;
  -	for (i=STbuffer->orig_sg_segs; i < STbuffer->sg_segs; i++) {
+	for (i=0; i < STbuffer->sg_segs; i++) {
   		for (b_size = PAGE_SIZE, order = 0;
  		     b_size < STbuffer->sg[i].length;
@@ -5156,7 +5172,7 @@
  		printk(OSST_DEB_MSG "osst :D: Buffer at %p normalized to %d 
bytes (segs %d).\n",
  			     STbuffer->b_data, STbuffer->buffer_size, 
STbuffer->sg_segs);
  #endif
-	STbuffer->sg_segs = STbuffer->orig_sg_segs;
+	STbuffer->sg_segs = STbuffer->orig_sg_segs = 0;
  }
   @@ -5300,28 +5316,24 @@
   static void validate_options (void)
  {
-  if (buffer_kbs > 0)
-		osst_buffer_size = buffer_kbs * ST_KILOBYTE;
-  if (write_threshold_kbs > 0)
+	if (max_dev > 0)
+		osst_max_dev = max_dev;  +	if (write_threshold_kbs > 0)
  		osst_write_threshold = write_threshold_kbs * ST_KILOBYTE;
-  if (osst_write_threshold > osst_buffer_size)
+	if (osst_write_threshold > osst_buffer_size)
  		osst_write_threshold = osst_buffer_size;
-  if (max_buffers > 0)
-		osst_max_buffers = max_buffers;
-  if (max_sg_segs >= OSST_FIRST_SG)
+	if (max_sg_segs >= OSST_FIRST_SG)
  		osst_max_sg_segs = max_sg_segs;
  #if DEBUG
-  printk(OSST_DEB_MSG "osst :D: bufsize %d, wrt %d, max buffers %d, s/g segs 
%d.\n",
-	 osst_buffer_size, osst_write_threshold, osst_max_buffers, 
osst_max_sg_segs);
-//printk(OSST_DEB_MSG "osst :D: sizeof(header) = %d (%s)\n",
-//		 
sizeof(os_header_t),sizeof(os_header_t)==OS_DATA_SIZE?"ok":"error");
+	printk(OSST_DEB_MSG "osst :D: max tapes %d, write threshold %d, s/g 
segs %d.\n",
+			   osst_max_dev, osst_write_threshold, 
osst_max_sg_segs);
  #endif
  }
  	 
  #ifndef MODULE
  /* Set the boot options. Syntax: osst=xxx,yyy,...
-   where xxx is buffer size in 1024 byte blocks and yyy is write threshold
-   in 1024 byte blocks. */
+   where xxx is write threshold in 1024 byte blocks,
+   and   yyy is number of s/g segments to use. */
  static int __init osst_setup (char *str)
  {
    int i, ints[5];
@@ -5359,14 +5371,30 @@
   #endif
  +/* Driverfs file support */
+static ssize_t osst_device_kdev_read(struct device *driverfs_dev, char *page, 
size_t count, loff_t off)
+{
+	kdev_t kdev; +	kdev.value=(int)(long)driverfs_dev->driver_data;
+	return off ? 0 : sprintf(page, "%x\n",kdev.value);
+}
+static DEVICE_ATTR(kdev,S_IRUGO,osst_device_kdev_read,NULL);
+
+static ssize_t osst_device_type_read(struct device *driverfs_dev, char *page, 
size_t count, loff_t off) +{
+	return off ? 0 : sprintf (page, "CHR\n");
+}
+static DEVICE_ATTR(type,S_IRUGO,osst_device_type_read,NULL);
+
   static struct file_operations osst_fops = {
-	read:		osst_read,
-	write:		osst_write,
-	ioctl:		osst_ioctl,
-	open:		os_scsi_tape_open,
-	flush:		os_scsi_tape_flush,
-	release:	os_scsi_tape_close,
+	.owner =        THIS_MODULE,
+	.read =         osst_read,
+	.write =        osst_write,
+	.ioctl =        osst_ioctl,
+	.open =         os_scsi_tape_open,
+	.flush =        os_scsi_tape_flush,
+	.release =      os_scsi_tape_close,
  };
   static int osst_supports(Scsi_Device * SDp)
@@ -5397,97 +5425,86 @@
  	return 0;
  }
  +/*
+ * osst startup / cleanup code
+ */
+
  static int osst_attach(Scsi_Device * SDp)
  {
  	OS_Scsi_Tape * tpnt;
  	ST_mode * STm;
  	ST_partstat * STps;
-	int i, dev;
-	struct gendisk *disk;
-#ifdef CONFIG_DEVFS_FS
-	int mode;
-#endif
+	OSST_buffer *buffer;
+	struct gendisk *drive;
+	int i, mode, dev_num;
   	if (SDp->type != TYPE_TAPE || !osst_supports(SDp))
-		 return 1;
+		return 1;
  -	disk = alloc_disk(1);
-	if (!disk)
+	drive = alloc_disk(1);
+	if (!drive)
  		return 1;
  -	if (osst_template.nr_dev >= osst_template.dev_max) {
-		 SDp->attached--;
-		 put_disk(disk);
-		 return 1;
+	/* if this is the first attach, build the infrastructure */
+	write_lock(&osst_dev_arr_lock);
+	if (os_scsi_tapes == NULL) {
+		os_scsi_tapes =
+			(OS_Scsi_Tape **)kmalloc(osst_max_dev * 
sizeof(OS_Scsi_Tape *),
+				   GFP_ATOMIC);
+		if (os_scsi_tapes == NULL) {
+			write_unlock(&osst_dev_arr_lock);
+			printk(KERN_ERR "osst :E: Unable to allocate array for 
OnStream SCSI tapes.\n");
+			return 1;
+		}
+		for (i=0; i < osst_max_dev; ++i) os_scsi_tapes[i] = NULL;
  	}
  	 
+	if (osst_nr_dev >= osst_max_dev) {
+		SDp->attached--;
+		put_disk(drive);
+		write_unlock(&osst_dev_arr_lock);
+		printk(KERN_ERR "osst :E: Too many tape devices (max. %d).\n", 
osst_max_dev);
+		return 1;
+	}
+
  	/* find a free minor number */
-	for (i=0; os_scsi_tapes[i] && i<osst_template.dev_max; i++);
-	if(i >= osst_template.dev_max) panic ("Scsi_devices corrupt (osst)");
+	for (i=0; os_scsi_tapes[i] && i<osst_max_dev; i++);
+	if(i >= osst_max_dev) panic ("Scsi_devices corrupt (osst)");
+	dev_num = i;
   	/* allocate a OS_Scsi_Tape for this device */
  	tpnt = (OS_Scsi_Tape *)kmalloc(sizeof(OS_Scsi_Tape), GFP_ATOMIC);
  	if (tpnt == NULL) {
-		 SDp->attached--;
-		 printk(KERN_WARNING "osst :W: Can't allocate device 
descriptor.\n");
-		 put_disk(disk);
-		 return 1;
+		SDp->attached--;
+		put_disk(drive);
+		write_unlock(&osst_dev_arr_lock);
+		printk(KERN_ERR "osst :E: Can't allocate device descriptor, 
device not attached.\n");
+		return 1;
  	}
  	memset(tpnt, 0, sizeof(OS_Scsi_Tape));
-	os_scsi_tapes[i] = tpnt;
-	dev = i;
-	tpnt->capacity = 0xfffff;
   	/* allocate a buffer for this device */
-	if (!new_tape_buffer(TRUE, TRUE)) -		 printk(KERN_ERR "osst 
:W: Unable to allocate a tape buffer.\n");
-
-#ifdef CONFIG_DEVFS_FS
-	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-		 char name[8];
-		 static char *formats[ST_NBR_MODES] ={"", "l", "m", "a"};
-
-		 /*  Rewind entry  */
-		 sprintf (name, "mt%s", formats[mode]);
-# if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-		 tpnt->de_r[mode] =
-			devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
-			   MAJOR_NR, i + (mode << 5),
-			   S_IFCHR | S_IRUGO | S_IWUGO,
-			   &osst_fops, NULL);
-# else
-		 tpnt->de_r[mode] =
-			devfs_register (SDp->de, name, 0, DEVFS_FL_DEFAULT,
-			   MAJOR_NR, i + (mode << 5),
-			   S_IFCHR | S_IRUGO | S_IWUGO,
-			   0, 0, &osst_fops, NULL);
-# endif		 
-		 /*  No-rewind entry  */
-		 sprintf (name, "mt%sn", formats[mode]);
-# if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-		 tpnt->de_n[mode] =
-			devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
-			   MAJOR_NR, i + (mode << 5) + 128,
-			   S_IFCHR | S_IRUGO | S_IWUGO,
-			   &osst_fops, NULL);
-# else		 
-		 tpnt->de_n[mode] =
-			devfs_register (SDp->de, name, 0, DEVFS_FL_DEFAULT,
-			   MAJOR_NR, i + (mode << 5) + 128,
-			   S_IFCHR | S_IRUGO | S_IWUGO,
-			   0, 0, &osst_fops, NULL);
-# endif
+	i = SDp->host->sg_tablesize;
+	if (osst_max_sg_segs < i)
+		i = osst_max_sg_segs;
+	buffer = new_tape_buffer(TRUE, SDp->host->unchecked_isa_dma, i);
+	if (buffer == NULL) {
+		SDp->attached--;
+		write_unlock(&osst_dev_arr_lock);
+		printk(KERN_ERR "osst :E: Unable to allocate a tape buffer, 
device not attached.\n");
+		kfree(tpnt);
+		return 1;
  	}
-	devfs_register_tape (tpnt->de_r[0]);
-#endif
-
+	os_scsi_tapes[dev_num] = tpnt;
+	tpnt->buffer = buffer;
  	tpnt->device = SDp;
-	disk->private_data = &tpnt->driver;
-	sprintf(disk->disk_name, "osst%d", i);
+	drive->private_data = &tpnt->driver;
+	sprintf(drive->disk_name, "osst%d", dev_num);
  	tpnt->driver = &osst_template;
-	tpnt->disk = disk;
-	tpnt->dirty = 0;
+	tpnt->drive = drive;
  	tpnt->in_use = 0;
+	tpnt->capacity = 0xfffff;
+	tpnt->dirty = 0;
  	tpnt->drv_buffer = 1;  /* Try buffering if no mode sense */
  	tpnt->restr_dma = (SDp->host)->unchecked_isa_dma;
  	tpnt->density = 0;
@@ -5512,7 +5529,8 @@
  	tpnt->os_fw_rev = osst_parse_firmware_rev (SDp->rev);
  	tpnt->omit_blklims = 1;
  -	tpnt->poll = (strncmp(SDp->model, "DI-", 3) == 0) || 
OSST_FW_NEED_POLL(tpnt->os_fw_rev,SDp);
+	tpnt->poll = (strncmp(SDp->model, "DI-", 3) == 0) || +		     
(strncmp(SDp->model, "FW-", 3) == 0) || OSST_FW_NEED_POLL(tpnt->os_fw_rev,SDp);
  	tpnt->frame_in_buffer = 0;
  	tpnt->header_ok = 0;
  	tpnt->linux_media = 0;
@@ -5545,9 +5563,56 @@
  	tpnt->modes[0].defined = TRUE;
  	tpnt->modes[2].defined = TRUE;
  	tpnt->density_changed = tpnt->compression_changed = 
tpnt->blksize_changed = FALSE;
+
  	init_MUTEX(&tpnt->lock);
+	osst_nr_dev++;
+	write_unlock(&osst_dev_arr_lock);
  -	osst_template.nr_dev++;
+	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
+		char name[8];
+		static char *formats[ST_NBR_MODES] ={"", "l", "m", "a"};
+		 
+		/*  Rewind entry  */
+		sprintf (name, "ot%s", formats[mode]);
+		sprintf(tpnt->driverfs_dev_r[mode].bus_id, "%s:%s", 
+				SDp->sdev_driverfs_dev.bus_id, name);
+		sprintf(tpnt->driverfs_dev_r[mode].name, "%s%s", 
+				SDp->sdev_driverfs_dev.name, name);
+		tpnt->driverfs_dev_r[mode].parent = &SDp->sdev_driverfs_dev;
+		tpnt->driverfs_dev_r[mode].bus = &scsi_driverfs_bus_type;
+		tpnt->driverfs_dev_r[mode].driver_data =
+			(void *)(long)__mkdev(MAJOR_NR, dev_num + (mode << 5));
+		device_register(&tpnt->driverfs_dev_r[mode]);
+		device_create_file(&tpnt->driverfs_dev_r[mode], 
+				&dev_attr_type);
+		device_create_file(&tpnt->driverfs_dev_r[mode], 
&dev_attr_kdev);
+		tpnt->de_r[mode] =
+			devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
+					MAJOR_NR, dev_num + (mode << 5),
+					S_IFCHR | S_IRUGO | S_IWUGO,
+					&osst_fops, NULL);
+		/*  No-rewind entry  */
+		sprintf (name, "ot%sn", formats[mode]);
+		sprintf(tpnt->driverfs_dev_n[mode].bus_id, "%s:%s", 
+				SDp->sdev_driverfs_dev.bus_id, name);
+		sprintf(tpnt->driverfs_dev_n[mode].name, "%s%s", 
+				SDp->sdev_driverfs_dev.name, name);
+		tpnt->driverfs_dev_n[mode].parent= &SDp->sdev_driverfs_dev;
+		tpnt->driverfs_dev_n[mode].bus = &scsi_driverfs_bus_type;
+		tpnt->driverfs_dev_n[mode].driver_data =
+			(void *)(long)__mkdev(MAJOR_NR, dev_num + (mode << 5) 
+ 128);
+		device_register(&tpnt->driverfs_dev_n[mode]);
+		device_create_file(&tpnt->driverfs_dev_n[mode], 
+				&dev_attr_type);
+		device_create_file(&tpnt->driverfs_dev_n[mode], 
+				&dev_attr_kdev);
+		tpnt->de_n[mode] =
+			devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
+					MAJOR_NR, dev_num + (mode << 5) + 128,
+					S_IFCHR | S_IRUGO | S_IWUGO,
+					&osst_fops, NULL);
+	}
+	devfs_register_tape (tpnt->de_r[0]);
   	printk(KERN_INFO
  		"osst :I: Attached OnStream %.5s tape at scsi%d, channel %d, 
id %d, lun %d as %s\n",
@@ -5561,101 +5626,76 @@
  	if (SDp->type != TYPE_TAPE) return 0;
  	if ( ! osst_supports(SDp) ) return 0;
  	 
-	osst_template.dev_noticed++;
+	osst_dev_noticed++;
  	return 1;
  }
  -static int osst_registered = 0;
-
-/* Driver initialization (not __initfunc because may be called later) */
-static int osst_init()
-{
-	int i;
-
-	if (osst_template.dev_noticed == 0)
-		return 0;
-
-	if (!osst_registered) {
-		if (register_chrdev(MAJOR_NR,"osst",&osst_fops)) {
-			printk(KERN_ERR "osst :W: Unable to get major %d for 
OnStream tapes\n",MAJOR_NR);
-			return 1;
-		}
-		osst_registered++;
-	}
-
-	if (os_scsi_tapes)
-		return 0;
-	osst_template.dev_max = OSST_MAX_TAPES;
-	if (osst_template.dev_max > 128 / ST_NBR_MODES)
-		printk(KERN_INFO "osst :I: Only %d tapes accessible.\n", 128 / 
ST_NBR_MODES);
-	os_scsi_tapes = kmalloc(osst_template.dev_max * sizeof(OS_Scsi_Tape *),
-								GFP_ATOMIC);
-	if (!os_scsi_tapes) {
-		printk(KERN_ERR "osst :W: Unable to allocate array for 
OnStream SCSI tapes.\n");
-		unregister_chrdev(MAJOR_NR, "osst");
-		return 1;
-	}
-
-	for (i=0; i < osst_template.dev_max; ++i)
-		os_scsi_tapes[i] = NULL;
-
-	/* Allocate the buffer pointers */
-	osst_buffers = kmalloc(osst_template.dev_max * sizeof(OSST_buffer *),
-								GFP_ATOMIC);
-	if (!osst_buffers) {
-		printk(KERN_ERR "osst :W: Unable to allocate tape buffer 
pointers.\n");
-		unregister_chrdev(MAJOR_NR, "osst");
-		kfree(os_scsi_tapes);
-		return 1;
-	}
-	osst_nbr_buffers = 0;
-
-	printk(KERN_INFO "osst :I: Tape driver with OnStream support version 
%s\nosst :I: %s\n", osst_version, cvsid);
-
-#if DEBUG
-	printk(OSST_DEB_MSG "osst :D: Buffer size %d bytes, write threshold %d 
bytes.\n",
-			osst_buffer_size, osst_write_threshold);
-#endif
-	return 0;
-}
-
   static void osst_detach(Scsi_Device * SDp)
  {
    OS_Scsi_Tape * tpnt;
-  int i;
-#ifdef CONFIG_DEVFS_FS
-  int mode;
-#endif
+  int i, mode;
  -  for(i=0; i<osst_template.dev_max; i++) {
+  write_lock(&osst_dev_arr_lock);
+  for(i=0; i<osst_max_dev; i++) {
  	tpnt = os_scsi_tapes[i];
  	if(tpnt != NULL && tpnt->device == SDp) {
  		tpnt->device = NULL;
-#ifdef CONFIG_DEVFS_FS
  		for (mode = 0; mode < ST_NBR_MODES; ++mode) {
  			devfs_unregister (tpnt->de_r[mode]);
  			tpnt->de_r[mode] = NULL;
  			devfs_unregister (tpnt->de_n[mode]);
  			tpnt->de_n[mode] = NULL;
  		}
-#endif
-		put_disk(tpnt->disk);
-		kfree(tpnt);
+		put_disk(tpnt->drive);
  		os_scsi_tapes[i] = NULL;
  		SDp->attached--;
-		osst_template.nr_dev--;
-		osst_template.dev_noticed--;
+		osst_nr_dev--;
+		osst_dev_noticed--;
+		write_unlock(&osst_dev_arr_lock);
+		for (mode = 0; mode < ST_NBR_MODES; ++mode) {
+			device_remove_file(&tpnt->driverfs_dev_r[mode],
+					&dev_attr_type);
+			device_remove_file(&tpnt->driverfs_dev_r[mode],
+					&dev_attr_kdev);
+			device_unregister(&tpnt->driverfs_dev_r[mode]);
+			device_remove_file(&tpnt->driverfs_dev_n[mode],
+					&dev_attr_type);
+			device_remove_file(&tpnt->driverfs_dev_n[mode],
+					&dev_attr_kdev);
+			device_unregister(&tpnt->driverfs_dev_n[mode]);
+			}
+		if (tpnt->header_cache != NULL) vfree(tpnt->header_cache);
+		if (tpnt->buffer) {
+			normalize_buffer(tpnt->buffer);
+			kfree(tpnt->buffer);
+		}
+		kfree(tpnt);
  		return;
  	}
    }
+  write_unlock(&osst_dev_arr_lock);
    return;
  }
   static int __init init_osst(void)  {
+	printk(KERN_INFO "osst :I: Tape driver with OnStream support version 
%s\nosst :I: %s\n", osst_version, cvsid);
+
  	validate_options();
-	return scsi_register_device(&osst_template);
+#if DEBUG
+	 printk(OSST_DEB_MSG "osst :D: %d s/g segments, write threshold %d 
bytes.\n",
+			 max_sg_segs, osst_write_threshold);
+#endif
+	if ((register_chrdev(MAJOR_NR,"osst",&osst_fops) < 0) || 
scsi_register_device(&osst_template)) {
+		printk(KERN_ERR "osst :E: Unable to register major %d for 
OnStream tapes\n",MAJOR_NR);
+		return 1;
+	}
+	osst_template.scsi_driverfs_driver.name = (char *)osst_template.tag;
+	osst_template.scsi_driverfs_driver.bus  = &scsi_driverfs_bus_type;
+	driver_register(&osst_template.scsi_driverfs_driver);
+
+	return 0;
  }
   static void __exit exit_osst (void)
@@ -5665,31 +5705,23 @@
   	scsi_unregister_device(&osst_template);
  	unregister_chrdev(MAJOR_NR, "osst");
-	osst_registered--;
+	driver_unregister(&osst_template.scsi_driverfs_driver);
+
  	if (os_scsi_tapes) {
-		for (i=0; i < osst_template.dev_max; ++i) {
-			STp = os_scsi_tapes[i];
-			if (!STp)
-				continue;
+		for (i=0; i < osst_max_dev; ++i) {
+			if (!(STp = os_scsi_tapes[i])) continue;
+			/* This is defensive, supposed to happen during detach 
*/
  			if (STp->header_cache)
  				vfree(STp->header_cache);
-			put_disk(STp->disk);
+			if (STp->buffer) {
+				normalize_buffer(STp->buffer);
+				kfree(STp->buffer);
+			}
+			put_disk(STp->drive);
  			kfree(STp);
  		}
  		kfree(os_scsi_tapes);
-
-		if (osst_buffers) {
-			for (i=0; i < osst_nbr_buffers; i++) {
-				if (osst_buffers[i]) {
-					osst_buffers[i]->orig_sg_segs = 0;
-					normalize_buffer(osst_buffers[i]);
-					kfree(osst_buffers[i]);
-				}
-			}
-			kfree(osst_buffers);
-		}
  	}
-	osst_template.dev_max = 0;
  	printk(KERN_INFO "osst :I: Unloaded.\n");
  }
  
