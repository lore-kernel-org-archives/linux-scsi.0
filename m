From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Query to optimize PageCache size in system
Date: Thu, 14 May 2009 22:00:15 +0100
Message-ID: <20090514210015.GD20363@shareable.org>
References: <e42309110905130732xf4313a6qba1f30a2d89728be@mail.gmail.com> <e42309110905130805r135c3373xa6ecda0e45180d34@mail.gmail.com> <20090513155444.GF15360@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:44332 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZENVAU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2009 17:00:20 -0400
Content-Disposition: inline
In-Reply-To: <20090513155444.GF15360@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ravish Tayal <ravish.tayal@gmail.com>, linux-arm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-usb@vger.kernel.org, ravish.tayal@conexant.com

Matthew Wilcox wrote:
> On Wed, May 13, 2009 at 08:35:52PM +0530, Ravish Tayal wrote:
> > I am looking for help to reduce the number of cached pages in the
> > system. I am using 2.6.12 linux kernel on ARM processor.for my
> > embedded USB mass storage application.
> 
> Why do you think the number of cached pages is a problem?  What problem
> are you experiencing that you think is caused by having a large number
> of cached pages?

Ravish didn't say if this applies, but cached pages are a problem on
NOMMU platforms because they cause severe placement-fragmentation of
other memory allocations including userspace allocations, and since
those all must be physically contiguous, it's a problem.

> > 3. Is there any provision in linux kernel through which I can restrict
> > the new page allocation for disk operation to not to be added in the
> > page-cache  ?
> > 4. If I open the file with O_DIRECT Flag would page_cache be avoided,
> > irrespective it is file read or File write operations?
> 
> Question 4 appears to be the answer to question 3.  O_DIRECT works for
> both reads and writes, but does have restrictions on alignment.

In theory there are some fadvise calls as an alternative, but I don't
know if they work.

There was also a patch posted a few months ago to limit the amount of
memory used for file page cache to a fraction of the total memory.
That might work.

A better solution to avoid fragmentation is crudely segregating file
cache pages from other allocations.  That's roughly what 2.4 NOMMU
kernels do, but 2.6 doesn't have the option.  (It has other problems
anyway).

-- Jamie
