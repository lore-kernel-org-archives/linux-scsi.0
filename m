From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [RFC] pci: Rework config space blocking services
Date: Tue, 06 Sep 2011 09:18:13 +0200
Message-ID: <4E65C935.9000803@siemens.com>
References: <20110829150552.GA6851@redhat.com> <4E5BB358.3060705@siemens.com> <4E5BDEAB.5000405@siemens.com> <20110829191858.GA9415@redhat.com> <4E608A51.70509@siemens.com> <20110906055810.GA13286@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from david.siemens.de ([192.35.17.14]:25036 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab1IFHS1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Sep 2011 03:18:27 -0400
In-Reply-To: <20110906055810.GA13286@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>

On 2011-09-06 09:00, Michael S. Tsirkin wrote:
> On Fri, Sep 02, 2011 at 09:48:33AM +0200, Jan Kiszka wrote:
>> On 2011-08-29 21:18, Michael S. Tsirkin wrote:
>>> On Mon, Aug 29, 2011 at 08:47:07PM +0200, Jan Kiszka wrote:
>>>> On 2011-08-29 17:42, Jan Kiszka wrote:
>>>>> I still don't get what prevents converting ipr to allow plain mutex
>>>>> synchronization. My vision is:
>>>>>  - push reset-on-error of ipr into workqueue (or threaded IRQ?)
>>>>
>>>> I'm starting to like your proposal: I had a look at ipr, but it turned
>>>> out to be anything but trivial to convert that driver. It runs its
>>>> complete state machine under spin_lock_irq, and the functions calling
>>>> pci_block/unblock_user_cfg_access are deep inside this thing. I have no
>>>> hardware to test whatever change, and I feel a bit uncomfortable asking
>>>> Brian to redesign his driver that massively.
>>>>
>>>> So back to your idea: I would generalize pci_block_user_cfg_access to
>>>> pci_block_cfg_access. It should fail when some other site already holds
>>>> the access lock, but it should remain non-blocking - for the sake of ipr.
>>>
>>> It would be easy to have blocking and non-blocking variants.
>>>
>>> But
>>> - I have no idea whether supporting sysfs config/reset access
>>>   while ipr is active makes any sense - I know we need it for uio.
>>> - reset while uio handles interrupt needs to block, not fail I think
>>>
>>
>> Here is a preview following those ideas. I'll look into generic INTx
>> masking services now and, if that works out and no concerns are raised,
>> I'll post it all.
>>
>> Jan
> 
> Hopefully as separate patches :)

For sure. :)

> 
> No real concerns, some nitpicking comments below.
> 
>> -----8<-----
>>
>> pci_block_user_cfg_access was designed for the use case that a single
>> context, the IPR driver, temporarily delays user space accesses to the
>> config space via sysfs. This assumption became invalid by the time
>> pci_dev_reset was added as locking instance. Today, if you run two loops
>> in parallel that reset the same device via sysfs, you end up with a
>> kernel BUG as pci_block_user_cfg_access detect the broken assumption.
>>
>> This reworks the pci_block_user_cfg_access to a sleeping service
>> pci_block_cfg_access and an atomic variant called
>> pci_block_cfg_access_in_atomic. The former not only blocks user space
>> access as before but also waits if access was already blocked. The
>> latter service just returns an error code in this case, allowing the
>> caller to resolve the conflict instead of raising a BUG.
> 
> I'm not sure I understand the point of the API renaming -
> the new names seem less clear than the original, to me.
> Regular config access isn't blocked by this API - it still only
> blocks user config accesses, we simply allow
> multiple block calls in parallel now.

It synchronizes everyone calling pci_block_cfg_access + sysfs access. So
this is no cosmetic renaming but something that reflects the key change
in the semantics IMO.

> 
> If we keep the old name, simply allow blocking
> and add an atomic variant, the patch will be much smaller.
> 
> 
>>
>> ---
>>  drivers/pci/access.c          |   76 +++++++++++++++++++++++++++--------------
>>  drivers/pci/iov.c             |   12 +++---
>>  drivers/pci/pci.c             |    4 +-
>>  drivers/scsi/ipr.c            |   24 +++++++++----
>>  drivers/uio/uio_pci_generic.c |   10 +++--
>>  include/linux/pci.h           |   14 +++++---
>>  6 files changed, 89 insertions(+), 51 deletions(-)
> 
> Below might be easier to review if it is split in two:
> 1. rename ucfg to cfg all over, tweak whitespace
> 2. allow multiple block calls, add in_atomic and update
>    in_atomic callers

As explained above, there is a strong relation between behavioral change
and API renaming in my eyes.

