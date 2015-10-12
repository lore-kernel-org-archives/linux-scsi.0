From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Mon, 12 Oct 2015 16:39:27 +0200
Message-ID: <20151012143927.GA24770@lst.de>
References: <1443202278.2188.13.camel@HansenPartnership.com> <20150930151449.GC26299@lst.de> <20150930215303.GI2627@mtj.duckdns.org> <1443652494.2185.57.camel@HansenPartnership.com> <20151002125608.GB14899@lst.de> <1443792301.2209.4.camel@HansenPartnership.com> <20151002133423.GA15867@lst.de> <1443793497.2209.10.camel@HansenPartnership.com> <20151004074556.GA13932@lst.de> <561BAB72.1070205@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53220 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbbJLOja (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 10:39:30 -0400
Content-Disposition: inline
In-Reply-To: <561BAB72.1070205@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org

On Mon, Oct 12, 2015 at 02:45:38PM +0200, Hannes Reinecke wrote:
> You cannot easily use the driver model here as the scsi_device is
> already (potentially) bound to the ULDs.
> If you were to go with the driver model you'd have to introduce
> another sub device between scsi_target and scsi_device.

You can have two struct devices in struct scsi_device, while it's
not pretty there are plenty of example all over the kernel with
multiple devices in a single containing structure. 

> Actually I have been thinking that, as it might make my life for the
> ALUA handler easier. However, this would be quite a largish redesign
> of the current handler infrastructure, pushing out my ALUA handler
> update even more.
> So I'd like to have the ALUA changes ironed out first and merged,
> and then work on a redesigned device handler infrastructure.

Fine with me.  As mentioned before we've never supported autoloading
the device handler modules at boot time - we only ever loaded them when
explicitly attaching them through device mapper.  Waiting another
release or maybe two to finally get there isn't the end of the world.
