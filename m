From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH v4 1/6] mpt3sas: Introduce
 mpt3sas_base_pci_device_is_available
Date: Thu, 27 Sep 2018 09:03:27 +0200
Message-ID: <20180927070327.wvl5glb4c7gtjoa3@wunner.de>
References: <1537935759-14754-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1537935759-14754-2-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20180926213241.GI28024@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180926213241.GI28024@bhelgaas-glaptop.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, andy.shevchenko@gmail.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 26, 2018 at 04:32:41PM -0500, Bjorn Helgaas wrote:
> On Wed, Sep 26, 2018 at 09:52:34AM +0530, Suganath Prabu S wrote:
> > @@ -6853,6 +6872,13 @@ mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
> >  
> >  	ioc->pending_io_count = 0;
> >  
> > +	if (!mpt3sas_base_pci_device_is_available(ioc)) {
> > +		pr_err(MPT3SAS_FMT
> > +		    "%s: pci error recovery reset or pci device unplug occurred\n",
> > +		    ioc->name, __func__);
> > +		return;
> > +	}
> > +
> >  	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
> 
> This is a good example of why I don't like pci_device_is_present(): it
> is fundamentally racy and gives a false sense of security.  Here we
> *think* we're making the code safer, but in fact we could have this
> sequence:
> 
>   mpt3sas_base_pci_device_is_available()    # returns true
>   # device is removed
>   ioc_state = mpt3sas_base_get_iocstate()
> 
> In this case the readl() inside mpt3sas_base_get_iocstate() will
> probably return 0xffffffff data, and we assume that's valid and
> continue on our merry way, pretending that "ioc_state" makes sense
> when it really doesn't.

The function does the following:

	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
	if ((ioc_state & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL)
		return;

where MPI2_IOC_STATE_MASK is 0xF0000000 and MPI2_IOC_STATE_OPERATIONAL
is 0x20000000.  If the device is removed after the call to
mpt3sas_base_pci_device_is_available(), the result of the bitwise "and"
operation would be 0xF0000000, which is unequal to 0x20000000.
Hence this looks safe.

I agree that pci_device_is_present() (and the pci_dev_is_disconnected()
it calls) must be used judiciously, but here it seems to have been done
correctly.

One thing to be aware of is that a return value of "true" from
pci_dev_is_disconnected() is definitive and can be trusted.
On the other hand a return value of "false" is more like a fuzzy
"likely not disconnected, but can't give any guarantees".
So the boolean return value is kind of the problem here.
Boolean logic doesn't really fit these "definitive if true,
not definitive if false" semantics.

However being able to get the definitive answer in the disconnected
case is valuable:  pciehp is the only entity that can determine
surprise removal authoritatively and unambiguously (albeit with
a latency).  All the other tools that we have at our disposal don't
have that quality:  E.g. checking the Vendor ID is ambiguous because
it returns a valid value if a device was quickly replaced with another
one.  Also, all ones may be returned in the case of an Uncorrectable
Error, but the device may revert to valid responses if the error can
be recovered.  (Please correct me if I'm wrong.)

Thanks,

Lukas
