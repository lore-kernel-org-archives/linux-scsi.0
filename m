From: Jeff Garzik <JGarzik@DunveganMedia.com>
Subject: Re: [PATCH] libsas: Don't issue commands to devices that have been
 hot-removed.
Date: Mon, 25 Feb 2008 18:39:35 -0500
Message-ID: <47C351B7.3080204@DunveganMedia.com>
References: <200711301022.08001.kb@sysmikro.com.pl> <200712031709.54168.kb@sysmikro.com.pl> <20071203193652.GB7066@tree.beaverton.ibm.com> <200712032106.44176.kb@sysmikro.com.pl> <20071204223516.GA6767@tree.beaverton.ibm.com> <4755D941.2060903@garzik.org> <20071204231727.GB6767@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55784 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbYBYXjm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 18:39:42 -0500
In-Reply-To: <20071204231727.GB6767@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, =?UTF-8?B?S3J6eXN6dG9mIELFgmFzemtvd3Nr?= =?UTF-8?B?aQ==?= <kb@sysmikro.com.pl>, linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>


(digging through old email)

Darrick J. Wong wrote:
> On Tue, Dec 04, 2007 at 05:48:33PM -0500, Jeff Garzik wrote:
> 
>> As an aside, issues like this really really imply a need to move libsas 
>> away from the old libata EH stuff (like brking did with ipr, in patches).
> 
> Hm... does the new libata EH handle the case of "device was
> unplugged, don't bother trying to send any more commands"?

Yes, most certainly :)  We wouldn't have hotplug support without that...


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

Just tested mvsas here...


> James Bottomley wondered if it would be easier to have sas-ata call only
> into the parts of libata that convert SCSI commands to ATA taskfiles,
> though I'm unsure how many wormy cans that would open.

Like Brian K noted, libata-EH is heavily involved in "anything not 
hotpath read/write", including but not limited to:  PMP, hotplug, device 
probing, device revalidation, explicit sequencing of ATA commands during 
initialization (critical for getting many ATA devices working)

You don't want to reinvent or duplicate all those ATA device 
initialization/revalidation quirks.

	Jeff



