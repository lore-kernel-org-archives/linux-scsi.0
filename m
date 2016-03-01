From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 04/15] scsi: ufs: verify hba controller hce reg value
Date: Tue, 1 Mar 2016 15:32:59 +0800
Message-ID: <56D545AB.1030606@suse.de>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
 <1456666367-11418-5-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1456666367-11418-5-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
> Sometimes due to hw issues it takes some time to the
> host controller register to update. In order to verify the register
> has updated, a polling is done until its value is set.
>=20
> In addition the functions ufshcd_hba_stop() and
> ufshcd_wait_for_register() was updated with an additional input
> parameter, indicating the timeout between reads will
> be done by sleeping or spinning the cpu.
>=20
> Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/scsi/ufs/ufshcd.c | 53 ++++++++++++++++++++++++++++---------=
----------
>  drivers/scsi/ufs/ufshcd.h | 12 +++--------
>  2 files changed, 35 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3400ceb..80031e6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -240,11 +240,13 @@ static inline void ufshcd_disable_irq(struct uf=
s_hba *hba)
>   * @val - wait condition
>   * @interval_us - polling interval in microsecs
>   * @timeout_ms - timeout in millisecs
> + * @can_sleep - perform sleep or just spin
>   *
>   * Returns -ETIMEDOUT on error, zero on success
>   */
> -static int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u3=
2 mask,
> -		u32 val, unsigned long interval_us, unsigned long timeout_ms)
> +int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
> +				u32 val, unsigned long interval_us,
> +				unsigned long timeout_ms, bool can_sleep)
>  {
>  	int err =3D 0;
>  	unsigned long timeout =3D jiffies + msecs_to_jiffies(timeout_ms);
> @@ -253,9 +255,10 @@ static int ufshcd_wait_for_register(struct ufs_h=
ba *hba, u32 reg, u32 mask,
>  	val =3D val & mask;
> =20
>  	while ((ufshcd_readl(hba, reg) & mask) !=3D val) {
> -		/* wakeup within 50us of expiry */
> -		usleep_range(interval_us, interval_us + 50);
> -
> +		if (can_sleep)
> +			usleep_range(interval_us, interval_us + 50);
> +		else
> +			udelay(interval_us);
>  		if (time_after(jiffies, timeout)) {
>  			if ((ufshcd_readl(hba, reg) & mask) !=3D val)
>  				err =3D -ETIMEDOUT;
> @@ -1459,7 +1462,7 @@ ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
>  	 */
>  	err =3D ufshcd_wait_for_register(hba,
>  			REG_UTP_TRANSFER_REQ_DOOR_BELL,
> -			mask, ~mask, 1000, 1000);
> +			mask, ~mask, 1000, 1000, true);
> =20
>  	return err;
>  }
> @@ -2815,6 +2818,23 @@ out:
>  }
> =20
>  /**
> + * ufshcd_hba_stop - Send controller to reset state
> + * @hba: per adapter instance
> + * @can_sleep: perform sleep or just spin
> + */
> +static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sle=
ep)
> +{
> +	int err;
> +
> +	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
> +	err =3D ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE,
> +					CONTROLLER_ENABLE, CONTROLLER_DISABLE,
> +					10, 1, can_sleep);
> +	if (err)
> +		dev_err(hba->dev, "%s: Controller disable failed\n", __func__);
> +}
> +
Shouldn't you return an error here?
If the controller disable failed you probably need a hard reset or
something, otherwise I would assume that every other command from that
point on will not work as expected.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
