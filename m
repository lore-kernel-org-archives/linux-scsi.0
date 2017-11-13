From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] scsi: bnx2i: bnx2i_hwi: use swap macro in
 bnx2i_send_iscsi_nopout
Date: Mon, 13 Nov 2017 08:33:42 +0000
Message-ID: <D62F5647.43759%manish.rangankar@cavium.com>
References: <20171103195839.GA23385@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171103195839.GA23385@embeddedor.com>
Content-Language: en-US
Content-ID: <706E1877EA3D0445902206FD5CB865D8@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 04/11/17 1:28 AM, "Gustavo A. R. Silva" <garsilva@embeddedor.com> wrote:

>Make use of the swap macro and remove unnecessary variable tmp.
>This makes the code easier to read and maintain.
>
>This code was detected with the help of Coccinelle.
>
>Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>---
> drivers/scsi/bnx2i/bnx2i_hwi.c | 9 +++------
> 1 file changed, 3 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c
>b/drivers/scsi/bnx2i/bnx2i_hwi.c
>index e0640e0..9e3bf53 100644
>--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
>+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
>@@ -547,12 +547,9 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn
>*bnx2i_conn,
> 	nopout_wqe->op_attr =3D ISCSI_FLAG_CMD_FINAL;
> 	memcpy(nopout_wqe->lun, &nopout_hdr->lun, 8);
>=20
>-	if (test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type)) {
>-		u32 tmp =3D nopout_wqe->lun[0];
>-		/* 57710 requires LUN field to be swapped */
>-		nopout_wqe->lun[0] =3D nopout_wqe->lun[1];
>-		nopout_wqe->lun[1] =3D tmp;
>-	}
>+	/* 57710 requires LUN field to be swapped */
>+	if (test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type))
>+		swap(nopout_wqe->lun[0], nopout_wqe->lun[1]);
>=20
> 	nopout_wqe->itt =3D ((u16)task->itt |
> 			   (ISCSI_TASK_TYPE_MPATH <<
>--=20
>2.7.4

Thanks,

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>

>
