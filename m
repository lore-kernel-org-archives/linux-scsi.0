From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: 2.6.8-rc3-mm2:  Debug: sleeping function called from invalid context at mm/mempool.c:197
Date: Mon, 9 Aug 2004 23:59:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040809235929.A11498@infradead.org>
References: <20040809153740.3dd31e2b.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:54541 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267330AbUHIW7e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2004 18:59:34 -0400
Content-Disposition: inline
In-Reply-To: <20040809153740.3dd31e2b.akpm@osdl.org>; from akpm@osdl.org on Mon, Aug 09, 2004 at 03:37:40PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Janet Morgan <janetmor@us.ibm.com>

On Mon, Aug 09, 2004 at 03:37:40PM -0700, Andrew Morton wrote:
> 
> qla2x00_get_new_sp() does a GFP_KERNEL allocation on the IO submission
> path.  That can cause recursion into already-held filesystem and VFS locks,
> so at the very least the allocation should be GFP_NOIO.
> 
> But even that is wrong, because some lock is held - probably the queue lock.
> 
> iow: it's all screwed up.  Is there any fix which is less lame than
> replacing the GFP_KERNEL with GFP_ATOMIC?

Unfortunately not.  As seen in that stacktrace there's a case where ->queuecommand
can be called from softirq context.

