From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: mq queue stall during command requeue
Date: Thu, 19 Jan 2017 16:11:56 +0000
Message-ID: <1484842302.2634.3.camel@sandisk.com>
References: <1484835465-66514-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0045.outbound.protection.outlook.com ([104.47.32.45]:61056
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753163AbdASQME (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Jan 2017 11:12:04 -0500
In-Reply-To: <1484835465-66514-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <602EBAAA74C1DB46AE130870A57ED452@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>, "hare@suse.com" <hare@suse.com>

On Thu, 2017-01-19 at 15:17 +0100, Hannes Reinecke wrote:
> When we're hitting a busy condition in queuecommand() we need to
> stop the hardware queue before calling blk_mq_delay_queue(); if
> we don't blk_mq_delay_queue() will not do anything and requeue
> will never triggered.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_lib.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e9e1e14..4b1cbc6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1951,8 +1951,10 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hct=
x,
>  	switch (ret) {
>  	case BLK_MQ_RQ_QUEUE_BUSY:
>  		if (atomic_read(&sdev->device_busy) =3D=3D 0 &&
> -		    !scsi_device_blocked(sdev))
> +		    !scsi_device_blocked(sdev)) {
> +			blk_mq_stop_hw_queue(hctx);
>  			blk_mq_delay_queue(hctx, SCSI_QUEUE_DELAY);
> +		}
>  		break;
>  	case BLK_MQ_RQ_QUEUE_ERROR:
>  		/*

You may want to add Fixes:=A052d7f1b5c2f3 (blk-mq: Avoid that requeueing
starts stopped queues). See also
https://www.spinics.net/lists/linux-block/msg06144.html.

Bart.=
