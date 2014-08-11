From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post
 Queue (RDPQ) Array support
Date: Mon, 11 Aug 2014 18:47:01 +0530
Message-ID: <CAK=zhgpGp57nMXeDGsNKg3SHsUc-LV25BtBuCcUBXqXUESzOWQ@mail.gmail.com>
References: <20140625103445.GA12943@avagotech.com>
	<yq1zjg2m6lu.fsf@sermon.lab.mkp.net>
	<CAK=zhgoQt5J=jh4jShAy5rBXNz34sN-tqf=uZDkY4zQJ9XhM5g@mail.gmail.com>
	<yq18unklvda.fsf@sermon.lab.mkp.net>
	<CAK=zhgpDWJLBMBB1mV-7u+o_UC86PiOCAp4vi4-UAn_hXHtF2A@mail.gmail.com>
	<yq1r41bkgdp.fsf@sermon.lab.mkp.net>
	<CAK=zhgp_v_sdt+VLDs1Mxxi8Cg4nZNnzgQ=d228h+Ht2EpdEqw@mail.gmail.com>
	<yq138dpgr6z.fsf@sermon.lab.mkp.net>
	<CAK=zhgoEhW7fT7SV6ZkzgFa_A49W9quzWOgXb=DH3D_CrMAdDw@mail.gmail.com>
	<yq161i6epv5.fsf@sermon.lab.mkp.net>
	<CAK=zhgpqW-t11JKiBRRM7Z4TEMyaEUBX943qT8faaKPk6Pk4XA@mail.gmail.com>
	<CAK=zhgpiyt9xukGCNDOpEDmWRwFSMCcEiUQ190BW0UgiLGVP6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgpiyt9xukGCNDOpEDmWRwFSMCcEiUQ190BW0UgiLGVP6g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

Please let me known any further changes are required so that I can
send this patch once again with git send-email.

Regards,
Sreekanth

