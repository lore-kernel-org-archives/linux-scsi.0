From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFT v3] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Wed, 23 Sep 2015 07:40:07 -0700
Message-ID: <1443019207.2240.27.camel@HansenPartnership.com>
References: <20150916134211.GA21535@infradead.org>
	 <1442907023-12709-1-git-send-email-jiang.liu@linux.intel.com>
	 <5601D550.5000801@internode.on.net>
	 <1442961929.15264.4.camel@HansenPartnership.com>
	 <5601E5FE.7020706@internode.on.net> <56023771.5010006@linux.intel.com>
	 <5602829C.5090500@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5602829C.5090500@internode.on.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, Ballabio Dario <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>, Dario Ballabio <ballabio_dario@emc.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-09-23 at 20:14 +0930, Arthur Marsh wrote:
> 
> Jiang Liu wrote on 23/09/15 14:54:
> 
> > Hi Arthur,
> > 	I have found the cause of the warning messages, it's caused
> > by a flaw in the conversion. But according to my understanding,
> > it isn't related to the kexec/kdump failure. Could you please help
> > to test the attached new version?
> > Thanks!
> > Gerry
> >
> 
> Thanks, the patch worked, I could successfully unload and reload the 
> eata module, and perform a kexec reboot with the eata module loading 
> successfully afterwards.

Great, so the bug was unconditionally unregistering the platform driver
when it would fail to attach if none of the legacy IO ports were
detected.

I think the driver needs a bit of a tidy up.  There's no need at all to
use ida_get_simple(): the only reason for a dense array of numbers was
for storing the hba private data in the array you got rid of; we can now
simply use shost->host_no ... it's more useful anyway because the
numbers match those SCSI is using.

Also, if you insist on converting the printk's to dev warn, you no
longer need to print out the driver name ... dev_printk already prints
out the device and driver name as the prefix.

The if (error == 0) is usually written as if (!error) but that's minor.

Thanks for doing the conversion,

James
