From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 1/2] SCSI tape fixes (new version): sense descriptor
 init, bsf->weof, blkno, debugging
Date: Tue, 15 Mar 2005 21:06:44 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0503152046250.6742@kai.makisara.local>
References: <Pine.LNX.4.61.0503121903010.6875@kai.makisara.local>
 <1110910469.5685.19.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:57953 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261787AbVCOTFZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2005 14:05:25 -0500
In-Reply-To: <1110910469.5685.19.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 15 Mar 2005, James Bottomley wrote:

> On Sat, 2005-03-12 at 19:04 +0200, Kai Makisara wrote:
> > This is an updated version of the patch I sent March 7. The sense descriptor
> > initialization has been made lighter.
> > 
> > The patch at the end of this message applies to 2.6.11-bk7 + st descriptor sense
> > patch + st auto eof patch (i.e., st patches currently in scsi-misc-2.6). The
> > patch fixes the following problems:
> 
> I'm afraid this doesn't apply.  It looks like I've got an interim patch
> that's crept in somewhere in the tree.
> 
> Could you take a look at scsi-misc-2.6 (or the patches on www.parisc-
> linux/~jejb/scsi_diffs) and see if you can construct a diff between
> where I currently am and where I should be?
> 
The changelog shows that the patch below is included. It is the previous 
version of the patch in the message with this subject.

# ChangeSet
#   2005/03/15 10:37:07-06:00 Kai.Makisara@kolumbus.fi 
#   [PATCH] SCSI tape fixes: sense descriptor init, bsf->weof, blkno,

The patch at the end of this message should take you into the point where 
you can directly apply 2/2 etc. (If you think that the patch below is not 
worth the trouble, you can skip that. The other patches are not touching 
verstr and should then apply with small offset.)

Thanks,
Kai

This patch changes the sense descriptor initialization a little faster.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.11-kk1/drivers/scsi/st.c	2005-03-15 20:55:12.000000000 +0200
+++ linux-2.6.11-bk7-k2/drivers/scsi/st.c	2005-03-12 13:52:30.000000000 +0200
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20050307";
+static char *verstr = "20050312";
 
 #include <linux/module.h>
 
@@ -268,10 +268,11 @@ static void st_analyze_sense(struct scsi
 	const u8 *ucp;
 	const u8 *sense = SRpnt->sr_sense_buffer;
 
-	memset(s, 0, sizeof(struct st_cmdstatus));
 	s->have_sense = scsi_request_normalize_sense(SRpnt, &s->sense_hdr);
+	s->flags = 0;
 
 	if (s->have_sense) {
+		s->deferred = 0;
 		s->remainder_valid =
 			scsi_get_sense_info_fld(sense, SCSI_SENSE_BUFFERSIZE, &s->uremainder64);
 		switch (sense[0] & 0x7f) {
