From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as33b) Remove /proc/scsi directory in scsi_remove_host()
Date: Fri, 13 Jun 2003 10:38:04 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0306131031100.760-100000@ida.rowland.org>
References: <20030612215858.GB3281@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3844 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265404AbTFMOYR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2003 10:24:17 -0400
In-Reply-To: <20030612215858.GB3281@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 12 Jun 2003, Mike Anderson wrote:

> Alan,
> 	This looks good. In scsi-misc-2.5 SHT has been removed so there
> 	will need to be a little name sync up. 

That shouldn't be difficult.

> 	I also had a patch that I was working on that removed the users
> 	of "->present" and just left the procfs users. This might be a
> 	good one to add on top of this patch.

I agree.

> 	We still have the issue outside of what this patch was trying
> 	to address with the proc_read/proc_write functions racing with
> 	the remove_proc_entry, but in previous statements this will
> 	currently be left as is for this obsolete interface.

That sounds like the right thing to do.  This is a generic problem with 
procfs (maybe sysfs too).  I think the only way to solve it is to add 
"open" and "close" routines that would increment/decrement a reference 
count for the host structure.  Delaying the kfree of the structure until 
the reference count goes to 0 would prevent anything bad from happening 
when scsi_unregister() is called while some process still has the file 
open.

But since this is an obsolete interface anyway, it's probably not worth 
going to all that trouble.

Alan Stern

