From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Fri, 07 Mar 2014 14:57:47 +0400
Message-ID: <1394189867.14365.4.camel@dabdike>
References: <1392286032-85036-1-git-send-email-hare@suse.de>
	 <1392286032-85036-3-git-send-email-hare@suse.de>
	 <20140228170131.GA31510@infradead.org> <5316D459.6070107@suse.de>
	 <20140305194255.GA5607@infradead.org> <53183951.7080805@suse.de>
	 <1394188800.5225.41.camel@dabdike> <20140307104321.GA28472@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38402 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbaCGK5w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2014 05:57:52 -0500
In-Reply-To: <20140307104321.GA28472@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On Fri, 2014-03-07 at 02:43 -0800, Christoph Hellwig wrote:
> On Fri, Mar 07, 2014 at 02:40:00PM +0400, James Bottomley wrote:
> > On Thu, 2014-03-06 at 10:01 +0100, Hannes Reinecke wrote:
> > > So the only 'proper' solution would be to add a bitmap of supported
> > > pages; however, this would be 256 bits = 32 bytes of additional
> > > space required for struct sdev.
> > > Which I'm a bit reluctant do to, as it'll be a sparse array in most
> > > cases, adding to quite some wasted space.
> > 
> > Why per sdev?  Isn't it per target?  The supported EVPD page list
> > shouldn't really vary for luns of the same target unless something very
> > strange is happening in the array.
> 
> It might very well vary.  For one difference device types support
> different EVPD patches and a target might mix and match device types for
> LUNs.

Yes, cardreaders can do this, I suppose, but they're not a usual case

>   Also software targets might use individual LUNs as passthrough
> to physical devices, in which case they might support different EVPD
> pages even for the same device type.  E.g. the pscsi backend for the
> in-kernel target might behave like that.

This is a bit of a stretch too.  However, I can't see an easy way of
supporting the common case (same EVPD array per lun) simply and allowing
for the more complex one, so I suppose if we do it it will have to be
per sdev.

James


