From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] ib_srp: 64bit LUN fixes
Date: Fri, 4 Jul 2014 06:48:35 -0700
Message-ID: <20140704134835.GB12345@infradead.org>
References: <1404474875-109997-1-git-send-email-hare@suse.de>
 <1404474875-109997-3-git-send-email-hare@suse.de>
 <53B69E97.4050901@acm.org>
 <53B6A5B4.2040807@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46954 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095AbaGDNsg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 09:48:36 -0400
Content-Disposition: inline
In-Reply-To: <53B6A5B4.2040807@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Fri, Jul 04, 2014 at 03:01:40PM +0200, Hannes Reinecke wrote:
> What I would like to do is to provide accessor functions for the scsi lun;
> I've started this already for the older SCSI parallel drivers (see my
> earlier patch).
> Once everything is moved over to accessors it should be trivial to move from
> the current scsilun_to_int representation in struct scsi_device to the
> 'real' LUN.
> 
> Adding another field would be bit of an overkill IMO, seeing that we can
> achieve the very same thing with a bit of code reshuffling.
> 
> James, Christoph, what's your opinion on using accessors?
> Would solve this issue nicely, and we can also use proper functions for HBAs
> only capable of handling 32bit LUNs.
> Drawback is that we would need accessors also for this capable of handling
> full 64bit LUNs, thus potentially incur some overhead there.

I think storing the struct scsi_lun in the scsi_device is the right way
to go ahead.  Any "accessors" for 8 or 32-bit LUNs should be simply
enough by just ignoring bits in the array, so there's very little
performance overhead.

If we can get rid of the old scalar LUN field that would be great,
and given that we know the printk format fallout already it doesn't look
like too much work.  Do you want to look into this?

