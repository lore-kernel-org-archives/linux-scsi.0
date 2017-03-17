From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCHv2 4/5] target/user: Fix wrongly calculating of the
 base_command_size
Date: Fri, 17 Mar 2017 13:45:47 +0800
Message-ID: <89dddfd8-6582-81f5-6e3a-85085350615d@cmss.chinamobile.com>
References: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1488962743-17028-5-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:38045 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdCQFsL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Mar 2017 01:48:11 -0400
In-Reply-To: <1488962743-17028-5-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com

On 2017年03月08日 16:45, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>
> The t_data_nents and t_bidi_data_nents are all the numbers of the
> segments, and we couldn't be sure the size of the data area block
> will equal to size of the segment.
>
> Use the actually block number needed intead of the sum of segments.
>
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> ---
>   drivers/target/target_core_user.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 99cd239..117be07 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -650,8 +650,7 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>   	 * expensive to tell how many regions are freed in the bitmap
>   	*/
>   	base_command_size = max(offsetof(struct tcmu_cmd_entry,
> -				req.iov[se_cmd->t_bidi_data_nents +
> -					se_cmd->t_data_nents]),
> +				req.iov[tcmu_cmd->dbi_len]),
For the old code:

If the segment size is larger than the DATA_BLOCK_SIZE, and at the same 
time all the
data blocks won't be continues between each other(that to say each block 
will use
one iov: iov_cnt == block cnt > nents), the entry's cdb data will 
overlap with entry's
iov[] data.

Thanks,

BRs
Xiubo


>   				sizeof(struct tcmu_cmd_entry));
>   	command_size = base_command_size
>   		+ round_up(scsi_command_size(se_cmd->t_task_cdb), TCMU_OP_ALIGN_SIZE);
