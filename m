From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH, RFC] st: start using scsi_execute
Date: Mon, 30 Jan 2006 15:45:35 -0600
Message-ID: <43DE88FF.60102@cs.wisc.edu>
References: <20060130182324.GA6253@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:7843 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932302AbWA3Vpp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 16:45:45 -0500
In-Reply-To: <20060130182324.GA6253@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> This patch updates st to use scsi_execute instead of scsi_execute_async
> for all scsi commands except the main I/O path.  The advantage is that
> these helpers do all the request tracking for these synchronous I/Os so
> that there is no need for st_request structures.  It also decouples
> these helper scsi commands from the main tape buffer, allowing for an
> easier switchover to the generic block request mapping routines for the
> main I/O path later on.
> 

I guess I messed that up. I am not sure why I went with 
scsi_execute_async for st.

But in my past attempts to convert these drivers to the block layer I 
was trying to make some nice function like scsi_execute and friends 
where the ULD does not have to worry about setting up any structure. 
Instead, we could have st and sg use the block layer functions directly 
like how block/scsi_ioct.c does. So the ULD would get a request, fill 
out the necessary fields, call blk_rq_map_user and call blk_execute*. Is 
is better to have a scsi API that sets things up for the ULDs or is the 
abstraction not worth it?
