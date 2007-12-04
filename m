From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] libsas: Don't issue commands to devices that have been
	hot-removed.
Date: Tue, 4 Dec 2007 15:17:27 -0800
Message-ID: <20071204231727.GB6767@tree.beaverton.ibm.com>
References: <200711301022.08001.kb@sysmikro.com.pl> <200712031709.54168.kb@sysmikro.com.pl> <20071203193652.GB7066@tree.beaverton.ibm.com> <200712032106.44176.kb@sysmikro.com.pl> <20071204223516.GA6767@tree.beaverton.ibm.com> <4755D941.2060903@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:50447 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXLDXRf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 18:17:35 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB4MFxE8002824
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 17:15:59 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB4NHTQX119818
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 16:17:29 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB4NHSTQ002520
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 16:17:29 -0700
Content-Disposition: inline
In-Reply-To: <4755D941.2060903@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Krzysztof =?utf-8?Q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>, linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>

On Tue, Dec 04, 2007 at 05:48:33PM -0500, Jeff Garzik wrote:

> As an aside, issues like this really really imply a need to move libsas 
> away from the old libata EH stuff (like brking did with ipr, in patches).

Hm... does the new libata EH handle the case of "device was
unplugged, don't bother trying to send any more commands"?

In general, I agree that sas-ata should adopt the new EH.
Unfortunately, I believe the old way of sas-ata configuring ATA ports is
somehow not compatible with the new EH stuff and causes a crash during
the device probe with my patch to move sas-ata to the new EH.  If I
apply the patch that migrates sas-ata to use brking's latest ata-sas
configuration mechanism (the one that creates real ata_hosts), I see
(a) lots and lots of ATA hosts getting created (one per ATA port;
possibly undesirable if you've a SAS topology with a lot of SATA disks)
and (b) NCQ disks don't seem to work if you unplug the disk and plug
it back in (unless NCQ is disabled entirely).  Jeff, by any chance have
you tried plugging SATA devices into your SAS controllers?

James Bottomley wondered if it would be easier to have sas-ata call only
into the parts of libata that convert SCSI commands to ATA taskfiles,
though I'm unsure how many wormy cans that would open.

--D
