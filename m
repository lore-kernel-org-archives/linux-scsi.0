From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: Repeatable Kernel Panic on Adaptec 2015S I20 device on bootup
Date: Mon, 25 Jul 2005 23:17:19 +0200
Message-ID: <42E556DF.2010406@shadowconnect.com>
References: <1671.206.173.47.7.1122320965.squirrel@mail.gravityedge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s0003.shadowconnect.net ([213.239.201.226]:14856 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S261432AbVGYVJu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 17:09:50 -0400
In-Reply-To: <1671.206.173.47.7.1122320965.squirrel@mail.gravityedge.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joshuam@gravityedge.com
Cc: linux-scsi@vger.kernel.org

Hello,

joshuam@gravityedge.com wrote:
> 1. Repeatable Kernel Panic on Adaptec 2015S I20 device on bootup
> 2. I can get this to panic on every bootup, I have included the Kernel
> boot output below.
> 3. Linux SCSI panic Adaptec 2015 bootup
> 4. Kernel version: 2.6.12.3
> 5. Kernel Output/Oops
> Linux version 2.6.12.3 (root@graviton.krk0) (gcc version 3.3.5 (Debian
> 1:3.3.5-
> )) #2 SMP Fri Jul 22 14:52:48 PDT 2005
> [...]
> Loading Adaptec I2O RAID: Version 2.4 Build 5go
> Detecting Adaptec I2O RAID controllers...
> Adaptec I2O RAID controller 0 irq=30
>      BAR0 e0900000 -
>      BAR1 e0a80000 - size= 1000000
> dpti: If you have a lot of devices this could take a few minutes.
> dpti0: Reading the hardware resource table.

here the dpt_i2o driver is loaded...

> TID 008  Vendor: ADAPTEC      Device: AIC-7902     Rev: 00000001
> TID 009  Vendor: ADAPTEC      Device: AIC-7902     Rev: 00000001
> TID 513  Vendor: SUPER   G    Device: GEM318       Rev: 0   0
> scsi0 : Vendor: Adaptec  Model: 2015S            FW:3B0A
>   Vendor: SUPER     Model: GEM318            Rev: 0
>   Type:   Processor                          ANSI SCSI revision: 02
> megaraid cmm: 2.20.2.5 (Release Date: Fri Jan 21 00:01:03 EST 2005)
> megaraid: 2.20.4.5 (Release Date: Thu Feb 03 12:27:22 EST 2005)
> 3ware Storage Controller device driver for Linux v1.26.02.001.
> 3ware 9000 Storage Controller device driver for Linux v2.26.02.002.
> Attached scsi generic sg0 at scsi0, channel 0, id 6, lun 0,  type 3
> I2O subsystem v$Rev$

and here the I2O subsystem...

> i2o: max drivers = 8
> i2o: Checking for PCI I2O controllers...
> i2o: I2O controller found on bus 3 at 24.
> iop0: PCI I2O controller
>      BAR0 at 0xF8300000 size=1048576
>      BAR1 at 0xFB000000 size=16777216
> iop0: using write combining MTRR
> iop0: Installed at IRQ 30
> iop0: Activating I2O controller...
> iop0: This may take a few minutes if there are many devices
> Unable to handle kernel paging request at virtual address 8000002c
 > [...]

The problem is caused, because two different drivers for the same device 
are loaded at the same time. You have to remove either the I2O subsystem 
or the dpt_i2o driver, both at the same time won't work...



Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
