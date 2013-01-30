From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Re: [PATCH] target: For iblock at default writecache enable.
Date: Tue, 29 Jan 2013 23:29:17 -0800
Message-ID: <1359530957.23290.1745.camel@haakon2.linux-iscsi.org>
References: <201301250958101278740@gmail.com>
	 <1359486198.23290.1409.camel@haakon2.linux-iscsi.org>
	 <5108558D.6000408@redhat.com>
	 ,  <1359501265.23290.1720.camel@haakon2.linux-iscsi.org>
	 <201301300919014311109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35346 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3A3H3V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2013 02:29:21 -0500
In-Reply-To: <201301300919014311109@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, James Bottomley <jbottomley@parallels.com>

Hi majianpeng,

On Wed, 2013-01-30 at 09:19 +0800, majianpeng wrote:
> >On Tue, 2013-01-29 at 15:04 -0800, Andy Grover wrote:
> >> On 01/29/2013 11:03 AM, Nicholas A. Bellinger wrote:
> >> 
> >> > So enabling emulate_write_cache=1 in the case when the underlying device
> >> > has not enabled it is incorrect.
> >> > 
> >> > I'd like to enable this bit when we know the underlying device has WCE=1
> >> > set, but currently there is not a way to determine this (generically)
> >> > from struct block_device.
> >> > 
> >> > So NACK for applying this until there is a method to determine what the
> >> > hardware below is doing.
> >> 
> >> This should be possible from userspace though. I'm planning on looking
> >> up underlying scsi device(s?) using libblkid, and then query the sense
> >> data using libsgutils when adding a block backstore in targetcli.
> >> 
> >
> >Querying the mode pages from userspace would work for the SCSI backstore
> >case, but certainly not for raw block devices.
> >
> >I'd still like to see this exposed to the block layer somehow, so that
> >the setting can be automatically determined by TCM once it's known if
> >the underlying HW has enabled write caching.
> >
> >> It's kind of a hassle, but isn't it a huge performance win if we can
> >> enable this?
> >> 
> >
> >Most certainly, but the danger is reporting WCE=1 (by default in all
> >cases) from TCM to the initiator when the underlying drives do not have
> >caching enabled.  Note that every spinning media device that I've ever
> >seen disables WCE by default from the factory.
>
> Sorry, what's the danger?Can you explain the details?

Current IBLOCK code will always use WRITE_FUA with emulate_write_cache=0
default setting.  It attempts to be safe and invoke write through
schematics with WRITE_FUA when emulate_write_cache=0 is present.

> And for most sata hdd the WCE  is enable by default.

Spinning media SAS drives from the factory still this disable per
default to avoid silent data loss in the event of a hard power failure.

> IMHO, for hard-raid the WCE will be disable, it used the cache of hardraid-card.
> 
> In func sd_revalidate_disk:
> >	/*
> >	 * We now have all cache related info, determine how we deal
> >	 * with flush requests.
> >	 */
> >	if (sdkp->WCE) {
> >		flush |= REQ_FLUSH;
> >		if (sdkp->DPOFUA)
> >			flush |= REQ_FUA;
> >	}
> 
> >	blk_queue_flush(sdkp->disk->queue, flush);
> We can use queue->flush_flags.

Good point.

These are request queue hints that IBLOCK could be taking advantage of
here.

> But in func generic_make_request_checks:
> >/*
> >	 * Filter flush bio's early so that make_request based
> >	 * drivers without flush support don't have to worry
> >	 * about them.
> >	 */
> >	if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
> >		bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
> So if uderlying device don't support WCE, it can remove REQ_FUA|REQ_FLUSH.
> I think enable writecache by default is ok.
> 

Blindly enabling WriteCacheEnabled=1 in all cases for IBLOCK backends to
the SCSI initiator port, and ignoring what the underlying hardware is
doing is not correct either.

So, I've sent out a patch proposing a method for IBLOCK to take
advantage of REQ_FLUSH for WCE=1.  I'm not crazy about the extra pointer
dereferences in the iblock_execute_rw() data I/O path, but it's likely
the most sane way to access to request_queue->flush_flags minus adding a
target callback to update emulate_write_cache in the event of a
blk_queue_flush() call, considering this value may change from below
target/iblock.

(hch, axboe + jejb CC'ed)

--nab

