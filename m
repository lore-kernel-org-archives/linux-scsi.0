From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH] scsi: ufs: Check for return value of
 create_singlethread_workqueue
Date: Tue, 26 Mar 2019 14:46:45 +0000
Message-ID: <SN6PR04MB4925D262CF042EAE14E38F59FC5F0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20190319034732.19559-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190319034732.19559-1-pakki001@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: "kjlu@umn.edu" <kjlu@umn.edu>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Subhash Jadavani <subhashj@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Bjorn Andersson <bjorn.andersson@linaro.org>, Ohad Sharabi <ohad.sharabi@wdc.com>, Vivek Gautam <vivek.gautam@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

HI,
>=20
> In case create_singlethread_workqueue fails in ufshcd_init_scaling, the
> patch returns the error upstream.
>=20
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---


>  out_remove_scsi_host:
>  	scsi_remove_host(hba->host);
> -exit_gating:
> +exit_scaling:
>  	ufshcd_exit_clk_scaling(hba);
> +exit_gating:
>  	ufshcd_exit_clk_gating(hba);
There are calls to exit_gating which expects clk_scaling cleanup as well.

Thanks,
Avri

>  out_disable:
>  	hba->is_irq_enabled =3D false;
> --
> 2.17.1
