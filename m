From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: Sym53c8xx_2 Odd Byte Data Transfer patches
Date: Tue, 14 Jun 2005 18:00:38 -0400
Message-ID: <009301c5712c$80200910$e0019d89@cybernetics.com>
References: <20050614205041.GB11655@parcelfarce.linux.theplanet.co.uk>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:14601 "EHLO
	cyborg.cybernetics.com") by vger.kernel.org with ESMTP
	id S261368AbVFNWCM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 18:02:12 -0400
In-Reply-To: <20050614205041.GB11655@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Matthew Wilcox' <matthew@wil.cx>, "'Stephens, Larry'" <larry.stephens@lsil.com>
Cc: "'Linux-Scsi@Vger. Kernel. Org (E-mail)'" <linux-scsi@vger.kernel.org>

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

