From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCHv5 2/2] tcmu: Fix wrongly calculating of the
 base_command_size
Date: Tue, 28 Mar 2017 13:34:26 -0500
Message-ID: <58DAACB2.1030509@redhat.com>
References: <1490605661-16127-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1490605661-16127-3-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20757 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755155AbdC1Sek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Mar 2017 14:34:40 -0400
In-Reply-To: <1490605661-16127-3-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, nab@linux-iscsi.org
Cc: agrover@redhat.com, shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com, iliastsi@arrikto.com

On 03/27/2017 04:07 AM, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> The t_data_nents and t_bidi_data_nents are the numbers of the
> segments, but it couldn't be sure the block size equals to size
> of the segment.
> 
> For the worst case, all the blocks are discontiguous and there
> will need the same number of iovecs, that's to say: blocks == iovs.
> So here just set the number of iovs to block count needed by tcmu
> cmd.
> 
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> Tested-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
> ---
>  drivers/target/target_core_user.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 65d475f..ede815c 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -408,6 +408,13 @@ static inline size_t tcmu_cmd_get_data_length(struct tcmu_cmd *tcmu_cmd)
>  	return data_length;
>  }
>  
> +static inline uint32_t tcmu_cmd_get_block_cnt(struct tcmu_cmd *tcmu_cmd)
> +{
> +	size_t data_length = tcmu_cmd_get_data_length(tcmu_cmd);
> +
> +	return data_length / DATA_BLOCK_SIZE;
> +}
> +
>  static sense_reason_t
>  tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
>  {
> @@ -435,8 +442,7 @@ static inline size_t tcmu_cmd_get_data_length(struct tcmu_cmd *tcmu_cmd)
>  	 * expensive to tell how many regions are freed in the bitmap
>  	*/
>  	base_command_size = max(offsetof(struct tcmu_cmd_entry,
> -				req.iov[se_cmd->t_bidi_data_nents +
> -					se_cmd->t_data_nents]),
> +				req.iov[tcmu_cmd_get_block_cnt(tcmu_cmd)]),
>  				sizeof(struct tcmu_cmd_entry));
>  	command_size = base_command_size
>  		+ round_up(scsi_command_size(se_cmd->t_task_cdb), TCMU_OP_ALIGN_SIZE);
> 

Looks ok to me. Thanks.
Reviewed-by: Mike Christie <mchristi@redhat.com>
