From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH 3/5]pci:bus.c Fix variable 'retval' set but not used
Date: Tue, 15 Jun 2010 23:56:48 -0700
Message-ID: <4C1875B0.1050007@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com> 	<1276666434-11227-4-git-send-email-justinmattock@gmail.com> <AANLkTik27fbCY0pMJdcbuCaEXr-902WiqiFPkju4Bet0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <AANLkTik27fbCY0pMJdcbuCaEXr-902WiqiFPkju4Bet0@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/15/2010 10:42 PM, Julian Calaby wrote:
> On Wed, Jun 16, 2010 at 15:33, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> The patch below fixes the warning message I am seeing with gcc 4.6.0
>>   CC      drivers/pci/bus.o
>> drivers/pci/bus.c: In function 'pci_enable_bridges':
>> drivers/pci/bus.c:237:6: warning: variable 'retval' set but not used
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/pci/bus.c |    2 --
>>   1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
>> index 628ea20..84bdb48 100644
>> --- a/drivers/pci/bus.c
>> +++ b/drivers/pci/bus.c
>> @@ -234,12 +234,10 @@ void pci_bus_add_devices(const struct pci_bus *bus)
>>   void pci_enable_bridges(struct pci_bus *bus)
>>   {
>>         struct pci_dev *dev;
>> -       int retval;
>>
>>         list_for_each_entry(dev,&bus->devices, bus_list) {
>>                 if (dev->subordinate) {
>>                         if (!pci_is_enabled(dev)) {
>> -                               retval = pci_enable_device(dev);
>>                                 pci_set_master(dev);
>>                         }
>>                         pci_enable_bridges(dev->subordinate);
>
> Er, this appears to be bogus: I'm only guessing, but I'd expect that
> the pci_enable_device() call is actually doing something useful, and
> removing it is going to break *something* - Have you booted a kernel
> with this code enabled and these patches applied?
>
> As for this warning, I think that there is a better solution.
>
> Thanks,
>

alright!!

Justin P. Mattock
