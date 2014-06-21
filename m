From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 10/14] scsi: only maintain target_blocked if the driver
 has a target queue limit
Date: Sat, 21 Jun 2014 22:10:14 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B42223@G9W0745.americas.hpqcorp.net>
References: <1402580946-11470-1-git-send-email-hch@lst.de>
 <1402580946-11470-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1402580946-11470-11-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Thursday, 12 June, 2014 8:49 AM
> To: James Bottomley
> Cc: Jens Axboe; Bart Van Assche; Elliott, Robert (Server Storage); linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 10/14] scsi: only maintain target_blocked if the driver has a
> target queue limit
> 
> This saves us an atomic operation for each I/O submission and completion
> for the usual case where the driver doesn't set a per-target can_queue
> value.  Only a few iscsi hardware offload drivers set the per-target
> can_queue value at the moment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_lib.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0e33dee..763b3c9 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
...

> @@ -1642,7 +1648,8 @@ static void scsi_request_fn(struct request_queue *q)
>  	return;
> 
>   host_not_ready:
> -	atomic_dec(&scsi_target(sdev)->target_busy);
> +	if (&scsi_target(sdev)->can_queue > 0)
> +		atomic_dec(&scsi_target(sdev)->target_busy);
>   not_ready:
>  	/*
>  	 * lock q, handle tag, requeue req, and decrement device_busy. We

There's an extra & in that if statement.

---
Rob Elliott    HP Server Storage
