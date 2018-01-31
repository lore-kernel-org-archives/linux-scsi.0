From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 1/1] scsi: ufs: make sure all interrupts are processed
Date: Wed, 31 Jan 2018 07:39:06 +0000
Message-ID: <DM5PR04MB1085C5039CA525D6FB77DBE3FCFB0@DM5PR04MB1085.namprd04.prod.outlook.com>
References: <1517288066-13171-1-git-send-email-asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1517288066-13171-1-git-send-email-asutoshd@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,
Can you elaborate how this can even happen?
Isn't the interrupt aggregation capability should attend for those cases?

Thanks,
Avri

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Asutosh Das
> Sent: Tuesday, January 30, 2018 6:54 AM
> To: subhashj@codeaurora.org; cang@codeaurora.org;
> vivek.gautam@codeaurora.org; rnayak@codeaurora.org;
> vinholikatti@gmail.com; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; Venkat Gopalakrishnan
> <venkatg@codeaurora.org>; Asutosh Das <asutoshd@codeaurora.org>; open
> list <linux-kernel@vger.kernel.org>
> Subject: [PATCH 1/1] scsi: ufs: make sure all interrupts are processed
>=20
> From: Venkat Gopalakrishnan <venkatg@codeaurora.org>
>=20
> As multiple requests are submitted to the ufs host controller in parallel=
 there
> could be instances where the command completion interrupt arrives later f=
or a
> request that is already processed earlier as the corresponding doorbell w=
as
> cleared when handling the previous interrupt. Read the interrupt status i=
n a
> loop after processing the received interrupt to catch such interrupts and=
 handle
> it.
>=20
> Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 8af2af3..58d81de 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5357,19 +5357,30 @@ static irqreturn_t ufshcd_intr(int irq, void *__h=
ba)
>  	u32 intr_status, enabled_intr_status;
>  	irqreturn_t retval =3D IRQ_NONE;
>  	struct ufs_hba *hba =3D __hba;
> +	int retries =3D hba->nutrs;
>=20
>  	spin_lock(hba->host->host_lock);
>  	intr_status =3D ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> -	enabled_intr_status =3D
> -		intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
>=20
> -	if (intr_status)
> -		ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
> +	/*
> +	 * There could be max of hba->nutrs reqs in flight and in worst case
> +	 * if the reqs get finished 1 by 1 after the interrupt status is
> +	 * read, make sure we handle them by checking the interrupt status
> +	 * again in a loop until we process all of the reqs before returning.
> +	 */
> +	do {
> +		enabled_intr_status =3D
> +			intr_status & ufshcd_readl(hba,
> REG_INTERRUPT_ENABLE);
> +		if (intr_status)
> +			ufshcd_writel(hba, intr_status,
> REG_INTERRUPT_STATUS);
> +		if (enabled_intr_status) {
> +			ufshcd_sl_intr(hba, enabled_intr_status);
> +			retval =3D IRQ_HANDLED;
> +		}
> +
> +		intr_status =3D ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> +	} while (intr_status && --retries);
>=20
> -	if (enabled_intr_status) {
> -		ufshcd_sl_intr(hba, enabled_intr_status);
> -		retval =3D IRQ_HANDLED;
> -	}
>  	spin_unlock(hba->host->host_lock);
>  	return retval;
>  }
> --
> Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center,
> Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linu=
x
> Foundation Collaborative Project.
