From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: SCSI disk error
Date: Tue, 03 Sep 2002 15:44:51 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200209032044.g83KiqJ08551@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Alex Adriaanse <alex_a@caltech.edu>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"Alex Adriaanse" <alex_a@caltech.edu> said:
> I got the following error message last night on one of my SCSI disks:
> SCSI disk error : host 0 channel 0 id 6 lun 0 return code = 100ff
>  I/O error: dev 08:11, sector 38584

That error is a DID_NO_CONNECT.  For the symbios driver that means a selection 
timeout, I think.

> Is there any way to look up what the return code means?  By the way,
> badblocks doesn't seem to return any bad blocks, and I can still
> access the disk (including the first partition) just fine.  I found
> documentation for my hard drive at h

They go in 8 bits from LSB to MSB: status byte, message byte, host byte, 
driver byte.  The first two (status and message) are the SCSI return codes 
from the device.  The latter two are set by the driver (that's where the 
DID_NO_CONNECT is).  See drivers/scsi/scsi.h

James Bottomley
