From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Wed, 5 Mar 2014 11:42:55 -0800
Message-ID: <20140305194255.GA5607@infradead.org>
References: <1392286032-85036-1-git-send-email-hare@suse.de>
 <1392286032-85036-3-git-send-email-hare@suse.de>
 <20140228170131.GA31510@infradead.org>
 <5316D459.6070107@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60860 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaCETnF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2014 14:43:05 -0500
Content-Disposition: inline
In-Reply-To: <5316D459.6070107@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On Wed, Mar 05, 2014 at 08:38:01AM +0100, Hannes Reinecke wrote:
> > Either way I think the call to query evpd 0 should be a separate
> > function, so even if we don't store the information it's abstracted out.
> > 
> Hmm. That would work if we were just asking for a single page; but
> when we're checking several pages (like 0x83 and 0x80) we'd need
> either to pass in a page array or querying page 0 several times.
> Neither of which is very appealing.
>
> However, specifying additional flags for the individual pages might
> work. I'll see what I can come up with.

Passing in a bitmask or flags seems useful.  Even better storing it in the
scsi_device.  Note that I expect the place that need to know the EVPD
patch to grow slowly but steadily over time.
