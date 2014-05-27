From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] Make SCSI error handler code easier to understand
Date: Tue, 27 May 2014 07:42:15 +0200
Message-ID: <538425B7.8030405@suse.de>
References: <538359DB.9080601@acm.org> <53835A9D.3090104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbaE0FmR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2014 01:42:17 -0400
In-Reply-To: <53835A9D.3090104@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Joe Lawrence <jdl1291@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/26/2014 05:15 PM, Bart Van Assche wrote:
> Every now and then someone asks how it is avoided that the SCSI error
> handler and the SCSI completion handler are invoked concurrently for
> the same SCSI command. Add a few WARN_ON_ONCE() statements that make
> it clear how this is avoided.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Joe Lawrence <joe.lawrence@stratus.com>
> ---
>   drivers/scsi/scsi_error.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 5232583..aee0dc0 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -120,6 +120,8 @@ scmd_eh_abort_handler(struct work_struct *work)
>   	struct scsi_device *sdev =3D scmd->device;
>   	int rtn;
>
> +	WARN_ON_ONCE(!blk_rq_completed(scmd->request));
> +
>   	if (scsi_host_eh_past_deadline(sdev->host)) {
>   		SCSI_LOG_ERROR_RECOVERY(3,
>   			scmd_printk(KERN_INFO, scmd,
> @@ -185,6 +187,8 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>   	struct Scsi_Host *shost =3D sdev->host;
>   	unsigned long flags;
>
> +	WARN_ON_ONCE(!blk_rq_completed(scmd->request));
> +
>   	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
>   		/*
>   		 * Retry after abort failed, escalate to next level.
> @@ -237,6 +241,8 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int =
eh_flag)
>   	unsigned long flags;
>   	int ret =3D 0;
>
> +	WARN_ON_ONCE(!blk_rq_completed(scmd->request));
> +
>   	if (!shost->ehandler)
>   		return 0;
>
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
