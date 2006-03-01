From: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Subject: RE: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Wed, 1 Mar 2006 12:57:12 -0800
Message-ID: <8C064C48AB104B428CBA524C342357CA34CFC4@aime2k05.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:30162 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751889AbWCAU5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 15:57:38 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>

I have located an HP machine that is the same flavor as James' (HP
Integrity rx2600: ia64 with zx1 chipset).  It exhibits the same problem.
I believe that the architecture may differ with traditional PC/PCI
architectures in how it deals with non-aligned PCI access.  When I
converted the OCM initialization code to write on qwords instead of
dwords, the code was able to pass OCM initialization.  It is possible
that the machine is doing a qword read/modify/write when accessing OCM
memory, which would explain the hang.  I haven't hooked up a PCI
analyzer.  The code now gets to the point where it is trying to read
NVRAM in order to get the SAS address.  It seems that the machine is
unable to retrieve non-aligned byte accesses correctly.  I will convert
the code to pull the correct byte/word/dword from the aligned qword.
We'll see if that fixes it.  None of these behaviors are exhibited on
x86, x86_64, powerpc, and ia64 without the zx1 chipset.  I understand
that there may be a few ARM implementations that have similar issues.

Mike: any word on getting James a machine?

Rob

> -----Original Message-----
> From: Jeff Garzik [mailto:jgarzik@pobox.com]
> Sent: Wednesday, March 01, 2006 12:23 PM
> To: Tarte, Robert
> Cc: Mike Anderson; James Bottomley; linux-scsi@vger.kernel.org;
> Tarte@us.ibm.com; Jeff Garzik
> Subject: Re: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
> 
> Tarte, Robert wrote:
> > What model ia64 are you running James?  I'll see if Adaptec has one
to
> > try to help reproduce this issue.  Jeff, have you tried the fixes to
see
> > if they addressed the issues you were seeing (OCM error when BIOS
off
> > and booted off of SCSI)?
> 
> Nah, I'm just waiting for James to ACK that things work on his side,
> really...
> 
> 	Jeff

