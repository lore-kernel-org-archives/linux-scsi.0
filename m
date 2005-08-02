From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: RE: [PATCH] drivers/scsi/st.c: add reference count and related fixes
Date: Tue, 2 Aug 2005 13:40:47 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0508021339520.7904@kai.makisara.local>
References: <92952AEF1F064042B6EF2522E0EEF437348377@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep07-0.kolumbus.fi ([193.229.0.51]:42228 "EHLO
	fep07-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261477AbVHBKgo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2005 06:36:44 -0400
In-Reply-To: <92952AEF1F064042B6EF2522E0EEF437348377@EXNA.corp.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dailey, Nate" <Nate.Dailey@stratus.com>
Cc: Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org

I have rediffed the patch against 2.6.13-rc5, done a couple of cosmetic
cleanups, and run some tests.  Brian King has acknowledged that it fixes the
problems he has seen. Seems mature enough for inclusion into 2.6.14 (or
later)?

Nate's explanation of the changes:

I've attached patches against 2.6.13rc2. These are basically identical
to my earlier patches, as I found that all issues I'd seen in earlier
kernels still existed in this kernel.

To summarize, the changes are: (more details in my original email)

- add a kref to the scsi_tape structure, and associate reference
counting stuff

- set sr_request->end_io = blk_end_sync_rq so we get notified when an IO
is rejected when the device goes away

- check rq_status when IOs complete, else we don't know that IOs
rejected for a dead device in fact did not complete

- change last_SRpnt so it's set before an async IO is issued (in case
st_sleep_done is bypassed)

- fix a bogus use of last_SRpnt in st_chk_result


Nate Dailey
Stratus Technologies

Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.13-rc5-k1/drivers/scsi/st.c	2005-08-02 12:34:48.000000000 +0300
+++ linux-2.6.13-rc5-k2/drivers/scsi/st.c	2005-08-02 12:32:21.000000000 +0300
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20050501";
+static char *verstr = "20050802";
 
 #include <linux/module.h>
 
