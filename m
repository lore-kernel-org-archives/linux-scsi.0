From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] stex: use resid for xfer len information
Date: Sun, 08 Jul 2007 15:44:28 +0300
Message-ID: <4690DC2C.6040006@panasas.com>
References: <NONAMEBYIqAFoXu4S910000013c@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5891 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751743AbXGHMoc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jul 2007 08:44:32 -0400
In-Reply-To: <NONAMEBYIqAFoXu4S910000013c@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: "james.Bottomley" <james.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Ed Lin wrote:
> The original implementation in stex_ys_commands() is inappropriate.
> For xfer len information, we should use resid instead.
> 
> Signed-off-by: Ed Lin <ed.lin@promise.com>
> ---
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index adda296..72f6d80 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -719,8 +719,8 @@ static void stex_ys_commands(struct st_h
>  
>  	if (ccb->cmd->cmnd[0] == MGT_CMD &&
>  		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
> -		scsi_bufflen(ccb->cmd) =
> -			le32_to_cpu(*(__le32 *)&resp->variable[0]);
> +		scsi_set_resid(ccb->cmd, scsi_bufflen(ccb->cmd) -
> +			le32_to_cpu(*(__le32 *)&resp->variable[0]));
>  		return;
>  	}
>  
> 
> 
> -

Thanks Ed Lin

This looks perfect to me. I was hoping for such a solution.
Thank you for looking into it.

Boaz