On Mon, Aug 11, 2014 at 6:45 PM, Sreekanth Reddy
<sreekanth.reddy@avagotech.com> wrote:
> Hi Martin,
>
> Please let me known any further changes are required so that I can send this
> patch once again with git send-email.
>
> Regards,
> Sreekanth
>
>
> On Wed, Aug 6, 2014 at 10:57 AM, Sreekanth Reddy
> <sreekanth.reddy@avagotech.com> wrote:
>>
>> Hi Martin,
>>
>> Replied inline.
>>
>> On Wed, Aug 6, 2014 at 12:16 AM, Martin K. Petersen
>> <martin.petersen@oracle.com> wrote:
>>>
>>> >>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com>
>>> >>>>> writes:
>>>
>>> Sreekanth,
>>>
>>> Patch was mangled and I had to apply every single hunk by hand. Please
>>> use git send-email.
>>>
>> Sorry, Next time onwards I will take of this.
>>
>>>
>>> +static int dma_mask;
>>> +
>>> +static int
>>> +_base_wait_for_doorbell_int(struct MPT2SAS_ADAPTER *ioc, int timeout,
>>> +                int sleep_flag);
>>> +static int
>>> +_base_wait_for_doorbell_ack(struct MPT2SAS_ADAPTER *ioc, int timeout,
>>> +                int sleep_flag);
>>> +static int
>>> +_base_wait_for_doorbell_not_used(struct MPT2SAS_ADAPTER *ioc, int
>>> timeout,
>>> +                 int sleep_flag);
>>> +static int
>>> +_base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER *ioc, int
>>> request_bytes,
>>> +    u32 *request, int reply_bytes, u16 *reply, int timeout, int
>>> sleep_flag);
>>> +static int
>>> +_base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag);
>>>
>>> Are you sure you need all these? _base_get_ioc_facts was the only one
>>> that needed to be declared in my original patch.
>>
>>
>> Accepted only _base_get_ioc_facts is needs to be declared here.
>>
>>>
>>>
>>> +    if (ioc->rdpq_array_enable)
>>> +        sz = reply_post_free_sz;
>>> +    else {
>>> +        if (_base_is_controller_msix_enabled(ioc))
>>> +            sz = reply_post_free_sz * ioc->reply_queue_count;
>>> +        else
>>> +            sz = reply_post_free_sz;
>>> +    }
>>>
>>> sz = reply_post_free_sz;
>>> if (_base_is_controller_msix_enabled(ioc) && !ioc->rdpq_array_enable)
>>>    sz *= ioc->reply_queue_count;
>>
>>
>> Accepted. In the next time I will update this in the patch.
>>>
>>>
>>> +    ioc->reply_post = kcalloc((ioc->rdpq_array_enable) ?
>>> +        (ioc->reply_queue_count):1,
>>> +        sizeof(struct reply_post_struct), GFP_KERNEL);
>>>
>>> You're special casing the !rdpq code path again. Why don't you just make
>>> sure reply_queue_count is always correct?
>>
>>
>> Here we are using the reply_post queue to store the base address of the
>> complete reply_post_free queue pool in case of non rdpq support scenario
>> (since here we allocate a complete memory pool of all the reply_queue_count
>> number of reply queues in single shot, so there is only one continuous
>> memory pool). so here the number of entries in the reply_post queue is one
>> in case of non rdpq support scenario.
>>
>> In case of rdpq support scenario reply_post queue will store the base
>> addresses of each and every reply_queue_count number of reply_post_free
>> queue pool. since here we allocate individual and separate reply_post_free
>> memory pool for each msix vector. so here reply_queue_count number of
>> individual reply_post_free queue pools are allocated, so the number of
>> entries in the reply_post queue is reply_queue_count value.
>>
>> So, here the number of entries in the reply_post queue is not dependent on
>> the reply_queue_count but it depends on the the rdpq_support enabled or not.
>> i.e. if rdpq support is enabled then the number of entries in this
>> reply_post queue is reply_queue_count value other wise it is one.
>>
>>>
>>>
>>> +    do {
>>> +        ioc->reply_post[i].reply_post_free =
>>> +            pci_pool_alloc(ioc->reply_post_free_dma_pool,
>>> +            GFP_KERNEL,
>>> +            &ioc->reply_post[i].reply_post_free_dma);
>>> +        if (!ioc->reply_post[i].reply_post_free) {
>>> +            printk(MPT2SAS_ERR_FMT
>>> +            "reply_post_free pool: pci_pool_alloc failed\n",
>>> +            ioc->name);
>>> +            goto out;
>>> +        }
>>> +        memset(ioc->reply_post[i].reply_post_free, 0, sz);
>>> +        dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
>>> +            "reply post free pool (0x%p): depth(%d),"
>>> +            "element_size(%d), pool_size(%d kB)\n", ioc->name,
>>> +            ioc->reply_post[i].reply_post_free,
>>> +            ioc->reply_post_queue_depth, 8, sz/1024));
>>> +        dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
>>> +            "reply_post_free_dma = (0x%llx)\n", ioc->name,
>>> +            (unsigned long long)
>>> +            ioc->reply_post[i].reply_post_free_dma));
>>> +        total_sz += sz;
>>> +    } while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
>>>
>>> Same thing. I think:
>>>
>>>      for (i = 0; i < ioc->reply_queue_count ; i++) {
>>>
>>> was much clearer.
>>
>>
>> I feel do while loop is suitable to reduce the redundancy code between the
>> rdpq support and non rdpq support scenarios.
>>
>> In case of non rdpq support scenario, this loop is executed only once to
>> allocate a continuous single memory pool for all reply_queue_count number of
>> reply_post_free queues.
>>
>> where as in case of rdpq support scenario, this loop is executed
>> reply_queue_count number of times for allocating individual and separate
>> memory pools for each reply_post_free queue.
>>
>>>
>>>
>>> If reply_queue_count is ever inconsistent wrt. ioc->rdpq_array_enable
>>> and _base_is_controller_msix_enabled(ioc) then that's an orthogonal
>>> problem that you should address directly instead of working around it
>>> several places in the code.
>>
>>
>>>
>>> --
>>> Martin K. Petersen      Oracle Linux Engineering
>>
>>
>> Regards,
>> Sreekanth
>
>
