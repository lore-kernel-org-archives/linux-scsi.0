From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Fri, 27 Aug 2010 14:52:53 +0900
Message-ID: <4C7752B5.3020905@ce.jp.nec.com>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100803184939.GA12198@lst.de> <20100803185148.GA12258@lst.de> <4C58F341.9060605@ct.jp.nec.com> <20100804085423.GA15687@lst.de> <4C5A1F05.40308@ce.jp.nec.com> <20100826225024.GB17832@redhat.com> <4C771852.3050500@ce.jp.nec.com> <20100827040808.GA19488@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100827040808.GA19488@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, tj@kernel.org, tytso@mit.edu, swhiteho@redhat.com, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi Mike,

(08/27/10 13:08), Mike Snitzer wrote:
>> the above mentioned 'special casing' is not a hard part.
>> See the attached patch.
> 
> Yes, Tejun suggested something like this in one of the threads.  Thanks
> for implementing it.
> 
> But do you agree that the request-based barrier code (added in commit
> d0bcb8786) could be reverted given the new FLUSH work?

No, it's a separate thing.
If we don't need to care about the case where multiple clones
of flush request are necessary, the special casing of flush
request can be removed regardless of the new FLUSH work.

> We no longer need waiting now that ordering isn't a concern.  Especially

The waiting is not for ordering, but for multiple clones.

> so given rq-based doesn't support multiple targets.  As you know, from
> dm_table_set_type:
> 
>         /*
>          * Request-based dm supports only tables that have a single target now.
>          * To support multiple targets, request splitting support is needed,
>          * and that needs lots of changes in the block-layer.
>          * (e.g. request completion process for partial completion.)
>          */

This comment is about multiple targets.
The special code for barrier is for single target whose
num_flush_requests > 1. Different thing.

> I think we need to at least benchmark the performance of dm-mpath
> without any of this extra, soon to be unnecessary, code.

If there will be no need for supporting a request-based target
with num_flush_requests > 1, the special handling of flush
can be removed.

And since there is no such target in the current tree,
I don't object if you remove that part of code for good reason.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
