From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Suggestion for aiding debugging of host removal
Date: Wed, 10 Dec 2003 15:14:56 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031210151456.A2927@infradead.org>
References: <20030709144410.GA3544@beaverton.ibm.com> <Pine.LNX.4.44L0.0312100947550.775-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:8197 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263618AbTLJPPF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2003 10:15:05 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0312100947550.775-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Wed, Dec 10, 2003 at 10:02:22AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Dec 10, 2003 at 10:02:22AM -0500, Alan Stern wrote:
> Mike:
> 
> I've got a question about host removal.  Once scsi_remove_host() has
> returned, the host driver's module is free to unload from memory (assuming
> the module's reference count is 0, which it normally is).  Hence it is a
> mistake to access the host template in any way after that time.
> 
> But it looks like scsi_host_dev_release() can be called after
> scsi_remove_host() has returned, and it uses shost->hostt.  There may be 
> other uses as well.
> 
> Would it help flush out such illegal accesses if at some appropriate point 
> shost->hostt was set to NULL, maybe near the end of scsi_remove_host()?

In fact that's a bug in the current scsi_host lifetime handling - before
the driver can leave it's upper layer ->remove function we need to wait
to the host refcount to become zero, similar to what free_netdev does.

I'll see whether I can come up with a fix.

