From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH RFC] target/user: Add double ring buffers support.
Date: Wed, 15 Feb 2017 13:46:26 +0800
Message-ID: <d51bb3d2-a4fe-ba99-8a5a-7d619d3ea5ad@cmss.chinamobile.com>
References: <1486709283-15535-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <240ae8db-1ede-2710-fb9c-1af3a020286e@redhat.com>
 <a968c308-8e1e-692f-ab0e-1cd9738a64ad@cmss.chinamobile.com>
 <f82b5412-e9e9-6d6f-882a-d26390a1784f@redhat.com>
 <801a726b-7f35-98b6-e150-dfa034539e32@cmss.chinamobile.com>
 <c02847d6-4bd0-f901-2ba8-c58bc500865c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <c02847d6-4bd0-f901-2ba8-c58bc500865c@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, mchristi@redhat.com
Cc: nab@linux-iscsi.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com
List-Id: linux-scsi@vger.kernel.org

>> The struct tcmu_cmd_entry {} size is fixed 44 bytes without iovec[], and
>> the size of struct iovec[N] is about 16 bytes * N.
>>
>> The cmd entry size will be [44B, N *16 + 44B], and the data size will be
>> [0, N * 4096], so the ratio of sizeof(cmd entry): sizeof(entry datas) ==
>> (N * 16 + 44)Bytes : (N * 4096)Bytes == (N * 16)/(N * 4096) +
>> 44/(N*4096) == 1/256 + 11/(N * 1024).
>> When N is bigger, the ratio will be smaller. If N >= 1, the ratio will
>> be [15/1024, 4/1024).
>>
>> So, that's right, 512M is a little bigger than actually needed, for the
>> safe ratio i think 16/1024 is enough, if the data area is fixed 1G, so
>> the cmd area could be 16M+.
>> Or cmd area(64M) + data area(960M) == 1G ?
> Seems like a good ratio. You could look at growing the cmd ring when
> deciding to allocate more pages for the data area. But, growing the cmd
> ring is a little trickier (see below) so maybe have a different policy
> for deciding when & how much to grow.
>
> Changing the cmd ring size: Unlike the data area where you can just
> allocate & map more pages, I think the cmd ring you probably want to
> complete all I/O, get cmd_head and cmd_tail back to the top with a PAD
> op, and *then* reallocate/remap the cmd ring and update
> tcmu_mailbox.cmdr_size.
Yes, that sounds nice. Growing the cmd area will be much more
complex, and this could be implemented in the future.

I will try to implement the following simple new scheme firstly:
- Fixed cmd area using the vmalloc(), total size will be 64M or 128M(?)
- Growing data area using kmalloc(DATA_BLOCK_SIZE, GFP_ATOMIC),
   the maximum total size will be 1G.

Thanks,

BRs
Xiubo

> Regards -- Andy
