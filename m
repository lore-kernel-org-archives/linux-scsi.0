From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCHv3 0/5] Dynamic growing data area support
Date: Tue, 21 Mar 2017 13:34:15 +0800
Message-ID: <bd798334-7c4a-3af5-a017-112ca4774755@cmss.chinamobile.com>
References: <1490000964-15732-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1490073887.8236.41.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1490073887.8236.41.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: agrover@redhat.com, mchristi@redhat.com, shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 2017年03月21日 13:24, Nicholas A. Bellinger wrote:
> Hi Xiubo !
>
> On Mon, 2017-03-20 at 17:09 +0800, lixiubo@cmss.chinamobile.com wrote:
>> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>
>> Changed for V3:
>> - [PATCHv2 2/5] fix double usage of blocks and possible page fault
>>    call trace.
>> - [PATCHv2 5/5] fix a mistake.
>>
>> Changed for V2:
>> - [PATCHv2 1/5] just fixes some small spelling and other mistakes.
>>    And as the initial patch, here sets cmd area to 8M and data area to
>>    1G(1M fixed and 1023M growing)
>> - [PATCHv2 2/5] is a new one, adding global data block pool support.
>>    The max total size of the pool is 2G and all the targets will get
>>    growing blocks from here.
>>    Test this using multi-targets at the same time.
>> - [PATCHv2 3/5] changed nothing, respin it to avoid the conflict.
>> - [PATCHv2 4/5] and [PATCHv2 5/5] are new ones.
>>
>>
>> Xiubo Li (5):
>>    tcmu: Add dynamic growing data area feature support
>>    tcmu: Add global data block pool support
>>    target/user: Fix possible overwrite of t_data_sg's last iov[]
>>    target/user: Fix wrongly calculating of the base_command_size
>>    target/user: Clean up tcmu_queue_cmd_ring
>>
>>   drivers/target/target_core_user.c | 621 +++++++++++++++++++++++++++++++-------
>>   1 file changed, 514 insertions(+), 107 deletions(-)
>>
> I've not been following the details of your TCMU efforts, so will have
> defer to MNC + AGrover for Acked-by + Reviewed-bys here.  ;)
>
> One comment on the series ordering though..
>
> Patches #1 + #2 introduce new features, while patches #3 + #4 are
> bug-fixes to (existing..?) code.  AFAICT, patches #3 + #4 are
> stand-alone that don't depend on the new features.  Is that correct..?

Yes, that's right.

> If so, I'd prefer to apply #3 + #4 to target-pending/master for
> v4.11-rcX (eg: bug-fixes only), and include new features in #1 + #2 and
> cleanup in #5 to target-pending/for-next. (eg: next merge window for
> v4.12-rc1).
>
> Usually the preferred way when submitting patches is to always put
> bug-fixes first in the series, followed by new features, further
> cleanups, etc.
>
> That way it's easy for a maintainer to split out / cherry-pick bug-fixes
> from the series as necessary, without needing to worry about
> dependencies in the earlier patches.
>
> That said, if patch #3 + #4 are stand-alone bug-fixes, would you be so
> kind to re-order them at the head of the series, and re-submit..?
>
Sure.

I will split the #3, #4 separately.

Thanks,

BRs
Xiubo
