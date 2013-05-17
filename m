From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: mpt2sas,mpt3sas watchdog device removal
Date: Fri, 17 May 2013 17:42:37 -0400
Message-ID: <20130517174237.3b4a431a@jlaw-desktop.mno.stratus.com>
References: <20130515132401.6a8ff7fb@jlaw-desktop.mno.stratus.com>
	<20130515132948.7dc4c551@jlaw-desktop.mno.stratus.com>
	<CAErSpo4OU2LRdmBLNBMbw79fYiR4yqYVJ++2ecju0qBNhAp-vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAErSpo4OU2LRdmBLNBMbw79fYiR4yqYVJ++2ecju0qBNhAp-vA@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 17 May 2013 09:29:06 -0600
Bjorn Helgaas <bhelgaas@google.com> wrote:

> [+cc linux-pci]
> 
> On Wed, May 15, 2013 at 11:29 AM, Joe Lawrence
> <joe.lawrence@stratus.com> wrote:
> > From 84ac7a35ebd61e84d4254eae78bb967de17254c2 Mon Sep 17 00:00:00
> > 2001 From: Joe Lawrence <joe.lawrence@stratus.com>
> > Date: Wed, 15 May 2013 12:52:31 -0400
> > Subject: [PATCH] mpt2sas,mpt3sas: make watchdog instantiated device
> > removal safe
> >
> > Calling pci_stop_and_remove_bus_device from a SCSI LLD may introduce
> > device removal races with PCI callback functions.
> >
> > Simplify the mpt2sas watchdog mechanism by separating PCI device
> > removal from SCSI midlayer detachment. When the watchdog wishes to
> > remove a SCSI device from the topology, detach from the SCSI
> > midlayer, leaving the PCI device alone. Adjust various pci_driver
> > callbacks to account for a potentially SCSI detached PCI device.
> 
> I don't know the details of the SCSI detachment, but this approach
> looks much cleaner to me.

Thanks for commenting, Bjorn.  I think this approach more closely
represents what this watchdog is trying to accomplish.  

Off list, Sreekanth from LSI tested and noticed a few issues with this
patch:

 - mpt2sas_base_stop_watchdog is called twice: The call from
   mpt2sas_base_detach is safe, but now unnecessary (as a call was
   added earlier up in the PCI driver callbacks to ensure that the
   watchdog was out of the way.) This second invocation can be removed.

 - If the watchdog detects a bad IOC, the watchdog remains running:
   The watchdog workqueue isn't cleaned up until
   mpt2sas_base_stop_watchdog is called, so in the case that the
   watchdog removes the device from SCSI topo, the workqueue will
   remain unused until PCI .remove/.shutdown cleans it up. Perhaps a
   single watchdog that iterates over all adapters would be simpler?

Finally, if SCSI topo detachment is all that is interesting here, would
it make more sense to move the watchdog into the MPT "scsi" code?  I
haven't looked at the code yet, but this might make an MPT fusion patch
easier (due to dependencies between its "scsi" and "base" modules).

Regards,

-- Joe
