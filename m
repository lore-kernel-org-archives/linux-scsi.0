From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/5] dm: implement REQ_FLUSH/FUA support
Date: Tue, 17 Aug 2010 11:33:52 +0200
Message-ID: <4C6A5780.2090100@kernel.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-6-git-send-email-tj@kernel.org> <20100816190203.GA22299@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100816190203.GA22299@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, Tejun Heo <tj@kernle.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

On 08/16/2010 09:02 PM, Mike Snitzer wrote:
> On Mon, Aug 16 2010 at 12:52pm -0400,
> Tejun Heo <tj@kernel.org> wrote:
> 
>> From: Tejun Heo <tj@kernle.org>
>>
>> This patch converts dm to support REQ_FLUSH/FUA instead of now
>> deprecated REQ_HARDBARRIER.
> 
> What tree does this patch apply to?  I know it doesn't apply to
> v2.6.36-rc1, e.g.: http://git.kernel.org/linus/708e929513502fb0

(from the head message)
These patches are on top of

  block#for-2.6.36-post (c047ab2dddeeafbd6f7c00e45a13a5c4da53ea0b)
+ block-replace-barrier-with-sequenced-flush patchset[1]
+ block-fix-incorrect-bio-request-flag-conversion-in-md patch[2]

and available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua

[1] http://thread.gmane.org/gmane.linux.kernel/1022363
[2] http://thread.gmane.org/gmane.linux.kernel/1023435

Probably fetching the git tree is the easist way to review?

>> For bio-based dm,
>> * -EOPNOTSUPP retry logic dropped.
>
> That logic wasn't just about retries (at least not in the latest
> kernel).  With commit 708e929513502fb0 the -EOPNOTSUPP checking also
> serves to optimize the barrier+discard case (when discards aren't
> supported).

With the patch applied, there's no second flush.  Those requests would
now be REQ_FLUSH + REQ_DISCARD.  The first can't be avoided anyway and
there won't be the second flush to begin with, so I don't think this
worsens anything.

>> * Nothing much changes.  It just needs to handle FLUSH requests as
>>   before.  It would be beneficial to advertise FUA capability so that
>>   it can propagate FUA flags down to member request_queues instead of
>>   sequencing it as WRITE + FLUSH at the top queue.
> 
> Can you expand on that TODO a bit?  What is the mechanism to propagate
> FUA down to a DM device's members?  I'm only aware of propagating member
> devices' features up to the top-level DM device's request-queue (not the
> opposite).
> 
> Are you saying that establishing the FUA capability on the top-level DM
> device's request_queue is sufficient?  If so then why not make the
> change?

Yeah, I think it would be enough to always advertise FLUSH|FUA if the
member devices support FLUSH (regardless of FUA support).  The reason
why I didn't do it was, umm, laziness, I suppose.

>> Lightly tested linear, stripe, raid1, snap and crypt targets.  Please
>> proceed with caution as I'm not familiar with the code base.
> 
> This is concerning...

Yeap, I want you to be concerned. :-) This was the first time I looked
at the dm code and there are many different disjoint code paths and I
couldn't fully follow or test all of them, so it definitely needs a
careful review from someone who understands the whole thing.

> if we're to offer more comprehensive review I think we need more
> detail on what guided your changes rather than details of what the
> resulting changes are.

I'll try to explain it.  If you have any further questions, please let
me know.

* For common part (dm-io, dm-log):

  * Empty REQ_HARDBARRIER is converted to empty REQ_FLUSH.

  * REQ_HARDBARRIER w/ data is converted either to data + REQ_FLUSH +
    REQ_FUA or data + REQ_FUA.  The former is the safe equivalent
    conversion but there could be cases where ther latter is enough.

* For bio based dm:

  * Unlike REQ_HARDBARRIER, REQ_FLUSH/FUA doesn't have any ordering
    requirements.  Remove assumptions of ordering and/or draining.

    A related question: Is dm_wait_for_completion() used in
    process_flush() safe against starvation under continuous influx of
    other commands?

  * As REQ_FLUSH/FUA doesn't require any ordering of requests before
    or after it, on array devices, the latter part - REQ_FUA - can be
    handled like other writes.  ie. REQ_FLUSH needs to be broadcasted
    to all devices but once that is complete the data/REQ_FUA bio can
    be sent to only the affected devices.  This needs some care as
    there are bio cloning/splitting code paths where REQ_FUA bit isn't
    preserved.

  * Guarantee that REQ_FLUSH w/ data never reaches targets (this in
    part is to put it in alignment with request based dm).

* For request based dm:

  * The sequencing is done by the block layer for the top level
    request_queue, so the only things request based dm needs to make
    sure is 1. handling empty REQ_FLUSH correctly (block layer will
    only send down empty REQ_FLUSHes) and 2. propagate REQ_FUA bit to
    member devices.

Thanks.

-- 
tejun
