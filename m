From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 1/2] scsi_error: set DID_TIME_OUT correctly
Date: Fri, 13 Jun 2014 10:32:14 -0400
Message-ID: <1402669934.3820.117.camel@localhost.localdomain>
References: <1402660906-74661-1-git-send-email-hare@suse.de>
	 <1402660906-74661-2-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbaFMOcn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 10:32:43 -0400
In-Reply-To: <1402660906-74661-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Bart vn Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

On Fri, 2014-06-13 at 14:01 +0200, Hannes Reinecke wrote:
> Any callbacks in scsi_timeout_out() might return BLK_EH_RESET_TIMER,
> in which case we should leave the result alone and not set
> DID_TIME_OUT, as the command didn't actually timeout.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 47a1ffc..ff176a6 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -291,11 +291,11 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
>  		if (scsi_abort_command(scmd) == SUCCESS)
>  			return BLK_EH_NOT_HANDLED;
>  
> -	scmd->result |= DID_TIME_OUT << 16;
> -
> -	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
> -		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)))
> -		rtn = BLK_EH_HANDLED;
> +	if (unlikely(rtn == BLK_EH_NOT_HANDLED)) {
> +		scmd->result |= DID_TIME_OUT << 16;
> +		if (!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))
> +			rtn = BLK_EH_HANDLED;
> +	}
>  
>  	return rtn;
>  }

See Paolo's patch series which includes:

[PATCH v3 4/6] scsi_error: fix invalid setting of host byte

I think your patch won't apply after his.

-Ewan


