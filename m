From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] megaraid_sas: Quirk mmio hook for 1078 MR controller
Date: Tue, 24 Dec 2013 07:46:33 -0700
Message-ID: <CAErSpo6Q7XnDhxKJOt2ZRUMzTY-Jj2dD=FJdh_DsLx2XB=zxrw@mail.gmail.com>
References: <201312231512.rBNFC6mo008974@cosmhbs0.lsi.com> <CAErSpo7X4khuPOp5s4MdunOmwww0V4JZipJa3iEOA=Y5nnCwqA@mail.gmail.com>
 <49ee1c68150946e0b972b6b047a07126@BN1PR07MB247.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <49ee1c68150946e0b972b6b047a07126@BN1PR07MB247.namprd07.prod.outlook.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "James E.J. Bottomley" <jbottomley@parallels.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>, Adam Radford <aradford@gmail.com>, "Yang, Bo" <Bo.Yang@lsi.com>, Myron Stowe <myron.stowe@redhat.com>
List-Id: linux-scsi@vger.kernel.org

[+cc Myron]

On Tue, Dec 24, 2013 at 1:20 AM, Desai, Kashyap <Kashyap.Desai@lsi.com> wrote:
>
>
>> -----Original Message-----
>> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> Sent: Monday, December 23, 2013 11:28 PM
>> To: Desai, Kashyap
>> Cc: linux-scsi@vger.kernel.org; linux-pci@vger.kernel.org; James E.J.
>> Bottomley; Saxena, Sumit; Adam Radford
>> Subject: Re: [PATCH] megaraid_sas: Quirk mmio hook for 1078 MR controller
>>
>> On Mon, Dec 23, 2013 at 8:13 AM,  <Kashyap.Desai@lsi.com> wrote:
>> > This patch has fix for LSI Gen-1 MR controller issue which only pop-up
>> > on few systems and it is not generic.
>> >
>> > On few system, MR 1078 MR controller is not working if mmio decoding is
>> off.
>> > This patch proposed early quirck entry for Device id 0x1000/0x0411 to
>> enable mmio.
>> >
>> > Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
>> > ---
>> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index
>> > f6c31fa..a20fe41 100644
>> > --- a/drivers/pci/quirks.c
>> > +++ b/drivers/pci/quirks.c
>> > @@ -43,6 +43,10 @@ static void quirk_mmio_always_on(struct pci_dev
>> > *dev)  }  DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
>> >                                 PCI_CLASS_BRIDGE_HOST, 8,
>> > quirk_mmio_always_on);
>> > +/* LSI controller device id 0x0411 has some issues if mmio_always_on is
>> not set.
>> > + * It pop-up only on few specific system, where decoding disable is not
>> working.
>> > + */
>> > +DECLARE_PCI_FIXUP_EARLY(0x1000, 0x0411, quirk_mmio_always_on);
>>
>> What is the actual problem that happens without this quirk?  Is there some
>> hardware defect in the MR 1078 that makes it fail when we disable decoding?
>>
>> Disabling decoding is important because it prevents conflicts with other
>> devices while sizing and updating BARs, so I don't want to use this quirk
>> unless it's really necessary.
> LSI is still investigating on h/w issue. It was originally reported from customer site and they have found this issue when they upgrade RHEL6.3 to RHEL6.4.
>
> Kernel/Driver fault with machine check on RHEL6.4 at the time of driver reading base address registers. New way, used in RHEL6.4 (similar to upstream kernel) is to disable mmio memory mapping a and i/o to the device, read the value and then re-enable mmio memory mapping and i/o.  This seems to cause problems on customer setup.

Is there a bug report we can look at?  Maybe a dmesg or console log of
the issue happening, along with "lspci -vv" output and contents of
/proc/iomem and /proc/ioports?

Unless there's some 1078 hardware defect related to writing the
command register, the current code should be safe.  It's possible
there's a driver defect or something else that causes an access to the
device while it is disabled.  If that's happening, *that* is what
needs to be fixed.

I am opposed to making a change like this to upstream until we
understand what's actually going on.  Of course, RH may want to put
the change in their kernel as a pragmatic measure.

> 1078 MR controller is pretty old h/w and we may need more time to actually figure out why new pci_read method is failing on customer system.  As an alternative (consider that LSI h/w has some issue), we opt to enable mmio via quirk entry.
>
>  ~ Kashyap
>
>>
>> Bjorn
>>
>
