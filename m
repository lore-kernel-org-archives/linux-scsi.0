From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] scsi_dh: Allow NULL hardware handler name in
 scsi_dh_attach()
Date: Mon, 2 Apr 2012 13:06:09 -0400
Message-ID: <20120402170608.GB28901@redhat.com>
References: <1333385035-6663-1-git-send-email-hare@suse.de>
 <1333385035-6663-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2DBRGR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Apr 2012 13:06:17 -0400
Content-Disposition: inline
In-Reply-To: <1333385035-6663-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Mon, Apr 02 2012 at 12:43pm -0400,
Hannes Reinecke <hare@suse.de> wrote:

> This patch allows to pass in a NULL hardware handler to
> scsi_dh_attach(), causing the reference count of the existing
> hardware handler to be increased.
> An error will be returned if no hardware handler is attached.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 48e46f5..77fa67e 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -475,10 +475,14 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
>  {
>  	unsigned long flags;
>  	struct scsi_device *sdev;
> -	struct scsi_device_handler *scsi_dh;
> +	struct scsi_device_handler *scsi_dh = NULL;
>  	int err = 0;
>  
> -	scsi_dh = get_device_handler(name);
> +	if (name) {
> +		scsi_dh = get_device_handler(name);
> +	} else if (sdev->scsi_dh_data) {
> +		scsi_dh = sdev->scsi_dh_data->scsi_dh;
> +	}

Extra brackets aren't needed.  But otherwise:

Acked-by: Mike Snitzer <snitzer@redhat.com>
