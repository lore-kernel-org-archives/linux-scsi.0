From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: eata fails to load on post 4.2 kernels
Date: Thu, 10 Sep 2015 16:13:14 +0800
Message-ID: <55F13B9A.4090101@linux.intel.com>
References: <v03tbc-ufe.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net>
 <55EC019F.4010209@internode.on.net> <55EC2567.8000100@internode.on.net>
 <55ECA291.1060103@internode.on.net> <55ECFF32.9030902@linux.intel.com>
 <55ED2DFA.6030502@internode.on.net> <55EE6FD1.2030600@linux.intel.com>
 <55F13644.2080203@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38962 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbbIJINl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2015 04:13:41 -0400
In-Reply-To: <55F13644.2080203@internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>, tglx@linutronix.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Authur,
	Thanks for the updating. Seem Bjorn doesn't like
neither of my two patches. So I'm trying to convert eata
to formal PCI driver, but the change will be much more
bigger and still not sure whether we could achieve that.
Will keep you updated.
Thanks!
Gerry

On 2015/9/10 15:50, Arthur Marsh wrote:
> 
> 
> Jiang Liu wrote on 08/09/15 14:49:
>> Hi Auhur,
>>     Could you please help to apply the test patch
>> against the latest mainstream linux kernel?
>> Thanks!
>> Gerry
> ...
> 
>>>>> git bisect good
>>>>> 991de2e59090e55c65a7f59a049142e3c480f7bd is the first bad commit
>>>>> commit 991de2e59090e55c65a7f59a049142e3c480f7bd
>>>>> Author: Jiang Liu <jiang.liu@linux.intel.com>
>>>>> Date:   Wed Jun 10 16:54:59 2015 +0800
>>>>>
>>>>>       PCI, x86: Implement pcibios_alloc_irq() and pcibios_free_irq()
>>>>>
>>>>>       To support IOAPIC hotplug, we need to allocate PCI IRQ
>>>>> resources on
>>>>> demand
>>>>>       and free them when not used anymore.
>>>>>
>>>>>       Implement pcibios_alloc_irq() and pcibios_free_irq() to
>>>>> dynamically
>>>>>       allocate and free PCI IRQs.
>>>>>
>>>>>       Remove mp_should_keep_irq(), which is no longer used.
>>>>>
>>>>>       [bhelgaas: changelog]
>>>>>       Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>>>>>       Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>>>>       Acked-by: Thomas Gleixner <tglx@linutronix.de>
>>>>>
>>>>> :040000 040000 765e2d5232d53247ec260b34b51589c3bccb36ae
>>>>> f680234a27685e94b1a35ae2a7218f8eafa9071a M      arch
>>>>> :040000 040000 d55a682bcde72682e883365e88ad1df6186fd54d
>>>>> f82c470a04a6845fcf5e0aa934512c75628f798d M      drivers
> 
> I tried to do a kexec shut-down with the first version of your patch:
> 
>>From 3085626fb2e677c1d88f158397948935b73f5239 Mon Sep 17 00:00:00 2001
> From: Jiang Liu <jiang.liu@linux.intel.com>
> Date: Tue, 8 Sep 2015 10:41:19 +0800
> Subject: [PATCH]
> 
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/pci/pci-driver.c |    1 +
>  drivers/scsi/eata.c      |    2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 52a880ca1768..17d2a0b1de18 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -392,6 +392,7 @@ int __weak pcibios_alloc_irq(struct pci_dev *dev)
>  {
>      return 0;
>  }
> +EXPORT_SYMBOL_GPL(pcibios_alloc_irq);
> 
>  void __weak pcibios_free_irq(struct pci_dev *dev)
>  {
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index 227dd2c2ec2f..7e6eaf867987 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -1061,6 +1061,7 @@ static void enable_pci_ports(void)
>                 driver_name, dev->bus->number, dev->devfn);
>  #endif
> 
> +        pcibios_alloc_irq(dev);
>          if (pci_enable_device(dev))
>              printk
>                  ("%s: warning, pci_enable_device failed, bus %d devfn
> 0x%x.\n",
> @@ -1520,6 +1521,7 @@ static void add_pci_ports(void)
>          if (!(dev = pci_get_class(PCI_CLASS_STORAGE_SCSI << 8, dev)))
>              break;
> 
> +        pcibios_alloc_irq(dev);
>          if (pci_enable_device(dev)) {
>  #if defined(DEBUG_PCI_DETECT)
>              printk
