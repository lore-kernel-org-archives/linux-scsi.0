From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH v1] scsi: ufs: Avoid runtime suspend possibly being
 blocked forever
Date: Wed, 12 Jun 2019 11:10:49 +0000
Message-ID: <SN6PR04MB492546256F8F8635E7EE60C2FCEC0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1560325326-1598-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1560325326-1598-1-git-send-email-stanley.chu@mediatek.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Stanley Chu <stanley.chu@mediatek.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>
Cc: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "beanhuo@micron.com" <beanhuo@micron.com>, "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, "ygardi@codeaurora.org" <ygardi@codeaurora.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>, "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>, "andy.teng@mediatek.com" <andy.teng@mediatek.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

>=20
> UFS runtime suspend can be triggered after pm_runtime_enable()
> is invoked in ufshcd_pltfrm_init(). However if the first runtime
> suspend is triggered before binding ufs_hba structure to ufs
> device structure via platform_set_drvdata(), then UFS runtime
> suspend will be no longer triggered in the future because its
> dev->power.runtime_error was set in the first triggering and does
> not have any chance to be cleared.
>=20
> To be more clear, dev->power.runtime_error is set if hba is NULL
> in ufshcd_runtime_suspend() which returns -EINVAL to rpm_callback()
> where dev->power.runtime_error is set as -EINVAL. In this case, any
> future rpm_suspend() for UFS device fails because
> rpm_check_suspend_allowed() fails due to non-zero
> dev->power.runtime_error.
>=20
> To resolve this issue, make sure the first UFS runtime suspend
> get valid "hba" in ufshcd_runtime_suspend(): Enable UFS runtime PM
> only after hba is successfully bound to UFS device structure.
>=20
> Fixes: e3ce73d (scsi: ufs: fix bugs related to null pointer access and ar=
ray size)
This code was inserted before platform_set_drvdata  in
6269473 [SCSI] ufs: Add runtime PM support for UFS host controller driver.
Why do you point to e3ce73d?

Thanks,
Avri

> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-p=
ltfrm.c
> index 8a74ec30c3d2..d7d521b394c3 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -430,24 +430,21 @@ int ufshcd_pltfrm_init(struct platform_device
> *pdev,
>  		goto dealloc_host;
>  	}
>=20
> -	pm_runtime_set_active(&pdev->dev);
> -	pm_runtime_enable(&pdev->dev);
> -
>  	ufshcd_init_lanes_per_dir(hba);
>=20
>  	err =3D ufshcd_init(hba, mmio_base, irq);
>  	if (err) {
>  		dev_err(dev, "Initialization failed\n");
> -		goto out_disable_rpm;
> +		goto dealloc_host;
>  	}
>=20
>  	platform_set_drvdata(pdev, hba);
>=20
> +	pm_runtime_set_active(&pdev->dev);
> +	pm_runtime_enable(&pdev->dev);
> +
>  	return 0;
>=20
> -out_disable_rpm:
> -	pm_runtime_disable(&pdev->dev);
> -	pm_runtime_set_suspended(&pdev->dev);
>  dealloc_host:
>  	ufshcd_dealloc_host(hba);
>  out:
> --
> 2.18.0
