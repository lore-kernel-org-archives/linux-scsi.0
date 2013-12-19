From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/4] drivers: target: Mark functions as static in
 tcm_loop.c
Date: Wed, 18 Dec 2013 16:11:57 -0800
Message-ID: <1387411917.5567.10.camel@haakon3.risingtidesystems.com>
References: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
	 <6d957ed9181ac274d13385db204db100b0ef8416.1387390091.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <6d957ed9181ac274d13385db204db100b0ef8416.1387390091.git.rashika.kheria@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Joern Engel <joern@logfs.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-12-19 at 00:02 +0530, Rashika Kheria wrote:
> Mark functions tcm_loop_make_naa_tpg(), tcm_loop_drop_naa_tpg(),
> tcm_loop_make_scsi_hba() and tcm_loop_drop_scsi_hba() as static in
> loopback/tcm_loop.c because they are not used outside this file.
>=20
> This eliminates the following warning in loopback/tcm_loop.c:
> drivers/target/loopback/tcm_loop.c:1231:25: warning: no previous prot=
otype for =E2=80=98tcm_loop_make_naa_tpg=E2=80=99 [-Wmissing-prototypes=
]
> drivers/target/loopback/tcm_loop.c:1276:6: warning: no previous proto=
type for =E2=80=98tcm_loop_drop_naa_tpg=E2=80=99 [-Wmissing-prototypes]
> drivers/target/loopback/tcm_loop.c:1308:16: warning: no previous prot=
otype for =E2=80=98tcm_loop_make_scsi_hba=E2=80=99 [-Wmissing-prototype=
s]
> drivers/target/loopback/tcm_loop.c:1378:6: warning: no previous proto=
type for =E2=80=98tcm_loop_drop_scsi_hba=E2=80=99 [-Wmissing-prototypes=
]
>=20
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
>  drivers/target/loopback/tcm_loop.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20

Applied to target-pending/for-next.

--nab

> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loop=
back/tcm_loop.c
> index 1b41e67..763ee45 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -1228,7 +1228,7 @@ static struct configfs_attribute *tcm_loop_tpg_=
attrs[] =3D {
> =20
>  /* Start items for tcm_loop_naa_cit */
> =20
> -struct se_portal_group *tcm_loop_make_naa_tpg(
> +static struct se_portal_group *tcm_loop_make_naa_tpg(
>  	struct se_wwn *wwn,
>  	struct config_group *group,
>  	const char *name)
> @@ -1273,7 +1273,7 @@ struct se_portal_group *tcm_loop_make_naa_tpg(
>  	return &tl_tpg->tl_se_tpg;
>  }
> =20
> -void tcm_loop_drop_naa_tpg(
> +static void tcm_loop_drop_naa_tpg(
>  	struct se_portal_group *se_tpg)
>  {
>  	struct se_wwn *wwn =3D se_tpg->se_tpg_wwn;
> @@ -1305,7 +1305,7 @@ void tcm_loop_drop_naa_tpg(
> =20
>  /* Start items for tcm_loop_cit */
> =20
> -struct se_wwn *tcm_loop_make_scsi_hba(
> +static struct se_wwn *tcm_loop_make_scsi_hba(
>  	struct target_fabric_configfs *tf,
>  	struct config_group *group,
>  	const char *name)
> @@ -1375,7 +1375,7 @@ out:
>  	return ERR_PTR(ret);
>  }
> =20
> -void tcm_loop_drop_scsi_hba(
> +static void tcm_loop_drop_scsi_hba(
>  	struct se_wwn *wwn)
>  {
>  	struct tcm_loop_hba *tl_hba =3D container_of(wwn,
