From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: emulex FC driver on ppc64
Date: Sat, 10 Apr 2004 20:18:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C01652@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:1253 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S262176AbUDKAS3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2004 20:18:29 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Anton Blanchard' <anton@samba.org>
Cc: linux-scsi@vger.kernel.org

Anton,

Thanks for the feedback. I know we've only recently been working things out
on the PPC64.  Most of the things look pretty minor - we should be able to
get them in shortly. As for the MAX 32 - we've been looking at raising the
count as well, but prioritized it below all the other work items we've got
on the current list.

-- James S


> -----Original Message-----
> From: Anton Blanchard [mailto:anton@samba.org]
> Sent: Friday, April 09, 2004 10:21 PM
> To: Smart, James
> Cc: linux-scsi@vger.kernel.org
> Subject: emulex FC driver on ppc64
> 
> 
> 
> Hi James,
> 
> I gave the sourceforge version of the emulex FC driver a spin on my
> ppc64 box. Good news is it worked out of the box. I had a few
> observations:
> 
> 1. request_irq uses SA_INTERRUPT and SA_SHIRQ. I cant see mixing these
> flags could be safe, and I doubt you need the SA_INTERRUPT in 
> the first
> place. Removing it also makes it easier to use timer tick profiling
> because the interrupt routing runs with irqs on.
> 
> 2. We now have dma_mapping_error so you can kill the NO_TCE, -1 hacks.
> 
> 3. A number of the files need to be un dosified, they have carriage
> returns in them.
> 
> 4. lpfc_bad_scatterlist is pretty nasty stuff. If its going to be
> impossible to get your firmware guys to fix this issue we 
> could look at
> working around it in the ppc64 IOMMU code. At least then we 
> wont have to
> walk each SG list, however theres every chance another architecture is
> going to have the same problem.
> 
> 5. #define MAX_ELX_BRDS 32
> Do we need a hard limit? Can we just dynamically allocate the
> structures? 32 is going to be way too small for some of our setups.
> btw your MODULE_PARM code is scary :)
> 
> Anton
> 
