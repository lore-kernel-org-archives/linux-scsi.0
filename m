From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] scsi: Implement 'ZBC' device type
Date: Mon, 2 Jun 2014 02:20:53 -0700
Message-ID: <20140602092053.GD32301@infradead.org>
References: <1401692478-23557-1-git-send-email-hare@suse.de>
 <1401692478-23557-4-git-send-email-hare@suse.de>
 <20140602083919.GA31170@infradead.org>
 <538C39EB.90109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40311 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaFBJUy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 05:20:54 -0400
Content-Disposition: inline
In-Reply-To: <538C39EB.90109@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Mon, Jun 02, 2014 at 10:46:35AM +0200, Hannes Reinecke wrote:
> >But I'm uneasy with adding anything like this for now, for one the specs
> >aren't even anywhere close to done, and second attaching ZBC devices
> >in general doesn't sound like a very smart idea, we really need a
> >strategy for the sequential required zones first.
> >
> In theory, yes.
> 
> In practice, however, ZAC drives will show up a normal ATA devices
> without that patch. Which is leading to even more trouble.
> So with this patch we're at least signalling to the user that
> something odd might happen.

So how about we drop the sd.c changes so that no ULD gets attached,
and keep the rest with the review comments addressed?  That way we
don't accidentally attach a ZBC/ZAC disk, but do get proper diagnostics
and can even use SG_IO with the experimental ZBC or ZAC commands.
