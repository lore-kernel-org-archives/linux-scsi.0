From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Mon, 2 Aug 2010 21:26:41 +0200
Message-ID: <20100802192641.GA13726@lst.de>
References: <4C51DCF1.3010507@redhat.com> <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org> <4C52CBFF.6090406@vlnb.net> <20100730130957.GA26894@lst.de> <4C52D2E0.5000609@vlnb.net> <20100730133410.GA27996@lst.de> <4C52D728.6070008@vlnb.net> <20100730142025.GA29341@lst.de> <4C571621.8070007@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C571621.8070007@vlnb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 02, 2010 at 11:01:53PM +0400, Vladislav Bolkhovitin wrote:
> IMHO, all is needed are:

What we need first is a simple interface that

 a) guarantees data integrity
 b) doesn't cause massive slowdowns

and then we can optimize it later.

What we absolutely don't need is a large number of different
interfaces that no one understands and that all are buggy in some way.

> >Now the fsync in XFS looks like this:
> >
> >1) write out all the data blocks using WRITE
> >2) wait for these to finish
> >3) propagate any I/O error to the inode so we can pick them up
> >4) update the inode size in the shadow in-memory structure
> >5) start a transaction to log the inode size
> >6) flush the write cache to make sure the data really is on disk
> 
> Here should be "6.1) wait for it to finish"

yes

> which can be eliminated if 
> requests sent ordered, correct?

not really - if the cache flush returns we shouldn't even send the log
update.

