From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: sata disk model/firmware length smaller
Date: Thu, 06 Jan 2011 09:23:55 +0100
Message-ID: <4D257C1B.8030708@stud.tu-ilmenau.de>
References: <201101061538027183872@gmail.com>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:60732 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1AFIcV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 03:32:21 -0500
In-Reply-To: <201101061538027183872@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "kernel.majianpeng" <kernel.majianpeng@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi,

Am 06.01.2011 08:38, schrieb kernel.majianpeng:
> 
> At present,I using WD SATA disk:
> [root@kedacom device]# smartctl -i /dev/sdo
> smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> === START OF INFORMATION SECTION ===
> Device Model:     WDC WD2003FYYS-02W0B0
> Serial Number:    WD-WMAY00749168
> Firmware Version: 01.01D01
> User Capacity:    2,000,398,934,016 bytes
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   8
> ATA Standard is:  Exact ATA specification draft version not indicated
> Local Time is:    Thu Jan  6 15:12:37 2011 UTC
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> [root@kedacom device]# cat /sys/block/sdo/device/rev 
> 01.0
> [root@kedacom device]# cat /sys/block/sdo/device/model 
> WDC WD2003FYYS-0
> I read ATA spec7, The INQUERY DEVICE command return valued:
> Firmware revision 8byte
> Model Number 40byte
> 
> This may be a bug?
> 2011-01-06 

Why should it?  Smartctl uses the ATA-Passthrough commands - the
reporting there is correct.  Your system on the other hand uses SCSI,
that's what libata is for.  You may want to also read the scsi-specs,
then you'll notice that "INQUIRE_DEVICE" scsi command allows less
characters for revision and model.

So maybe you'll want to write a feature request to the libata devs to
update the VPD via ATA commands after a disk has been detected to be ATA.

Cheers,
St0fF
> 
> 
> 
> kernel.majianpeng 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

