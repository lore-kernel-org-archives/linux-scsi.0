From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: mvsas: fix misleading indentation
Date: Tue, 20 Oct 2015 09:46:54 +0200
Message-ID: <1445327214.16404.0.camel@suse.de>
References: <1445287000-1370-1-git-send-email-luisbg@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445287000-1370-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luis de Bethencourt <luisbg@osg.samsung.com>, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, hare@suse.de, tj@kernel.org, dan.j.williams@intel.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-10-19 at 21:36 +0100, Luis de Bethencourt wrote:
> Fix a smatch warning:
> drivers/scsi/mvsas/mv_sas.c:740 mvs_task_prep() warn: curly braces
> intended?
>=20
> The code is correct, the indention is misleading. When the device is
> not
> ready we want to return SAS_PHY_DOWN. But current indentation makes
> it
> look like we only do so in the else branch of if (mvi_dev).
>=20
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> ---
>=20
> Hi,
>=20
> The aim of this patch is to improve code readability, and at the same
> time
> silence the smatch warning.
>=20
> Thanks for the review,
> Luis
>=20
> =C2=A0drivers/scsi/mvsas/mv_sas.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mvsas/mv_sas.c
> b/drivers/scsi/mvsas/mv_sas.c
> index 454536c..b1c5dec 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -737,8 +737,8 @@ static int mvs_task_prep(struct sas_task *task,
> struct mvs_info *mvi, int is_tmf
> =C2=A0			mv_dprintk("device %016llx not ready.\n",
> =C2=A0				SAS_ADDR(dev->sas_addr));
> =C2=A0
> -			rc =3D SAS_PHY_DOWN;
> -			return rc;
> +		rc =3D SAS_PHY_DOWN;
> +		return rc;
> =C2=A0	}
> =C2=A0	tei.port =3D dev->port->lldd_port;
> =C2=A0	if (tei.port && !tei.port->port_attached && !tmf) {

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
