From: Andrew Morton <akpm@digeo.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: Fri, 31 Jan 2003 12:44:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030131124412.086f2d1c.akpm@digeo.com>
References: <20030129104731.A2811@beaverton.ibm.com>
	<3E382E2C.4030201@splentec.com>
	<20030129121117.A3389@beaverton.ibm.com>
	<20030130225738.1874c2e0.akpm@digeo.com>
	<1044020591.2002.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id MAA29921
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jan 2003 12:41:51 -0800 (PST)
In-Reply-To: <1044020591.2002.16.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: patmans@us.ibm.com, luben@splentec.com, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@steeleye.com> wrote:
>
> On Fri, 2003-01-31 at 01:57, Andrew Morton wrote:
> > Please do not reinvent the mm/mempool.c functionality.
> > 
> > 'twould be better to just use it ;)
> 
> Unfortunately, in this instance, mempool is a slight overkill.  The
> problem is that we need to guarantee that a command (or set of commands)
> be available to a given device regardless of what's going on in the rest
> of the system.  Thus we might need a mempool for each active device,
> rather than a mempool for all devices and a mechanism for giving fine
> grained control to the pool depth per device.

A lot depends on the context of the allocation.  Can the caller sleep?
Is the caller using GFP_ATOMIC/__GFP_HIGH?

(What file-n-line should I be looking at, anyway?)

Bear in mind that on the swapout path, the calling process has PF_MEMALLOC
set.  This is a strong and successful mechanism - it allows the caller to dip
into the final page reserves which are denied to even GFP_ATOMIC allocations.
There's maybe a megabyte or two there.

Could be that there's no problem to be solved here.  It depends on whether
these allocations are occurring in process context or not.

>  Mempool would fit all of
> the above, I was just concerned that it looks to be a rather heavy
> addition (in terms of structure size) per device.

It's 40-odd bytes, plus 4*max_reservation bytes.  Fairly lean.
