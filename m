From: Manish Rangankar <mrangankar@marvell.com>
Subject: RE: [PATCH 6/7] scsi: qlogic: no need to check return value of
 debugfs_create functions
Date: Wed, 23 Jan 2019 05:36:50 +0000
Message-ID: <BYAPR18MB2485661ACC93D549309BB720D8990@BYAPR18MB2485.namprd18.prod.outlook.com>
References: <20190122150906.12470-1-gregkh@linuxfoundation.org>
 <20190122150906.12470-7-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122150906.12470-7-gregkh@linuxfoundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Tuesday, January 22, 2019 8:39 PM
> To: James Bottomley <jejb@linux.ibm.com>; Martin Petersen
> <martin.petersen@oracle.com>
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Greg Kroah-
> Hartman <gregkh@linuxfoundation.org>; QLogic-Storage-
> Upstream@cavium.com
> Subject: [PATCH 6/7] scsi: qlogic: no need to check return value of
> debugfs_create functions
>=20
> External Email
>=20
> When calling debugfs functions, there is no need to ever check the return
> value.  The function can work or not, but the code logic should never do
> something different based on this.
>=20
> Cc: QLogic-Storage-Upstream@cavium.com
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/scsi/qedf/qedf_debugfs.c | 18 ++----------------
> drivers/scsi/qedi/qedi_debugfs.c | 17 ++---------------
>  2 files changed, 4 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/scsi/qedf/qedf_debugfs.c
> b/drivers/scsi/qedf/qedf_debugfs.c
> index c29c162a494f..a32d8ee4666e 100644
> --- a/drivers/scsi/qedf/qedf_debugfs.c
> +++ b/drivers/scsi/qedf/qedf_debugfs.c
> @@ -27,30 +27,19 @@ qedf_dbg_host_init(struct qedf_dbg_ctx *qedf,
>                     const struct file_operations *fops)  {
>         char host_dirname[32];
> -       struct dentry *file_dentry =3D NULL;
>=20
>         QEDF_INFO(qedf, QEDF_LOG_DEBUGFS, "Creating debugfs host
> node\n");
>         /* create pf dir */
>         sprintf(host_dirname, "host%u", qedf->host_no);
>         qedf->bdf_dentry =3D debugfs_create_dir(host_dirname,
> qedf_dbg_root);
> -       if (!qedf->bdf_dentry)
> -               return;
>=20
>         /* create debugfs files */
>         while (dops) {
>                 if (!(dops->name))
>                         break;
>=20
> -               file_dentry =3D debugfs_create_file(dops->name, 0600,
> -                                                 qedf->bdf_dentry, qedf,
> -                                                 fops);
> -               if (!file_dentry) {
> -                       QEDF_INFO(qedf, QEDF_LOG_DEBUGFS,
> -                                  "Debugfs entry %s creation failed\n",
> -                                  dops->name);
> -                       debugfs_remove_recursive(qedf->bdf_dentry);
> -                       return;
> -               }
> +               debugfs_create_file(dops->name, 0600, qedf->bdf_dentry, q=
edf,
> +                                   fops);
>                 dops++;
>                 fops++;
>         }
> @@ -80,9 +69,6 @@ qedf_dbg_init(char *drv_name)
>=20
>         /* create qed dir in root of debugfs. NULL means debugfs root */
>         qedf_dbg_root =3D debugfs_create_dir(drv_name, NULL);
> -       if (!qedf_dbg_root)
> -               QEDF_INFO(NULL, QEDF_LOG_DEBUGFS, "Init of debugfs "
> -                          "failed\n");
>  }
>=20
>  /**
> diff --git a/drivers/scsi/qedi/qedi_debugfs.c
> b/drivers/scsi/qedi/qedi_debugfs.c
> index fd914ca4149a..5667e4752e2e 100644
> --- a/drivers/scsi/qedi/qedi_debugfs.c
> +++ b/drivers/scsi/qedi/qedi_debugfs.c
> @@ -23,27 +23,16 @@ qedi_dbg_host_init(struct qedi_dbg_ctx *qedi,
>                    const struct file_operations *fops)  {
>         char host_dirname[32];
> -       struct dentry *file_dentry =3D NULL;
>=20
>         sprintf(host_dirname, "host%u", qedi->host_no);
>         qedi->bdf_dentry =3D debugfs_create_dir(host_dirname, qedi_dbg_ro=
ot);
> -       if (!qedi->bdf_dentry)
> -               return;
>=20
>         while (dops) {
>                 if (!(dops->name))
>                         break;
>=20
> -               file_dentry =3D debugfs_create_file(dops->name, 0600,
> -                                                 qedi->bdf_dentry, qedi,
> -                                                 fops);
> -               if (!file_dentry) {
> -                       QEDI_INFO(qedi, QEDI_LOG_DEBUGFS,
> -                                 "Debugfs entry %s creation failed\n",
> -                                 dops->name);
> -                       debugfs_remove_recursive(qedi->bdf_dentry);
> -                       return;
> -               }
> +               debugfs_create_file(dops->name, 0600, qedi->bdf_dentry, q=
edi,
> +                                   fops);
>                 dops++;
>                 fops++;
>         }
> @@ -60,8 +49,6 @@ void
>  qedi_dbg_init(char *drv_name)
>  {
>         qedi_dbg_root =3D debugfs_create_dir(drv_name, NULL);
> -       if (!qedi_dbg_root)
> -               QEDI_INFO(NULL, QEDI_LOG_DEBUGFS, "Init of debugfs failed=
\n");
>  }
>=20
>  void
> --
> 2.20.1

Thanks
Acked-by: Manish Rangankar <mrangankar@marvell.com>
