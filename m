From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 03:16:58 -0400
Message-ID: <4292D4EA.8090308@pobox.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <4292D275.8070409@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:18125 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261397AbVEXHRD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 03:17:03 -0400
In-Reply-To: <4292D275.8070409@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

Hannes Reinecke wrote:
> Jeff Garzik wrote:
> [ .. ]
> 
>>Longer term, SATA PM through SCSI will have three facets:
>>
>>* Device PM.  This is best handled by the device class driver (sd/sr/st).
>>
>>* Bus PM.  This is best handled by the transport class driver (need to
>>write for SATA and SAS).
>>
>>* Host PM.  This is handled in the obvious manner, using existing PM
>>driver hooks.  PCI D0/D3, etc.
>>
>>I can describe how this will look when libata is divorced from SCSI, if
>>you would like, too...
> 
> 
> Divorced from SCSI? Care to elaborate?


General Linux thesis:  translation and emulation are lame.  Adds 
needless overhead.  One should write a "bare metal" driver.

libata should be able to export a native block driver for ATA devices, 
making libata-scsi.c simply an optional "T10 SAT implementation" that 
users can retain for compatibility and certain features, or excise for 
lower overhead.

As ATAPI is converging with SCSI MMC -- the two committes are actively 
aligning the standards -- I would prefer to handle ATAPI devices through 
the SCSI layer.

	Jeff


