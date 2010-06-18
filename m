From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set
 but not used
Date: Fri, 18 Jun 2010 10:31:52 -0700
Message-ID: <4C1BAD88.9050903@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>	<1276666434-11227-5-git-send-email-justinmattock@gmail.com> <20100618102330.29eccb5b@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100618102330.29eccb5b@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/18/2010 10:23 AM, Jesse Barnes wrote:
> On Tue, 15 Jun 2010 22:33:53 -0700
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>> The below patch fixes a warning message when using gcc 4.6.0
>>    CC      drivers/pci/setup-bus.o
>> drivers/pci/setup-bus.c: In function 'pci_assign_unassigned_bridge_resources':
>> drivers/pci/setup-bus.c:868:6: warning: variable 'retval' set but not used
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/pci/setup-bus.c |    2 --
>>   1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> index 19b1113..215590b 100644
>> --- a/drivers/pci/setup-bus.c
>> +++ b/drivers/pci/setup-bus.c
>> @@ -865,7 +865,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>>   	struct pci_bus *parent = bridge->subordinate;
>>   	int tried_times = 0;
>>   	struct resource_list_x head, *list;
>> -	int retval;
>>   	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
>>   				  IORESOURCE_PREFETCH;
>>
>> @@ -874,7 +873,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>>   again:
>>   	pci_bus_size_bridges(parent);
>>   	__pci_bridge_assign_resources(bridge,&head);
>> -	retval = pci_reenable_device(bridge);
>>   	pci_set_master(bridge);
>>   	pci_enable_bridges(parent);
>>
>
> This has the same problem as your earlier bridge_enable patch; you need
> to keep the call to pci_reenable_device.  I should have caught this
> issue when Yinghai's patch went in: the right way to silence a warning
> about not checking a return value isn't to simply assign it to
> something, you really should *do* something as well, at least some
> debug output would be nice, but ideally handling the error in a sane
> way.
>


yeah I was still looking into the scsi patch with adding a printk
then I can look at this as well.

Justin P. Mattock
