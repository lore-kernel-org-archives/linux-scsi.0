From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC 7/9] zfcp: use fc_block_rport for TMFs and host reset to
 decouple from scsi_cmnd
Date: Wed, 26 Jul 2017 08:14:49 +0200
Message-ID: <04cc8ef5-957e-456a-a63c-90fec989497f@suse.de>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
 <20170725141427.35258-8-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750710AbdGZGOv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jul 2017 02:14:51 -0400
In-Reply-To: <20170725141427.35258-8-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

On 07/25/2017 04:14 PM, Steffen Maier wrote:
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_scsi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 05c823ccb959..8e96196fa877 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -287,7 +287,7 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
>  			break;
>  
>  		zfcp_erp_wait(adapter);
> -		ret = fc_block_scsi_eh(scpnt);
> +		ret = port->rport ? fc_block_rport(port->rport) : 0;
>  		if (ret) {
>  			zfcp_dbf_scsi_devreset("fiof", adapter, tm_flags, NULL,
>  					       scsi_id, scsi_lun);> @@ -337,11 +337,13 @@ static int
zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>  {
>  	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
>  	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
> +	struct zfcp_port *port;
>  	int ret;
>  
>  	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>  	zfcp_erp_wait(adapter);
> -	ret = fc_block_scsi_eh(scpnt);
> +	port = zfcp_sdev->port;
> +	ret = port->rport ? fc_block_rport(port->rport) : 0;
>  	if (ret)
>  		return ret;
>  
> 

Hmm. So there is a chance where ->rport is simply NULL, in which case we
won't be calling fc_block_rport().
However, we _do_ continue with TMF even then.
Wasn't that precisely the point of fc_block_rport() to figure out if the
rport is valid?
So shouldn't we rather return FAILED or something here?
If not, why do we continue sending TMFs to a non-existing port?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
