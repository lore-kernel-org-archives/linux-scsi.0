From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] target/user: Fix use-after-free cmd->se_cmd if the cmd
 isexpired
Date: Wed, 4 Jan 2017 16:51:49 +0800
Message-ID: <e4c25855-8570-dd54-50e5-7e23791b22f4@cmss.chinamobile.com>
References: <1483433176-21063-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <586C5004.5030909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <586C5004.5030909@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, bart.vanassche@sandisk.com
Cc: varun@chelsio.com, agrover@redhat.com, bgly@us.ibm.com, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, namei.unix@gmail.com, stable@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org


Hi Mike

Thanks very much for your analysis.

>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>> index 2e33100..6396581 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -684,7 +684,6 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
>>   
>>   	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
>>   	target_complete_cmd(cmd->se_cmd, SAM_STAT_CHECK_CONDITION);
>> -	cmd->se_cmd = NULL;
>>   
> How did tcmu_handle_completion get to a point it was accessing the
> se_cmd if the TCMU_CMD_BIT_EXPIRED bit was set?
> Were memory accesses out
> of order?
No, even using the -O3, becuase has there memory dependency ?

> CPU1 set the TCMU_CMD_BIT_EXPIRED bit then cleared
> cmd->se_cmd, but CPU2 copied cmd->se_cmd to se_cmd and saw it was NULL
> but did not yet see the TCMU_CMD_BIT_EXPIRED bit set?

Because the debug rpms for my kernel version were lost, and the crash
tools couldn't be used to have a more accurate analysis.
>
> It looks like, if you do the above patch, the above function will call
> target_complete_cmd and tcmu_handle_completion will call it again, so we
> will have a double free issue.
Maybe the best resolution is to move tcmu_handle_completion() between
spin_lock(&udev->commands_lock) and spin_unlock(&udev->commands_lock)?

Thanks.

BRs
Xiubo Li
