From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 13/22] qla2xxx: Fix PRLI state check
Date: Thu, 30 Nov 2017 17:02:56 +0100
Message-ID: <3effe07e-d107-bbcc-6df9-d151e3baf985@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-14-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753296AbdK3QC6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 11:02:58 -0500
In-Reply-To: <20171130034047.15070-14-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Get Port Database MBX cmd is to validate current Login state upon
> PRLI completion. Current code looks at the last login state for
> re-validation which was incorrect. This patch removed incorrect
> state check.
> 
> Fixes: 15f30a5752287 ("qla2xxx: Use IOCB interface to submit non-critical MBX.")
> Cc: <stable@vger.kernel.org> # 4.10+
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index cb717d47339f..e2b5fa47bb57 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -6160,8 +6160,7 @@ int __qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
>  	}
>  
>  	/* Check for logged in state. */
> -	if (current_login_state != PDS_PRLI_COMPLETE &&
> -	    last_login_state != PDS_PRLI_COMPLETE) {
> +	if (current_login_state != PDS_PRLI_COMPLETE) {
>  		ql_dbg(ql_dbg_mbx, vha, 0x119a,
>  		    "Unable to verify login-state (%x/%x) for loop_id %x.\n",
>  		    current_login_state, last_login_state, fcport->loop_id);
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
