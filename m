From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] PCI/MSI: don't apply affinity if there aren't enough
        vectors left
Date: Thu, 2 Feb 2017 19:32:16 +0100
Message-ID: <20170202183216.GA8385@lst.de>
References: <1485778541-28994-1-git-send-email-hch@lst.de> <20170202173659.GD21267@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170202173659.GD21267@bhelgaas-glaptop.roam.corp.google.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, bhelgaas@google.com, bart.vanassche@sandisk.com, tglx@linutronix.de, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 02, 2017 at 11:36:59AM -0600, Bjorn Helgaas wrote:
> You didn't say exactly where the out of bounds access was, but I assume
> it's probably in irq_create_affinity_masks() in this path:

Yes.  See the original report from Bart here:

http://www.spinics.net/lists/linux-scsi/msg104082.html

> The fix in pci_alloc_irq_vectors_affinity() looks fine, but I wish it
> were closer to the actual problem.

I plan to also fix the low-level issue, but:

 a) I have other patches pending in that are for 4.11 and I'd like
    to batch them up with those to avoid conflicts
 b) we really need a high-level check like the one added in this
    patch so that we do the right thing (drop affinity) in this
    case instead of returning an error to the caller and failing
    the probe.
