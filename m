From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid changes for 2.4.24 kernel to add support of AMD64 (part 2)
Date: Fri, 13 Feb 2004 23:04:00 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040213230400.B21467@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552B8@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:56331 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267276AbUBMXEC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 18:04:02 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552B8@otce2k03.adaptec.com>; from mark_salyzyn@adaptec.com on Fri, Feb 13, 2004 at 05:37:44PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Feb 13, 2004 at 05:37:44PM -0500, Salyzyn, Mark wrote:
> [MGS] The ioctl that utilizes this structure detects if the caller is a
> 32 bit or a 64 bit application under the AMD64 environment, and tunes
> itself to the size of the fib element as necessary. I opted to use the
> redefinition of this structure as a means to simplify the split
> personality code that utilizes this structure.
> 
> In a 32 bit environment, there is no need to detect if the caller is a
> 32 bit or a 64 bit application, so the smaller fib element is all that
> is needed.

	Well..  What about ia64 or ppc64 or mips64 or..?  There's much
	more than PCs out there. 

> [MGS] Without any test of busy status at all, we run the *high* risk of
> a panic resulting from a stack overflow. This code is here because of a
> broken error recovery in the scsi layer resulting in infinite recursion
> under some sensitive activities.

	You mean the thing rmk fixed?  If that's still not in 2.4 it's
	rather sad indeed..  If you mean something else please explain
	it to the list, a patch would be even better.

> Fix the scsi layer, and this code can go away.

	Some cooperation from vendors could also help ;-)

> [MGS] Ok, tell me how to rescan for a device? The RAID drivers cause
> asynchronous device changes that need to be reported to the scsi layer.
> The scan_scsis call is hidden, so we *must* use the proc write to get to
> it.

	DO NOT DO IT.  Even from userland.  /proc/scsi/scsi's dubious
	scan interface existing is more than bad enough and a _big_
	mistake from the people writing the original linux scsi code.
	But at least we canb blame it on those peopl brave enough.

	But in addition top the rescan beeing bogus opening files from
	kernelspace and writing to them is simply not allowed.

> Or do you mean the arrangements for register_ioctl32_conversion? Because
> other drivers do not have 32 bit applications calling a 64 bit ioctl for
> RAID management functions. The current structure of the x86_64 port in
> the 2.4 tree is to block 32 bit applications from calling the ioctl
> without these arrangements.

	There's quite a lot of drivers using register_ioctl32_conversion
	that don't seem to need it.  But I don't have an x86-64 box so
	don't ask me for details.  It just looked more than strange..

