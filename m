From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bugme-new] [Bug 7919] New: Tape dies if wrong block size used
Date: Sat, 3 Feb 2007 13:21:29 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0702031307480.6410@kai.makisara.local>
References: <200702012334.l11NYTWu010618@fire-2.osdl.org>
 <20070201160858.ef28f354.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:55067 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946453AbXBCLSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2007 06:18:51 -0500
In-Reply-To: <20070201160858.ef28f354.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, dmartin@sccd.ctc.edu

On Thu, 1 Feb 2007, Andrew Morton wrote:

> On Thu, 1 Feb 2007 15:34:29 -0800
> bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=7919
> > 
> >            Summary: Tape dies if wrong block size used
> >     Kernel Version: 2.6.20-rc5
> >             Status: NEW
> >           Severity: normal
> >              Owner: scsi_drivers-other@kernel-bugs.osdl.org
> >          Submitter: dmartin@sccd.ctc.edu
> > 
> > 
> > Most recent kernel where this bug did *NOT* occur: 2.6.17.14
> > 
> > Other Kernels Tested and Results:
> > 
> >     OK 2.6.15.7
> >     OK 2.6.16.37 
> >     OK 2.6.17.14 
> >     BAD 2.6.18.6
> >     BAD 2.6.18-1.2869.fc6
> >     BAD 2.6.19.2 +
> >     BAD 2.6.20-rc5
> > 
> > NOTE: 2.6.18-1.2869.fc6 is a Fedora modified kernel, all others are from kernel.org
> > 
...
> > Steps to reproduce: 
> > Get a Adaptec AHA-2940U/UW/D / AIC-7881U card and a tape drive,
> > install a recent kernel
> > set the tape block size - mt setblk 4096
> > read from or write to tape using wrong block size - tar -b 7 -cvf /dev/tape foo
> >
Write does not trigger this bug because the driver refuses in fixed block 
mode writes that are not a multiple of the block size. Read does trigger 
it in my system.

The bug is not associated with any specific HBA. st tries to do direct i/o 
in fixed block mode with reads that are not a multiple of tape block size. 

The patch in this message fixes the st problem by switching to using the 
driver buffer up to the next close of the device file in fixed block mode 
if the user asks for a read like this.

I don't know why the bug has surfaced only after 2.6.17 although the st 
problem is old. There may be another bug in the block subsystem and this 
patch works around it. However, the patch fixes a problem in st and in 
this way it is a valid fix.

This patch may also fix the bug 7900.

The patch compiles and is lightly tested.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6/drivers/scsi/st.c	2006-12-09 13:29:31.000000000 +0200
+++ linux-2.6.20-rc7-km/drivers/scsi/st.c	2007-02-03 12:52:05.000000000 +0200
@@ -9,7 +9,7 @@
    Steve Hirsch, Andreas Koppenh"ofer, Michael Leodolter, Eyal Lebedinsky,
    Michael Schaefer, J"org Weule, and Eric Youngdale.
 
-   Copyright 1992 - 2006 Kai Makisara
+   Copyright 1992 - 2007 Kai Makisara
    email Kai.Makisara@kolumbus.fi
 
    Some small formal changes - aeb, 950809
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static const char *verstr = "20061107";
+static const char *verstr = "20070203";
 
 #include <linux/module.h>
 
@@ -1168,6 +1168,7 @@ static int st_open(struct inode *inode, 
 		STps = &(STp->ps[i]);
 		STps->rw = ST_IDLE;
 	}
+	STp->try_dio_now = STp->try_dio;
 	STp->recover_count = 0;
 	DEB( STp->nbr_waits = STp->nbr_finished = 0;
 	     STp->nbr_requests = STp->nbr_dio = STp->nbr_pages = STp->nbr_combinable = 0; )
@@ -1400,9 +1401,9 @@ static int setup_buffering(struct scsi_t
 	struct st_buffer *STbp = STp->buffer;
 
 	if (is_read)
-		i = STp->try_dio && try_rdio;
+		i = STp->try_dio_now && try_rdio;
 	else
-		i = STp->try_dio && try_wdio;
+		i = STp->try_dio_now && try_wdio;
 
 	if (i && ((unsigned long)buf & queue_dma_alignment(
 					STp->device->request_queue)) == 0) {
@@ -1599,7 +1600,7 @@ st_write(struct file *filp, const char _
 			STm->do_async_writes && STps->eof < ST_EOM_OK;
 
 		if (STp->block_size != 0 && STm->do_buffer_writes &&
-		    !(STp->try_dio && try_wdio) && STps->eof < ST_EOM_OK &&
+		    !(STp->try_dio_now && try_wdio) && STps->eof < ST_EOM_OK &&
 		    STbp->buffer_bytes < STbp->buffer_size) {
 			STp->dirty = 1;
 			/* Don't write a buffer that is not full enough. */
@@ -1769,7 +1770,7 @@ static long read_tape(struct scsi_tape *
 	if (STp->block_size == 0)
 		blks = bytes = count;
 	else {
-		if (!(STp->try_dio && try_rdio) && STm->do_read_ahead) {
+		if (!(STp->try_dio_now && try_rdio) && STm->do_read_ahead) {
 			blks = (STp->buffer)->buffer_blocks;
 			bytes = blks * STp->block_size;
 		} else {
@@ -1948,10 +1949,12 @@ st_read(struct file *filp, char __user *
 		goto out;
 
 	STm = &(STp->modes[STp->current_mode]);
-	if (!(STm->do_read_ahead) && STp->block_size != 0 &&
-	    (count % STp->block_size) != 0) {
-		retval = (-EINVAL);	/* Read must be integral number of blocks */
-		goto out;
+	if (STp->block_size != 0 && (count % STp->block_size) != 0) {
+		if (!STm->do_read_ahead) {
+			retval = (-EINVAL);	/* Read must be integral number of blocks */
+			goto out;
+		}
+		STp->try_dio_now = 0;  /* Direct i/o can't handle split blocks */
 	}
 
 	STps = &(STp->ps[STp->partition]);
--- linux-2.6/drivers/scsi/st.h	2006-08-31 19:11:40.000000000 +0300
+++ linux-2.6.20-rc7-km/drivers/scsi/st.h	2007-02-03 12:53:24.000000000 +0200
@@ -117,7 +117,8 @@ struct scsi_tape {
 	unsigned char cln_sense_value;
 	unsigned char cln_sense_mask;
 	unsigned char use_pf;			/* Set Page Format bit in all mode selects? */
-	unsigned char try_dio;			/* try direct i/o? */
+	unsigned char try_dio;			/* try direct i/o in general? */
+	unsigned char try_dio_now;		/* try direct i/o before next close? */
 	unsigned char c_algo;			/* compression algorithm */
 	unsigned char pos_unknown;			/* after reset position unknown */
 	int tape_type;
