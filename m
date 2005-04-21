From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Re: fastfail operation and retries
Date: Thu, 21 Apr 2005 15:13:16 -0700
Message-ID: <20050421221316.GA21963@us.ibm.com>
References: <20050419171953.GA8444@lion28.boeblingen.de.ibm.com>
	<20050421164205.GA20482@us.ibm.com>
	<20050421195435.GP17315@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050421195435.GP17315@marowsky-bree.de>
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

On Thu, Apr 21, 2005 at 09:54:35PM +0200, Lars Marowsky-Bree wrote:

> > We need a patch like Mike Christie had, this:
> > 
> > http://marc.theaimsgroup.com/?l=linux-kernel&m=107961883914541&w=2
> > 
> > The scsi core should decode the sense data and pass up the result, then dm
> > need not decode sense data, and we don't need sense data passed around via
> > the block layer.
> 
> The most recent udm patchset has a patch by Jens Axboe and myself to
> pass up sense data / error codes in the bio so the dm mpath module can
> deal with it.  

But the scmd->result is not passed back.

If we passed it back there would be enough information available, but then
you still need to add the same decoding as already found in scsi core
(scsi_decide_disposition and more).

Better to decode the error once, and then pass that data back to the
blk layer.

> Only issue still is that the SCSI midlayer does only generate a single
> "EIO" code also for timeouts; however, that pretty much means it's a
> transport error, because if it was a media error, we'd be getting sense
> data ;-)

How does lack of sense data imply that there was no media/device error? A
timeout could be a failure anywhere, in the transport or because of
target/media/LUN problems. Or not a real error at all, just a busy device
or too short a timeout setting.

Currently scsi core does not fastfail time outs ...

Does path checker take paths permanently offline after multiple failures?

If a timeout causes a path failure (means today that scsi core already
retried the command), and path checker re-enables the path (for example,
path checker can send a test unit ready with no failure; this also means
scsi core has already retried the command), this could lead to retrying
that IO (or even another IO) and hitting a timeout again on that path.

Also a SCSI failure (command made it to the media/device, but got some
error) can happen without sense data, like any SCSI errors other than
a CHECK_CONDITION that are not requeued by scsi core (see
scsi_decide_disposition switch cases for status_byte(scmd->result)).

It's probably OK to just fail the path for all driver/transport errors
(and non-sense errors) even if they are retryable: path checker will just
re-enable the path (maybe immediately). But, we end up with different and
potentially significant behaviour for some error cases with/without fastfail.

So though I don't like the approach: distinguishing timeouts or ensuring
that path checker won't continually reenable a path might be good enough,
as long as there are no other error cases (driver or SCSI) that could lead
to long lasting failures.

> > scsi core could be changed to handle device specific decoding via sense
> > tables that can be modified via sysfs, similar to devinfo code (well,
> > devinfo still lacks a sysfs interface).
> 
> dm-path's capabilities go a bit beyond just the error decoding (which
> for generic devices is also provided for in a generic
> dm_scsi_err_handler()); for example you can code special initialization
> commands and behaviour an array might need.

Yes, but that doesn't mean we should decode SCSI sense or scsi core error
errors (i.e. scmd->result) in dm space.

Also, non-scsi drivers would like to use dm multipath, like DASD. Using
extended blk errors allows simpler support for such devices and drivers.

-- Patrick Mansfield