@@ -219,6 +219,12 @@ static int switch_partition(struct scsi_
 
 static int st_int_ioctl(struct scsi_tape *, unsigned int, unsigned long);
 
+static void scsi_tape_release(struct kref *);
+
+#define to_scsi_tape(obj) container_of(obj, struct scsi_tape, kref)
+
+static DECLARE_MUTEX(st_ref_sem);
+
 

 #include "osst_detect.h"
 #ifndef SIGS_FROM_OSST
@@ -230,6 +236,46 @@ static int st_int_ioctl(struct scsi_tape
 	{"OnStream", "FW-", "", "osst"}
 #endif
 
+static struct scsi_tape *scsi_tape_get(int dev)
+{
+	struct scsi_tape *STp = NULL;
+
+	down(&st_ref_sem);
+	write_lock(&st_dev_arr_lock);
+
+	if (dev < st_dev_max && scsi_tapes != NULL)
+		STp = scsi_tapes[dev];
+	if (!STp) goto out;
+
+	kref_get(&STp->kref);
+
+	if (!STp->device)
+		goto out_put;
+
+	if (scsi_device_get(STp->device))
+		goto out_put;
+
+	goto out;
+
+out_put:
+	kref_put(&STp->kref, scsi_tape_release);
+	STp = NULL;
+out:
+	write_unlock(&st_dev_arr_lock);
+	up(&st_ref_sem);
+	return STp;
+}
+
+static void scsi_tape_put(struct scsi_tape *STp)
+{
+	struct scsi_device *sdev = STp->device;
+
+	down(&st_ref_sem);
+	kref_put(&STp->kref, scsi_tape_release);
+	scsi_device_put(sdev);
+	up(&st_ref_sem);
+}
+
 struct st_reject_data {
 	char *vendor;
 	char *model;
@@ -311,7 +357,7 @@ static int st_chk_result(struct scsi_tap
 		return 0;
 
 	cmdstatp = &STp->buffer->cmdstat;
-	st_analyze_sense(STp->buffer->last_SRpnt, cmdstatp);
+	st_analyze_sense(SRpnt, cmdstatp);
 
 	if (cmdstatp->have_sense)
 		scode = STp->buffer->cmdstat.sense_hdr.sense_key;
@@ -399,10 +445,10 @@ static void st_sleep_done(struct scsi_cm
 
 	(STp->buffer)->cmdstat.midlevel_result = SCpnt->result;
 	SCpnt->request->rq_status = RQ_SCSI_DONE;
-	(STp->buffer)->last_SRpnt = SCpnt->sc_request;
 	DEB( STp->write_pending = 0; )
 
-	complete(SCpnt->request->waiting);
+	if (SCpnt->request->waiting)
+		complete(SCpnt->request->waiting);
 }
 
 /* Do the scsi command. Waits until command performed if do_wait is true.
@@ -412,8 +458,20 @@ static struct scsi_request *
 st_do_scsi(struct scsi_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd,
 	   int bytes, int direction, int timeout, int retries, int do_wait)
 {
+	struct completion *waiting;
 	unsigned char *bp;
 
+	/* if async, make sure there's no command outstanding */
+	if (!do_wait && ((STp->buffer)->last_SRpnt)) {
+		printk(KERN_ERR "%s: Async command already active.\n",
+		       tape_name(STp));
+		if (signal_pending(current))
+			(STp->buffer)->syscall_result = (-EINTR);
+		else
+			(STp->buffer)->syscall_result = (-EBUSY);
+		return NULL;
+	}
+
 	if (SRpnt == NULL) {
 		SRpnt = scsi_allocate_request(STp->device, GFP_ATOMIC);
 		if (SRpnt == NULL) {
@@ -427,7 +485,13 @@ st_do_scsi(struct scsi_request * SRpnt, 
 		}
 	}
 
-	init_completion(&STp->wait);
+	/* If async IO, set last_SRpnt. This ptr tells write_behind_check
+	   which IO is outstanding. It's nulled out when the IO completes. */
+	if (!do_wait)
+		(STp->buffer)->last_SRpnt = SRpnt;
+
+	waiting = &STp->wait;
+	init_completion(waiting);
 	SRpnt->sr_use_sg = STp->buffer->do_dio || (bytes > (STp->buffer)->frp[0].length);
 	if (SRpnt->sr_use_sg) {
 		if (!STp->buffer->do_dio)
@@ -438,17 +502,20 @@ st_do_scsi(struct scsi_request * SRpnt, 
 		bp = (STp->buffer)->b_data;
 	SRpnt->sr_data_direction = direction;
 	SRpnt->sr_cmd_len = 0;
-	SRpnt->sr_request->waiting = &(STp->wait);
+	SRpnt->sr_request->waiting = waiting;
 	SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;
 	SRpnt->sr_request->rq_disk = STp->disk;
+	SRpnt->sr_request->end_io = blk_end_sync_rq;
 	STp->buffer->cmdstat.have_sense = 0;
 
 	scsi_do_req(SRpnt, (void *) cmd, bp, bytes,
 		    st_sleep_done, timeout, retries);
 
 	if (do_wait) {
-		wait_for_completion(SRpnt->sr_request->waiting);
+		wait_for_completion(waiting);
 		SRpnt->sr_request->waiting = NULL;
+		if (SRpnt->sr_request->rq_status != RQ_SCSI_DONE)
+			SRpnt->sr_result |= (DRIVER_ERROR << 24);
 		(STp->buffer)->syscall_result = st_chk_result(STp, SRpnt);
 	}
 	return SRpnt;
@@ -465,6 +532,7 @@ static int write_behind_check(struct scs
 	struct st_buffer *STbuffer;
 	struct st_partstat *STps;
 	struct st_cmdstatus *cmdstatp;
+	struct scsi_request *SRpnt;
 
 	STbuffer = STp->buffer;
 	if (!STbuffer->writing)
@@ -478,10 +546,14 @@ static int write_behind_check(struct scs
         ) /* end DEB */
 
 	wait_for_completion(&(STp->wait));
-	(STp->buffer)->last_SRpnt->sr_request->waiting = NULL;
+	SRpnt = STbuffer->last_SRpnt;
+	STbuffer->last_SRpnt = NULL;
+	SRpnt->sr_request->waiting = NULL;
+	if (SRpnt->sr_request->rq_status != RQ_SCSI_DONE)
+		SRpnt->sr_result |= (DRIVER_ERROR << 24);
 
-	(STp->buffer)->syscall_result = st_chk_result(STp, (STp->buffer)->last_SRpnt);
-	scsi_release_request((STp->buffer)->last_SRpnt);
+	(STp->buffer)->syscall_result = st_chk_result(STp, SRpnt);
+	scsi_release_request(SRpnt);
 
 	STbuffer->buffer_bytes -= STbuffer->writing;
 	STps = &(STp->ps[STp->partition]);
@@ -1055,25 +1127,20 @@ static int st_open(struct inode *inode, 
 	 */
 	filp->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
 
+	if (!(STp = scsi_tape_get(dev)))
+		return -ENXIO;
+
 	write_lock(&st_dev_arr_lock);
-	if (dev >= st_dev_max || scsi_tapes == NULL ||
-	    ((STp = scsi_tapes[dev]) == NULL)) {
-		write_unlock(&st_dev_arr_lock);
-		return (-ENXIO);
-	}
 	filp->private_data = STp;
 	name = tape_name(STp);
 
 	if (STp->in_use) {
 		write_unlock(&st_dev_arr_lock);
+		scsi_tape_put(STp);
 		DEB( printk(ST_DEB_MSG "%s: Device already in use.\n", name); )
 		return (-EBUSY);
 	}
 
-	if(scsi_device_get(STp->device)) {
-		write_unlock(&st_dev_arr_lock);
-		return (-ENXIO);
-	}
 	STp->in_use = 1;
 	write_unlock(&st_dev_arr_lock);
 	STp->rew_at_close = STp->autorew_dev = (iminor(inode) & 0x80) == 0;
@@ -1118,7 +1185,7 @@ static int st_open(struct inode *inode, 
  err_out:
 	normalize_buffer(STp->buffer);
 	STp->in_use = 0;
-	scsi_device_put(STp->device);
+	scsi_tape_put(STp);
 	return retval;
 
 }
@@ -1250,7 +1317,7 @@ static int st_release(struct inode *inod
 	write_lock(&st_dev_arr_lock);
 	STp->in_use = 0;
 	write_unlock(&st_dev_arr_lock);
-	scsi_device_put(STp->device);
+	scsi_tape_put(STp);
 
 	return result;
 }
@@ -3887,6 +3954,7 @@ static int st_probe(struct device *dev)
 		goto out_put_disk;
 	}
 	memset(tpnt, 0, sizeof(struct scsi_tape));
+	kref_init(&tpnt->kref);
 	tpnt->disk = disk;
 	sprintf(disk->disk_name, "st%d", i);
 	disk->private_data = &tpnt->driver;
@@ -3902,6 +3970,7 @@ static int st_probe(struct device *dev)
 		tpnt->tape_type = MT_ISSCSI2;
 
 	tpnt->buffer = buffer;
+	tpnt->buffer->last_SRpnt = NULL;
 
 	tpnt->inited = 0;
 	tpnt->dirty = 0;
@@ -4076,15 +4145,10 @@ static int st_remove(struct device *dev)
 					tpnt->modes[mode].cdevs[j] = NULL;
 				}
 			}
-			tpnt->device = NULL;
 
-			if (tpnt->buffer) {
-				tpnt->buffer->orig_frp_segs = 0;
-				normalize_buffer(tpnt->buffer);
-				kfree(tpnt->buffer);
-			}
-			put_disk(tpnt->disk);
-			kfree(tpnt);
+			down(&st_ref_sem);
+			kref_put(&tpnt->kref, scsi_tape_release);
+			up(&st_ref_sem);
 			return 0;
 		}
 	}
@@ -4093,6 +4157,34 @@ static int st_remove(struct device *dev)
 	return 0;
 }
 
+/**
+ *      scsi_tape_release - Called to free the Scsi_Tape structure
+ *      @kref: pointer to embedded kref
+ *
+ *      st_ref_sem must be held entering this routine.  Because it is
+ *      called on last put, you should always use the scsi_tape_get()
+ *      scsi_tape_put() helpers which manipulate the semaphore directly
+ *      and never do a direct kref_put().
+ **/
+static void scsi_tape_release(struct kref *kref)
+{
+	struct scsi_tape *tpnt = to_scsi_tape(kref);
+	struct gendisk *disk = tpnt->disk;
+
+	tpnt->device = NULL;
+
+	if (tpnt->buffer) {
+		tpnt->buffer->orig_frp_segs = 0;
+		normalize_buffer(tpnt->buffer);
+		kfree(tpnt->buffer);
+	}
+
+	disk->private_data = NULL;
+	put_disk(disk);
+	kfree(tpnt);
+	return;
+}
+
 static void st_intr(struct scsi_cmnd *SCpnt)
 {
 	scsi_io_completion(SCpnt, (SCpnt->result ? 0: SCpnt->bufflen), 1);
--- linux-2.6.13-rc5-k1/drivers/scsi/st.h	2005-06-18 09:44:25.000000000 +0300
+++ linux-2.6.13-rc5-k2/drivers/scsi/st.h	2005-08-02 12:31:23.000000000 +0300
@@ -3,7 +3,7 @@
 #define _ST_H
 
 #include <linux/completion.h>
-
+#include <linux/kref.h>
 
 /* Descriptor for analyzed sense data */
 struct st_cmdstatus {
@@ -156,6 +156,7 @@ struct scsi_tape {
 	unsigned char last_sense[16];
 #endif
 	struct gendisk *disk;
+	struct kref     kref;
 };
 
 /* Bit masks for use_pf */
