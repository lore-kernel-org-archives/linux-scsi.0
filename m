From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [2.6.25.1] qla2xxx can't see more than 4 drives
Date: Tue, 6 May 2008 06:51:18 -0700
Message-ID: <20080506135118.GA46493@plap4.qlogic.org>
References: <alpine.DEB.1.10.0805031458050.2330@mtl.rackplans.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:9216 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbYEFNvT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 09:51:19 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0805031458050.2330@mtl.rackplans.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Mack <gmack@innerfire.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 03 May 2008, Gerhard Mack wrote:

> I have an array witjh 6 drives in it and if use the card's utilities on 
> boot it sees all of them but for some reason Linux only sees 4 drives.
> 
> Am I running into a limit?  I can see both drives if I remove other drives 
> from the array.
> 
> [0:0:0:0]    disk    MAXTOR   ATLAS10K4_36SCA  DFM0  /dev/sda
> [0:0:1:0]    disk    MAXTOR   ATLAS10K4_36SCA  DFM0  /dev/sdb
> [0:0:2:0]    disk    MAXTOR   ATLAS10K4_36SCA  DFM0  /dev/sdc
> [0:0:6:0]    process PE/PV    1x3 SCSI BP      0.28  -
> fiber channel drives:
> [2:0:0:0]    disk    SEAGATE  ST314680 CLAR146 7A0A  /dev/sdd
> [2:0:1:0]    disk    SEAGATE  ST314680 CLAR146 7A04  /dev/sde
> [2:0:2:0]    disk    SEAGATE  ST314680 CLAR146 7A0A  /dev/sdf
> [2:0:3:0]    disk    SEAGATE  ST314680 CLAR146 7A04  /dev/sdg
> 
> QLogic Fibre Channel HBA Driver
> qla2xxx 0000:02:0a.0: Found an ISP2312, irq 24, iobase 0xf88cc000
> qla2xxx 0000:02:0a.0: Configuring PCI space...
> qla2xxx 0000:02:0a.0: Configure NVRAM parameters...
> qla2xxx 0000:02:0a.0: Verifying loaded RISC code...
> qla2xxx 0000:02:0a.0: Allocated (412 KB) for firmware dump...
> scsi3 : qla2xxx
> qla2xxx 0000:02:0a.0: LIP reset occured (f8f7).
> qla2xxx 0000:02:0a.0: LIP occured (f8f7).
> qla2xxx 0000:02:0a.0: LOOP UP detected (1 Gbps).

Could you load the driver with the ql2xextended_error_logging module
parameter set to 1 and send the resultant driver logs?  Also, it would
could you also send the output of the following after the driver is
loaded:

$ cat /sys/class/fc_host/host<host_no>
$ cat /sys/class/scsi_host/host<host_no>/*
$ cat /sys/class/fc_remote_ports/*

where host_no corresponds to the SCSI host-number assigned to the HBA.

Regards,
Andrew Vasquez
