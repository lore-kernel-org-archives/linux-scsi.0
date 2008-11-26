From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Fix SCSI regression in 2.6.27 [was [Bugme-new] [Bug
 12099] New: Nokia 5310 storage-mode]
Date: Wed, 26 Nov 2008 10:01:47 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811260957470.2359-100000@iolanthe.rowland.org>
References: <1227676067.3415.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39699 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751796AbYKZPBs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 10:01:48 -0500
In-Reply-To: <1227676067.3415.63.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, stable@kernel.org

On Tue, 25 Nov 2008, James Bottomley wrote:

> On Tue, 2008-11-25 at 10:34 -0500, Alan Stern wrote:
> > This patch is intended for 2.6.27.stable and 2.6.28.  It's a temporary 
> > fix for a problem affecting a number of USB mass-storage devices 
> > (including many Nokia phones): When trying to access a nonexistent 
> > "last" sector, the SCSI midlayer gets caught in an endless retry loop.
> 
> Can't we just invoke the last sector handling flag for all Nokia
> devices?

That would work for those devices... until and unless Nokia ever 
decides to correct their bug.  It won't help anything else.

> This would cause tape errors on unit attention (fairly common
> condition).  It can be argued that we get more users of USB mobile
> phones than tapes, but I'd rather keep both communities happy

Me too.  I realize this patch hasn't been tested or vetted by anyone in
the SCSI development crowd.  That's why I've been pestering you guys
about it!

> By and large, the reason we backport from head if at all possible is so
> we can avoid bugs like this creeping into stable.  (And backporting from
> head is far easier if the bug fixes are small and don't contain
> miscellaneous code clean ups, control flow changes and comment fixes)

> I tried to untangle it on the 'plane yesterday.  I've just got a bit
> more testing to do then I'll post the patch to your patch.

That's fine with me.  I just don't want to see the same problem 
continuing on into 2.6.28.final.

Alan Stern

