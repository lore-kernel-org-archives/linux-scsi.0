From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH v2 2/3] scsi: ufs: Allow resetting the UFS device
Date: Thu, 6 Jun 2019 06:36:22 +0000
Message-ID: <SN6PR04MB4925FC3F1001326AA218DF21FC170@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20190606010249.3538-1-bjorn.andersson@linaro.org>
 <20190606010249.3538-3-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606010249.3538-3-bjorn.andersson@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Evan Green <evgreen@chromium.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


>  static int ufshcd_hba_init(struct ufs_hba *hba)
>  {
>  	int err;
> @@ -7425,9 +7460,15 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
>  	if (err)
>  		goto out_disable_vreg;
>=20
> +	err =3D ufshcd_init_device_reset(hba);
> +	if (err)
> +		goto out_disable_variant;
> +
>  	hba->is_powered =3D true;
>  	goto out;
>=20
> +out_disable_variant:
> +	ufshcd_vops_setup_regulators(hba, false);
Is this necessary?
ufshcd_vops_setup_regulators() was just called as part of ufshcd_variant_hb=
a_init

Thanks,
Avri
