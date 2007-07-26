From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 8366] aic79xx and aic7xxx driver issues
Date: Thu, 26 Jul 2007 11:05:41 -0400
Message-ID: <1185462341.3501.62.camel@localhost.localdomain>
References: <20070725010525.614621080E4@picon.linux-foundation.org>
	 <1185329683.3488.46.camel@localhost.localdomain>
	 <1185461780.14419.17.camel@fea.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:42590 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755861AbXGZPFm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 11:05:42 -0400
In-Reply-To: <1185461780.14419.17.camel@fea.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: freelsjd@ornl.gov
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2007-07-26 at 10:56 -0400, Freels, James D. wrote:
> James, I have been out for a couple of days and could not try this
> yet.
> 
> Presently, the system is booted up under 2.6.18.8 which is not the
> troublesome kernel.
> 
> However, I tried your suggestion below, using max_width instead of
> max_wide.

Yes ... sorry should have looked instead of doing it from memory.

>  I get the following while sshed to the system remotely:
> 
> fea8:~# echo 0 > /sys/class/spi_transport/target0:0:3/max_width
> fea8:~# echo 1 > /sys/class/spi_transport/target0:0:3/revalidate

This should produce output in dmesg to indicate the device speeds were
rescanned.

> fea8:~# cat /sys/class/spi_transport/target0:0:3/max_width
> 0
> fea8:~# cat /sys/class/spi_transport/target0:0:3/revalidate
> cat: /sys/class/spi_transport/target0:0:3/revalidate: Permission
> denied
> 
> So, instead, I shifted through the dmesg file to find this string:
> 
> scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>         <Adaptec 29160N Ultra160 SCSI adapter>
>         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> 
> Further the output from 
> 
> cat /proc/scsi/aic7xxx/0 
> 
> gives
> 
> Adaptec AIC7xxx driver version: 7.0
> Adaptec 29160N Ultra160 SCSI adapter
> aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> Allocated SCBs: 4, SG List Length: 128
> 
> Serial EEPROM:
> 0x439d 0x439d 0x439d 0x439d 0x439d 0x439d 0x439d 0x439d
> 0x00d0 0x00d0 0x00d0 0x00d0 0x00d0 0x00d0 0x00d0 0x00d0
> 0x08f4 0x6c5d 0x2807 0x0010 0x0300 0xffff 0xffff 0xffff
> 0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0xc617
> 
> Target 0 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz DT, offset 127)
> Target 1 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz DT, offset 127)
> Target 2 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz DT, offset 127)
> Target 3 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz DT, offset 127)
>         Goal: 20.000MB/s transfers (20.000MHz, offset 32)
>         Curr: 20.000MB/s transfers (20.000MHz, offset 32)
>         Channel A Target 3 Lun 0 Settings
>                 Commands Queued 216
>                 Commands Active 0
>                 Command Openings 1
>                 Max Tagged Openings 0
>                 Device Queue Frozen Count 0
> Target 4 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz DT, offset 127)
> Target 5 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz DT, offset 127)
> Target 6 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz DT, offset 127)
>         Goal: 20.000MB/s transfers (20.000MHz, offset 32)
>         Curr: 20.000MB/s transfers (20.000MHz, offset 32)
>         Channel A Target 6 Lun 0 Settings
>                 Commands Queued 1342313
>                 Commands Active 0
>                 Command Openings 1
>                 Max Tagged Openings 0
>                 Device Queue Frozen Count 0
> Target 7 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz DT, offset 127)
> Target 8 Negotiation Settings
>         User: 3.300MB/s transfers
> Target 9 Negotiation Settings
>         User: 3.300MB/s transfers
> Target 10 Negotiation Settings
>         User: 3.300MB/s transfers
> Target 11 Negotiation Settings
>         User: 3.300MB/s transfers
> Target 12 Negotiation Settings
>         User: 3.300MB/s transfers
> Target 13 Negotiation Settings
>         User: 3.300MB/s transfers
> Target 14 Negotiation Settings
>         User: 3.300MB/s transfers
> Target 15 Negotiation Settings
>         User: 3.300MB/s transfers
> 
> So, it looks like indeed, I have a narrow device.
> 
> Looking through
> the /usr/src/linux-2.6.22.1/Documentation/scsi/aic7xxx.txt file for
> dependence on aic7892 driver, I find:
> 
>   AHA-29160N     aic7892   PCI/32      LVD-HD68F       SE-HD50F
>                                          SE-50M
> 
> So, it is using the driver, but seems to indicate a wide or narrow
> capability.

Yes, all aic7xxx cards are wide capable

> Is there any way to force narrow bus ?  Perhaps the card is in a
> 64-bit slot and needs to be in a 32-bit slot ? 

That's what the two echos do.  The domain validation is supposed to
detect a narrow device on a wide cable, but it looks to be failing
somehow ... although we won't know this for definite until you try it on
the latest kernel.

The way to force narrow it to set it in the aic bios if you can.  The
driver picks up that setting and places it in max_width.

James


