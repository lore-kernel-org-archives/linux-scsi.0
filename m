From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH -next] [SCSI] lpfc 8.3.36: fix potential NULL pointer
 dereference in lpfc_sli4_rq_put()
Date: Thu, 6 Dec 2012 10:46:10 -0500
Message-ID: <50C0BDC2.6070208@emulex.com>
References: <CAPgLHd8VqtYG2cS3627WtxizaNugb9x=85+cZiQEgQc3Fp_kjw@mail.gmail.com>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:6049 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422692Ab2LFPqN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2012 10:46:13 -0500
In-Reply-To: <CAPgLHd8VqtYG2cS3627WtxizaNugb9x=85+cZiQEgQc3Fp_kjw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: JBottomley@parallels.com, yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

Acked-By:   James Smart  <james.smart@emulex.com>

Thanks

-- james s


On 12/2/2012 8:33 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> The dereference to 'put_index' should be moved below the NULL test.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 624eab3..a9a7fd7 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -431,11 +431,12 @@ lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
>   	struct lpfc_rqe *temp_hrqe;
>   	struct lpfc_rqe *temp_drqe;
>   	struct lpfc_register doorbell;
> -	int put_index = hq->host_index;
> +	int put_index;
>   
>   	/* sanity check on queue memory */
>   	if (unlikely(!hq) || unlikely(!dq))
>   		return -ENOMEM;
> +	put_index = hq->host_index;
>   	temp_hrqe = hq->qe[hq->host_index].rqe;
>   	temp_drqe = dq->qe[dq->host_index].rqe;
>   
>
>
>
>

