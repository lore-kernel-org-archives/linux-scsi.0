From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ST alloc failures
Date: Fri, 2 Apr 2004 07:32:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040402073207.A31736@infradead.org>
References: <20040402051355.GA1604@frodo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:45070 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263227AbUDBGcK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 01:32:10 -0500
Content-Disposition: inline
In-Reply-To: <20040402051355.GA1604@frodo>; from nathans@sgi.com on Fri, Apr 02, 2004 at 03:13:55PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Nathan Scott <nathans@sgi.com>
Cc: linux-scsi@vger.kernel.org

[linux-scsi is the right list for st problems, moving the thread there]

On Fri, Apr 02, 2004 at 03:13:55PM +1000, Nathan Scott wrote:
> Hi all,
> 
> I'm seeing a bunch of large allocation attempts failing from
> the SCSI tape driver when doing dumps and restores ... (this
> is with a stock 2.6.4 kernel).
> 
> xfsdump: page allocation failure. order:8, mode:0xd0
> Call Trace:
>  [<c013982b>] __alloc_pages+0x33b/0x3d0
>  [<c03805ac>] enlarge_buffer+0xdc/0x1b0
>  [<c03819a3>] st_map_user_pages+0x33/0x90
>  [<c037cf24>] setup_buffering+0xb4/0x160

This looks like the driver tries to pin down the userpages first
(st_map_user_pages) but then fails and needs to use an inkernel
buffer.  Can you put some debug printks into st_map_user_pages
to see why it fails?  The actual message is harmless, it's the
same thing we had in the XFS log code:  It tries to allocate
an as large as possible buffer and if that fails tries the next
smaller power of two size.  We should probably add an __GFP_NOWARN
here.

