From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [Lsf10-pc] [LFS/VM TOPIC] Stable pages while IO (was Wrong DIF
	guard tag on ext2 write)
Date: Fri, 4 Jun 2010 12:30:09 -0400
Message-ID: <20100604163009.GF10153@fieldses.org>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com> <4C07D3D0.8010500@panasas.com> <20100604162332.GF3414@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100604162332.GF3414@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Vladislav Bolkhovitin <vst@vlnb.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, lsf10-pc@lists.linuxfoundation.org, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 04, 2010 at 06:23:32PM +0200, Jan Kara wrote:
> On Thu 03-06-10 19:09:52, Boaz Harrosh wrote:
> > [Topic]
> > How to not let pages change while in IO
> > 
> > [Abstract]
> > As seen in a long thread on the fsdvel scsi mailing lists. Lots of
> > people have headaches and sleep less nights because individual pages
> > can change while in IO and/or DMA. Though each one as slightly different
> > needs, the mechanics look to be the same.
>   Hmm, I don't think it's really about "how to not let pages change" - that
> is doable by using wait_on_page_writeback() in ->page_mkwrite and
> ->write_begin.

Will the same work for the NFS server checksumming page data in read
replies?

--b.

> I think the discussion is more about whether we should do it
> or whether we should rechecksum and resubmit IO in case of checksum failure
> as Nick proposed...
> 
> 								Honza
> > People that care:
> > - Mirror and RAID people that need on disk consistency.
> > - Network storage that wants data checksum.
> > - DIF/DIX people
> > - ...
> > 
> > I for one know nothing of the subject but am a RAID person and would
> > like a solution that does not force me to copy the complete data load.
> > 
> > Please lets get all the VM VFS and drivers people in one room and see
> > if we can have a Linux solution to this problem
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> _______________________________________________
> Lsf10-pc mailing list
> Lsf10-pc@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/lsf10-pc
