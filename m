From: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
Subject: [PATCH] message fix of st.c
Date: Wed, 31 Mar 2004 21:29:49 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <040801c4171c$4dd73890$2987110a@lsd.css.fujitsu.com>
Reply-To: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:17572 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S261930AbUCaMdY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 07:33:24 -0500
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi Kai,

st.c has some messages that does not tell us the error device.
This patch adds device name to such messages.
This is a patch for linux-2.6.5-rc3.

Please apply!

Thanks,
Hironobu Ishii.


diff -urN linux-2.6.5-rc3/drivers/scsi/st.c linux-2.6.5-rc3-work/drivers/scsi/st.c
--- linux-2.6.5-rc3/drivers/scsi/st.c 2004-03-30 19:02:47.000000000 +0900
+++ linux-2.6.5-rc3-work/drivers/scsi/st.c 2004-03-30 22:25:30.000000000 +0900
@@ -174,12 +174,12 @@
 static int modes_defined;
 
 static ST_buffer *new_tape_buffer(int, int, int);
-static int enlarge_buffer(ST_buffer *, int, int);
-static void normalize_buffer(ST_buffer *);
-static int append_to_buffer(const char *, ST_buffer *, int);
-static int from_buffer(ST_buffer *, char *, int);
-static void move_buffer_data(ST_buffer *, int);
-static void buf_to_sg(ST_buffer *, unsigned int);
+static int enlarge_buffer(Scsi_Tape *, int, int);
+static void normalize_buffer(Scsi_Tape *);
+static int append_to_buffer(const char *, Scsi_Tape *, int);
+static int from_buffer(Scsi_Tape *, char *, int);
+static void move_buffer_data(Scsi_Tape *, int);
+static void buf_to_sg(Scsi_Tape *, unsigned int);
 
 static int st_map_user_pages(struct scatterlist *, const unsigned int, 
         unsigned long, size_t, int, unsigned long);
@@ -408,7 +408,7 @@
  SRpnt->sr_use_sg = STp->buffer->do_dio || (bytes > (STp->buffer)->frp[0].length);
  if (SRpnt->sr_use_sg) {
   if (!STp->buffer->do_dio)
-   buf_to_sg(STp->buffer, bytes);
+   buf_to_sg(STp, bytes);
   SRpnt->sr_use_sg = (STp->buffer)->sg_segs;
   bp = (char *) &((STp->buffer)->sg[0]);
  } else
@@ -1030,7 +1030,7 @@
  }
 
  /* See that we have at least a one page buffer available */
