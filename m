From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/3] - mpt fusion - panic in mptsas_slave_configure
Date: Thu, 13 Apr 2006 17:15:10 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70080B8F@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42205 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965020AbWDMXPM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 19:15:12 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Thursday, April 13, 2006 4:28 PM, James Bottomley wrote: 

> Erm, there's something else wrong here, then.  The sas transport class
> shouldn't be attaching to the raid volumes (only the raid components)
> since a RAID volume is not a SAS device.  I think when this 
> came up ages
> ago, I said the SAS class should do a deny_binding() callback like the
> SPI transport class does for the mptfusion driver ... 
> 

???, the mptsas driver is not attaching the raid volumes to sas
 transport. Only the raid components are attached.

What the fusion driver is doing is placing the raid volumes on virtual 
channel beyond the last known channel for the rphys.  Basically the 
reverse of what you did for fusion when you added the spi transport 
support.  What this means is the raid volumes are located at 
ioc->num_ports.  Then we use scsi_add_device and scsi_remove_device 
to handle adding and removing the raid volumes attaching on this 
virtual channel.   From mptsas_slave_alloc(), we bypass the logic 
for rphy handling near the comment that says "RAID Volumes placed 
beyond the last expected port". I beleive all this is correct, 
okay'd by you and Christoph several months ago.  However the problem
came when you added the mptsas_slave_configure. We need to add the same 
check that bypasses calling the sas transport layer API for anything
sitting
this virtual channel reserved for RAID.

Eric   

