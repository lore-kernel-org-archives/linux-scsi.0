From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set
 but not used
Date: Fri, 18 Jun 2010 11:48:29 -0700
Message-ID: <4C1BBF7D.8090904@kernel.org>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>	<1276666434-11227-5-git-send-email-justinmattock@gmail.com> <20100618102330.29eccb5b@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20100618102330.29eccb5b@virtuousgeek.org>
Sender: linux-pci-owner@vger.kernel.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/18/2010 10:23 AM, Jesse Barnes wrote:
> On Tue, 15 Jun 2010 22:33:53 -0700
> "Justin P. Mattock" <justinmattock@gmail.com> wrote:
> 
>> The below patch fixes a warning message when using gcc 4.6.0
>>   CC      drivers/pci/setup-bus.o
>> drivers/pci/setup-bus.c: In function 'pci_assign_unassigned_bridge_resources':
>> drivers/pci/setup-bus.c:868:6: warning: variable 'retval' set but not used
>>  
>>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>>
>> ---
>>  drivers/pci/setup-bus.c |    2 --
>>  1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> index 19b1113..215590b 100644
>> --- a/drivers/pci/setup-bus.c
>> +++ b/drivers/pci/setup-bus.c
>> @@ -865,7 +865,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>>  	struct pci_bus *parent = bridge->subordinate;
>>  	int tried_times = 0;
>>  	struct resource_list_x head, *list;
>> -	int retval;
>>  	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
>>  				  IORESOURCE_PREFETCH;
>>  
>> @@ -874,7 +873,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>>  again:
>>  	pci_bus_size_bridges(parent);
>>  	__pci_bridge_assign_resources(bridge, &head);
>> -	retval = pci_reenable_device(bridge);
>>  	pci_set_master(bridge);
>>  	pci_enable_bridges(parent);
>>  

I sent following patch several weeks ago, can you put that in pci-next?

Subject: [PATCH] pciehp: Enable bridges at last for multiple try assigning

Found one PCIe Module with several bridges "cold" hotadd doesn't work.

the root cause:
1. BIOS assign small range the parent bridges.
2. First try for hotadd only can make some bridges get resource assigned.
3. Second will update parent bridge res, get right sizes for all child bridges
    and devices, but resource for child bridges are not set to HW register.
    Because first try already enable those bridges, so __pci_bridge_assign_resource
    skip the setting step.

So try to move enabling of child bridges to last and only do that one time

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -866,19 +866,16 @@ void pci_assign_unassigned_bridge_resour
 again:
 	pci_bus_size_bridges(parent);
 	__pci_bridge_assign_resources(bridge, &head);
-	retval = pci_reenable_device(bridge);
-	pci_set_master(bridge);
-	pci_enable_bridges(parent);
 
 	tried_times++;
 
 	if (!head.next)
-		return;
+		goto enable_all;
 
 	if (tried_times >= 2) {
 		/* still fail, don't need to try more */
 		free_failed_list(&head);
-		return;
+		goto enable_all;
 	}
 
 	printk(KERN_DEBUG "PCI: No. %d try to assign unassigned res\n",
@@ -911,5 +908,10 @@ again:
 	free_failed_list(&head);
 
 	goto again;
+
+enable_all:
+	retval = pci_reenable_device(bridge);
+	pci_set_master(bridge);
+	pci_enable_bridges(parent);
 }
 EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
