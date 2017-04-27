From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: target: fixup error message in
 target_tg_pt_gp_tg_pt_gp_id_store()
Date: Thu, 27 Apr 2017 16:17:09 +0000
Message-ID: <1493309828.2625.8.camel@sandisk.com>
References: <1493302638-113622-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4263 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939262AbdD0QRY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2017 12:17:24 -0400
In-Reply-To: <1493302638-113622-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <410D832FCEEE194C8BB07923E9692E25@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "nab@daterainc.com" <nab@daterainc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

On Thu, 2017-04-27 at 16:17 +0200, Hannes Reinecke wrote:
> When setting up an ALUA target port group with an invalid ID the
> error message
>=20
> kstrtoul() returned -22 for tg_pt_gp_id
>=20
> is displayed, which is not really helpful.
> Convert it to something sane.
>=20
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Did you perhaps mean "Signed-off-by"?

>  drivers/target/target_core_configfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
> index 1f229cc..27f7411 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -2691,8 +2691,8 @@ static ssize_t target_tg_pt_gp_tg_pt_gp_id_store(st=
ruct config_item *item,
> =20
>  	ret =3D kstrtoul(page, 0, &tg_pt_gp_id);
>  	if (ret < 0) {
> -		pr_err("kstrtoul() returned %d for"
> -			" tg_pt_gp_id\n", ret);
> +		pr_err("ALUA tg_pt_gp_id: invalid value '%s' for"
> +			" tg_pt_gp_id\n", page);
>  		return ret;
>  	}
>  	if (tg_pt_gp_id > 0x0000ffff) {

Although this patch looks fine to me, this would have been a good opportuni=
ty
to join the two parts of the error message such that these appear on the sa=
me
source code line.

Bart.=
