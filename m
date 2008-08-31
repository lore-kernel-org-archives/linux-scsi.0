From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi/sd: Fix capacity output to show MB/GB/TB/...
Date: Sat, 30 Aug 2008 20:54:12 -0600
Message-ID: <20080831025412.GJ1239@parisc-linux.org>
References: <48B9546B.4010004@simon.arlott.org.uk> <1220117091.3615.3.camel@localhost.localdomain> <20080830174516.GD1239@parisc-linux.org> <48B9B552.8060406@simon.arlott.org.uk> <48B9B588.7060709@simon.arlott.org.uk> <1220147947.3615.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57594 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYHaC4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Aug 2008 22:56:00 -0400
Content-Disposition: inline
In-Reply-To: <1220147947.3615.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Aug 30, 2008 at 08:59:07PM -0500, James Bottomley wrote:
> However, I'm afraid it needs to be a bit more sophisticated:  for
> instance, under these calculations, a 1.75TB disk will show up as 1TB.
> Thus, I think we need to print the capacity to 3 significant figures to
> cope with this case.

Do you have an objection to my original suggestion of 1750GB in that
case?  It saves faffing around with fractions and it's unlikely to
confuse the user.

BTW, I do appreciate Simon's point about df showing a different number.
How about we print:

sd 7:0:0:0: [sdc] 1099511627776 512-byte hardware sectors (563TB / 512TiB)

(or perhaps a more realistic number ...)

sd 7:0:0:0: [sdc] 976562500000 512-byte hardware sectors (500TB / 455TiB)

It's perhaps a more gentle way of informing our users that they may not
have quite as much capacity as they thought they had.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
