From: Berkley Shands <berkley@cs.wustl.edu>
Subject: Re: [BUG] x86_64 pci_map_sg modifies sg list - fails multiple map/unmaps
Date: Mon, 5 Jan 2004 14:00:16 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401052000.i05K0Gc0000014396@mudpuddle.cs.wustl.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cliff.cse.wustl.edu ([128.252.166.5]:65444 "EHLO
	cliff.cse.wustl.edu") by vger.kernel.org with ESMTP id S265350AbUAEUAT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2004 15:00:19 -0500
List-Id: linux-scsi@vger.kernel.org
To: berkley@cs.wustl.edu, davem@redhat.com
Cc: gibbs@scsiguy.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

	   		BUG_ON(s->length == 0);

		size += s->length; 

		/* Handle the previous not yet processed entries */

		if (i > start) {
			struct scatterlist *ps = &sg[i-1];
			/* Can only merge when the last chunk ends on a page 
			   boundary. */
			if (1 || !force_iommu || !need || (i-1 > start && ps->offset) ||
			    (ps->offset + ps->length) % PAGE_SIZE) { 
				if (pci_map_cont(sg, start, i, sg+out, pages, 
						 need) < 0)
					goto error;

If I totally disable coalescing, in arch/x86_64/pci-gart.c by adding the if (1 || ...
then the bughalt goes away. So might some performance, but a system that runs is
MUCH better than one that hard faults on a regular basis.

The shipped scsi driver still needs to be updated to NOT "offline" the drives.
the 2.0.5 driver does this quite well.

Thank you.

berkley
