From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Thu, 02 Mar 2006 08:45:42 -0600
Message-ID: <1141310742.3238.6.camel@mulgrave.il.steeleye.com>
References: <8C064C48AB104B428CBA524C342357CA34CFC4@aime2k05.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:21677 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750947AbWCBOpr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 09:45:47 -0500
In-Reply-To: <8C064C48AB104B428CBA524C342357CA34CFC4@aime2k05.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>

On Wed, 2006-03-01 at 12:57 -0800, Tarte, Robert wrote:
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

Could you post the patch that gets it working?

I'd like to try on my zx2000, and I'm sure the HP ZX1 people would like
to see it to try and work out what's going on on the ZX1 bus.

Thanks,

James


