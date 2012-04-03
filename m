From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [dm-devel] [PATCH 1/2] scsi_dh: Allow NULL hardware handler name
 in scsi_dh_attach()
Date: Tue, 03 Apr 2012 10:46:02 +0900
Message-ID: <4F7A565A.7060201@ce.jp.nec.com>
References: <1333385035-6663-1-git-send-email-hare@suse.de> <1333385035-6663-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:35239 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2DCBrP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2012 21:47:15 -0400
In-Reply-To: <1333385035-6663-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>

Hi Hannes,

On 04/03/12 01:43, Hannes Reinecke wrote:
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
>  	if (!scsi_dh)
>  		return -EINVAL;

It won't work. sdev is not initialized...

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
