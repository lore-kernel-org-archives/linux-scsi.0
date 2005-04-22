From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Re: fastfail operation and retries
Date: Thu, 21 Apr 2005 17:22:29 -0700
Message-ID: <20050422002229.GA23031@us.ibm.com>
References: <20050419171953.GA8444@lion28.boeblingen.de.ibm.com>
	<20050421164205.GA20482@us.ibm.com>
	<20050421195435.GP17315@marowsky-bree.de>
	<20050421221316.GA21963@us.ibm.com>
	<20050421225256.GB17315@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050421225256.GB17315@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Linux SCSI <linux-scsi@vger.kernel.org>, Andreas Herrmann <aherrman@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 22, 2005 at 12:52:56AM +0200, Lars Marowsky-Bree wrote:
> On 2005-04-21T15:13:16, Patrick Mansfield <patmans@us.ibm.com> wrote:
> 
> > > The most recent udm patchset has a patch by Jens Axboe and myself to
> > > pass up sense data / error codes in the bio so the dm mpath module can
> > > deal with it.  
> > But the scmd->result is not passed back.
> 
> Bear with me and my limitted knowledge of the SCSI midlayer for a
> second: What additional benefit would this provide over sense
> key/asc/ascq & the error parameter in the bio end_io path?

So we can mark a path in dm as failed or not; then dm won't mark a path
failed for driver, transport, or other retryable errors.

As noted, this might not lead to user visible affects, since retryable
errors _should_ end up failing and then re-enabling the path, but that
could lead to problems. But the code paths will be cleaner.

> > Better to decode the error once, and then pass that data back to the
> > blk layer.
> 
> Decoding is device specific. So is the handling of path initialization
> and others. I'd rather have this consolidated in one module, than have
> parts of it in the mid-layer and other parts in the multipath code.

Me too, but I'm arguing to decode them in scsi core.

