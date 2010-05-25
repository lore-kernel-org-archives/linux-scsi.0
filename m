From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Lsf10-pc] [LFS/VM TOPIC] Barriers and SYNCHRONZIE_CACHE
Date: Tue, 25 May 2010 13:41:21 +0200
Message-ID: <20100525114120.GM23411@kernel.dk>
References: <4BFBADE9.4060904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44936 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab0EYLlX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 May 2010 07:41:23 -0400
Content-Disposition: inline
In-Reply-To: <4BFBADE9.4060904@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf10-pc@lists.linuxfoundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, May 25 2010, Hannes Reinecke wrote:
> Hi all,
> 
> [Topic]
> Barriers and SYNCHRONIZE CACHE
> 
> [Abstract]
> In recent years some design flaws in the barriers implementation
> became apparent:
> - No indication about _which_ blocks to flush, so all outstanding
>   blocks are flushed
> - No error handling for SYNCHRONIZE CACHE
> - SYNCHRONIZE CACHE affects all I/Os, so if a LUN is used by
>   several virtual guests _all_ guests are affected
> - SYNCHRONIZE CACHE has a rather severe performance impact
>   on RAID controllers (if executed directly)
> 
> To overcome these issues I would propose to modify the
> barrier interface so that individual blocks can be
> marked as 'flushing'/'immediate'. This would allow
> the lower layers (eg. SCSI midlayer) to restrict
> the barriers operation on the affected blocks only.
> EG the SYNCHRONIZE_CACHE operation could be updated
> with a block list. Or more advanced methods (like FUA
> or tagging) could be used, avoiding the need to issue
> a SYNCHRONIZE CACHE altogether.

I think this is better handled over email for several reasons. Here's a
few of them:

- We've talked about barriers at each io/fs summit since we started
  holding those, and nothing has ever come out of it. Lets not waste
  more time _talking_ about it.

- Following from the previous entry, this is now at a point (and has
  been for probably 5 years) where the best way forward is discussion
  based on actual code.

- Yet another hand wavy discussion on how to improve barriers turns hair
  greyer. And at least personally, I don't need more grey hairs.

-- 
Jens Axboe

