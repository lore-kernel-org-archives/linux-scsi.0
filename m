From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] beiscsi: the custom_length field has been set to a wrong
 value.
Date: Mon, 7 Jul 2014 15:57:57 +0200
Message-ID: <20140707135757.GA30059@infradead.org>
References: <1403774186-4751-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49748 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaGGNzq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 09:55:46 -0400
Content-Disposition: inline
In-Reply-To: <1403774186-4751-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: jayamohan.kallickal@emulex.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>

On Thu, Jun 26, 2014 at 11:16:26AM +0200, Maurizio Lombardi wrote:
> In the beiscsi_conn_get_stats() function, custom_length should be set
> to 1 to take into account the "eh_abort_cnt" field at custom[0].
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Any chance to get a review on this one?

> ---
>  drivers/scsi/be2iscsi/be_iscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
> index fd284ff..8616281 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -914,7 +914,7 @@ void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
>  	stats->r2t_pdus = conn->r2t_pdus_cnt;
>  	stats->digest_err = 0;
>  	stats->timeout_err = 0;
> -	stats->custom_length = 0;
> +	stats->custom_length = 1;
>  	strcpy(stats->custom[0].desc, "eh_abort_cnt");
>  	stats->custom[0].value = conn->eh_abort_cnt;
>  }
> -- 
> Maurizio Lombardi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
