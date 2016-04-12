From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] IB/iser: set max_segment_size
Date: Tue, 12 Apr 2016 18:51:30 +0200
Message-ID: <20160412165130.GB9568@lst.de>
References: <1460470405-11673-1-git-send-email-hch@lst.de> <1460470405-11673-3-git-send-email-hch@lst.de> <570D156B.7010206@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34123 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757206AbcDLQvd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2016 12:51:33 -0400
Content-Disposition: inline
In-Reply-To: <570D156B.7010206@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Apr 12, 2016 at 08:34:03AM -0700, Bart Van Assche wrote:
> Hello Christoph,
>
> ib_sg_to_pages() can handle segments that are larger than mr->page_size. 

The interface handles it fine, but we'll still end up using a segment
per (MR) page.

> Have you considered to set queue_limits.max_hw_sectors instead of 
> max_segment_size?

That's what NVMe does, but I don't think it's a good idea.  Because
of the unaligned start into the page this means you have to set the limit
to one lower than the actual hardware limit.
