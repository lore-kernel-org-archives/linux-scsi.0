From: Mark Lord <lsml@rtr.ca>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Wed, 15 Sep 2004 08:47:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <414839F0.20008@rtr.ca>
References: <414711AC.5030200@rtr.ca> <41471A84.4090200@pobox.com> <4147C38C.3000104@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:40345 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S261169AbUIOMtW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 08:49:22 -0400
In-Reply-To: <4147C38C.3000104@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
>>>
>>> Both hdparm and smartmontools are fully supported by this driver.
> 
> I'm curious how smartmontools is supported. Does the driver
> support SCSI LOG SENSE commands on the physical units or does
> it take the 3ware/Marvell route?
> There is no sign of QStor specific code in smartmontools's CVS.

This driver simply implements the HDIO_DRIVE_CMD/HDIO_DRIVE_TASK
ioctl call (from Linux IDE).  By doing so, it automatically gains
compatibility with smartmontools (-d ata), and with hdparm.

Currently, the implementation of those is native to the controller.
But eventually, I'd like to see it implement Curtis's ATA Passthrough
spec (to which I've been contributing).

Port selectors aside --> a nightmare for any sysadmin or driver writer
--> Linux has a huge unresolved issue for block devices.

It is currently next-to-impossible for a vendor to support a
new drive controller card under Linux unless it uses either SCSI
or libata.  Doing one as a new block driver is not an option,
because of the installation issues for the end-user during the
first couple of years of deployment --> until the distros begin
to include the required /dev/ entries everywhere.

To solve this requires a nice generic /dev/ interface for disks,
common to all drivers which talk to such devices.

Currently on Linux, that interface is called "SCSI".
I think it might not be unreasonable to gradually evolve
the SCSI host interface to include, say, a non-translating
queuecommand() method, and associated pals.

This would get rid of much (not all) of the double-translation objection,
and provide a smooth path for supporting Firewire, USB, parallel-port,
SATA, ATA, and of course SCSI, disks all under one naming subsystem.

We practically have that already today.
The SCSI mid-layer is a nice generic block device glue system.
We just need perhaps to make it less SCSI-specific.

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
