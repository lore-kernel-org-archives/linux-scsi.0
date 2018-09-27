From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v4 1/6] mpt3sas: Introduce
 mpt3sas_base_pci_device_is_available
Date: Thu, 27 Sep 2018 13:47:46 -0500
Message-ID: <20180927184746.GM28024@bhelgaas-glaptop.roam.corp.google.com>
References: <1537935759-14754-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1537935759-14754-2-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20180926213241.GI28024@bhelgaas-glaptop.roam.corp.google.com>
 <20180927070327.wvl5glb4c7gtjoa3@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180927070327.wvl5glb4c7gtjoa3@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, andy.shevchenko@gmail.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, linux-kernel@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Russell Currey <ruscur@russell.cc>, Sam Bobroff <sbobroff@linux.ibm.com>, Oliver O'Halloran <oohall@gmail.com>
List-Id: linux-scsi@vger.kernel.org

[+cc Ben, Russell, Sam, Oliver in case they have pertinent experience from
powerpc error handling; thread begins at
https://lore.kernel.org/linux-pci/1537935759-14754-1-git-send-email-suganath-prabu.subramani@broadcom.com/]

On Thu, Sep 27, 2018 at 09:03:27AM +0200, Lukas Wunner wrote:
> On Wed, Sep 26, 2018 at 04:32:41PM -0500, Bjorn Helgaas wrote:
> > On Wed, Sep 26, 2018 at 09:52:34AM +0530, Suganath Prabu S wrote:
> > > @@ -6853,6 +6872,13 @@ mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
> > >  
> > >  	ioc->pending_io_count = 0;
> > >  
> > > +	if (!mpt3sas_base_pci_device_is_available(ioc)) {
> > > +		pr_err(MPT3SAS_FMT
> > > +		    "%s: pci error recovery reset or pci device unplug occurred\n",
> > > +		    ioc->name, __func__);
> > > +		return;
> > > +	}
> > > +
> > >  	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
> > 
> > This is a good example of why I don't like pci_device_is_present(): it
> > is fundamentally racy and gives a false sense of security.  Here we
> > *think* we're making the code safer, but in fact we could have this
> > sequence:
> > 
> >   mpt3sas_base_pci_device_is_available()    # returns true
> >   # device is removed
> >   ioc_state = mpt3sas_base_get_iocstate()
> > 
> > In this case the readl() inside mpt3sas_base_get_iocstate() will
> > probably return 0xffffffff data, and we assume that's valid and
> > continue on our merry way, pretending that "ioc_state" makes sense
> > when it really doesn't.
> 
> The function does the following:
> 
> 	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
> 	if ((ioc_state & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL)
> 		return;
> 
> where MPI2_IOC_STATE_MASK is 0xF0000000 and MPI2_IOC_STATE_OPERATIONAL
> is 0x20000000.  If the device is removed after the call to
> mpt3sas_base_pci_device_is_available(), the result of the bitwise "and"
> operation would be 0xF0000000, which is unequal to 0x20000000.
> Hence this looks safe.

I agree this particular case is technically safe, but figuring that
out requires an unreasonable amount of analysis.  And there's no hint
in the code that we need to be concerned about whether the readl()
returns valid data, so the need for the analysis won't even occur to
most readers.

I don't feel good about encouraging this style of adding an explicit
test for whether the device is available, followed by a completely
implicit test that accidentally happens to correctly handle a device
that was removed after the explicit test.

If we instead added a test for ~0 after the readl(), we would avoid
the race and give the reader a clue that *any* read from the device
can potentially fail without advance warning.

> I agree that pci_device_is_present() (and the pci_dev_is_disconnected()
> it calls) must be used judiciously, but here it seems to have been done
> correctly.
> 
> One thing to be aware of is that a return value of "true" from
> pci_dev_is_disconnected() is definitive and can be trusted.
> On the other hand a return value of "false" is more like a fuzzy
> "likely not disconnected, but can't give any guarantees".
> So the boolean return value is kind of the problem here.
> Boolean logic doesn't really fit these "definitive if true,
> not definitive if false" semantics.
> 
> However being able to get the definitive answer in the disconnected
> case is valuable:  pciehp is the only entity that can determine
> surprise removal authoritatively and unambiguously (albeit with
> a latency).  All the other tools that we have at our disposal don't
> have that quality:  E.g. checking the Vendor ID is ambiguous because
> it returns a valid value if a device was quickly replaced with another
> one.  Also, all ones may be returned in the case of an Uncorrectable
> Error, but the device may revert to valid responses if the error can
> be recovered.  (Please correct me if I'm wrong.)

I think everything you said above is true, but I'm not yet convinced
that it's being applied usefully in mpt3sas.

  bool pci_dev_is_disconnected(pdev)       # "true" is definitive
  {
    return test_bit(PCI_DEV_DISCONNECTED, &dev->priv_flags);
  }

  bool pci_device_is_present(pdev)         # "false" is definitive
  {
    if (pci_dev_is_disconnected(pdev))
      return false;
    return pci_bus_read_dev_vendor_id(...);
  }

  mpt3sas_base_pci_device_is_available(ioc)  # "false" is definitive
  {
    return !ioc->pci_error_recovery && pci_device_is_present(ioc->pdev);
  }

  mpt3sas_wait_for_commands_to_complete(...)
  {
    ...
 +  if (!mpt3sas_base_pci_device_is_available(ioc))
 +    return;

    # In the definitive case, we returned above.  If we get here, we
    # think the device *might* be present.  The readl() inside
    # mpt3sas_base_get_iocstate() might fail (returning ~0 data).
    # It happens that (~0 & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL
    # so we will return below if the device was removed after the
    # check above.

    ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
    if ((ioc_state & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL)
      return;
    ...


I think this code is unreasonably complicated.  The multiple layers
and negations make it very difficult to figure out what's definitive.

I'm not sure how mpt3sas benefits from adding
mpt3sas_base_pci_device_is_available() here, other than the fact that
it avoids an MMIO read to the device in most cases.  I think it would
be simpler and better to make mpt3sas_base_get_iocstate() smarter
about handling ~0 values from the readl().

Bjorn