> Could this be handled by a module in the mid-layer which receives
> commands from the DM multipath layers above, and pass appropriate flags
> back up? Probably. (I think this is what you're suggesting.) But
> frankly, I prefer the current approach, which works. I don't see a real
> benefit in your architecture, besides spreading things out further.

scsi core (I don't like calling it midlayer) could have a module or such.

The same decoding that is being put into dm hardware modules should
also be in scsi core. That is, when running such hardware without dm
multipath (single pathed or just stupidly) we still want the decoding of
the sense data, especially for retryable errors.

> The one thing which could be improved here is that I'm not sure if an
> EIO w/o sense data from the SCSI mid-layer always corresponds to a
> timeout. Could we get EIO also for other errors?

You should be getting EIO for all IO failures, timeout or not. For example
a cable pull returns DID_NO_CONNECT (for at least qlogic, and maybe for
emulex), its decoded in scsi_decide_disposition, and scsi core calls
scsi_end_request(x, 0, x, x), and then calls end_that_request_chunk(x, 0,
x) and that sets error to EIO.

> However, as you correctly state later, it's pretty safe to treat such
> errors as a "path error" and retry elsewhere, because if it was a false
> failure, the path checker will reinstate soonish.
> 
> > timeout could be a failure anywhere, in the transport or because of
> > target/media/LUN problems. Or not a real error at all, just a busy device
> > or too short a timeout setting.
> 
> Well, the not real errors might benefit from the IO being retried on
> another path though.

Yes.

> > Does path checker take paths permanently offline after multiple failures?
> 
> The path checker lives in user-space, and that's policy ;-) So, from the
> kernel perspective, it doesn't matter. User-space currently does not
> 'permanently' fail paths, but it could be modified to do so if it goes
> up/down at a too high rate, basically dampening for stability.  Patches
> welcome.
> 
> > So though I don't like the approach: distinguishing timeouts or ensuring
> > that path checker won't continually reenable a path might be good enough,
> > as long as there are no other error cases (driver or SCSI) that could lead
> > to long lasting failures.
> 
> That's essentially what is being done. However, there's some more
> special cases (like a storage array telling us that that service
> processor is no longer active and we should switch not to another path
> on the same, but to the other SP; which we model in dm-mpath via
> different priority groups and causing a PG switch), and some errors
> translate to errors being immediately propagated upwards (media error,
> illegal request, data protect and some others; again, this might include
> specific handling based on the storage being addressed), because for
> these retrying on another path (or switching service processors) doesn't
> make any sense or might be even harmful.

Yes ... I'm familiar with such hardware.

> > Yes, but that doesn't mean we should decode SCSI sense or scsi core error
> > errors (i.e. scmd->result) in dm space.
> 
> This happens in the SCSI layer; dm-mpath only sees already 'decoded'
> sense key/asc/ascq.

But that data is not decoded, dm has to look at the sense value etc. Some
of that must overlap with the code in scsi core.

> > Also, non-scsi drivers would like to use dm multipath, like DASD. Using
> > extended blk errors allows simpler support for such devices and drivers.
> 
> Sure. The bi_error field introduced by Axboe's patch has flags detailing
> what kind of error information is available - it's either ERRNO
> (basically, the current "error"), SENSE (for certain scsi requests,
> where sense is available), and could be extended to include a DASD
> class, and then be complemented by a dm-dasd module for hw-specific
> handling for any other specific needs they might have.
> 
> Can you sketch/summarize your suggested design in more detail? That
> would be helpful for me, because I missed parts of the earlier
> discussion.

I can try forward porting Mike C's patch ... what we need on top of the
bi_error is to pass back the bi_error when calling end_that_request_first,
instead of a boolean 0/1 for uptodate, pass a BIO_ERROR_xxx. And set
bio->bi_error and/or just pass it back in bio_endio().

The errors could be:
	
	BIO_SUCCESS = 0,
	BIO_ERROR_ERR,
	BIO_ERROR_RETRY,
	BIO_ERROR_DEV_FAILURE,
	BIO_ERROR_DEV_RETRY,
	BIO_ERROR_TRNSPT_FAILURE,
	BIO_ERROR_TRNSPT_RETRY,
	BIO_ERROR_TIMEOUT,

And maybe (for non-failure failover case, when an SP is no longer active)
a BIO_ERROR_TRNSPT_INACTIVE or ?.

These somewhat match Mike C's values, he had:

+	BLK_SUCCESS,
+	BLK_ERR,		/* Generic error like -EIO */
+	BLK_FATAL_DEV,		/* Fatal driver error */
+	BLK_FATAL_TRNSPT,	/* Fatal transport error */
+	BLK_FATAL_DRV,		/* Fatal driver error */
+	BLK_RETRY_DEV,		/* Device error, I/O may be retried */
+	BLK_RETRY_TRNSPT,	/* Transport error, I/O may retried */
+	BLK_RETRY_DRV,		/* Driver error, I/O may be retried */

AFICT, the only need for a _DRV as in Mike's patch was too handle the
-EWOULDBLOCK (can't find this in current source though ..), so we might
need only a BIO_ERROR_RETRY.

And then in dm:

	BIO_SUCCESS:		complete IO with no failure
	BIO_ERROR_RETRY: 	never makes it to dm
	BIO_ERROR_ERR:		treat as a failed IO
	BIO_ERROR_DEV_FAILURE:	failed IO
	BIO_ERROR_DEV_RETRY:	retry on any path
	BIO_ERROR_TRNSPT_FAILURE:	fail path
	BIO_ERROR_TRNSPT_RETRY:	retry on any path
	BIO_ERROR_TIMEOUT:	hard to handle, needs to retry on another
				path, but mark this path as potentially
				failing. For now, it could just fail the
				path (then we are in the same situation as
				today).
	BIO_ERROR_TRNSPT_INACTIVE:	failover ...

Non-dm users treat non BIO_SUCCESS results as IO failures (we should not
return retry errors unless fast fail is set).

"retry on any path" would normally use a different path if one is
available.

We still need a scsi vendor specific decoder, I'd volunteered to do that
work before but there were no responses last time I brought it up (on
linux-scsi).

-- Patrick Mansfield
