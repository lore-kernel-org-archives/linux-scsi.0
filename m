From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/5] dm: implement REQ_FLUSH/FUA support
Date: Tue, 17 Aug 2010 18:51:30 +0200
Message-ID: <4C6ABE12.40705@kernel.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-6-git-send-email-tj@kernel.org> <20100816190203.GA22299@redhat.com> <4C6A5780.2090100@kernel.org> <20100817140734.GA30768@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100817140734.GA30768@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On 08/17/2010 04:07 PM, Mike Snitzer wrote:
>> With the patch applied, there's no second flush.  Those requests would
>> now be REQ_FLUSH + REQ_DISCARD.  The first can't be avoided anyway and
>> there won't be the second flush to begin with, so I don't think this
>> worsens anything.
> 
> Makes sense, but your patches still need to be refreshed against the
> latest (2.6.36-rc1) upstream code.  Numerous changes went in to DM
> recently.

Sure thing.  The block part isn't fixed yet and so the RFC tag.  Once
the block layer part is settled, it probably should be pulled into
dm/md and other trees and conversions should happen there.

>> Yeap, I want you to be concerned. :-) This was the first time I looked
>> at the dm code and there are many different disjoint code paths and I
>> couldn't fully follow or test all of them, so it definitely needs a
>> careful review from someone who understands the whole thing.
> 
> You'll need Mikulas (bio-based) and NEC (request-based, Kiyoshi and
> Jun'ichi) to give it serious review.

Oh, you already cc'd them.  Great.  Hello, guys, the original thread
is

  http://thread.gmane.org/gmane.linux.raid/29100

> NOTE: NEC has already given some preliminary feedback to hch in the
> "[PATCH, RFC 2/2] dm: support REQ_FLUSH directly" thread:
> https://www.redhat.com/archives/dm-devel/2010-August/msg00026.html
> https://www.redhat.com/archives/dm-devel/2010-August/msg00033.html

Hmmm... I think both issues don't exist in this incarnation of
conversion although I'm fairly sure there will be other issues.  :-)

>>     A related question: Is dm_wait_for_completion() used in
>>     process_flush() safe against starvation under continuous influx of
>>     other commands?
>
> As for your specific dm_wait_for_completion() concern -- I'll defer to
> Mikulas.  But I'll add: we haven't had any reported starvation issues
> with DM's existing barrier support.  DM uses a mempool for its clones,
> so it should naturally throttle (without starvation) when memory gets
> low.

I see but single pending flush and steady write streams w/o saturating
the mempool would be able to stall dm_wait_for_completeion(), no?  Eh
well, it's a separate issue, I guess.

>>   * Guarantee that REQ_FLUSH w/ data never reaches targets (this in
>>     part is to put it in alignment with request based dm).
> 
> bio-based DM already split the barrier out from the data (in
> process_barrier).  You've renamed process_barrier to process_flush and
> added the REQ_FLUSH logic like I'd expect.

Yeah and threw in WARN_ON() there to make sure REQ_FLUSH + data bios
don't slip through for whatever reason.

>> * For request based dm:
>>
>>   * The sequencing is done by the block layer for the top level
>>     request_queue, so the only things request based dm needs to make
>>     sure is 1. handling empty REQ_FLUSH correctly (block layer will
>>     only send down empty REQ_FLUSHes) and 2. propagate REQ_FUA bit to
>>     member devices.
> 
> OK, so seems 1 is done, 2 is still TODO.  Looking at your tree it seems
> 2 would be as simple as using the following in

Oh, I was talking about the other way around.  Passing REQ_FUA in
bio->bi_rw down to member request_queues.  Sometimes while
constructing clone / split bios, the bit is lost (e.g. md raid5).

> dm_init_request_based_queue (on the most current upstream dm.c):
> blk_queue_flush(q, REQ_FLUSH | REQ_FUA);
> (your current patch only sets REQ_FLUSH in alloc_dev).

Yeah, but for that direction, just adding REQ_FUA to blk_queue_flush()
should be enough.  I'll add it.

Thanks.

-- 
tejun
