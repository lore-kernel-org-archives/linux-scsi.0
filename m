From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] target/user: Fix possible overwrite of t_data_sg's
 lastiov[]
Date: Mon, 6 Mar 2017 13:48:27 +0800
Message-ID: <edee1773-74b5-d0e2-4b81-12cd75e55e52@cmss.chinamobile.com>
References: <1488260828-28167-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <92ad7848-8d75-3344-eff6-b003599c55e9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:42184 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752884AbdCFFs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 00:48:28 -0500
In-Reply-To: <92ad7848-8d75-3344-eff6-b003599c55e9@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, nab@linux-iscsi.org
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, mchristi@redhat.com, Ilias Tsitsimpis <iliastsi@arrikto.com>


> On 02/27/2017 09:47 PM, lixiubo@cmss.chinamobile.com wrote:
>> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>
>> If there has BIDI data, its first iov[] will overwrite the last
>> iov[] for se_cmd->t_data_sg.
>
> (+CCing orig BIDI and data block code authors)
>
> Yeah. It looks like because alloc_and_scatter_data_area() (hereafter 
> "aasda") is called twice in the BIDI case, and both times iov_cnt is 
> 0, the new_iov() call doesn't increment the iov ptr and the first bidi 
> iov overwrites the last data iov.
Yes, it is.

> Maybe fix this by exiting aasda() with iov pointing at the next unused 
> iov in the array? 
May it shouldn't be the aasda()'s duty to increment the iov ptr.


> Probably also want to zero the iov.
>
>> To fix this, we can just increase the iov pointer, but this may
>> introuduce a new memory leakage bug: If the se_cmd->data_length
>> and se_cmd->t_bidi_data_sg->length are all not aligned up to the
>> DATA_BLOCK_SIZE, the actual length needed maybe larger than just
>> sum of them.
>
> This also sounds right. But the solution below rounds up both data and 
> bidi lengths to DATA_BLOCK_SIZE separately. That's not quite right 
> either, since the current code (once aasda is fixed) allows the last 
> data and first bidi iovs to both have allocations from the same data 
> block. Shouldn't we be rounding up the sum of data and bidi 
> data_lengths to DATA_BLOCK_SIZE? Call this Option A.
Maybe it not very clear of the commit comments. This fix will separate
data from bidi blocks in iovs. Won't allow using the same data block.

For the round_up() changes:

The total data_length is only used for checking the available freed data 
block
space.

For example, when the se_cmd->data_length = 1K and t_bidi_data_sg->length
= 2K. The orig total data_length == sum(1K + 2K) == 3K, so in
is_ring_space_avail(..., data_length == 3K), if there has only one freed 
data block
space available in the ring, it will return TRUE.

But after this fixed patch, it actually needs two freed data block 
space, and the
total data_length should be round_up(1K, _SIZE) + round_UP(2K,
_SIZE) == 8K (here is two data blocks). So when there is only one freed 
data block
space available in ring, it should return FALSE and will wait and retry.


> Option B is we go with changing the implementation to always use a 
> separate data block for BIDI data (BIDI cmds are rare so no big deal), 
> but then also please look into simplifying code in aasda() and 
> tcmu_queue_cmd_ring that may now be overly complex.
>
Yes, there still has other bugs like this one,  i will try to simplify 
the code then.

For the BIDI data, still hasn't been used by the tcmu-runner. Is any 
other consumer
using this?

Thanks,

BRs
Xiubo

> Thanks -- Regards -- Andy
>
>>
>> So, this could be avoided by rounding all the data lengthes up
>> to DATA_BLOCK_SIZE.
>>
>> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
>> ---
>>  drivers/target/target_core_user.c | 17 +++++++++++------
>>  1 file changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/target/target_core_user.c 
>> b/drivers/target/target_core_user.c
>> index 2e33100..59a18fd 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -429,10 +429,11 @@ static bool is_ring_space_avail(struct tcmu_dev 
>> *udev, size_t cmd_size, size_t d
>>
>>      mb = udev->mb_addr;
>>      cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
>> -    data_length = se_cmd->data_length;
>> +    data_length = round_up(se_cmd->data_length, DATA_BLOCK_SIZE);
>>      if (se_cmd->se_cmd_flags & SCF_BIDI) {
>>          BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
>> -        data_length += se_cmd->t_bidi_data_sg->length;
>> +        data_length += round_up(se_cmd->t_bidi_data_sg->length,
>> +                DATA_BLOCK_SIZE);
>>      }
>>      if ((command_size > (udev->cmdr_size / 2)) ||
>>          data_length > udev->data_size) {
>> @@ -503,10 +504,14 @@ static bool is_ring_space_avail(struct tcmu_dev 
>> *udev, size_t cmd_size, size_t d
>>      entry->req.iov_dif_cnt = 0;
>>
>>      /* Handle BIDI commands */
>> -    iov_cnt = 0;
>> -    alloc_and_scatter_data_area(udev, se_cmd->t_bidi_data_sg,
>> -        se_cmd->t_bidi_data_nents, &iov, &iov_cnt, false);
>> -    entry->req.iov_bidi_cnt = iov_cnt;
>> +    if (se_cmd->se_cmd_flags & SCF_BIDI) {
>> +        iov_cnt = 0;
>> +        iov++;
>> +        alloc_and_scatter_data_area(udev, se_cmd->t_bidi_data_sg,
>> +                se_cmd->t_bidi_data_nents, &iov, &iov_cnt,
>> +                false);
>> +        entry->req.iov_bidi_cnt = iov_cnt;
>> +    }
>>
>>      /* cmd's data_bitmap is what changed in process */
>>      bitmap_xor(tcmu_cmd->data_bitmap, old_bitmap, udev->data_bitmap,
>>
>
