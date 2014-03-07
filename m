From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Fri, 7 Mar 2014 02:43:21 -0800
Message-ID: <20140307104321.GA28472@infradead.org>
References: <1392286032-85036-1-git-send-email-hare@suse.de>
 <1392286032-85036-3-git-send-email-hare@suse.de>
 <20140228170131.GA31510@infradead.org>
 <5316D459.6070107@suse.de>
 <20140305194255.GA5607@infradead.org>
 <53183951.7080805@suse.de>
 <1394188800.5225.41.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaCGKnZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2014 05:43:25 -0500
Content-Disposition: inline
In-Reply-To: <1394188800.5225.41.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On Fri, Mar 07, 2014 at 02:40:00PM +0400, James Bottomley wrote:
> On Thu, 2014-03-06 at 10:01 +0100, Hannes Reinecke wrote:
> > So the only 'proper' solution would be to add a bitmap of supported
> > pages; however, this would be 256 bits = 32 bytes of additional
> > space required for struct sdev.
> > Which I'm a bit reluctant do to, as it'll be a sparse array in most
> > cases, adding to quite some wasted space.
> 
> Why per sdev?  Isn't it per target?  The supported EVPD page list
> shouldn't really vary for luns of the same target unless something very
> strange is happening in the array.

It might very well vary.  For one difference device types support
different EVPD patches and a target might mix and match device types for
LUNs.  Also software targets might use individual LUNs as passthrough
to physical devices, in which case they might support different EVPD
pages even for the same device type.  E.g. the pscsi backend for the
in-kernel target might behave like that.

