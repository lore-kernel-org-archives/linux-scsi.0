From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: RFC: Transport identifier
Date: Thu, 26 Feb 2009 15:48:21 +0000
Message-ID: <1235663301.19035.44.camel@localhost.localdomain>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39382 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071AbZBZPs3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2009 10:48:29 -0500
In-Reply-To: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-02-25 at 23:31 -0500, Martin K. Petersen wrote:
> There are a few cases where it would be useful to know which transport
> is associated with a scsi_device.  For instance when determining whether
> to send a READ CAPACITY(16) to a device or not:
> 
>     static int sd_try_rc16_first(struct scsi_device *sdp)
>     {
> 	if (scsi_device_transport(sdp) == SCSI_TRANSPORT_USB)
> 	   return 0; /* Run screaming for the hills */
>     [...]
> 
> This patch implements support for a transport identifier in the
> scsi_host.  The id defaults to SPI and it is explicitly overridden in
> the host templates for FC, SAS, USB, etc. drivers.
> 
> It also looks like the availability of this transport id could improve
> the sysfs parsing in lsscsi.

I'd really rather not put transport specific knowledge back into the
mid-layer ... the whole idea of the transport classes was to take it out
as much as possible.

The other thought is that a lot of devices nowadays are bridged (all
SCSI DVDs have SPI to ATA bridges; a lot of high end USB storage or
enclosures has USB to ATA bridges), so a single transport identifier
doesn't quite cover it.

The final thought is that a lot of what you're looking for is actually
in the PROTOCOL field of a VPD inquiry, so it might be possible to use
that to obviate a lot of this.

James


