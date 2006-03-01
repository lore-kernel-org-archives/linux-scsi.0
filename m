From: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Subject: RE: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Wed, 1 Mar 2006 13:22:56 -0800
Message-ID: <8C064C48AB104B428CBA524C342357CA34CFC5@aime2k05.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:13781 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751269AbWCAVX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 16:23:27 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jgarzik@pobox.com>, Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>

> -----Original Message-----
> From: Matthew Wilcox [mailto:matthew@wil.cx]
> Sent: Wednesday, March 01, 2006 1:12 PM
> To: Tarte, Robert
> Cc: Jeff Garzik; Mike Anderson; James Bottomley; linux-
> scsi@vger.kernel.org; Jeff Garzik
> Subject: Re: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
> 
> On Wed, Mar 01, 2006 at 12:57:12PM -0800, Tarte, Robert wrote:
> > I have located an HP machine that is the same flavor as James' (HP
> > Integrity rx2600: ia64 with zx1 chipset).  It exhibits the same
problem.
> > I believe that the architecture may differ with traditional PC/PCI
> > architectures in how it deals with non-aligned PCI access.  When I
> > converted the OCM initialization code to write on qwords instead of
> > dwords, the code was able to pass OCM initialization.  It is
possible
> > that the machine is doing a qword read/modify/write when accessing
OCM
> > memory, which would explain the hang.  I haven't hooked up a PCI
> > analyzer.  The code now gets to the point where it is trying to read
> > NVRAM in order to get the SAS address.  It seems that the machine is
> > unable to retrieve non-aligned byte accesses correctly.  I will
convert
> > the code to pull the correct byte/word/dword from the aligned qword.
> > We'll see if that fixes it.  None of these behaviors are exhibited
on
> > x86, x86_64, powerpc, and ia64 without the zx1 chipset.  I
understand
> > that there may be a few ARM implementations that have similar
issues.
> 
> You're saying that you do an 8-byte non-DMA write to an address
> that's congruent to 4 mod 8?  Based on briefly skimming the internal
> documentation for zx1, I'd say you're invoking undefined behaviour.

Thanks for the confirmation.  Internal documentation for zx1?  Where can
I locate this?  Thanks in advance.

> > -
> > To unsubscribe from this list: send the line "unsubscribe
linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


