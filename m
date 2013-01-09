From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: initialize sense_reason_t ret in
 core_scsi3_emulate_pro_register()
Date: Tue, 08 Jan 2013 17:51:26 -0800
Message-ID: <1357696286.5660.36.camel@haakon2.linux-iscsi.org>
References: <y>  <1356210957-30089-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1356210957-30089-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi Geert,

Apologies for the delay on this one.  Still catching up on some older
holiday items..

On Sat, 2012-12-22 at 22:15 +0100, Geert Uytterhoeven wrote:
> drivers/target/target_core_pr.c: In function =E2=80=98core_scsi3_emul=
ate_pro_register=E2=80=99:
> drivers/target/target_core_pr.c:2056: warning: =E2=80=98ret=E2=80=99 =
may be used uninitialized in this function
>=20
> If !spec_i_pt, the "goto out_put_pr_reg" on line 2141 seems to be a r=
eal
> case where ret is not initialized.
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/target/target_core_pr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_=
core_pr.c
> index e35dbf8..c2e8026 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -2053,7 +2053,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *=
cmd, u64 res_key, u64 sa_res_key,
>  	/* Used for APTPL metadata w/ UNREGISTER */
>  	unsigned char *pr_aptpl_buf =3D NULL;
>  	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr =3D NULL;
> -	sense_reason_t ret;
> +	sense_reason_t ret =3D 0;
>  	int pr_holder =3D 0, type;
> =20
>  	if (!se_sess || !se_lun) {

Looks fine, applied to target-pending/master.

Thank you,

--nab
