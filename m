From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: mpt2sas,mpt3sas watchdog device removal
Date: Mon, 21 Oct 2013 10:24:38 -0400
Message-ID: <20131021102438.4b32b920@jlaw-desktop.mno.stratus.com>
References: <20130515132401.6a8ff7fb@jlaw-desktop.mno.stratus.com>
	<20130515132948.7dc4c551@jlaw-desktop.mno.stratus.com>
	<CAErSpo4OU2LRdmBLNBMbw79fYiR4yqYVJ++2ecju0qBNhAp-vA@mail.gmail.com>
	<20130517174237.3b4a431a@jlaw-desktop.mno.stratus.com>
	<CAErSpo4=6=3+VNgw9rKBoYO92DMnbPp0NZW5Z_j4WweKTymjmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAErSpo4=6=3+VNgw9rKBoYO92DMnbPp0NZW5Z_j4WweKTymjmg@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 10 Oct 2013 15:59:28 -0600
Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Fri, May 17, 2013 at 3:42 PM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> > On Fri, 17 May 2013 09:29:06 -0600
> > Bjorn Helgaas <bhelgaas@google.com> wrote:
> >
> >> [+cc linux-pci]
> >>
> >> On Wed, May 15, 2013 at 11:29 AM, Joe Lawrence
> >> <joe.lawrence@stratus.com> wrote:
> >> > From 84ac7a35ebd61e84d4254eae78bb967de17254c2 Mon Sep 17 00:00:00
> >> > 2001 From: Joe Lawrence <joe.lawrence@stratus.com>
> >> > Date: Wed, 15 May 2013 12:52:31 -0400
> >> > Subject: [PATCH] mpt2sas,mpt3sas: make watchdog instantiated device
> >> > removal safe
> >> >
> >> > Calling pci_stop_and_remove_bus_device from a SCSI LLD may introduce
> >> > device removal races with PCI callback functions.
> >> >
> >> > Simplify the mpt2sas watchdog mechanism by separating PCI device
> >> > removal from SCSI midlayer detachment. When the watchdog wishes to
> >> > remove a SCSI device from the topology, detach from the SCSI
> >> > midlayer, leaving the PCI device alone. Adjust various pci_driver
> >> > callbacks to account for a potentially SCSI detached PCI device.
> >>
> >> I don't know the details of the SCSI detachment, but this approach
> >> looks much cleaner to me.
> >
> > Thanks for commenting, Bjorn.  I think this approach more closely
> > represents what this watchdog is trying to accomplish.
> >
> > Off list, Sreekanth from LSI tested and noticed a few issues with this
> > patch:
> >
> >  - mpt2sas_base_stop_watchdog is called twice: The call from
> >    mpt2sas_base_detach is safe, but now unnecessary (as a call was
> >    added earlier up in the PCI driver callbacks to ensure that the
> >    watchdog was out of the way.) This second invocation can be removed.
> >
> >  - If the watchdog detects a bad IOC, the watchdog remains running:
> >    The watchdog workqueue isn't cleaned up until
> >    mpt2sas_base_stop_watchdog is called, so in the case that the
> >    watchdog removes the device from SCSI topo, the workqueue will
> >    remain unused until PCI .remove/.shutdown cleans it up. Perhaps a
> >    single watchdog that iterates over all adapters would be simpler?
> >
> > Finally, if SCSI topo detachment is all that is interesting here, would
> > it make more sense to move the watchdog into the MPT "scsi" code?  I
> > haven't looked at the code yet, but this might make an MPT fusion patch
> > easier (due to dependencies between its "scsi" and "base" modules).
> 
> Hi Joe,
> 
> I noticed this when looking through old email.  I can't remember if
> anything happened with this.  It seems like nice work; did it go
> anywhere?

Hello Bjorn,

Sorry for the late reply, I was on vacation last week.

This patchset started as an attempt to push upstream some of the
changes that Stratus makes to the fusion/mpt* drivers.  I had hoped to
come up with a patchset that fixed hotplug vs. watchdog removal in each
of the three LSI drivers.  Unfortunately this was more of a spare time
project and other work took priority.

There is a chance that Stratus maybe revisiting the fusion driver in
the near future.  I will keep this patchset in mind if that happens.

Regards,

-- Joe
