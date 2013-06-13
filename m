From: Asias He <asias@redhat.com>
Subject: Re: [PATCH 5/9] virtio-scsi: Implement TMF timeout
Date: Thu, 13 Jun 2013 09:58:20 +0800
Message-ID: <20130613015820.GA29758@hj.localdomain>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
 <1370850058-27613-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab3FMB70 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jun 2013 21:59:26 -0400
Content-Disposition: inline
In-Reply-To: <1370850058-27613-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>

On Mon, Jun 10, 2013 at 09:40:54AM +0200, Hannes Reinecke wrote:
> Any TMF might be take longer as expected, or not return at all.
> So we need to use 'wait_for_completion_timeout' when sending
> a TMF to protect against these cases.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Asias He <asias@redhat.com>

> ---
>  drivers/scsi/virtio_scsi.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 1efd219..abfc684 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -30,6 +30,7 @@
>  #define VIRTIO_SCSI_MEMPOOL_SZ 64
>  #define VIRTIO_SCSI_EVENT_LEN 8
>  #define VIRTIO_SCSI_VQ_BASE 2
> +#define VIRTIO_SCSI_TMF_TIMEOUT 30
>  
>  /* Command queue element */
>  struct virtio_scsi_cmd {
> @@ -597,8 +598,10 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
>  			      GFP_NOIO) < 0)
>  		goto out;
>  
> -	wait_for_completion(&comp);
> -	if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
> +	if (wait_for_completion_timeout(&comp,
> +					VIRTIO_SCSI_TMF_TIMEOUT * HZ) == 0)
> +		ret = FAILED;
> +	else if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
>  	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
>  		ret = SUCCESS;
>  
> -- 
> 1.7.12.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Asias
