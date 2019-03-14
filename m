From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH] scsi: ufs: fix a missing check of devm_reset_control_get
Date: Thu, 14 Mar 2019 09:15:10 +0000
Message-ID: <SN6PR04MB4925DB2652FAED5F3AED27CCFC4B0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20190314063749.13907-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190314063749.13907-1-kjlu@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: "pakki001@umn.edu" <pakki001@umn.edu>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,
>=20
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Acked-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufs-hisi.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
> index 452e19f8fb47..ce9d7c40909f 100644
> --- a/drivers/scsi/ufs/ufs-hisi.c
> +++ b/drivers/scsi/ufs/ufs-hisi.c
> @@ -544,6 +544,11 @@ static int ufs_hisi_init_common(struct ufs_hba *hba)
>  	ufshcd_set_variant(hba, host);
>=20
>  	host->rst  =3D devm_reset_control_get(dev, "rst");
> +	if (IS_ERR(host->rst)) {
> +		dev_err(dev, "%s: failed to get reset control\n",
> +			__func__);
Use full line please

> +		return PTR_ERR(host->rst);
> +	}
>=20
>  	ufs_hisi_set_pm_lvl(hba);
>=20
> --
> 2.17.1
