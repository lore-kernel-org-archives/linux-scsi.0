From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 25/27] block: remove the discard_zeroes_data
	flag
Date: Mon, 08 May 2017 23:46:14 -0700
Message-ID: <1494312374.16894.36.camel@haakon3.risingtidesystems.com>
References: <20170405172125.22600-1-hch@lst.de>
	<20170405172125.22600-26-hch@lst.de>
	<1493671519.2665.15.camel@sandisk.com>
	<1493707425.23202.77.camel@haakon3.risingtidesystems.com>
	<1493709373.23202.79.camel@haakon3.risingtidesystems.com>
	<20170502072328.GA11522@lst.de>
	<1493782395.23202.84.camel@haakon3.risingtidesystems.com>
	<20170507092209.GA27370@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20170507092209.GA27370-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org" <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org" <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2017-05-07 at 11:22 +0200, hch-jcswGhMUV9g@public.gmane.org wrote:
> On Tue, May 02, 2017 at 08:33:15PM -0700, Nicholas A. Bellinger wrote:
> > The larger target/iblock conversion patch looks like post v4.12 material
> > at this point, so to avoid breakage wrt to existing LBPRZ behavior, I'll
> > plan to push the following patch post -rc1.
> 
> I don't think this is safe.  If you want to do the aboe you also
> need to ensure ->execute_unmap always zeroes the data.  For actual
> files in the file backend we should be all fine, but for the block
> device case [1] and iblock we'd need to use blkdev_issue_zeroout
> instead of blkdev_issue_discard when unmap_zeroes_data is set.
> 
> [1] which btw already seems broken as it doesn't invalidate cached
> data when issuing a discard.

Mmm, for [1] that would appear to be true, but after a deeper look at
existing code I don't think this is the case.

The reason being is target backend attributes emulate_tpu and
emulate_tpws are strictly user configurable, and aren't automatically
set based upon the underlying IBLOCK block_device support for either
one.

According to pre v4.12-rc1 code, q->limits.discard_zeroes_data was only
enabled by drivers/scsi/sd.c:sd_config_discard() for
sdkp->provisioning_mode WRITE_SAME with LBPRZ = 1 or explicit ZERO, and
for NVME for devices that supported NVME_QUIRK_DISCARD_ZEROES.  Eg: Only
real DISCARD + ZERO support.

In your changes to v4.12-rc1, this logic to signal real DISCARD + zero
support for SCSI and NVMe via q->limits.max_write_zeroes_sectors has not
changed..

So AFAICT, regardless if the user sets emulate_tpu or emulate_tpws for a
IBLOCK backend, SCSI host code will have to choose sdkp->zeroing_mode
WRITE_SAME with LBPRZ or explicit ZERO, and NVMe host code will have to
chose a ctrl NVME_QUIRK_DEALLOCATE_ZEROES before
q->limits.max_write_zeroes_sectors != 0 is propagated up to target code,
and LBPRZ = 1 is signaled via READ_CAPACITY_16 and EVPD = 0xb2.

That said, simply propagating up q->limits.max_write_zeroes_sectors as
dev_attrib->unmap_zeroes_data following existing code still looks like
the right thing to do.
