From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: [PATCH] fix warnings in new compat code for scsi
Date: Fri, 4 Feb 2005 02:54:47 +0000
Message-ID: <20050204025447.GH8859@parcelfarce.linux.theplanet.co.uk>
References: <1107484762.5502.41.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:32913 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262152AbVBDCyt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2005 21:54:49 -0500
Content-Disposition: inline
In-Reply-To: <1107484762.5502.41.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andi Kleen <ak@muc.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Feb 03, 2005 at 08:39:22PM -0600, James Bottomley wrote:
> I just got around to applying and testing this.  I needed the attached
> to get around the compile warnings it gave me on ia64
> 
> I've got to say, it doesn't look pretty to have the block layer
> compat_ioctl returning long but the scsi one returning int; likewise
> with the void __user *arg vs unsigned long arg.

Seconded.  Use of long is utter idiocy:
	a) ioctl(2) is declared as int in userland headers
	b) ->ioctl() returns int
	c) ->compat_ioctl() is supposed to emulate ->ioctl() of 32bit
platform, for fsck sake!  Even if none of the above would apply, it
would _still_ be 32bit.

And the first two reasons apply to ->unlocked_ioctl() as well.  Could we
please undo that bright decision until it's too late?  I can do patches
for that in by tomorrow morning...
