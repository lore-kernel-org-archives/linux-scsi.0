From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH RFC] target/user: Add double ring buffers support.
Date: Tue, 14 Feb 2017 13:03:40 +0800
Message-ID: <5a82256f-aa97-53d6-4752-6787bd44500b@cmss.chinamobile.com>
References: <1486709283-15535-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <240ae8db-1ede-2710-fb9c-1af3a020286e@redhat.com>
 <8f0aad0d-9c55-c004-6882-5a31f0241aef@cmss.chinamobile.com>
 <6a8ea198-2af0-32cf-1ba8-ad6ac125c254@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <6a8ea198-2af0-32cf-1ba8-ad6ac125c254@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, mchristi@redhat.com
Cc: nab@linux-iscsi.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com
List-Id: linux-scsi@vger.kernel.org



On 2017年02月14日 01:42, Andy Grover wrote:
> On 02/12/2017 05:38 PM, Xiubo Li wrote:
>> On 2017年02月11日 02:02, Andy Grover wrote:
>>> 1. increase the region mmap()ed by userspace, TCMU_RING_SIZE, from 1MB
>>> to 1GB or larger
>>> 2. Don't vmalloc() the whole thing, instead vmalloc for the cmd ring
>>> portion, and dynamically alloc pages for the data area as needed and
>>> map them into the data area.
>> Should the data area mapping is dynamical or add one new API to
>> userspace to trigger it ?
>
> I would recommend having the kernel make the decision to allocate/map 
> more memory, or not (i.e. wait for existing I/O to complete and free 
> pages) because this avoids the need for a new API, and also the kernel 
> may better decide how to allocate total pages used across multiple 
> TCMU devices.
>
Yes, agreed.


>>> 4. Implement an algorithm to keep allocated pages mapped into the data
>>> area for reuse, and maybe a heuristic to keep extreme burstiness from
>>> over-allocating pages
>>>
>> Does a little like slab ?
>
> It's definitely becoming less of a storage issue and more of a 
> page-management issue. It might make sense to look at mm code and ask 
> mm experts for their advice, yep.
>
Sure, i will have a deep investigate about this.

Thanks very much.

BRs
Xiubo


>>> This should allow TCMU to allocate more data area as needed, not waste
>>> memory for slower devices, and avoid userspace ABI changes. Could we
>>> prototype this approach and see if it is workable?
>>>
>> I will do more investigate about this.
>
> Thank you for working to improve this area!
>
> Regards -- Andy
>
