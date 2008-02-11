From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] drivers/scsi/aic7xxx/aic7xxx_osm_pci.c - remove
	pointer comparison to 0
Date: Mon, 11 Feb 2008 11:49:02 -0600
Message-ID: <1202752142.3122.52.camel@localhost.localdomain>
References: <1202708852.13411.3.camel@localhost>
	 <1202743820.3122.13.camel@localhost.localdomain>
	 <1202749685.13411.11.camel@localhost>
	 <20080211091742.dff2e2da.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37618 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743AbYBKRtJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Feb 2008 12:49:09 -0500
In-Reply-To: <20080211091742.dff2e2da.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joe Perches <joe@perches.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Mon, 2008-02-11 at 09:17 -0800, Randy Dunlap wrote:
> On Mon, 11 Feb 2008 09:08:05 -0800 Joe Perches wrote:
> 
> > On Mon, 2008-02-11 at 09:30 -0600, James Bottomley wrote:
> > > On Sun, 2008-02-10 at 21:47 -0800, Joe Perches wrote:
> > > > -       if (request_region(*base, 256, "aic7xxx") == 0)
> > > > +       if (!request_region(*base, 256, "aic7xxx"))
> > > 
> > > This patch is completely pointless.
> > 
> > It removes a sparse warning.
> 
> I try to say that in the patch description.  Andrew also tries
> to enforce such errors/warnings in patch descriptions....

Well, the aic7xxx subdirectory is a nightmare of CodingStyle non
conformities ... you can see the return (ENOMEM) just in this patch.
That's two problems: the brackets and non negative error returns which
are later converted to negative ones thus inviting sign problems.  The
driver is also about 3x bigger than it should be because of the vestiges
of the BSD glue layer.  However, I think my life is too short to apply
the 32,554 patches it would take to correct this an issue at a time.

This is one of those drivers we tolerate because we must and we fix up
around the regions we have to touch.

James


