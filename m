From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: add quirk for 3ware 9650SE controller
Date: Tue, 24 Sep 2013 14:50:10 -0600
Message-ID: <CAErSpo6ULW459LBE=Wj4GEyCY63TbirSDLDivK7hrs92WzitLw@mail.gmail.com>
References: <alpine.LNX.2.00.1308271141080.2077@pobox.suse.cz>
 <alpine.LNX.2.00.1308271144420.2077@pobox.suse.cz> <alpine.LNX.2.00.1308281745460.4557@pobox.suse.cz>
 <CAErSpo6saRNMw6Js0PLXZzYDdH0M3ypSFLDxVxp0G02aetp0Dw@mail.gmail.com>
 <alpine.LNX.2.00.1309061150140.26934@pobox.suse.cz> <CAErSpo5ExXsbSd+jYP5JYwq-RBf-dx1T_AZx6CV4=6-AfTTynQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:44459 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab3IXUub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Sep 2013 16:50:31 -0400
Received: by mail-ie0-f171.google.com with SMTP id at1so9743701iec.16
        for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2013 13:50:31 -0700 (PDT)
In-Reply-To: <CAErSpo5ExXsbSd+jYP5JYwq-RBf-dx1T_AZx6CV4=6-AfTTynQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Adam Radford <aradford@gmail.com>

On Fri, Sep 6, 2013 at 4:47 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Sep 6, 2013 at 3:51 AM, Jiri Kosina <jkosina@suse.cz> wrote:

>>> >> > Commit d5dea7d95 ("PCI: msi: Disable msi interrupts when we initialize a
>>> >> > pci device") makes MSIs be forcibly disabled at boot time.
>>> >> >
>>> >> > It turns out that this breaks 3ware controller -- if MSIs are disabled
>>> >> > during PCI discovery of this controller, the device doesn't work properly
>>> >> > (it doesn't respond to any commands that are being sent to it after
>>> >> > initialization).
>
> Is there a bug report for this issue?  It's nice to have a pointer to,
> e.g., a bugzilla.kernel.org bug report with info such as dmesg logs,
> lspci output, etc., for future reference.  Maybe somebody will figure
> out a more generic change that could make this quirk unnecessary, and
> details will help in figuring that out.
>
> I assume the actual PCI discovery done in the PCI core works fine;
> it's just that the driver doesn't work if MSIs are disabled on the
> device.  If that's the case, can this be fixed by some driver change?
> Maybe the driver needs to enable MSI before it sends commands to the
> device?

Ping?  Since the complaint is that the device doesn't work unless MSIs
are enabled, can this be fixed in the driver instead of in a quirk?

> Any description of what this failure looks like to a user?  How can a
> user or a distro connect a symptom (driver timeout, console message,
> or whatever) to this patch?
>
>>> >> > Reverting d5dea7d95 or not force-disabling MSIs in pci_msi_init_pci_dev()
>>> >> > makes the device work properly again.
>>> >> >
>>> >> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>>> >> >
>>> >> > ---
>>> >> >
>>> >> > I am adding Adam Radford as a recepient as well, to see whether he is able
>>> >> > to provide some more explanation why this device would expose this
>>> >> > behavior.
>>> >
>>> > OK, so Adam Radford's lsi.com address is bouncing, hence I guess we can't
>>> > expect any feedback from him.
>>> >
>>> > Bjorn, Jesse, any word on this please?
>>>
>>> It's on my list to look at.  It's too late to put it in for v3.11, and
>>> it's doubtful that it will even make the v3.12 merge window (though
>>> possibly it could go in post-merge window).  d5dea7d95 is several
>>> years old, so hopefully this issue isn't super-urgent.  Let me know if
>>> otherwise.
>>
>> I agree that this should be applicable to 3.12-rcX as well, as it's very
>> device-specific.
>>
>> Thanks.
>>
>>>
>>> Bjorn
>>>
>>> >> >  drivers/pci/msi.c    |    3 +++
>>> >> >  drivers/pci/quirks.c |   10 ++++++++++
>>> >> >  include/linux/pci.h  |    1 +
>>> >> >  3 files changed, 14 insertions(+), 0 deletions(-)
>>> >> >
>>> >> > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>>> >> > index aca7578..4f36b8b 100644
>>> >> > --- a/drivers/pci/msi.c
>>> >> > +++ b/drivers/pci/msi.c
>>> >> > @@ -1040,6 +1040,9 @@ void pci_msi_init_pci_dev(struct pci_dev *dev)
>>> >> >  {
>>> >> >     INIT_LIST_HEAD(&dev->msi_list);
>>> >> >
>>> >> > +   if (dev->broken_msi_disable)
>>> >> > +           return;
>>> >> > +
>>> >> >     /* Disable the msi hardware to avoid screaming interrupts
>>> >> >      * during boot.  This is the power on reset default so
>>> >> >      * usually this should be a noop.
>>> >> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>>> >> > index e85d230..4ba3400 100644
>>> >> > --- a/drivers/pci/quirks.c
>>> >> > +++ b/drivers/pci/quirks.c
>>> >> > @@ -2890,6 +2890,16 @@ static void quirk_intel_ntb(struct pci_dev *dev)
>>> >> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0e08, quirk_intel_ntb);
>>> >> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0e0d, quirk_intel_ntb);
>>> >> >
>>> >> > +/*
>>> >> > + * 3ware 9650SE controller doesn't properly initialize if MSI are
>>> >> > + * disabled on it during PCI device discovery
>>> >> > + */
>>> >> > +static void quirk_broken_msi_disable(struct pci_dev *dev)
>>> >> > +{
>>> >> > +   dev->broken_msi_disable = 1;
>>> >> > +}
>>> >> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_3WARE, 0x1004, quirk_broken_msi_disable);
>>> >> > +
>>> >> >  static ktime_t fixup_debug_start(struct pci_dev *dev,
>>> >> >                              void (*fn)(struct pci_dev *dev))
>>> >> >  {
>>> >> > diff --git a/include/linux/pci.h b/include/linux/pci.h
>>> >> > index 0fd1f15..c327d74 100644
>>> >> > --- a/include/linux/pci.h
>>> >> > +++ b/include/linux/pci.h
>>> >> > @@ -341,6 +341,7 @@ struct pci_dev {
>>> >> >  #ifdef CONFIG_PCI_MSI
>>> >> >     struct list_head msi_list;
>>> >> >     struct kset *msi_kset;
>>> >> > +   unsigned int    broken_msi_disable:1;
>>> >> >  #endif
>>> >> >     struct pci_vpd *vpd;
>>> >> >  #ifdef CONFIG_PCI_ATS
>>> >> >
>>> >> > --
>>> >> > Jiri Kosina
>>> >> > SUSE Labs
>>> >> >
>>> >>
>>> >> --
>>> >> Jiri Kosina
>>> >> SUSE Labs
>>> >>
>>> >
>>> > --
>>> > Jiri Kosina
>>> > SUSE Labs
>>>
>>
>> --
>> Jiri Kosina
>> SUSE Labs
