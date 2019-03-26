From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH] scsi: ufs: Fix to check the return value of
 alloc_ordered_workqueue
Date: Tue, 26 Mar 2019 14:17:35 +0000
Message-ID: <SN6PR04MB49251FBA9EFB10A277FD8C5EFC5F0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20190319175423.13724-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190319175423.13724-1-pakki001@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: "kjlu@umn.edu" <kjlu@umn.edu>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Subhash Jadavani <subhashj@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Bjorn Andersson <bjorn.andersson@linaro.org>, Ohad Sharabi <ohad.sharabi@wdc.com>, Vivek Gautam <vivek.gautam@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,
>=20
> In ufshcd_init_clk_gating, alloc_ordered_workqueue may fail and return
> NULL. The patch handles error consistent with other invocations in this
> module.
Not sure that's good enough, as later on we will try to queue work to that =
workqueue.

Thanks,
Avri


>=20
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e040f9dd9ff3..701b2da25f09 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1791,6 +1791,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba
> *hba)
>  		 hba->host->host_no);
>  	hba->clk_gating.clk_gating_workq =3D
> alloc_ordered_workqueue(wq_name,
>=20
> WQ_MEM_RECLAIM);
> +	if (!hba->clk_gating.clk_gating_workq)
> +		dev_err(hba->dev, "Failed to allocate work queue\n");
>=20
>  	hba->clk_gating.is_enabled =3D true;
>=20
> --
> 2.17.1