- if (!enlarge_buffer(STp->buffer, PAGE_SIZE, STp->restr_dma)) {
+ if (!enlarge_buffer(STp, PAGE_SIZE, STp->restr_dma)) {
   printk(KERN_WARNING "%s: Can't allocate tape buffer.\n", name);
   retval = (-EOVERFLOW);
   goto err_out;
@@ -1061,7 +1061,7 @@
  return 0;
 
  err_out:
- normalize_buffer(STp->buffer);
+ normalize_buffer(STp);
  STp->in_use = 0;
  scsi_device_put(STp->device);
  return retval;
@@ -1192,7 +1192,7 @@
  if (STp->door_locked == ST_LOCKED_AUTO)
   do_door_lock(STp, 0);
 
- normalize_buffer(STp->buffer);
+ normalize_buffer(STp);
  write_lock(&st_dev_arr_lock);
  STp->in_use = 0;
  write_unlock(&st_dev_arr_lock);
@@ -1317,7 +1317,7 @@
   else
    bufsize = count;
   if (bufsize > STbp->buffer_size &&
-      !enlarge_buffer(STbp, bufsize, STp->restr_dma)) {
+      !enlarge_buffer(STp, bufsize, STp->restr_dma)) {
    retval = (-EOVERFLOW);
    goto out;
   }
@@ -1468,7 +1468,7 @@
      do_count = count;
    }
 
-   i = append_to_buffer(b_point, STbp, do_count);
+   i = append_to_buffer(b_point, STp, do_count);
    if (i) {
     retval = i;
     goto out;
@@ -1560,7 +1560,7 @@
         in fixed block mode without direct i/o) */
      if (!retry_eot && (SRpnt->sr_sense_buffer[0] & 1) == 0 &&
          (scode == NO_SENSE || scode == RECOVERED_ERROR)) {
-      move_buffer_data(STp->buffer, transfer - undone);
+      move_buffer_data(STp, transfer - undone);
       retry_eot = TRUE;
       if (STps->drv_block >= 0) {
        STps->drv_block += (transfer - undone) /
@@ -1909,7 +1909,7 @@
    transfer = STbp->buffer_bytes < count - total ?
        STbp->buffer_bytes : count - total;
    if (!do_dio) {
-    i = from_buffer(STbp, buf, transfer);
+    i = from_buffer(STp, buf, transfer);
     if (i) {
      retval = i;
      goto out;
@@ -2668,7 +2668,7 @@
    STp->block_size = arg & MT_ST_BLKSIZE_MASK;
    if (STp->block_size != 0) {
     if (old_block_size == 0)
-     normalize_buffer(STp->buffer);
+     normalize_buffer(STp);
     (STp->buffer)->buffer_blocks =
         (STp->buffer)->buffer_size / STp->block_size;
    }
@@ -3450,15 +3450,16 @@
 
 
 /* Try to allocate enough space in the tape buffer */
-static int enlarge_buffer(ST_buffer * STbuffer, int new_size, int need_dma)
+static int enlarge_buffer(Scsi_Tape *STp, int new_size, int need_dma)
 {
  int segs, nbr, max_segs, b_size, priority, order, got;
+ ST_buffer *STbuffer = STp->buffer ;
 
  if (new_size <= STbuffer->buffer_size)
   return TRUE;
 
  if (STbuffer->buffer_size <= PAGE_SIZE)
-  normalize_buffer(STbuffer);  /* Avoid extra segment */
+  normalize_buffer(STp);  /* Avoid extra segment */
 
  max_segs = STbuffer->use_sg;
  nbr = max_segs - STbuffer->frp_segs;
@@ -3482,10 +3483,10 @@
     order--;
     continue;
    }
-   printk(KERN_NOTICE "st: failed to enlarge buffer to %d bytes.\n",
-          new_size);
+   printk(KERN_NOTICE "%s: failed to enlarge buffer to %d bytes.\n",
+          tape_name(STp), new_size);
    DEB(STbuffer->buffer_size = got);
-   normalize_buffer(STbuffer);
+   normalize_buffer(STp);
    return FALSE;
   }
   STbuffer->frp[segs].length = b_size;
@@ -3496,16 +3497,17 @@
  }
  STbuffer->b_data = page_address(STbuffer->frp[0].page);
         DEBC(printk(ST_DEB_MSG
-                    "st: Succeeded to enlarge buffer at %p to %d bytes (segs %d->%d, %d).\n",
-                    STbuffer, got, STbuffer->orig_frp_segs, STbuffer->frp_segs, b_size));
+                    "%s: Succeeded to enlarge buffer at %p to %d bytes (segs %d->%d, %d).\n",
+                    tape_name(STp), STbuffer, got, STbuffer->orig_frp_segs, STbuffer->frp_segs, b_size));
 
  return TRUE;
 }
 
 
 /* Release the extra buffer */
