From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC 4/9] zfcp: decouple FSF request setup of TMF from scsi_cmnd
Date: Wed, 26 Jul 2017 07:55:21 +0200
Message-ID: <62db9fd0-66e9-4468-0a71-3f894ea274ad@suse.de>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
 <20170725141427.35258-5-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50188 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750813AbdGZFzY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jul 2017 01:55:24 -0400
In-Reply-To: <20170725141427.35258-5-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

On 07/25/2017 04:14 PM, Steffen Maier wrote:
> The scsi_device argument of zfcp_fc_fcp_tm() can now be NULL.
> 
> In zfcp_fsf_fcp_task_mgmt() resolve the still old argument scsi_cmnd
> into scsi_device very early and only depend on scsi_device and derived
> objects in the function body.
> 
> Scsi_device and derived zfcp_scsi_dev can later be NULL for the
> target reset case, so do not depend on them unconditionally.
> For the generic case, rather change to using zfcp_port directly.
> 
> This prepares to later change the function signature replacing the
> scsi_cmnd argument with zfcp_port and an
> optional scsi_device which can be NULL.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_fc.h  |  6 ++++--
>  drivers/s390/scsi/zfcp_fsf.c | 25 +++++++++++++++++--------
>  2 files changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
> index 24949868d027..0e5b01c33873 100644
> --- a/drivers/s390/scsi/zfcp_fc.h
> +++ b/drivers/s390/scsi/zfcp_fc.h
> @@ -235,13 +235,15 @@ void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi)
>  /**
>   * zfcp_fc_fcp_tm() - Setup FCP command as task management command.
>   * @fcp: Pointer to FCP_CMND IU to set up.
> - * @dev: Pointer to SCSI_device where to send the task management command.
> + * @dev: Pointer to SCSI device if LUN Reset TMF, or %NULL.
>   * @tm_flags: Task management flags to setup tm command.
>   */
>  static inline
>  void zfcp_fc_fcp_tm(struct fcp_cmnd *fcp, struct scsi_device *dev, u8 tm_flags)
>  {
> -	int_to_scsilun(dev->lun, (struct scsi_lun *) &fcp->fc_lun);
> +	if (dev)
> +		int_to_scsilun(dev->lun, (struct scsi_lun *) &fcp->fc_lun);
> +
>  	fcp->fc_tm_flags = tm_flags;
>  }
>  
Hmm. This function is becoming so small, _and_ with a conditional to
boot. Maybe you should simply open-coding it?

> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index f221a34c26df..2dc7d2a6f6ea 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
> @@ -2339,13 +2339,19 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
>  {
>  	struct zfcp_fsf_req *req = NULL;
>  	struct fcp_cmnd *fcp_cmnd;
> -	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scmnd->device);
> -	struct zfcp_qdio *qdio = zfcp_sdev->port->adapter->qdio;
> +	struct scsi_device *sdev = scmnd->device;
> +	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
> +	struct zfcp_port *port = zfcp_sdev->port;
> +	struct zfcp_qdio *qdio = port->adapter->qdio;
>  
> -	if (unlikely(!(atomic_read(&zfcp_sdev->status) &
> +	if (unlikely(!(atomic_read(&port->status) &
>  		       ZFCP_STATUS_COMMON_UNBLOCKED)))
>  		return NULL;
>  
> +	if (unlikely(zfcp_sdev && !(atomic_read(&zfcp_sdev->status) &
> +				    ZFCP_STATUS_COMMON_UNBLOCKED)))
> +		return NULL;
> +
>  	spin_lock_irq(&qdio->req_q_lock);
>  	if (zfcp_qdio_sbal_get(qdio))
>  		goto out;
> @@ -2360,18 +2366,21 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
>  	}
>  
>  	fcp_cmnd = &req->qtcb->bottom.io.fcp_cmnd.iu;
> -	req->data = (fcp_cmnd->fc_tm_flags & FCP_TMF_LUN_RESET) ?
> -		scmnd->device : (void *)sdev_to_zfcp(scmnd->device)->port;
> +	if (fcp_cmnd->fc_tm_flags & FCP_TMF_LUN_RESET) {
> +		req->data = sdev;
> +		req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
> +	} else
> +		req->data = port;
> +
>  	req->handler = zfcp_fsf_fcp_task_mgmt_handler;
> -	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
> -	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
> +	req->qtcb->header.port_handle = port->handle;
>  	req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
>  	req->qtcb->bottom.io.service_class = FSF_CLASS_3;
>  	req->qtcb->bottom.io.fcp_cmnd_length = FCP_CMND_LEN;
>  
>  	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
>  
> -	zfcp_fc_fcp_tm(fcp_cmnd, scmnd->device, tm_flags);
> +	zfcp_fc_fcp_tm(fcp_cmnd, sdev, tm_flags);
>  
>  	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
>  	if (!zfcp_fsf_req_send(req))
> 
Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
