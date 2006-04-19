From: Daniel Drake <dsd@gentoo.org>
Subject: Re: 2.6.14 regression: aic7xxx hangs on boot
Date: Thu, 20 Apr 2006 00:08:22 +0100
Message-ID: <4446C2E6.6040708@gentoo.org>
References: <44461FB5.8060705@gentoo.org>	 <1145454585.3465.5.camel@mulgrave.il.steeleye.com>	 <444658BE.5080309@gentoo.org> <1145462527.6183.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta07-winn.ispmail.ntl.com ([81.103.221.47]:15518 "EHLO
	mtaout01-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S1751314AbWDSWyj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 18:54:39 -0400
In-Reply-To: <1145462527.6183.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: gibbs@scsiguy.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> OK ... so more details, like the dmesg up to the problem (primarily to
> diagnose the transport parameters and what's on the bus).  Plus, what
> were the transport parameters in the case where it worked
> (from /proc/scsi/aic7xxx/*)

The loop/crash occurs during early boot, so it's not possible to login 
and run dmesg. I will ask if a serial console is available.

Here is /proc/scsi/aic7xxx/0 from 2.6.13.4:

Adaptec AIC7xxx driver version: 6.2.36
Adaptec 29160 Ultra160 SCSI adapter
aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
Allocated SCBs: 36, SG List Length: 128

Serial EEPROM:
0x433a 0xc13a 0xc13a 0xc13a 0xc13a 0xc13a 0xc13a 0xc13a
0xc13a 0xc13a 0xc13a 0xc13a 0xc13a 0xc13a 0xc13a 0xc13a
0x08f4 0x7c5d 0x2807 0x0010 0x0300 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0x484f

Target 0 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
         Goal: 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
         Curr: 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
         Channel A Target 0 Lun 0 Settings
                 Commands Queued 19329
                 Commands Active 0
                 Command Openings 32
                 Max Tagged Openings 32
                 Device Queue Frozen Count 0
Target 1 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 2 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 3 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
         Goal: 3.300MB/s transfers
         Curr: 3.300MB/s transfers
         Channel A Target 3 Lun 0 Settings
                 Commands Queued 19
                 Commands Active 0
                 Command Openings 1
                 Max Tagged Openings 0
                 Device Queue Frozen Count 0
Target 4 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
         Goal: 20.000MB/s transfers (20.000MHz, offset 15)
         Curr: 20.000MB/s transfers (20.000MHz, offset 15)
         Channel A Target 4 Lun 0 Settings
                 Commands Queued 23
                 Commands Active 0
                 Command Openings 1
                 Max Tagged Openings 0
                 Device Queue Frozen Count 0
Target 5 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
         Goal: 3.300MB/s transfers
         Curr: 3.300MB/s transfers
         Channel A Target 5 Lun 0 Settings
                 Commands Queued 29
                 Commands Active 0
                 Command Openings 1
                 Max Tagged Openings 0
                 Device Queue Frozen Count 0
Target 6 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 7 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 8 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 9 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 10 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 11 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 12 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 13 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 14 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 15 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)

> Also, if it's a multi-device bus is the problem caused by a single
> device (as in do a binary search pulling things off the bus).

There is 1 disk, 2 CD drives, and 1 zip drive. The system is booting 
from the disk, which makes this a bit tricky. The same problem still 
occurs when the CD and zip drives have been disconnected.

Daniel

