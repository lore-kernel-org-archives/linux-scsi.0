From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V2] PCI/portdrv: do not disable device on reboot/shutdown
Date: Wed, 23 May 2018 18:57:18 -0400
Message-ID: <61f70fd6-52fd-da07-ce73-303f95132131@codeaurora.org>
References: <1527043490-17268-1-git-send-email-okaya@codeaurora.org>
 <20180523213249.GD150632@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180523213249.GD150632@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, timur@codeaurora.org, ryan@finnie.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Frederick Lawler <fred@fredlawl.com>, Dongdong Liu <liudongdong3@huawei.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, open list <linux-kernel@vger.kernel.org>, Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/23/2018 5:32 PM, Bjorn Helgaas wrote:
> 
> The crash seems to indicate that the hpsa device attempted a DMA after
> we cleared the Root Port's PCI_COMMAND_MASTER, which means
> hpsa_shutdown() didn't stop DMA from the device (it looks like *most*
> shutdown methods don't disable device DMA, so it's in good company).

All drivers are expected to shutdown DMA and interrupts in their shutdown()
routines. They can skip removing threads, data structures etc. but DMA and
interrupt disabling are required. This is the difference between shutdown()
and remove() callbacks.

If you see that this is not being done in HPSA, then that is where the
bugfix should be.

Counter argument is that if shutdown() is not implemented, at least remove()
should be called. Expecting all drivers to implement shutdown() callbacks
is just bad by design in my opinion. 

Code should have fallen back to remove() if shutdown() doesn't exist.
I can propose a patch for this but this is yet another story to chase.

> 
>> This has been found to cause crashes on HP DL360 Gen9 machines during
>> reboot. Besides, kexec is already clearing the bus master bit in
>> pci_device_shutdown() after all PCI drivers are removed.
> 
> The original path was:
> 
>   pci_device_shutdown(hpsa)
>     drv->shutdown
>       hpsa_shutdown                     # hpsa_pci_driver.shutdown
>   ...
>   pci_device_shutdown(RP)               # root port
>     drv->shutdown
>       pcie_portdrv_remove               # pcie_portdriver.shutdown
>         pcie_port_device_remove
>           pci_disable_device
>             do_pci_disable_device
>               # clear RP PCI_COMMAND_MASTER
>     if (kexec)
>       pci_clear_master(RP)
>         # clear RP PCI_COMMAND_MASTER
> 
> If I understand correctly, the new path after this patch is:
> 
>   pci_device_shutdown(hpsa)
>     drv->shutdown
>       hpsa_shutdown                     # hpsa_pci_driver.shutdown
>   ...
>   pci_device_shutdown(RP)               # root port
>     drv->shutdown
>       pcie_portdrv_shutdown             # pcie_portdriver.shutdown
>         __pcie_portdrv_remove(RP, false)
>           pcie_port_device_remove(RP, false)
>             # do NOT clear RP PCI_COMMAND_MASTER

yup

>     if (kexec)
>       pci_clear_master(RP)
>         # clear RP PCI_COMMAND_MASTER
> 
> I guess this patch avoids the panic during reboot because we're not in
> the kexec path, so we never clear PCI_COMMAND_MASTER for the Root
> Port, so the hpsa device can DMA happily until the lights go out.
> 
> But DMA continuing for some random amount of time before the reboot or
> shutdown happens makes me a little queasy.  That doesn't sound safe.
> The more I think about this, the more confused I get.  What am I
> missing?  

see above.

> 
>> Just remove the extra clear in shutdown path by seperating the remove and
>> shutdown APIs in the PORTDRV.
>>
>>  static pci_ers_result_t pcie_portdrv_error_detected(struct pci_dev *dev,
>> @@ -218,7 +228,7 @@ static struct pci_driver pcie_portdriver = {
>>  
>>  	.probe		= pcie_portdrv_probe,
>>  	.remove		= pcie_portdrv_remove,
>> -	.shutdown	= pcie_portdrv_remove,
>> +	.shutdown	= pcie_portdrv_shutdown,
> 
> What are the circumstances when we call .remove() vs .shutdown()?
> 
> I guess the main (maybe only) way to call .remove() is to hot-remove
> the port?  And .shutdown() is basically used in the reboot and kexec
> paths?

Correct. shutdown() is only called during reboot/shutdown calls. If you echo
1 into the remove file, remove() gets called. Handy for hotplug use cases.
It needs to be the exact opposite of the probe. It needs to clean up resources
etc. and have the HW in a state where it can be reinitialized via probe again.

> 
>>  	.err_handler	= &pcie_portdrv_err_handler,
>>  
>> -- 
>> 2.7.4
>>
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
