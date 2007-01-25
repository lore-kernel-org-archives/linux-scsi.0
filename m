From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bugme-new] [Bug 7864] New: A MTIOCTOP/MTWEOF within the early
 warning will cause the file number to be incorrect
Date: Fri, 26 Jan 2007 00:38:39 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0701260024280.5146@kai.makisara.local>
References: <200701222107.l0ML7KPn010266@fire-2.osdl.org>
 <20070124204804.77486468.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:47040 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030352AbXAYXEJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jan 2007 18:04:09 -0500
In-Reply-To: <20070124204804.77486468.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: ce_reisinger@yahoo.com, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, linux-scsi@vger.kernel.org

On Wed, 24 Jan 2007, Andrew Morton wrote:

> On Mon, 22 Jan 2007 13:07:20 -0800
> bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=7864
> > 
> >            Summary: A MTIOCTOP/MTWEOF within the early warning will cause
> >                     the file number to be incorrect
> >     Kernel Version: 2.6.19.2
> >             Status: NEW
> >           Severity: low
> >              Owner: io_scsi@kernel-bugs.osdl.org
> >          Submitter: ce_reisinger@yahoo.com
> > 
> > 
> > Write records to a SCSI tape until a write fails with a ENOSPC (you have reached
> > early warning.
> > Now perform a:
> >    struct mtget before, after;
> >    ioctl(fd, MTIOCGET, &before);
> >    struct mtop mtop = { MTWEOF, 1 };
> >    ioctl(fd, MTIOCTOP, &mtop);
> >    ioctl(fd, MTIOCGET, &after);
> > 
> > Check the value of mt_fileno in the before and after structures. Notice the
> > after is 2 greater then the before.
> > 
> > The problem appears to be in the block of code starting at line 2817 in st.c.
> > This block is entered because the drive did return a CHECK CONDITION with NO
> > SENSE and the SENSE_EOM bit set. At lines 2824/5 the fileno is incremented. But
> > it has already been increased by the number of filemarks requested by the
> > MTIOCTOP. I believe that the residue count in the sense data should be
> > subtracted from fileno, not a increment as is done.
> > 
> 
> Thanks.  Could you please send us a tested patch to fix these things, as
> per http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt ?
> 
The analysis is basically correct and explains the bug. According to the 
SCSI standards, the sense code is NO SENSE or RECOVERED ERROR in case 
writing filemark(s) succeeds. If it fails (partly or completely) the sense 
code is VOLUME OVERFLOW. The patch below is tested to fix the case when 
one filemark is successfully written after the EOM early warning. It 
should also fix the case at real EOM but this has not been tested.

Carl, thanks for reporting the bug and providing the analysis for the fix.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6/drivers/scsi/st.c	2006-12-09 13:29:31.000000000 +0200
+++ linux-2.6.20-rc6-km/drivers/scsi/st.c	2007-01-25 22:51:35.000000000 +0200
@@ -2816,15 +2816,18 @@ static int st_int_ioctl(struct scsi_tape
 
 		if (cmd_in == MTWEOF &&
 		    cmdstatp->have_sense &&
-		    (cmdstatp->flags & SENSE_EOM) &&
-		    (cmdstatp->sense_hdr.sense_key == NO_SENSE ||
-		     cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) &&
-		    undone == 0) {
-			ioctl_result = 0;	/* EOF written successfully at EOM */
-			if (fileno >= 0)
-				fileno++;
+		    (cmdstatp->flags & SENSE_EOM)) {
+			if (cmdstatp->sense_hdr.sense_key == NO_SENSE ||
+			    cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) {
+				ioctl_result = 0;	/* EOF(s) written successfully at EOM */
+				STps->eof = ST_NOEOF;
+			} else {  /* Writing EOF(s) failed */
+				if (fileno >= 0)
+					fileno -= undone;
+				if (undone < arg)
+					STps->eof = ST_NOEOF;
+			}
 			STps->drv_file = fileno;
-			STps->eof = ST_NOEOF;
 		} else if ((cmd_in == MTFSF) || (cmd_in == MTFSFM)) {
 			if (fileno >= 0)
 				STps->drv_file = fileno - undone;
