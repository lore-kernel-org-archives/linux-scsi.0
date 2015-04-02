From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 05/42] hpsa: decrement h->commands_outstanding in fail_all_outstanding_cmds
Date: Thu, 02 Apr 2015 15:33:48 +0200
Message-ID: <551D453C.1030205@redhat.com>
References: <20150317200139.19856.87982.stgit@brunhilda> <20150317200252.19856.96524.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbbDBNeS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2015 09:34:18 -0400
In-Reply-To: <20150317200252.19856.96524.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 03/17/2015 09:02 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>
> make tracking of outstanding commands more robust
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index fe860a6..3a06812 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6945,7 +6945,7 @@ static void fail_all_outstanding_cmds(struct ctlr_info *h)
>  		if (refcount > 1) {
>  			c->err_info->CommandStatus = CMD_CTLR_LOCKUP;
>  			finish_cmd(c);
> -			failcount++;

The failcount should stay untouched.

What is the status of this series is it already accepted or makes reviewing still sense?
Christopher has commented on 2/41 + 6/41 in the previous V2, has this been answered/resolved?

Thanks,
Tomas


> +			atomic_dec(&h->commands_outstanding);
>  		}
>  		cmd_free(h, c);
>  	}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

