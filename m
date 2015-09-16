From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND] csiostor:Fix error handling in the function
 csio_device_reset
Date: Wed, 16 Sep 2015 08:49:17 +0200
Message-ID: <55F910ED.7000001@suse.de>
References: <1442355274-22410-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442355274-22410-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, JBottomley@odin.com
Cc: michaelc@cs.wisc.edu, davem@davemloft.net, anish@chelsio.com, martin.petersen@oracle.com, hariprasad@chelsio.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/16/2015 12:14 AM, Nicholas Krause wrote:
> This fixes error handling in the function csio_device_reset to
> check the return value of aftering the function csio_hw_reset
> to check if it returned a error code and if so unlock the irq
> spinlock for the hardware plus return the hardware error code
> immediately.
>=20
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/scsi/csiostor/csio_scsi.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiosto=
r/csio_scsi.c
> index 2c4562d..faea4e7 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -1378,6 +1378,7 @@ csio_device_reset(struct device *dev,
>  {
>  	struct csio_lnode *ln =3D shost_priv(class_to_shost(dev));
>  	struct csio_hw *hw =3D csio_lnode_to_hw(ln);
> +	int ret;
> =20
>  	if (*buf !=3D '1')
>  		return -EINVAL;
> @@ -1389,7 +1390,11 @@ csio_device_reset(struct device *dev,
>  	csio_lnodes_block_request(hw);
> =20
>  	spin_lock_irq(&hw->lock);
> -	csio_hw_reset(hw);
> +	ret =3D csio_hw_reset(hw);
> +	if (ret) {
> +			spin_unlock_irq(&hw->lock);
> +			return ret;
> +	}
>  	spin_unlock_irq(&hw->lock);
> =20
>  	/* Unblock upper IOs */
>=20
No sure if that is correct; wouldn't the device stay blocked
if csio_hw_reset() fails?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
