From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 12/22] qla2xxx: Clear send ELS LOGO flag after target
 re-login
Date: Thu, 30 Nov 2017 17:00:56 +0100
Message-ID: <40460403-7a2d-4a1f-7e7b-cd6e270a4fa1@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-13-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752369AbdK3QA6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 11:00:58 -0500
In-Reply-To: <20171130034047.15070-13-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> This patch fixes clearing out els_send_logo flag at the
> time of session deletion.
> 
> Fixes: 3515832cc614 ("scsi: qla2xxx: Reset the logo flag, after target re-login.")
> Cc: <stable@vger.kernel.org> # 4.10+
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 283ff316e4b2..e824cdc77139 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -983,6 +983,7 @@ static void qlt_free_session_done(struct work_struct *work)
>  			logo.id = sess->d_id;
>  			logo.cmd_count = 0;
>  			qlt_send_first_logo(vha, &logo);
> +			sess->send_els_logo = 0;
>  		}
>  
>  		if (sess->logout_on_delete) {
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
