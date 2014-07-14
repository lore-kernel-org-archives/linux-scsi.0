From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/7] drivers: scsi: storvsc: Set srb_flags in all cases
Date: Mon, 14 Jul 2014 08:17:12 +0200
Message-ID: <53C375E8.8090901@suse.de>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
 <1405183712-23967-1-git-send-email-kys@microsoft.com>
 <1405183712-23967-6-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1405183712-23967-6-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com, apw@canonical.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/12/2014 06:48 PM, K. Y. Srinivasan wrote:
> Correctly set SRB flags for all valid I/O directions. Some IHV drivers on=
 the
> Windows host require this. The host validates the command and SRB flags
> prior to passing the command down to native driver stack.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c |   12 +++++-------
>   1 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 3516761..9342ba4 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1599,26 +1599,24 @@ static int storvsc_queuecommand(struct Scsi_Host =
*host, struct scsi_cmnd *scmnd)
>   	vm_srb =3D &cmd_request->vstor_packet.vm_srb;
>   	vm_srb->win8_extension.time_out_value =3D 60;
>
> +	vm_srb->win8_extension.srb_flags |=3D
> +		(SRB_FLAGS_QUEUE_ACTION_ENABLE |
> +		SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
>
>   	/* Build the SRB */
>   	switch (scmnd->sc_data_direction) {
>   	case DMA_TO_DEVICE:
>   		vm_srb->data_in =3D WRITE_TYPE;
>   		vm_srb->win8_extension.srb_flags |=3D SRB_FLAGS_DATA_OUT;
> -		vm_srb->win8_extension.srb_flags |=3D
> -			(SRB_FLAGS_QUEUE_ACTION_ENABLE |
> -			SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
>   		break;
>   	case DMA_FROM_DEVICE:
>   		vm_srb->data_in =3D READ_TYPE;
>   		vm_srb->win8_extension.srb_flags |=3D SRB_FLAGS_DATA_IN;
> -		vm_srb->win8_extension.srb_flags |=3D
> -			(SRB_FLAGS_QUEUE_ACTION_ENABLE |
> -			SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
>   		break;
>   	default:
>   		vm_srb->data_in =3D UNKNOWN_TYPE;
> -		vm_srb->win8_extension.srb_flags =3D 0;
> +		vm_srb->win8_extension.srb_flags |=3D (SRB_FLAGS_DATA_IN |
> +						     SRB_FLAGS_DATA_OUT);
>   		break;
>   	}
>
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
