From: "Stephens, Larry" <larry.stephens@lsil.com>
Subject: RE: Sym53c8xx_2 Odd Byte Data Transfer patches
Date: Wed, 15 Jun 2005 06:16:41 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C013519D9@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:32685 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261422AbVFOMQ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 08:16:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'tonyb@cybernetics.com'" <tonyb@cybernetics.com>, 'Matthew Wilcox' <matthew@wil.cx>
Cc: "'Linux-Scsi@Vger. Kernel. Org (E-mail)'" <linux-scsi@vger.kernel.org>, "Wade, Roy" <Roy.Wade@lsil.com>

This fix handles the case where an application requests that an odd number
of bytes of data be transferred either from or to a wide (16 bit) device
(usually a tape drive) on an LSI Logic adapter controlled by the sym53c8xx_2
driver.

Our customer has provided us with an application that allows a user to
specify how many bytes of data to write or read from the wide tape drive.
Baring an NDA agreement, I probably could provide the application if
necessary.

-----Original Message-----
From: Tony Battersby [mailto:tonyb@cybernetics.com]
Sent: Tuesday, June 14, 2005 3:01 PM
To: 'Matthew Wilcox'; 'Stephens, Larry'
Cc: 'Linux-Scsi@Vger. Kernel. Org (E-mail)'
Subject: RE: Sym53c8xx_2 Odd Byte Data Transfer patches


> While this patch does seem to solve the problem of transferring an odd
> number of bytes to the device, I recently received a bug report saying
> that we don't accept an odd number of bytes transferred from a device.
> It seems to me that it's going to require modifying the scsi
> scripts in
> order to do this.  Do you agree?  Have you looked into
> transfers in the
> opposite direction as part of this work?

If a target sends an odd number of bytes during a wide DATA IN phase,
then it should send an IGNORE WIDE RESIDUE message immediately after
exiting the data phase to inform the initiator.  The sym53c8xx_2 driver
in the 2.4 kernel series handles this correctly except on a REQUEST
SENSE command issued for autosense (previously sym53c8xx_2 would reject
an IWR message for autosense; I submitted a patch a good while ago to
make it ignore IWR in this case instead of rejecting it).  Not
accounting for IWR on autosense is not a big deal though, so I consider
sym53c8xx_2 in 2.4 kernels to handle odd-length DATA IN phases
acceptably.  I haven't tested the 2.6 kernels.

Anthony J. Battersby
Cybernetics
