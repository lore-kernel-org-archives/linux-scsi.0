From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ibmvscsi driver - next version
Date: Mon, 23 Feb 2004 19:49:13 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040223194913.A13181@infradead.org>
References: <opr3s2iefyl6e53g@us.ibm.com> <20040223144542.A9624@infradead.org> <opr3t8zmyel6e53g@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:23824 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262018AbUBWTtO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 14:49:14 -0500
Content-Disposition: inline
In-Reply-To: <opr3t8zmyel6e53g@us.ibm.com>; from sleddog@us.ibm.com on Mon, Feb 23, 2004 at 01:41:36PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Dave Boutcher <sleddog@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, Feb 23, 2004 at 01:41:36PM -0600, Dave Boutcher wrote:
> > 	any reason you hid all headers in ibmvscsi.h?  normally we include
> > 	them in the source files directly.
> 
> Philosophy question....I usually assume that a header file should in turn 
> include anything it needs...so ibmvscsi.h includes all the scsi header 
> files it uses...bad philosophy?

If you actually need them you need to include them.  But in ibmvscsi.h
I only see pointers to the scsi datastructures - for those a simple
forward-declaration is enough.


> > 	This can't ever happen.  You will only get called for commands
> > 	that you have accepted in queuecommand and not called the completion
> > 	routine for.
> 
> The above code was in the abort routine....I would personally prefer to 
> leave the check in there from pure paranoia.  If we are into aborts, bad 
> things are happening, and I don't really care about code path in 
> abort...perhaps I should add a "this should never happen" comment? :-)  I 
> could make it a BUG()...I'm not a huge fan of BUG() in drivers...

Just remove it.  If you don't trust the midlayer it's hard to write
a scsi driver..

> The INIT_WORK call needs to be done before we get back to the subdriver in 
> case the first message gets turned around really fast.  Having this stub 
> seemed the cleanest way to handle that generically.

Why can't you simply do it in ibmvscsi_init_crq_queue for example?

