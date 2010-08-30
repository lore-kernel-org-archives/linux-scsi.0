From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Mon, 30 Aug 2010 14:45:29 +0200
Message-ID: <4C7BA7E9.1050602@kernel.org>
References: <4C58F341.9060605@ct.jp.nec.com> <20100804085423.GA15687@lst.de> <4C5A1F05.40308@ce.jp.nec.com> <20100826225024.GB17832@redhat.com> <4C771852.3050500@ce.jp.nec.com> <20100827040808.GA19488@redhat.com> <4C7752B5.3020905@ce.jp.nec.com> <20100827141314.GB22504@redhat.com> <4C7B3760.2070201@ce.jp.nec.com> <4C7B6CC8.5080609@kernel.org> <20100830124334.GA5283@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100830124334.GA5283@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@lst.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, tytso@mit.edu, swhiteho@redhat.com, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hello,

On 08/30/2010 02:43 PM, Mike Snitzer wrote:
> I did it yesterday also, mine builds on your previous DM patchset...
> 
> I'll review your recent patchset, from today, to compare and will share
> my findings.

Thanks. :-)

> I was hoping we could get the current request-based code working with
> your new FLUSH+FUA work without removing support for num_flush_requests
> (yet).  And then layer in the removal to give us the before and after so
> we would know the overhead associated with keeping/dropping
> num_flush_requests.  But like I said earlier "we _could_ just remove it
> and never look back".

I tried but it's not very easy because the original implementation
depended on the block layer suppressing other requests while flush
sequence is in progress.  The painful part was that block layer no
longer sorts requeued flush requests in front of other front inserted
requests, so explicit queue suppressing can't be implemented simply.
Another route would be adding a separate wait/wakeup logic for flushes
(someone posted a demo patch for that which was almost there but not
fully), but it seemed like a aimless effort to build a new facility to
rip it out in the next patch.  After all, the whole thing seemed
somewhat pointless given that writes can't be routed to multiple
targets (if writes can't target multiple devices, flushes won't need
to either).

Thanks.

-- 
tejun
