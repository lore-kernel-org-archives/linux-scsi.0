From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI passthrough ioctl calls vs. sd/sg devices
Date: Sat, 24 Apr 2004 14:06:10 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4089E7B2.5060803@torque.net>
References: <519672568F040C41B6FAC21ADF51B18FEFBE@mailnode1.commstor.crossroads.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:4358 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261915AbUDXEGH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Apr 2004 00:06:07 -0400
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFBE@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

Lee Xing wrote:
> Hi,
> 
> I would appreciate it if some one could clarify this.  It's a bit confusing.
> 
> <<The Linux SCSI Generic (sg) HOWTO>> page 2 says "The sg driver permits user applications to send SCSI commands to devices that understand them.  SCSI commands are 6, 10, 12 or 16 bytes long.  The SCSI disk driver (sd), once device initialization is complete, only sends SCSI READ and WRITE commands."
> 
> <<The Linux 2.4 SCSI subsystem HOWTO>> page 3 says "Sg is a SCSI command pass through device that uses a char device interface.  General purpose Linux commands should not be used on sg devices."
> 
> My questions are:
> 
> - looks like SCSI passthrough ioctl calls can only apply 
>   to sg devices.  Is it right, and can we apply SCSI
>   passthrough ioctl calls to sd devices as well?

True in the lk 2.4 series. When all else fails you can still
use the SCSI_IOCTL_SEND_COMMAND ioctl() [which is what is
used by smartmontools currently].

In the lk 2.6 series the SG_IO ioctl is available for block
devices which include SCSI disks and ATAPI dvd/cd drives.
The SG_IO ioctl is currently not available for SCSI char
device drivers (e.g. st and osst) other than sg itself.
BTW ATA disks don't understand SCSI commands so the SG_IO
ioctl is of little use with them.

It the next week or so I hope to propose a SG_IO ioctl
for the scsi mid level for consideration in lk 2.6.
That will make the SG_IO ioctl available to st and osst
as well.

> - what are the so-called "General purpose Linux commands"?
>   Are they read()/write() or 'mount' / 'dd' or something else?

mount, dd, cp, mv, rm (etc).

The sg3_utils package has a dd variant called sg_dd which can use
sg devices (as well as those that the standard dd can handle).

> What should we do if we need to 'mount' a file system on a disk and 
> also need to issue SCSI passthrough ioctl calls to the same disk?  
 > Maybe we should use both sd and sg (i.e. mount the file system to
 > /dev/sda, and issue SCSI passthrough ioctl calls to /dev/sg0 that
> maps to the same physical disk)?  

yes

> 'mount' doesn't work on sg devices as I was told earlier.

true.

Doug Gilbert

