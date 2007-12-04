From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libsas: Don't issue commands to devices that have been
 hot-removed.
Date: Tue, 04 Dec 2007 18:40:54 -0500
Message-ID: <4755E586.2030401@garzik.org>
References: <200711301022.08001.kb@sysmikro.com.pl> <200712031709.54168.kb@sysmikro.com.pl> <20071203193652.GB7066@tree.beaverton.ibm.com> <200712032106.44176.kb@sysmikro.com.pl> <20071204223516.GA6767@tree.beaverton.ibm.com> <4755D941.2060903@garzik.org> <20071204231727.GB6767@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57960 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbXLDXlD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 18:41:03 -0500
In-Reply-To: <20071204231727.GB6767@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: =?UTF-8?B?S3J6eXN6dG9mIELFgmFzemtvd3NraQ==?= <kb@sysmikro.com.pl>, linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>

Darrick J. Wong wrote:
> On Tue, Dec 04, 2007 at 05:48:33PM -0500, Jeff Garzik wrote:
> 
>> As an aside, issues like this really really imply a need to move libsas 
>> away from the old libata EH stuff (like brking did with ipr, in patches).
> 
> Hm... does the new libata EH handle the case of "device was
> unplugged, don't bother trying to send any more commands"?
> 
> In general, I agree that sas-ata should adopt the new EH.
> Unfortunately, I believe the old way of sas-ata configuring ATA ports is
> somehow not compatible with the new EH stuff and causes a crash during
> the device probe with my patch to move sas-ata to the new EH.  If I
> apply the patch that migrates sas-ata to use brking's latest ata-sas
> configuration mechanism (the one that creates real ata_hosts), I see
> (a) lots and lots of ATA hosts getting created (one per ATA port;
> possibly undesirable if you've a SAS topology with a lot of SATA disks)
> and (b) NCQ disks don't seem to work if you unplug the disk and plug
> it back in (unless NCQ is disabled entirely).  Jeff, by any chance have
> you tried plugging SATA devices into your SAS controllers?

aic94xx yes, bcm and mv no.

Will take a look though...


> James Bottomley wondered if it would be easier to have sas-ata call only
> into the parts of libata that convert SCSI commands to ATA taskfiles,
> though I'm unsure how many wormy cans that would open.

You want more than that.

You want to make sure libata is the place for knowledge about weird ATA 
devices, SATA quirks, ATA device error handling (to be distinguished 
from ATA /link/ error handling), and other areas.

That stuff shouldn't be duplicated, and you /really/ do not want to 
re-learn all those lessons all over again ;-)

	Jeff



