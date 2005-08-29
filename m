From: Greg KH <greg@kroah.com>
Subject: Re: 2.6: how do I this in sysfs?
Date: Mon, 29 Aug 2005 15:32:11 -0700
Message-ID: <20050829223211.GA17088@kroah.com>
References: <D4CFB69C345C394284E4B78B876C1CF10ABB0269@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.com ([216.218.225.136]:9112 "HELO kroah.com")
	by vger.kernel.org with SMTP id S1751376AbVH2WcV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 18:32:21 -0400
Received: from storm.he.net ([127.0.0.9]) by kroah.com for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2005 15:32:11 -0700
Content-Disposition: inline
In-Reply-To: <D4CFB69C345C394284E4B78B876C1CF10ABB0269@cceexc23.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mochel@osdl.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>, "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>, Luben Tuikov <luben_tuikov@adaptec.com>

On Mon, Aug 29, 2005 at 12:24:18PM -0500, Miller, Mike (OS Dev) wrote:
> 
> > This is after my minimal sas transport class, please also 
> > read the thread about it on linux-scsi
> > 
> In the referenced code for using sysfs, there only appear to be methods
> for reading attributes.  How about if we want to cause a command to
> get written out to the hardware?   Do we do something like this?
> 
>         /* get a semaphore keep everyone else out while we're working,
>            and hope like hell that all the other processes are playing
>            nice and using the semaphore too, or else we're hosed. */
> 
>         get_some_kind_of_semaphore();

try flock() on the /sys/blah/blah/ directory.  That should keep userspace happy.  
I think it only takes a small sysfs patch to make this work (or it might work
today, don't remember, sorry...)

Or look into using configfs instead.

thanks,

greg k-h