-static void normalize_buffer(ST_buffer * STbuffer)
+static void normalize_buffer(Scsi_Tape *STp)
 {
+ ST_buffer *STbuffer = STp->buffer ;
  int i, order;
 
  for (i = STbuffer->orig_frp_segs; i < STbuffer->frp_segs; i++) {
@@ -3515,8 +3517,8 @@
  }
         DEB(
  if (debugging && STbuffer->orig_frp_segs < STbuffer->frp_segs)
-  printk(ST_DEB_MSG "st: Buffer at %p normalized to %d bytes (segs %d->%d).\n",
-         STbuffer, STbuffer->buffer_size, STbuffer->frp_segs, STbuffer->orig_frp_segs);
+  printk(ST_DEB_MSG "%s: Buffer at %p normalized to %d bytes (segs %d->%d).\n",
+         tape_name(STp), STbuffer, STbuffer->buffer_size, STbuffer->frp_segs, STbuffer->orig_frp_segs);
         ) /* end DEB */
  STbuffer->frp_segs = STbuffer->orig_frp_segs;
  STbuffer->frp_sg_current = 0;
@@ -3525,15 +3527,16 @@
 
 /* Move data from the user buffer to the tape buffer. Returns zero (success) or
    negative error code. */
-static int append_to_buffer(const char *ubp, ST_buffer * st_bp, int do_count)
+static int append_to_buffer(const char *ubp, Scsi_Tape *STp, int do_count)
 {
  int i, cnt, res, offset;
+ ST_buffer * st_bp = STp->buffer ;
 
  for (i = 0, offset = st_bp->buffer_bytes;
       i < st_bp->frp_segs && offset >= st_bp->frp[i].length; i++)
   offset -= st_bp->frp[i].length;
  if (i == st_bp->frp_segs) { /* Should never happen */
-  printk(KERN_WARNING "st: append_to_buffer offset overflow.\n");
+  printk(KERN_WARNING "%s: append_to_buffer offset overflow.\n", tape_name(STp));
   return (-EIO);
  }
  for (; i < st_bp->frp_segs && do_count > 0; i++) {
@@ -3548,8 +3551,8 @@
   offset = 0;
  }
  if (do_count) {  /* Should never happen */
-  printk(KERN_WARNING "st: append_to_buffer overflow (left %d).\n",
-         do_count);
+  printk(KERN_WARNING "%s: append_to_buffer overflow (left %d).\n",
+         tape_name(STp), do_count);
   return (-EIO);
  }
  return 0;
@@ -3558,15 +3561,16 @@
 
 /* Move data from the tape buffer to the user buffer. Returns zero (success) or
    negative error code. */
-static int from_buffer(ST_buffer * st_bp, char *ubp, int do_count)
+static int from_buffer(Scsi_Tape *STp, char *ubp, int do_count)
 {
  int i, cnt, res, offset;
+ ST_buffer * st_bp = STp->buffer ;
 
  for (i = 0, offset = st_bp->read_pointer;
       i < st_bp->frp_segs && offset >= st_bp->frp[i].length; i++)
   offset -= st_bp->frp[i].length;
  if (i == st_bp->frp_segs) { /* Should never happen */
-  printk(KERN_WARNING "st: from_buffer offset overflow.\n");
+  printk(KERN_WARNING "%s: from_buffer offset overflow.\n", tape_name(STp));
   return (-EIO);
  }
  for (; i < st_bp->frp_segs && do_count > 0; i++) {
@@ -3582,8 +3586,8 @@
   offset = 0;
  }
  if (do_count) {  /* Should never happen */
-  printk(KERN_WARNING "st: from_buffer overflow (left %d).\n",
-         do_count);
+  printk(KERN_WARNING "%s: from_buffer overflow (left %d).\n",
+         tape_name(STp), do_count);
   return (-EIO);
  }
  return 0;
@@ -3591,10 +3595,11 @@
 
 
 /* Move data towards start of buffer */
-static void move_buffer_data(ST_buffer * st_bp, int offset)
+static void move_buffer_data(Scsi_Tape *STp, int offset)
 {
  int src_seg, dst_seg, src_offset = 0, dst_offset;
  int count, total;
+ ST_buffer * st_bp = STp->buffer ;
 
  if (offset == 0)
   return;
@@ -3607,7 +3612,7 @@
   offset -= st_bp->frp[src_seg].length;
  }
  if (src_seg == st_bp->frp_segs) { /* Should never happen */
-  printk(KERN_WARNING "st: move_buffer offset overflow.\n");
+  printk(KERN_WARNING "%s: move_buffer offset overflow.\n", tape_name(STp));
   return;
  }
 
@@ -3633,12 +3638,13 @@
 
 
 /* Fill the s/g list up to the length required for this transfer */
-static void buf_to_sg(ST_buffer *STbp, unsigned int length)
+static void buf_to_sg(Scsi_Tape *STp, unsigned int length)
 {
  int i;
  unsigned int count;
  struct scatterlist *sg;
  struct st_buf_fragment *frp;
+ ST_buffer *STbp = STp->buffer ;
 
  if (length == STbp->frp_sg_current)
   return;   /* work already done */
@@ -4001,7 +4007,7 @@
 
    if (tpnt->buffer) {
     tpnt->buffer->orig_frp_segs = 0;
-    normalize_buffer(tpnt->buffer);
+    normalize_buffer(tpnt);
     kfree(tpnt->buffer);
    }
    put_disk(tpnt->disk);

