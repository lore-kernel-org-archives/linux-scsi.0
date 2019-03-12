From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 2/3] scsi: ufs: Add error checks for pm_runtime_get_sync()
Date: Tue, 12 Mar 2019 14:06:56 +0000
Message-ID: <SN6PR04MB49256D55A9EFCE6F0579BC3BFC490@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20190308083053.30631-1-rnayak@codeaurora.org>
 <20190308083053.30631-3-rnayak@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190308083053.30631-3-rnayak@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rajendra Nayak <rnayak@codeaurora.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "pedrom.Sousa@synopsys.com" <pedrom.Sousa@synopsys.com>
Cc: "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,
>=20
> Add an error check for pm_runtime_get_sync(), ignoring this can
> hide issues with the runtime pm handling in the driver.
Can you elaborate on those issues?
I guess you've encountered some during your bring-up.

>=20
> Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 2ddf24466a62..060dc38cc582 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8357,7 +8357,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>  	}
>=20
>  	/* Hold auto suspend until async scan completes */
> -	pm_runtime_get_sync(dev);
> +	err =3D pm_runtime_get_sync(dev);
> +	if (err < 0)
> +		goto out_remove_scsi_host;
> +
>  	atomic_set(&hba->scsi_block_reqs_cnt, 0);
>  	/*
>  	 * We are assuming that device wasn't put in sleep/power-down
On your first patch you are incrementing the device's usage counter,
To avoid any suspend during probe, but this comment above state
 some assumption of this very same issue.
Is it still valid?

Thanks,
Avri
