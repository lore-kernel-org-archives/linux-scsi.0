From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] libsas: Don't issue commands to devices that have been
 hot-removed.
Date: Thu, 06 Dec 2007 10:55:25 -0600
Message-ID: <4758297D.10909@linux.vnet.ibm.com>
References: <200711301022.08001.kb@sysmikro.com.pl> <200712031709.54168.kb@sysmikro.com.pl> <20071203193652.GB7066@tree.beaverton.ibm.com> <200712032106.44176.kb@sysmikro.com.pl> <20071204223516.GA6767@tree.beaverton.ibm.com> <4755D941.2060903@garzik.org> <20071204231727.GB6767@tree.beaverton.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:57711 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbXLFQzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2007 11:55:40 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB6Frr9i014097
	for <linux-scsi@vger.kernel.org>; Thu, 6 Dec 2007 10:53:53 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB6GtR2R127348
	for <linux-scsi@vger.kernel.org>; Thu, 6 Dec 2007 09:55:27 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB6GtQAa024866
	for <linux-scsi@vger.kernel.org>; Thu, 6 Dec 2007 09:55:27 -0700
In-Reply-To: <20071204231727.GB6767@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, =?ISO-8859-1?Q?Krzysztof_B=3Faszkows?= =?ISO-8859-1?Q?ki?= <kb@sysmikro.com.pl>, linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>

Darrick J. Wong wrote:
> In general, I agree that sas-ata should adopt the new EH.
> Unfortunately, I believe the old way of sas-ata configuring ATA ports is
> somehow not compatible with the new EH stuff and causes a crash during
> the device probe with my patch to move sas-ata to the new EH.  If I
> apply the patch that migrates sas-ata to use brking's latest ata-sas
> configuration mechanism (the one that creates real ata_hosts), I see
> (a) lots and lots of ATA hosts getting created (one per ATA port;
> possibly undesirable if you've a SAS topology with a lot of SATA disks)

The new libata EH ends up spending more time in the error handling thread
than the old code did. One of the reasons having multiple ATA/SCSI hosts
is a good thing is that is the granularity of error handling, so it
prevents stalling all the other devices under that SAS HBA while we are
hitting errors on an ATAPI SATA device, for example.

Arguably, SATA users of libata already have one SCSI host per ATA port,
so my SAS patches really just bring SAS in line with that design...

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
