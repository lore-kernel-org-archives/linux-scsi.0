From: Dave Boutcher <sleddog@us.ibm.com>
Subject: Re: [PATCH] ibmvscsi driver - next version
Date: Mon, 23 Feb 2004 13:41:36 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <opr3t8zmyel6e53g@us.ibm.com>
References: <opr3s2iefyl6e53g@us.ibm.com> <20040223144542.A9624@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:45998 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262011AbUBWTmK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 14:42:10 -0500
In-Reply-To: <20040223144542.A9624@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Chrisoph,

Thanks for the fast revew!!!  I'll get a new version out today.  A couple 
of comments on comments...

On Mon, 23 Feb 2004 14:45:42 +0000, Christoph Hellwig <hch@infradead.org> 
wrote:
> +#include <linux/module.h>
> +#include <scsi/scsi_device.h>
> +#include "ibmvscsi.h"
>
> 	any reason you hid all headers in ibmvscsi.h?  normally we include
> 	them in the source files directly.

Philosophy question....I usually assume that a header file should in turn 
include anything it needs...so ibmvscsi.h includes all the scsi header 
files it uses...bad philosophy?

> +	/* If we can't find this event, just return false */
> +	if (found_evt == NULL) {
> +		printk(KERN_ERR "ibmvscsi: failed to abort command\n");
> +		return FAILED;
> +	}
>
> 	This can't ever happen.  You will only get called for commands
> 	that you have accepted in queuecommand and not called the completion
> 	routine for.

The above code was in the abort routine....I would personally prefer to 
leave the check in there from pure paranoia.  If we are into aborts, bad 
things are happening, and I don't really care about code path in 
abort...perhaps I should add a "this should never happen" comment? :-)  I 
could make it a BUG()...I'm not a huge fan of BUG() in drivers...

> +/**
> + * This stub is needed by ibmvscsi
> + */
> +void ibmvscsi_task(unsigned long data)
> +{
> +}
>
> 	I think you should just set up the task in the rpa subdriver
> 	when it's not needed by the iseries one.

The INIT_WORK call needs to be done before we get back to the subdriver in 
case the first message gets turned around really fast.  Having this stub 
seemed the cleanest way to handle that generically.

Dave B

