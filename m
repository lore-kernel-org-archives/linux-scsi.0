From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: libfc: fix incorrect variable assingment
Date: Fri, 12 May 2017 08:21:12 -0400
Message-ID: <1494591672.1081.10.camel@localhost.localdomain>
References: <20170511222444.GA6604@embeddedgus>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755430AbdELMVO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 May 2017 08:21:14 -0400
In-Reply-To: <20170511222444.GA6604@embeddedgus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2017-05-11 at 17:24 -0500, Gustavo A. R. Silva wrote:
> Previous assignment was causing the use of the uninitialized variable
> _explan_ inside fc_seq_ls_rjt() function, which in this particular
> case is being called by fc_seq_els_rsp_send().
> 
> Addresses-Coverity-ID: 1398125
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/scsi/libfc/fc_rport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
> index b44c313..5203258 100644
> --- a/drivers/scsi/libfc/fc_rport.c
> +++ b/drivers/scsi/libfc/fc_rport.c
> @@ -1422,7 +1422,7 @@ static void fc_rport_recv_rtv_req(struct fc_rport_priv *rdata,
>  	fp = fc_frame_alloc(lport, sizeof(*rtv));
>  	if (!fp) {
>  		rjt_data.reason = ELS_RJT_UNAB;
> -		rjt_data.reason = ELS_EXPL_INSUF_RES;
> +		rjt_data.explan = ELS_EXPL_INSUF_RES;
>  		fc_seq_els_rsp_send(in_fp, ELS_LS_RJT, &rjt_data);
>  		goto drop;
>  	}

s/assingment/assignment/

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
