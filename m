From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: DPC vs tasklet
Date: Thu, 20 May 2004 18:03:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040520180339.A10148@infradead.org>
References: <8D43EFD7CCBDB24980134BE078C227E704E37AEB@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:44045 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265225AbUETRDl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 13:03:41 -0400
Content-Disposition: inline
In-Reply-To: <8D43EFD7CCBDB24980134BE078C227E704E37AEB@xcm.emulex.com>; from Jon.Infante@Emulex.Com on Thu, May 20, 2004 at 09:52:25AM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Infante, Jon" <Jon.Infante@Emulex.Com>
Cc: "Smart, James" <James.Smart@Emulex.Com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Thu, May 20, 2004 at 09:52:25AM -0700, Infante, Jon wrote:
> I was going to take your advice:
> "usage of tasklet itself is questionable, you probably want a kernel-thread"
> 
> and redo our driver bottom half discovery handler to use a DPC. I just
> wanted to get your opinion of why usage of a tasklet is questionable. Some
> of the LINUX documentation I've read states "tasklets are the preferred
> mechanism with which to implement your bottom half for a normal hardware
> device". I can see, as you stated, being in user context will help with
> things like allowing the use of GFP_KERNEL for memory allocations or safe
> calling of del_timer_sync(); but its not real clear to me what all the
> tradeoffs are and why some people think tasklets are the preferred
> mechanism. Can you shed some more light on this or direct me to some URLs
> with more info.

tasklets run at softirq time which means you don't want to do too much
work there, in addition to making locking and memory allocation more
difficult for you.  Given that you're doing lots of processing in there
a kernel thread seems like the better choice.  The kernelthread also
has the advtantage that you can bind it to the cpu the irq happens on
to avoid lots of cacheline bouncing.

In the end you probably want to benchmark the different variants against
each other.
