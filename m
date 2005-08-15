From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 15 Aug 2005 11:13:30 -0400
Message-ID: <4300B11A.2050006@adaptec.com>
References: <20050815135537.GB19426@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:48841 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964802AbVHOPNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 11:13:35 -0400
In-Reply-To: <20050815135537.GB19426@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

> +void sas_add_target(struct sas_port *port, struct sas_identify *attached,
> +		uint channel, uint target)
> +{
> +	if (attached->target_port_protocols &
> +	    (SAS_PROTOCOL_SSP|SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA))
> +		scsi_scan_target(&port->dev, channel, target, ~0, 0, attached);
> +}

I've a few questions:

1. What kind of device does the Fusion driver export?
   Is this a true end device, or is this the LU in the SSP end device?

   I.e. since the Fusion card firmware does everything about SAS there is,
   is also LU discovery done in the firmware, or does the firmware export
   only the SSP end devices and leave LU discovery to SCSI Core
   (as the code suggests)?

2. Since I saw that (end) devices bind to ports, what is the maximum
   number of ports that the Fusion firmware export?

3. Will control of SATA and STP devices be given to libata or will
   the Fision firmware make those look like SCSI devices?

Thanks,
	Luben

