From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] tcmu: Fix possible overflow for memcpy address in iovec
Date: Tue, 11 Jul 2017 17:04:39 +0800
Message-ID: <45bc0296-7b3a-c2d5-8e3b-c7b60ff6e2bb@cmss.chinamobile.com>
References: <1499758843-14159-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <c77ef933-1d47-b885-e3be-4a8b39b5e9fe@cmss.chinamobile.com>
 <1499762465.28145.48.camel@haakon3.daterainc.com>
 <f6d78118-ae7a-219e-005c-820d80b02477@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <f6d78118-ae7a-219e-005c-820d80b02477@wdc.com>
Sender: target-devel-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: mchristi@redhat.com, bryantly@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


>>>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>>>> index 930800c..86a845a 100644
>>>> --- a/drivers/target/target_core_user.c
>>>> +++ b/drivers/target/target_core_user.c
>>>> @@ -437,7 +437,7 @@ static int scatter_data_area(struct tcmu_dev *udev,
>>>>    			to_offset = get_block_offset_user(udev, dbi,
>>>>    					block_remaining);
>>>>    			offset = DATA_BLOCK_SIZE - block_remaining;
>>>> -			to = (void *)(unsigned long)to + offset;
>>>> +			to = (void *)((unsigned long)to + offset);
>>>>    
>>>>    			if (*iov_cnt != 0 &&
>>>>    			    to_offset == iov_tail(udev, *iov)) {
>>>> @@ -510,7 +510,7 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>>>>    			copy_bytes = min_t(size_t, sg_remaining,
>>>>    					block_remaining);
>>>>    			offset = DATA_BLOCK_SIZE - block_remaining;
>>>> -			from = (void *)(unsigned long)from + offset;
>>>> +			from = (void *)((unsigned long)from + offset);
>>>>    			tcmu_flush_dcache_range(from, copy_bytes);
>>>>    			memcpy(to + sg->length - sg_remaining, from,
>>>>    					copy_bytes);
> I was just looking at this patch and about to try to see if it fixes my
> problem... It cannot hurt. Trying...
Hi Damien,

Please test another patch, I think that one maybe fix this.

Thanks,
BRs
