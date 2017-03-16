From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 5/5] target/user: Clean up tcmu_queue_cmd_ring
Date: Thu, 16 Mar 2017 15:50:03 -0500
Message-ID: <7d9016c5-e067-bb35-756f-8a7fd143e6af@linux.vnet.ibm.com>
References: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1488962743-17028-6-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751185AbdCPXcL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 19:32:11 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2GKiDwJ011657
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 16:50:09 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 297ym4payg-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 16:50:09 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Thu, 16 Mar 2017 16:50:08 -0400
In-Reply-To: <1488962743-17028-6-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com


> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>
> Add two helpers to simplify the code, and move some code out of
> the cmdr spin lock to reduce the size of critical region.
>
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> ---
>   drivers/target/target_core_user.c | 54 ++++++++++++++++++++++-----------------
>   1 file changed, 30 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 117be07..5205d2f 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c

<SNIP>

>
> +static inline void tcmu_cmd_get_cmd_size(struct se_cmd *se_cmd,
> +			size_t *base_size, size_t *cmd_size)

Should this be tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd instead? Look at bottom.

> +{
> +	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
> +
> +	*base_size = max(offsetof(struct tcmu_cmd_entry,
> +				 req.iov[tcmu_cmd->dbi_len]),
> +				 sizeof(struct tcmu_cmd_entry));
> +
> +	*cmd_size = round_up(scsi_command_size(se_cmd->t_task_cdb),
> +			TCMU_OP_ALIGN_SIZE) + *base_size;
> +	WARN_ON(*cmd_size & (TCMU_OP_ALIGN_SIZE-1));
> +}
> +
>   static sense_reason_t
>   tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
>   {
>   	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
>   	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
>   	size_t base_command_size, command_size;
> -	struct tcmu_mailbox *mb;
> +	struct tcmu_mailbox *mb = udev->mb_addr;
>   	struct tcmu_cmd_entry *entry;
>   	struct iovec *iov;
>   	int iov_cnt, ret;
> @@ -642,6 +660,8 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>   	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags))
>   		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>
> +	if (se_cmd->se_cmd_flags & SCF_BIDI)
> +		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
>   	/*
>   	 * Must be a certain minimum size for response sense info, but
>   	 * also may be larger if the iov array is large.
> @@ -649,33 +669,19 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>   	 * We prepare way too many iovs for potential uses here, because it's
>   	 * expensive to tell how many regions are freed in the bitmap
>   	*/
> -	base_command_size = max(offsetof(struct tcmu_cmd_entry,
> -				req.iov[tcmu_cmd->dbi_len]),
> -				sizeof(struct tcmu_cmd_entry));
> -	command_size = base_command_size
> -		+ round_up(scsi_command_size(se_cmd->t_task_cdb), TCMU_OP_ALIGN_SIZE);
> -
> -	WARN_ON(command_size & (TCMU_OP_ALIGN_SIZE-1));
> -
> -	spin_lock_irq(&udev->cmdr_lock);
> -
> -	mb = udev->mb_addr;
> -	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
> -	data_length = round_up(se_cmd->data_length, DATA_BLOCK_SIZE);
> -	if (se_cmd->se_cmd_flags & SCF_BIDI) {
> -		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
> -		data_length += round_up(se_cmd->t_bidi_data_sg->length,
> -				DATA_BLOCK_SIZE);
> -	}
> +	tcmu_cmd_get_cmd_size(tcmu_cmd, &base_command_size, &command_size);

<SNIP>

So Based upon your definition of tcmu_cmd_get_cmd_size, why did you pass in tcmu_cmd here? It wont compile in its current state.

-Bryant
