From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] convert sg to blk_rq map functions
Date: Mon, 15 Aug 2005 15:06:27 -0500
Message-ID: <4300F5C3.1080006@cs.wisc.edu>
References: <1123562301.6090.14.camel@max> <43008AA4.6000002@torque.net> <4300F49C.3000404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:3498 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964916AbVHOUGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 16:06:52 -0400
In-Reply-To: <4300F49C.3000404@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Mike Christie wrote:
> 
> Block layer defines the max segment size as 65536. We need
> new block layer helpers to do the mapping. Although one late night
> I thought I could use a modified blk_rq_map_kern some how. If sg or
> st allocate the reserve buffers then we could make a

oops, I meant sg or st would allocate the reserves or huge
buffers/pages/segments using some block layer helper becuase the
block layer knows the segment and size limits a little better. But
the sg or st driver would pass in the reserves to the block layer
mapping function similar to how we can pass in bio_sets to the bio code.

> blk_rq_map_kern_iovec function that worked similar to its
> user cousin but of course operated on a iovec of kernel buffers.
> But then I am not sure if at that point we should just be
> interacting with the bio code directly instead of adding a
> extra iovec abstraction. I would guess for SCSI drivers at least
> it is nicer to not worry about bio internals though. James
> and Jens would konw best though.
> 
> 
