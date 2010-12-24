From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Boot failure with block/for-next
Date: Fri, 24 Dec 2010 09:47:58 -0600
Message-ID: <1293205678.2987.37.camel@mulgrave.site>
References: <1293038823.3019.89.camel@mulgrave.site>
	 <1293078673.3019.765.camel@mulgrave.site>
	 <20101223100956.GA15625@htj.dyndns.org>
	 <1293118041.3029.3.camel@mulgrave.site>
	 <20101223155239.GB18482@htj.dyndns.org>
	 <1293120614.7776.0.camel@mulgrave.site>
	 <20101223161312.GC18482@htj.dyndns.org>
	 <1293128717.7776.68.camel@mulgrave.site>
	 <20101224110327.GB8781@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101224110327.GB8781@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-12-24 at 12:03 +0100, Tejun Heo wrote:
> Hello, James.
> 
> On Thu, Dec 23, 2010 at 12:25:17PM -0600, James Bottomley wrote:
> > On Thu, 2010-12-23 at 17:13 +0100, Tejun Heo wrote:
> > > On Thu, Dec 23, 2010 at 10:10:14AM -0600, James Bottomley wrote:
> > > > > Can you please apply the debug patch I posted in the other message and
> > > > > post the boot log?  Let's see how the partition read is failing.
> > > > 
> > > > That's actually a red herring ... the disk isn't spinning up, so the
> > > > partition read is getting a not ready.
> > > 
> > > Oh, yay, but at any rate I think the don't-clear-media-presence patch
> > > is probably a good idea just in case UA gets reported somehow.
> > 
> > Well, it wasn't this either.  It turns out that this disk alone reports
> > UNIT_ATTENTION RESET_OCCURRED on the first TEST UNIT READY of spin up.
> > Ordinarily this is harmless, but the new medium change code wrongly
> > interprets any UNIT_ATTENTION as medium changed (and then refuses to
> > talk to the disk).  This is actually a change from the previous code, so
> > the fix is to put it back the way it was.
> 
> I see.  I wonder why the previous patch didn't work.

Oh, you didn't put a ->removable check in enough paths.  The setting on
UA was still unconditional, as was the check in sd_prep_fn().

>   It should have
> had about the same effect.  I think the UA change went in there while
> trying to bring sr and sd behaviors closer to each other, but yes it
> seems the original code didn't have that.  That said, now there are
> paths where UA would be consumed without setting ->changed and thus sd
> may miss media change events.  This has been like this for quite some
> time and there aren't many removable sd devices these days, so maybe
> this doesn't matter too much.

The code can never really be merged.  for CD/DVD, UA pretty much does
mean medium removal.  Discs and arrays emit a panoply of UA events (it's
the SCSI asynchronous event mechanism) if you assume media change on all
of them, there'll be terrible confusion.  We can narrow to 28/00 that
means medium may have changed.  It could really do with checking by
someone who has a removable disc device, though ... it looks like some
of the 3B/xx might be applicable.

> Anyways, for now, the change looks good to me too.  Thanks.

Thanks,

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7d25746..1995533 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -578,7 +578,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		goto out;
 	}
 
-	if (sdp->changed) {
+	if (sdp->removable && sdp->changed) {
 		/*
 		 * quietly refuse to do anything to a changed disc until 
 		 * the changed bit has been reset
@@ -1008,6 +1008,9 @@ static int media_not_present(struct scsi_disk *sdkp,
 	/* not invoked for commands that could return deferred errors */
 	switch (sshdr->sense_key) {
 	case UNIT_ATTENTION:
+		if (sdkp->device->removable && sshdr->asc == 0x28 &&
+		    sshdr->ascq == 0x00)
+			sdkp->device->changed = 1;
 	case NOT_READY:
 		/* medium not present */
 		if (sshdr->asc == 0x3A) {
