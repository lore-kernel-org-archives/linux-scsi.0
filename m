From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH] isci: filter broadcast change notifications during
 SMP phy resets
Date: Mon, 27 Jun 2011 11:02:34 -0500
Message-ID: <1309190554.459.3.camel@mulgrave>
References: <20110624194109.26706.58553.stgit@localhost6.localdomain6>
	 <4E0894EC.2010509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43423 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab1F0QCh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2011 12:02:37 -0400
In-Reply-To: <4E0894EC.2010509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, dmilburn@redhat.com, jack_wang@usish.com, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, yuxiangl@marvell.com, hch@lst.de

On Mon, 2011-06-27 at 16:34 +0200, Hannes Reinecke wrote:
> On 06/24/2011 09:48 PM, Dan Williams wrote:
> > From: Jeff Skirvin<jeffrey.d.skirvin@intel.com>
> >
> > When resetting a sata device in the domain we have seen occasions where
> > libsas prematurely marks a device gone in the time it takes for the
> > device to re-establish the link.  This plays badly with software raid
> > arrays.  Other libsas drivers have non-uniform delays in their reset
> > handlers to try to cover this condition, but not sufficient to close the
> > hole.  Given that a sata device can take many seconds to recover we
> > filter bcns and poll for the device reattach state before notifying
> > libsas that the port needs the domain to be rediscovered.  Once this has
> > been proven out at the lldd level we can think about uplevelling this
> > feature to a common implementation in libsas.
> >
> That's the second time something like this have come up now.
> Wouldn't it makes sense to implement something like the dev_loss_tmo 
> mechanism with have for FC? That should cover this situation nicely ...

It's certainly what we agreed to at LSF, yes, so it looks like a good
idea.

James


