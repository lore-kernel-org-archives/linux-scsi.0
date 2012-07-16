From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/7] sbp-target: Consolidate duplicated error path code
 in sbp_handle_command()
Date: Mon, 16 Jul 2012 15:55:50 -0700
Message-ID: <1342479350.18004.298.camel@haakon2.linux-iscsi.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
	 <1342461882-5848-4-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342461882-5848-4-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chris Boot <bootc@bootc.net>, Stefan Richter <stefanr@s5r6.in-berlin.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-07-16 at 11:04 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> Cc: Chris Boot <bootc@bootc.net>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/target/sbp/sbp_target.c |   28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
> 

Looks like a reasonable 'de-dupe'.  Applied to for-next.

> diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
> index 7e6136e..2425ca4 100644
> --- a/drivers/target/sbp/sbp_target.c
> +++ b/drivers/target/sbp/sbp_target.c
> @@ -1219,28 +1219,14 @@ static void sbp_handle_command(struct sbp_target_request *req)
>  	ret = sbp_fetch_command(req);
>  	if (ret) {
>  		pr_debug("sbp_handle_command: fetch command failed: %d\n", ret);
> -		req->status.status |= cpu_to_be32(
> -			STATUS_BLOCK_RESP(STATUS_RESP_TRANSPORT_FAILURE) |
> -			STATUS_BLOCK_DEAD(0) |
> -			STATUS_BLOCK_LEN(1) |
> -			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_UNSPECIFIED_ERROR));
> -		sbp_send_status(req);
> -		sbp_free_request(req);
> -		return;
> +		goto err;
>  	}
>  
>  	ret = sbp_fetch_page_table(req);
>  	if (ret) {
>  		pr_debug("sbp_handle_command: fetch page table failed: %d\n",
>  			ret);
> -		req->status.status |= cpu_to_be32(
> -			STATUS_BLOCK_RESP(STATUS_RESP_TRANSPORT_FAILURE) |
> -			STATUS_BLOCK_DEAD(0) |
> -			STATUS_BLOCK_LEN(1) |
> -			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_UNSPECIFIED_ERROR));
> -		sbp_send_status(req);
> -		sbp_free_request(req);
> -		return;
> +		goto err;
>  	}
>  
>  	unpacked_lun = req->login->lun->unpacked_lun;
> @@ -1252,6 +1238,16 @@ static void sbp_handle_command(struct sbp_target_request *req)
>  	target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
>  			req->sense_buf, unpacked_lun, data_length,
>  			MSG_SIMPLE_TAG, data_dir, 0);
> +	return;
> +
> +err:
> +	req->status.status |= cpu_to_be32(
> +		STATUS_BLOCK_RESP(STATUS_RESP_TRANSPORT_FAILURE) |
> +		STATUS_BLOCK_DEAD(0) |
> +		STATUS_BLOCK_LEN(1) |
> +		STATUS_BLOCK_SBP_STATUS(SBP_STATUS_UNSPECIFIED_ERROR));
> +	sbp_send_status(req);
> +	sbp_free_request(req);
>  }
>  
>  /*
