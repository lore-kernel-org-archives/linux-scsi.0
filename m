From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Boot failure with block/for-next
Date: Thu, 23 Dec 2010 12:25:17 -0600
Message-ID: <1293128717.7776.68.camel@mulgrave.site>
References: <1293038823.3019.89.camel@mulgrave.site>
	 <1293078673.3019.765.camel@mulgrave.site>
	 <20101223100956.GA15625@htj.dyndns.org>
	 <1293118041.3029.3.camel@mulgrave.site>
	 <20101223155239.GB18482@htj.dyndns.org>
	 <1293120614.7776.0.camel@mulgrave.site>
	 <20101223161312.GC18482@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101223161312.GC18482@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-12-23 at 17:13 +0100, Tejun Heo wrote:
> On Thu, Dec 23, 2010 at 10:10:14AM -0600, James Bottomley wrote:
> > > Can you please apply the debug patch I posted in the other message and
> > > post the boot log?  Let's see how the partition read is failing.
> > 
> > That's actually a red herring ... the disk isn't spinning up, so the
> > partition read is getting a not ready.
> 
> Oh, yay, but at any rate I think the don't-clear-media-presence patch
> is probably a good idea just in case UA gets reported somehow.

Well, it wasn't this either.  It turns out that this disk alone reports
UNIT_ATTENTION RESET_OCCURRED on the first TEST UNIT READY of spin up.
Ordinarily this is harmless, but the new medium change code wrongly
interprets any UNIT_ATTENTION as medium changed (and then refuses to
talk to the disk).  This is actually a change from the previous code, so
the fix is to put it back the way it was.

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6a88fc1..7d25746 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1008,8 +1008,6 @@ static int media_not_present(struct scsi_disk *sdkp,
 	/* not invoked for commands that could return deferred errors */
 	switch (sshdr->sense_key) {
 	case UNIT_ATTENTION:
-		sdkp->device->changed = 1;
-		/* fall through */
 	case NOT_READY:
 		/* medium not present */
 		if (sshdr->asc == 0x3A) {
