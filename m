From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH RFC] target/user: Add double ring buffers support.
Date: Tue, 14 Feb 2017 13:50:46 +0800
Message-ID: <801a726b-7f35-98b6-e150-dfa034539e32@cmss.chinamobile.com>
References: <1486709283-15535-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <240ae8db-1ede-2710-fb9c-1af3a020286e@redhat.com>
 <a968c308-8e1e-692f-ab0e-1cd9738a64ad@cmss.chinamobile.com>
 <f82b5412-e9e9-6d6f-882a-d26390a1784f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:35528 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbdBNFus (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2017 00:50:48 -0500
In-Reply-To: <f82b5412-e9e9-6d6f-882a-d26390a1784f@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, mchristi@redhat.com
Cc: nab@linux-iscsi.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com


>>> Yes I think it's now clear we need more buffer space to avoid
>>> bottlenecks for high iops. The initial design kept it simple with the
>>> 1MB vmalloc'd space but anticipated greater would be needed. It should
>>> not be necessary to change userspace or the TCMU ABI to handle growing
>>> the buffer for fast devices:
>>>
>>> 1. increase the region mmap()ed by userspace, TCMU_RING_SIZE, from 1MB
>>> to 1GB or larger
>> For the cmd area, set the size to fixed 512M, and data area's size to
>> fixed 1G, is that okay ?
>
> 512M seems a little big for the cmd area... use of the cmd ring should 
> be much smaller than the data area. Each cmd has a minimum size, but 
> then to describe an additional page in the iovec[] should be just one 
> struct iovec (16 bytes?) for each 4K page.
>

The struct tcmu_cmd_entry {} size is fixed 44 bytes without iovec[], and 
the size of struct iovec[N] is about 16 bytes * N.

The cmd entry size will be [44B, N *16 + 44B], and the data size will be 
[0, N * 4096], so the ratio of sizeof(cmd entry): sizeof(entry datas) == 
(N * 16 + 44)Bytes : (N * 4096)Bytes == (N * 16)/(N * 4096) + 
44/(N*4096) == 1/256 + 11/(N * 1024).
When N is bigger, the ratio will be smaller. If N >= 1, the ratio will 
be [15/1024, 4/1024).

So, that's right, 512M is a little bigger than actually needed, for the 
safe ratio i think 16/1024 is enough, if the data area is fixed 1G, so 
the cmd area could be 16M+.
Or cmd area(64M) + data area(960M) == 1G ?


>>> 3. Upgrade the current fixed-size bitmap-based tracking of data area
>>> to handle the new scheme
>> The Radix tree will be used to keep the block's index(0 ~
>> 1G/DATA_BLOCK_SIZE) and physical page mapping relations. Each leaf is
>> one data block(the size is DATA_BLOCK_SIZE).
>>
>> For non-leaf nodes, use the radix tags[0][SLOTs] to indicate wether
>> slot[SLOTs]'s branch has free(reused the old one or NULL leafs) block
>> leafs or not.
>> This could speed the search of the free blocks in data area.
>
> Yes I think radix tree is a good place to start.
>
Okay.

Thanks,

BRs
Xiubo


> Regards -- Andy
>
