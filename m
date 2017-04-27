From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] libfc: do not flood console with messages 'libfc: queue
 full ...'
Date: Thu, 27 Apr 2017 16:07:29 +0000
Message-ID: <1493309247.2625.4.camel@sandisk.com>
References: <1493303103-113774-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:32234 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754823AbdD0QHe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2017 12:07:34 -0400
In-Reply-To: <1493303103-113774-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <2FBA3273D6DFFB44963F97006C73B4AE@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On Thu, 2017-04-27 at 16:25 +0200, Hannes Reinecke wrote:
> @@ -1896,11 +1899,11 @@ int fc_queuecommand(struct Scsi_Host *shost, stru=
ct scsi_cmnd *sc_cmd)
> =20
>  	if (!fc_fcp_lport_queue_ready(lport)) {
>  		if (lport->qfull) {
> -			fc_fcp_can_queue_ramp_down(lport);
> -			shost_printk(KERN_ERR, lport->host,
> -				     "libfc: queue full, "
> -				     "reducing can_queue to %d.\n",
> -				     lport->host->can_queue);
> +			if (fc_fcp_can_queue_ramp_down(lport))
> +				shost_printk(KERN_ERR, lport->host,
> +					     "libfc: queue full, "
> +					     "reducing can_queue to %d.\n",
> +					     lport->host->can_queue);
>  		}
>  		rc =3D SCSI_MLQUEUE_HOST_BUSY;
>  		goto out;

Hello Hannes,

Although this would have been a good opportunity to join the log message
that has been split over two lines:

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
