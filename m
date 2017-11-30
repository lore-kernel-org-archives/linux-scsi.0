From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 15/22] qla2xxx: Replace fcport alloc with
 qla2x00_alloc_fcport
Date: Thu, 30 Nov 2017 17:19:39 +0100
Message-ID: <09dd4d0e-1712-1243-ef8b-bf2b3d89c146@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-16-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57525 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752177AbdK3QTl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 11:19:41 -0500
In-Reply-To: <20171130034047.15070-16-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Current code manually allocate an fcport structure that
> is not properly initialize. Replace kzalloc with
> qla2x00_alloc_fcport, so that all fields are initialized.
> Also set set scan flag to port found
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index e824cdc77139..2a6242d97a7e 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -5783,7 +5783,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
>  	unsigned long flags;
>  	u8 newfcport = 0;
>  
> -	fcport = kzalloc(sizeof(*fcport), GFP_KERNEL);
> +	fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
>  	if (!fcport) {
>  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf06f,
>  		    "qla_target(%d): Allocation of tmp FC port failed",
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
