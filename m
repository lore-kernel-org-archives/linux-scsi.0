From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sg regression in 2.6.16-rc5
Date: Wed, 01 Mar 2006 16:30:35 -0600
Message-ID: <1141252235.3276.63.camel@mulgrave.il.steeleye.com>
References: <E94491DE-8378-41DC-9C01-E8C1C91B6B4E@mac.com>
	 <4404AA2A.5010703@torque.net> <20060301083824.GA9871@merlin.emma.line.org>
	 <Pine.LNX.4.64.0603011027400.22647@g5.osdl.org>
	 <4405F6F1.9040106@torque.net>  <1141245769.9586.6.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:55189 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751329AbWCAWbI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 17:31:08 -0500
In-Reply-To: <1141245769.9586.6.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: dougg@torque.net, Linus Torvalds <torvalds@osdl.org>, Matthias Andree <matthias.andree@gmx.de>, Mark Rustad <mrustad@mac.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, 2006-03-01 at 14:42 -0600, Mike Christie wrote:
> The current sg driver should use alloc_pages() with an order that should
> get 32 KB. If the order being passed to alloc_pages() in sg.c is only
> getting one page by default that is bug.

> The generic routines now being used can turn that 32KB segment into
> multiple 4KB ones if the LLD does not support clustering.

To be honest, the original behaviour was a bug.  A device that doesn't
enable clustering is telling us it can't take anything other than
PAGE_SIZE chunks ... trying to give it more is likely to end in tears.

However ... I'm not sure we actually have any devices that anyone can
identify which truly can't enable clustering (a lot which have it
disabled, I suspect, are that way historically because their writers
didn't trust the clustering algorithm).

So ... I think we can go ahead and cautiously enable clustering (as a
separate patch like Jens suggested).

James


