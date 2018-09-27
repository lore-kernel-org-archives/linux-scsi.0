From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH v4 1/6] mpt3sas: Introduce
 mpt3sas_base_pci_device_is_available
Date: Thu, 27 Sep 2018 21:09:59 +0200
Message-ID: <20180927190959.dio4qwti3i4accjm@wunner.de>
References: <1537935759-14754-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1537935759-14754-2-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20180926213241.GI28024@bhelgaas-glaptop.roam.corp.google.com>
 <20180927070327.wvl5glb4c7gtjoa3@wunner.de>
 <20180927184746.GM28024@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180927184746.GM28024@bhelgaas-glaptop.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, andy.shevchenko@gmail.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, linux-kernel@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Russell Currey <ruscur@russell.cc>, Sam Bobroff <sbobroff@linux.ibm.com>, Oliver O'Halloran <oohall@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 27, 2018 at 01:47:46PM -0500, Bjorn Helgaas wrote:
>   mpt3sas_wait_for_commands_to_complete(...)
>   {
>     ...
>  +  if (!mpt3sas_base_pci_device_is_available(ioc))
>  +    return;
> 
>     # In the definitive case, we returned above.  If we get here, we
>     # think the device *might* be present.  The readl() inside
>     # mpt3sas_base_get_iocstate() might fail (returning ~0 data).
>     # It happens that (~0 & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL
>     # so we will return below if the device was removed after the
>     # check above.
> 
>     ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
>     if ((ioc_state & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL)
>       return;
>     ...
> 
> 
> I think this code is unreasonably complicated.  The multiple layers
> and negations make it very difficult to figure out what's definitive.

I agree there's room for improvement.


> I'm not sure how mpt3sas benefits from adding
> mpt3sas_base_pci_device_is_available() here, other than the fact that
> it avoids an MMIO read to the device in most cases.  I think it would
> be simpler and better to make mpt3sas_base_get_iocstate() smarter
> about handling ~0 values from the readl().

Avoiding an MMIO read when it's known to run into a Completion Timeout
buys about 17 ms.  If the function is executed many times (I don't know
if that's the case here, I'm referring to the general case), or if bailing
out of it early avoids significant amounts of further I/O, then checking
for disconnectedness makes sense.

The 17 ms number is from this talk:
https://www.youtube.com/watch?v=GJ6B0xzgvlM&t=832

It's the typical Completion Timeout on an Intel chip, but it can be up to
50 ms in the default setting or up to 64 s if so configured in the Device
Control 2 register (PCIe r4.0 sec 7.8.16).

Thanks,

Lukas
