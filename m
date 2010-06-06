From: Jan Kara <jack@suse.cz>
Subject: Re: [LFS/VM TOPIC] Stable pages while IO (was Wrong DIF guard tag
 on ext2 write)
Date: Mon, 7 Jun 2010 01:37:53 +0200
Message-ID: <20100606233753.GC3302@quack.suse.cz>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <4C07D3D0.8010500@panasas.com>
 <20100604162332.GF3414@quack.suse.cz>
 <4C0B6BC7.8070803@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C0B6BC7.8070803@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jan Kara <jack@suse.cz>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lsf10-pc@lists.linuxfoundation.org, Nick Piggin <npiggin@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ric Wheeler <rwheeler@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Sun 06-06-10 12:35:03, Boaz Harrosh wrote:
> On 06/04/2010 07:23 PM, Jan Kara wrote:
> > On Thu 03-06-10 19:09:52, Boaz Harrosh wrote:
> >> [Topic]
> >> How to not let pages change while in IO
> >>
> >> [Abstract]
> >> As seen in a long thread on the fsdvel scsi mailing lists. Lots of
> >> people have headaches and sleep less nights because individual pages
> >> can change while in IO and/or DMA. Though each one as slightly different
> >> needs, the mechanics look to be the same.
> 
> >   Hmm, I don't think it's really about "how to not let pages change" - that
> > is doable by using wait_on_page_writeback() in ->page_mkwrite and
> > ->write_begin. I think the discussion is more about whether we should do it
> > or whether we should rechecksum and resubmit IO in case of checksum failure
> > as Nick proposed...
> > 
> > 								Honza
> 
> I have hijacked the DIF threads but, No, my proposal is for a general
> toolset that could be used for all the above as well as DIF if needed.
> 
> Surly even with DIF the keep-constant vs retransmit is a matter of
> machine+link speed multiply by faulting work loads. So there might be
> situations where an admin wants to choose.
> 
> With other none checksum fixtures, like RAID5/MIRROR this is not always
> an option and it becomes keep-constant vs copy. (That is complete
> workload copy). So for these setups the option is clear. No?
  Is it? You can have enough CPU / memory bandwidth to do the copying while
you need not be comfortable with a thread blocking until IO is finished
when it tries to do a rewrite...

> I'm glad that you think it is easy/doable to implement. And I'll surly
> test your above receipt. Do you think it would be acceptable as a generic
> per-sb tunable.  So for instance an ext3 over RAID5 could turn this on
> and eliminate the data copy?
  Yes, that would be useful. At least so that one can get real performance
numbers...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
