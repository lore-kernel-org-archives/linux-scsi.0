From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] first cut at infrastructure for handling different device types in the sas class
Date: Sat, 4 Mar 2006 15:47:06 +0000
Message-ID: <20060304154706.GA14174@infradead.org>
References: <1141445103.5397.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34757 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751464AbWCDPrH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Mar 2006 10:47:07 -0500
Content-Disposition: inline
In-Reply-To: <1141445103.5397.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Mar 03, 2006 at 10:05:03PM -0600, James Bottomley wrote:
> This one actually does the end devices, since that's all I really have
> to work with in my setup.  However, I can do the expanders in the same
> way.  The idea is to make the rphy embedded in the enveloping device
> structure, so the code which doesn't care about type can still treat the
> code as a simple rphy, and the code that does care can cast out to the
> device type.
> 
> Temporarily, because mptsas doesn't do this, I've put a flag in to
> indicate whether the rphy is enveloped or not, however, if we enforce
> this for everything, then eventually that would go away.

Looks good in general, but we should probably kill the rphy naming.  That was
my invention when doing the transport class, when I still thought we'd add a
remote object for every phy in wide links.  We ended up having just a remote
object only under one of the phys for a wide link so we should probably
kill this naming invention.  In the end we should probably just have
a sas_end_device, sas_expander and sas_sata_device (or just sata_device
if we can share code with libata) and the common subset (sas_device?)
shouldn't be exposed to userland on it's own.

>  /**
> + * sas_rphy_end_device_alloc - allocate an rphy for an end device
> + *
> + * Allocates an SAS remote PHY structure, connected to @parent.
> + *
> + * Returns:
> + *	SAS PHY allocated or %NULL if the allocation failed.
> + */
> +struct sas_rphy *sas_rphy_end_device_alloc(struct sas_phy *parent)

this should become sas_end_device_alloc, and so on for the other
functions.

