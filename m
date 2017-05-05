From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: qedf: Avoid reading past end of buffer
Date: Fri, 5 May 2017 23:01:04 +0000
Message-ID: <1494025263.2744.22.camel@sandisk.com>
References: <20170505224255.GA21521@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170505224255.GA21521@beast>
Content-Language: en-US
Content-ID: <75B1B52B3E3AA14F9DAD24C86B5B7299@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "keescook@chromium.org" <keescook@chromium.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>, "danielmicay@gmail.com" <danielmicay@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-05-05 at 15:42 -0700, Kees Cook wrote:
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
> index cceddd995a4b..a5c97342fd5d 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -2895,7 +2895,7 @@ static int __qedf_probe(struct pci_dev *pdev, int m=
ode)
>  	slowpath_params.drv_minor =3D QEDF_DRIVER_MINOR_VER;
>  	slowpath_params.drv_rev =3D QEDF_DRIVER_REV_VER;
>  	slowpath_params.drv_eng =3D QEDF_DRIVER_ENG_VER;
> -	memcpy(slowpath_params.name, "qedf", QED_DRV_VER_STR_SIZE);
> +	strncpy(slowpath_params.name, "qedf", QED_DRV_VER_STR_SIZE);
>  	rc =3D qed_ops->common->slowpath_start(qedf->cdev, &slowpath_params);
>  	if (rc) {
>  		QEDF_ERR(&(qedf->dbg_ctx), "Cannot start slowpath.\n");

Hello Kees,

Although this patch looks fine to me, isn't strlcpy() preferred over strncp=
y()?

Bart.=
