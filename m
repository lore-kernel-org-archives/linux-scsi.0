From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] support for bidirectional transfers and variable length CDBs
Date: Sun, 29 Oct 2006 13:48:52 +0000
Message-ID: <20061029134852.GB22902@infradead.org>
References: <4541F822.70700@panasas.com> <20061028163609.GA17317@infradead.org> <4544ADB3.8050708@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40160 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965230AbWJ2Ns4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Oct 2006 08:48:56 -0500
Content-Disposition: inline
In-Reply-To: <4544ADB3.8050708@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Dalit Naor <DALIT@il.ibm.com>, Liran Schour <LIRANS@il.ibm.com>, Sami.Iren@seagate.com, Daniel.E.Messinger@seagate.com, stuart.brodsky@seagate.com, open-iscsi@googlegroups.com, Boaz Harrosh <bharrosh@panasas.com>

On Sun, Oct 29, 2006 at 03:33:39PM +0200, Benny Halevy wrote:
> >though.
> >  
> I'm not sure I understand exactly when these helpers are to be used.
> Can you point me at more info please?
> Does this solve the dependency of scsi on struct request for buffer mapping?
> (i.e. will this be used in the scsi_init_io() path instead of calling 
> blk_rq_map_kern()
> or the calls to the block layer in scsi_merge_bio()?)

No, not at all.  It's intended to replace the direct calls to the dma
mapping helpers (or kmap calls) in the low level scsi drivers.  That
way they don't need to know how we represent the storage for the
<request_buffer, request_bufflen, use_sg, sglist_len> tuple given
the we plan to change it and 95% of the driver don't need to know
the details, they just want to dma map whatever is there.

> >We might aswell change scsi_execute_async to just support bidi and varlen
> >commands in the end.  There's very few user and having yet another API
> >to submit scsi commands doesn't sound very helpfull.
> >  
> cool.  and what about scsi_execute?  are you ok with changing it too or 
> would you
> rather add a new synchronous API call for bidi. The reason I'm asking is 
> that
> it doesn't currently allocate a scsi_io_context and therefore it's more 
> efficient
> than the async api.

My vague feeling is that I'd prefer not to touch scsi_execute because it's
used quite a lot and also in relatively fasthpathes.  We'll have to decice
whether to update it, introduce a wrapper like scsi_execute_bidi or
just opencode that in the callers if there are only a few.

> > - you submit your patch that fixes the scsi_execute comment typo
> > - you submit your patch to add the VARLEN_CDB opcode
> > - you start converting as many as possible drivers to the
> >   above wrapper API (I already had a big FC card vendor signed up
> >   for this, but no updates so far..)
> >  
> fine with me, if ok with them too, please send them my way so they can send
> us whatever they've done already.

I haven't seen anything yet, that's why I added the sneaky comment here.
I expect the relevant parties will answer this mail next week ;-)

