From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [PATCH] 2.6.3 qla2xxx driver -- use readX_relaxed
Date: Mon, 1 Mar 2004 16:45:49 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EE25@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:48336 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S261523AbUCBApZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Mar 2004 19:45:25 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: linux-scsi@vger.kernel.org

On Wednesday, February 25, 2004 8:06 PM,
linux-scsi-owner@vger.kernel.org wrote: 
> For those to whom this is new (it was discussed on linux-kernel and
> linux-ia64 I believe), normal PCI register reads imply that PCI DMA
> writes that occured prior to the PCI MMR (memory mapped register)
> read (on the PCI bus) will be reflected in system memory once the
> MMR read is complete.
> 
> On our platforms, we can speed up the MMR read significantly if that
> ordering requirement is "relaxed".
> 

Interesting...but this implementation seems to be applying a different
set of semantic rules to the term 'relaxed' in comparison to the
'relaxed ordering' rules defined by PCI-X and PCI-Express, no?

> So I attempted to find the common register reads that don't have a
> need for this ordering so that I could make them use this faster
> read.
> 
> I did not change this line (111 of drivers/scsi/qla2xxx/qla_isr.c),
> because it may in some cases imply that a DMA write has completed.
> 
> 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
> 

Yes in several cases it would.

> Andrew, if you have a chance to look at this and incorporate it in
> the driver, it would be great.  Also, any comments would be welcome.
> 

Sounds good, I just wish I had an Altix machine to test with.  You
seem to have covered most of the fast-path cases, I'll look some more
tonight for any others.  I guess my only nit-pick is the lowercase
_relaxed() suffix applied to RD_REG* #defines.

Thanks,
Andrew Vasquez
