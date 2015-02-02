From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block layer copying user io vectors
Date: Mon, 2 Feb 2015 02:00:34 -0800
Message-ID: <20150202100034.GB26503@infradead.org>
References: <60F6FAE47D1BCE4380CC06D18F49789B952F7ED3@NTXBOIMBX02.micron.com>
 <20150123170627.GA8652@infradead.org>
 <60F6FAE47D1BCE4380CC06D18F49789B95301D66@NTXBOIMBX02.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <60F6FAE47D1BCE4380CC06D18F49789B95301D66@NTXBOIMBX02.micron.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Andy Falanga (afalanga)" <afalanga@micron.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 30, 2015 at 05:43:04PM +0000, Andy Falanga (afalanga) wrote:
> > > This function does something that seems rather strange.  On line 859,
> > > a for loop determines the number of pages needed for the copying of
> > > the user data to kernel space.  Then the memory is allocated (line
> > > 886 bio_kmalloc()).  Then, strangely, on line 895, there is this
> > > conditional:
> > 
> > This is because the function can also be used with preallocated pages,
> > a feature only used by the sg and tape drivers.
> > 
> > Make sure your user memory is 4k aligned, and you should be able to
> > avoid the copy entirely (1).
> 
> Where is this 4k alignment being enforced?  When sg_start_req calls to
> blk_rq_map_user_iov, the only check for alignment is that the data buffers
> are 4-byte aligned (q->dma_alignment == 3).  I have verified that they are.

Indeed, I though we had the more strict direct I/O alignment.

Still doesn't help because the sg driver refuses to directly map user
pages for vectored I/O.
