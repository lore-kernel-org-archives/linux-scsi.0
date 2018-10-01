From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v4 1/6] mpt3sas: Introduce mpt3sas_base_pci_device_is_available
Date: Mon, 1 Oct 2018 12:27:28 +0530
Message-ID: <CA+RiK64EdoSngTzDMUP4xXNcZQa6KfyucsRw42+DUo3s+JPmVQ@mail.gmail.com>
References: <1537935759-14754-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1537935759-14754-2-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20180926213241.GI28024@bhelgaas-glaptop.roam.corp.google.com>
 <20180927070327.wvl5glb4c7gtjoa3@wunner.de> <20180927184746.GM28024@bhelgaas-glaptop.roam.corp.google.com>
 <20180927190959.dio4qwti3i4accjm@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927190959.dio4qwti3i4accjm@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: lukas@wunner.de
Cc: helgaas@kernel.org, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-kernel@vger.kernel.org, benh@kernel.crashing.org, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com
List-Id: linux-scsi@vger.kernel.org

Hi Lucas and Bjorn,
Thanks for reviewing and providing useful comments.

On Fri, Sep 28, 2018 at 12:40 AM Lukas Wunner <lukas@wunner.de> wrote:
>
> On Thu, Sep 27, 2018 at 01:47:46PM -0500, Bjorn Helgaas wrote:
> >   mpt3sas_wait_for_commands_to_complete(...)
> >   {
> >     ...
> >  +  if (!mpt3sas_base_pci_device_is_available(ioc))
> >  +    return;
> >
> >     # In the definitive case, we returned above.  If we get here, we
> >     # think the device *might* be present.  The readl() inside
> >     # mpt3sas_base_get_iocstate() might fail (returning ~0 data).
> >     # It happens that (~0 & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL
> >     # so we will return below if the device was removed after the
> >     # check above.
> >
> >     ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
> >     if ((ioc_state & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL)
> >       return;
> >     ...
> >
> >
> > I think this code is unreasonably complicated.  The multiple layers
> > and negations make it very difficult to figure out what's definitive.
>
> I agree there's room for improvement.
>
>
> > I'm not sure how mpt3sas benefits from adding
> > mpt3sas_base_pci_device_is_available() here, other than the fact that
> > it avoids an MMIO read to the device in most cases.  I think it would
> > be simpler and better to make mpt3sas_base_get_iocstate() smarter
> > about handling ~0 values from the readl().
>
> Avoiding an MMIO read when it's known to run into a Completion Timeout
> buys about 17 ms.  If the function is executed many times (I don't know
> if that's the case here, I'm referring to the general case), or if bailing
> out of it early avoids significant amounts of further I/O, then checking
> for disconnectedness makes sense.
>
> The 17 ms number is from this talk:
> https://www.youtube.com/watch?v=GJ6B0xzgvlM&t=832
>
> It's the typical Completion Timeout on an Intel chip, but it can be up to
> 50 ms in the default setting or up to 64 s if so configured in the Device
> Control 2 register (PCIe r4.0 sec 7.8.16).
>

This function is called only during controller reset, system shutdown
and driver unload operations.
For this case we can remove mpt3sas_base_pci_device_is_available() check,
since we can make the device removal from readl in
mpt3sas_base_get_iocstate() as you suggested.
But we need mpt3sas_base_pci_device_is_available() in other places
like while submitting the
IO/TMs to the HBA firmware etc where driver is not checking for the
IOC state (through readl() operation)
 to gracefully handle the HBA hot-unplug operation.

> Thanks,
>
> Lukas
