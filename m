From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_sysfs: Fix queue_ramp_up_period return code
Date: Tue, 27 Oct 2015 07:57:52 +0100
Message-ID: <562F2070.70200@suse.de>
References: <562E3E9F.50600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <562E3E9F.50600@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/26/2015 03:54 PM, Peter Oberparleiter wrote:
> Writing a number to /sys/bus/scsi/devices/<sdev>/queue_ramp_up_period
> returns the value of that number instead of the number of bytes writt=
en.
> This behavior can confuse programs expecting POSIX write() semantics.
> Fix this by returning the number of bytes written instead.
>=20
> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index b333389..6b0f292 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -898,7 +898,7 @@ sdev_store_queue_ramp_up_period(struct device *de=
v,
>  		return -EINVAL;
>=20
>  	sdev->queue_ramp_up_period =3D msecs_to_jiffies(period);
> -	return period;
> +	return count;
>  }
>=20
>  static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
