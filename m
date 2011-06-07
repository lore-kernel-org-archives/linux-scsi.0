From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT] isci: towards the v3.0 merge candidate
Date: Tue, 7 Jun 2011 10:53:15 +0200
Message-ID: <20110607085315.GA3794@lst.de>
References: <1307408765.11482.40.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48982 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab1FGIxQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2011 04:53:16 -0400
Content-Disposition: inline
In-Reply-To: <1307408765.11482.40.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Jeff Garzik <jeff@garzik.org>, Dave Jiang <dave.jiang@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, sfr@canb.auug.org.au, David Milburn <dmilburn@redhat.com>, hare@suse.de

On Mon, Jun 06, 2011 at 06:06:05PM -0700, Dan Williams wrote:
> The libsas-pending, x86-pending, and subsequently upstream-pending
> branches are now closed with the inclusion of v3.0-rc2 into 'master'.

Can you generate a tree without the merge commits?

> Conspicuously missing is significant progress toward the request to
> merge the isci_ and scic_sds_ level of data structures.  This is mainly
> due to taking a break on the cleanups to knock down bugs and missing
> features, but it also comes back to biting the bullet on more rename
> thrash.  Patches like "isci: remove 'min memory' infrastructure" give me
> pause because they indicate we still have work to do on clarifying the
> data structures and shrinking the number of members (the meat / hard
> work of the cleanup).  A rename is icing (still necessary) at this
> point, but working on closing out bugs before going down that road.
> 
> Questions / suggestions on how to proceed on the cleanup versus bug
> fixing for the 3.0 merge are welcome.

I think we really need to get the main data structures and the naming sorted
out.  Also the development process really would benefit from more frequent
posting of updates.

> Adam Gruchala (1):
>       isci: Added support for C0 to SCU Driver

Please make the silicon revision per-pdev.  Even if you only happen to
one in any given system now this is plain ugly.

> 
> Dan Williams (3):
>       Revert "isci: Add missing PCI IDs"
>       isci: remove 'min memory' infrastructure
>       isci: use pci_map_biosrom
> 
> Dave Jiang (3):
>       isci: removing the kmalloc in smp request construct
>       isci: Retrieve the EFI variable for OEM parameter
>       isci: Removing unused variables compiler warnings
> 
> Edmund Nadolski (10):
>       isci: replace isci_timer list with proper embedded timers

Please don't add those sci_timer wrappers.  del_timer already makes
sure it is cancelled, it just doesn't wait for the execution of
previous timers, so your additional cancel flag doesn't buy anything.


Btw, what bugfixes have you been looking into?  There's basically none
in this update, and given the time it took to get this one out there's
not a whole lot of things in it at all.

>     Revert "isci: Add missing PCI IDs"
>     
>     This reverts commit c2af8ba9.  These ids are reserved for 3rd party
>     vendors to deploy their own drivers.

This sounds wrong.  It's probably the same crap we had with all kinds of
Intel and other vendor cards where some OEM adds value by providing fake
raid and a driver of it's own.  Care to explain how not supporting them
benefits the user?

