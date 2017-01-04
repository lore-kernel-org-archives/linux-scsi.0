From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] target/user: Fix use-after-free cmd->se_cmd if the cmd is
 expired
Date: Tue, 3 Jan 2017 19:29:40 -0600
Message-ID: <586C5004.5030909@redhat.com>
References: <1483433176-21063-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965614AbdADB3m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Jan 2017 20:29:42 -0500
In-Reply-To: <1483433176-21063-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, bart.vanassche@sandisk.com
Cc: varun@chelsio.com, agrover@redhat.com, bgly@us.ibm.com, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, namei.unix@gmail.com, stable@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>

On 01/03/2017 02:46 AM, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> This is another use-after-free bug, the crash Call Trace is like:
> [  368.909498] RIP: 0010:[<ffffffff81326766>]  [<ffffffff81326766>]
> memcpy+0x16/0x110
> ......
> [  368.909547] Call Trace:
> [  368.909550]  [<ffffffffa07717a9>] ?gather_data_area+0x109/0x180
> [  368.909552]  [<ffffffffa077227f>] tcmu_handle_completions+0x2ff/0x450
> [  368.909554]  [<ffffffffa07723e5>] tcmu_irqcontrol+0x15/0x20
> [  368.909555]  [<ffffffffa06f07eb>] uio_write+0x7b/0xc0
> [  368.909558]  [<ffffffff811fe12d>] vfs_write+0xbd/0x1e0
> [  368.909559]  [<ffffffff811fec4f>] SyS_write+0x7f/0xe0
> [  368.909562]  [<ffffffff816964c9>] system_call_fastpath+0x16/0x1b
> 
> Don't free se_cmd of the expired cmds in tcmu_check_expired_cmd(),
> it will be dereferenced by tcmu_handle_completions()--->
> tcmu_handle_completion(), after userspace ever resumes processing.
> 
> It will be freed by tcmu_handle_completion() if userspace ever recovers,
> or tcmu_free_device if not.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> Signed-off-by: Jianfei Hu <hujianfei@cmss.chinamobile.com>
> ---
>  drivers/target/target_core_user.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 2e33100..6396581 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -684,7 +684,6 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
>  
>  	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
>  	target_complete_cmd(cmd->se_cmd, SAM_STAT_CHECK_CONDITION);
> -	cmd->se_cmd = NULL;
>  

How did tcmu_handle_completion get to a point it was accessing the
se_cmd if the TCMU_CMD_BIT_EXPIRED bit was set? Were memory accesses out
of order? CPU1 set the TCMU_CMD_BIT_EXPIRED bit then cleared
cmd->se_cmd, but CPU2 copied cmd->se_cmd to se_cmd and saw it was NULL
but did not yet see the TCMU_CMD_BIT_EXPIRED bit set?

It looks like, if you do the above patch, the above function will call
target_complete_cmd and tcmu_handle_completion will call it again, so we
will have a double free issue.
