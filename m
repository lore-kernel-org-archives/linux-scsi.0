From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Fri, 27 Aug 2010 10:13:14 -0400
Message-ID: <20100827141314.GB22504@redhat.com>
References: <20100727175418.GF6820@quack.suse.cz>
 <20100803184939.GA12198@lst.de>
 <20100803185148.GA12258@lst.de>
 <4C58F341.9060605@ct.jp.nec.com>
 <20100804085423.GA15687@lst.de>
 <4C5A1F05.40308@ce.jp.nec.com>
 <20100826225024.GB17832@redhat.com>
 <4C771852.3050500@ce.jp.nec.com>
 <20100827040808.GA19488@redhat.com>
 <4C7752B5.3020905@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C7752B5.3020905@ce.jp.nec.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Christoph Hellwig <hch@lst.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, tj@kernel.org, tytso@mit.edu, swhiteho@redhat.com, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 27 2010 at  1:52am -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi Mike,
> 
> (08/27/10 13:08), Mike Snitzer wrote:
> > But do you agree that the request-based barrier code (added in commit
> > d0bcb8786) could be reverted given the new FLUSH work?
> 
> No, it's a separate thing.
> If we don't need to care about the case where multiple clones
> of flush request are necessary, the special casing of flush
> request can be removed regardless of the new FLUSH work.

Ah, yes thanks for clarifying.  But we've never cared about multiple
clone of a flush so it's odd that such elaborate infrastructure was
introduced without a need.

> > We no longer need waiting now that ordering isn't a concern.  Especially
> 
> The waiting is not for ordering, but for multiple clones.
> 
> > so given rq-based doesn't support multiple targets.  As you know, from
> > dm_table_set_type:
> > 
> >         /*
> >          * Request-based dm supports only tables that have a single target now.
> >          * To support multiple targets, request splitting support is needed,
> >          * and that needs lots of changes in the block-layer.
> >          * (e.g. request completion process for partial completion.)
> >          */
> 
> This comment is about multiple targets.
> The special code for barrier is for single target whose
> num_flush_requests > 1. Different thing.

Yes, I need to not send mail just before going to bed..
 
> > I think we need to at least benchmark the performance of dm-mpath
> > without any of this extra, soon to be unnecessary, code.
> 
> If there will be no need for supporting a request-based target
> with num_flush_requests > 1, the special handling of flush
> can be removed.
> 
> And since there is no such target in the current tree,
> I don't object if you remove that part of code for good reason.

OK, certainly something to keep in mind.  But _really_ knowing the
multipath FLUSH+FUA performance difference (extra special-case code vs
none) requires a full FLUSH conversion of request-based DM anyway.

In general, request-based DM's barrier/flush code does carry a certain
maintenance overhead.  It is quite a bit of distracting code in the core
DM which isn't buying us anything.. so we _could_ just remove it and
never look back (until we have some specific need for num_flush_requests
> 1 in rq-based DM).

Mike
