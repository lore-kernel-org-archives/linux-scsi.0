From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH RFC] target/user: Add double ring buffers support.
Date: Mon, 13 Feb 2017 09:58:01 -0800
Message-ID: <f82b5412-e9e9-6d6f-882a-d26390a1784f@redhat.com>
References: <1486709283-15535-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <240ae8db-1ede-2710-fb9c-1af3a020286e@redhat.com>
 <a968c308-8e1e-692f-ab0e-1cd9738a64ad@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <a968c308-8e1e-692f-ab0e-1cd9738a64ad@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: Xiubo Li <lixiubo@cmss.chinamobile.com>, mchristi@redhat.com
Cc: nab@linux-iscsi.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 02/13/2017 01:50 AM, Xiubo Li wrote:
> There is one new scheme in my mind:

>> Yes I think it's now clear we need more buffer space to avoid
>> bottlenecks for high iops. The initial design kept it simple with the
>> 1MB vmalloc'd space but anticipated greater would be needed. It should
>> not be necessary to change userspace or the TCMU ABI to handle growing
>> the buffer for fast devices:
>>
>> 1. increase the region mmap()ed by userspace, TCMU_RING_SIZE, from 1MB
>> to 1GB or larger
> For the cmd area, set the size to fixed 512M, and data area's size to
> fixed 1G, is that okay ?

512M seems a little big for the cmd area... use of the cmd ring should 
be much smaller than the data area. Each cmd has a minimum size, but 
then to describe an additional page in the iovec[] should be just one 
struct iovec (16 bytes?) for each 4K page.

>> 3. Upgrade the current fixed-size bitmap-based tracking of data area
>> to handle the new scheme
> The Radix tree will be used to keep the block's index(0 ~
> 1G/DATA_BLOCK_SIZE) and physical page mapping relations. Each leaf is
> one data block(the size is DATA_BLOCK_SIZE).
>
> For non-leaf nodes, use the radix tags[0][SLOTs] to indicate wether
> slot[SLOTs]'s branch has free(reused the old one or NULL leafs) block
> leafs or not.
> This could speed the search of the free blocks in data area.

Yes I think radix tree is a good place to start.

Regards -- Andy
