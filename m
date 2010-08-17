From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/5] dm: implement REQ_FLUSH/FUA support
Date: Tue, 17 Aug 2010 14:21:31 -0400
Message-ID: <20100817182130.GA31737@redhat.com>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
	<1281977523-19335-6-git-send-email-tj@kernel.org>
	<20100816190203.GA22299@redhat.com> <4C6A5780.2090100@kernel.org>
	<20100817140734.GA30768@redhat.com> <4C6ABE12.40705@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4C6ABE12.40705@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: jack@suse.cz, mst@redhat.com, linux-ide@vger.kernel.org, dm-devel@redhat.com, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, hch@lst.de, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, vst@vlnb.net, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, linux-raid@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 17 2010 at 12:51pm -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 08/17/2010 04:07 PM, Mike Snitzer wrote:
> >> With the patch applied, there's no second flush.  Those requests would
> >> now be REQ_FLUSH + REQ_DISCARD.  The first can't be avoided anyway and
> >> there won't be the second flush to begin with, so I don't think this
> >> worsens anything.
> > 
> > Makes sense, but your patches still need to be refreshed against the
> > latest (2.6.36-rc1) upstream code.  Numerous changes went in to DM
> > recently.
> 
> Sure thing.  The block part isn't fixed yet and so the RFC tag.  Once
> the block layer part is settled, it probably should be pulled into
> dm/md and other trees and conversions should happen there.

Why base your work on a partial 2.6.36 tree?  Why not rebase to linus'
2.6.36-rc1?

Once we get the changes in a more suitable state (across the entire
tree) we can split the individual changes out to their respective
trees.  Without a comprehensive tree I fear this code isn't going to get
tested or reviewed properly.

For example: any review of DM changes, against stale DM code, is wasted
effort.

> >> * For request based dm:
> >>
> >>   * The sequencing is done by the block layer for the top level
> >>     request_queue, so the only things request based dm needs to make
> >>     sure is 1. handling empty REQ_FLUSH correctly (block layer will
> >>     only send down empty REQ_FLUSHes) and 2. propagate REQ_FUA bit to
> >>     member devices.
> > 
> > OK, so seems 1 is done, 2 is still TODO.  Looking at your tree it seems
> > 2 would be as simple as using the following in
> 
> Oh, I was talking about the other way around.  Passing REQ_FUA in
> bio->bi_rw down to member request_queues.  Sometimes while
> constructing clone / split bios, the bit is lost (e.g. md raid5).

Seems we need to change __blk_rq_prep_clone to propagate REQ_FUA just
like REQ_DISCARD: http://git.kernel.org/linus/3383977

Doesn't seem like we need to do the same for REQ_FLUSH (at least not for
rq-based DM's benefit) because dm.c:setup_clone already special cases
flush requests and sets REQ_FLUSH in cmd_flags.

Mike
