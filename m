From: Laurence Oberman <loberman@redhat.com>
Subject: Re: scsi: qla2xxx: Fix apparent cut-n-paste error.
Date: Wed, 28 Dec 2016 12:00:46 -0500 (EST)
Message-ID: <1874130276.10065793.1482944446039.JavaMail.zimbra@redhat.com>
References: <20161227181321.35xf5hm4qz3uajmp@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:53794 "EHLO
        mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbcL1RA4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Dec 2016 12:00:56 -0500
In-Reply-To: <20161227181321.35xf5hm4qz3uajmp@codemonkey.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@codemonkey.org.uk>
Cc: linux-scsi@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>



----- Original Message -----
> From: "Dave Jones" <davej@codemonkey.org.uk>
> To: linux-scsi@vger.kernel.org
> Cc: "Quinn Tran" <quinn.tran@cavium.com>
> Sent: Tuesday, December 27, 2016 1:13:21 PM
> Subject: scsi: qla2xxx: Fix apparent cut-n-paste error.
> 
> commit 093df73771bac8a37d607c0e705d157a8cef4c5c introduces two bodies of
> code that look similar but with s/req/rsp/ in the second instance.
> But in one case, it looks like this conversion was missed.
> 
> Signed-off-by: Dave Jones <davej@codemonkey.org.uk>
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 8521cfe302e9..ad4edc13ebcf 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -466,7 +466,7 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
>  			continue;
>  
>  		rsp = ha->rsp_q_map[cnt];
> -		clear_bit(cnt, ha->req_qid_map);
> +		clear_bit(cnt, ha->rsp_qid_map);
>  		ha->rsp_q_map[cnt] =  NULL;
>  		spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  		qla2x00_free_rsp_que(ha, rsp);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Dave

This had me going for a while but I figured out what you were pointing out.
Your change seems correct to me.

Reviewed-by: Laurence Oberman <loberman@redhat.com>
