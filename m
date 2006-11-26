From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Disable SCSI-Reservation at the driver level ?
Date: Sun, 26 Nov 2006 11:46:35 -0600
Message-ID: <1164563196.13612.3.camel@localhost.localdomain>
References: <0ca701c71178$528eb3a0$eeeea8c0@aldipc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38786 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S935482AbWKZRql (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Nov 2006 12:46:41 -0500
In-Reply-To: <0ca701c71178$528eb3a0$eeeea8c0@aldipc>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roland <devzero@web.de>
Cc: linux-scsi@vger.kernel.org

On Sun, 2006-11-26 at 17:31 +0100, roland wrote:
> VMWare ESX refuses to create VMFS Filesystem on SATA disk, attached to a 
> onBoard SAS controller (lsi1068).
> When i raid1 two SATA disks, it works, if i use a single SATA disk, the 
> controller seems to "expose" the disk differently to the operating system 
> and creation of a VMFS fails due to missing ability to issue SCSI 
> reservation command.

There's no SCSI fix for this ... the SAT has no translation for the SCSI
reservation commands, largely because there's no corresponding ATA
equivalent and even for SCSI devices they may fail anyway.  The
application should cope with such a failure, so in this case it's the
application that needs fixing.


> Maybe i can can "workaround" this somehow ?
> I couldn`t find a way to stop the vmkfstools (which is used to format 
> blockdevice with VMFS) issueing a SCSI reservation command, but i assume 
> this can probably be done via filtering some syscall (ioctl?) via LD_PRELOAD 
> library - i.e. wrapping vmkfstools - or maybe i can hack this at the driver 
> level, since source of the ESX storage drivers is available for download and 
> can be recompiled. :)

It's most likely done via a SG_IO ioctl() but you should trace the
application to be sure.

James