> 
>>
>> diff --git a/drivers/pci/access.c b/drivers/pci/access.c
>> index fdaa42a..640522a 100644
>> --- a/drivers/pci/access.c
>> +++ b/drivers/pci/access.c
>> @@ -127,20 +127,20 @@ EXPORT_SYMBOL(pci_write_vpd);
>>   * We have a bit per device to indicate it's blocked and a global wait queue
>>   * for callers to sleep on until devices are unblocked.
>>   */
>> -static DECLARE_WAIT_QUEUE_HEAD(pci_ucfg_wait);
>> +static DECLARE_WAIT_QUEUE_HEAD(pci_cfg_wait);
>>
>> -static noinline void pci_wait_ucfg(struct pci_dev *dev)
>> +static noinline void pci_wait_cfg(struct pci_dev *dev)
>>  {
>>       DECLARE_WAITQUEUE(wait, current);
>>
>> -     __add_wait_queue(&pci_ucfg_wait, &wait);
>> +     __add_wait_queue(&pci_cfg_wait, &wait);
>>       do {
>>               set_current_state(TASK_UNINTERRUPTIBLE);
>>               raw_spin_unlock_irq(&pci_lock);
>>               schedule();
>>               raw_spin_lock_irq(&pci_lock);
>> -     } while (dev->block_ucfg_access);
>> -     __remove_wait_queue(&pci_ucfg_wait, &wait);
>> +     } while (dev->block_cfg_access);
>> +     __remove_wait_queue(&pci_cfg_wait, &wait);
>>  }
>>
>>  /* Returns 0 on success, negative values indicate error. */
>> @@ -153,7 +153,8 @@ int pci_user_read_config_##size                                           \
>>       if (PCI_##size##_BAD)                                           \
>>               return -EINVAL;                                         \
>>       raw_spin_lock_irq(&pci_lock);                           \
>> -     if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);       \
>> +     if (unlikely(dev->block_cfg_access))                            \
>> +             pci_wait_cfg(dev);                                      \
>>       ret = dev->bus->ops->read(dev->bus, dev->devfn,                 \
>>                                       pos, sizeof(type), &data);      \
>>       raw_spin_unlock_irq(&pci_lock);                         \
>> @@ -172,7 +173,8 @@ int pci_user_write_config_##size                                  \
>>       if (PCI_##size##_BAD)                                           \
>>               return -EINVAL;                                         \
>>       raw_spin_lock_irq(&pci_lock);                           \
>> -     if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);       \
>> +     if (unlikely(dev->block_cfg_access))                            \
>> +             pci_wait_cfg(dev);                                      \
>>       ret = dev->bus->ops->write(dev->bus, dev->devfn,                \
>>                                       pos, sizeof(type), val);        \
>>       raw_spin_unlock_irq(&pci_lock);                         \
>> @@ -401,36 +403,58 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size)
>>  EXPORT_SYMBOL(pci_vpd_truncate);
>>
>>  /**
>> - * pci_block_user_cfg_access - Block userspace PCI config reads/writes
>> + * pci_block_cfg_access - Block PCI config reads/writes
> 
> This comment seems confusing. We don't in fact block all config
> reads writes. Instead we block userspace accesses and
> concurrent block requests.

I'm open for a better suggestion that summarize the more verbose (and
hopefully clearer) explanation below.

> 
>>   * @dev:     pci device struct
>>   *
>> - * When user access is blocked, any reads or writes to config space will
>> - * sleep until access is unblocked again.  We don't allow nesting of
>> - * block/unblock calls.
>> + * When access is blocked, any userspace reads or writes to config space
>> + * and concurrent block requests will sleep until
>> + * access is unblocked again.
>>   */
>> -void pci_block_user_cfg_access(struct pci_dev *dev)
>> +void pci_block_cfg_access(struct pci_dev *dev)
>>  {
>>       unsigned long flags;
>> -     int was_blocked;
>> +
>> +     might_sleep();
>> +
>> +     raw_spin_lock_irqsave(&pci_lock, flags);
>> +     if (dev->block_cfg_access)
>> +             pci_wait_cfg(dev);
>> +     dev->block_cfg_access = 1;
>> +     raw_spin_unlock_irqrestore(&pci_lock, flags);
> 
> Above can sleep so irq must be enabled, thus
> it can be raw_spin_lock_irq, right?

Yes, will clean up.

> 
>> +}
>> +EXPORT_SYMBOL_GPL(pci_block_cfg_access);
>> +
>> +/**
>> + * pci_block_cfg_access_in_atomic - Block PCI config reads/writes from atomic
>> + *                                  context
>> + * @dev:     pci device struct
>> + *
>> + * Same as pci_block_cfg_access, but will fail with -EBUSY if access is
>> + * already blocked.
> 
> Mention return value on success? Callers seem to rely on it being 0.

OK, also for all futher remarks.

Thanks for the review,
Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
