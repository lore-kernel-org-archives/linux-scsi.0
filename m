From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 05/43] hpsa: decrement h->commands_outstanding in fail_all_outstanding_cmds
Date: Fri, 17 Apr 2015 15:20:24 +0200
Message-ID: <55310898.4020809@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134709.30238.38976.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbbDQNUv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:20:51 -0400
In-Reply-To: <20150416134709.30238.38976.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:47 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>
> make tracking of outstanding commands more robust
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 2ac700b..6ee92af 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6918,6 +6918,7 @@ static void fail_all_outstanding_cmds(struct ctlr_info *h)
>  		if (refcount > 1) {
>  			c->err_info->CommandStatus = CMD_CTLR_LOCKUP;
>  			finish_cmd(c);
> +			atomic_dec(&h->commands_outstanding);
>  			failcount++;
>  		}
>  		cmd_free(h, c);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

