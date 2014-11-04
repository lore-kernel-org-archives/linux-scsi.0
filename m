From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 10/11] scsi: don't force tagged_supported in drivers
Date: Tue, 4 Nov 2014 09:16:30 +0100
Message-ID: <CAD+HZHUu_yw7x2GxHdnnGCktneihSX+C-8=yHVa1A3E7BGp10A@mail.gmail.com>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
	<1415087656-9491-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:46335 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaKDIQa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 03:16:30 -0500
Received: by mail-ig0-f173.google.com with SMTP id r10so6258266igi.12
        for <linux-scsi@vger.kernel.org>; Tue, 04 Nov 2014 00:16:30 -0800 (PST)
In-Reply-To: <1415087656-9491-11-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

2014-11-04 8:54 GMT+01:00 Christoph Hellwig <hch@lst.de>:
> Now that we also get proper values in cmd->request->tag for untagged
> commands, there is no need to force tagged_supported to on in drivers
> that need host-wide tags.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/fnic/fnic_main.c       |  2 --
>  drivers/scsi/libsas/sas_scsi_host.c |  1 -

> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index 56d698a..89e8b68 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -945,7 +945,6 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
>                 SAS_DPRINTK("device %llx, LUN %llx doesn't support "
>                             "TCQ\n", SAS_ADDR(dev->sas_addr),
>                             scsi_dev->lun);
> -               scsi_dev->tagged_supported = 0;
>                 scsi_adjust_queue_depth(scsi_dev, 1);
>         }
Hi Christoph,

The commit msg doesn't match for above, is it intentional ?

Regards,
Jack
