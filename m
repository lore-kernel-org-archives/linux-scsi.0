From: Anton Blanchard <anton@samba.org>
Subject: emulex FC driver on ppc64
Date: Sat, 10 Apr 2004 12:21:24 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040410022124.GI18493@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:54708 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S261815AbUDJCZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2004 22:25:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: linux-scsi@vger.kernel.org


Hi James,

I gave the sourceforge version of the emulex FC driver a spin on my
ppc64 box. Good news is it worked out of the box. I had a few
observations:

1. request_irq uses SA_INTERRUPT and SA_SHIRQ. I cant see mixing these
flags could be safe, and I doubt you need the SA_INTERRUPT in the first
place. Removing it also makes it easier to use timer tick profiling
because the interrupt routing runs with irqs on.

2. We now have dma_mapping_error so you can kill the NO_TCE, -1 hacks.

3. A number of the files need to be un dosified, they have carriage
returns in them.

4. lpfc_bad_scatterlist is pretty nasty stuff. If its going to be
impossible to get your firmware guys to fix this issue we could look at
working around it in the ppc64 IOMMU code. At least then we wont have to
walk each SG list, however theres every chance another architecture is
going to have the same problem.

5. #define MAX_ELX_BRDS 32
Do we need a hard limit? Can we just dynamically allocate the
structures? 32 is going to be way too small for some of our setups.
btw your MODULE_PARM code is scary :)

Anton
