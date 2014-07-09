From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/14] fnic: reject device resets without assigned tags
 for the blk-mq case
Date: Wed, 09 Jul 2014 13:27:32 +0200
Message-ID: <53BD2724.5060803@suse.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-15-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403715121-1201-15-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>
List-Id: linux-scsi@vger.kernel.org

On 06/25/2014 06:52 PM, Christoph Hellwig wrote:
> Current the midlayer fakes up a struct request for the explicit reset
> ioctls, and those don't have a tag allocated to them.  The fnic drive=
r pokes
> into midlayer structures to paper over this design issue, but that wo=
n't
> work for the blk-mq case.
>
> Either someone who can actually test the hardware will have to come u=
p with
> a similar hack for the blk-mq case, or we'll have to bite the bullet =
and fix
> the way the EH ioctls work for real, but until that happens we fail t=
hese
> explicit requests here.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Cc: Hiral Patel <hiralpat@cisco.com>
> Cc: Suma Ramars <sramars@cisco.com>
> Cc: Brian Uchino <buchino@cisco.com>
> ---
>   drivers/scsi/fnic/fnic_scsi.c |   16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_s=
csi.c
> index 3f88f56..961bdf5 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -2224,6 +2224,22 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>
>   	tag =3D sc->request->tag;
>   	if (unlikely(tag < 0)) {
> +		/*
> +		 * XXX(hch): current the midlayer fakes up a struct
> +		 * request for the explicit reset ioctls, and those
> +		 * don't have a tag allocated to them.  The below
> +		 * code pokes into midlayer structures to paper over
> +		 * this design issue, but that won't work for blk-mq.
> +		 *
> +		 * Either someone who can actually test the hardware
> +		 * will have to come up with a similar hack for the
> +		 * blk-mq case, or we'll have to bite the bullet and
> +		 * fix the way the EH ioctls work for real, but until
> +		 * that happens we fail these explicit requests here.
> +		 */
> +		if (shost_use_blk_mq(sc->device->host))
> +			goto fnic_device_reset_end;
> +
>   		tag =3D fnic_scsi_host_start_tag(fnic, sc);
>   		if (unlikely(tag =3D=3D SCSI_NO_TAG))
>   			goto fnic_device_reset_end;
>
The correct fix will be part of my EH redesign.
Plan is to allocate a real command/request for EH, which then can be=20
used to send down EH TMFs and related commands.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
