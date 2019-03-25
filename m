From: Manish Rangankar <mrangankar@marvell.com>
Subject: RE: [PATCH] scsi: qla4xxx: fix a potential NULL pointer dereference
Date: Mon, 25 Mar 2019 06:18:30 +0000
Message-ID: <BYAPR18MB24857ABD5DDE4D62E35F9C6DD85E0@BYAPR18MB2485.namprd18.prod.outlook.com>
References: <20190314063100.12805-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190314063100.12805-1-kjlu@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: "pakki001@umn.edu" <pakki001@umn.edu>, "QLogic-Storage-Upstream@qlogic.com" <QLogic-Storage-Upstream@qlogic.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-
> owner@vger.kernel.org> On Behalf Of Kangjie Lu
> Sent: Thursday, March 14, 2019 12:01 PM
> To: kjlu@umn.edu
> Cc: pakki001@umn.edu; QLogic-Storage-Upstream@qlogic.com; James E.J.
> Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] scsi: qla4xxx: fix a potential NULL pointer dereference
>=20
> In case iscsi_lookup_endpoint fails, the fix returns -EINVAL to avoid NUL=
L
> pointer dereference.
>=20
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c
> index a77bfb224248..80289c885c07 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -3203,6 +3203,8 @@ static int qla4xxx_conn_bind(struct
> iscsi_cls_session *cls_session,
>  	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
>  		return -EINVAL;
>  	ep =3D iscsi_lookup_endpoint(transport_fd);
> +	if (!ep)
> +		return -EINVAL;
>  	conn =3D cls_conn->dd_data;
>  	qla_conn =3D conn->dd_data;
>  	qla_conn->qla_ep =3D ep->dd_data;
> --
> 2.17.1

Thanks
Acked-by: Manish Rangankar <mrangankar@marvell.com>
