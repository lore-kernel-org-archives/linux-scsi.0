From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4/9] virtio_scsi: Enable new EH timeout handler
Date: Wed, 12 Jun 2013 10:54:43 -0400
Message-ID: <51B88BB3.7070900@redhat.com>
References: <1370850058-27613-1-git-send-email-hare@suse.de> <1370850058-27613-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:48937 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab3FLOyu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jun 2013 10:54:50 -0400
Received: by mail-qa0-f42.google.com with SMTP id hu16so381500qab.15
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2013 07:54:49 -0700 (PDT)
In-Reply-To: <1370850058-27613-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

Il 10/06/2013 03:40, Hannes Reinecke ha scritto:
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/virtio_scsi.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 2168258..1efd219 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -654,6 +654,11 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
>  	return virtscsi_tmf(vscsi, cmd);
>  }
>  
> +static enum blk_eh_timer_return virtscsi_timedout(struct scsi_cmnd *scmd)
> +{
> +	return scsi_abort_command(scmd);
> +}
> +
>  static int virtscsi_target_alloc(struct scsi_target *starget)
>  {
>  	struct virtio_scsi_target_state *tgt =
> @@ -683,6 +688,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
>  	.queuecommand = virtscsi_queuecommand_single,
>  	.eh_abort_handler = virtscsi_abort,
>  	.eh_device_reset_handler = virtscsi_device_reset,
> +	.eh_timed_out = virtscsi_timedout,
>  
>  	.can_queue = 1024,
>  	.dma_boundary = UINT_MAX,
> @@ -699,6 +705,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
>  	.queuecommand = virtscsi_queuecommand_multi,
>  	.eh_abort_handler = virtscsi_abort,
>  	.eh_device_reset_handler = virtscsi_device_reset,
> +	.eh_timed_out = virtscsi_timedout,
>  
>  	.can_queue = 1024,
>  	.dma_boundary = UINT_MAX,
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
