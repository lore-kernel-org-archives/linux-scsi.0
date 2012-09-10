From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH] [SCSI] lpfc 8.3.32: use list_move_tail instead of list_del/list_add_tail
Date: Mon, 10 Sep 2012 13:31:39 -0400
Message-ID: <504E23FB.9080405@emulex.com>
References: <CAPgLHd_fG+Qa0Zds-1pWfzCOPN5LWxQ_MkzjAoqx8eDUyuwOtw@mail.gmail.com>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:14878 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2IJRbl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2012 13:31:41 -0400
In-Reply-To: <CAPgLHd_fG+Qa0Zds-1pWfzCOPN5LWxQ_MkzjAoqx8eDUyuwOtw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: JBottomley@parallels.com, yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

Acked-by: James Smart <james.smart@emulex.com>

Thanks

-- james  s




On 9/5/2012 2:49 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Using list_move_tail() instead of list_del() + list_add_tail().
>
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 9cbd20b..0ada66b 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -15833,8 +15833,7 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
>   			(mb->u.mb.mbxCommand != MBX_REG_VPI))
>   			continue;
>   
> -		list_del(&mb->list);
> -		list_add_tail(&mb->list, &mbox_cmd_list);
> +		list_move_tail(&mb->list, &mbox_cmd_list);
>   	}
>   	/* Clean up active mailbox command with the vport */
>   	mb = phba->sli.mbox_active;
>
>
>

