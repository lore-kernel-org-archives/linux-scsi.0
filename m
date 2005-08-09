From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] SPI transport class and generic Domain Validation for
	 fusion
Date: Mon, 8 Aug 2005 18:07:45 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C037B09A6@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:952 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932380AbVHIAH6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 20:07:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Wade, Roy" <Roy.Wade@lsil.com>, "Cratin, Laura" <Laura.Cratin@lsil.com>, "Maloy, Joe" <Joe.Maloy@lsil.com>, "Pope, Steve" <spope@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, "Hickerson, Roger" <roger.hickerson@lsil.com>

On Monday, August 08, 2005 3:47 PM, James Bottomley wrote:
> Eric,
> 
> This attached patch should do DV on both physical devices and the
> underlying devices of fusion IM assemblies (providing you apply it on
> top of the prior underlying device exposure patch), which, I 
> believe was
> your only outstanding concern with the last generic DV patch.
> 
> There is one slight unsightly piece: the IM device still 
> attaches to the
> transport class however all the parameters it shows actually belong to
> the underlying device at that id ... I could do with finding a way of
> persuading the SPI transport class not to attach to RAID devices.
> 
> Since this addresses all of LSI's prior concerns, may I now apply it?
> 

Roy/Laura/Roy/Steve, and others - This is a patch to remove our 
internal dv(domain validation) code and replace with generic 
dv implemention in the linux kernel.  This is a year old push from 
kernel.org , for the drivers in upstream kernel.

James:  I've not been able to review this patch, nor the other one you sent.
On concern is whether spi transport handle asyn events?  Meaning will it do
domain
validation on RAID1 volume - for a new drive that was hot swapped with a 
good disk?  In the driver look at mptscsih_event_process - this code is 
handling a aync event from the firmware telling the driver to perform 
dv on disk that was just added.  

Pls don't rush this into the kernel untill we have time to review, and/or 
talk to our internal test teams on test effort, and/or talk to our customers
explaning the risk in removing this code.

Eric Moore

