From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 16:20:25 +0200
Message-ID: <20100730142025.GA29341@lst.de>
References: <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org> <4C52CBFF.6090406@vlnb.net> <20100730130957.GA26894@lst.de> <4C52D2E0.5000609@vlnb.net> <20100730133410.GA27996@lst.de> <4C52D728.6070008@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C52D728.6070008@vlnb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 30, 2010 at 05:44:08PM +0400, Vladislav Bolkhovitin wrote:
> Yes, but why not to make step further and allow to completely eliminate 
> the waiting/draining using ORDERED requests? Current advanced storage 
> hardware allows that.

There is a few caes where we could do that - the fsync without metadata
changes above would be the prime example.  But there's a lot lower
hanging fruit until we get to the point where it's worth trying.

But in most cases we don't just drain an imaginary queue but actually
need to modify software state before finishing one class of I/O and
submitting the next.

Again, take the example of fsync, but this time we have actually
extended the file and need to log an inode size update, as well
as a modification to to the btree blocks.

Now the fsync in XFS looks like this:

1) write out all the data blocks using WRITE
2) wait for these to finish
3) propagate any I/O error to the inode so we can pick them up
4) update the inode size in the shadow in-memory structure
5) start a transaction to log the inode size
6) flush the write cache to make sure the data really is on disk
7) write out a log buffer containing the inode and btree updates
8) if the FUA bit is not support flush the cache again

and yes, the flush in 6) is important so that we don't happen
to log the inode size update before all data has made it to disk
in case the cache flush in 8) is interrupted

