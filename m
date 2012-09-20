From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Fail to probe qla2xxx fiber channel card while doing pci hotplug
Date: Thu, 20 Sep 2012 09:46:48 -0600
Message-ID: <CAErSpo6Wvn_cdOJg-OULbjyDQ0Qibq_+X78QMSqBeoC0GuB2VQ@mail.gmail.com>
References: <505456FD.6040801@huawei.com> <CAErSpo6OkAV-wwKnpMRAvisQ_Jj=w9dxLbO3JxkX2A_Vd8QX=Q@mail.gmail.com>
 <50571243.4050001@huawei.com> <CAErSpo7WwwB3ZO9g4WjQZKcfXAP0tKuXWKn=UTw1mDGJyX6=vQ@mail.gmail.com>
 <505924E4.5010502@huawei.com> <CAErSpo5PuwG1pvCRBxOUoyK-_ajg-AZkkuCUxeGbkb6TyBP_Kw@mail.gmail.com>
 <505A7599.5070103@huawei.com> <505B0B6A.2050709@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <505B0B6A.2050709@huawei.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Jon Mason <jdmason@kudzu.us>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, PCI <linux-pci@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 20, 2012 at 6:26 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> On 2012/9/20 9:47, Yijing Wang wrote:
>>>> We compared the two situations after BIOS initialization, and found Max Payload Size in DEVCTRL is 256B
>>>> if FC card had been installed, if the slot is empty, Max Payload Size is 128B. We force it to be 128B when
>>>> FC card installed when system boot up. Finally pci hotplug becomes ok. So I suspect maybe our PCIe hardware
>>>> has problem supporting 256B.
>>>
>>> Ah, this sounds like something I've been worried about for a while,
>>> i.e., do we handle MPS correctly when we hot-add devices?
>>>
>>> Yijing, I'm not quite clear on what you're observing.  I guess you're
>>> saying that if an FC card is installed at boot, the BIOS sets MPS to
>>> 256, and that if no FC card is installed, the BIOS sets MPS to 128?
>>
>> Yes.
>>
>>> You haven't mentioned any Linux boot options, so I assume you haven't
>>> tried any.  Does "pci=pcie_bus_safe" make any difference?
>>
>> Yes, I don't add any Linux boot options before. I will try this boot option
>> "pci=pcie_bus_safe".
>>
>>> Jon, here's a pointer to the beginning of the thread:
>>> http://marc.info/?l=linux-pci&m=134770460302298&w=2 (full dmesg log at
>>> http://marc.info/?l=linux-scsi&m=134788365823217&w=2).  I'm not sure
>>> we have enough in the dmesg log to diagnose an issue like this.  I
>>> wonder if it would be useful to log the current setting, so we could
>>> notice BIOS default differences like this one.
>>>
>
> Hi Bjorn,
>    After add "pci=pcie_bus_safe" boot options, Hot-plug for FC card is OK.
> It's great! Thanks for your help!
>
> Giri, it's not the fc card problem, we fix this problem by add boot option
> "pci=pcie_bus_safe" which force the MPS of the entire system to the smallest
> possible.

That's OK for a workaround, but it'd definitely not a complete
solution.  At the very least, we need some kind of info in dmesg that
will enable us to diagnose the problem next time somebody runs into
it.  *You* are sophisticated enough to poke around and look at MPS
settings manually, but the next person who runs into it will not be.
