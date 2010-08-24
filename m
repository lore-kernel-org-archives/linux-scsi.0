From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Tue, 24 Aug 2010 13:52:16 -0400
Message-ID: <20100824175215.GA29409@redhat.com>
References: <20100814103654.GA13292@lst.de>
 <4C6A5D8A.4010205@kernel.org>
 <20100817131915.GB2963@lst.de>
 <4C6ABBCB.9030306@kernel.org>
 <20100817165929.GB13800@lst.de>
 <4C6E3C1A.50205@ct.jp.nec.com>
 <4C72660A.7070009@kernel.org>
 <20100823141733.GA21158@redhat.com>
 <4C739DE9.5070803@ct.jp.nec.com>
 <4C73FA8F.5080800@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C73FA8F.5080800@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Hannes Reinecke <hare@suse.de>, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 24 2010 at 12:59pm -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 08/24/2010 12:24 PM, Kiyoshi Ueda wrote:
> > Yes, checking whether it's a transport error in lower layer is
> > the right solution.
> > (Since I know it's not available yet, I just hoped if upper layers
> >  had some other options.)
> > 
> > Anyway, only reporting errors for REQ_FLUSH to upper layer without
> > such a solution would make dm-multipath almost unusable in real world,
> > although it's better than implicit data loss.
> 
> I see.
> 
> >>> Maybe just turn off barrier support in mpath for now?
> > 
> > If it's possible, it could be a workaround for a short term.
> > But how can you do that?
> > 
> > I think it's not enough to just drop REQ_FLUSH flag from q->flush_flags.
> > Underlying devices of a mpath device may have write-back cache and
> > it may be enabled.
> > So if a mpath device doesn't set REQ_FLUSH flag in q->flush_flags, it
> > becomes a device which has write-back cache but doesn't support flush.
> > Then, upper layer can do nothing to ensure cache flush?
> 
> Yeah, I was basically suggesting to forget about cache flush w/ mpath
> until it can be fixed.  You're saying that if mpath just passes
> REQ_FLUSH upwards without retrying, it will be almost unuseable,
> right?  I'm not sure how to proceed here.

Seems clear that we must fix mpath to receive the SCSI errors, in some
form, so it can decide if a retry is required/valid or not.

Such error processing was a big selling point for the transition from
bio-based to request-based multipath; so it's unfortunate that this
piece has been left until now.

> How much work would discerning between transport and IO errors take?

Hannes already proposed some patches:
https://patchwork.kernel.org/patch/61282/
https://patchwork.kernel.org/patch/61283/
https://patchwork.kernel.org/patch/61596/

This work was discussed at LSF, see "Error Handling - Hannes Reinecke"
here: http://lwn.net/Articles/400589/

I thought James, Alasdair and others offered some guidance on what he'd
like to see...

Unfortunately, even though I was at this LSF session, I can't recall any
specific consensus on how Hannes' work should be refactored (to avoid
adding SCSI sense processing code directly in dm-mpath).  Maybe James,
Hannes or others remember?

Was it enough to just have the SCSI sense processing code split out in a
new sub-section of the SCSI midlayer -- and then DM calls that code?

> If it can't be done quickly enough the retry logic can be kept around
> to keep the old behavior but that already was a broken behavior, so...
> :-(

I'll have to review this thread again to understand why mpath's existing
retry logic is broken behavior.  mpath is used with more capable SCSI
devices so I'm missing why a failed FLUSH implies data loss.

Mike
