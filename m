From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/5] New blk_make_request(), takes bio, returns a	request
Date: Tue, 19 May 2009 16:33:42 +0300
Message-ID: <4A12B536.2020900@panasas.com>
References: <4A1032B0.5000003@panasas.com> <4A1033DB.2030908@panasas.com> <20090519094130.GW4140@kernel.dk> <4A1284F7.2050703@panasas.com> <20090519101308.GX4140@kernel.dk> <4A12A5BB.3060105@panasas.com> <20090519124953.GA4140@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:12616 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753667AbZESNdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2009 09:33:47 -0400
In-Reply-To: <20090519124953.GA4140@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 05/19/2009 03:49 PM, Jens Axboe wrote:
> On Tue, May 19 2009, Boaz Harrosh wrote:
>> + * WARNING: When allocating/cloning a bio-chain, careful consideration should be
>> + * given to how you allocate bios. In particular, you cannot use __GFP_WAIT for
>> + * anything but the first bio in the chain. Otherwise you risk deadlocking,
>> + * waiting for a bio to be returned to the pool, which will never return, since
>> + * it was not submitted yet.
> 
> Perhaps something like:
> 
> Otherwise you risk waiting for IO completion of a bio that hasn't been
> submitted yet, thus resulting in a deadlock.
> 
>> + * Alternatively bios should be allocated using bio_kmalloc only.
>> + * If possible a long IO should be split into smaller parts when allocation
>> + * fails. Partial allocation should not be an error, or you risk a live-lock.
>>   */
>>  struct request *blk_make_request(struct request_queue *q, struct bio *bio,
>>  				 gfp_t gfp_mask)
> 
> Alternatively bios should be allocated using bio_kmalloc() instead of
> bio_alloc(), as that avoids the mempool deadlock. If possible a big IO
> should be ...
> 

Thanks Jens makes much more sense.

I'm posting as reply to original patch (with version 2 at title).

I'm also reposting a small forgoten patch that belongs to Tejun's
batch.

Boaz
