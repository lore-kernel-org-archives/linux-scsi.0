From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH] PCI/MSI: don't apply affinity if there aren't enough
 vectors left
Date: Thu, 2 Feb 2017 16:38:48 -0600
Message-ID: <20170202223848.GA11138@bhelgaas-glaptop.roam.corp.google.com>
References: <1485778541-28994-1-git-send-email-hch@lst.de>
 <20170202173659.GD21267@bhelgaas-glaptop.roam.corp.google.com>
 <20170202183216.GA8385@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751861AbdBBWiy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Feb 2017 17:38:54 -0500
Content-Disposition: inline
In-Reply-To: <20170202183216.GA8385@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: bhelgaas@google.com, bart.vanassche@sandisk.com, tglx@linutronix.de, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Feb 02, 2017 at 07:32:16PM +0100, Christoph Hellwig wrote:
> On Thu, Feb 02, 2017 at 11:36:59AM -0600, Bjorn Helgaas wrote:
> > You didn't say exactly where the out of bounds access was, but I assume
> > it's probably in irq_create_affinity_masks() in this path:
> 
> Yes.  See the original report from Bart here:
> 
> http://www.spinics.net/lists/linux-scsi/msg104082.html
> 
> > The fix in pci_alloc_irq_vectors_affinity() looks fine, but I wish it
> > were closer to the actual problem.
> 
> I plan to also fix the low-level issue, but:
> 
>  a) I have other patches pending in that are for 4.11 and I'd like
>     to batch them up with those to avoid conflicts
>  b) we really need a high-level check like the one added in this
>     patch so that we do the right thing (drop affinity) in this
>     case instead of returning an error to the caller and failing
>     the probe.

OK.  I applied this to for-linus for v4.10.

I think b) refers to this piece:

  +   /*
  +    * If there aren't any vectors left after applying the pre/post
  +    * vectors don't bother with assigning affinity.
  +    */
  +   if (affd->pre_vectors + affd->post_vectors == min_vecs)
  +           affd = NULL;

I think this can be (and really should be) fixed in
irq_create_affinity_masks(), which can also ignore affinity without
returning an error to the caller of pci_alloc_irq_vectors_affinity().
But I guess it's ok to also check here.

Thanks for reminding me to pick this up for v4.10.

Bjorn
