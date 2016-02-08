From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [mpt3sas driver 06/10] mpt3sas: Added smp_affinity_enable module
 parameter.
Date: Mon, 8 Feb 2016 13:38:27 +0100
Message-ID: <56B88C43.2070904@redhat.com>
References: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
 <1453963027-19770-7-git-send-email-suganath-prabu.subramani@avagotech.com>
 <56B367B5.5030001@redhat.com>
 <CA+RiK65WEot9z4H6M-9PEuCT0U7uMcwvVFskoQU1XBYLwdev+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+RiK65WEot9z4H6M-9PEuCT0U7uMcwvVFskoQU1XBYLwdev+w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Suganath prabu Subaramani <suganath-prabu.subramani@avagotech.com>, JBottomley@parallels.com, jejb@kernel.org, Christoph Hellwig <hch@infradead.org>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Krishnaraddi Mankani <krishnaraddi.mankani@avagotech.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "Elliott, Robert (Server Storage)" <elliott@hp.com>
List-Id: linux-scsi@vger.kernel.org

On 8.2.2016 07:01, Suganath Prabu Subramani wrote:
> Hi Tomas,
> Initially, we posted this patch with "zalloc_cpumassk_var" and Robert
> has suggested to use "alloc_cpumask_var". Please check the below link.
> "http://www.gossamer-threads.com/lists/linux/kernel/2068280?do=post_view_threaded#2068280"

That thread is about allocating more than KMALLOC_MAX_SIZE with a kmalloc,
it doesn't matter if it is a kzalloc or kmalloc.

If that is an issue in mpt3sas, in your code fails already here when !CONFIG_CPUMASK_OFFSTACK

        reply_q =  kzalloc(sizeof(struct adapter_reply_queue), GFP_KERNEL);
....
Good news is that the the size allocated in your case is much smaller than what
the lpfc tried at that time, (it used a struct with struct cpumask  maskbits;
and multiplied it with nr_cpus) -> this is not your case.
You can use that zalloc_cpumask_var.

--tm

>
> We incorporated other review comments for freeing reply_q and
> cpumask_var in this patch and sending it soon.
>
> Thanks,
> Suganath prabu S
>
> On Thu, Feb 4, 2016 at 8:31 PM, Tomas Henzl <thenzl@redhat.com> wrote:
>> On 28.1.2016 07:37, Suganath prabu Subaramani wrote:
>>> From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
>>>
>>> Module parameter to enable/disable configuring
>>> affinity hint for msix vector.
>>> SMP affinity feature can be enabled/disabled by setting
>>> module parameter "smp_affinity_enable" to 1/0.
>>> By default this feature is enabled. (smp_affinity_enable = 1 enabled).
>>>
>>> Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
>>> Signed-off-by: Chaitra P B <chaitra.basappa@avagotech.com>
>>> ---
>>>  drivers/scsi/mpt3sas/mpt3sas_base.c | 34 +++++++++++++++++++++++-----------
>>>  1 file changed, 23 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>>> index 31838d9a..a1a3b39 100644
>>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>>> @@ -83,6 +83,10 @@ static int msix_disable = -1;
>>>  module_param(msix_disable, int, 0);
>>>  MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
>>>
>>> +static int smp_affinity_enable = 1;
>>> +module_param(smp_affinity_enable, int, S_IRUGO);
>>> +MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disbale Default: enable(1)");
>>> +
>>>  static int max_msix_vectors = -1;
>>>  module_param(max_msix_vectors, int, 0);
>>>  MODULE_PARM_DESC(max_msix_vectors,
>>> @@ -1812,8 +1816,10 @@ _base_free_irq(struct MPT3SAS_ADAPTER *ioc)
>>>
>>>       list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
>>>               list_del(&reply_q->list);
>>> -             irq_set_affinity_hint(reply_q->vector, NULL);
>>> -             free_cpumask_var(reply_q->affinity_hint);
>>> +             if (smp_affinity_enable) {
>>> +                     irq_set_affinity_hint(reply_q->vector, NULL);
>>> +                     free_cpumask_var(reply_q->affinity_hint);
>>> +             }
>>>               synchronize_irq(reply_q->vector);
>>>               free_irq(reply_q->vector, reply_q);
>>>               kfree(reply_q);
>>> @@ -1844,9 +1850,11 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
>>>       reply_q->msix_index = index;
>>>       reply_q->vector = vector;
>>>
>>> -     if (!alloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL))
>>> -             return -ENOMEM;
>>> -     cpumask_clear(reply_q->affinity_hint);
>>> +     if (smp_affinity_enable) {
>>> +             if (!alloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL))
>> a kfree(reply_q); should go here
>>
>>> +                     return -ENOMEM;
>>> +             cpumask_clear(reply_q->affinity_hint);
>> maybe zalloc_cpumask_var ?
>>
>>> +     }
>>         if (r) {
>>                 pr_err(MPT3SAS_FMT "unable to allocate interrupt %d!\n",
>>                     reply_q->name, vector);
>>                 kfree(reply_q);
>> and a  free_cpumask_var (..)  here ?
>>                 return -EBUSY;
>>
>>
>> cheers,
>> tomash
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
