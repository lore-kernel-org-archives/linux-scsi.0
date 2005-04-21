From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Re: fastfail operation and retries
Date: Fri, 22 Apr 2005 00:52:56 +0200
Message-ID: <20050421225256.GB17315@marowsky-bree.de>
References: <20050419171953.GA8444@lion28.boeblingen.de.ibm.com>
	<20050421164205.GA20482@us.ibm.com>
	<20050421195435.GP17315@marowsky-bree.de>
	<20050421221316.GA21963@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050421221316.GA21963@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, Linux SCSI <linux-scsi@vger.kernel.org>, Andreas Herrmann <aherrman@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 2005-04-21T15:13:16, Patrick Mansfield <patmans@us.ibm.com> wrote:

> > The most recent udm patchset has a patch by Jens Axboe and myself to
> > pass up sense data / error codes in the bio so the dm mpath module ca=
n
> > deal with it. =20
> But the scmd->result is not passed back.

Bear with me and my limitted knowledge of the SCSI midlayer for a
second: What additional benefit would this provide over sense
key/asc/ascq & the error parameter in the bio end_io path?

> Better to decode the error once, and then pass that data back to the
> blk layer.

Decoding is device specific. So is the handling of path initialization
and others. I'd rather have this consolidated in one module, than have
parts of it in the mid-layer and other parts in the multipath code.

Could this be handled by a module in the mid-layer which receives
commands from the DM multipath layers above, and pass appropriate flags
back up? Probably. (I think this is what you're suggesting.) But
frankly, I prefer the current approach, which works. I don't see a real
benefit in your architecture, besides spreading things out further.

> > Only issue still is that the SCSI midlayer does only generate a singl=
e
> > "EIO" code also for timeouts; however, that pretty much means it's a
> > transport error, because if it was a media error, we'd be getting sen=
se
> > data ;-)
> How does lack of sense data imply that there was no media/device error?

It does not always imply that. Note the "pretty much ... ;-)".

The one thing which could be improved here is that I'm not sure if an
EIO w/o sense data from the SCSI mid-layer always corresponds to a
timeout. Could we get EIO also for other errors?

However, as you correctly state later, it's pretty safe to treat such
errors as a "path error" and retry elsewhere, because if it was a false
failure, the path checker will reinstate soonish.

> timeout could be a failure anywhere, in the transport or because of
> target/media/LUN problems. Or not a real error at all, just a busy devi=
ce
> or too short a timeout setting.

Well, the not real errors might benefit from the IO being retried on
another path though.

> Does path checker take paths permanently offline after multiple failure=
s?

The path checker lives in user-space, and that's policy ;-) So, from the
kernel perspective, it doesn't matter. User-space currently does not
'permanently' fail paths, but it could be modified to do so if it goes
up/down at a too high rate, basically dampening for stability.  Patches
welcome.

> So though I don't like the approach: distinguishing timeouts or ensurin=
g
> that path checker won't continually reenable a path might be good enoug=
h,
> as long as there are no other error cases (driver or SCSI) that could l=
ead
> to long lasting failures.

That's essentially what is being done. However, there's some more
special cases (like a storage array telling us that that service
processor is no longer active and we should switch not to another path
on the same, but to the other SP; which we model in dm-mpath via
different priority groups and causing a PG switch), and some errors
translate to errors being immediately propagated upwards (media error,
illegal request, data protect and some others; again, this might include
specific handling based on the storage being addressed), because for
these retrying on another path (or switching service processors) doesn't
make any sense or might be even harmful.

> Yes, but that doesn't mean we should decode SCSI sense or scsi core err=
or
> errors (i.e. scmd->result) in dm space.

This happens in the SCSI layer; dm-mpath only sees already 'decoded'
sense key/asc/ascq.

> Also, non-scsi drivers would like to use dm multipath, like DASD. Using
> extended blk errors allows simpler support for such devices and drivers=
.

Sure. The bi_error field introduced by Axboe's patch has flags detailing
what kind of error information is available - it's either ERRNO
(basically, the current "error"), SENSE (for certain scsi requests,
where sense is available), and could be extended to include a DASD
class, and then be complemented by a dm-dasd module for hw-specific
handling for any other specific needs they might have.

Can you sketch/summarize your suggested design in more detail? That
would be helpful for me, because I missed parts of the earlier
discussion.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
