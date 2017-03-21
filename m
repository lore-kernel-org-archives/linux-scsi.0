From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCHv3 3/5] target/user: Fix possible overwrite of t_data_sg's
 last iov[]
Date: Tue, 21 Mar 2017 15:10:00 -0400
Message-ID: <77af2a99-d51c-7212-acf1-cf61b50cfdc5@redhat.com>
References: <1490000964-15732-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1490000964-15732-4-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47726 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758175AbdCUTKL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Mar 2017 15:10:11 -0400
In-Reply-To: <1490000964-15732-4-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, agrover@redhat.com, nab@linux-iscsi.org
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com

On 03/20/2017 05:09 AM, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> If there has BIDI data, its first iov[] will overwrite the last
> iov[] for se_cmd->t_data_sg.
> 
> To fix this, we can just increase the iov pointer, but this may
> introuduce a new memory leakage bug: If the se_cmd->data_length
> and se_cmd->t_bidi_data_sg->length are all not aligned up to the
> DATA_BLOCK_SIZE, the actual length needed maybe larger than just
> sum of them.
> 
> So, this could be avoided by rounding all the data lengthes up
> to DATA_BLOCK_SIZE.
> 
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_user.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 8cbe196..780c30f 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -288,13 +288,14 @@ static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
>  
>  static inline uint32_t tcmu_cmd_get_dbi_len(struct se_cmd *se_cmd)
>  {
> -	size_t data_length = se_cmd->data_length;
> +	size_t data_length = round_up(se_cmd->data_length, DATA_BLOCK_SIZE);
>  	uint32_t dbi_len;
>  
>  	if (se_cmd->se_cmd_flags & SCF_BIDI)
> -		data_length += se_cmd->t_bidi_data_sg->length;
> +		data_length += round_up(se_cmd->t_bidi_data_sg->length,
> +					DATA_BLOCK_SIZE);
>  
> -	dbi_len = (data_length + DATA_BLOCK_SIZE - 1) / DATA_BLOCK_SIZE;
> +	dbi_len = data_length / DATA_BLOCK_SIZE;
>  
>  	return dbi_len;
>  }
> @@ -609,10 +610,11 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>  
>  	mb = udev->mb_addr;
>  	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
> -	data_length = se_cmd->data_length;
> +	data_length = round_up(se_cmd->data_length, DATA_BLOCK_SIZE);
>  	if (se_cmd->se_cmd_flags & SCF_BIDI) {
>  		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
> -		data_length += se_cmd->t_bidi_data_sg->length;
> +		data_length += round_up(se_cmd->t_bidi_data_sg->length,
> +				DATA_BLOCK_SIZE);
>  	}
>  	if ((command_size > (udev->cmdr_size / 2)) ||
>  	    data_length > udev->data_size) {
> @@ -690,15 +692,19 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>  	entry->req.iov_dif_cnt = 0;
>  
>  	/* Handle BIDI commands */
> -	iov_cnt = 0;
> -	ret = alloc_and_scatter_data_area(udev, tcmu_cmd,
> -		se_cmd->t_bidi_data_sg, se_cmd->t_bidi_data_nents,
> -		&iov, &iov_cnt, false);
> -	if (ret) {
> -		pr_err("tcmu: alloc and scatter bidi data failed\n");
> -		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +	if (se_cmd->se_cmd_flags & SCF_BIDI) {
> +		iov_cnt = 0;
> +		iov++;
> +		ret = alloc_and_scatter_data_area(udev, tcmu_cmd,
> +					se_cmd->t_bidi_data_sg,
> +					se_cmd->t_bidi_data_nents,
> +					&iov, &iov_cnt, false);
> +		if (ret) {
> +			pr_err("tcmu: alloc and scatter bidi data failed\n");
> +			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +		}
> +		entry->req.iov_bidi_cnt = iov_cnt;
>  	}
> -	entry->req.iov_bidi_cnt = iov_cnt;
>  
>  	/* All offsets relative to mb_addr, not start of entry! */
>  	cdb_off = CMDR_OFF + cmd_head + base_command_size;
> 

Looks ok to me. Thanks.

Reviewed-by: Mike Christie <mchristi@redhat.com>
