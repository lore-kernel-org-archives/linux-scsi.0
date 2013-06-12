From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/9] virtio-scsi: Implement TMF timeout
Date: Wed, 12 Jun 2013 10:54:53 -0400
Message-ID: <51B88BBD.5050002@redhat.com>
References: <1370850058-27613-1-git-send-email-hare@suse.de> <1370850058-27613-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:37760 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3FLOy4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jun 2013 10:54:56 -0400
Received: by mail-qa0-f45.google.com with SMTP id ci6so380243qab.18
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2013 07:54:55 -0700 (PDT)
In-Reply-To: <1370850058-27613-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

Il 10/06/2013 03:40, Hannes Reinecke ha scritto:
> Any TMF might be take longer as expected, or not return at all.
> So we need to use 'wait_for_completion_timeout' when sending
> a TMF to protect against these cases.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
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
> 


Acked-by: Paolo Bonzini <pbonzini@redhat.com>


