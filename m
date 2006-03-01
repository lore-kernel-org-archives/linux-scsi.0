From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Wed, 1 Mar 2006 14:12:25 -0700
Message-ID: <20060301211225.GE1598@parisc-linux.org>
References: <8C064C48AB104B428CBA524C342357CA34CFC4@aime2k05.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:7333 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751908AbWCAVM0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 16:12:26 -0500
Content-Disposition: inline
In-Reply-To: <8C064C48AB104B428CBA524C342357CA34CFC4@aime2k05.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>

On Wed, Mar 01, 2006 at 12:57:12PM -0800, Tarte, Robert wrote:
> I have located an HP machine that is the same flavor as James' (HP
> Integrity rx2600: ia64 with zx1 chipset).  It exhibits the same problem.
> I believe that the architecture may differ with traditional PC/PCI
> architectures in how it deals with non-aligned PCI access.  When I
> converted the OCM initialization code to write on qwords instead of
> dwords, the code was able to pass OCM initialization.  It is possible
> that the machine is doing a qword read/modify/write when accessing OCM
> memory, which would explain the hang.  I haven't hooked up a PCI
> analyzer.  The code now gets to the point where it is trying to read
> NVRAM in order to get the SAS address.  It seems that the machine is
> unable to retrieve non-aligned byte accesses correctly.  I will convert
> the code to pull the correct byte/word/dword from the aligned qword.
> We'll see if that fixes it.  None of these behaviors are exhibited on
> x86, x86_64, powerpc, and ia64 without the zx1 chipset.  I understand
> that there may be a few ARM implementations that have similar issues.

You're saying that you do an 8-byte non-DMA write to an address
that's congruent to 4 mod 8?  Based on briefly skimming the internal
documentation for zx1, I'd say you're invoking undefined behaviour.

> Mike: any word on getting James a machine?
> 
> Rob
> 
> > -----Original Message-----
> > From: Jeff Garzik [mailto:jgarzik@pobox.com]
> > Sent: Wednesday, March 01, 2006 12:23 PM
> > To: Tarte, Robert
> > Cc: Mike Anderson; James Bottomley; linux-scsi@vger.kernel.org;
> > Tarte@us.ibm.com; Jeff Garzik
> > Subject: Re: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
> > 
> > Tarte, Robert wrote:
> > > What model ia64 are you running James?  I'll see if Adaptec has one
> to
> > > try to help reproduce this issue.  Jeff, have you tried the fixes to
> see
> > > if they addressed the issues you were seeing (OCM error when BIOS
> off
> > > and booted off of SCSI)?
> > 
> > Nah, I'm just waiting for James to ACK that things work on his side,
> > really...
> > 
> > 	Jeff
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
