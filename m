From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH][scsi-next] scsi: qla2xxx: remove redundant null check on
 tgt
Date: Wed, 7 Jun 2017 22:42:03 +0000
Message-ID: <BF3F11EE-4110-49BE-8117-1F6205D86DB3@cavium.com>
References: <20170605172958.12844-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170605172958.12844-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <75B6FCE620540E4892012EEAE4AB9C81@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Jun 5, 2017, at 10:29 AM, Colin King <colin.king@canonical.com> wrote:
>=20
> From: Colin Ian King <colin.king@canonical.com>
>=20
> An earlier commit ed7fb808477b846bb2 ("scsi: qla2xxx: Remove
> redundant wait when target is stopped.") removed a null check
> on ha->tgt.tgt_ops and replaced it with a new check that null
> checked tgt, thus making the subsequent null check on tgt
> totally redundant. Remove it.
>=20
> Detected by CoverityScan, CID#1440452 ("Logically Dead Code")
>=20
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> drivers/scsi/qla2xxx/qla_target.c | 6 ------
> 1 file changed, 6 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index cb33ca87ca37..3594a76f6155 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -5519,12 +5519,6 @@ void qlt_async_event(uint16_t code, struct scsi_ql=
a_host *vha,
> 	if (!tgt || tgt->tgt_stop || tgt->tgt_stopped)
> 		return;
>=20
> -	if (unlikely(tgt =3D=3D NULL)) {
> -		ql_dbg(ql_dbg_tgt, vha, 0xe03a,
> -		    "ASYNC EVENT %#x, but no tgt (ha %p)\n", code, ha);
> -		return;
> -	}
> -
> 	if (((code =3D=3D MBA_POINT_TO_POINT) || (code =3D=3D MBA_CHG_IN_CONNECT=
ION)) &&
> 	    IS_QLA2100(ha))
> 		return;
> --=20
> 2.11.0
>=20

Looks good.

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
