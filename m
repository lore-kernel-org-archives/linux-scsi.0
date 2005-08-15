From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] convert sg to blk_rq map functions
Date: Mon, 15 Aug 2005 15:01:32 -0500
Message-ID: <4300F49C.3000404@cs.wisc.edu>
References: <1123562301.6090.14.camel@max> <43008AA4.6000002@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:1450 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964907AbVHOUB5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 16:01:57 -0400
In-Reply-To: <43008AA4.6000002@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> 
> sg_io_hdr::info could be used to indicate whether DIO
> was done or not (as is the present case in sg).
> 
> But if you are changing things, why not follow the
> user supplied O_DIRECT open() flag?

It was only becuase the block layer functions that the
SG_IO code used to map a block layer request/bio defaulted
to the zero copy code. I added a extra argument to override this
so I could support the sg_io_hdr::info flag but had not
implemented it yet. I only used the extra argument to support
the old inteface's copy_to_user behavior.

Would you prefer that I support O_DIRECT, sg_io_hdr::info,
defualt to zero_copy if it is possible, or some combination?
I mean can I drop sg_io_hdr::info or would it be ok if
I do not support O_DIRECT right away since the patch is
kinda large.


> 
> 
>>- Always obey LLD queue restrictions.
> 
> 
> Depends which ones :-)

Yeah ok :) I just meant becuase it used the block layer
code to build the scatter list it checked all the queue limits
that the block layer tested for which sg had missed previously.

> 
>>- Rely on block layer reserves and bio bounce buffer for
>>memory allocations.
> 
> 
> Do block layer reserves cope with elements greater
> than a PAGE_SIZE? 

There are actually no resrves for the buffer today. This
is something that dm-multipath (well the userspace part needs it
when it uses SG_IO for failover and failback) needs and something
I intened to add while doing the upper layer scsi drivers becuase
st also needs what you describe below. It will allocate a
large buffer with alloc_pages, assume the LLD supports clustering,
then build a request's scatterlist with huge segments.

The structures like requests, bios, etc are using mempools.

One feature of the current sg driver
> is that it can send a single request greater than
> max_scatg_elems*PAGE_SIZE. The sg driver uses scatg
> elements of 32 KB for a maximum size of 8 MB per transfer
> (if max_scatg_elems is 256). Some folks out there
> increase the 32 KB per scatg element by increasing
> the SG_SCATTER_SZ define in sg.h .
> Are "huge" pages a possibility here?

Block layer defines the max segment size as 65536. We need
new block layer helpers to do the mapping. Although one late night
I thought I could use a modified blk_rq_map_kern some how. If sg or
st allocate the reserve buffers then we could make a
blk_rq_map_kern_iovec function that worked similar to its
user cousin but of course operated on a iovec of kernel buffers.
But then I am not sure if at that point we should just be
interacting with the bio code directly instead of adding a
extra iovec abstraction. I would guess for SCSI drivers at least
it is nicer to not worry about bio internals though. James
and Jens would konw best though.


Thanks for alll the info. It will be very helpful.
