From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add compat_ioctl to st
Date: Tue, 18 Jan 2005 12:54:59 +0000
Message-ID: <20050118125459.GO30982@parcelfarce.linux.theplanet.co.uk>
References: <20050118110613.GC43344@muc.de> <20050118122524.GN30982@parcelfarce.linux.theplanet.co.uk> <20050118123024.GA68224@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:19885 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261286AbVARMzA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 07:55:00 -0500
Content-Disposition: inline
In-Reply-To: <20050118123024.GA68224@muc.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: Matthew Wilcox <matthew@wil.cx>, James.Bottomley@SteelEye.com, Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org

On Tue, Jan 18, 2005 at 01:30:24PM +0100, Andi Kleen wrote:
> > How about having a macro ...
> > 
> > 	.ioctl =	st_ioctl,
> > 	COMPAT_IOCTL_ENTRY(st_compat_ioctl)
> > 	.open =		st_open,
> > 
> > which could be defined something like:
> > 
> > #ifdef CONFIG_COMPAT
> > #define COMPAT_IOCTL_ENTRY(x)	.compat_ioctl = x,
> > #else
> > #define COMPAT_IOCTL_ENTRY(x)	/* */
> > #endif
> 
> To be honest I prefer the ifdef. It makes it clear 
> what is going on, without any unneeded abstraction.
> The macro in comparison looks unnatural in the definition
> block.

It would have prevented the mistake you made in sg (which message I only
read after writing this).  Another way of managing without ifdefs would
be:

	.compat_ioctl = COMPAT_IOCTL_ENTRY(st),

with

#ifdef CONFIG_COMPAT
#define COMPAT_IOCTL_ENTRY(x)	x##_compat_ioctl
#else
#define COMPAT_IOCTL_ENTRY(x)	NULL
#endif

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
