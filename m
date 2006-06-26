From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Areca driver recap + status
Date: Mon, 26 Jun 2006 09:48:58 -0500
Message-ID: <1151333338.2673.4.camel@mulgrave.il.steeleye.com>
References: <09be01c695b3$2ed8c2c0$c100a8c0@robm>
	 <20060621222826.ff080422.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:30661 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751252AbWFZOuF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 10:50:05 -0400
In-Reply-To: <20060621222826.ff080422.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: rdunlap@xenotime.net, hch@infradead.org, erich@areca.com.tw, brong@fastmail.fm, dax@gurulabs.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Robert Mueller <robm@fastmail.fm>

On Wed, 2006-06-21 at 22:28 -0700, Andrew Morton wrote: 
> On Thu, 22 Jun 2006 14:18:23 +1000
> "Robert Mueller" <robm@fastmail.fm> wrote:
> 
> > The driver went into 2.6.11-rc3-mm1 here:
> > http://marc.theaimsgroup.com/?l=linux-kernel&m=110754432622498&w=2
> 
> One and a half years.
> 
> Would the world end if we just merged the dang thing?

Not the world perhaps, but I'm unwilling to concede that if a driver
author is given a list of major issues and does nothing, then the driver
should go in after everyone gets impatient.

The rules for inclusion are elastic and include broad leeway for good
behaviour, but this would stretch the elasticity way beyond breaking
point.

The list of issues is here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=114556263632510

Most of the serious stuff is fixed with the exception of:

- sysfs has more than one value per file
- BE platform support
- PAE (cast of dma_addr_t to unsigned long) issues.
- SYNCHRONIZE_CACHE is ignored.  This is wrong.  The sync cache in the
shutdown notifier isn't sufficient.

At least the sysfs files have to be fixed before it goes in ... unless
you want to be lynched by Greg?

What I could do is set up a holding tree for all the fixed ... but -mm
is doing a good job of that at the moment.

James


