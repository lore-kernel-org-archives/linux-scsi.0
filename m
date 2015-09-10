From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [Bugfix] PCI, x86: Correctly allocate IRQs for PCI devices
 managed by non-PCI drivers
Date: Thu, 10 Sep 2015 16:58:01 +0800
Message-ID: <55F14619.4030007@linux.intel.com>
References: <55EE8106.6060100@internode.on.net>
 <1441697190-27993-1-git-send-email-jiang.liu@linux.intel.com>
 <20150908162735.GK829@google.com> <55EF119E.5030905@linux.intel.com>
 <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32015 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbbIJI6T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2015 04:58:19 -0400
In-Reply-To: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arthur Marsh <arthur.marsh@internode.on.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2015/9/10 3:11, Bjorn Helgaas wrote:
> On Tue, Sep 8, 2015 at 11:49 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
>> Hi Bjorn,
>>         We have used another draft version to fix this issue by changing
>> eata driver as below. But that needs to export pcibios_alloc_irq. And
>> I'm not sure whether there are other drivers having the same behavior.
>> If we think it's a legacy behavior and only a few drivers may have
>> such a behavior, I prefer changing drivers to fix the issue too.
> 
> Did you look at changing the driver to use pci_register_driver()?  I
> bet it's pretty straightforward.
Hi Bjorn,
	I have done some investigation. It's doable, but the change
may be a little bigger. Will send the patch out for comments once
it's done.
Thanks!
Gerry

> 
>>  drivers/pci/pci-driver.c |    1 +
>>  drivers/scsi/eata.c      |    2 ++
>>  2 files changed, 3 insertions(+)
>>
>> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
>> index 52a880ca1768..17d2a0b1de18 100644
>> --- a/drivers/pci/pci-driver.c
>> +++ b/drivers/pci/pci-driver.c
>> @@ -392,6 +392,7 @@ int __weak pcibios_alloc_irq(struct pci_dev *dev)
>>  {
>>         return 0;
>>  }
>> +EXPORT_SYMBOL_GPL(pcibios_alloc_irq);
>>
>>  void __weak pcibios_free_irq(struct pci_dev *dev)
>>  {
>> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
>> index 227dd2c2ec2f..7e6eaf867987 100644
>> --- a/drivers/scsi/eata.c
>> +++ b/drivers/scsi/eata.c
>> @@ -1061,6 +1061,7 @@ static void enable_pci_ports(void)
>>                        driver_name, dev->bus->number, dev->devfn);
>>  #endif
>>
>> +               pcibios_alloc_irq(dev);
>>                 if (pci_enable_device(dev))
>>                         printk
>>                             ("%s: warning, pci_enable_device failed, bus %d devfn 0x%x.\n",
>> @@ -1520,6 +1521,7 @@ static void add_pci_ports(void)
>>                 if (!(dev = pci_get_class(PCI_CLASS_STORAGE_SCSI << 8, dev)))
>>                         break;
>>
>> +               pcibios_alloc_irq(dev);
>>                 if (pci_enable_device(dev)) {
>>  #if defined(DEBUG_PCI_DETECT)
>>                         printk
>>
>>
>>>
>>>>      return pci_enable_resources(dev, mask);
>>>>  }
>>>>
>>>> --
>>>> 1.7.10.4
>>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
