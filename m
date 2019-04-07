From: Mukesh Ojha <mojha@codeaurora.org>
Subject: Re: [PATCH] scsi: mvumi: fix warning Using plain integer as NULL
 pointer
Date: Sun, 7 Apr 2019 11:44:06 +0530
Message-ID: <c84ef8f8-5a3d-4027-5f92-edb3544fecde@codeaurora.org>
References: <20190406175331.GA22504@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190406175331.GA22504@hari-Inspiron-1545>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 4/6/2019 11:23 PM, Hariprasad Kelam wrote:
> Changed "0 to NULL" to avoid below sparse warnings
>
> drivers/scsi/mvumi.c:755:58: warning: Using plain integer as NULL
> pointer
> drivers/scsi/mvumi.c:1797:48: warning: Using plain integer as NULL
> pointer
> drivers/scsi/mvumi.c:2142:50: warning: Using plain integer as NULL
> pointer
>
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> ---
>   drivers/scsi/mvumi.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 3df0269..a541061 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -752,7 +752,7 @@ static int mvumi_issue_blocked_cmd(struct mvumi_hba *mhba,
>   		spin_lock_irqsave(mhba->shost->host_lock, flags);
>   		atomic_dec(&cmd->sync_cmd);
>   		if (mhba->tag_cmd[cmd->frame->tag]) {
> -			mhba->tag_cmd[cmd->frame->tag] = 0;
> +			mhba->tag_cmd[cmd->frame->tag] = NULL;
>   			dev_warn(&mhba->pdev->dev, "TIMEOUT:release tag [%d]\n",
>   							cmd->frame->tag);
>   			tag_release_one(mhba, &mhba->tag_pool, cmd->frame->tag);
> @@ -1794,7 +1794,7 @@ static void mvumi_handle_clob(struct mvumi_hba *mhba)
>   		cmd = mhba->tag_cmd[ob_frame->tag];
>   
>   		atomic_dec(&mhba->fw_outstanding);
> -		mhba->tag_cmd[ob_frame->tag] = 0;
> +		mhba->tag_cmd[ob_frame->tag] = NULL;
>   		tag_release_one(mhba, &mhba->tag_pool, ob_frame->tag);
>   		if (cmd->scmd)
>   			mvumi_complete_cmd(mhba, cmd, ob_frame);
> @@ -2139,7 +2139,7 @@ static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
>   	spin_lock_irqsave(mhba->shost->host_lock, flags);
>   
>   	if (mhba->tag_cmd[cmd->frame->tag]) {
> -		mhba->tag_cmd[cmd->frame->tag] = 0;
> +		mhba->tag_cmd[cmd->frame->tag] = NULL;
>   		tag_release_one(mhba, &mhba->tag_pool, cmd->frame->tag);
>   	}
>   	if (!list_empty(&cmd->queue_pointer))
