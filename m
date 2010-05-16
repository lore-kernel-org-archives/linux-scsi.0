From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/8] SCSI: implement sd_unlock_native_capacity()
Date: Sun, 16 May 2010 19:00:18 +0200
Message-ID: <4BF024A2.4090804@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>	 <1273946974-29131-7-git-send-email-tj@kernel.org>	 <1274017175.14187.9.camel@mulgrave.site>	 <1274022457.2564.105.camel@localhost> <1274025636.14187.24.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:48968 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0EPRAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 May 2010 13:00:44 -0400
In-Reply-To: <1274025636.14187.24.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, bzolnier@gmail.com

Hello, James.

On 05/16/2010 06:00 PM, James Bottomley wrote:
> This layering problem is partly the fault of libata ... if we had an ATA
> native disk driver, it would be able to unlock the capacity on its own.

Yeap.

> It's just we're using SCSI which has no SAT command it can issue for
> this, so the functional request has to be pushed down to libata ...
> leading to the need to thread it through the host template.
> 
> I was just pointing out that the whole thing is simplified if we use a
> block queue function approach instead.  ide_disk_t has access to the
> queue, as does gendisk, so it would all "just work" with a simple call
> site change if we used queue ops instead of block dev ops.  The plus
> side of doing it this way is that the SCSI threading becomes
> unnecessary: libata gets directly hooked into the unlock function
> instead of having to do it via an intermediary.

Yeah, it can be made to work via a queue callback but I'm afraid that
would be a genuine layering violation (although going through SCSI is
extra layering, it isn't really a layering violation).

These are request_queue methods.

	request_fn_proc		*request_fn;
	make_request_fn		*make_request_fn;
	prep_rq_fn		*prep_rq_fn;
	unplug_fn		*unplug_fn;
	merge_bvec_fn		*merge_bvec_fn;
	prepare_flush_fn	*prepare_flush_fn;
	softirq_done_fn		*softirq_done_fn;
	rq_timed_out_fn		*rq_timed_out_fn;
	dma_drain_needed_fn	*dma_drain_needed;
	lld_busy_fn		*lld_busy_fn;

These are gendisk methods.

	int (*open) (struct block_device *, fmode_t);
	int (*release) (struct gendisk *, fmode_t);
	int (*locked_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
	int (*direct_access) (struct block_device *, sector_t,
						void **, unsigned long *);
	int (*media_changed) (struct gendisk *);
	void (*unlock_native_capacity) (struct gendisk *);
	int (*revalidate_disk) (struct gendisk *);
	int (*getgeo)(struct block_device *, struct hd_geometry *);

request_queue is (or at least supposed to be) oblivious about genhd
and its attributes including capacity.  After all, request_queue can
exist w/o genhd associated, so it would be quite odd to have capacity
related method living in request_queue.

Another thing is that there is no generic way to reach the associated
genhd from request_queue and I can't think of a clean way to map
request_queue to the associated ata device w/o in-flight requests (can
you even do that from SCSI?).

Unfortunately, libata is still properly layered below SCSI, so I'm
afraid threading through sd is clumsy yet the cleanest way to do it.

Thanks.

-- 
tejun
