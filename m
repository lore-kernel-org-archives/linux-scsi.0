From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] target: update error handling for
 sbc_setup_write_same()
Date: Tue, 27 Nov 2012 19:03:19 -0800
Message-ID: <1354071799.18736.110.camel@haakon2.linux-iscsi.org>
References: <20121127142701.GA1059@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40811 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2K1DDV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Nov 2012 22:03:21 -0500
In-Reply-To: <20121127142701.GA1059@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

Hi Dan,

On Tue, 2012-11-27 at 17:27 +0300, Dan Carpenter wrote:
> We recently changed this to return positive subsystem error codes so the
> error handling needs to be updated.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

A nice catch on this sense_reason_t return breakage that I managed to
introduce within for-3.8 code.

Applied to for-next.

Thank you!

--nab

> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 943c689..4fd22cd 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -439,7 +439,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>  			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
>  
>  			ret = sbc_setup_write_same(cmd, &cdb[10], ops);
> -			if (ret < 0)
> +			if (ret)
>  				return ret;
>  			break;
>  		default:
> @@ -512,7 +512,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>  		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
>  
>  		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
> -		if (ret < 0)
> +		if (ret)
>  			return ret;
>  		break;
>  	case WRITE_SAME:
> @@ -530,7 +530,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>  		 * of byte 1 bit 3 UNMAP instead of original reserved field
>  		 */
>  		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
> -		if (ret < 0)
> +		if (ret)
>  			return ret;
>  		break;
>  	case VERIFY:
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


