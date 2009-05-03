From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 03 May 2009 18:02:51 +0300
Message-ID: <49FDB21B.3080301@panasas.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com> <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils> <20090503144847.GR8822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:16101 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753878AbZECPEE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 11:04:04 -0400
In-Reply-To: <20090503144847.GR8822@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>

On 05/03/2009 05:48 PM, Matthew Wilcox wrote:
> On Sun, May 03, 2009 at 02:07:32PM +0100, Hugh Dickins wrote:
>> I notice OCZ hope to have updated Vertex firmware mid-May,
>> such that their TRIM support matches up with (y)ours.
> 
> Excellent.
> 
>> You have GFP_KERNEL allocations in your discard_fn()s.  I believe that
>> allocations down at that level will need to be GFP_NOIO - the bio mempool
>> might be empty by this point, you don't want memory allocation to get into
>> submitting even more I/O to satisfy your discard_fn().  Does it need its
>> own mempool of reserve pages?  My guess is that you can get away without
>> that, since a failed discard, though regrettable, loses no data.
> 
> You make a good point.  There's definitely still work to be done around
> error handling.  OTOH, we could always do what IDE does ...
> 
> static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
> {
>         ide_drive_t *drive = q->queuedata;
>         struct ide_cmd *cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
> 
>         /* FIXME: map struct ide_taskfile on rq->cmd[] */
>         BUG_ON(cmd == NULL);
> 
> 
> 

Out from the frying pan and into the fire. ;-)

I agree with Hugh. The allocation is done at, too-low in the food chain.
(And that free of buffer at upper layer allocated by lower layer).

I think you need to separate the: "does lld need buffer, what size"
from the "here is buffer prepare", so upper layer that can sleep does
sleep.

In all other buffer needing operations the allocation is done before
submission of request, No?

Just my $0.017
Thanks
Boaz

BTW:
 I've not have time to review second round will "TODO"
