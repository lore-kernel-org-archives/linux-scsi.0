From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf10-pc] [LFS/VM TOPIC] Stable pages while IO (was Wrong DIF
 guard tag on ext2 write)
Date: Fri, 4 Jun 2010 19:11:52 +0200
Message-ID: <20100604171151.GH3414@quack.suse.cz>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <4C07D3D0.8010500@panasas.com>
 <20100604162332.GF3414@quack.suse.cz>
 <20100604163009.GF10153@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100604163009.GF10153@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Vladislav Bolkhovitin <vst@vlnb.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, lsf10-pc@lists.linuxfoundation.org, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri 04-06-10 12:30:09, J. Bruce Fields wrote:
> On Fri, Jun 04, 2010 at 06:23:32PM +0200, Jan Kara wrote:
> > On Thu 03-06-10 19:09:52, Boaz Harrosh wrote:
> > > [Topic]
> > > How to not let pages change while in IO
> > > 
> > > [Abstract]
> > > As seen in a long thread on the fsdvel scsi mailing lists. Lots of
> > > people have headaches and sleep less nights because individual pages
> > > can change while in IO and/or DMA. Though each one as slightly different
> > > needs, the mechanics look to be the same.
> >   Hmm, I don't think it's really about "how to not let pages change" - that
> > is doable by using wait_on_page_writeback() in ->page_mkwrite and
> > ->write_begin.
> 
> Will the same work for the NFS server checksumming page data in read
> replies?
  Currently it won't. The above relies on the fact that when we clear dirty
page flag in clear_page_dirty_for_io we also write-protect the page.
Moreover I suppose you don't set PageWriteback when serving a content from
a page...
  But an elegant way to solve this would IMHO be to do:
	lock_page(page);
	if (page_mkclean(page))
		set_page_dirty(page);
  and now you can be sure that until you unlock the page it cannot be
modified because both ->page_mkwrite and ->write_begin need page lock
before they can go and modify a page...

									Honza	
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
