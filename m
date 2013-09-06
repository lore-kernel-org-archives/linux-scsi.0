From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] PCI: add quirk for 3ware 9650SE controller
Date: Fri, 6 Sep 2013 11:51:19 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1309061150140.26934@pobox.suse.cz>
References: <alpine.LNX.2.00.1308271141080.2077@pobox.suse.cz> <alpine.LNX.2.00.1308271144420.2077@pobox.suse.cz> <alpine.LNX.2.00.1308281745460.4557@pobox.suse.cz> <CAErSpo6saRNMw6Js0PLXZzYDdH0M3ypSFLDxVxp0G02aetp0Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAErSpo6saRNMw6Js0PLXZzYDdH0M3ypSFLDxVxp0G02aetp0Dw@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Adam Radford <aradford@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 28 Aug 2013, Bjorn Helgaas wrote:

> [+cc another email addr for Adam from git logs]

Thanks. Adam, would you happen to have any possible explanation / 
background?

> >> > Commit d5dea7d95 ("PCI: msi: Disable msi interrupts when we initialize a
> >> > pci device") makes MSIs be forcibly disabled at boot time.
> >> >
> >> > It turns out that this breaks 3ware controller -- if MSIs are disabled
> >> > during PCI discovery of this controller, the device doesn't work properly
> >> > (it doesn't respond to any commands that are being sent to it after
> >> > initialization).
> >> >
> >> > Reverting d5dea7d95 or not force-disabling MSIs in pci_msi_init_pci_dev()
> >> > makes the device work properly again.
> >> >
> >> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> >> >
> >> > ---
> >> >
> >> > I am adding Adam Radford as a recepient as well, to see whether he is able
> >> > to provide some more explanation why this device would expose this
> >> > behavior.
> >
> > OK, so Adam Radford's lsi.com address is bouncing, hence I guess we can't
> > expect any feedback from him.
> >
> > Bjorn, Jesse, any word on this please?
> 
> It's on my list to look at.  It's too late to put it in for v3.11, and
> it's doubtful that it will even make the v3.12 merge window (though
> possibly it could go in post-merge window).  d5dea7d95 is several
> years old, so hopefully this issue isn't super-urgent.  Let me know if
> otherwise.

I agree that this should be applicable to 3.12-rcX as well, as it's very 
device-specific.

Thanks.

> 
> Bjorn
> 
> >> >  drivers/pci/msi.c    |    3 +++
> >> >  drivers/pci/quirks.c |   10 ++++++++++
> >> >  include/linux/pci.h  |    1 +
> >> >  3 files changed, 14 insertions(+), 0 deletions(-)
> >> >
> >> > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> >> > index aca7578..4f36b8b 100644
> >> > --- a/drivers/pci/msi.c
> >> > +++ b/drivers/pci/msi.c
> >> > @@ -1040,6 +1040,9 @@ void pci_msi_init_pci_dev(struct pci_dev *dev)
> >> >  {
> >> >     INIT_LIST_HEAD(&dev->msi_list);
> >> >
> >> > +   if (dev->broken_msi_disable)
> >> > +           return;
> >> > +
> >> >     /* Disable the msi hardware to avoid screaming interrupts
> >> >      * during boot.  This is the power on reset default so
> >> >      * usually this should be a noop.
> >> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> >> > index e85d230..4ba3400 100644
> >> > --- a/drivers/pci/quirks.c
> >> > +++ b/drivers/pci/quirks.c
> >> > @@ -2890,6 +2890,16 @@ static void quirk_intel_ntb(struct pci_dev *dev)
> >> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0e08, quirk_intel_ntb);
> >> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0e0d, quirk_intel_ntb);
> >> >
> >> > +/*
> >> > + * 3ware 9650SE controller doesn't properly initialize if MSI are
> >> > + * disabled on it during PCI device discovery
> >> > + */
> >> > +static void quirk_broken_msi_disable(struct pci_dev *dev)
> >> > +{
> >> > +   dev->broken_msi_disable = 1;
> >> > +}
> >> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_3WARE, 0x1004, quirk_broken_msi_disable);
> >> > +
> >> >  static ktime_t fixup_debug_start(struct pci_dev *dev,
> >> >                              void (*fn)(struct pci_dev *dev))
> >> >  {
> >> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> >> > index 0fd1f15..c327d74 100644
> >> > --- a/include/linux/pci.h
> >> > +++ b/include/linux/pci.h
> >> > @@ -341,6 +341,7 @@ struct pci_dev {
> >> >  #ifdef CONFIG_PCI_MSI
> >> >     struct list_head msi_list;
> >> >     struct kset *msi_kset;
> >> > +   unsigned int    broken_msi_disable:1;
> >> >  #endif
> >> >     struct pci_vpd *vpd;
> >> >  #ifdef CONFIG_PCI_ATS
> >> >
> >> > --
> >> > Jiri Kosina
> >> > SUSE Labs
> >> >
> >>
> >> --
> >> Jiri Kosina
> >> SUSE Labs
> >>
> >
> > --
> > Jiri Kosina
> > SUSE Labs
> 

-- 
Jiri Kosina
SUSE Labs
