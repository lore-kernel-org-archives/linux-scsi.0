From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 15 Aug 2005 17:21:31 +0200
Message-ID: <20050815152131.GB20854@lst.de>
References: <20050815135537.GB19426@lst.de> <4300B11A.2050006@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:63442 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964792AbVHOPVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 11:21:49 -0400
Content-Disposition: inline
In-Reply-To: <4300B11A.2050006@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Mon, Aug 15, 2005 at 11:13:30AM -0400, Luben Tuikov wrote:
> > +void sas_add_target(struct sas_port *port, struct sas_identify *attached,
> > +		uint channel, uint target)
> > +{
> > +	if (attached->target_port_protocols &
> > +	    (SAS_PROTOCOL_SSP|SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA))
> > +		scsi_scan_target(&port->dev, channel, target, ~0, 0, attached);
> > +}
> 
> I've a few questions:
> 
> 1. What kind of device does the Fusion driver export?
>    Is this a true end device, or is this the LU in the SSP end device?
>    I.e. since the Fusion card firmware does everything about SAS there is,
>    is also LU discovery done in the firmware, or does the firmware export
>    only the SSP end devices and leave LU discovery to SCSI Core
>    (as the code suggests)?

It seems to give notification for the actual LU, but doing an LU scan
works if you use the target ID from those reports.  Given that I prefer
to do as much as possible in the transport class to have the same
behaviour for different HBAs I'd prefer to not rely on the firmware's
LU scan.

> 2. Since I saw that (end) devices bind to ports, what is the maximum
>    number of ports that the Fusion firmware export?

right now it reports the number of physical ports, that's four or eight
for the cards I have.  But again I don't have the actual documentation
yet.

> 3. Will control of SATA and STP devices be given to libata or will
>    the Fision firmware make those look like SCSI devices?

Fusion makes them look like SCSI devices.  As I mentioned I tested this
patch only with SATA disks.  But as the command translation for cards
not doing thi in firmware would happen in the ->queuecommand path I
don't think the transport class should be involved with it.
