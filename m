From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Some plans for scsi_cmnd
Date: Tue, 25 Sep 2007 14:47:50 +0100
Message-ID: <20070925134750.GA21930@infradead.org>
References: <20070925133733.GT10625@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53484 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXIYNrv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 09:47:51 -0400
Content-Disposition: inline
In-Reply-To: <20070925133733.GT10625@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 25, 2007 at 07:37:33AM -0600, Matthew Wilcox wrote:
> 2. Thanks to a thinko, we also discussed the upper-layer ->done.  We think
> it should be feasible to move this from the scsi_cmnd to the scsi_device
> since sg doesn't use it.

I suspect putting it into the scsi_driver would be even better.

> 3. We also discussed scsi_pointer.  It's really quite crufty, and it
> gets recycled for storing all kinds of things.  The ambitious plan here
> is to change the whole way scsi_cmnds are allocated.  Code is clearer
> than my description ...
> 
> sym2.c:
> 
> struct sym2_cmnd {
> 	struct scsi_cmnd cmd;
> 	int Phase;
> 	char *data_in;
> }
> 
> struct scsi_host_template sym2_template {
> 	.cmnd_size = sizeof(sym2_cmnd);
> }

I'd prefer to add alloc_mnd and destroy_cmnd methods as per struct
inode.  That also allows drivers to do things like dma_pool allocations
ahead of time and not worry about needing to do this kind of allocations
from softirq context which is at least theoretically deadlockable
without emergency pool schemes.

