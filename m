From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] tcmu: Fix possbile memory leak when recalculating the
 cmdbase size
Date: Tue, 11 Jul 2017 17:33:31 +0800
Message-ID: <9cc9d1ca-7e7b-6858-b65c-8649e4283378@cmss.chinamobile.com>
References: <1499760357-15120-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <8284220f-3ec6-06db-8e09-127f997a774c@cmss.chinamobile.com>
 <1499765039.16582.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1499765039.16582.3.camel@wdc.com>
Sender: target-devel-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "mchristi@redhat.com" <mchristi@redhat.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "bryantly@linux.vnet.ibm.com" <bryantly@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Damien,

Good news.

Thanks very much for you help to test about this.


On 2017年07月11日 17:24, Damien Le Moal wrote:
> Xiubo,
>
> Well done ! This fixed my problem. The ZBC test suite now passes all tests on
> my target without crashing the kernel.
>
> Please see some comments/nitpicks below.
>
> Otherwise, please feel free to add my "tested-by"
>
>
> On Tue, 2017-07-11 at 17:06 +0800, Xiubo Li wrote:
>> On 2017年07月11日 16:05, lixiubo@cmss.chinamobile.com wrote:
>>> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>>
>>> For all the entries allocated from the ring cmd area, the memory
>>> is something like the stack, which will reserve the old data, so
>>> the entry->req.iov_bidi_cnt maybe none zero.
>>>
>>> To fix this, just memset all the entry memory before using it, and
>>> also to be more readable we adjust the bidi code.
>>>
>>> Fixed: fe25cc34795(tcmu: Recalculate the tcmu_cmd size to save cmd area
>>> 		memories)
>>> Reported-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
>>> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>> ---
>>>    drivers/target/target_core_user.c | 5 +++--
>>>    1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/target/target_core_user.c
>>> b/drivers/target/target_core_user.c
>>> index 2f1fa92..be62c86 100644
>>> --- a/drivers/target/target_core_user.c
>>> +++ b/drivers/target/target_core_user.c
>>> @@ -840,6 +840,7 @@ static inline size_t tcmu_cmd_get_cmd_size(struct
>>> tcmu_cmd *tcmu_cmd,
>>>    	}
>>>    
>>>    	entry = (void *) mb + CMDR_OFF + cmd_head;
>>> +	memset(entry, 0, command_size);
>>>    	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_CMD);
>>>    	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
>>>    	entry->hdr.kflags = 0;
> The added memset allows removing the 0 assignment here, and the one that
> follows this one too.
>
Yes, it is. Maybe reserving them could make the code more readable ?

Thanks,

BRs
Xiubo

>>> @@ -865,8 +866,8 @@ static inline size_t tcmu_cmd_get_cmd_size(struct
>>> tcmu_cmd *tcmu_cmd,
>>>    	entry->req.iov_dif_cnt = 0;
>>>    
>>>    	/* Handle BIDI commands */
>>> +	iov_cnt = 0;
>>>    	if (se_cmd->se_cmd_flags & SCF_BIDI) {
>>> -		iov_cnt = 0;
>>>    		iov++;
>>>    		ret = scatter_data_area(udev, tcmu_cmd,
>>>    					se_cmd->t_bidi_data_sg,
>>> @@ -879,8 +880,8 @@ static inline size_t tcmu_cmd_get_cmd_size(struct
>>> tcmu_cmd *tcmu_cmd,
>>>    			pr_err("tcmu: alloc and scatter bidi data
>>> failed\n");
>>>    			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>>>    		}
>>> -		entry->req.iov_bidi_cnt = iov_cnt;
>>>    	}
>>> +	entry->req.iov_bidi_cnt = iov_cnt;
>>>    
>>>    	/*
>>>    	 * Recalaulate the command's base size and size according
> For reference, here is the actual patch I used for testing:
>
> diff --git a/drivers/target/target_core_user.c
> b/drivers/target/target_core_user.c
> index 2f1fa92..3b25ef3 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -563,7 +563,7 @@ static int scatter_data_area(struct tcmu_dev *udev,
>   			to_offset = get_block_offset_user(udev, dbi,
>   					block_remaining);
>   			offset = DATA_BLOCK_SIZE - block_remaining;
> -			to = (void *)(unsigned long)to + offset;
> +			to += offset;
>   
>   			if (*iov_cnt != 0 &&
>   			    to_offset == iov_tail(udev, *iov)) {
> @@ -636,7 +636,7 @@ static void gather_data_area(struct tcmu_dev *udev, struct
> tcmu_cmd *cmd,
>   			copy_bytes = min_t(size_t, sg_remaining,
>   					block_remaining);
>   			offset = DATA_BLOCK_SIZE - block_remaining;
> -			from = (void *)(unsigned long)from + offset;
> +			from += offset;
>   			tcmu_flush_dcache_range(from, copy_bytes);
>   			memcpy(to + sg->length - sg_remaining, from,
>   					copy_bytes);
> @@ -840,10 +840,9 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
>   	}
>   
>   	entry = (void *) mb + CMDR_OFF + cmd_head;
> +	memset(entry, 0, command_size);
>   	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_CMD);
>   	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
> -	entry->hdr.kflags = 0;
> -	entry->hdr.uflags = 0;
>   
>   	/* Handle allocating space from the data area */
>   	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
> @@ -862,11 +861,10 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
>   		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>   	}
>   	entry->req.iov_cnt = iov_cnt;
> -	entry->req.iov_dif_cnt = 0;
>   
>   	/* Handle BIDI commands */
> +	iov_cnt = 0;
>   	if (se_cmd->se_cmd_flags & SCF_BIDI) {
> -		iov_cnt = 0;
>   		iov++;
>   		ret = scatter_data_area(udev, tcmu_cmd,
>   					se_cmd->t_bidi_data_sg,
> @@ -879,8 +877,8 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
>   			pr_err("tcmu: alloc and scatter bidi data failed\n");
>   			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>   		}
> -		entry->req.iov_bidi_cnt = iov_cnt;
>   	}
> +	entry->req.iov_bidi_cnt = iov_cnt;
>   
>   	/*
>   	 * Recalaulate the command's base size and size according
> -- 
>
> Best regards.
>
