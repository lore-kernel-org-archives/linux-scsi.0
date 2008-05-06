From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [2.6.25.1] qla2xxx can't see more than 4 drives
Date: Tue, 6 May 2008 15:08:26 -0700
Message-ID: <20080506220826.GI57975@plap4.qlogic.org>
References: <alpine.DEB.1.10.0805031458050.2330@mtl.rackplans.net> <20080506135118.GA46493@plap4.qlogic.org> <alpine.DEB.1.10.0805061022120.5741@mtl.rackplans.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:40656 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025AbYEFWI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 18:08:27 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0805061022120.5741@mtl.rackplans.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Mack <gmack@innerfire.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 06 May 2008, Gerhard Mack wrote:

> On Tue, 6 May 2008, Andrew Vasquez wrote:
> > Could you load the driver with the ql2xextended_error_logging module
> > parameter set to 1 and send the resultant driver logs?  Also, it would
> > could you also send the output of the following after the driver is
> > loaded:
> > 
> > $ cat /sys/class/fc_host/host<host_no>
> > $ cat /sys/class/scsi_host/host<host_no>/*
> > $ cat /sys/class/fc_remote_ports/*
> > 
> > where host_no corresponds to the SCSI host-number assigned to the HBA.
> > 
> Of course.. 
> 
> QLogic Fibre Channel HBA Driver
> qla2xxx 0000:02:0a.0: Found an ISP2312, irq 24, iobase 0xf88cc000
> qla2xxx 0000:02:0a.0: Configuring PCI space...
> qla2xxx 0000:02:0a.0: Configure NVRAM parameters...
> qla2xxx 0000:02:0a.0: Verifying loaded RISC code...
> scsi(4): **** Load RISC code ****
...
> cat /sys/class/fc_host/host4/* :
> 0x200000e08b127d20
> 0
> 0x200000e08b127d20
> 0
> 0x000001
> 0x210000e08b127d20
> Online
> LPort (private loop)

Hmm, qla2xxx has a 'split' port-discovery model based on topology.
Switched fabric (P2P) discovery and logins are managed by the driver.
FC_AL topology discovery and logins are managed by firmware.  The
driver (qla2xxx) simply asks the firmware for a list of recognized
ports, as you've noted the driver (and indirectly, firmware), only
recognized 4 ports during LIPA/LIHA/LISA address negotiation:

> cat /sys/class/fc_remote_ports/rport-4\:0-0/*  :
> 0x2200000c507ce546
...
> cat /sys/class/fc_remote_ports/rport-4\:0-1/*
> 0x22000004cf69c688
...
> cat /sys/class/fc_remote_ports/rport-4\:0-2/* | log
> 0x2200000c507ce809
...
> cat /sys/class/fc_remote_ports/rport-4\:0-3/* :
> 0x22000004cf69b98f
...


You mentioned that the 'BIOS' configuration program recognizes 6
devices, have there been any changes made via the BIOS utility to

* assign a hard-loop id?
* acquire a loop-id during LIPA?

or any changes above and beyond 'default' settings?  If so, could you
'retrore' default settings within BIOS utility?

--
Andrew Vasquez
