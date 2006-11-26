From: "roland" <devzero@web.de>
Subject: Re: Disable SCSI-Reservation at the driver level ?
Date: Sun, 26 Nov 2006 20:22:25 +0100
Message-ID: <0ce401c71190$34ba35d0$eeeea8c0@aldipc>
References: <0ca701c71178$528eb3a0$eeeea8c0@aldipc> <1164563196.13612.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:2195 "EHLO
	fmmailgate03.web.de") by vger.kernel.org with ESMTP id S935556AbWKZTU5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Nov 2006 14:20:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

> There's no SCSI fix for this ... the SAT has no translation for the SCSI
> reservation commands, largely because there's no corresponding ATA
> equivalent and even for SCSI devices they may fail anyway.  The
> application should cope with such a failure, so in this case it's the
> application that needs fixing.

yes, sure i cannot translate a SCSI reservation command into SATA equivalent 
because SATA doesn`t support.
but i`m unsure, what sense does SCSI reservation does make with local 
storage, anyway - because there is no concurrent access in this scenario.
ESX is very SAN oriented, and in nearly all cases SCSI is being used as 
storage, so SCSI reservation will ususally "just work", regardless if being 
needed or not.
I assume it`s not really needed with local storage, but i`m not sure here.
So if the application issues SCSI reservation and i cannot fix the 
application due to mising source, the only way to fix this is to "fake" a 
successful SCSI reservation, maybe via syscall modification (LD_PRELOAD) or 
via driver reporting success on every SCSI reservation command.

> It's most likely done via a SG_IO ioctl() but you should trace the
> application to be sure.

thanks, this is a good hint for what i should search for. i will see if i 
can find a suitable strace package for ESX (ESX doesn`t come with strace) 
and investigate

regards
roland


----- Original Message ----- 
From: "James Bottomley" <James.Bottomley@SteelEye.com>
To: "roland" <devzero@web.de>
Cc: <linux-scsi@vger.kernel.org>
Sent: Sunday, November 26, 2006 6:46 PM
Subject: Re: Disable SCSI-Reservation at the driver level ?


> On Sun, 2006-11-26 at 17:31 +0100, roland wrote:
>> VMWare ESX refuses to create VMFS Filesystem on SATA disk, attached to a
>> onBoard SAS controller (lsi1068).
>> When i raid1 two SATA disks, it works, if i use a single SATA disk, the
>> controller seems to "expose" the disk differently to the operating system
>> and creation of a VMFS fails due to missing ability to issue SCSI
>> reservation command.
>
> There's no SCSI fix for this ... the SAT has no translation for the SCSI
> reservation commands, largely because there's no corresponding ATA
> equivalent and even for SCSI devices they may fail anyway.  The
> application should cope with such a failure, so in this case it's the
> application that needs fixing.
>
>
>> Maybe i can can "workaround" this somehow ?
>> I couldn`t find a way to stop the vmkfstools (which is used to format
>> blockdevice with VMFS) issueing a SCSI reservation command, but i assume
>> this can probably be done via filtering some syscall (ioctl?) via 
>> LD_PRELOAD
>> library - i.e. wrapping vmkfstools - or maybe i can hack this at the 
>> driver
>> level, since source of the ESX storage drivers is available for download 
>> and
>> can be recompiled. :)
>
> It's most likely done via a SG_IO ioctl() but you should trace the
> application to be sure.
>
> James
>
> 

