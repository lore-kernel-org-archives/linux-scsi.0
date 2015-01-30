From: "Andy Falanga (afalanga)" <afalanga@micron.com>
Subject: RE: block layer copying user io vectors
Date: Fri, 30 Jan 2015 17:43:04 +0000
Message-ID: <60F6FAE47D1BCE4380CC06D18F49789B95301D66@NTXBOIMBX02.micron.com>
References: <60F6FAE47D1BCE4380CC06D18F49789B952F7ED3@NTXBOIMBX02.micron.com>
 <20150123170627.GA8652@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150123170627.GA8652@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

> > This function does something that seems rather strange.  On line 859,
> > a for loop determines the number of pages needed for the copying of
> > the user data to kernel space.  Then the memory is allocated (line
> > 886 bio_kmalloc()).  Then, strangely, on line 895, there is this
> > conditional:
> 
> This is because the function can also be used with preallocated pages,
> a feature only used by the sg and tape drivers.
> 
> Make sure your user memory is 4k aligned, and you should be able to
> avoid the copy entirely (1).

Where is this 4k alignment being enforced?  When sg_start_req calls to
blk_rq_map_user_iov, the only check for alignment is that the data buffers
are 4-byte aligned (q->dma_alignment == 3).  I have verified that they are.

> 
> (1) except that the sg driver disables the direct mapping of user pages
>     when using readv/writev.  I can't really see why and it should be
>     fixable by just removign that condition from the if in
> sg_start_req.

I am investigating this now.

>     Alternatively use the SG_IO ioctl directly on the disk device node,
>     which neither has the read/writev limitation, nor does it use
>     a fixed upper bound preallocated page pool.

Unfortunately, the write/read interface of sg is what I need to use for
asynchronous reasons.
