From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [Drbd-dev] [PATCH 23/27] drbd: make intelligent use
 of blkdev_issue_zeroout
Date: Mon, 15 Jan 2018 13:46:35 +0100
Message-ID: <20180115124635.GA4107@soda.linbit>
References: <20170405172125.22600-1-hch@lst.de>
	<20170405172125.22600-24-hch@lst.de>
	<alpine.LRH.2.11.1801130035010.13147@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1801130035010.13147@mail.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <drbd-dev@lists.ewheeler.net>
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, martin.petersen@oracle.com, snitzer@redhat.com, philipp.reisner@linbit.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, shli@kernel.org, Christoph Hellwig <hch@lst.de>, agk@redhat.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 13, 2018 at 12:46:40AM +0000, Eric Wheeler wrote:
> Hello All,
> =

> We just noticed that discards to DRBD devices backed by dm-thin devices =

> are fully allocating the thin blocks.
> =

> This behavior does not exist before =

> ee472d83 block: add a flags argument to (__)blkdev_issue_zeroout
> =

> The problem exists somewhere between
> [working] c20cfc27 block: stop using blkdev_issue_write_same for zeroing
>   and
> [broken]  45c21793 drbd: implement REQ_OP_WRITE_ZEROES
> =

> Note that c20cfc27 works as expected, but 45c21793 discards blocks =

> being zeroed on the dm-thin backing device. All commits between those two =

> produce the following error:
> =

> blkdiscard: /dev/drbd/by-res/test: BLKDISCARD ioctl failed: Input/output =
error
> =

> Also note that issuing a blkdiscard to the backing device directly =

> discards as you would expect. This is just a problem when sending discard=
s =

> through DRBD.
> =

> Is there an easy way to solve this in the short term, even if the ultimat=
e =

> fix is more involved?

> On Wed, 5 Apr 2017, Christoph Hellwig wrote:
> =


commit 0dbed96a3cc9786bc4814dab98a7218753bde934
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Apr 5 19:21:21 2017 +0200

    drbd: make intelligent use of blkdev_issue_zeroout

> > drbd always wants its discard wire operations to zero the blocks, so
> > use blkdev_issue_zeroout with the BLKDEV_ZERO_UNMAP flag instead of
> > reinventing it poorly.

> > -/*
> > - * We *may* ignore the discard-zeroes-data setting, if so configured.
> > - *
> > - * Assumption is that it "discard_zeroes_data=3D0" is only because the=
 backend
> > - * may ignore partial unaligned discards.
> > - *
> > - * LVM/DM thin as of at least
> > - *   LVM version:     2.02.115(2)-RHEL7 (2015-01-28)
> > - *   Library version: 1.02.93-RHEL7 (2015-01-28)
> > - *   Driver version:  4.29.0
> > - * still behaves this way.
> > - *
> > - * For unaligned (wrt. alignment and granularity) or too small discard=
s,
> > - * we zero-out the initial (and/or) trailing unaligned partial chunks,
> > - * but discard all the aligned full chunks.
> > - *
> > - * At least for LVM/DM thin, the result is effectively "discard_zeroes=
_data=3D1".
> > - */
> > -int drbd_issue_discard_or_zero_out(struct drbd_device *device, sector_=
t start, unsigned int nr_sectors, bool discard)


As I understood it,
blkdev_issue_zeroout() was supposed to "always try to unmap",
deprovision, the relevant region, and zero-out any unaligned
head or tail, just like my work around above was doing.

And that device mapper thin was "about to" learn this, "soon",
or maybe block core would do the equivalent of my workaround
described above.

But it then did not.

See also:
https://www.redhat.com/archives/dm-devel/2017-March/msg00213.html
https://www.redhat.com/archives/dm-devel/2017-March/msg00226.html

I then did not follow this closely enough anymore,
and I missed that with recent enough kernel,
discard on DRBD on dm-thin would fully allocate.

In our out-of-tree module, we had to keep the older code for
compat reasons, anyways. I will just re-enable our zeroout
workaround there again.

In tree, either dm-thin learns to do REQ_OP_WRITE_ZEROES "properly",
so the result in this scenario is what we expect:

  _: unprovisioned, not allocated, returns zero on read anyways
  *: provisioned, some arbitrary data
  0: explicitly zeroed:

  |gran|ular|ity |    |    |    |
  |****|****|____|****|
     to|-be-|zero|ed
  |**00|____|____|00**|

(leave unallocated blocks alone,
 de-allocate full blocks just like with discard,
 explicitly zero unaligned head and tail)

Or DRBD will have to resurrect that reinvented zeroout again,
with exactly those semantics. I did reinvent it for a reason ;)

-- =

: Lars Ellenberg
: LINBIT | Keeping the Digital World Running
: DRBD -- Heartbeat -- Corosync -- Pacemaker
: R&D, Integration, Ops, Consulting, Support

DRBD=AE and LINBIT=AE are registered trademarks of LINBIT
