From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCHv4 2/4] tcmu: Fix wrongly calculating of the
 base_command_size
Date: Tue, 21 Mar 2017 15:53:09 -0400
Message-ID: <77be5d5f-c899-1379-87f6-720aa3755504@redhat.com>
References: <1490085382-28658-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1490085382-28658-3-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38752 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752625AbdCUTxR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Mar 2017 15:53:17 -0400
In-Reply-To: <1490085382-28658-3-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, agrover@redhat.com, nab@linux-iscsi.org
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com

On 03/21/2017 04:36 AM, lixiubo@cmss.chinamobile.com wrote:
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
> ---
>  drivers/target/target_core_user.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 65d475f..ae5b74f 100644
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
> +	return (data_length + DATA_BLOCK_SIZE - 1) / DATA_BLOCK_SIZE;
> +}

Can you just do data_length / DATA_BLOCK_SIZE, because
tcmu_cmd_get_data_length will return data_length as a multiple of
DATA_BLOCK_SIZE.
